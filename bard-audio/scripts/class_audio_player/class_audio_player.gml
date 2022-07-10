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
parameters = container.get_parameters();//map_Create(); //parameters our sounds are dependent on (watch them for updates)
parameters_update = [];
parameters_updated = false;

unique_param_settings = ds_map_create_pooled(); 

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

playid = -1; //each time we are played, this increments so the sounds playing together have the same id
am_playing = false;

//track events
was_beat = false;
beat_event = false;
dbeat_event = false;
measure_event = false;
beats_per_measure = container.beats_per_measure;

bpm = container.bpm;
beat_start = container.beatstart; //what beat does the song start on (ie. a 1-beat pickup on a 4-beats-per-measure song might be said to start on beat -1)
beats = beat_start;
measures = floor(beats/beats_per_measure);
time_in_beats = 0;

spec_snd = (container.specmax>0 or container.specmin>0);

space_rand = false;

threed = false;

parent = noone; 

seed = -1;

start_time = 0;
beat_p = -1;
dbeat_p = -1;

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

DELETED = false;

#endregion

array_push(global.audio_players,self); //track me!

static param_update = function(param){
	 if (!parameters_updated and array_find_index(parameters,param)!=-1){
	    parameters_updated = 1; //queue my containers to be recalculated in the next update cycle
	 }	
}

static bus_updated = function(bus_name){
	                if array_find_index(audio_busses,bus_name)!=-1{
						if array_find_index(bus_update,bus_name)==-1{
							array_push(bus_update,bus_name);
						}
	                }
}

static pause = function(){
	if !paused{
		paused = true;
		paused_time = current_time;
		
		var i=0;
		repeat(array_length(playing)){
			audio_pause_sound(playing[i].aud);
			i ++;
		}
	}
}

static unpause = function(){
	if paused{
		paused = false;
			var i=0;
			repeat(array_length(playing)){
			    audio_resume_sound(playing[i].aud);
				i ++;
			}
		
			i = 0;
			repeat(array_length(delay_sounds)){
			    var s = delay_sounds[i];
				var st = s.playstart;
				s.playstart = st-(paused_time-current_time);
				
				i++;
			}
	}
}

static play = function(option=false,_playedBy=noone){
	playid += 1;
	seed = random_get_seed();
	am_playing = true;
	
	if !is_struct(_playedBy) and _playedBy!=noone{owner = _playedBy;}

	var playlist = container.create_instances(option);

	if sync{
		if !DISABLE_SYNCGROUPS{
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
	auto_play = (container.type==CONTAINER_TYPE.CHOICE and container.contin);
	
	if group!=-1 and group_delay{
	    audio_start_sync_group(group);
	    group_playing = true;
		group_track_pos = 0;
	    }
		
	start_time = current_time;
	//first_beat = true; //?
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

//this is called from container_pitch_note
//it basically just exists for that purpose... fyi
static pitch_sounds = function(perc,playID=-1){
			live_update = false;
		
			var i = 0;
			repeat(array_length(playing)){
			    var s = playing[i];
				if (playID==-1 or s.playid==playID){
				    audio_sound_pitch(s.aud,1+(perc/100));
				}
				
				i++;
			}	
}

static get_time = function(){
			var n = array_length(playing);
			if n{
			   return audio_sound_get_track_position(playing[0].aud); //return 1st one
			}
			return -1;
}

static set_time = function(timeInSecs){
			var i=0;
			repeat(array_length(playing)){
			    audio_sound_set_track_position(playing[i].aud,timeInSecs);
				i ++;
			}
		
			i = 0;
			repeat(array_length(delay_sounds)){
				delay_sounds[i].playstart = current_time - (timeInSecs*1000);
				i ++;
			}	
}

static align_time = function(){
			var i = 0,
				t = -1;//get_time = 0;
			repeat(array_length(playing)){
			    var s = playing[i],
			        aud = s.aud;
				if t==-1{
					t = audio_sound_get_track_position(aud); //return 1st one
				}else{
					if abs(audio_sound_get_track_position(aud)-t)>.05{
						audio_sound_set_track_position(aud,t);
					}
				}
				
				i++;
			}
}

static get_beatEvent = function(){
	return beat_event; //?	
}
static get_doubleBeatEvent = function(){
	return dbeat_event; //?	
}
static get_measureEvent = function(){
	return measure_event; //?	
}
static get_bpm = function(){
	return bpm*pitch; //?	
}
static get_beat = function(){ //what integer beat of the song are we on
	return beats; 	
}
static get_measure = function(){ //what integer measure of the song are we on
	return measures; 	
}
static get_time_in_beats = function(){ //get the exact fractional value of where in the song we are measured in beats
	return time_in_beats;	
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
				if array_find_index(unique_param,playID)==-1{
					array_push(unique_param,playID);
					parameters_updated += 1;
				}
			}
}

#region update functions
static update_bpm = function(ms_passed = (current_time - time_p)){
		if bpm>0{
		if array_length(playing){
		    var beat,nbeat,beatcalc,dbeat;
		    if group_playing and group!=-1{ //audio sync group
				var group_pos = audio_sync_group_get_track_pos(group);
				
				///here because of game maker bug, ideally can be removed later
				if abs(group_pos-group_track_pos)<2{
					group_track_pos = max(group_pos,group_track_pos);
				}else{
					group_track_pos = group_pos;	
				}
				group_track_pos += snd.delayin;
				
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
					group_track_pos += snd.delayin;
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
		        beat_event = nbeat;
		        dbeat_event = (nbeat or ndbeat);
        
		        if nbeat{
						beats += 1; 
						if delta_time>(500000){
									beats = beat;
								}
						//show_debug_message("beat updated from varying container! t:"+string(current_time/500)+" g:"+string(group_pos));
						}
		        measure_event = (nbeat and (beats mod beats_per_measure)==0);
				
		        measures = floor(beats/beats_per_measure);
		        time_in_beats = beatcalc;
				//////// susss of this ////////////////////////////
			
		    beat_p = beat;
			dbeat_p = dbeat;
		
	}
	}
}

static update_amplaying = function(){
	var _n = array_length(playing),
	    n2 = array_length(delay_sounds);
	
	if group_playing and group!=-1{
	    if !audio_sync_group_is_playing(group){
	        group_playing = false;
	        audio_destroy_sync_group(group);
	        group = -1;
	        }
	}


	if _n+n2==0 and !group_playing and !group_delay
	{
		am_playing = false;
	}

	var i = 0;
	repeat(_n){
		var s = playing[i];
		if !playing[i].isPlaying() and !((group_playing or group_delay) and s.sync){
			var idd = s.playid;
			if ds_map_exists(unique_param_settings,idd) and array_find_index(unique_param,idd)==-1{
				ds_map_delete(unique_param_settings,idd);
			}
			var dind = array_find_index(delayout_sounds,s);
			if dind!=-1{
				//show_debug_message(audio_get_name(s.file)+" ("+string(s)+") stopped playing while waiting to delayout? : "+stacktrace_to_string());
				array_delete(delayout_sounds,dind,1);
			}
		
			s.destroy(self);
			_n -= 1;
		
	        if auto_play and (index<array_length(container.contents) or container.loop){
	            if !spec_snd{
	                play(true);
	            }
	        }else{
	            if _n+n2<=0 and !group_playing and !group_delay// and spec_time<=0
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
}

static update_params = function(){
	var _n = array_length(playing);
	if live_update and parameters_updated>0 and _n{
	repeat(parameters_updated){ //usually 1, but when setting unique parameters this happens once for each unique one to get the different sound sets
			var uniquep = -1,found = false;
			if array_length(unique_param){
				uniquep = unique_param[0];
				//ds_list_delete(unique_param,0);
				var umap = unique_param_settings[?uniquep],
					cmap = global.audio_param_copy_map;
				if is_undefined(umap) or !ds_exists(umap,ds_type_map){
					array_delete(unique_param,0,1);
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
					unique_param[0] = cmap;
				}
				//ds_map_destroy(umap);
			}
			var p_l = array_length(playing),
				d_l = array_length(delay_sounds),
				nn=p_l+d_l,
				playlist = array_create(nn);
			array_copy(playlist,0,playing,0,p_l);
			array_copy(playlist,p_l,delay_sounds,0,d_l);
			//ds_list_add_to_list(delay_sounds,playlist);
            if !simple_sound{
                for(var j=nn-1;j>=0;j-=1){
                    var aud = playlist[j];
                    //if ds_map_exists(aud,"index"){
                        ds_map_replace(global.audio_list_index,aud.container.name,aud.index);
                    //}
                }
            }
            
			
			var ulist = container.create_instances(),
				unum = array_length(ulist);
            var naud = ulist[0];
            
            for(var j=0;j<nn;j+=1){
                var aud = playlist[j],
					idd = -1;
                if !simple_sound{
                    idd = aud.instid;
					var _a = 0,
						naud = undefined;
					repeat(unum){
						if ulist[_a].instid==idd{
							naud = ulist[_a];
							break;	
						}
						_a ++;	
					}
					if _a>=unum{
						continue; //no match found for me, somehow
					}
                }
                if (uniquep==-1 or aud.playid==uniquep) //if i match the specific playid that is updating, or none was specified,
				and array_find_index(fadeout_sounds,aud.aud)==-1 //and i'm not fading out already
					{
					found = true;
					aud.copy_from(naud);
                    var snd = aud.aud, 
						file = aud.file;
                    if aud.sync{snd = file;}
					
					if !is_undefined(snd){
							aud.update_current_volume(volume);
							aud.update_current_pitch();
					}
                }
            }
			
			//reset beat if container pitch changed
			        //var pp = pitch;
                   // pitch = 1+(container.pitch/100);
                    //if pitch!=pp and bpm>0{
                       // first_beat = true;
                       // }
			
			//set global param to its previous state
			if array_length(unique_param){
				var cmap = unique_param[0];
				array_delete(unique_param,0,1);
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
}
	
static update_bus = function(){
		var bn = array_length(bus_update);
		if bn{
		    var n = array_length(playing);
		        for(var i=0;i<n;i+=1){
		            var s = playing[i],
		                b = s.bus;
		            if array_find_index(bus_update,b)!=-1{
		                    //if is_equal(bus,b){
		                        var ng = bus_gain_current(b),
		                            bp = s.bus_vol;
		                    if ng!=bp{
		                        if array_find_index(fadeout_sounds,s)==-1 or s.sync{ //not fading out already
									s.bus_vol = ng;
									s.update_current_volume(volume);
		                        }
		                    }
		                //}
		                }
		            }

		bus_update = [];
		}
	
	}
	
static update_delayin = function(){
	var dn = array_length(delay_sounds);
	var i = 0;
	repeat(dn){
	    var s = delay_sounds[i];
	    if current_time >= s.playstart+(s.delayin*1000)
	    {
	        if s.sync and group!=-1{
	            if group_delay{
	                group_playing = true;
	                audio_start_sync_group(group);
	                group_delay = false;
					group_track_pos = 0;
	            }
	        }else{
				s.play(self);

				if spec_snd{
					//play me again!
					var my_id = s.playid,
						old_l = dn;	
					play(1);
				
					//but pass the play id of the summoner onto its children
					dn = array_length(delay_sounds);
					for(var ni=old_l;ni<dn;ni+=1){
						delay_sounds[ni].playid = my_id;
					}
				}
	        }
	        array_delete(delay_sounds,i,1);
	    }else{
			i ++;	
		}
	}	
}
	
static update_delayout = function(){
		var i = 0;
		repeat(array_length(delayout_sounds)){
		     var s = delayout_sounds[i];
		                var delay = (s.delayout) - (ms_passed/1000);
		                if delay<=0{
		                    if s.fadeout<=0{
		                        audio_stop_sound(s.aud); 
		                    }else{
		                        audio_sound_gain(s.aud,0,s.fadeout*1000);
		                        array_push(fadeout_sounds,s.aud);
		                    }
		                    array_delete(delayout_sounds,i,1);
		                }else{
		                    s.delayout = delay;
							i ++;
		                }
		        }	
	}
	
static update_fadeout = function(){
	var i = 0;
	repeat(array_length(fadeout_sounds)){
		    var a = fadeout_sounds[i];
		    if audio_sound_get_gain(a)<.01{
		        audio_stop_sound(a);
		        array_delete(fadeout_sounds,i,1);
		    }else{
				i ++;	
			}
		}	
}
	
static update_volume = function(){
	if volume!=volume_p{
	    volume_p = volume;
	    var i = 0;
	    repeat(array_length(playing)){
	        var s = playing[i];
	        var snd = s.aud;
	        if array_find_index(fadeout_sounds,snd)==-1{ //not fading out already
	            s.update_current_volume(volume);
	        }
			i ++;
	    }
	}
}

static update = function(){
	var ms_passed = current_time-time_p;
	time_p = current_time;

	if !paused{
		//track bpm and beats
		update_bpm(ms_passed);

		//cull sounds no longer playing
		update_amplaying();

		//update parameters
		update_params();

		//update bus volumes
		update_bus();

		//update fadeout, potentially destroy
		if fading_out>0{
			volume -= ms_passed/(fading_out*1000);
			if volume<=0{
				return destroy();
			}
		}

		//object volume change
		update_volume();

		////delay sounds, ie. sounds that dont start until some time has passed after we told them to play.
		update_delayin();

		///delayout sounds, ie sounds that dont stop until some time has passed after we told them to stop
		update_delayout();
        
		///end faded out sounds
		update_fadeout();

		if persistent and (audio_in_editor or (!am_playing and !array_length(delayout_sounds))){
			return destroy(); //nothing playing, so clean me up
		}
	}

	return true;
}
#endregion

static stop = function(sid=-1,option=false){
	    if group!=-1{
	        audio_stop_sync_group(group);
	        group_playing = false;
	        audio_destroy_sync_group(group);
	        group = -1;
	        group_delay = false;
	        //obj.am_playing = false;
	    }
	    //else{
	        var n = array_length(playing),
				stopped = true,
				i=0;
	        repeat(n){
	            var s = playing[i];
	            if sid>-1{
	                if s.playid!=sid{
						i ++;
	                    stopped = false;
	                    continue;
	                }
	            }
	            if option and s.loop==0{
					if option<2{
						audio_sound_gain(s.aud,clamp(s.current_vol,0,1)/2,100); //!
		                i ++;
		                continue;
					}else{
						if s.fadeout<=0{
							audio_sound_gain(s.aud,0,200); //no matter how long it is, causes clips sometimes
							i ++;
							continue;
						}
					}
	            }
				
	            if s.delayout<=0{
					if s.fadeout<=0{
	                    audio_stop_sound(s.aud);
	                }else{
	                    audio_sound_gain(s.aud,0,s.fadeout*1000);
	                    array_push(fadeout_sounds,s.aud);
	                }
	            }else{
	                array_push(delayout_sounds,s);
	            }
				
				array_delete(playing,i,1);
	        }

			var n = array_length(delay_sounds);
			if sid>-1{
				var i=0;
		        repeat(n){
					var s = delay_sounds[i];
					if s.playid!=sid{
	                    stopped = false;
						i ++;
	                    continue;
	                }else{
						array_delete(delay_sounds,i,1);
					}
				}
			}else{
				delay_sounds = [];
			}
	        
			am_playing = !stopped;
	    //}
	    if container.type==CONTAINER_TYPE.CHOICE{
	        if container.contin{
	            index = 0;
	            auto_play = false;
	        }
	    }
	    if container.type==CONTAINER_TYPE.HLT and !option{ //looop tail
	        play(1);
	    }
	return 1;
}

static destroy = function(_hard_stop = false){
	if !DELETED{
		//stop all sounds that marked as looping
		var _i=0;
		repeat(array_length(playing)){
			var s = playing[_i];
			if s.loop or _hard_stop{
				audio_stop_sound(s.aud);
			}
			_i ++;
		}
		//non-looping sounds can be allowed to play out, usually better than cutting them off.
		//but they could be cut off with a stop() if you want first.
	
		ds_map_destroy_pooled(unique_param_settings);
	
		array_delete(global.audio_players,array_find_index(global.audio_players,self),1); //stop tracking me
	
		//once this function is called, this player will stop updating and will be missing some internal data.
		//if you have a reference to it from outside the system somehow, then it will stay alive in memory and honor that reference.
		//IF you are doing that, this var will let you know that it wants to die
		//even if you play the same container again with container_play(), that will spawn a new player which you would want to start referencing instead
		DELETED = true; 
	}
	return false;
}
}

