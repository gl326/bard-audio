/// @description Insert description here
// You can write your code in this editor

if global.bard_editor_highlighted==id{
	draw_set_color(objAudioEditor.color_fg2);
	for (var _i=0;_i<4;_i+=1){
		draw_rectangle(l-_i,t-_i,r+_i,b+_i,1);
	}
}