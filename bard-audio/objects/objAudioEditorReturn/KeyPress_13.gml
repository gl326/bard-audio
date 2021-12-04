///@description crl+enter to return to editor
if keyboard_check(vk_control){
                the_audio.music_scene = -4;
                persistent=false;
				instance_activate_all();
                with(objAudioContainer){persistent = false;}
				with(objPoolParent){
					persistent = false;
					with(object){
						persistent = false;	
					}
				}
				 with(objAudioContainer){persistent = false;}
                audio_stop_all();
                room_goto(rmAudioEditor);
}
