// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_asset_stop(assetIndex){
	if ds_map_exists(global.audio_assets,assetIndex){
		return global.audio_assets[?assetIndex].stop();
	}else{
		show_debug_message("sound "+string(assetIndex)+" does not exist");
		return 0;	
	}
}