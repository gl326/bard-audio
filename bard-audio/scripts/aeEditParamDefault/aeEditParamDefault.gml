/// @description aeEditParamDefault(id)
/// @param id
function aeEditParamDefault(class) {
	var name = param_name(class),def = param_default(class);
	var val = get_string("enter new default for "+name+"?",string(def));
	                    if string_number(val)==val and val!=""{
	                        class.default_value = real(val);
							class.val = class.default_value;
	                    }



}
