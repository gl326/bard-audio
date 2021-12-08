///@param name
///@param id
///@param option
function container_pause(container) {
	var player = container_player(container);
	if !is_undefined(player){
		player.pause();	
	}

}
