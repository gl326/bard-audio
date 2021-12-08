//draw_set_halign(fa_right);
//draw_set_valign(fa_bottom);
if saved_fx>0{
draw_set_color(color_fg);
draw_set_alpha(power(saved_fx,1/3));
draw_text(display_get_gui_width()/2,display_get_gui_height()*.9,"SAVED!!!!!");
//draw_text_roundrect(display_get_gui_width()/2,display_get_gui_height()*.9,"SAVED!!!!!",1.5,30,c_black,c_white);
draw_set_alpha(1);
draw_set_valign(fa_top);
draw_set_halign(fa_left);//?
}

