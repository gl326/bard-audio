// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function class_audio_asset(_name) constructor{
	name = _name;
	gain = 0;
	bus = "";
	editor_order = 0;
	
	if asset_get_index(name)!=-1{
		ds_map_add(global.audio_assets,asset_get_index(name),self); //track me!
	}else{
		show_debug_message(concat("WARNING! no matching audio asset for \"",name,"\". was it deleted or renamed?"));
	}
}