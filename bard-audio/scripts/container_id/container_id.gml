/// @description continer_id(container name)
/// @param container name
function container_id(argument0) {
	var con = argument0;
	if is_string(con){
	    if ds_map_exists(global.audio_containers,con){
	        con = ds_map_find_value(global.audio_containers,con);
	    }else{
	        show_debug_message("tried to id nonexistent container "+con);
	        return noone;
	    }
	    }
	return con;



}
