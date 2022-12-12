with(objEditorpanel){
	if parent_window==other.id{
		draw_set_color(objAudioEditor.color_fg2);
		draw_line_width((l+r)/2,(t+10),(other.l+other.r)/2,(other.t+other.b)/2,4);
	}
}

draw_set_color(objAudioEditor.color_bg2);
draw_rectangle(l,t,r,b,false);
draw_set_color(objAudioEditor.color_fg);
draw_rectangle(l,t,r,b,true);
draw_line(l,t+top_h,r,t+top_h);

if title!=""{draw_text(l+4,t+2,(title));}

event_inherited();