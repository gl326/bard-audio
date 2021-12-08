//resets the given bus to its default gain
function bus_reset(bus_name){
	if ds_map_exists(global.audio_busses,bus_name){
		bus_set_gain(bus_name,global.audio_busses[?bus_name].default_gain);	
	}
}