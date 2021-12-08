//return true for one update cycle, if a new measure is starting during this frame
function measureEvent() {
	var player = container_player(music_playing());
	if !is_undefined(player){
		return player.measureEvent();
	}else{
		return false;	
	}
}