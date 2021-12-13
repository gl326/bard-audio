/// @description Insert description here
// You can write your code in this editor
if debug_view{
	bard_audio_debug_gui();
}

//simple loading graphic
if bard_audio_isloading(){
	var ang = -360*current_time/1000,
		arange = 60,
		num = 4,
		xx = display_get_gui_width()-50,
		yy = display_get_gui_height()-50,
		rrad = 25,
		crad = 10;	
	draw_set_color(c_white);
	for(var i=0;i<num;i+=1){
		draw_circle(
			xx+lengthdir_x(rrad,ang+arange*i/(num-1)),
			yy+lengthdir_y(rrad,ang+arange*i/(num-1)),
			crad*sqr(1-(i/num)),
			false);
	}
}