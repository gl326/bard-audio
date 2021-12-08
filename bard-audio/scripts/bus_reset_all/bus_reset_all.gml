//resets all busses to their default gain
//this will recursively cause them all to recalculate their volumes, which could be slow if you have quite a few
//this is a really brute force method which does not use any existing hierarchy to optimize. so use at your own risk
//for in-game code you will be better served having a well-defined hierarchy and calling reset() only on the busses you would have ever changed
function bus_reset_all(){
	var busses = ds_map_keys_to_array(global.audio_busses),
		_i;
	repeat(array_length(busses)){
		bus_reset(busses[_i]);
		_i ++;	
	}
}