if setup and !deleted{
	var n = ds_list_size(playing);
for(var i=0;i<n;i+=1){
    var s = ds_list_find_value(playing,i);
    if ds_map_find_value(s,"loop"){
        audio_stop_sound(ds_map_find_value(s,"aud")); //they will delete on their own
    }
    container_map_clean(s);
}

ds_list_destroy(playing);
ds_list_destroy(parameters);
ds_list_destroy(parameters_update);

/*
for(var i=0;i<ds_list_size(unique_param);i+=1){
    var s = ds_list_find_value(unique_param,i);
    ds_map_destroy(s);
}
*/
ds_list_destroy(unique_param);

	var n = ds_list_size(delay_sounds);
for(var i=0;i<n;i+=1){
    var s = ds_list_find_value(delay_sounds,i);
    container_map_clean(s);
}

	var n = ds_list_size(delayout_sounds);
for(var i=0;i<n;i+=1){
    var s = ds_list_find_value(delayout_sounds,i);
    container_map_clean(s);
}

ds_list_destroy(delay_sounds);
ds_list_destroy(delayout_sounds);
ds_list_destroy(fadeout_sounds);
ds_list_destroy(bus_update);
ds_list_destroy(audio_busses);

if group!=-1{
    audio_destroy_sync_group(group);
}

/*
if unique_param!=-1{
    ds_map_destroy(unique_param);
}
*/

if the_audio.music_playing == id{the_audio.music_playing = -1;}
if the_audio.ambiance_playing == id{the_audio.ambiance_playing = -1;}
if the_audio.ambiance_p_playing == id{the_audio.ambiance_p_playing = -1;}

if emitter!=-1{
    if audio_emitter_exists(emitter){
		/*
	    var stop = false;
	    with(objAudioContainer){
	        if setup and !deleted and emitter==(other.id).emitter and id!=(other.id).id{stop = true; break;}
	    }
	    if !stop{ //don't delete it if someone else is using it!
	            audio_emitter_Free(emitter);
	    }
		*/
		if made_emitter{
			audio_emitter_Free(emitter);
		}
    }
}
}

ds_map_destroy(unique_param_settings);

deleted = true;

/* */
/*  */
