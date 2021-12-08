///@param name
///@param secs
///@param option
function container_set_time(container,timeInSecs) {
	var player = container_player(container);
	if !is_undefined(player){
		player.set_time(timeInSecs);	
	}
}
