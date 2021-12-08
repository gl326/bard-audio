// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function container_play(_container,_option = false,_playedBy = undefined){
	if is_undefined(_playedBy){
		if !is_struct(self){
			_playedBy = id;	
		}
	}
	return container_player(_container,true).play(_option,_playedBy).play_id;
}