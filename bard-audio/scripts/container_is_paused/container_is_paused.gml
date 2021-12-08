/// @description container_is_paused(name)
/// @param name
function container_is_paused(container) {
	var player = container_player(container)
	if is_undefined(player){
		return false;
	}else{
	    return player.paused;
	}
}
