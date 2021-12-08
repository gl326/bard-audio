function container_stop_instance(container, sid) {
	if sid!=-1{
		container_stop(container,sid);	
	}

	return -1;
}
