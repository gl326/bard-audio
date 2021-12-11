/// @description aePlayEditingSound()
function aePlayEditingSound() {
	with(objAudioEditor){
	if editing!=-1{
	if editing_audio{
	    if audio_is_playing(editing){
	        audio_asset_stop(editing);
	        }
	    else{
	        var aud = audio_asset_play(editing,0,0);
	        audio_sound_gain(aud,(1+(audio_asset_gain(editing)/100))
	            *(1+bus_gain(audio_asset_bus(editing)))
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
