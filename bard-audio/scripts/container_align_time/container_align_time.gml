///force all the playing sounds in the given container to be set to the same time.
//if you have a song with a couple layers, this is good to do once in a whule to enforce that they aren't desyncing.
//game maker has audio groups that are supposed to solve this problem, but they're ambiguously buggy so i stopped relying on them
function container_align_time(container) {
	var player = container_player(container);
	if !is_undefined(player){
		player.align_time();	
	}
}
