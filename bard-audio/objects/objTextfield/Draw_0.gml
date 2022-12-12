
draw_set_color(objAudioEditor.color_fg);
if title!=""{
	draw_set_halign(fa_right); draw_set_valign(fa_middle);
	draw_text(l-2,(t+b)/2,title);
	draw_set_halign(fa_left); draw_set_valign(fa_top);
}
if param_ref!=""{
	draw_set_color(objAudioEditor.color_fg2);
	}

var dragging = (objAudioEditor.dragging==id and objAudioEditor.drag_start);

draw_rectangle(l,t,r,b,!dragging);

if dragging{draw_set_color(objAudioEditor.color_bg);}
var ss = string(text),s=ss;
if param_ref!=""{
	s = string(param_ref);	
}
if param_ref=="" and s==string_number(s) and string_digits(s)!=""{
    if real(s)>0 and plusmin{s = "+"+s;}
    else{
    if real(s)==0 and plusmin and !am_bard_editor_highlighted(){s="+-"+s}
    }
    ss = s;
    if dB{s+="dB";}else{
    if percent{s+="%";}
    }
    }
    draw_text(l+2,t+2,(s));

if am_bard_editor_highlighted() and !dragging{ //type pipe 
    if sin(pi*(current_time-typetime)/1000)>=0{
        draw_rectangle(l+2+string_width((ss)),t,l+4+string_width((text)),b,false)
    }
}

if slider and param_ref=="" and editing!=-1{// and !objAudioEditor.editing_audio{
    
    draw_set_color(objAudioEditor.color_fg);
    draw_rectangle(l+slide_l,lerp(t,b,.4),l+slide_r,lerp(t,b,.6),false);
    
    var slide_x;
	if is_numeric(variable_struct_get(editing,param)){
	    if dB{
	        slide_x = 
	            lerp(l+slide_l,l+slide_r,
	            clamp(InvQuadInOut(((variable_struct_get(editing,param) )-slider_min)/(slider_max-slider_min)),0,1)
	            );
			//draw_text(slide_l,b,string(variable_struct_get(editing,param)));
	    }else{
	    slide_x = 
	        lerp(l+slide_l,l+slide_r,
	        clamp((variable_struct_get(editing,param)-slider_min)/(slider_max-slider_min),0,1)
	        );
	    }
	    draw_set_color(objAudioEditor.color_fg2);
	    draw_rectangle(l+slide_l,lerp(t,b,.4),slide_x,lerp(t,b,.6),false);
    
		if !slider_select{
		    draw_set_color(choice(objAudioEditor.color_bg,objAudioEditor.color_mg,slider_select));
		    draw_rectangle(slide_x-butt_w,t,slide_x+butt_w,b,false);
		    draw_set_color(objAudioEditor.color_fg);
		    draw_rectangle(slide_x-butt_w,t,slide_x+butt_w,b,1); 
		}else{
			draw_set_color(objAudioEditor.color_mg);
			draw_rectangle(slide_x-butt_w,t,slide_x+butt_w,b,1); 
			draw_set_alpha(.5);
			draw_rectangle(slide_x-butt_w,t,slide_x+butt_w,b,false); 
			draw_set_alpha(1);
			draw_set_color(objAudioEditor.color_bg);
		    draw_rectangle(slide_x-1,t,slide_x+1,b,false);
		}
	}
}

if highlight_text!=""{
	if mouse_in_region(l,t,r,b){
		if !highlight_text_format{
			var str = highlight_text, scale = 1, width=-1, maxlines=-1;
				var sw = string_width(str)*scale,
					sh = string_height(str)*scale,
					slines = string_count(chr(10),str),
					lines = 1+slines;
	
			 while(((width!=-1 and (sw/lines)>width) or (width==-1 and (sw/lines)>(sh*(lines)*2))) and (maxlines<0 or lines<maxlines)){
			        lines += 1;
				}
				for(var _l=1;_l<lines-slines;_l+=1){
			        var _t = str;

			        var cc = round(string_length(_t)*(_l)/(lines-slines)),
						c = 0,
						i = 0;
					while((c+cc)>0 and (c+cc)<=string_length(_t)){
						if string_char_at(_t,cc+c)==" "{
							_t = string_delete(_t,cc+c,1);
							_t = string_insert(chr(10),_t,cc+c);
							str = _t;
							break;
						}else{
							if !is_even(i){
								c = -c;
							}else{
								c = abs(c)+1;
							}
							i += 1;
						}
					}

			    }
			highlight_text = str;
			highlight_text_format = true;	
		}
		var hx = 10, hpad = 10,
			width = string_width(highlight_text),
			height = string_height(highlight_text);
		draw_set_color(c_black);
		draw_rectangle(r+hx,(t+b)/2 - height/2 - hpad, r+hx+width+hpad*2, (t+b)/2 + height/2 + hpad, false);
		draw_set_color(c_white); draw_set_halign(fa_left); draw_set_valign(fa_middle);
		draw_text(r+hx+hpad,(t+b)/2,highlight_text);
		draw_set_valign(fa_top);
	}
}
//draw_text(l,b,string(editing));

event_inherited();