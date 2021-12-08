/// @description param_create(name, default)
/// @param name
/// @param  default
function param_create(name,defaultValue) {
	if !ds_map_exists(global.audio_params,name){
	    return new class_audio_parameter(name,defaultValue);
	}
	else{
	    show_message("there's already a parmeter with this name!");
	    return -1;
	}

}
