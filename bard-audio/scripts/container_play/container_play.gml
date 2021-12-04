/// @description container_play(name,option)
/// @param name
/// @param option
function container_play(con,option = false) {

	if is_string(con){
	    if ds_map_exists(global.audio_containers,con){
			
			if os_type==os_ps5{
				switch(con){
					case "select":
					case "scroll":
					case "menu_select":
					case "menu_back":
					case "toggle":
					case "transit_pass_flip":
					case "clothing_lock":
					case "clothing_unlock":
					case "menu_dressup_open":
					case "menu_dressup_close":
					case "decor_grab":
					case "decor_place":
						if object_index==objBrush{
							container_vibrate_gamepad(ds_map_find_value(global.audio_containers,con),player_id);	
						}else{
							container_vibrate_gamepad(ds_map_find_value(global.audio_containers,con),0);
						}
					break;
				}
			}
			
	        con = ds_map_find_value(global.audio_containers,con);
	    }else{
	        show_debug_message("tried to play nonexistent container "+con);
	        return noone;
	    }
	    }
    
	if ds_list_size(container_contents(con))>0{
	var obj = noone;
	with(objAudioContainer){if container==con and setup and instance_exists(id){obj = id; break;}}
	if obj==noone{
	    obj = instance_create_depth(0,0,0,objAudioContainer);
	    obj.container = con;
	    obj.setup = false;
	    with(obj){
	        //container_setup();
	        event_user(0);
	        }
	}
	//show_debug_message("created obj "+string(obj.id));
	if !obj.setup{
	    show_debug_message("playing container "+container_name(con)+" failed for unknowable reasons");
	    return noone;
	    }
	obj.play_id += 1;
	if option>100{
		obj.play_id = option;	
		var stopped = false;
		var n = ds_list_size(obj.delay_sounds);
		        for(var i=0;i<n;i+=1){
					var s = ds_list_find_value(obj.delay_sounds,i);
					if ds_map_Find_value(s,"playid")==option{
	                    stopped = true;
	                    break;
	                }
				}
		if !stopped{
			var n = ds_list_size(obj.playing);
		        for(var i=0;i<n;i+=1){
					var s = ds_list_find_value(obj.playing,i);
					if ds_map_Find_value(s,"playid")==option{
	                    stopped = true;
	                    break;
	                }
				}
		}
		if stopped{
			return obj;	
		}
	}
	obj.seed = random_get_seed();
	obj.am_playing = true;
	if object_index!=objAudioContainer 
	or obj.owner==noone{obj.owner = id;}
	obj.name = ds_map_Find_value(obj.container,"name");
	with(obj){
	    bpm = container_attribute(container,"bpm");
	    varyingbpm = container_attribute(container,"varybpm");
		//spec_time = random_range(container_attribute(container,"specmin"),container_attribute(container,"specmax"));
	
		beat_start = container_attribute(container,"beatstart");
		beats = beat_start;
		spec_snd = (container_attribute(container,"specmax")>0 or container_attribute(container,"specmin")>0);
	    if ds_map_Find_value(container,"music")/* and container_type(container)==2*/{
	        music = true;
			group_track_pos = 0;
			the_audio.measure = 0;
	    }else{music = false;}
	}
	var playlist = list_Create();
	var idmap = container_map_create();
            

	containerSounds(con,playlist,-1,obj,idmap,option); 

	container_map_clean(idmap);

	if obj.sync{
		if !global.DISABLE_SYNCGROUPS{
			obj.group = audio_create_sync_group(obj.group_loop);
		}else{
			obj.fake_sync = true;
		}
	}


	var n = ds_list_size(playlist);
	if n>1{obj.simple_sound = false;}
	var typ= container_type(con);
	var threed = false;
	for(var i=0;i<n;i+=1){
	    var s = ds_list_find_value(playlist,i);
	    if  ((ds_map_Find_value(s,"delayin")<=0 or (!obj.spec_snd and option)) or ds_map_Find_value(s,"sync")){
	        //show_debug_message("playing con "+container_name(con)+" sound "+ds_map_string(s)+" obj "+string(obj));
	        container_sound_play(s,con,obj);
	    }else{
	        ds_list_add(obj.delay_sounds,s);
	    }
	}
	//if obj.group!=-1{audio_sync_group_debug(obj.group);}
	obj.auto_play = (typ==0 and ds_map_Find_value(con,"contin"));
	if obj.group!=-1 and !obj.group_delay{
	    audio_start_sync_group(obj.group);
	    obj.group_playing = true;
		obj.group_track_pos = 0;
	    }
	obj.start_time = current_time;
	obj.first_beat = true;
	ds_list_destroy(playlist);

	/* ???? with(obj) maybe???
	if obj.music and n>0 and !option{
	    //as written, it makes it so the playing object has these things set... and when it's the_audio that messed stuff up
	    beat = 0;
	    beat_time = 0;
	    measure_event = false;
	    beat_event = false;
	}*/

	obj.firstplay = true;
            
	return obj;
	}

	return noone;



}
