/// @description container_stop(name, optional id, only stop loops)
/// @param name
/// @param  OptionalId
/// @param  StopLoopsOnly
function container_stop(container,sid = -1, option = false) {
	var player = container_player(container);
	if is_undefined(player){
		return -1;	
	}else{
		player.stop(sid,option);	
	}
	
	return 1;
}
