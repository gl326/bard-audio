/// @description bus_set(bus name, set typically from -100 to 0)
/// @param bus name
/// @param  setFrom-100to0
function bus_set(argument0, argument1) {
	if ds_map_exists(global.audio_busses,argument0){
		var cv = ds_map_find_value(global.audio_busses,argument0);
		if ds_map_find_value(cv,"gain")!=argument1{
		    ds_map_replace(cv,"gain",argument1);
		    var calc = 0;
		    if argument0!="master"
			and argument0!="ui_setting"{
		        calc = bus_calculate(ds_map_find_value(cv,"parent"));
		    }
		    bus_recalculate(argument0,calc);
		}

	}else{
		show_debug_message("WARNING!!!!!!! Trying to set nonexistent bus "+string(argument0));
	}

}
