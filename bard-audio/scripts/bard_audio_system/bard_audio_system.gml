// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro audio_uses_z false
#macro audio_in_editor (room==rmAudioEditor)
#macro DISABLE_SYNCGROUPS true //game maker has a 'sync group' feature but it had some weird issues on some platforms right when we were trying to ship wandersong so we rerouted all the logic to avoid using them
	//this might be a decision we could go back on but in general the fewer different features we're relying on, the better. even at their best sync groups have a lot of weird/unpredictable/unique behavior that 
	//forces you to treat them different from other ypes of playing sounds.
#macro ROOT_SOUND_FOLDER "Sounds"

//default values for spatial audio
audio_listener_orientation(0,0,1,0,-1,0);
audio_falloff_set_model(audio_falloff_linear_distance); //_clamped?

global.default_sound_size = 1400;// //if sounds are within this distance of the listener, they're full volume
global.default_sound_atten = 2850;// //at this distance, sounds are inaudible
global.listener_distance = 1250;//50 //how far the listener is from the screen
global.max_listener_distance = 1500; //farthest the listener can be from the screen - the distance is alered based on the view scale


//run this ~once per frame to update the state of all sounds
function bard_audio_update(){
	//update ongoing effects/fades etc.
	audio_tweens_update(); 
	
	//states for music, ambience etc.
	var _i = 0;
	repeat(array_length(global.audio_playstacks)){
		if global.audio_playstacks[_i].update(){
			_i ++;
		}
	}
	
	//players for individual containers
	_i = 0;
	repeat(array_length(global.audio_players)){
		if global.audio_players[_i].update(){
			_i ++;
		}
	}
	
	//update/clean these objects as necessary
	with(objLocationsound){
		if !container_is_playing(container){
		    instance_destroy();
		}	
	}
}

//stop tracking sounds - ie. for a room end
function bard_audio_clear(clearPersistent = false){
	var _i = 0;
	repeat(array_length(global.audio_players)){
		if clearPersistent or !global.audio_players[_i].persistent{
			global.audio_players[_i].destroy();
		}else{
			_i ++;	
		}
	}
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
}
	
//do this in the draw_gui event to display info on playing sounds
function bard_audio_debug_gui(){
	var display_width = display_get_gui_width(),
		display_height = display_get_gui_height(),
		text_color = c_white,
		text_bcolor = c_black,
		debug_h = 0;


	draw_set_color(text_bcolor);
	draw_set_alpha(.5);
	draw_rectangle(0,0,display_width,min(display_height*.33,debug_h+20),false);
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
	var yy=20,
		_i = 0;
	repeat(array_length(global.audio_players)){
		with(global.audio_players[_i]){
	    if array_length(playing){
	        draw_set_color(text_bcolor);
	        draw_text(20,yy+4,container.name+" ("+string(pitch)+")");
	        draw_set_color(text_color);
	        draw_set_color(text_color);
	        draw_text(20,yy,container.name);
	        yy += 20;
	        for(var i=0;i<array_length(playing);i+=1){
	            var s = playing[i],
	                aud = s.aud,
	                file = s.file,
	                yyy=0,
	                str = audio_get_name(file)+": gain "+string(audio_sound_get_gain(aud))+" pitch "+string(audio_sound_get_pitch(aud));//+" pos "+string(audio_sound_get_track_position(aud));
	                str+="[input gain: "+string(s.current_vol)+"]"
	                if s.blend!=0{str+="[blend: "+string(s.blend)+"]";}
	                str+=" bus "+string(s.bus)+" "+string(s.bus_vol);
					var emit = s.emitter;
	            if emit!=-1{
						yyy+=20;
						var ex = audio_emitter_get_x(emit)-(global.listener_x), 
						ey = audio_emitter_get_y(emit)-(global.listener_y),
						ez = audio_emitter_get_z(emit)-global.listener_z,
						egain = audio_emitter_get_gain(emitter);
						str+="\n(emitter| x:"+string((ex))+", y:"+string((ey))+", z:"+string(ez)
							+", dist:"+string(sqrt(sqr(ex)+sqr(ey)+sqr(ez)))+", size "+string(aemitter_size)+"/"+string(aemitter_atten)+", pan "+string(100*aemitter_pan)+"%"+" gain "+string(egain)+")"}
            
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
	                    str = audio_get_name(file)+": "+string(del);
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

//for data lookup and tracking during gameplay
global.audio_containers = ds_map_create(); //settings and contents of all containers
global.audio_params = ds_map_create(); //parameters, hooks and default values
global.audio_busses = ds_map_create(); //audio busses
global.audio_assets = ds_map_create(); //settings for individual sound assets (bus, gain)
//global.audio_asset_vol = ds_map_create(); //volume settings for each sound asset
//global.audio_asset_bus = ds_map_create(); //bus settings for each sound asset
global.audio_list_index = ds_map_create(); //for containers that need to remember wha sounds they've played
global.audio_emitters = ds_map_create(); //for tracking emitters
global.audio_param_copy_map = ds_map_create(); //this is a blank dummy map we use to copy data around when setting parameters

//definitions for music keys and current musical key state
global.music_keys = ds_map_create();
global.music_key = "";
bard_audio_system_music_keys();

#endregion

/////////state for current playign music&ambience. 
//you could remove these if you want to roll your own system for how you play music and stuff
//this just works for me
//the functions music_set() and ambience_set() are interfaces to talk to these
//and all the global beatevent() scripts reference this music player
global.music_player = new class_audio_playstack(4); //2 second gap between songs ending/starting
global.ambience_player = new class_audio_playstack(4);