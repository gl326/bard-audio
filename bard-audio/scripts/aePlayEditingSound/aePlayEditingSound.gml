/// @description aePlayEditingSound()
function aePlayEditingSound() {
	with(objAudioEditor){
	if editing!=-1{
	if editing_audio{
	    if audio_is_playing(editing){
	        audio_stop_sound(editing);
	        }
	    else{
	        var aud = audio_play_sound(editing,0,0);
	        audio_sound_gain(aud,(1+(ds_map_Find_value(global.audio_asset_vol,audio_get_name(editing))/100))
	            *(1+bus_calculate(ds_map_Find_value(global.audio_asset_bus,audio_get_name(editing))))
	            ,0);
	        }
	}else{
	    if container_is_playing(editing){
	        container_stop(editing);
	    }else{
	        container_play(editing);
	    }
	}
	}
	}



}
