// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function bus_getdata(bus){
	if is_string(bus){
	    if ds_map_exists(global.audio_busses,bus){
	        return global.audio_busses[?bus];
	    }else{
		    show_debug_message("tried to get nonexistent bus "+bus);
		    return undefined;
	    }
	}
	return bus;
}