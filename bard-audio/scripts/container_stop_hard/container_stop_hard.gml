///this untracks the given instantly, stopping any attached looping sounds and not incurring the usual stop() logic that might incur some delay, fadeouts, tail sounds, etc.
function container_stop_hard(container) {
	var player = container_player(container);
	if !is_undefined(player){
		player.destroy();	
	}
}
