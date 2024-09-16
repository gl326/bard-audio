////////bard audio system!!!!!!

#macro TEMP_DISABLE_GM_AUDIO_BUSSES false 
/*temp gm audio bus disable to stop crashing */

#macro AUDIO_USES_Z false 
/*if TRUE, then we will assume every spatial object has an internal variable called "z," the same as every game maker object 
has variables called "x" and "y." if you arent using a z variable then leave this off.
*/

#macro BARD_EDITOR_MODE (debug_mode and os_type==os_windows)
#macro AUDIO_EDITOR_CAN_LOAD_DATA true
/* this should be set to false or debug_mode when making any public build releases. 
when true, this allows the game to look for project files & audio editor data on the user's file system. 
this is important because, when you query the user's file system for project data stuff, it gives users a potential avenue of attack to edit the game or do weird stuff
i prefer to leave this as debug_mode at all times for safety, and only use the audio editor in debug mode.
*/

#macro AUDIO_EDITOR_ROOM rmAudioEditor 
/*The GameMaker room used as the audio editor. it can be named anything, just make sure its a room that contains objAudioEditor.
*/

#macro EDITOR_PLAY_ROOM rmOverworld 
/* When you hit CTRL+ENTER in the editor, it will go to this room. make it a room that could be a reasonable entrypoint to begin
gameplay! that way you can edit sounds, test them in-game, and then go back to adjust.
*/

#macro ROOT_SOUND_FOLDER "Sounds" 
/*root folder for all audio *inside the game maker project* */

#macro EXTERN_SOUND_FOLDER "audio/" 
/* folder for any external audio files, should be located in your project datafiles
*DO include the final slash* */

#macro BARD_AUDIO_DATA_FILE "audio_data.json"
#macro DEMO:BARD_AUDIO_DATA_FILE EXT_FILE_PREFIX+"audio_data.json"
#macro AREA01:BARD_AUDIO_DATA_FILE EXT_FILE_PREFIX+"audio_data.json"

#macro DISABLE_SYNCGROUPS true 
/* game maker has a "sync group" feature but it had some weird issues on some platforms right when we were trying to ship wandersong so we rerouted all the logic to avoid using them
	this might be a decision we could go back on but in general the fewer different features we're relying on, the better. even at their best sync groups have a lot of weird/unpredictable/unique behavior that 
	forces you to treat them different from other types of playing sounds.*/
	
#macro AUDIO_EDITOR_AUTO_SAVE true 
/*when 'true' it auto-saves. could be very slow in a giant project so leaving the option to disable this later*/

#macro AUDIO_ENABLE true
/* when 'false,' no audio is loaded or played through the system ever. might be useful for saving processing or load time etc. */

#macro MUSIC_DEFAULT_FADEOUT 4
/*when using the music_* functions to change from one trakc ot another, this is the default fadeout length before starting the next song */

#macro MUSIC_DEFAULT_GAP 0
/*when using the music_* functions to change from one track to another, this is the default gap of silence starting the next song (this time always follows the previous song fading out) */

#macro AUDIO_EDITOR_KEY_SHORTCUT [vk_control,vk_enter]

//////////default values for spatial audio//////////
audio_listener_orientation(0,-1,0,0,0,-1);
audio_falloff_set_model(audio_falloff_linear_distance); //_clamped?

global.default_sound_size = 800;// //if sounds are within this distance of the listener, theyre full volume
global.default_sound_atten = 2500;// //at this distance, sounds are inaudible
global.listener_distance = 0;// 1250;//50 //how far the listener is from the screen
global.max_listener_distance = 1500; //farthest the listener can be from the screen - the distance is alered based on the view scale

////////// if you want to add music keys, add them in *bard_audio_system_music_keys* //////////


//////////IMPORTANT FUNCTIONS! Use these to hook the system into your game!//////////

//run this ~once per frame to update the state of all sounds
function bard_audio_update(){
	//update ongoing effects/fades etc.
	audio_tweens_update(); 
	
	//states for music, ambience etc.
	var _i = 0;
	repeat(array_length(global.audio_playstacks)){
		global.audio_playstacks[_i].update();
		_i ++;
	}
	
	//players for individual containers
	_i = 0;
	repeat(array_length(global.audio_players)){
		if global.audio_players[_i].update(){ //returns FALSE if this update happened to destroy the player, so we know not to advance down the list
			_i ++;
		}
	}
	
	//update/clean these objects as necessary
	with(objLocationsound){
		if !container_is_playing(container){
		    location_sound_destroy(self);
		}	
	}
}

//function to stop tracking sounds - ie. for a room end
function bard_audio_clear(clearPersistent = false){
	var _i = 0;
	repeat(array_length(global.audio_players)){
		if clearPersistent or !global.audio_players[_i].persistent{
			global.audio_players[_i].destroy(true);
		}else{
			_i ++;	
		}
	}
	
	if clearPersistent{
		_i = 0;
		repeat(array_length(global.audio_playstacks)){
			global.audio_playstacks[_i].reset();
			_i ++;
		}
	}
	
	global.audio_tweens = [];
}

//this sets where the audio listener is
//in wandersong and chicory this was always the middle of the screen
//this also moves the listener "away" using global.listener_distance and view_zoom_scale
//if you have view_zoom_scale adjust based on your camera zooming in or out, this makes the listener adjust position accordingly
//so stuff gets louder when you zoom in and quieter when you zoom out
//you can also make your own logic to determine the listener z position and just leave view_zoom at 1 and listener_distance at 0. that's fine too.
function bard_audio_listener_update(_x,_y,_z = 0,_view_zoom_scale=1){
	global.listener_x = _x;
	global.listener_y = _y;
	global.listener_z = _z+clamp(
 	(0 - (global.listener_distance*_view_zoom_scale)),
	-global.max_listener_distance,global.max_listener_distance);
	
	audio_listener_position(global.listener_x,global.listener_y,global.listener_z);
	
	//update default emitters to be on top of the listener. 
	//they are used by sounds not tagged as 3D, therefore there should never be any distance factor to their volume.
	//it would be neat if someday gamemaker adds a way for some emitters to not be 3D, since they're the only way to get audio effects.
	var _i = 0;
	repeat(array_length(global.bard_audio_data[bard_audio_class.bus])){
		var bus_id = global.bard_audio_data[bard_audio_class.bus][_i].name;//default_emitter
		var _emitter = bus_emitter_if_exists(bus_id);
		if _emitter!=-1{
			audio_emitter_position(
				_emitter,
				global.listener_x,global.listener_y,global.listener_z
			);
		}
		_i ++;	
	}
}
	
//make sure to put this in the Asynchonous Event > Save/Load of some global object.
//this is used to manage audio that's being loaded in and assign it correctly.
function bard_audio_load_event(){
	if !is_undefined(global.audio_loading){
		if async_load[?"id"]==global.audio_loading.id{
			if async_load[?"status"]{
				if is_string(global.audio_loading.item){ 
					//path to external file
					var _newBuff = buffer_create(buffer_get_size(global.audio_loading.buffer), buffer_fixed, 1);
					buffer_copy(global.audio_loading.buffer, 0, buffer_get_size(global.audio_loading.buffer), _newBuff, 0);
				
					global.audio_loading.from.loaded_audio = __audioExtWavBufferToAudio(_newBuff);
					global.audio_loading.from.loaded_buffer = _newBuff;
					global.audio_loading.from.loaded = true;
					if global.audio_loading.from.loaded_audio==-1{
						show_debug_message("!!!!!!!!!!!AUDIO ERROR! File "+string(global.audio_loading.item)+" failed to load due to an issue with the file!!!!!!!!!!!");	
					}
					buffer_delete(global.audio_loading.buffer);
				}else{
					//audio group. no extra logic needed.
				}
			}
		
			bard_audio_load_queue_end();
		}
	}
}
	
//do this in the draw_gui event to display info on playing sounds
function bard_audio_debug_gui(){
	var display_width = display_get_gui_width(),
		display_height = display_get_gui_height(),
		text_color = c_white,
		text_bcolor = c_black,
		debug_h = 0;
		
	var _i = 0;
	repeat(array_length(global.audio_players)){
		debug_h += 40;
		var _player = global.audio_players[_i];
		debug_h += array_length(_player.playing)*20;
		debug_h += (array_length(_player.delay_sounds)>0)*20;
		debug_h += array_length(_player.delay_sounds)*20;
	}

	draw_set_color(text_bcolor);
	draw_set_alpha(.5);
	draw_rectangle(0,0,display_width,min(display_height*.33,debug_h+20),false);
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
	var yy=20;

	//if false
	{ // Bus display. Only shows buses with emitters assigned to them.
		var yyy = 0;
		var str = "";
		var busses = ds_map_values_to_array(global.audio_busses);
		var bus_index = 0;
		repeat(array_length(busses)){
		    with(busses[bus_index]){
		    	var emitters = audio_bus_get_emitters(struct);
		    	var emitter_count = string(array_length(emitters));
		    	if(emitter_count > 0){
					str+="\naudio bus[" + name + "] has [" + string(array_length(emitters)) + "] emitter(s)";
					yyy+=20;
			    	
			    	var gm_effects = struct.effects;
					for(var gm_effect_index=0;gm_effect_index<8;gm_effect_index+=1){
						var cur_effect = gm_effects[gm_effect_index];
						if (!is_undefined(cur_effect)){
							yyy+=20;
							if (cur_effect.type == AudioEffectType.Reverb1){
								str+="\n  Active effect[reverb1]";
								str+=" bypass: " + string(cur_effect.bypass);
								str+=" size: " + string(cur_effect.size);
								str+=" damp: " + string(cur_effect.damp);
								str+=" mix: " + string(cur_effect.mix);
							} else {
								str+="\n  There is an effect[" + string(cur_effect.type) + "] is here that we could describe...";
							}
						}
					}
                }
		    }
		    bus_index++;
		}

		draw_set_color(text_bcolor);
		draw_text(20,yy+2,str);

		draw_set_color(text_color);
		draw_text(20,yy,str);
		yy+=40+yyy;
	}

	var _i = 0;
	repeat(array_length(global.audio_players)){
		with(global.audio_players[_i]){
	    if array_length(playing){
			var _tstr = container.name+" (pitch: "+string(pitch)+")";
			if bpm>0{
				_tstr += " ("+string(1 + (get_beat() mod beats_per_measure))+"/"+string(beats_per_measure)+" B:"+string(get_time_in_beats())+" M:"+string(get_measure())+")";
			}
	        draw_set_color(text_bcolor);
	        draw_text(20,yy+4,_tstr);
	        draw_set_color(text_color);
			if bpm>0{
				if beatEvent(){
					draw_set_color(c_yellow);	
				}
			}
	        draw_text(20,yy,_tstr);
			
			
			
	        yy += 20;
	        for(var i=0;i<array_length(playing);i+=1){
	            var s = playing[i],
	                aud = s.aud,
	                file = s.file,
	                yyy=0,
	                str = string(audio_asset_name(file))+": gain "+string(audio_sound_get_gain(aud))+" pitch "+string(audio_sound_get_pitch(aud));//+" pos "+string(audio_sound_get_track_position(aud));
	                str+="[input gain: "+string(s.current_vol)+"]"
	                if s.blend!=0{str+="[blend: "+string(s.blend)+"]";}
					if s.bus!=""{str+=" bus "+string(s.bus)+" "+string(100*(1+bus_gain_current(s.bus)))+"%";}
					var emit = s.emitter;
	            if emit!=-1{
						yyy+=20;
						var ex = audio_emitter_get_x(emit)-(global.listener_x), 
						ey = audio_emitter_get_y(emit)-(global.listener_y),
						ez = audio_emitter_get_z(emit)-global.listener_z,
						egain = audio_emitter_get_gain(emit);
						str+="\n(emitter| x:"+string((ex))+", y:"+string((ey))+", z:"+string(ez)
							+", dist:"+string(sqrt(sqr(ex)+sqr(ey)+sqr(ez)));
						if emitter!=-1{
							str+=", size "+string(aemitter_size)+"/"+string(aemitter_atten)+", pan "+string(100*aemitter_pan)+"%"+" gain "+string(egain)+")";
						}else{
							str+=" gain "+string(egain)+")";	
						}

					var gm_effects = bus_get_gm_effects(s.bus);
	        		for(var gm_effect_index=0;gm_effect_index<8;gm_effect_index+=1){
	        			var cur_effect = gm_effects[gm_effect_index];
	        			if (!is_undefined(cur_effect)){
							yyy+=20;
							if (cur_effect.type == AudioEffectType.Reverb1){
								str+="\n  Active effect[reverb1]";
								str+=" bypass: " + string(cur_effect.bypass);
								str+=" size: " + string(cur_effect.size);
								str+=" damp: " + string(cur_effect.damp);
								str+=" mix: " + string(cur_effect.mix);
							} else {
								str+="\n  There is an effect is here that we could describe...";
							}
	        			}
	        		}
				}
            
	            draw_set_color(text_bcolor);
	            draw_text(20,yy+4,str);
	            var sw = string_width(str);
	            draw_rectangle(30+sw,yy,30+sw+100,yy+16,false);
            
	            draw_set_color(text_color);
	            draw_text(20,yy,str);
	            draw_rectangle(30+sw,yy,30+sw+(100*audio_sound_get_track_position(aud)/audio_sound_length(aud)),yy+16,false);
	            yy+=20+yyy;
	        }
	        if array_length(delay_sounds)>0{
	        draw_text(80,yy,"QUEUED:");
	            yy+=20;
	            ////delay sounds
	            for(var i=0;i<array_length(delay_sounds);i+=1){
	                var s = delay_sounds[i];
	                var del = (s.delayin+(s.playstart/1000)-(current_time/1000)),
	                    sync = s.sync and group!=-1,
	                    file = s.file,
	                    str = audio_asset_name(file)+": "+string(del);
	                    if sync{str += " (sync)";}
	                    draw_set_color(text_bcolor);
	                    draw_text(80,yy+4,str);
	                    draw_set_color(text_color);
	                    draw_text(80,yy,str);
	                    yy+=20;
	                    }
	                }
	        yy+=20;
	    }
    
		/*
	    if emitter!=-1{
	        var w = display_width, h = display_height,
	            //mx = w/2,
				//my = h/2,
				p=-1;
	        if array_length(playing){
				p = playing[0];	
			}
	        if p!=-1{
		        var anim = min(1,audio_sound_get_track_position(p.aud)/.5),
		            vx = (audio_emitter_get_x(emitter)-(__view_get( e__VW.XView, 0 )))*w/__view_get( e__VW.WView, 0 ),
		            vy = (audio_emitter_get_y(emitter)-(__view_get( e__VW.YView, 0 )))*h/__view_get( e__VW.HView, 0 );
		        draw_set_color(c_yellow);
		        if anim<1 and !PointInBox(vx,vy,0,0,w,h){draw_line(vx,vy,min(w-50,max(50,vx)),min(h-50,max(50,vy)));}
		        draw_sprite_ext(sprAudioButtons,1,
		            vx,vy,
		            4,4,0,text_color,1);
					draw_set_halign(fa_center);
				draw_text(vx,vy+16,name);
				draw_set_halign(fa_left);
		        if anim<1{
		        draw_circle(vx,vy,650*w/__view_get( e__VW.WView, 0 )*sqrt(anim),true);
		        }
		    }
	    }*/
	}
		_i ++;
	}

	debug_h = yy;

	draw_set_halign(fa_right);
	var n = 0;
	if false{ //not now, sorry
		var i = 0, n = ds_map_size(global.audio_emitters), k =ds_map_find_first(global.audio_emitters);
		for(i=0;i<n;i+=1){
		    str = string(k)+": "+string(ds_map_Find_value(global.audio_emitters,k));
		            draw_set_color(text_bcolor);
		            draw_text(display_width-20,(20*(i+1))+4,str);
		            draw_set_color(text_color);
		            draw_text(display_width-20,(20*(i+1)),str);
		    k = ds_map_find_next(global.audio_emitters,k);
		}
	}
	
	////music state stuff....
	/*
	draw_set_color(text_color);
	if beatEvent(){
		draw_set_color(c_red);
		if measureEvent(){draw_set_color(c_yellow);}
	}
	var sstr = "group: "+string(audio_loaded)+"\nmusic: "+string(music_current)+"\nscene music: "+string(music_scene)+
	                "\nprev music: "+string(music_p)+"\nmusic vol: "+string(music_volume)+
	                "\nambiance: "+string(ambiance_current)+" (vol "+string(ambiance_volume)+")";
	 sstr += "\nbeat: "+string(beat_time)+"/"+string(beatMs())+" | "+string(beat mod beat_count)+" ("+string(beat)+")";
	 sstr += "\n"+string(beat_prog);
		sstr += "\nmeasure: "+string(measure);
	            draw_text(display_width-20,(20*(n+1)),sstr);
	*/

}
	
#region internal data structures and variables (don't touch if you can help it)
global.listener_x = 0;
global.listener_y = 0;
global.listener_z = 0;

#macro audio_in_editor (room==AUDIO_EDITOR_ROOM)

//data structures that hold referneces to important things

//arrays of component classes and settings which we use for serialisation
//this is all the data you manipulate in the audio editor
enum bard_audio_class{
	container,
	parameter,
	bus,
	asset,
	_num
}
global.bard_audio_data = [];
repeat(bard_audio_class._num){
	array_push(global.bard_audio_data,[]);	
}

//these ones are not serialized, but are tracked via array 
global.audio_players = [];
global.audio_playstacks = [];
global.audio_bus_param_watchers = [];

//for data lookup and tracking during gameplay
global.audio_containers = ds_map_create(); //settings and contents of all containers
global.audio_params = ds_map_create(); //parameters, hooks and default values
global.audio_busses = ds_map_create(); //audio busses
global.audio_assets = ds_map_create(); //settings for individual sound assets (bus, gain)
global.audio_list_index = ds_map_create(); //for containers that need to remember wha sounds they've played
global.audio_emitters = ds_map_create(); //for tracking emitters
global.audio_param_copy_map = ds_map_create(); //this is a blank dummy map we use to copy data around when setting parameters
global.audio_external_assets = ds_map_create(); //map external asset paths to indexes
global.audio_load_queue = [];
global.audio_loading = undefined;

global.location_sounds_pool = ds_queue_create();

//definitions for music keys and current musical key state
global.music_keys = ds_map_create();
global.music_key = "";
bard_audio_system_music_keys();

global.external_audio_index = 1000000;

#endregion

/////////state for current playign music&ambience. 
//you could remove these if you want to roll your own system for how you play music and stuff
//this just works for me
//the functions music_set() and ambience_set() are interfaces to talk to these
//and all the global beatevent() scripts reference this music player
global.music_player = new class_audio_playstack("music", 4); //2 second gap between songs ending/starting
global.music_player.set_playback_gap(MUSIC_DEFAULT_GAP);

global.ambience_player = new class_audio_playstack("ambience", 4, true);
global.ambience_player.set_fade_in(2);

global.__bard_project_datafiles = undefined;
//bard_audio_data_load();