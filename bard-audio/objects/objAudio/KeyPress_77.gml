///@description in debug mode, alt+m to toggle debug
if global.DEBUG 
{
if keyboard_check(vk_alt){ //Alt+M shows audio debug info
    audio_debug_setting = (audio_debug_setting+1) mod 2; //4
    switch(audio_debug_setting){
        case 1:
            audio_debug_on = 1;
            audio_sync_group_debug(-1);
            audio_debug(false);
            break;
        case 2:
            audio_debug_on = 0;
            audio_sync_group_debug(-1);
            audio_debug(true);
            break;
         case 3:
            audio_debug_on = 0;
            audio_debug(false);
            with(objAudioContainer){
                    if group!=-1{
                        audio_sync_group_debug(group);
                        break;
                    }   
                } 
          default:
            audio_debug_setting = 0;
            audio_debug_on = 0;
            audio_sync_group_debug(-1);
            audio_debug(false);
            break; 
    }

}


}
