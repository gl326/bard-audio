// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_asset_set_bus(assetIndex, setTo){
	if !ds_map_exists(global.audio_assets,assetIndex){ //should never happen
		audio_asset_create(assetIndex);
	}
	
	setTo = string(setTo);
	global.audio_assets[?assetIndex].bus = setTo;
}