
draw_set_color(objAudioEditor.color_fg);
if param_ref!=""{draw_set_color(objAudioEditor.color_fg2);}

var dragging = (objAudioEditor.dragging==id and objAudioEditor.drag_start);

draw_Rectangle(l,t,r,b,!dragging);

if dragging{draw_set_color(objAudioEditor.color_bg);}
var ss = string(text),s=ss;
if container_edit and param_ref=="" and s==string_number(s) and string_digits(s)!=""{
    if real(s)>0 and plusmin{s = "+"+s;}
    else{
    if real(s)==0 and plusmin and !am_highlighted(){s="+-"+s}
    }
    ss = s;
    if dB{s+="dB";}else{
    if percent{s+="%";}
    }
    }
    draw_text(l+2,t+2,string_Hash_to_newline(s));

if am_highlighted() and !dragging{ //type pipe 
    if sin(pi*(current_time-typetime)/1000)>=0{
        draw_Rectangle(l+2+string_width(string_Hash_to_newline(ss)),t,l+4+string_width(string_Hash_to_newline(text)),b,false)
    }
}

if slider and param_ref=="" and editing!=-1 and !objAudioEditor.editing_audio{
    
    draw_set_color(objAudioEditor.color_fg);
    draw_Rectangle(slide_l,lerp(t,b,.4),slide_r,lerp(t,b,.6),false);
    
    var slide_x;
	if is_real(ds_map_Find_value(editing,param)){
	    if dB{
	        slide_x = 
	            lerp(slide_l,slide_r,
	            clamp(InvQuadInOut((ds_map_Find_value(editing,param)-slider_min)/(slider_max-slider_min)),0,1)
	            );
	    }else{
	    slide_x = 
	        lerp(slide_l,slide_r,
	        clamp((ds_map_Find_value(editing,param)-slider_min)/(slider_max-slider_min),0,1)
	        );
	    }
	    draw_set_color(objAudioEditor.color_fg2);
	    draw_Rectangle(slide_l,lerp(t,b,.4),slide_x,lerp(t,b,.6),false);
    
	    draw_set_color(choice(objAudioEditor.color_bg,objAudioEditor.color_mg,slider_select));
	    draw_Rectangle(slide_x-butt_w,t,slide_x+butt_w,b,false);
	    draw_set_color(objAudioEditor.color_fg);
	    draw_Rectangle(slide_x-butt_w,t,slide_x+butt_w,b,1); 
	}
}
//draw_text(l,b,string(editing));

