/// @description audio_param_set(param name, new number)
/// @param param name
/// @param  new number
function audio_param_reset(param) {
	audio_param_set(param,param_getdata(param).default_value);
}
