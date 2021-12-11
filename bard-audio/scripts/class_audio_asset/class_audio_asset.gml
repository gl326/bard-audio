// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function class_audio_asset(_name="",_external=false) constructor{
	external = _external;
	name = _name;
	path = "";
	index = 0;
	
	gain = 0;
	bus = "";
	editor_order = 0;
	
	//////loaded state for external audio
	loaded = false;
	loaded_audio = -1;
	loaded_buffer = -1;
	streamed = false;
	
	ELEPHANT_SCHEMA
    {
        ELEPHANT_VERBOSE_EXCLUDE : [
			"loaded",
			"index",
			"loaded_buffer",
			"loaded_audio"
        ],
    }
	
	ELEPHANT_POST_READ_METHOD
    {
		setup(); //...
    }

	static setup = function(){
		if !external{
			path = "";
			index = asset_get_index(name);
		}else{
			path = name;
			name = filename_name(path);
			index = global.external_audio_index;
			global.external_audio_index ++;
			if filename_ext(path)==".ogg"{
				streamed = true;	
			}
		}
	
		if !external{
			if asset_get_index(name)!=-1{
				ds_map_add(global.audio_assets,index,self); //track me!
			}else{
				show_debug_message(concat("WARNING! no matching audio asset for \"",name,"\". was it deleted or renamed?"));
			}
		}else{	
			if file_exists(path){
				ds_map_add(global.audio_external_assets,path,index); //for lookup
				ds_map_add(global.audio_assets,index,self); //track me!
			}else{
				show_debug_message(concat("WARNING! no file for \"",path,"\". was it deleted or renamed?"));
			}
		}
	}
	
	static play = function(prio,looping){
		if !external{
			return audio_play_sound(index,prio,looping);	
		}else{
			load();
			return audio_play_sound(loaded_audio,prio,looping);
		}
	}
	
	static play_on = function(emitterID,looping,prio){
		if !external{
			return audio_play_sound_on(emitterID,index,looping,prio);	
		}else{
			load();
			return audio_play_sound_on(emitterID,loaded_audio,looping,prio);	
		}
	}
	
	static stop = function(){
		if !external{
			return audio_stop_sound(index);	
		}else{
			return audio_stop_sound(loaded_audio);
		}	
	}
	
	static load = function(){
		if external and !loaded{
			if streamed{
				loaded_audio = audio_create_stream(path);
			}else{
				loaded_buffer = buffer_load(path);
				loaded_audio = __audioExtWavBufferToAudio(loaded_buffer);
			}
			
			loaded = true;	
		}
	}
	
	static unload = function(){
		if external and loaded{
			if streamed{
				audio_destroy_stream(loaded_audio);
			}else{
				audio_free_buffer_sound(loaded_audio);
				buffer_delete(loaded_buffer);
			}
			loaded_audio = -1;
			loaded_buffer = -1;
			
			loaded = false;	
		}
	}
}