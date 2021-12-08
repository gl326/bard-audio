/// @description audio_param_unique_get(sound, id, new number)
/// @param sound
/// @param  id
/// @param  new number
function audio_param_unique_get(container,param) {
	var player = container_player(container);
	if !is_undefined(player){
		return ds_map_Find_value(player.unique_param,param);	
	}

	return noone;
}
