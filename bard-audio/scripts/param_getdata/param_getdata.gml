// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function param_getdata(bus){
	if is_string(bus){
	    if ds_map_exists(global.audio_params,bus){
	        return global.audio_params[?bus];
	    }else{
		    show_debug_message("tried to get nonexistent param "+bus);
		    return undefined;
	    }
	}
	return bus;
}