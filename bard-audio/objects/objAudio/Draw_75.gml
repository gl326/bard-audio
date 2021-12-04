/// @description Audio debug (alt+M in debug mode)
// You can write your code in this editor

var display_width = display_get_gui_width(),
	display_height = display_get_gui_height(),
	text_color = c_white,
	text_bcolor = c_black;

if audio_debug_on{// and instance_exists(the_levelobj){
draw_set_color(text_bcolor);
draw_set_alpha(.5);
draw_Rectangle(0,0,display_width,min(display_height*.33,debug_h+20),false);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(ftDebug);
var yy=20;
with(objAudioContainer){
    if ds_list_size(playing)>0{
        draw_set_color(text_bcolor);
        draw_text(20,yy+4,string_Hash_to_newline(container_name(container)+" ("+string(pitch)+")"));
        draw_set_color(text_color);
        draw_set_color(text_color);
        draw_text(20,yy,string_Hash_to_newline(container_name(container)));
        yy += 20;
        for(var i=0;i<ds_list_size(playing);i+=1){
            var s = ds_list_find_value(playing,i),
                aud = ds_map_find_value(s,"aud"),
                file = ds_map_find_value(s,"file"),
                yyy=0,
                str = audio_get_name(file)+": gain "+string(audio_sound_get_gain(aud))+" pitch "+string(audio_sound_get_pitch(aud));//+" pos "+string(audio_sound_get_track_position(aud));
                str+="[input gain: "+string(ds_map_find_value(s,"current_vol"))+"]"
                if ds_map_exists(s,"blend"){str+="[blend: "+string(ds_map_find_value(s,"blend"))+"]";}
                str+=" bus "+string(ds_map_Find_value(s,"bus"))+" "+string(ds_map_Find_value(s,"bus_vol"));
				var emit = -1;
				if ds_map_exists(s,"emitter"){
					emit = ds_map_find_value(s,"emitter");	
				}
            if emit!=-1{
					yyy+=20;
					var ex = audio_emitter_get_x(emit)-(global.listener_x), 
					ey = audio_emitter_get_y(emit)-(global.listener_y),
					ez = audio_emitter_get_z(emit)-global.listener_z,
					egain = audio_emitter_get_gain(emitter);
					str+="#(emitter| x:"+string((ex))+", y:"+string((ey))+", z:"+string(ez)
						+", dist:"+string(sqrt(sqr(ex)+sqr(ey)+sqr(ez)))+", size "+string(aemitter_size)+"/"+string(aemitter_atten)+", pan "+string(100*aemitter_pan)+"%"+" gain "+string(egain)+")"}
            
            draw_set_color(text_bcolor);
            draw_text(20,yy+4,string_Hash_to_newline(str));
            var sw = string_width(string_Hash_to_newline(str));
            draw_Rectangle(30+sw,yy,30+sw+100,yy+16,false);
            
            draw_set_color(text_color);
            draw_text(20,yy,string_Hash_to_newline(str));
            draw_Rectangle(30+sw,yy,30+sw+(100*audio_sound_get_track_position(aud)/audio_sound_length(aud)),yy+16,false);
            yy+=20+yyy;
        }
        if ds_list_size(delay_sounds)>0{
        draw_text(80,yy,string_Hash_to_newline("QUEUED:"));
            yy+=20;
            ////delay sounds
            for(var i=0;i<ds_list_size(delay_sounds);i+=1){
                var s = ds_list_find_value(delay_sounds,i);
                var del = (ds_map_Find_value(s,"delayin")+(ds_map_Find_value(s,"playstart")/1000)-(current_time/1000)),
                    sync = ds_map_Find_value(s,"sync") and group!=-1,
                    file = ds_map_find_value(s,"file"),
                    str = audio_get_name(file)+": "+string(del);
                    if sync{str += " (sync)";}
                    draw_set_color(text_bcolor);
                    draw_text(80,yy+4,string_Hash_to_newline(str));
                    draw_set_color(text_color);
                    draw_text(80,yy,string_Hash_to_newline(str));
                    yy+=20;
                    }
                }
        yy+=20;
    }
    
    if emitter!=-1{
        var w = display_width, h = display_height,
            //mx = w/2,
			//my = h/2,
			p=-1;
        for(var i=0;i<ds_list_size(playing);i+=1){
            if ds_exists(ds_list_find_value(playing,i),ds_type_map){p = ds_list_find_value(playing,i); break;}
        }
        if p!=-1{
        var anim = min(1,audio_sound_get_track_position(ds_map_find_value(p,"aud"))/.5),
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
    }
}
debug_h = yy;

draw_set_halign(fa_right);
var n = 0;
if false{ //not now, sorry
var i = 0, n = ds_map_size(global.audio_emitters), k =ds_map_find_first(global.audio_emitters);
for(i=0;i<n;i+=1){
    str = string(k)+": "+string(ds_map_Find_value(global.audio_emitters,k));
            draw_set_color(text_bcolor);
            draw_text(display_width-20,(20*(i+1))+4,string_Hash_to_newline(str));
            draw_set_color(text_color);
            draw_text(display_width-20,(20*(i+1)),string_Hash_to_newline(str));
    k = ds_map_find_next(global.audio_emitters,k);
}
}
draw_set_color(text_color);
if beatEvent(){
	draw_set_color(c_red);
	if measureEvent(){draw_set_color(c_yellow);}
}
var sstr = "group: "+string(audio_loaded)+"#music: "+string(music_current)+"#scene music: "+string(music_scene)+
                "#prev music: "+string(music_p)+"#music vol: "+string(music_volume)+
                "#ambiance: "+string(ambiance_current)+" (vol "+string(ambiance_volume)+")";
 sstr += "#beat: "+string(beat_time)+"/"+string(beatMs())+" | "+string(beat mod beat_count)+" ("+string(beat)+")";
 sstr += "#"+string(beat_prog);
	sstr += "#measure: "+string(measure);
            draw_text(display_width-20,(20*(n+1)),
                string_Hash_to_newline(sstr));
draw_set_halign(fa_left);
}

draw_set_halign(fa_center);
draw_set_color(c_blue);
with(objAudiodebugnote){
	for(var i=-1;i<=1;i+=.5){
		draw_text_transformed(x+(i*3),y,my_text,3,3,0);	
	}
}
