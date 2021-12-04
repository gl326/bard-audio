///@description go to gameplay from audio editor
if keyboard_check(vk_control){
    if audio_loaded{save_audioedit();}
    with(the_audio){event_user(10);}
    instance_create_depth(x,y,0,objAudioEditorReturn);
	
	//go wherever you need to go to initiate gameplay
    room_goto(rmPlay);
}

