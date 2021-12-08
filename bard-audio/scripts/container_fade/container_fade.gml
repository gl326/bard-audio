//fade container to a new volume from 0 to 1 over a set amount of time, in seconds.
//returns a tween handle that you could then attach a callback() to if you wanted
function container_fade(container,newVolume,time=2,curve=1) {
	var player = container_player(container);
	if !is_undefined(player){
		return player.tween_audio("volume",newVolume,time,curve);
	}
}
