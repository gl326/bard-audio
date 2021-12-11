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
	
	emitter = -1;
	
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
	bus_vol = 0;
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
	    player.bus_track(bus);
	
	    if container.spacerand{
				threed = true;
				var space_emitter = player.get_emitter();
			
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
	    }else{
			if !instance_exists(player.owner){
				show_debug_message("container "+name+" owner "+string(player.owner)+" ceased to exist ");
				player.owner = noone;
				}
			else{
				if owner<=0{owner = player.owner;}
			if object_is_ancestor((owner).object_index,objSpatialObject) or (owner).object_index==objSpatialObject{

		    if threed{ //dlay spunds need to know this player
				with(owner){
					var ref_dist = container.threed_sound_size,
		                max_dist = container.threed_sound_falloff,
						cust_pan = container.threed_pan;
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
								other.emitter = old_emitter;
								has_emitter = true;
							}else{
								array_delete(audio_emitter,i,1);	
								array_delete(audio_emitter_size,i,1);
								audio_emitter_n -= 1;
							}
							break;
						}
					}
				}else{
					audio_emitter = [];	
					audio_emitter_size = [];	
				}
		        if !has_emitter{ //emitter is created per calling spatialobj for positioning
		            var new_emitter = audio_emitter_Create();
		            audio_emitter_falloff(new_emitter,ref_dist,max_dist,falloff_factor);
		            audio_emitter_gain(new_emitter,1);
					audio_emitter_position(new_emitter,x,y,audio_uses_z?z: 0);
					player.emitter = new_emitter;
					other.emitter = new_emitter;
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
	    
	
		if fadein>0{
			audio_sound_gain(file,0,0); //HACK: to make sure fading in sounds are not audible at the start, 
				//we set the file volume to nil before playing this instance.
				//maybe someday we'll be able to set audio parameteres on an instance before it starts playing.
		}
		
		var file_vol = audio_asset_gain(file); 
		
	    bus_vol = bus_gain(bus_id);
	    var blend_vol = 1+blend;
        
	    current_vol = (vol+1)*(file_vol+1)*(bus_vol+1);
	    if is_undefined(current_vol) or is_real(current_vol)==0 {current_vol = 0;}

	   var finalvolumecalc = clamp(current_vol,0,1)*max(0,player.volume*blend_vol);
	
	    if typ==0 and container.contin{looping = false;}
	    loop = looping;

	    if !sync{
			if !threed{
	            aud_playing = audio_play_sound(file,0,looping);
	        }else{
	            aud_playing = audio_play_sound_on(player.emitter,file,looping,0);
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
    
	    if is_undefined(aud_playing){destroy(); return -1;}
		
		aud = aud_playing;
	    if sync{
			aud_playing = file;
		}
		
	    if fadein>0{
	        audio_sound_gain(aud_playing,0,0);
	        audio_sound_gain(aud_playing,finalvolumecalc,fadein*1000);
			audio_sound_gain(file,1,0); ///HACK: set back to 1 after previously setting to 0
	    }else{
	        audio_sound_gain(aud_playing,finalvolumecalc,0);
	    }
    
	    update_current_pitch();
	
		if randstart{
			audio_sound_set_track_position(aud_playing,random(audio_sound_length(aud_playing)));
		}else{
			if starttime>0{
				audio_sound_set_track_position(aud_playing,starttime);
			}
		}
		
		
		array_push(player.playing,self); //track me!
		/*
		//questionable old ideas
	    if !ds_map_Find_value(s,"tail"){ //tails dont get tracked or updated
	        //ds_map_add(s,"aud",aud_playing);
	        ds_list_add(player.playing, s); //once was list_add_map but it was janky between updates
	        //show_message(string(s)+": "+string(ds_exists(s,ds_type_map)));
	    }else{
	        ds_map_destroy(s);
	    }
		*/
	}
	}
	
	static update_current_pitch = function(){
		var snd = aud;
		if sync{snd = file;}
		audio_sound_pitch(snd,1+pitch);
	}
	
	//using current state of my bus, file, container etc.... set the gain of my attached sound.
	static update_current_volume = function(parentVolume){
		var snd = aud;
		if sync{snd = file;}
        var file_vol = audio_asset_gain(file); 

            current_vol = (vol+1)*(file_vol+1)*(bus_vol+1);
                            //ds_map_replace(s,"current_vol",ds_map_find_value(s,"current_vol")*(ng+1)/(bp+1)); //old (bad) way
			var newFinalVol = lerp(0,clamp(current_vol,0,1),QuadInOut(parentVolume)*(1+blend));
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
		array_delete(_player.playing,array_find_index(_player.playing,self),1);
	}
}