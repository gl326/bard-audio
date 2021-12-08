/// get the current gain setting on a given bus
function bus_gain(bus_name) {
	if ds_map_exists(global.audio_busses,bus_name){
	    return ds_map_find_value(global.audio_busses,bus_name).gain;
	}else{
		return 0;
	}
}
