/// @description container_sound_play(data map, container, optional obj, optional play_on_gamepad)
/// @param data map
/// @param  container
/// @param  optional obj
/// @param  optional play_on_gamepad
function container_sound_play() {
	var s = argument[0], con = argument[1], obj = noone;//play_on_gamepad = false;
	if argument_count>2{obj = argument[2];}
	else{
	    with(objAudioContainer){if setup and container==con  //CHECK WHY THIS CRASHED
	    {obj = id; break;}}
	    }
		
	var test_vibration_vol = false;
    
	if obj!=noone{
	var typ = container_type(con),
	    name = container_name(con); //helps with debug

	if ds_map_exists(s,"file"){
	    //if container_type(con)==1{
	    //    show_message("playing "+audio_get_name(ds_map_find_value(s,"file"))+", loop "+string(ds_map_Find_value(s,"loop")));
	    //}
	    var aud_playing = -1,
	        file = ds_map_find_value(s,"file"),
	        looping = (ds_map_Find_value(s,"loop") or (typ!=1 and ds_map_Find_value(con,"loop"))),
	        //choice(ds_map_Find_value(con,"loop"),ds_map_Find_value(s,"loop"),typ==1),
	        threed = false;
		var bus_id = ds_map_find_value(s,"bus");
	    if !ds_map_exists(global.audio_busses,bus_id){
	        bus_id = ds_map_Find_value(global.audio_asset_bus,file);
			ds_map_replace(s,"bus",bus_id);
	    }else{
	        ds_list_add(obj.audio_busses,bus_id);
	    }
	
	
	    if container_attribute(con,"spacerand"){
	        threed = true;
			var space_emitter = -1;
			
			var owner = ds_map_Find_value(s,"owner");
			if owner>0 
			and (object_is_ancestor((owner).object_index,objSpatialObject) or (owner).object_index==objSpatialObject) 
			and owner.audio_special_emitter!=-1{
					//show_debug_message("vibrating "+name+" to gp emitter "+string(audio_special_emitter));
					obj.emitter = owner.audio_special_emitter;
					obj.threed = true;
					if owner.audio_vibrate{
						var volset = -1+global.rumble;
						test_vibration_vol = true;
						//show_debug_message("rumbling "+audio_get_name(file)+" to "+string(owner.audio_special_emitter));
						ds_map_Replace(s,"vol",volset); 
					}else{
						ds_map_Replace(s,"vol",100); //LOL
					}
					ds_map_Replace(s,"emitter",owner.audio_special_emitter);
					threed = true;
			}else{
				if obj.emitter==-1 or !audio_emitter_exists(obj.emitter){
		            obj.made_emitter = true;
		            obj.emitter = audio_emitter_Create();
		        }
			
				space_emitter = obj.emitter;
			
			
				var ref_dist = ds_map_Find_value(con,"3d_sound_size"),
		                max_dist = ds_map_Find_value(con,"3d_sound_falloff");
		                //falloff_factor = ds_map_Find_value(con,"3d_falloff_factor");
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
		            (room_width/2) + lengthdir_x(dist,dir),
		            (room_height/2) + lengthdir_y(dist,dir),0);
			}
				
	    }else{
		if !instance_exists(obj.owner){
				show_debug_message("container "+name+" owner "+string(obj.owner)+" ceased to exist ");
				obj.owner = noone;
				}
			else{
			var owner = ds_map_Find_value(s,"owner");
			if owner<=0{owner = obj.owner;}
		if object_is_ancestor((owner).object_index,objSpatialObject) or (owner).object_index==objSpatialObject{
							//show_debug_message("playing "+string(name)+" from "+object_get_name(object_index)+" "+string(id));
				 
				//this block was a special case we wrote for putting audio in controllers
				//but it could have otjer uses too?
				//setting audio_special_emitter to an emitter belonging to an objSpatialObject
				//would make it so that emitter didn't actually use any 3d spatial logic, and was locked to full volume
				//it's complicated to explain why we had to do that and i dont remember all the details anymore
				//sorry
				if owner.audio_special_emitter!=-1{
					//show_debug_message("vibrating "+name+" to gp emitter "+string(audio_special_emitter));
					obj.emitter = owner.audio_special_emitter;
					obj.threed = true;
					if owner.audio_vibrate{
						var volset = -1+global.rumble;
						test_vibration_vol = true;
						//show_debug_message("rumbling "+audio_get_name(file)+" to "+string(owner.audio_special_emitter));
						ds_map_Replace(s,"vol",volset); 
					}else{
						ds_map_Replace(s,"vol",100); //LOL
					}
					ds_map_Replace(s,"emitter",owner.audio_special_emitter);
					threed = true;
				}
				else{ //only here if you're using audio_special_emitter
	    if ds_map_Find_value(s,"3d"){ //dlay spunds need to know this obj
	        threed = true;
			with(owner){
				var ref_dist = ds_map_Find_value(con,"3d_sound_size"),
	                max_dist = ds_map_Find_value(con,"3d_sound_falloff"),
					cust_pan = ds_map_Find_value(con,"3d_pan");
	                //falloff_factor = ds_map_Find_value(con,"3d_falloff_factor");
	            if ref_dist==0{
					ref_dist = global.default_sound_size;
				}
				
	            if max_dist==0{
					max_dist = global.default_sound_atten;
					}
				if cust_pan!=0{
					audio_emitter_pan = (cust_pan/100);
				}
	            //if falloff_factor==0{falloff_factor=1;}
				var falloff_factor = 1;
				var emitter_size = ref_dist + (max_dist*falloff_factor),
					has_emitter = false;
				obj.aemitter_size = ref_dist;
				obj.aemitter_atten = max_dist;
				obj.aemitter_pan = audio_emitter_pan;
			if audio_emitter!=-1{
				for(var i=0;i<audio_emitter_n;i+=1){
					if ds_list_find_value(audio_emitter_size,i)==emitter_size{
						var old_emitter = ds_list_find_value(audio_emitter,i);
						if audio_emitter_exists(old_emitter){
							obj.emitter = old_emitter;
							ds_map_Replace(s,"emitter",old_emitter);
							has_emitter = true;
						}else{
							ds_list_delete(audio_emitter,i);	
							ds_list_delete(audio_emitter_size,i);
							audio_emitter_n -= 1;
						}
						break;
					}
				}
			}else{
				audio_emitter = ds_list_create();	
				audio_emitter_size = ds_list_create();	
			}
	        if !has_emitter{ //emitter is created per calling prop/object for positioning
	            var new_emitter = audio_emitter_Create();
	            audio_emitter_falloff(new_emitter,ref_dist,max_dist,falloff_factor);
	            audio_emitter_gain(new_emitter,1);
				var ex = 0,//audio_emitter_pan*((global.xview+(global.wview/2))-x), 
					ey = 0,
					ez = (depth*lerp(1,5,sqr(min(1,abs(depth)/100))));

	            audio_emitter_position(new_emitter,x+ex,y+ey,ez);
				obj.emitter = new_emitter;
				ds_map_Replace(s,"emitter",new_emitter);
				ds_list_add(audio_emitter,new_emitter);
				ds_list_add(audio_emitter_size,emitter_size);
				audio_emitter_n += 1;
	            }
			//show_debug_message("emitter "+string(obj.emitter));
			}
			 obj.threed = true;
		}
	       
	    }
		}
		}
		}
	    
	
		var fadein = ds_map_Find_value(s,"fadein");
		if fadein>0{audio_sound_gain(file,0,0);}
		
			    var file_vol; 
	    if audio_in_editor{
	        file_vol = (ds_map_Find_value(global.audio_asset_vol,audio_get_name(file)))/100;
		
			if ds_map_exists(objAudioEditor.audio_sound_groups,file){
				var agroup = ds_map_find_value(objAudioEditor.audio_sound_groups,file);
				if is_real(agroup) and !audio_group_is_loaded(agroup){
						with(the_audio){
							ds_list_add(audio_loading,agroup);
		                    loading_audio = true;	
						}
				}
			}
		
	    }else{
	        file_vol = (ds_map_Find_value(global.audio_asset_vol,file));
	    }
	    var bus_vol = bus_calculate(bus_id),
	        blend_vol = 1+ds_map_Find_value(s,"blend");
	    ds_map_Replace(s,"bus_vol",bus_vol);
        
	    var current_vol = (ds_map_Find_value(s,"vol")+1)*(file_vol+1)*(bus_vol+1);
	    if is_undefined(current_vol) or is_real(current_vol)==0 {current_vol = 0;}
	    ds_map_add(s,"current_vol",current_vol);
    
	    //show_message(audio_get_name(file)+" blend "+string(blend_vol)+" vol "+string(ds_map_find_value(s,"current_vol"))+
	    //    " = con "+string(ds_map_Find_value(s,"vol"))+" + file "+string(file_vol)+" + bus "+string(bus_vol))
	    //var current_vol = ds_map_find_value(s,"current_vol");
	    //
    
   
	    //show_debug_message("adjusting sound "+ds_map_string(s)+" obj "+string(obj)+" blend "+string(blend_vol)); //yyc crash check
	    //show_debug_message("obj volume "+string(obj.volume)+" fadein "+string(fadein)+" playing "+string(aud_playing));
	    var finalvolumecalc = clamp(current_vol,0,1)*max(0,obj.volume*blend_vol);
	
	    if typ==0 and ds_map_Find_value(con,"contin"){looping = false;}
	    ds_map_replace(s,"loop",looping);
		
		var sync = ds_map_Find_value(s,"sync");
	    if !sync{
			if !threed{
	            aud_playing = audio_play_sound(file,0,looping);
	        }else{
				//show_debug_message("playign "+string(name)+" now from emitter "+string(obj.emitter));
	            aud_playing = audio_play_sound_on(obj.emitter,file,looping,0);
	        }
	    }else{
	        aud_playing = audio_play_in_sync_group(obj.group,file);
	        if ds_map_Find_value(s,"delayin")>0{
	            if !obj.group_delay{
	                obj.group_delay = true;
	                ds_list_add(obj.delay_sounds,s);
	                }
	        }
	    }
    
	    if is_undefined(aud_playing){ds_map_destroy(s); return -1;}
		
		ds_map_add(s,"aud",aud_playing);
	    if sync{aud_playing = file;}
	        //lerp(0,min(1,max(0,current_vol)),obj.volume*blend_vol);
	    //show_debug_message("final calc "+string(finalvolumecalc));
		
		if test_vibration_vol{
			//show_debug_message("vibrate gain set to "+string(finalvolumecalc));	
		}
		
	    if fadein>0{
	        audio_sound_gain(aud_playing,0,0);
	        audio_sound_gain(aud_playing,finalvolumecalc,fadein*1000);
			audio_sound_gain(file,1,0); ///???
	    }else{
	        audio_sound_gain(aud_playing,finalvolumecalc,0);
	    }
    
	    audio_sound_pitch(aud_playing,1+ds_map_Find_value(s,"pitch"));
		
		
	
		if ds_map_Find_value(s,"randstart"){
			audio_sound_set_track_position(aud_playing,random(audio_sound_length(aud_playing)));
		}else{
			var st = ds_map_Find_value(s,"starttime");
			if st>0{
				audio_sound_set_track_position(aud_playing,st);
			}
		}
    
	    if !ds_map_Find_value(s,"tail"){ //tails dont get tracked or updated
	        //ds_map_add(s,"aud",aud_playing);
	        ds_list_add(obj.playing, s); //once was list_add_map but it was janky between updates
	        //show_message(string(s)+": "+string(ds_exists(s,ds_type_map)));
	    }else{
	        ds_map_destroy(s);
	    }
	    }else{ds_map_destroy(s);}
	}



}
