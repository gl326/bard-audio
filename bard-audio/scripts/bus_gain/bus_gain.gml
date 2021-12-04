/// @description bus_calculate(bus name)
/// @param bus name
function bus_gain(argument0) {
	if ds_map_exists(global.audio_bus_calculated,argument0){
	    return ds_map_find_value(global.audio_bus_calculated,argument0);
	}else{
		return 0;
	}
}
