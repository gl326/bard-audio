//      buffer_u8          1
//      buffer_s8          2
//      buffer_u16         3
//      buffer_s16         4
//      buffer_u32         5
//      buffer_s32         6
//      buffer_f16         7
//      buffer_f32         8
//      buffer_f64         9
//      buffer_bool       10
//      buffer_string     11
//      buffer_u64        12
//      buffer_text       13
#macro  buffer_any        14
#macro  buffer_array      15
#macro  buffer_struct     16
#macro  buffer_undefined  17

#macro  __ELEPHANT_SCHEMA_NAME             "__Elephant_Schema__"
#macro  __ELEPHANT_PRE_WRITE_METHOD_NAME   "__Elephant_Pre_Write_Method__"
#macro  __ELEPHANT_POST_WRITE_METHOD_NAME  "__Elephant_Post_Write_Method__"
#macro  __ELEPHANT_PRE_READ_METHOD_NAME    "__Elephant_Pre_Read_Method__"
#macro  __ELEPHANT_POST_READ_METHOD_NAME   "__Elephant_Post_Read_Method__"
#macro  __ELEPHANT_FORCE_VERSION_NAME      "__Elephant_Force_Version__"
#macro  __ELEPHANT_VERSION_VERBOSE_NAME    "__Elephant_Version_Verbose__"
#macro  __ELEPHANT_VERBOSE_EXCLUDE_NAME    "__Elephant_Verbose_Exclude__"

#macro  __ELEPHANT_VERBOSE_FORCE_NAME	"__Elephant_Verbose_Force__" // added for bard audio

#macro __ELEPHANT_JSON_CIRCULAR_REF    "__Elephant_Circular_Ref__"
#macro __ELEPHANT_JSON_CONSTRUCTOR     "__Elephant_Constructor__"
#macro __ELEPHANT_JSON_SCHEMA_VERSION  "__Elephant_Schema_Version__"

#macro __ELEPHANT_JSON_CONSTRUCTOR_PREV "__Elephant_Constructor__"

#macro  ELEPHANT_IS_DESERIALIZING   global.__elephantIsDeserializing
#macro  ELEPHANT_SCHEMA_VERSION     global.__elephantSchemeVersion
#macro  ELEPHANT_SCHEMA             static __Elephant_Schema__ =
#macro  ELEPHANT_PRE_WRITE_METHOD   static __Elephant_Pre_Write_Method__  = function()
#macro  ELEPHANT_POST_WRITE_METHOD  static __Elephant_Post_Write_Method__ = function()
#macro  ELEPHANT_PRE_READ_METHOD    static __Elephant_Pre_Read_Method__   = function()
#macro  ELEPHANT_POST_READ_METHOD   static __Elephant_Post_Read_Method__  = function()
#macro  ELEPHANT_FORCE_VERSION      __Elephant_Force_Version__
#macro  ELEPHANT_VERSION_VERBOSE    __Elephant_Version_Verbose__
#macro  ELEPHANT_VERBOSE_EXCLUDE    __Elephant_Verbose_Exclude__
#macro  ELEPHANT_VERBOSE_FORCE      __Elephant_Verbose_Force__

#macro ELEPHANT_WRITE_VERSION false

//for cross-platform and net safety we need to always check every variation of generic struct constructor that gamemaker or json could generate
#macro _INSTANCEOF_STRUCT (_instanceof == "struct" or _instanceof=="[[Object]]" or _instanceof=="[[Method]]")

global.__elephantReadFunction         = undefined;
global.__elephantConstructorIndexes   = {};
global.__elephantConstructorNextIndex = 0;
global.__elephantFound                = undefined;
global.__elephantFoundCount           = 0;
global.__elephantForceVerbose         = false;
ELEPHANT_SCHEMA_VERSION               = undefined;
ELEPHANT_IS_DESERIALIZING             = undefined;



#macro  __ELEPHANT_HEADER       0x454C4550  //ELEP
#macro  __ELEPHANT_FOOTER       0x48414E54  //HANT
#macro  __ELEPHANT_BYTE_VERSION ((1 << 16) | (4 << 8) | (0))
#macro  __ELEPHANT_VERSION      (string(__ELEPHANT_BYTE_VERSION >> 16) + "." + string((__ELEPHANT_BYTE_VERSION >> 8) & 0xFF) + "." + string(__ELEPHANT_BYTE_VERSION & 0xFF))
#macro  __ELEPHANT_DATE         "2021-07-02"

__ElephantTrace("Welcome to Elephant by @jujuadams! This is version " + string(__ELEPHANT_VERSION) + ", " + string(__ELEPHANT_DATE));


function __ElephantTrace()
{
    var _string = "Elephant: ";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message(_string);
}

function __ElephantError()
{
    var _string = "";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message("Elephant: " + _string);
    show_error("Elephant:\n" + _string + "\n ", true);
}

function __ElephantValueToDatatype(_value)
{
    switch(typeof(_value))
    {
        case "int32":     return buffer_s32;       break;
        case "bool":      return buffer_bool;      break;
        case "number":    return buffer_f64;       break;
        case "string":    return buffer_string;    break;
        case "undefined": return buffer_undefined; break;
        case "struct":    return buffer_struct;    break;
        
        case "array":
        case "vec3":
        case "vec4": return buffer_array; break;
        
		case "ref": //??
        case "int64":
        case "ptr": return buffer_u64; break;
                
        case "method":
            __ElephantTrace("Methods not supported, writing <undefined>");
            return buffer_undefined;
        break;
                
        default:
            __ElephantError("Datatype not recognised \"", typeof(_value), "\"");
        break
    }
    
    return buffer_undefined;
}

function __ElephantConstructorFindLatestVersion(_elephantSchemas)
{
    var _latestVersion = 0;
    
	if ELEPHANT_WRITE_VERSION{
	    if (is_struct(_elephantSchemas))
	    {
	        if (variable_struct_exists(_elephantSchemas, __ELEPHANT_FORCE_VERSION_NAME))
	        {
	            _latestVersion = _elephantSchemas[$ __ELEPHANT_FORCE_VERSION_NAME];
            
	            if (_latestVersion != 0) //Allow forcing to version 0
	            {
	                if (!variable_struct_exists(_elephantSchemas, "v" + string(_latestVersion)))
	                {
	                    __ElephantError("Forced schema version \"", _latestVersion, "\" has no data (constructor = \"", _instanceof, "\")");
	                }
	            }
	        }
	        else
	        {
	            //Iterate over names inside the root of the schema struct
	            var _names = variable_struct_get_names(_elephantSchemas);
	            var _i = 0;
	            repeat(array_length(_names))
	            {
	                var _name = _names[_i];
                
	                if ((_name != __ELEPHANT_VERSION_VERBOSE_NAME)
	                &&  (_name != __ELEPHANT_VERBOSE_EXCLUDE_NAME))
	                {
	                    try
	                    {
	                        //Check the first character (should only ever be "v")
	                        if (string_char_at(_name, 1) != "v") throw -1;
                        
	                        //Extract the numeric version from the remainder of the string 
	                        var _version = real(string_delete(_name, 1, 1));
                        
	                        //Check to see if the version number is between 1 and 127 (inclusive)
	                        if ((_version < 0x01) || (_version > 0x7F) || (floor(_version) != _version)) throw -2;
                        
	                        //Check if we can go backwards from the version number back to the struct entry
	                        if (_name != "v" + string(_version)) throw -3;
                        
	                        //Finally, if the found version is larger than the latest version we found already, update the latest version
	                        if (_version > _latestVersion) _latestVersion = _version;
	                    }
	                    catch(_)
	                    {
	                        __ElephantError("Schema version tag \"", _name, "\" is invalid:\n- Schema versions must start with a lowercase \"v\" and be followed by a version number\n- The version number must be an integer from 1 to 255 inclusive\n- The version number must contain no leading zeros e.g. \"v001\" is invalid");
	                    }
	                }
                
	                ++_i;
	            }
	        }
	    }
	}
    
    return _latestVersion;
}

function __ElephantRemoveExcludedVariables(_names, _elephantSchemas)
{
    //There's no specific serialization information so we write this constructor as a generic struct
    if (is_struct(_elephantSchemas))
    {
        //Check to see if we have an array of variables to exclude from serialization
        if (variable_struct_exists(_elephantSchemas, __ELEPHANT_VERBOSE_EXCLUDE_NAME))
        {
            var _excludeArray = _elephantSchemas[$ __ELEPHANT_VERBOSE_EXCLUDE_NAME];
            if (!is_array(_excludeArray)) __ElephantError("Verbose exclude data must be an array (datatype = ", typeof(_excludeArray), ", constructor = \"", _instanceof, "\")");
            
            var _foundLength = array_length(_names);
            var _i = 0;
            repeat(array_length(_excludeArray))
            {
                var _exclude = _excludeArray[_i];
                
                var _j = 0;
                repeat(_foundLength)
                {
                    if (_names[_j] == _exclude)
                    {
                        array_delete(_names, _j, 1);
                        --_foundLength;
                        break;
                    }
                    
                    ++_j;
                }
                
                ++_i;
            }
        }
    }
}