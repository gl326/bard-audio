/// @description bus_recalculate(bus name,calc)
/// @param bus name
/// @param calc
function bus_recalculate(bus_name) {
	//rcalculate the given bus gain, given the calculation of its parent.
	//goes recusrively down until all children are in their new form

	if ds_map_exists(global.audio_busses,bus_name){
		return global.audio_busses[?bus_name].recalculate();
	}

	return 0;
}
