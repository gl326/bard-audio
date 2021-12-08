/// @description container_is_playing(name)
/// @param name
function container_is_playing(container) {
	var player = container_player(container)
	if is_undefined(player){
		return false;
	}else{
	    return player.am_playing and !player.paused;
	}
}
