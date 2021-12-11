// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_asset_set_gain(assetIndex, setTo){
	if !ds_map_exists(global.audio_assets,assetIndex){ //should nver happen i think
		audio_asset_create(assetIndex);
	}
	setTo = real(setTo);
	
	global.audio_assets[?assetIndex].gain = setTo;
}