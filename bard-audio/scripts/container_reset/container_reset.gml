/// @description container_reset(container)
/// @param container
function container_reset(argument0) {
	var con = argument0;
	if is_string(con){
	    if ds_map_exists(global.audio_containers,con){
	        con = ds_map_find_value(global.audio_containers,con);
	    }else{
	        show_debug_message("tried to reset nonexistent container "+con);
	        return noone;
	    }
	    }
	ds_map_delete(global.audio_list_index,con);

	with(objAudioContainer){if container==con and !deleted and instance_exists(id){instance_destroy(); deleted = true;}}



}
