//get the current playtime of the current song in seconds
function music_set_time(timeInSeconds) {
	var player = container_player(music_playing());
	if !is_undefined(player){
		return player.set_time(timeInSeconds);
	}else{
		return false;	
	}
}