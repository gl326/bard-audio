/// @description audio_param_set(param name, new number)
/// @param param name
/// @param  new number
function audio_param_reset_all() {
	var _i = 0,
		_data = global.bard_audio_data[bard_audio_class.parameter];
	repeat(array_length(_data)){
		audio_param_reset(_data[_i].name,_data[_i].default_value);
		_i ++;	
	}
}
