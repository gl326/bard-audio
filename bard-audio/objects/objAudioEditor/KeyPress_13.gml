///@description go to gameplay from audio editor
if keyboard_check(vk_control){
    instance_create_depth(x,y,0,objAudioEditorReturn);
	
	//go wherever you need to go to initiate gameplay
    room_goto(EDITOR_PLAY_ROOM);
}

