// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function bus_fade(bus_name,fadeToNegativeOneHundredToZero=-100,fadeTimeInSeconds=1,curve=1){
	if ds_map_exists(global.audio_busses,bus_name){
		with(global.audio_busses[?bus_name]){
			return tween_audio("gain",fadeToNegativeOneHundredToZero,fadeTimeInSeconds,curve).on_update(function(){
			 var _calc = 0;
		    if parent!=undefined{
		        _calc = bus_getdata(parent).calc;
		    }
			recalculate(_calc);
			});
		}
		//returns a tween which you could attach a callback(); to
	}
}