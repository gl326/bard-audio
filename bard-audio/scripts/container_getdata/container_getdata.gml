// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function container_getdata(_container){
	if is_string(_container){
	    if ds_map_exists(global.audio_containers,_container){
	        _container = ds_map_find_value(global.audio_containers,_container);
	    }else{
	        show_debug_message("tried to play nonexistent container "+_container);
	        return undefined;
	    }
	}
	return _container;
}