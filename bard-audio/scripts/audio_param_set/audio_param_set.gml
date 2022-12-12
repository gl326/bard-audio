/// @description audio_param_set(param name, new number)
/// @param param name
/// @param  new number
function audio_param_set(param, newv) {
	newv = clamp(newv,0,100);
	
	if ds_map_exists(global.audio_params,param){
		global.audio_params[?param].set(newv);
	}
}
