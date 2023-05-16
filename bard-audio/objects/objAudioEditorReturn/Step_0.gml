/// @description Insert description here
// You can write your code in this editor
var _shortcut = AUDIO_EDITOR_KEY_SHORTCUT;
if array_length(_shortcut){
	var _i = array_length(_shortcut),
		_pressed = 0;
	repeat(_i){
		_i --;
		if keyboard_check_pressed(_shortcut[_i]){
			_pressed = true;	
		}else if !keyboard_check(_shortcut[_i]){
			_pressed = false;
			break;
		}
	}
	
	if _pressed{
		room_goto(AUDIO_EDITOR_ROOM);	
	}
}