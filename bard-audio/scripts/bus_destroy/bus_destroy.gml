/// @description bus_destroy(name)
/// @param name
function bus_destroy(argument0) {
	var name=argument0;

	if !ds_map_exists(global.audio_busses,name){
	    var del = ds_map_find_value(global.audio_busses,name);
	    ds_map_destroy(del);
	    ds_map_delete(global.audio_busses,name);
	    return 1;
	}
	else{
	    show_message("already doesnt exist!");
	    return 0;
	}




}
