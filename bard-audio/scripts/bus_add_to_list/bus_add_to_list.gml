/// @description bus_add_to_list(bus name,list)
/// @param bus name
/// @param list
function bus_add_to_list(argument0, argument1) {
	if ds_map_exists(global.audio_busses,argument0){
	    var map = ds_map_find_value(global.audio_busses,argument0);
	    ds_list_add(argument1,argument0);
	    bus_add_to_list(ds_map_Find_value(map,"parent"),argument1); 
	    }



}
