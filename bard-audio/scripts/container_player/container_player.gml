// finds the player for the given container
// if you set mustExist to true, then it will create the player
function container_player(_container,_mustExist=false){
	_container = container_getdata(_container);
	
	var _i = 0;
	repeat(array_length(global.audio_players)){
		if global.audio_players[_i].container==_container{
			return global.audio_players[_i];
		}
		_i ++;	
	}
	
	if _mustExist{
		return new class_audio_player(_container);
	}
	return undefined;
}