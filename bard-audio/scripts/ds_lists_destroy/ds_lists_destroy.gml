function ds_lists_destroy() {
	for(var i=0;i<argument_count;i+=1){
			ds_list_destroy(argument[i]);
	}


}
