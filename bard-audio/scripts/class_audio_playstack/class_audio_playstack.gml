// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function class_audio_playstack(_name="", layers=1, _overlaps = false) constructor{
	name = _name; //use for debug
	
	current = array_create(layers,-1);
	queue = array_create(layers,-4);

	playback_gap = 0;
	gap = array_create(layers,0);
	time_p = current_time;
	
	fade_in = 0;
	
	//whether audio can overlap
	//generally for music you want this to be FALSE, and anything else like ambiences you would say TRUE
	//when TRUE, the default behavior is to cross-fade audio as it changes state. 
	//when FALSE, we always patiently wait for the previous audio to end before starting the next one.
	overlaps = _overlaps;
	
	paused = false;
	
	debug_on = false;
	
	array_push(global.audio_playstacks,self); //track me!
	
	//set the gap between stuff being played
	static set_playback_gap = function(timeInSeconds){
		playback_gap = timeInSeconds;
		if debug_on{
			show_debug_message("AUDIO PLAYSTACK: playback gap set to "+string(timeInSeconds));	
		}
		return self;
	}
	
	//adds a default fade in to anything new as it plays
	static set_fade_in = function(timeInSeconds){
		fade_in = timeInSeconds;
		if debug_on{
			show_debug_message("AUDIO PLAYSTACK: fade set to "+string(timeInSeconds));	
		}
		return self;
	}
	
	static set_overlap = function(_trueOrFalse){
		overlaps = _trueOrFalse;	
	}
	
	static get_playing = function(){
		var tier = get_playing_tier();
		if tier>=0{
			return current[tier];	
		}
		return -1;
	}
	
	static get_playing_tier = function(){
		for(var i=array_length(current)-1;i>=0;i-=1){
			var ret = current[i];
			if (is_string(ret)){
				if container_is_playing(ret){
					return i;
				}
			}else if ret==0{
				return i;
			}
		}
		return -1;
	}
	
	static play = function(_container_name,tier=0,fadeOutTime=2,leaveOldPaused=false){
			//empty string is treated as a null instruction
			if is_string(_container_name) and _container_name==""{
				_container_name = -1;	
			}
			
			if debug_on{
				show_debug_message("======= AUDIO PLAYSTACK: trying to add new queue item "+string(_container_name));	
			}
		
			//chekc if we like this input
			if !is_string(_container_name) //is it the name of a container?
			and _container_name!=-1 //'null' indicating that this layer doesnt have any instruction
			and _container_name!=0{ //'silent' meaning we want to explicitly play nothing
				if debug_on{
					show_debug_message("AUDIO PLAYSTACK: invalid input");	
				}
				return self; //not a valid input, don't take that	
			}
			
			//fill the layers so that they're continuous into the requested tier
			while(array_length(current)<=tier){
				array_push(current,-1);
				array_push(queue,-4);
			}
			
			if is_string(queue[tier])==is_string(_container_name)
			and queue[tier]==_container_name{
				if debug_on{
					show_debug_message("AUDIO PLAYSTACK: item already queued");	
				}
				return self; //this item is already queued to play, so don't update anything	
			}
			
			//queue the new thing to play
			queue_add(_container_name,tier);
			
			//get the tier of the currently active audio
			var old_tier = get_playing_tier();
			
			if old_tier>tier{
				//music at a higher tier is currently active, so we can hot swap this new track in wihout incurring any interruption
				dequeue(tier);
				return self;
			}
	
			//get what we're trying to replace
			var playing = get_playing();
			
			//oh, it's what we were already trying to play. let's just move the reference up? to the tier we requested and move on then.
			if is_string(playing)==is_string(_container_name) and playing==_container_name{
				if debug_on{
					show_debug_message("AUDIO PLAYSTACK: new queue item was already playing at lower tier");	
				}
				
				if old_tier>=0{
					current[old_tier] = -1;
				}
				current[tier] = playing;
				queue[tier] = -4;
				return self;
			}
			
			//start the process of ending the current playing music so that our newly queued item can slot in
			if is_string(playing){
				if old_tier==tier{ //we're replacing the current tier, so it must stop and be replaced - can't leave it paused
					if debug_on{
						show_debug_message("AUDIO PLAYSTACK: fading out "+playing+" for "+string(fadeOutTime)+"s to replace with new item at same tier");	
					}
					if fadeOutTime>0{
						container_fadeout(playing,fadeOutTime);
					}else{
						container_stop(playing);	//fade out current music
					}
				}else{ //we're playing music at a higher tier than what was previously active
					if debug_on{
						show_debug_message("AUDIO PLAYSTACK: fading out "+playing+" for "+string(fadeOutTime)+"s to replace with new item at a higher tier");	
					}
					
					current[tier] = current[old_tier]; //duplicate the reference up to this higher tier
							//this lets us track when it's ready to be overwritten
					
					//we'll be playing 'over' the old tier, so check if we wanted to leave it paused
					var tween;
					with(container_player(playing)){tween = tween_audio("volume",0,fadeOutTime);}
					if leaveOldPaused{
						tween.callback(function(){pause(); volume = 1;}); //set volume back to 1 for when we resume
					}else{
						tween.callback(function(){destroy();});	
					}
				}
			}
			
			return self;
	}
	
	static update = function(){
		var ms_passed = current_time - time_p;
			time_p = current_time;
		if !paused{
			//look at queued instructions
			var firstqueue = true,
				queue_waiting = false;
			for(var i=array_length(queue)-1;i>=0;i-=1){ //start from the highest tier queued item and work our way down
				if !(is_real(queue[i]) and queue[i]==-4){ //we have a queued item waiting to start!
					if overlaps or !firstqueue or !container_is_playing(current[i]){
						gap[i] = max(0,gap[i]-(ms_passed/1000)); //update the playback gap
						if !firstqueue or gap[i]<=0{
							dequeue(i,!overlaps and !firstqueue);	
							if is_string(current[i]){
								if debug_on{
									show_debug_message("AUDIO PLAYSTACK: queue item "+string(current[i])+" ("+string(i)+") is NOW STARTING TO PLAY!");	
								}
								container_play(current[i]);	//start playing the queued item
								container_set_persistent(current[i],true); //mark is persistent
								
								if fade_in{
									container_set_volume(current[i],0);
									with(container_player(current[i])){
										tween_audio("volume",1,other.fade_in);
									}
								}
							}
						}else{
							if debug_on{
								show_debug_message("AUDIO PLAYSTACK: queue item "+string(current[i])+" ("+string(i)+") is waiting through a silence gap before it starts...");	
							}
							queue_waiting = true;	
						}
					}else{
						if debug_on{
							show_debug_message("AUDIO PLAYSTACK: queue item "+string(current[i])+" ("+string(i)+") is waiting to start");	
						}
						queue_waiting = true;	
					}
					firstqueue = false;
				}
			}
		
			if queue_waiting{
				return true; //we're waiting for a queue item to activate, so all others will not update until then	
			}
		
			//check current instructions and make sure the topmost thing is running correctly
			for(var i=array_length(current)-1;i>=0;i-=1){ //start from the highest tier instruction and work our way down
				if !(is_real(current[i]) and current[i]==-1){ //we have an instruction!
					if is_string(current[i]){ //it's an instruction to play something
							if container_is_paused(current[i]){ //make sure it's unpaused
								if fade_in{
									container_set_volume(current[i],0);
									with(container_player(current[i])){
										tween_audio("volume",1,other.fade_in);
									}
								}
								container_unpause(current[i]);
							}else if !container_is_running(current[i]){ //this container has stopped for some other reason
								if debug_on{
									show_debug_message("AUDIO PLAYSTACK: playing item "+string(current[i])+" ("+string(i)+") has stopped, so we are clearing this tier");	
								}
								//it might have been halted by something external, or maybe the sound wasn't set to loop...
								//let's treat it as though this layer has now become null and let lower instructions carry the torch in following updates
								current[i] = -1;
							}
					
					}
					break; //we only honor the topmost instruction. everything below is left alone.
				}
			}
		}
	}
	
	static dequeue = function(tier,stopOld=true){
		if !(is_real(queue[tier]) and queue[tier]==-4){
			if stopOld{
				container_stop_hard(current[tier]);	
			}
						if debug_on{
							show_debug_message("AUDIO PLAYSTACK: tier "+string(tier)+": "+string(current[tier])+" >>> "+string(queue[tier]));	
						}
			current[tier] = queue[tier];
			queue[tier] = -4;
		}
	}
	
	//reset all layers to blank and stop the active sound
	static reset = function(){
		var n = array_length(current);
		container_stop(get_playing());
		
		current = array_create(n,-1);
		queue = array_create(n,-4);
		gap = array_create(n,0);
	}
	
	static pause = function(){
		if !paused{
			paused = true;	
			container_pause(get_playing());
		}
	}
	
	static unpause = function(){
		if paused{
			paused = false;	
			container_unpause(get_playing());
		}
	}
	
	static queue_add = function(_instr,_tier,_gap = playback_gap){
			queue[_tier] = _instr;
			if is_string(_instr){
				gap[_tier] = _gap; //introduce a playback gap before we start this audio
			}else{
				gap[_tier] = 0; //it's silence or empty, so no gap needed
			}
			if debug_on{
				show_debug_message("AUDIO PLAYSTACK: "+string(_instr)+" queued to play at tier "+string(_tier)+" with playback gap "+string(_gap));	
			}
	}
	
	static destroy = function(){
		array_delete(global.audio_playstacks,array_find_index(global.audio_playstacks,self),1);
	}
}