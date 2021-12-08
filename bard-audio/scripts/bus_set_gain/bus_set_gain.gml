//set the volume of a bus during gameplay
//could be used to change volume of music based on a setting,
//or some other effect.... who knows.
function bus_set_gain(bus_name,setFromNegativeOneHundredtoZero) {
	if ds_map_exists(global.audio_busses,bus_name){
		var cv = ds_map_find_value(global.audio_busses,bus_name);
		if cv.gain!=setFromNegativeOneHundredtoZero{
		    cv.gain = setFromNegativeOneHundredtoZero;
		    var calc = 0;
		    if cv.parent!=undefined{
		        calc = cv.parent.calc;
		    }
		    cv.recalculate(calc);
		}
	}else{
		show_debug_message("WARNING!!!!!!! Trying to set nonexistent bus "+string(bus_name));
	}

}
