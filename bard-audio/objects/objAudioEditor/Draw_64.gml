//draw_set_halign(fa_right);
//draw_set_valign(fa_bottom);
if holding!=-1{
    if hold_x==-1 and hold_y==-1{
    var name;
        if holding_audio{
            draw_set_color(color_fg2);
            name = audio_asset_name(holding);
            }
        else{
            draw_set_color(color_fg);
            name = holding;
            }
        if holding_copy{name+=":COPYING"}
        else{if holding_move{name+=":MOVING"}
            else{name+=":REFERENCING";}}
        draw_text_transformed(mouse_x*display_get_gui_width()/room_width,mouse_y*display_get_gui_height()/room_height,(name),
			display_get_gui_width()/room_width,
			display_get_gui_width()/room_width,
			0);
    }
}

if saved_fx>0{
draw_set_color(color_fg);
draw_set_alpha(power(saved_fx,1/3));
draw_text(display_get_gui_width()/2,display_get_gui_height()*.9,"SAVED!!!!!");
//draw_text_roundrect(display_get_gui_width()/2,display_get_gui_height()*.9,"SAVED!!!!!",1.5,30,c_black,c_white);
draw_set_alpha(1);
draw_set_valign(fa_top);
draw_set_halign(fa_left);//?
}

