/// @description gameaudio_stop(sound,option)
/// @param sound
/// @param option
function gameaudio_stop() {
	var option = false;
	if argument_count>1{option = argument[1];}
	if is_real(argument[0]){
	    return audio_stop_sound(argument[0]);
	}else{
	    return container_stop(argument[0],-1,option);
	}



}
