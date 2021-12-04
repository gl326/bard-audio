function container_vibrate_instance(con, sid, gp) {
	if sid==-1{
		return container_vibrate_gamepad(con,gp);	
	}else{
		return sid;
	}


}
