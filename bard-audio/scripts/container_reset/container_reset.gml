/// @description container_reset(container)
/// @param container
function container_reset(_container_name) {
	ds_map_delete(global.audio_list_index,_container_name);
	var player = container_player(_container_name);
	if !is_undefined(player){
		player.destroy();	
	}
}
