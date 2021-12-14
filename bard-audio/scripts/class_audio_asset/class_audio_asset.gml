// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function class_audio_asset(_name="",_external=false) constructor{
	external = _external;
	name = "";
	path = _name;
	index = 0;
	
	gain = 0;
	bus = "";
	editor_order = 0;
	
	//////loaded state for external/grouped audio
	loaded = false;
	loaded_audio = -1;
	loaded_buffer = -1;
	streamed = false;
	
	//is_grouped = false;
	//audio_group = ""; //if we're an internal file in an audio group, track that here
	audio_group_id = 0;
	
	ELEPHANT_SCHEMA
    {
        ELEPHANT_VERBOSE_EXCLUDE : [
			"loaded",
			"index",
			"loaded_buffer",
			"loaded_audio",
			"name",
        ],
    }
	
	ELEPHANT_POST_READ_METHOD
    {
		setup(); //...
    }

	static setup = function(){
		if !external{
			name = path;
			index = asset_get_index(name);
		}else{
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
		
		//weird blank
		if name=="" and path==""{
			//stop serializing me
			var ind = array_find_index(global.bard_audio_data[bard_audio_class.asset],self);
			if ind!=-1{
				array_delete(global.bard_audio_data[bard_audio_class.asset],ind,1);	
			}
		}
	}
	
	static play = function(prio,looping){
		if load(){
			if !external{
				return audio_play_sound(index,prio,looping);	
			}else{
				return audio_play_sound(loaded_audio,prio,looping);
			}
		}
	}
	
	static play_on = function(emitterID,looping,prio){
		if load(){
			if !external{
				return audio_play_sound_on(emitterID,index,looping,prio);	
			}else{
				return audio_play_sound_on(emitterID,loaded_audio,looping,prio);	
			}
		}
	}
	
	static stop = function(){
		if !external{
			return audio_stop_sound(index);	
		}else{
			return audio_stop_sound(loaded_audio);
		}	
	}
	
	static is_loaded = function(){
		if external{
			return (loaded>=1);
		}else{
			if audio_group_id>0 and !audio_group_is_loaded(audio_group_id){
				return false;
			}else{
				return true;	
			}
		}
	}
	
	static load = function(){
		if external and !loaded{
			if streamed{
				loaded_audio = audio_create_stream(path);
				loaded = true;	
			}else{
				if loaded==0{
					bard_audio_load_queue_add(path,self);
					loaded = -1;
				}
				return false;
			}
		}else{
			if audio_group_id>0 and !audio_group_is_loaded(audio_group_id){
				if !audio_group_load_queued(audio_group_id){
					bard_audio_load_queue_add(audio_group_id,self);	
				}
				return false;
			}
		}
		
		return true;
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
		}else{
			if audio_group_id>0 and audio_group_is_loaded(audio_group_id){
				bard_audio_load_queue_add(-audio_group_id,self);	
			}	
		}
		
		return true;
	}
}