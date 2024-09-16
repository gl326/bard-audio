/// Makes a copy of the target. Like ElephantWrite() and ElephantRead(), this function obeys schemas.
/// If you'd like to copy all (non-static) member variables then set forceVerbose to <true>
/// Regardless, this function will recreate constructed structs appropriately and will also correctly
/// duplicate circular references.
/// 
/// @return  A copy of the target data
/// 
/// @param target           Data to duplicate
/// @param [forceVerbose]   Optional, whether to force verbose duplication for structs. Defaults to <false>

function ElephantDuplicate()
{
    var _target = argument[0];
    global.__elephantForceVerbose = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : false;
    
    global.__elephantFoundDuplicate = ds_map_create();
    
    global.__elephantPostDuplicateCallbackOrder   = ds_list_create();
    global.__elephantPostDuplicateCallbackVersion = ds_list_create();
    
    ELEPHANT_IS_DESERIALIZING = false;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    var _result = __ElephantDuplicateInner(_target, buffer_any);
    
    ELEPHANT_IS_DESERIALIZING = true;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    var _i = 0;
    repeat(ds_list_size(global.__elephantPostDuplicateCallbackOrder))
    {
        with(global.__elephantPostDuplicateCallbackOrder[| _i])
        {
            //Execute the post-read callback if we can
            if (variable_struct_exists(self, __ELEPHANT_POST_READ_METHOD_NAME))
            {
                ELEPHANT_SCHEMA_VERSION = global.__elephantPostDuplicateCallbackVersion[| _i];
                self[$ __ELEPHANT_POST_READ_METHOD_NAME]();
            }
        }
        
        ++_i;
    }
    
    ds_map_destroy(global.__elephantFoundDuplicate);
    ds_list_destroy(global.__elephantPostDuplicateCallbackOrder);
    ds_list_destroy(global.__elephantPostDuplicateCallbackVersion);
    
    ELEPHANT_IS_DESERIALIZING = undefined;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    global.__elephantForceVerbose = false;
    
    return _result;
}

function __ElephantDuplicateInner(_target, _datatype)
{
    if (_datatype == buffer_array)
    {
        if (!is_array(_target)) __ElephantError("Target isn't an array: "+string(_target));
        
        //Check to see if we've seen this array before
        var _foundCopy = global.__elephantFoundDuplicate[? _target];
        if (is_array(_foundCopy))
        {
            return _foundCopy;
        }
        else
        {
            var _length = array_length(_target);
            
            var _copy = array_create(_length);
            global.__elephantFoundDuplicate[? _target] = _copy;
            
            var _i = 0;
            repeat(_length)
            {
                _copy[@ _i] = __ElephantDuplicateInner(_target[_i], buffer_any);
                ++_i;
            }
            
            return _copy;
        }
    }
    else if (_datatype == buffer_struct)
    {
        if (!is_struct(_target)) __ElephantError("Target isn't a struct: "+string(_target));
        
        //Check to see if we've seen this struct before
        var _foundCopy = global.__elephantFoundDuplicate[? _target];
        if (is_struct(_foundCopy))
        {
            return _foundCopy;
        }
        else
        {
            //Check to see if this is a normal struct
            var _instanceof = instanceof(_target);
            if _INSTANCEOF_STRUCT
            {
                var _copy = {};
                global.__elephantFoundDuplicate[? _target] = _copy;
                
                var _names = variable_struct_get_names(_target);
                var _i = 0;
                repeat(array_length(_names))
                {
                    var _name = _names[_i];
                    _copy[$ _name] = __ElephantDuplicateInner(_target[$ _name], buffer_any);
                    ++_i;
                }
            }
            else
            {
                var _constructorFunction = asset_get_index(_instanceof);
                if (is_method(_constructorFunction))
                {
                    //Is a method
                    var _copy = new _constructorFunction();
                }
                else if (is_numeric(_constructorFunction) && script_exists(_constructorFunction))
                {
                    //Is a script
                    var _copy = new _constructorFunction();
                }
                else
                {
                    __ElephantError("Could not resolve constructor function \"", _instanceof, "\"");
                }
                
                global.__elephantFoundDuplicate[? _target] = _copy;
                
                //Discover the latest schema version
                var _elephantSchemas = _target[$ __ELEPHANT_SCHEMA_NAME];
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
                
                //Execute the pre-write callback if we can
                ELEPHANT_SCHEMA_VERSION = _latestVersion;
                var _callback = _target[$ __ELEPHANT_PRE_WRITE_METHOD_NAME];
                if (is_method(_callback)) method(_target, _callback)();
                
                ds_list_add(global.__elephantPostDuplicateCallbackOrder,   _copy         );
                ds_list_add(global.__elephantPostDuplicateCallbackVersion, _latestVersion);
                
                //Execute the pre-read callback if we can
                ELEPHANT_SCHEMA_VERSION = _latestVersion;
                var _callback = _copy[$ __ELEPHANT_PRE_READ_METHOD_NAME];
                if (is_method(_callback)) method(_copy, _callback)();
                
                if (_verbose || global.__elephantForceVerbose)
                {
                    //There's no specific serialization information so we write this constructor as a generic struct
                    __ElephantRemoveExcludedVariables(_names, _elephantSchemas);
                    
                    //Iterate over the serializable variable names and write them
                    var _i = 0;
                    repeat(array_length(_names))
                    {
                        var _name = _names[_i];
						if _name!=""{
							_copy[$ _name] = __ElephantDuplicateInner(variable_struct_get_errorcheck(_target, _name), buffer_any); //_target[$ _name]
						}
                        ++_i;
                    }
                }
                else
                {
                    //Iterate over the serializable variable names and write them
                    var _i = 0;
                    repeat(array_length(_names))
                    {
                        var _name = _names[_i];
                        _copy[$ _name] = __ElephantDuplicateInner(_target[$ _name], _schema[$ _name]);
                        ++_i;
                    }
                }
                
                //Execute the post-write callback if we can
                ELEPHANT_SCHEMA_VERSION = _latestVersion;
                var _callback = _target[$ __ELEPHANT_POST_WRITE_METHOD_NAME];
                if (is_method(_callback)) method(_target, _callback)();
            }
            
            return _copy;
        }
    }
    else if (_datatype == buffer_any)
    {
        return __ElephantDuplicateInner(_target, __ElephantValueToDatatype(_target));
    }
    else if (_datatype == buffer_undefined)
    {
        return undefined;
    }
    else
    {
        if ((_datatype == buffer_text) || (_datatype == buffer_string)) return string(_target);
        return _target;
    }
}