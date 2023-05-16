// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function class_audio_asset(_name="",_external=false,_project = "") constructor{
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
	
	project = _project;
	
	marked_to_delete = false;
	
	ELEPHANT_SCHEMA
    {
        ELEPHANT_VERBOSE_EXCLUDE : [
			"loaded",
			"index",
			"loaded_buffer",
			"loaded_audio",
			"name",
			"project",
			"marked_to_delete"
        ],
    }
	
	ELEPHANT_POST_READ_METHOD
    {
		setup(); //...
    }
	
	static DELETE = function(){
		if ELEPHANT_IS_DESERIALIZING{
			marked_to_delete = true;	
		}else{
				var ind = array_find_index(global.bard_audio_data[bard_audio_class.asset],self);
				if ind!=-1{
					array_delete(global.bard_audio_data[bard_audio_class.asset],ind,1);	
				}else{
					marked_to_delete = true;	
				}
		}
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
				DELETE();
			}
		}else{	
			var _exists = false;
			if file_exists(project+path){
				_exists = true;
			}else{
						var all_files = gumshoe(EXTERN_SOUND_FOLDER,filename_ext(path), false),
							found = -1,
							_i = 0,
							search_name = filename_name(path);
						repeat(array_length(all_files)){
							var file = all_files[_i];
							var file_name = filename_name(file);
							if file_name==search_name{
								if found==-1{
									show_debug_message(path+" [>>MOVED TO>>] "+file);	
									path = file;
									_exists = true;
									break; //you could remove this to keep searching and make sure there arent duplicates, but for the sake of speed on big projects its probably not worth a warning
								}else{
									show_debug_message("WARNING! found multiple viable replacements for "+path+"! sound might be wonky");
									break;
								}
							}
							_i ++;	
						}
			}
			
			if _exists{
				ds_map_add(global.audio_external_assets,path,index); //for lookup
				ds_map_add(global.audio_assets,index,self); //track me!	
			}else{
				show_debug_message(concat("WARNING! no file for \"",path,"\". was it deleted or renamed?"));
				DELETE();
			}
		}
		
		//weird blank
		if name=="" and path==""{
			DELETE();
		}
	}
	
	static play = function(prio=0,looping=0,gain=1,pitch=1,offset=0){
		if load(){
			var _emitter = bus_emitter(bus);
			if _emitter!=-1{
				return play_on(_emitter,looping,prio,gain,pitch,offset);
			}else{
				return audio_play_sound(asset_id(),prio,looping,gain,offset,pitch);
			}
		}
	}
	
	static play_on = function(emitterID,looping,prio=0,gain=1,pitch=1,offset=0){
		if load(){
			return audio_play_sound_on(emitterID,asset_id(),looping,prio,gain,offset,pitch);
		}
	}
	
	static asset_id = function(){
		if !external{
			return index;	
		}else{
			return loaded_audio;	
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
		if !AUDIO_ENABLE{
			return false;	
		}
		
		if external and !loaded{
			if streamed{
				loaded_audio = audio_create_stream(project+path);
				loaded = true;	
			}else{
				if loaded==0{
					bard_audio_load_queue_add(project+path,self);
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