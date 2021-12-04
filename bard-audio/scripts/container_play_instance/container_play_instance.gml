function container_play_instance(argument0, argument1) {
	var con = argument0,
		sid = argument1;
	
	if sid==-1{
		return container_play(con).play_id;	
	}else{
		return sid;
	}


}
