//this is a sort of hack that forces all the tracks playing in the music to be set to the same time
//do this once in a while to prevent desynchronisation in layered tracks
function music_align() {
	var player = container_player(music_playing());
	if !is_undefined(player){
		return player.align_time();
	}else{
		return false;	
	}
}