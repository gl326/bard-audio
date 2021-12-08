/// @description bus_get(bus name - typically returns -1 to 0)
/// @param bus name - typically returns -1 to 0
function bus_get(argument0) {
	if ds_map_exists(global.audio_busses,argument0){
	    return ds_map_find_value(global.audio_busses,argument0).gain;
	}
	return 0;



}
