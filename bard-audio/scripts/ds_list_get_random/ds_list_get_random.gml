function ds_list_get_random(_list){
	return _list[| floor(random(ds_list_size(_list)))];
}