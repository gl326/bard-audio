function __ElephantReadInner_v4(_buffer, _datatype)
{
    if (_datatype == buffer_array)
    {
        var _length = buffer_read(_buffer, buffer_u16);
        
        //Special value indicating that this is a reference to an array we've seen before
        if (_length == 0xFFFF)
        {
            var _foundIndex = buffer_read(_buffer, buffer_u16);
            return global.__elephantFound[? _foundIndex];
        }
        else
        {
            var _array = array_create(_length);
            
            //Adds this array to ourlook-up table using a unique index
            //If we read a reference to this array in the future then we grab it out of this look-up table
            global.__elephantFound[? global.__elephantFoundCount] = _array;
            global.__elephantFoundCount++;
            
            if (_length > 0)
            {
                var _common_datatype = buffer_read(_buffer, buffer_u8);
                var _i = 0;
                repeat(_length)
                {
                    _array[@ _i] = global.__elephantReadFunction(_buffer, _common_datatype);
                    ++_i;
                }
            }
            
            return _array;
        }
    }
    else if (_datatype == buffer_struct)
    {
        var _length = buffer_read(_buffer, buffer_u16);
        
        //Special value indicating that this is a reference to a struct we've seen before
        if (_length == 0xFFFF)
        {
            var _foundIndex = buffer_read(_buffer, buffer_u16);
            return global.__elephantFound[? _foundIndex];
        }
        else if (_length == 0xFFFE) //Special value indicating that this is a struct created by a constructor
        {
            var _constructorIndex = buffer_read(_buffer, buffer_u16);
            
            var _instanceof = global.__elephantConstructorIndexes[$ _constructorIndex];
            if (_instanceof == undefined)
            {
                _instanceof = buffer_read(_buffer, buffer_string);
                global.__elephantConstructorIndexes[$ _constructorIndex] = _instanceof;
                global.__elephantConstructorNextIndex++;
            }
            
            var _constructorFunction = asset_get_index(_instanceof);
            if (is_method(_constructorFunction))
            {
                //Is a method
                var _struct = new _constructorFunction();
            }
            else if (is_numeric(_constructorFunction) && script_exists(_constructorFunction))
            {
                //Is a script
                var _struct = new _constructorFunction();
            }
            else
            {
                __ElephantError("Could not resolve constructor function \"", _instanceof, "\"");
            }
            
            //Read out the schema version used to serialize this struct and whether it was stored verbosely
            var _version_and_verbose = buffer_read(_buffer, buffer_u8);
            var _verbose = (_version_and_verbose >> 7);
            var _version = (_version_and_verbose & 0x7F);
            
            //Adds this struct to ourlook-up table using a unique index
            //If we read a reference to this struct in the future then we grab it out of this look-up table
            global.__elephantFound[? global.__elephantFoundCount] = _struct;
            global.__elephantFoundCount++;
            
            ds_list_add(global.__elephantPostReadCallbackOrder,   _struct );
            ds_list_add(global.__elephantPostReadCallbackVersion, _version);
            
            //Execute the pre-read callback if we can
            ELEPHANT_SCHEMA_VERSION = _version;
            var _callback = _struct[$ __ELEPHANT_PRE_READ_METHOD_NAME];
            if (is_method(_callback)) method(_struct, _callback)();
            
            if (_verbose)
            {
                var _length = buffer_read(_buffer, buffer_u16);
                var _i = 0;
                repeat(_length)
                {
                    var _name = buffer_read(_buffer, buffer_string);
                    _struct[$ _name] = global.__elephantReadFunction(_buffer, buffer_any);
                    ++_i;
                }
            }
            else
            {
                var _elephantSchemas = _struct[$ __ELEPHANT_SCHEMA_NAME];
                if (is_struct(_elephantSchemas))
                {
                    var _schema = _elephantSchemas[$ "v" + string(_version)];
                    if (is_struct(_schema))
                    {
                        //Get variables names, and alphabetize them so that they match the order that they were serialized
                        var _names = variable_struct_get_names(_schema);
                        array_sort(_names, true);
                        
                        //Iterate over the variable names and read them
                        var _i = 0;
                        repeat(array_length(_names))
                        {
                            var _name = _names[_i];
                            _struct[$ _name] = global.__elephantReadFunction(_buffer, _schema[$ _name]);
                            ++_i;
                        }
                    }
                    else
                    {
                        __ElephantError("No Elephant \"v", _version, "\" schema found for constructor \"", _instanceof, "\"");
                    }
                }
                else
                {
                    __ElephantError("No Elephant schema found for constructor \"", _instanceof, "\", but a schema is required for importing");
                }
            }
            
            return _struct;
        }
        else
        {
            //If length isn't 0xFFFF or 0xFFFE then it's a generic struct
            var _struct = {};
            
            //Adds this struct to ourlook-up table using a unique index
            //If we read a reference to this struct in the future then we grab it out of this look-up table
            global.__elephantFound[? global.__elephantFoundCount] = _struct;
            global.__elephantFoundCount++;
            
            var _i = 0;
            repeat(_length)
            {
                var _name = buffer_read(_buffer, buffer_string);
                _struct[$ _name] = global.__elephantReadFunction(_buffer, buffer_any);
                ++_i;
            }
            
            return _struct;
        }
    }
    else if (_datatype == buffer_any)
    {
        _datatype = buffer_read(_buffer, buffer_u8);
        return global.__elephantReadFunction(_buffer,_datatype);
    }
    else if (_datatype == buffer_undefined)
    {
        return undefined;
    }
    else
    {
        if (_datatype == buffer_text) _datatype = buffer_string;
        return buffer_read(_buffer, _datatype);
    }
}