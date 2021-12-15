/// @description Insert description here
// You can write your code in this editor
if room==EDITOR_PLAY_ROOM{
	draw_set_color(c_white);
	draw_line(room_width/4,room_height/2,room_width*3/4,room_height/2);
	draw_line(room_width/2,room_height/4,room_width/2,room_height*3/4);
	if beat_fx>0{
		draw_set_alpha(sqrt(beat_fx));
		draw_circle(room_width/2,room_height/2,sqr(1-beat_fx)*200,true);	
		draw_set_alpha(1);
	}
	
	draw_set_font(-1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	draw_text(20,20,"Q: transition music to track A\nW: transition music to track B\nE: animate intensity parameter to 100\nR: animate intensity parameter to 0\nT: pause/unpause music\nClick anywhere to play a musical note at the mouse position");
}