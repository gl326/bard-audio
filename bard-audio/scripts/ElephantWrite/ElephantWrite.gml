/// Serializes the given target data and writes it to the given buffer, starting at the buffer_tell() position.
/// This function uses buffer_write() and will move the buffer head as it writes. If no buffer is provided then
/// a new buffer is created that fits the serialized data. This function calls ELEPHANT_PRE_WRITE_METHOD and
/// ELEPHANT_POST_WRITE_METHOD for constructed structs, and ELEPHANT_IS_DESERIALIZING is set to <false>.
/// ELEPHANT_SCHEMA_VERSION will contain the constructor schema version that Elephant is using to serialize data.
/// 
/// @return  Buffer, either the buffer passed into the function or a buffer the function created itself
/// 
/// @param target    Data to serialize
/// @param [buffer]  Optional, the buffer to write to. If no buffer is provided then one is created automatically

function ElephantWrite()
{
    var _target = argument[0];
    var _buffer = (argument_count > 1)? argument[1] : undefined;
    
    if (_buffer == undefined)
    {
        _buffer = buffer_create(1024, buffer_grow, 1);
        var _resize_buffer = true; //Also resize the buffer if we've generated our own
    }
    else
    {
        var _resize_buffer = false;
    }
    
    global.__elephantConstructorNextIndex = 0;
    global.__elephantConstructorIndexes   = {};
    
    global.__elephantFound      = ds_map_create();
    global.__elephantFoundCount = 0;
    
    ELEPHANT_IS_DESERIALIZING = false;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    //Do serialization here
    buffer_write(_buffer, buffer_u32, __ELEPHANT_HEADER);
    buffer_write(_buffer, buffer_u32, __ELEPHANT_BYTE_VERSION);
    __ElephantBufferInner(_buffer, _target, buffer_any);
    buffer_write(_buffer, buffer_u32, __ELEPHANT_FOOTER);
    
    if (_resize_buffer)
    {
        buffer_resize(_buffer, buffer_tell(_buffer));
    }
    
    //Make sure we clear references to 
    ds_map_destroy(global.__elephantFound);
    
    ELEPHANT_IS_DESERIALIZING = undefined;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    return _buffer;
}

function __ElephantBufferInner(_buffer, _target, _datatype)
{
    if (_datatype == buffer_array)
    {
        if (!is_array(_target)) __ElephantError("Target isn't an array");
        
        //Check to see if we've seen this array before
        var _foundIndex = global.__elephantFound[? _target];
        if (is_numeric(_foundIndex))
        {
            //Write a special length here to indicate we're going to use a previously-created reference
            buffer_write(_buffer, buffer_u16, 0xFFFF);
            
            //Followed by the index of the found data structure
            buffer_write(_buffer, buffer_u16, _foundIndex);
        }
        else
        {
            var _length = array_length(_target);
            if (_length >= 0xFFFF)
            {
                __ElephantError("Array length must be less than 65535 (was ", _length, ")");
            }
            else
            {
                //Adds this array to our already-written struct using a unique index
                //If we need to store a reference to this array in the future then we use this index instead
                global.__elephantFound[? _target] = global.__elephantFoundCount;
                global.__elephantFoundCount++;
                
                //Write the length of the array
                buffer_write(_buffer, buffer_u16, _length);
                
                if (array_length(_target) > 0)
                {
                    //Discover a common datatype
                    //If no common datatype can be found, we use buffer_any
                    var _common = undefined;
                    var _i = 0;
                    repeat(array_length(_target))
                    {
                        _datatype = __ElephantValueToDatatype(_target[_i]);
                        if (_common == undefined)
                        {
                            _common = _datatype;
                        }
                        else if (_common != _datatype)
                        {
                            _common = buffer_any;
                            break;
                        }
                        
                        ++_i;
                    }
                    
                    //Write the found common datatype, even if it's buffer_any
                    buffer_write(_buffer, buffer_u8, _common);
                    
                    //Write the contents of the array using the common datatype
                    var _i = 0;
                    repeat(array_length(_target))
                    {
                        __ElephantBufferInner(_buffer, _target[_i], _common);
                        ++_i;
                    }
                }
            }
        }
    }
    else if (_datatype == buffer_struct)
    {
        if (!is_struct(_target)) __ElephantError("Target isn't a struct");
        
        //Check to see if we've seen this struct before
        var _foundIndex = global.__elephantFound[? _target];
        if (is_numeric(_foundIndex))
        {
            //Write a special length here to indicate we're going to use a previously-created reference
            buffer_write(_buffer, buffer_u16, 0xFFFF);
            
            //Followed by the index of the found data structure
            buffer_write(_buffer, buffer_u16, _foundIndex);
        }
        else
        {
            //Adds this struct to our already-written struct using a unique index
            //If we need to store a reference to this struct in the future then we use this index instead
            global.__elephantFound[? _target] = global.__elephantFoundCount;
            global.__elephantFoundCount++;
            
            //Check to see if this is a normal struct
            var _instanceof = instanceof(_target);
            if (_instanceof == "struct")
            {
                //...if so, we want to serialize all variables for this struct (using buffer_any)
                var _names = variable_struct_get_names(_target);
                var _length = array_length(_names);
                
                //Check the length. We use the length property of structs to communicate two special bits of data
                //  length = 0xFFFF = Seen this struct before, use that reference
                //  length = OcFFFE = Struct was instantiated using a constructor
                //Therefore we cannot allow those lengths for structs
                if (_length >= 0xFFFE)
                {
                    __ElephantError("Structs must contain fewer than 65534 member variables (was ", _length, ")");
                }
                else
                {
                    buffer_write(_buffer, buffer_u16, _length);
                    
                    var _i = 0;
                    repeat(array_length(_names))
                    {
                        var _name = _names[_i];
                        
                        buffer_write(_buffer, buffer_string, _name);
                        __ElephantBufferInner(_buffer, _target[$ _name], buffer_any);
                        
                        ++_i;
                    }
                }
            }
            else
            {
                //The struct's instanceof indicates this has been instantiated using a constructor
                //Let's write a special value to communicate that to the deserializer
                buffer_write(_buffer, buffer_u16, 0xFFFE);
                
                //Try to find a datatype index for this constructor
                var _index = global.__elephantConstructorIndexes[$ _instanceof];
                if (_index != undefined)
                {
                    buffer_write(_buffer, buffer_u16, _index);
                }
                else
                {
                    //If we can't find one, return a new index
                    //We handle what to do with a new index when we run __ElephantBufferInner() again
                    _index = global.__elephantConstructorNextIndex;
                    global.__elephantConstructorNextIndex++;
                    global.__elephantConstructorIndexes[$ _instanceof] = _index;
                    
                    //Write our new index and which constructor this maps to
                    buffer_write(_buffer, buffer_u16, _index);
                    buffer_write(_buffer, buffer_string, _instanceof); //TODO - Hash this? Make sure to use a salt too
                }
                
                var _elephantSchemas = _target[$ __ELEPHANT_SCHEMA_NAME];
                
                //Discover the latest schema version
                var _latestVersion = __ElephantConstructorFindLatestVersion(_elephantSchemas);
                if (_latestVersion > 0)
                {
                    //Get the appropriate schema
                    var _schema = _elephantSchemas[$ "v" + string(_latestVersion)];
                    var _names = variable_struct_get_names(_schema);
                    
                    var _verbose = false;
                    if (variable_struct_exists(_schema, __ELEPHANT_VERSION_VERBOSE_NAME)) _verbose = _schema[$ __ELEPHANT_VERSION_VERBOSE_NAME];
                }
                else
                {
                    var _names = variable_struct_get_names(_target);
                    var _verbose = true;
                }
                
                //Write the latest version and whether we're in verbose mode
                buffer_write(_buffer, buffer_u8, (_verbose << 7) | (_latestVersion & 0x7F));
                
                //Execute the pre-write callback if we can
                ELEPHANT_SCHEMA_VERSION = _latestVersion;
                var _callback = _target[$ __ELEPHANT_PRE_WRITE_METHOD_NAME];
                if (is_method(_callback)) method(_target, _callback)();
        
                if (_verbose)
                {
                    //There's no specific serialization information so we write this constructor as a generic struct
                    __ElephantRemoveExcludedVariables(_names, _elephantSchemas);
                    
                    //Write the length (after excluding variables)
                    var _length = array_length(_names);
                    buffer_write(_buffer, buffer_u16, _length);
                    
                    //Now do the writing!
                    var _i = 0;
                    repeat(_length)
                    {
                        var _name = _names[_i];
                        buffer_write(_buffer, buffer_string, _name);
                        __ElephantBufferInner(_buffer, _target[$ _name], buffer_any);
                        
                        ++_i;
                    }
                }
                else
                {
                    //Alphabetize the variables names so that they'll match the order that they will be deserialized
                    array_sort(_names, true);
            
                    //Iterate over the serializable variable names and write them
                    var _i = 0;
                    repeat(array_length(_names))
                    {
                        var _name = _names[_i];
                        __ElephantBufferInner(_buffer, _target[$ _name], _schema[$ _name]);
                        ++_i;
                    }
                }
                
                //Execute the post-write callback if we can
                ELEPHANT_SCHEMA_VERSION = _latestVersion;
                var _callback = _target[$ __ELEPHANT_POST_WRITE_METHOD_NAME];
                if (is_method(_callback)) method(_target, _callback)();
            }
        }
    }
    else if (_datatype == buffer_any)
    {
        _datatype = __ElephantValueToDatatype(_target);
        buffer_write(_buffer, buffer_u8, _datatype);
        __ElephantBufferInner(_buffer, _target, _datatype);
    }
    else if (_datatype == buffer_undefined)
    {
        //Don't need to write anything for <undefined> values
    }
    else
    {
        if (_datatype == buffer_text) _datatype = buffer_string;
        buffer_write(_buffer, _datatype, _target);
    }
}