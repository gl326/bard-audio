/// @description music_scene_set(name)
/// @param name
function music_scene_set(argument0) {
	//the_levelobj.level_music = argument0;

	if !is_equal(the_audio.music_scene, argument0){
	        the_audio.music_scene = argument0;
	        if is_real(argument0) and argument0<0{the_audio.fading_out = true;}
	    }




}
