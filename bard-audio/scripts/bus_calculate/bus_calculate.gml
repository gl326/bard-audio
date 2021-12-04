/// @description bus_calculate(bus name)
/// @param bus name
function bus_calculate(argument0) {
	//get the calculated gain value of the given bus, which we did the math on earlier and
	//stored cuz they dont change often
	if ds_map_exists(global.audio_bus_calculated,argument0){
	    return ds_map_find_value(global.audio_bus_calculated,argument0);
	}else{
		return 0;
	}
	/*var calc = 0;
	if ds_map_exists(global.audio_busses,argument0){
	    var map = ds_map_find_value(global.audio_busses,argument0);
	    //if ds_exists(map,ds_type_map){
	        calc = ((calc+1)
	            *((ds_map_Find_value(map,"gain")/100)+1)
	            *(bus_calculate(ds_map_Find_value(map,"parent"))+1)
	            )-1;
	      //  }
        
	    }
	return calc;*/



}
