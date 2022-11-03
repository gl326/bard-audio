/// @description audio_param_set(param name, new number)
/// @param param
/// @param  newVal
/// @param  soundName
/// @param  soundID
function audio_param_set_unique(param, newVal, _container, playID=-1) {
	var player = container_player(_container);
	if !is_undefined(player){
		return player.param_set_unique(param, newVal, playID);	
	}
	return undefined;
}
