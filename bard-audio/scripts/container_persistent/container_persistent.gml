///@param name
///@param id
///@param option
function container_persistent(container) {
	var player = container_player(container);
	if !is_undefined(player){
		return player.persistent;
	}

	return false;
}
