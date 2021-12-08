/// @description beatEvent()
function doubleBeatEvent() {
	var player = container_player(music_playing());
	if !is_undefined(player){
		return player.doubleBeatEvent();
	}else{
		return false;	
	}
}
