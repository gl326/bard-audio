/// @description audio_param_state(param name)
/// @param param name
function audio_param_state(param) {
	var _struct = global.audio_params[?param];
	if is_struct(_struct){
		return _struct.val;
	}else{
		show_debug_message("AUDIO WARNING! No parameter named \""+string(param)+"\"");
		return 0;
	}



}
