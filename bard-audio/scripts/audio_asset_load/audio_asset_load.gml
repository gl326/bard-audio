// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_asset_load(assetIndex){
	var asset = global.audio_assets[?assetIndex];
	if !is_undefined(asset){
		asset.load();
	}
}