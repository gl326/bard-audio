/// @description bus_destroy(name)
/// @param name
//used by editor functions, not to be used during gameplay probably
function bus_destroy(argument0) {
	var name=argument0;

	if ds_map_exists(global.audio_busses,name){
	    ds_map_delete(global.audio_busses,name);
	    return 1;
	}
	else{
	    show_message("already doesnt exist!");
	    return 0;
	}




}
