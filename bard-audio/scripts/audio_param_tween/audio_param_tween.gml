// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_param_tween(param,tweenTo,timeInSeconds=1,curve=1){
	if ds_map_exists(global.audio_params,param){
		global.audio_params[?param].tween("val",tweenTo,timeInSeconds,curve).on_update(function(){
			var _i = 0;
			repeat(array_length(global.audio_players)){
				global.audio_players[_i].param_update(name);
				_i ++;
			}	
		});	
	}
}