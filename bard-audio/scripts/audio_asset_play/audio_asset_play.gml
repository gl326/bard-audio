// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_asset_play(assetIndex,prio=0,looping=0,gain=1,pitch=1,offset=0){
	if ds_map_exists(global.audio_assets,assetIndex){
		return global.audio_assets[?assetIndex].play(prio,looping,gain,pitch,offset);
	}else{
		show_debug_message("sound "+string(assetIndex)+" does not exist");
		return 0;	
	}
}