/// @description Insert description here
// You can write your code in this editor
bard_audio_update();

bard_audio_listener_update(room_width/2, room_height/2);

if debug_mode and keyboard_check(vk_control) and keyboard_check_pressed(ord("M")){
	debug_view = !debug_view;	
}