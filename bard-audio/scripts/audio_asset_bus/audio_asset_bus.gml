// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_asset_bus(assetIndex){
	if ds_map_exists(global.audio_assets,assetIndex){
		return global.audio_assets[?assetIndex].bus;
	}else{
		return 0;	
	}
}