/// @description music_set(name)
/// @param name
function music_set(argument0) {
	//the_levelobj.level_music = argument0;
	if !is_equal(argument0,the_audio.music_current){
	
		//delay music start for smoother transition from high-energy music
		music_start_delay = .1*1000*1000;
		if is_string(the_audio.music_current) and is_string(argument0){
			var olde = music_jingle_instrument(the_audio.music_current),
				newe = music_jingle_instrument(argument0);
			if newe<olde{
				the_audio.music_start_delay = 2*1000*1000; //delta_time	
			}
		}
		
		if argument0=="music_title"{
			music_start_delay = 0; //!
		}
	
	    the_audio.music_p = the_audio.music_current;
	    the_audio.fading_out = true;
	    the_audio.music_current = argument0;
	}



}
