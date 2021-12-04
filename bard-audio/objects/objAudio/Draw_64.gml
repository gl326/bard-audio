/// @description draw something while audio is loading? 

/* something like this
if loading_audio{
    draw_set_color(c_black);
    draw_Rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
	draw_set_color(c_white);
	draw_text(display_get_gui_width()/2,display_get_gui_height()/2,
		string(loading_prog)+"%");
}
