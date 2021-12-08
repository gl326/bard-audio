/// @description music&ambiance state during gameplay

if !audio_in_editor and !loading_audio{
	var music_change = "";
if !is_equal(music_scene_p,music_scene){
    if !is_equal(music_scene_p,-1){
        gameaudio_stop(music_p); //option used to be 1???
        music_p = music_scene_p;
    }
}
music_scene_p = music_scene;

if is_string(music_scene) or music_scene>=-1{

    if is_equal(music_scene,-1){ //mandatory silence
        if music_volume>0{fading_out = true;}
        else{
			if fading_out or (is_string(music_current) and container_is_playing(music_current)){
				gameaudio_stop(music_current); //option used to be 1???
			}
			if fading_out or (is_string(music_p) and container_is_playing(music_p)){
				gameaudio_stop(music_p); //option used to be 1???
			}
            fading_out = false;
            music_obj = noone;
            if container_has_beat{
                container_has_beat = false;
            }
            }

    music_volume = max(0,music_volume - (1/(room_speed*1.5)));
    }else{
        if !gameaudio_is_playing(music_scene) //and (room!=rmPlay)
		{

			if !manual_stop{
	            gameaudio_stop(music_p);
	            gameaudio_stop(music_current);
			}
			
            //TODO: make this not hacky NEVER.
            if instance_exists(music_obj){music_obj.persistent = false;} //old can die now
            music_playing = gameaudio_play(music_scene,music_player,1);
            beat_count = 4;
            if is_string(music_scene){music_obj = music_playing;}else{music_obj = noone;}
            if instance_exists(music_obj){music_obj.persistent = true;} //new can stay!

            if music_volume==0{music_volume = 1;}
			
			music_change = the_audio.music_scene;
        }else{
            music_volume = min(1,music_volume + (1/(room_speed*1.5)));
        }
    }

}else{
var ftime = auto_fade_time;
if is_equal(music_current,-1) or fading_out{
	/*if music_transition{
		music_transitioning = true;	
	}
	if music_transitioning and !is_equal(music_current,-1)
	and !is_equal(music_p,-1){
		fading_out = true;
		if measure_event and (measure mod 2)==0{
			fading_out = false;	
		}
	}else*/
	{
	    if music_volume>0{fading_out = true;}
	    else{
	        gameaudio_stop(music_p);//option used to be 1???
	        container_has_beat = false;
			
			if music_start_delay>0{
				music_start_delay -= (delta_time);
			}else{
				fading_out = false;
			}
	        }
	    if !is_equal(the_audio.music_current,-1){
	        music_volume = max(0,music_volume - (1/(room_speed*.75))); //if going to another song, fade fast
	    }else{
	        music_volume = max(0,music_volume - (delta_time/(ftime*1000000)));
	    }
	}
}else{
    if !gameaudio_is_playing(music_current){
        gameaudio_stop(music_p); //option used to be 1???

        if instance_exists(music_obj){music_obj.persistent = false;} //old dies
		
		audio_param_set("spookiness",0); //lollllllll
		
		music_transition_state = (100*(music_transition>0));
		audio_param_set("music_transition",music_transition_state);
		
        music_playing = gameaudio_play(music_current,music_player,1);
        beat_count = 4;
        if is_string(music_current){music_obj = music_playing;}
        else{music_obj = noone;}
        if instance_exists(music_obj){music_obj.persistent = true;} //new lives
		
		music_change = the_audio.music_current;

        if music_volume==0{music_volume = 1;}
    }
	
	//if we're in a transition state, track the time and if it goes over some amount then escalate to fading out entirely
	if music_transition>0{
		music_transition_time += (1/room_speed);
		if music_transition_time>=music_transition_maxtime
		and music_can_transition<2{
			ftime *= 5;
			music_transition = 2;	
		}
	}else{
		music_transition_time = 0;	
	}
	
	//if we're in a transition state, fade music parameter and/or/then volume itself. otherwise volume goes up.
	if music_transition==2 or (!music_can_transition and music_transition==1){
	        music_volume = max(0,music_volume - (delta_time/(ftime*1000000)));
	}else{
			music_volume = min(1,music_volume + (1/(room_speed*.75)));
	}
	
}
}


music_cur_volume = music_volume;

audio_emitter_position(music_player,__view_get( e__VW.XView, 0 )+(__view_get( e__VW.WView, 0 )/2),__view_get( e__VW.YView, 0 )+(__view_get( e__VW.HView, 0 )/2),0);
audio_emitter_gain(music_player,music_cur_volume);
audio_emitter_set_listener_mask(music_player,audio_get_listener_mask());
if instance_exists(music_obj){
	music_obj.volume = music_cur_volume;
	
	}

//////////////ambiance
if is_equal(ambiance_current,-1) or amb_fading_out{ //silence
    if ambiance_volume>0{amb_fading_out = true;}
    else{
        amb_fading_out = false;
        gameaudio_stop(ambiance_p); //option used to be 1???
        }
    ambiance_volume = max(0,ambiance_volume - (1/(room_speed*.75)));
}else{
    if !gameaudio_is_playing(ambiance_current){ //start + fade in new ambiance
        if ambiance_player == ambiance_p_player
        or !audio_emitter_exists(ambiance_player){
			ambiance_player = audio_emitter_Create();
			audio_emitter_gain(ambiance_player,0);
		}

        if instance_exists(ambiance_obj){ambiance_obj.persistent = false;} //old dies
        ambiance_playing = gameaudio_play(ambiance_current,ambiance_player,1);
        if is_string(ambiance_current){ambiance_obj = ambiance_playing;}
		else{ambiance_obj = noone;}
        if instance_exists(ambiance_obj){
			ambiance_obj.persistent = true;
			ambiance_obj.volume = 0;
			with(ambiance_obj){
				container_update_volume();	
			}
			} //new lives
    }
    ambiance_volume = min(1,ambiance_volume + (1/(room_speed*.75)));
}

if ambiance_player!=-1{
	audio_emitter_gain(ambiance_player,QuadInOut(ambiance_volume));
	audio_emitter_set_listener_mask(ambiance_player,audio_get_listener_mask());
}
if instance_exists(ambiance_obj){
	ambiance_obj.volume = QuadInOut(ambiance_volume);
}

if ambiance_p_player!=-1{ //fade out an old one
    ambiance_p_volume = max(0,ambiance_p_volume - (1/(room_speed*2)));
    if ambiance_p_volume>0{
    audio_emitter_gain(ambiance_p_player,QuadInOut(ambiance_p_volume));
    if instance_exists(ambiance_p_obj){ambiance_p_obj.volume = QuadInOut(ambiance_p_volume);}
    }else{
		audio_emitter_Free(ambiance_p_player);
		if ambiance_p_player==ambiance_player{ambiance_player = -1;}
        gameaudio_stop(ambiance_p); //option used to be 1???
        ambiance_p_player = -1;
        ambiance_p_obj = noone;
    }
}
}

if is_real(music_fade_to){
    var vol = bus_get("music_gameplay"),
        t = music_fade_time,
        amt = 0;
    if t>0{
		amt = clamp((current_time-music_fade_start)/(1000*t),0,1);
		}

    if t==0 or amt>=1{
        vol = music_fade_to;
        music_fade_to = "";
    }else{
        vol = lerp(music_fade_save,music_fade_to,amt);
    }
    bus_set("music_gameplay",(vol)*100)
}


var vx = room_width/2,
	vy = room_height/2,
	vw = room_width;
with(the_scenemanager){
	vx = camera_x;
	vy = camera_y;
	vw = camera_get_view_width(camera);
}
//set the global listener position!
//this puts it dead center in the screen, using game maker's compatibility view functions...
//change this to whatever makes sense for you
//the z position is set away from the screen, to simulate the player's distance from the screen
bard_audio_listener_update(vx,vy,0,vw/default_view_width);
