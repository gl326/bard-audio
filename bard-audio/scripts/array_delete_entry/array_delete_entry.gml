function array_delete_entry(_array){
	var _i = 1;
	repeat(argument_count - 1){
		var _ind = array_find_index(_array, argument[_i]);
		if _ind!=-1{
			array_delete(_array, _ind, 1);	
		}
		_i ++;	
	}
	return _array;
}