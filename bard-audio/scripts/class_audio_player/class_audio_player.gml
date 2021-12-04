// this manages audio that is actively being played.
// it tracks the current state of sounds that are playing and handles things like timed fadeouts and tracks bpm, etc.
// each player handles just one audiocontainer and all its associated sounds
function class_audio_player(_container) constructor{
container = _container;
name = _container.name;

#region vars
//show_debug_message(string(id)+" user event 0");
/**/
playing = []; //currently playing sounds + attributes
parameters = [];//map_Create(); //parameters our sounds are dependent on (watch them for updates)
parameters_update = [];
parameters_updated = false;

unique_param_settings = ds_map_create(); //rethink

index = 0;
firstplay = false;
persistent = false;

delay_sounds = []; //souns that are waiting to play
delayout_sounds = []; //sounds that are waiting to stop?
fadeout_sounds = [];

audio_busses = []; //busses that are relevant to me
bus_update = []; //busses that are updated each frame

randomed = false;
auto_play = false;

group_delay = false;
group_loop = 0;

owner = noone;

simple_sound = true; //when true, each sound "instance" is just one audio file so we can update params faster

play_id = -1; //each time we are played, this increments so the sounds playing together have the same id
was_beat = false;
am_playing = false;

	    bpm = container.bpm;
	    varyingbpm = container.varybpm;
		//spec_time = random_range(container_attribute(container,"specmin"),container_attribute(container,"specmax"));
	
		beat_start = container.beatstart;
		beats = beat_start;
		spec_snd = (container.specmax>0 or container.specmin>0);
		
		///////not sure this is necessary//////
	    if container.music{
	        music = true;
			group_track_pos = 0;
			the_audio.measure = 0;
	    }else{music = false;}
		////////

space_rand = false;

threed = false;

parent = noone; 

seed = -1;

start_time = 0;
beat_p = -1;
dbeat_p = -1;
beat_time = 0;
first_beat = true;
had_new_beat = false;

time_p = current_time;

pitch = 1;

spot_size = 0;
spot_atten = 0;

unique_param = [];

sync = false;
group = -1;
group_playing = false;
group_track_pos = 0;

live_update = true; //when off, i dont check parameters after starting

fake_sync = false;

aemitter_size = 0;
aemitter_atten = 0;
aemitter_pan = 1;

volume = 1; //used for fade in/out during gameplay, etc
volume_p = 1;
fading_out = 0;

emitter = -1; //these are made and maintained by props, but this lets us know if we have one
made_emitter = false;

pitch = 1+(container.pitch/100);

paused = false;
paused_time = current_time;

#endregion

array_push(global.audio_players,self); //track me!

static param_update = function(param){
	 if (!parameters_updated and array_find_index(parameters,param)!=-1){
	    parameters_updated = 1; //queue my containers to be recalculated in the next update cycle
	 }	
}

static play = function(option=false,_playedBy=noone){
	seed = random_get_seed();
	am_playing = true;
	if !is_struct(_playedBy) and _playedBy!=noone{owner = _playedBy;}

	var playlist = container.create_instances(option);

	if sync{
		if !global.DISABLE_SYNCGROUPS{
			group = audio_create_sync_group(group_loop);
		}else{
			fake_sync = true;
		}
	}

	var n = array_length(playlist);
	if n>1{simple_sound = false;}

	var i = 0;
	repeat(n){
		play_instance(playlist[i],option);
		i ++;
	}
	auto_play = (con.type==CONTAINER_TYPE.CHOICE and con.contin);
	
	if group!=-1 and group_delay{
	    audio_start_sync_group(group);
	    group_playing = true;
		group_track_pos = 0;
	    }
		
	start_time = current_time;
	first_beat = true;
	firstplay = true;
	return self;
}

static play_instance = function(inst,option=false){
		if  (inst.delayin<=0 or (!spec_snd and option)) or inst.sync{
	        inst.play(self);
	    }else{
	        array_push(delay_sounds,inst);
	    }	
}

static bus_track = function(busID){
	if array_find_index(audio_busses,busID)==-1{
		array_push(audio_busses,busID)	
	}
}

static get_emitter = function(){
	if emitter==-1 or !audio_emitter_exists(emitter){
		made_emitter = true;
		emitter = audio_emitter_Create();	
	}
	
	return emitter;
}

static get_time = function(){
			var n = array_length(playing);
			if n{
			   return audio_sound_get_track_position(playing[0].aud); //return 1st one
			}
			return -1;
}

static beatEvent = function(){
	return was_beat; //?	
}

static param_set_unique = function(param,newVal,playID){
	newVal = clamp(newVal,0,100);
			var isnew = true;
			if ds_map_exists(unique_param_settings,playID){
				var imap = ds_map_find_value(unique_param_settings,playID);
				if ds_map_exists(imap,param){
					if ds_map_find_value(imap,param)==newv{
						isnew = false;
					}else{
						ds_map_replace(imap,param,newv);	
					}
				}else{
					ds_map_add(imap,param,newv);
				}
			}else{
				ds_map_add_map(unique_param_settings,playID,map_Create(param,newv));	
			}
			
			if isnew{
				if ds_list_find_index(unique_param,playID)==-1{
					ds_list_add(unique_param,playID);
					parameters_updated += 1;
				}
			}
}

static update = function(){
var ms_passed = current_time-time_p;
time_p = current_time;

if !paused{
	
var _n = array_length(playing),
    n2 = array_length(delay_sounds);

//track bpm and beats
if bpm>0{
if _n{
	if bpm>0 and !varyingbpm{
			beat_time += ms_passed;
	    //add half a frame of time to the beat calculation - this way we can estimate if a new beat is going to happen before the next update cycle
		//and have things react as close as possible to the actual exact moment
		
		//we throttle how many times a new beat event can register to be on every other update, so even if something crazy happens you should still have a beat happened frame followed by a beat-didn't-happen frame
	    var beatcalc = beat_start + (current_time+(1000/(room_speed*2))-start_time)/1000/60*bpm*pitch,
	        beat = floor(beatcalc),
			new_beat = (beat!=beat_p);
		if !new_beat{was_beat = false;}
		else{
			if was_beat{
				new_beat = false;
			} //beats on consecutive frames are discarded, weird bugs with this
			else{was_beat = true;}
			}
		had_new_beat = (new_beat and !first_beat);
		if had_new_beat{
			beats = beat;	
		}
		
		///////#music_state//////////////
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
		/////////////
		
	    if new_beat{
	        first_beat = false;
	        }
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
	    var snd = playing[0],
	        aud = snd.aud;
			///here because of game maker bug, ideally can be removed later
			var group_pos = audio_sound_get_track_position(aud);
			if fake_sync{
				if group_pos<group_track_pos and abs(group_pos-group_track_pos)>2{
					for(var i=1;i<array_length(playing);i+=1){
						var faud = playing[i].aud;
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
		beatcalc += beat_start;
		
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
		
			//////// #music_state ////////////////////////////
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
			//////// susss of this ////////////////////////////
			
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
if n+n2==0 and !group_playing and !group_delay
{
	am_playing = false;
}

var i = 0;
repeat(n){
	var s = playing[i];
	if !playing[i].isPlaying() and !((group_playing or group_delay) and s.sync){
		/////unique param stuff...////////
		var idd = s.playid;
		if ds_map_exists(unique_param_settings,idd) and ds_list_find_index(unique_param,idd)==-1{
			ds_map_delete(unique_param_settings,idd);
		}
		var dind = ds_list_find_index(delayout_sounds,s);
		if dind!=-1{
			show_debug_message(audio_get_name(ds_map_find_value(s,"file"))+" ("+string(s)+") stopped playing while waiting to delayout? : "+stacktrace_to_string());
			ds_list_delete(delayout_sounds,dind);
		}
		///////////////////////////
		
		s.destroy(self);
		n -= 1;
		
        if auto_play and (index<array_length(container.contents) or container.loop){
            if !spec_snd{
                play(true);
            }
        }else{
            if n+n2<=0 and !group_playing and !group_delay// and spec_time<=0
			{
				am_playing = false;
				///#music_state
				//if is_equal(the_audio.music_scene,container_name(container)){
				//	music_scene_set(-4);
				//}
			}
        }
    }else{
		i++;
	}
}

//update parameters
if live_update and parameters_updated>0 and n{
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
	                        if !audio_in_editor{file_vol = (ds_map_Find_value(global.audio_asset_vol,audio_get_name(file)))/100;}
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
var bn = !ds_list_empty(bus_update);
if bn{
    var n = ds_list_size(playing);
        for(var i=0;i<n;i+=1){
            var s = ds_list_find_value(playing,i),
                b = ds_map_Find_value(s,"bus");
            if ds_list_find_index(bus_update,b)!=-1{
                    //if is_equal(bus,b){
                        var ng = bus_calculate(b),
                            bp = ds_map_Find_value(s,"bus_vol"),
                            snd = ds_map_find_value(s,"aud");
                    if ng!=bp{
                        var file = ds_map_find_value(s,"file");
                        if ds_map_Find_value(s,"sync"){snd = file;}
                        if ds_list_find_index(fadeout_sounds,snd)==-1 or ds_map_Find_value(s,"sync"){ //not fading out already
                            var file_vol = (ds_map_Find_value(global.audio_asset_vol,file)),
                                bus_vol = ng;
                            if !audio_in_editor{file_vol = (ds_map_Find_value(global.audio_asset_vol,audio_get_name(file)))/100;}
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


if persistent and (audio_in_editor or (!am_playing and ds_list_empty(delayout_sounds))){
	return destroy();	//controversial????
}
}

/* */
/*  */
return true;
}
	
static destroy = function(){
	array_delete(global.audio_players,array_find_index(global.audio_players,self),1);
	return false;
}
}