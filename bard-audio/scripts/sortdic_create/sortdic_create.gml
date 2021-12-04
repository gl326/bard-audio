// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sortdic_create(){
	var newdic = ds_map_create();
	ds_map_add_list(newdic,"sort",ds_list_create());
	ds_map_add_map(newdic,"lookup",ds_map_create());
	ds_map_add_map(newdic,"rlookup",ds_map_create());
	return newdic;
}