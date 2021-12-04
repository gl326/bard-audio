/// Deserializes Elephant data from a buffer, starting at the buffer_tell() point. This function uses
/// buffer_read() and will move the buffer head as it reads data. This function calls ELEPHANT_PRE_READ_METHOD
/// and ELEPHANT_POST_READ_METHOD for constructed structs, and ELEPHANT_IS_DESERIALIZING is set to <true>.
/// ELEPHANT_SCHEMA_VERSION will contain the constructor schema version that Elephant found in the source data.
/// 
/// @return  The data that was encoded
/// 
/// @param buffer  The buffer to read from

function ElephantRead(_buffer)
{
    var _header = buffer_read(_buffer, buffer_u32);
    if (_header != __ELEPHANT_HEADER) __ElephantError("Header mismatch");
    
    global.__elephantConstructorNextIndex = 0;
    global.__elephantConstructorIndexes   = {};
    
    global.__elephantFound      = ds_map_create();
    global.__elephantFoundCount = 0;
    
    global.__elephantPostReadCallbackOrder   = ds_list_create();
    global.__elephantPostReadCallbackVersion = ds_list_create();
    
    ELEPHANT_IS_DESERIALIZING = true;
    ELEPHANT_SCHEMA_VERSION   = undefined;
    
    //Read the Elephant version out from the buffer, then figure out which deserialization function to run
    var _version = buffer_read(_buffer, buffer_u32);
    switch(_version)
    {
        case ((1 << 16) | (0 << 8) | (0)): //1.0.0
            global.__elephantReadFunction = __ElephantReadInner_v1;
        break;
        
        case ((1 << 16) | (1 << 8) | (0)): //1.1.0
        case ((1 << 16) | (2 << 8) | (0)): //1.2.0
        case ((1 << 16) | (2 << 8) | (1)): //1.2.1
            global.__elephantReadFunction = __ElephantReadInner_v2;
        break;
        
        case ((1 << 16) | (3 << 8) | (0)): //1.3.0
            global.__elephantReadFunction = __ElephantReadInner_v3;
        break;
        
        case ((1 << 16) | (4 << 8) | (0)): //1.4.0
            global.__elephantReadFunction = __ElephantReadInner_v4;
        break;
        
        default:
            var _major = _version >> 16;
            var _minor = (_version >> 8) & 0xFF;
            var _patch = _version & 0xFF
            __ElephantError("Buffer is for unsupported version ", _major, ".", _minor, ".", _patch, ", it may be a newer version\n(Found ", _version, ", we are ", __ELEPHANT_VERSION, ")");
        break;
    }
    
    //Run the read function and grab whatever comes back (hopefully it's useful data!)
    var _result = global.__elephantReadFunction(_buffer, buffer_any);
    
    var _footer = buffer_read(_buffer, buffer_u32);
    if (_footer != __ELEPHANT_FOOTER) __ElephantError("Footer mismatch");
    
    //Now execute post-read callbacks in the order that the structs were created (1.4.0 / v4 and above only)
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
    
    return _result;
}