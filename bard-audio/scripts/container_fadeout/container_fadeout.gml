//this forces the given container to fade out to 0 volume over a set amount of time (in seconds) and then destroy itself. 
function container_fadeout(container,time=2) {
	var player = container_player(container);
	if !is_undefined(player){
		player.fading_out = time;	
	}
}
