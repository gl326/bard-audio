//get how far along the current song is, measured in beats
function music_time_beat() {
	var player = container_player(music_playing());
	if !is_undefined(player){
		return player.get_time_in_beats();
	}else{
		return false;	
	}
}