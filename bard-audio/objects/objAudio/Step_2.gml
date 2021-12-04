///@description audio loading

///check if audio has finished loading and start room if so
if loading_audio{
    loading_fade+=(1-loading_fade)*.2;
    var loaded = true,load_wait = 300;
    loading_prog = 0;
    if ds_list_size(audio_loading)>0{
        if current_time>unload_start+load_wait{ //hack wait for .5 seconds to let audio unload...
        for(var i=0;i<ds_list_size(audio_loading);i+=1){
            var group = ds_list_find_value(audio_loading,i);
            if !audio_group_is_loaded(group){
                loaded = false;
                show_debug_message("checking "+string(group));
                if ds_list_find_index(audio_loading_flag,group)!=-1 or !audio_group_load(group){
                    if ds_list_find_index(audio_loading_flag,group)!=-1{
                        var prog = audio_group_load_progress(group);
                        loading_prog += prog;
                        show_debug_message("group "+string(group)+": "+string(prog)+"%");
                    }else{
                        ds_list_delete(audio_loading,i); //starting load failed
                        i -= 1;
                        show_debug_message("failed to load group "+string(group));
                        continue;
                    }
                }else{
                    show_debug_message("started loading "+string(group));
                    ds_list_add(audio_loading_flag,group);
                }
                break;
            }else{
                //ds_list_delete(audio_loading,i);
                //i -= 1;
                loading_prog += 100;
            }
        }
        }else{
			//hack wait for .5 seconds to let audio unload...
			//if you don't do this, audio will start loading in too fast and gamemaker would crash pretty often
			loaded = false;
			show_debug_message("waiting "+string((unload_start+load_wait)-current_time)+" to load.....");
			}
        loading_prog/=(ds_list_size(audio_loading));
    }
    if loaded{
        show_debug_message("loading done!");
        ds_list_clear(audio_loading);
        ds_list_clear(audio_loading_flag);
        loading_audio = false;
        loading_fade = 0;
        load_color = -1;
        if audio_room{
            audio_room = false;
			if !preloading{
				//DO SOMETHING HERE TO START YOUR LEVEL... GO TO THE NEXT ROOM OR WHATEVER.
				//In wandersong, I would go to the gameplay room, but i load audio first before spawning objects
				//then spawn them here at this time once loading completed.
			}
			preloading = false;
            }
    }
    
}
