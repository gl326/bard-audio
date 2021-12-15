// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function bus_fade(bus_name,fadeToNegativeOneToZero=-1,fadeTimeInSeconds=1,curve=1){
	if ds_map_exists(global.audio_busses,bus_name){
		with(global.audio_busses[?bus_name]){
			return tween_audio("gain",fadeToNegativeOneToZero,fadeTimeInSeconds,curve).on_update(function(){
			 var calc = 0;
		    if cv.parent!=undefined{
		        calc = cv.parent.calc;
		    }
			recalculate();});
		}
		//returns a tween which you could attach a callback(); to
	}
}