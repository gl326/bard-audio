// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_asset_index(_path){
	var ret = global.audio_external_assets[?_path];
	if is_undefined(ret){
		ret = -1;	
	}
	
	return ret;
}