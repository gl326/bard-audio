//set the volume of a bus during gameplay
//could be used to change volume of music based on a setting,
//or some other effect.... who knows.
function bus_set_gain(bus_name,setFromNegativeOnetoZero) {
	if ds_map_exists(global.audio_busses,bus_name){
		var cv = ds_map_find_value(global.audio_busses,bus_name);
		if cv.gain!=setFromNegativeOnetoZero{
		    cv.gain = setFromNegativeOnetoZero;
		    var calc = 0;
		    if cv.parent!=undefined{
		        calc = bus_getdata(cv.parent).calc;
		    }
		    cv.recalculate(calc);
		}
	}else{
		show_debug_message("WARNING!!!!!!! Trying to set nonexistent bus "+string(bus_name));
	}

}
