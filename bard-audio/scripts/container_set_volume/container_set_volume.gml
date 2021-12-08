
function container_set_volume(container,volume) {
	var player = container_player(container);
	if !is_undefined(player){
		player.volume = volume;	
	}
}
