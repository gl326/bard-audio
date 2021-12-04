/// Unpacks a struct/array JSON created by ElephantToJSON(), respecting Elephant schemas, constructors, and circular references.
/// 
/// @return  The data that was encoded
/// 
/// @param  target

function ElephantFromJSON(_target)
{
    global.__elephantFound      = ds_map_create();
    global.__elephantFoundCount = 0;
    
    global.__elephantPostReadCallbackOrder   = ds_list_create();
    global.__elephantPostReadCallbackVersion = ds_list_create();
    
    ELEPHANT_IS_DESERIALIZING = true;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    var _duplicate = __ElephantFromJSONInner(_target);
    
    //Now execute post-read callbacks in the order that the structs were created
    var _i = 0;
    repeat(ds_list_size(global.__elephantPostReadCallbackOrder))
    {
        with(global.__elephantPostReadCallbackOrder[| _i])
        {
            //Execute the post-read callback if we can
            if (variable_struct_exists(self, __ELEPHANT_POST_READ_METHOD_NAME))
            {
                ELEPHANT_SCHEMA_VERSION = global.__elephantPostReadCallbackVersion[| _i];
                self[$ __ELEPHANT_POST_READ_METHOD_NAME]();
            }
        }
        
        ++_i;
    }
    
    ds_map_destroy(global.__elephantFound);
    
    ds_list_destroy(global.__elephantPostReadCallbackOrder);
    ds_list_destroy(global.__elephantPostReadCallbackVersion);
    
    ELEPHANT_IS_DESERIALIZING = undefined;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    return _duplicate;
}

function __ElephantFromJSONInner(_target)
{
    if (is_struct(_target))
    {
        if (variable_struct_exists(_target, __ELEPHANT_JSON_CIRCULAR_REF))
        {
            return global.__elephantFound[? _target[$ __ELEPHANT_JSON_CIRCULAR_REF]];
        }
        else if (variable_struct_exists(_target, __ELEPHANT_JSON_CONSTRUCTOR))
        {
            var _instanceof = _target[$ __ELEPHANT_JSON_CONSTRUCTOR   ];
            var _version    = _target[$ __ELEPHANT_JSON_SCHEMA_VERSION];
            
            if (_version == undefined) __ElephantError("No schema version found");
            
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
            
            //Execute the pre-read callback if we can
            ELEPHANT_SCHEMA_VERSION = _version;
            var _callback = _struct[$ __ELEPHANT_PRE_READ_METHOD_NAME];
            if (is_method(_callback)) method(_struct, _callback)();
            
            ds_list_add(global.__elephantPostReadCallbackOrder,   _struct);
            ds_list_add(global.__elephantPostReadCallbackVersion, _version);
        }
        else
        {
            //Generic struct
            var _struct  = {};
            var _version = undefined;
        }
        
        global.__elephantFound[? global.__elephantFoundCount] = _struct;
        global.__elephantFoundCount++;
        
        var _names = variable_struct_get_names(_target);
        
        //Sort the names alphabetically
        //This is important for deserializing circular references so that the indexes are always created in the same order
        array_sort(_names, lb_sort_ascending);
        
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            if ((_name != __ELEPHANT_JSON_CONSTRUCTOR) && (_name != __ELEPHANT_JSON_SCHEMA_VERSION))
            {
                _struct[$ _name] = __ElephantFromJSONInner(_target[$ _name]);
            }
            
            ++_i;
        }
        
        return _struct;
    }
    else if (is_array(_target))
    {
        var _length = array_length(_target);
        var _array = array_create(_length);
        
        global.__elephantFound[? global.__elephantFoundCount] = _array;
        global.__elephantFoundCount++;
        
        var _i = 0;
        repeat(_length)
        {
            _array[@ _i] = __ElephantFromJSONInner(_target[_i]);
            ++_i;
        }
        
        return _array;
    }
    else
    {
        return _target;
    }
}