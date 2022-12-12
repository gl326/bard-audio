//resets all busses to their default gain
//this will recursively cause them all to recalculate their volumes, which could be slow if you have quite a few
//this is a really brute force method which does not use any existing hierarchy to optimize. so use at your own risk
//for in-game code you will be better served having a well-defined hierarchy and calling reset() only on the busses you would have ever changed
function bus_reset_all(){
	var busses = ds_map_keys_to_array(global.audio_busses),
		_i = 0;
	if !is_undefined(busses){
	repeat(array_length(busses)){
		bus_reset(busses[_i]);
		bus_clear_effects(busses[_i],false);
		_i ++;	
	}
	
	_i = 0;
	repeat(array_length(busses)){
		bus_getdata(busses[_i]).default_effects();
		_i ++;	
	}
	}
}