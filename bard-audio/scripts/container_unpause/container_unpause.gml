///@param name
///@param id
///@param option
function container_unpause() {
	var player = container_player(container);
	if !is_undefined(player){
		player.unpause();	
	}
}
