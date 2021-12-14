/// @description param_create(name, default)
/// @param name
/// @param  default
function param_create(name,defaultValue) {
	if !ds_map_exists(global.audio_params,name){
		var ret = new class_audio_parameter(name,defaultValue);
		ret.track();
		array_push(
			global.bard_audio_data[bard_audio_class.parameter], 
			ret
		);
		return ret;
	}
	else{
	    show_message("there's already a parmeter with this name!");
	    return -1;
	}

}
