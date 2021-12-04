function container_stop_instance(argument0, argument1) {
	var con = argument0,
		sid = argument1;
	
	if sid!=-1{
		container_stop(con,sid);	
	}

	return -1;


}
