// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ambience_set(_container_name,_tier=0,fadeOutTime=4){
	return global.ambience_player.play(_container_name,_tier,fadeOutTime);
}