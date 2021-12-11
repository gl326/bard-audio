// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_asset_play_on(emitterID,assetIndex,looping,prio=0){
	if ds_map_exists(global.audio_assets,assetIndex){
		return global.audio_assets[?assetIndex].play_on(emitterID,looping);
	}else{
		show_debug_message("sound "+string(assetIndex)+" does not exist");
		return 0;	
	}
}