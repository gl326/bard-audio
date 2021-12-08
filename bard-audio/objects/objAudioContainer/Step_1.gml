//parameter update
if deleted{
	instance_destroy();
	exit;
}

if !paused{
var update_sound = true; 


if bpm>0{
if !ds_list_empty(playing){
	if bpm>0 and !varyingbpm{
		//if delta_time>(500000){
		//	start_time += (delta_time/1000);
		//	beat_time += 1000/60;
		//}else{
			beat_time += delta_time/1000;
		//}
	    //add half a frame of time
	    var beatcalc = beat_start + (current_time+(1000/(room_speed*2))-start_time)/1000/60*bpm*pitch,
	        beat = floor(beatcalc),
			new_beat = (beat!=beat_p);
		if !new_beat{was_beat = false;}
		else{
			if was_beat{
				new_beat = false;
			} //beats on consecutive frames are discarded, game maker was buggy with this
			else{was_beat = true;}
			}
		had_new_beat = (new_beat and !first_beat);
		if had_new_beat{
			beats = beat;	
		}
	    if music{
			the_audio.music_bpm = bpm*pitch;
	        the_audio.container_has_beat = true;
	        the_audio.beat_event = had_new_beat;
	        if new_beat{
					if !first_beat{
							//beats += 1;
							//if delta_time>(500000){
								beats = beat;
							//}
							//show_debug_message("beat updated from nonvarying container! t:"+string(current_time/500));
						}
				beat_time = 0;
			}
	       the_audio.measure_event = the_audio.beat_event and ((beats mod the_audio.beat_count)==0);
	       the_audio.measure = floor(beats/the_audio.beat_count);
		   // if the_audio.measure_event{the_audio.measure += 1;}
	        the_audio.beat = beats;
	        the_audio.beat_time = beat_time;
			the_audio.beat_prog = beatcalc;//beats+(beat_time/beatMs());
			
	        if the_audio.beat_event{
	            the_audio.doublebeated = false;
	            the_audio.doublebeat_event = true;
	        }else{
	            if !the_audio.doublebeated and round(beatcalc)!=beat_p{
	                the_audio.doublebeated = true;
	                the_audio.doublebeat_event = true;
	            }else{
	                the_audio.doublebeat_event = false;
	            }
	        }
        
	        }  
	    if new_beat{
	        first_beat = false;
	        }
		//else{update_sound = false;} //stop music from updating except on beat events?
			//good idea on paper which we tried in wandersong
			//but in practice it was better for us to handle the timing of parameter changes manually
			//so some happened on beats (like section changes) but some were smooth (like fades).
	    beat_p = beat;
	}

	if varyingbpm and music{
	    var beat,nbeat,beatcalc,dbeat;
	    if group_playing and group!=-1{
			var group_pos = audio_sync_group_get_track_pos(group);
			///here because of game maker bug, ideally can be removed later
			if abs(group_pos-group_track_pos)<2{
				group_track_pos = max(group_pos,group_track_pos);
			}else{
				group_track_pos = group_pos;	
			}
			beatcalc = group_track_pos/(60/bpm);
	    }else{
	    var snd = ds_list_find_value(playing,0),
	        aud = ds_map_find_value(snd,"aud");
			///here because of game maker bug, ideally can be removed later
			var group_pos = audio_sound_get_track_position(aud);
			if fake_sync{
				if group_pos<group_track_pos and abs(group_pos-group_track_pos)>2{
					for(var i=1;i<ds_list_size(playing);i+=1){
						var faud = ds_map_find_value(ds_list_find_value(playing,i),"aud");
						audio_sound_set_track_position(faud,group_pos);
					}
				}
			}
		
			if abs(group_pos-group_track_pos)<2{
				group_track_pos = max(group_pos,group_track_pos);
			}else{
				group_track_pos = group_pos;	
			}
			beatcalc = group_track_pos/(60/bpm);
	    }
		beatcalc += beat_start;//container_attribute(container,"beatstart");
		
		dbeat = floor(beatcalc*2);
		beat = floor(beatcalc);
		var nbeat = (beat!=beat_p),
			ndbeat = (dbeat!=dbeat_p);
		if nbeat{
			if was_beat{nbeat = false;}
			else{was_beat = true;}
		}else{
			was_beat = false;	
		}
	
	        the_audio.music_bpm = bpm*pitch;
	        the_audio.container_has_beat = true;
	        the_audio.beat_event = nbeat;
	        if nbeat or ndbeat{
	            the_audio.doublebeat_event = true;
	           // the_audio.doublebeated = false;
	        }else{
	           // if ndbeat{
	            //    the_audio.doublebeat_event = true;
	           //     the_audio.doublebeated = true;
	           // }else{
	                the_audio.doublebeat_event = false;
	           // }
	        }
        
	        if nbeat{
					beats += 1; beat_time = 0;
					if delta_time>(500000){
								beats = beat;
							}
					//show_debug_message("beat updated from varying container! t:"+string(current_time/500)+" g:"+string(group_pos));
					}
	        the_audio.measure_event = (nbeat and (beat mod the_audio.beat_count)==0);
	        the_audio.measure = floor(beat/the_audio.beat_count);
	        the_audio.beat = beats;
	        the_audio.beat_time = beat_time;
			the_audio.beat_prog = beatcalc;//beats+(beat_time/beatMs());
	    beat_p = beat;
		dbeat_p = dbeat;
	}
}
}

if group_playing and group!=-1{
    if !audio_sync_group_is_playing(group){
        group_playing = false;
        audio_destroy_sync_group(group);
        group = -1;
        }
}


//cull sounds no longer playing
//if group==-1 or !group_playing{
var n = ds_list_size(playing),
	//pos=0,
	//dopos = update_sound and bpm>0,
    n2 = ds_list_size(delay_sounds);
if n+n2==0 and !group_playing and !group_delay// and spec_time<=0
{am_playing = false;}


for(var i=0;i<n;i+=1){
    var s = ds_list_find_value(playing,i),
        aud = ds_map_find_value(s,"aud");
		
	//weird rare error some user(s) see?? from out of memory maybe? try to handle that
	if os_type==os_ps4 or debug_mode{
		if !ds_exists(s,ds_type_map){
			ds_list_delete(playing,i);
			break;
		}else{
			if is_undefined(aud){
				container_map_clean(s);
				ds_list_delete(playing,i);
				break;
			}
		}
	}

    if !audio_is_playing(aud) and !((group_playing or group_delay) and ds_map_Find_value(s,"sync")){
		var idd = ds_map_find_value(s,"playid");
		if ds_map_exists(unique_param_settings,idd) and ds_list_find_index(unique_param,idd)==-1{
			ds_map_delete(unique_param_settings,idd);
		}
		var dind = ds_list_find_index(delayout_sounds,s);
		if dind!=-1{
			show_debug_message(audio_get_name(ds_map_find_value(s,"file"))+" ("+string(s)+") stopped playing while waiting to delayout? : "+stacktrace_to_string());
			ds_list_delete(delayout_sounds,dind);
		}
		
		if music and varyingbpm and i==0 and n>1{
			//var beatl = round(container_attribute(container,"lpdelayin",id)/(bpm/60));
			//beat_start += beatl;
			//while(beat_start<0){beat_start += 4;}
			if name=="music_boss2_2"{
				beat_start += 2;	
			}
		}
		
		container_map_clean(s);
        ds_list_delete(playing,i);
		
        i-=1;
        n-=1;
        if auto_play and (
            index<ds_list_size(container_contents(container)) or ds_map_Find_value(container,"loop")
            ){
            if !spec_snd{
				instance_activate_object(owner);
                container_play(container,1);
            }
        }else{
            if n+n2<=0 and !group_playing and !group_delay// and spec_time<=0
			{
				am_playing = false;
				if is_equal(the_audio.music_scene,container_name(container)){
					music_scene_set(-4);
				}
				}
        }
    }
}

//update parameters
if update_sound and live_update and parameters_updated>0 and !ds_list_empty(playing){
	repeat(parameters_updated){ //usually 1, but when setting unique parameters this happens once for each unique one to get the different sound sets
			var uniquep = -1,found = false;
			if !ds_list_empty(unique_param){
				uniquep = ds_list_find_value(unique_param,0);
				//ds_list_delete(unique_param,0);
				var umap = unique_param_settings[?uniquep],
					cmap = global.audio_param_copy_map;
				if is_undefined(umap) or !ds_exists(umap,ds_type_map){
					ds_list_delete(unique_param,0);
					break;
				}else{
					ds_map_copy(cmap,umap);
					var k = ds_map_find_first(cmap),
						kn = ds_map_size(cmap);
					repeat(kn){
						cmap[?k] = global.audio_state[?k];
						global.audio_state[?k] = umap[?k];
						k = ds_map_find_next(cmap,k);	
					}
					ds_list_replace(unique_param,0,cmap);
				}
				//ds_map_destroy(umap);
			}
			var playlist = ds_list_create();
			ds_list_copy(playlist,playing);
			ds_list_add_to_list(delay_sounds,playlist);
            var nn=ds_list_size(playlist);
            if !simple_sound{
                for(var j=nn-1;j>=0;j-=1){
                    var aud = ds_list_find_value(playlist,j);
                    if ds_map_exists(aud,"index"){
                        ds_map_replace(global.audio_list_index,ds_map_find_value(aud,"container"),ds_map_find_value(aud,"index"));
                    }
                }
            }
            
			
            var ulist = list_Create();
            var idmap = container_map_create();
            containerSounds(container,ulist,-1,id,idmap);
            var naud = ds_list_find_value(ulist,0);
            
            for(var j=0;j<nn;j+=1){
                var aud = ds_list_find_value(playlist,j),
					idd=-1;
                if !simple_sound{
                    idd=ds_map_find_value(aud,"id");
                    naud = ds_map_Find_value(idmap,idd);
                }
                if ds_list_find_index(fadeout_sounds,ds_map_find_value(aud,"aud"))==-1 //not fading out already
                and (uniquep==-1 or ds_map_find_value(aud,"playid")==uniquep){
                /*
                var dstr= "",nnn=ds_list_size(ulist);
                for(var k=0;k<nnn;k+=1){
                    var a = ds_list_find_value(ulist,k);
                    dstr+=ds_map_find_value(a,"id")+","
                    if ds_map_find_value(a,"id")==idd{naud = a; break;}
                }*/
                //show_debug_message("found "+ds_map_string(naud)+" looking for "+ds_map_string(aud)+" in #"+ds_map_string(idmap));
                /////////////
                
                if naud!=0{ //kind of hacky
					found = true;
                        //debug_1 = "from "+string(ds_map_Find_value(aud,"vol"))+" to "+string(ds_map_Find_value(naud,"vol"));
                    ds_map_copy_keys_excepting(aud,naud,"ind","aud","playstart","playid","delayout",
						"current_vol","bus_vol");
                    var snd = ds_map_find_value(aud,"aud"), file = ds_map_find_value(aud,"file");
                    if ds_map_Find_value(aud,"sync"){snd = file;}
					
					if !is_undefined(snd){
	                        var file_vol = (ds_map_Find_value(global.audio_asset_vol,file)),
	                            bus_vol = ds_map_find_value(aud,"bus_vol");
	                        if audio_in_editor{file_vol = (ds_map_Find_value(global.audio_asset_vol,audio_get_name(file)))/100;}
							var current_vol = (ds_map_Find_value(aud,"vol")+1)*(file_vol+1)*(bus_vol+1);
	                        ds_map_replace(aud,"current_vol",current_vol);
	                        audio_sound_gain(snd,lerp(0,clamp(current_vol,0,1),QuadInOut(volume)*(1+ds_map_Find_value(aud,"blend"))),0);
	                    audio_sound_pitch(snd,1+ds_map_Find_value(aud,"pitch"));
					}
                    
                    var pp = pitch;
                    pitch = 1+(container_attribute(container,"pitch")/100);
                    if pitch!=pp and bpm>0{
                        first_beat = true;
                        }
                    }
                }
            }
            
            container_map_clean(idmap);
			
            var un = ds_list_size(ulist);
            for(var j=0;j<un;j+=1){
				var cm = ds_list_find_value(ulist,j);
                container_map_clean(cm);
            }
            
            ds_list_destroy(ulist);
			ds_list_destroy(playlist);
			
			//set global param to its previous state
			if !ds_list_empty(unique_param){
				var cmap = ds_list_find_value(unique_param,0);
				ds_list_delete(unique_param,0);
				var k = ds_map_find_first(cmap),
					kn = ds_map_size(cmap);
				repeat(kn){
					global.audio_state[?k] = cmap[?k];
					k = ds_map_find_next(cmap,k);	
				}
				
				if !found and ds_map_exists(unique_param_settings,uniquep){ //there was an update but no sunds to match
					ds_map_delete(unique_param_settings,uniquep);
				}
			}
	}
	parameters_updated = 0;
}

//update bus volumes
if update_sound{
var bn = !ds_list_empty(bus_update);
if bn{
    var n = ds_list_size(playing);
        for(var i=0;i<n;i+=1){
            var s = ds_list_find_value(playing,i),
                b = ds_map_Find_value(s,"bus");
            if ds_list_find_index(bus_update,b)!=-1{
                    //if is_equal(bus,b){
                        var ng = bus_gain(b),
                            bp = ds_map_Find_value(s,"bus_vol"),
                            snd = ds_map_find_value(s,"aud");
                    if ng!=bp{
                        var file = ds_map_find_value(s,"file");
                        if ds_map_Find_value(s,"sync"){snd = file;}
                        if ds_list_find_index(fadeout_sounds,snd)==-1 or ds_map_Find_value(s,"sync"){ //not fading out already
                            var file_vol = (ds_map_Find_value(global.audio_asset_vol,file)),
                                bus_vol = ng;
                            if audio_in_editor{file_vol = (ds_map_Find_value(global.audio_asset_vol,audio_get_name(file)))/100;}
                            ds_map_replace(s,"current_vol",(ds_map_Find_value(s,"vol")+1)*(file_vol+1)*(bus_vol+1));
                            //ds_map_replace(s,"current_vol",ds_map_find_value(s,"current_vol")*(ng+1)/(bp+1)); //old (bad) way
							var newFinalVol = lerp(0,clamp(ds_map_find_value(s,"current_vol"),0,1),QuadInOut(volume)*(1+ds_map_Find_value(s,"blend")));
                            audio_sound_gain(snd,newFinalVol,0);
                            ds_map_Replace(s,"bus_vol",bus_vol);
                        }
                    }
                //}
                }
            }

ds_list_clear(bus_update);
}
}

if fading_out>0{
	volume -= fading_out;
	if volume<=0{
		instance_destroy();
		exit;
	}
}

//object volume change
container_update_volume();

////delay sounds
var dn = ds_list_size(delay_sounds);
for(var i=0;i<dn;i+=1){
    var s = ds_list_find_value(delay_sounds,i);
    //var del = ds_map_Find_value(s,"delayin") - (delta_time/1000000);//(1/room_speed);
    //if del>0{ds_map_Replace(s,"delayin",del);}
    //else
    if current_time >= ds_map_find_value(s,"playstart")+(ds_map_find_value(s,"delayin")*1000)
    {
        if ds_map_Find_value(s,"sync") and group!=-1{
            if group_delay{
                group_playing = true;
                audio_start_sync_group(group);
                group_delay = false;
				group_track_pos = 0;
            }
        }else{
            container_sound_play(s,container,id);
			if music{
				group_track_pos = 0;	
			}
			if spec_snd{
				var my_id = ds_map_Find_value(s,"playid"),
					old_l = dn;	
				container_play(container,1);
				dn = ds_list_size(delay_sounds);
				for(var ni=old_l;ni<dn;ni+=1){
					var ns = ds_list_find_value(delay_sounds,ni);
					ds_map_Replace(ns,"playid",my_id);
				}
			}
        }
        ds_list_delete(delay_sounds,i);
		dn -= 1;
        i -= 1;
        }
}

///delayout sounds
var n = ds_list_size(delayout_sounds);
        for(var i=0;i<n;i+=1){
            var s = ds_list_find_value(delayout_sounds,i);
            if ds_exists(s,ds_type_map){
                var delay = ds_map_Find_value(s,"delayout") - (global.FTD/room_speed);
                if delay<=0{
                    if ds_map_Find_value(s,"fadeout")<=0{
                        audio_stop_sound(ds_map_find_value(s,"aud")); //they will delete on their own
                    }else{
                        audio_sound_gain(ds_map_find_value(s,"aud"),0,ds_map_Find_value(s,"fadeout")*1000);
                        ds_list_add(fadeout_sounds,ds_map_find_value(s,"aud"));
                    }
					container_map_clean(s);
                    ds_list_delete(delayout_sounds,i);
                    i-=1; n-=1;
                }else{
                    ds_map_Replace(s,"delayout",delay)
                }
            }else{
                ds_list_delete(delayout_sounds,i);
                i-=1; n-=1;
            }
        }
        
///end faded out sounds
if update_sound{
	var fon = ds_list_size(fadeout_sounds);
	for(var i=0;i<fon;i+=1){
	    var a = ds_list_find_value(fadeout_sounds,i);
	    if audio_sound_get_gain(a)<.01{
	        audio_stop_sound(a);
	        ds_list_delete(fadeout_sounds,i);
	        i -= 1;
			fon -= 1;
	    }
	}
}

if persistent and (audio_in_editor or (!am_playing and ds_list_empty(delayout_sounds))){
	instance_destroy();	//controversial????
}
}

/* */
/*  */
