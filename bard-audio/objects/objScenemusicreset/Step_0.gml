/// @description Insert description here
// You can write your code in this editor
time += delta_time;

if time >= reset_time*1000000{
	var nmusic = set_to;
    if !is_equal(the_audio.music_scene,nmusic){
        the_audio.music_scene = nmusic;
        if is_real(nmusic) and nmusic<0{
			the_audio.fading_out = true;
		}
    }	
	instance_destroy();
}
