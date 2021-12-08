///@param name
///@param id
///@param option
function container_set_persistent(container,_persistent) {
	var player = container_player(container);
	if !is_undefined(player){
		player.persistent = _persistent;
	}

}
