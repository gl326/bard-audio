/// @description ambiance_set(amb)
/// @param amb
function ambiance_set(argument0) {
	var amb = argument0;
	if the_audio.ambiance_current!=amb{
			the_audio.ambiance_p = the_audio.ambiance_current;
	        the_audio.ambiance_p_volume = the_audio.ambiance_volume;
	        the_audio.ambiance_p_obj = the_audio.ambiance_obj;
	        the_audio.ambiance_volume = 0;
	        the_audio.ambiance_p_player = the_audio.ambiance_player;
	        the_audio.ambiance_p_playing = the_audio.ambiance_playing;

        
	    the_audio.ambiance_current = amb;
	}



}
