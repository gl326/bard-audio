/// @description beatEvent()
function beatEvent() {
	var player = container_player(music_playing());
	if !is_undefined(player){
		return player.beatEvent();
	}else{
		return false;	
	}
}