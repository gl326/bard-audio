/// @description container_is_playing(name)
/// @param name
//this returns if the container has any sounds it's managing - note that it will return TRUE even if the container is currently paused
function container_is_running(container) {
	var player = container_player(container)
	if is_undefined(player){
		return false;
	}else{
	    return player.am_playing;
	}
}
