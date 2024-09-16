// a single instance of one sound playing
// the closest thing to just being an audio_play_sound()
// this tracks one currently playing audio instance and can be used to track/set volume and stuff on a sound as it is playing
//they are tracked by audioplayers
function class_audio_instance(_container,_sound=-1,_loops=false,_gain=0,_pitch=0) constructor{
	container = _container;
	file = _sound;
	loop = _loops;
	vol = _gain;
	pitch = _pitch;
	
	currentvol = 0;
	
	emitter = -1; //for debug tracking
	
	sync = false;
	aud = -1;
	playid = 0;
	instid = 0;
	
	threed = false;
	
	fadein = 0;
	fadeout = 0;
	delayin = 0;
	delayout = 0;
	
	playstart = current_time;
	
	index = 0;
	
	blend = 0;
	
	bus = audio_asset_bus(file);
	//bus_vol = 0;
	owner = -1;
	
	starttime = 0;
	randstart = false;
	tail = false; 
	
	static isPlaying = function(){
		return audio_is_playing(aud);
	}
	
	static play = function(player = container_player(container)){
	if !is_undefined(player){
	var typ = container.type,
	    name = container.name; //helps with debug

	    var aud_playing = -1,
	        looping = (loop or (typ!=CONTAINER_TYPE.HLT and container.loop));
		var bus_id = bus;
	    //player.bus_track(bus);
		var _emitter = -1;
		var _has_owner = false;
		
	    if container.spacerand{ //i play at a random spatial position, and manage my own emitter
				threed = true;
				
				var _emitter_id = 0;
				if container.specmin>0{
					var _needed_emitters = min(4, max(1, player.made_emitter, audio_sound_length(audio_asset_id(file))/max(.25,container.specmin)));	
					_emitter_id = (player.spec_id mod _needed_emitters);
					player.spec_id += 1;
				}
				var space_emitter = player.get_emitter(_emitter_id);
			
				var ref_dist = container.threed_sound_size,
		            max_dist = container.threed_sound_falloff;
		            if ref_dist==0{
						ref_dist = global.default_sound_size;
					}
				
		            if max_dist==0{
						max_dist = global.default_sound_atten;
						}
			
				audio_emitter_falloff(space_emitter,ref_dist,max_dist,1);
		        audio_emitter_gain(space_emitter,1);
				
		        var dir = random(360), 
					dist = global.default_sound_size+((global.default_sound_atten-global.default_sound_size)*sqr(random(1)));
		        audio_emitter_position(space_emitter,
		            global.listener_x + lengthdir_x(dist,dir),
		            global.listener_y + lengthdir_y(dist,dir),
					global.listener_z);
					
				_emitter = space_emitter;
	    }else{
			if !instance_exists(player.owner){
					if player.owner!=noone{
						show_debug_message("container "+name+" owner "+string(player.owner)+" ceased to exist ");
						player.owner = noone;
					}
				}
			else{
				if owner<=0{owner = player.owner;}
			if object_is_ancestor((owner).object_index,objSpatialObject) or (owner).object_index==objSpatialObject{
			_has_owner = true;
		    if threed{ //dlay spunds need to know this player
				with(owner){
					var ref_dist = other.container.threed_sound_size,
		                max_dist = other.container.threed_sound_falloff,
						cust_pan = other.container.threed_pan;
		                //falloff_factor = ds_map_Find_value(container,"3d_falloff_factor");
		            if ref_dist==0{
						ref_dist = global.default_sound_size;
					}
		            if max_dist==0{
						max_dist = global.default_sound_atten;
						}
					if cust_pan!=0{
						audio_emitter_pan = (cust_pan/100);
					}
		            
					//find matching audio emitter in playing object
					var falloff_factor = 1;
					var emitter_size = ref_dist + (max_dist*falloff_factor),
						has_emitter = false;
					player.aemitter_size = ref_dist;
					player.aemitter_atten = max_dist;
					player.aemitter_pan = audio_emitter_pan;
				if audio_emitter!=-1{
					var i=0;
					repeat(audio_emitter_n){
						if audio_emitter_size[i]==emitter_size{
							var old_emitter = audio_emitter[i];
							if audio_emitter_exists(old_emitter){
								player.emitter = old_emitter;
								_emitter = old_emitter;
								has_emitter = true;
							}else{
								array_delete(audio_emitter,i,1);	
								array_delete(audio_emitter_size,i,1);
								audio_emitter_n -= 1;
							}
							break;
						}
						i ++;
					}
				}else{
					audio_emitter = [];	
					audio_emitter_size = [];	
				}
		        if !has_emitter{ //emitter is created per calling spatialobj for positioning
		            var new_emitter = audio_emitter_Create();
		            audio_emitter_falloff(new_emitter,ref_dist,max_dist,falloff_factor);
		            audio_emitter_gain(new_emitter,1);
					audio_emitter_position(new_emitter,x,y,AUDIO_USES_Z?z: 0);
					player.emitter = new_emitter;
					_emitter = new_emitter;
					array_push(audio_emitter,new_emitter);
					array_push(audio_emitter_size,emitter_size);
					audio_emitter_n += 1;
		            }
				}
				 player.threed = true;
			}
	       
			}
		}
		}

		var file_vol = audio_asset_gain(file); 
		
	    //bus_vol = bus_gain_current(bus_id);
	    var blend_vol = 1+blend;
        
	    current_vol = (vol+1)*(file_vol+1);//*(bus_vol+1);
	    if is_undefined(current_vol) or is_real(current_vol)==0 {current_vol = 0;}

	   var finalvolumecalc = max(current_vol,0)*max(0,player.volume*blend_vol);
		var _set_gain = finalvolumecalc;
		if fadein>0{
			_set_gain = 0;	
		}
		
		var start_offset = 0;
		if randstart{
			var _file_length = audio_sound_length(audio_asset_id(file));
			start_offset = random(_file_length);
		}else{
			if starttime>0{
				start_offset = starttime;
			}
		}

	    if typ==0 and container.contin{looping = false;}
	    loop = looping;

	    if !sync{
			if _emitter==-1{
				if player.has_any_effects(){
					_emitter = player.get_effect_emitter();
				}else if bus_id!=""{
					_emitter = bus_emitter(bus_id); //nobody tried to assign an emitter, so let's go to my bus
				}
			}
		
			if _emitter==-1{ //i must not be on a bus! 
	            aud_playing = audio_asset_play(file,0,looping, _set_gain, 1+pitch, start_offset);
	        }else{
				var _bus_struct = undefined;
				if _has_owner and is_struct(owner.audio_emitter_effect_bus){
					_bus_struct = owner.audio_emitter_effect_bus.struct;
				}else if player.has_any_effects(){
					_bus_struct = player.get_effect_bus().struct; 
				}else if bus_id!=""{
					_bus_struct = bus_getdata(bus_id).struct; //make sure whatever emitter i'm using is assigned to my bus
				}
				//show_debug_message(">>>>>>>> container "+name);
				
				if is_struct(_bus_struct){
					//temp check to see if this is a bug??
					if !TEMP_DISABLE_GM_AUDIO_BUSSES{
						//runner 2022.11.0.73: audio_emitter_bus seemingly crashes 1 in every 10,000 times or so here with no apparent cause
						//so, we try to do it only very rarely 
						if audio_emitter_get_bus(_emitter)!=_bus_struct{
							//show_debug_message("TEST 1 > setting emitter bus. emitter: "+string(_emitter)+" | bus: "+string(_bus_struct));
							audio_emitter_bus(_emitter,_bus_struct); 	
						}
					}
				}
	            aud_playing = audio_asset_play_on(_emitter,file,looping,0, _set_gain, 1+pitch, start_offset);
				
				emitter = _emitter; //for debug tracking
	        }
	    }else{
	        aud_playing = audio_play_in_sync_group(player.group,file);
	        if delayin>0{
	            if !player.group_delay{
	                player.group_delay = true;
	                array_push(player.delay_sounds,self);
	                }
	        }
	    }
    
	    if is_undefined(aud_playing){return -1;}
		
		aud = aud_playing;
	    if sync{
			aud_playing = file;
		}
		
	    if fadein>0{
	        audio_sound_gain(aud_playing,finalvolumecalc,fadein*1000);
	    }

		array_push(player.playing,self); //track me!
	}
	}
	
	static update_current_pitch = function(){
		var snd = aud;
		if sync{snd = file;}
		audio_sound_pitch(snd,1+pitch);
	}
	
	//using current state of my bus, file, container etc.... set the gain of my attached sound.
	static update_current_volume = function(parentVolume = 1){
		var snd = aud;
		if sync{snd = file;}
        var file_vol = audio_asset_gain(file); 

            current_vol = (vol+1)*(file_vol+1);//*(bus_vol+1);
			var newFinalVol = lerp(0,max(current_vol,0),QuadInOut(parentVolume)*(1+blend));
            audio_sound_gain(snd,newFinalVol,0);
	}
	
	static copy_from = function(naud){
		loop	= naud.loop;
		vol		= naud.vol;
		pitch	= naud.pitch;
		sync	= naud.sync;
		threed	= naud.threed;
		fadein	= naud.fadein;
		delayin = naud.delayin;
		blend	= naud.blend;
		
		//ds_map_copy_keys_excepting(aud,naud,"ind","aud","playstart","playid","delayout","current_vol","bus_vol");
	}
	
	//might never be used
	static destroy = function(_player = container_player(container)){
		var ind = array_find_index(_player.playing,self);
		if ind>-1{
			array_delete(_player.playing,ind,1);
		}
	}
	
	static pitch_set = function(_pitch,_update = true){
		pitch = _pitch;
		if _update{
			update_current_pitch();
		}
	}
	
	static volume_set = function(_volume,_update = true){
		vol = _volume;
		if _update{
			update_current_volume();
		}
	}
	
	//multiply the pitch by a value, roughly 0-1.
	//for ex. multiply by 0.5 to set the pitch by half / down one octave.
	static pitch_multiply = function(_pitch,_update = true){
		var _old_value = pitch+1;
		var _new_value = _old_value * _pitch;
		pitch_set(_new_value - 1, _update); 	
	}
	
	static volume_multiply = function(_volume,_update = true){
		var _old_value = vol+1;
		var _new_value = _old_value * _volume;
		volume_set(_new_value - 1, _update); 	
	}
}