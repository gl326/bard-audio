// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_param_tween(param,tweenTo,timeInSeconds=1,curve=1){
	if ds_map_exists(global.audio_params,param){
		with(global.audio_params[?param]){
			return tween_audio("val",tweenTo,timeInSeconds,curve).on_update(function(){
					trigger_update();
				});	
		}
	}
}