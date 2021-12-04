/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
if !the_audio.audio_debug_on{
	draw_text(0,0,"CTRL+ENTER to return to audio editor");
}
