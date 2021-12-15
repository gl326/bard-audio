/// @description Insert description here
// You can write your code in this editor
bard_audio_update();

bard_audio_listener_update(room_width/2, room_height/2);

if debug_mode and keyboard_check(vk_control) and keyboard_check_pressed(ord("M")){
	debug_view = !debug_view;	
}

if room==rmAudioDemo{
	if keyboard_check_pressed(ord("Q")){
		music_set("bard_main_bgm");	
		set_music_key("cmaj");
	}
		
	if keyboard_check_pressed(ord("W")){
		music_set("bard_sail_bgm");	
		set_music_key("fmaj");
	}
	
	if keyboard_check_pressed(ord("T")){
		if !music_is_paused(){
			music_pause();
		}else{
			music_unpause();
		}
	}
	
	if keyboard_check(ord("E")){
		if is_struct(tween){tween.destroy();}
		tween = audio_param_tween("intensity",100,2);
	}
		
	if keyboard_check(ord("R")){
		if is_struct(tween){tween.destroy();}
		tween = audio_param_tween("intensity",0,2);
	}
	
	if mouse_check_button_pressed(mb_left){
		var obj = container_play_position("test_choice_sfx",mouse_x,mouse_y);
		container_pitch_note("test_choice_sfx",choose(0,2,4),obj.playID);
	}
	
	if beatEvent(){
		beat_fx = 1;	
	}else{
		beat_fx = approach(beat_fx,0,1/15);	
	}
}