/// get the current gain setting on a given bus. this is the setting on this individual bus, which might differ from its current volume if a parent bus has a volume setting on it
function bus_gain(bus_name) {
	if ds_map_exists(global.audio_busses,bus_name){
	    return ds_map_find_value(global.audio_busses,bus_name).gain;
	}else{
		return 0;
	}
}

function bus_gain_current(bus_name) {
	if ds_map_exists(global.audio_busses,bus_name){
	    return ds_map_find_value(global.audio_busses,bus_name).calc;
	}else{
		return 0;
	}
}

function bus_emitter(bus_name){
	if ds_map_exists(global.audio_busses,bus_name){
	    return ds_map_find_value(global.audio_busses,bus_name).get_emitter();
	}else{
		return -1;
	}	
}