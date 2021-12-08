// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function container_stop_all(stopPersistent=false){
	//this calls container_stop() on all playing containers.
	//note that container_stop() can often still incur additional logic, like fading out, playing a 'tail' sound, or whatever else.
	//but for mooooost cases, stop_all() will be the most natural way for all playing sounds to end & clean themselves up
	var _i = 0;
	repeat(array_length(global.audio_players)){
		var p = global.audio_players[_i];
		if stopPersistent or !p.persistent{
			p.stop();	
		}
		_i ++;	
	}
}