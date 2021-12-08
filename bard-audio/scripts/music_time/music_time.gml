//get the current playtime of the current song in seconds
function music_time() {
	var player = container_player(music_playing());
	if !is_undefined(player){
		return player.get_time();
	}else{
		return false;	
	}
}