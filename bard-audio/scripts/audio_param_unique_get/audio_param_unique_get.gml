/// @description audio_param_unique_get(sound, id, new number)
/// @param sound
/// @param  id
/// @param  new number
function audio_param_unique_get(param,container,playID) {
	var player = container_player(container);
	if !is_undefined(player){
		//ds_map_add_map(unique_param_settings,playID,map_Create(param,newv));
		if ds_map_exists(player.unique_param_settings,playID){
			return ds_map_Find_value(player.unique_param_settings,playID)[?param];	
		}
	}

	return undefined;
}
