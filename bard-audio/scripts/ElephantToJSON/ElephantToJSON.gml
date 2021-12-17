/// Makes a copy of a struct/array JSON, respecting Elephant schemas, circular references, and constructors.
/// 
/// @return Struct/array JSON
/// 
/// @param target  Data to serialize

function ElephantToJSON(_target)
{
    global.__elephantFound      = ds_map_create();
    global.__elephantFoundCount = 0;
    
    ELEPHANT_IS_DESERIALIZING = false;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    var _duplicate = __ElephantToJSONInner(_target);
    
    ds_map_destroy(global.__elephantFound);
    
    ELEPHANT_IS_DESERIALIZING = undefined;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    return _duplicate;
}

function __ElephantToJSONInner(_target)
{
    if (is_struct(_target))
    {
        var _duplicate = {};
        
        var _circularRef = global.__elephantFound[? _target];
        if (_circularRef != undefined)
        {
            _duplicate[$ __ELEPHANT_JSON_CIRCULAR_REF] = _circularRef;
        }
        else
        {
            global.__elephantFound[? _target] = global.__elephantFoundCount;
            global.__elephantFoundCount++;
            
            var _instanceof = instanceof(_target);
            if (_instanceof == "struct")
            {
                var _names = variable_struct_get_names(_target);
                var _verbose = true;
            }
            else
            {
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
                
                //Record the constructor and version
                _duplicate[$ __ELEPHANT_JSON_CONSTRUCTOR   ] = _instanceof;
                _duplicate[$ __ELEPHANT_JSON_SCHEMA_VERSION] = _latestVersion;
                
                //Execute the pre-write callback if we can
                ELEPHANT_SCHEMA_VERSION = _latestVersion;
                var _callback = _target[$ __ELEPHANT_PRE_WRITE_METHOD_NAME];
                if (is_method(_callback)) method(_target, _callback)();
                
                if (_verbose) __ElephantRemoveExcludedVariables(_names, _elephantSchemas);
            }
            
            //Sort the names alphabetically
            //This is important for serializing circular references so that the indexes are always created in the same order
            array_sort(_names, true);
            
            //Write the relevant data to the JSON
            var _length = array_length(_names);
            var _i = 0;
            repeat(_length)
            {
                var _name = _names[_i];
                _duplicate[$ _name] = __ElephantToJSONInner(_target[$ _name]);
                ++_i;
            }
            
            if (_instanceof != "struct")
            {
                //Execute the post-write callback if we can
                ELEPHANT_SCHEMA_VERSION = _latestVersion;
                var _callback = _target[$ __ELEPHANT_POST_WRITE_METHOD_NAME];
                if (is_method(_callback)) method(_target, _callback)();
            }
        }
        
        return _duplicate;
    }
    else if (is_array(_target))
    {
        var _circularRef = global.__elephantFound[? _target];
        if (_circularRef != undefined)
        {
            var _duplicate = {};
            _duplicate[$ __ELEPHANT_JSON_CIRCULAR_REF] = _circularRef;
        }
        else
        {
            global.__elephantFound[? _target] = ds_map_size(global.__elephantFound);
            
            var _length = array_length(_target);
            var _duplicate = array_create(_length);
            var _i = 0;
            repeat(_length)
            {
                _duplicate[@ _i] = __ElephantToJSONInner(_target[_i]);
                ++_i;
            }
        }
        
        return _duplicate;
    }
    else
    {
        return _target;
    }
}