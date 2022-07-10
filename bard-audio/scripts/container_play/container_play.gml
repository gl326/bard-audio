// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function container_play(_container,_option = false,_playedBy = undefined){
	if is_undefined(_playedBy){
		if !is_struct(self){
			_playedBy = id;	
		}
	}
	//if we're playing a container which was in the process of fading out, then lets hard swap that bad boy out
	var _player = container_player(_container,true);
	if _player.fading_out{
		_player.destroy();
		_player = container_player(_container,true);
	}
	
	return _player.play(_option,_playedBy).playid;
}