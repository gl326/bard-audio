//copy matching fields from source to dest
function struct_inherit_values(dest,source,_error=false){
	var entries = variable_struct_get_names(source);
	
	//add additional arguments to exclude certain entries
	for(var i=3;i<argument_count;i+=1){
		var ind = array_find_index(entries,argument[i]);
		if ind!=-1{
			array_delete(entries,ind,1);	
		}
	}
	
	var i = array_length(entries);
	repeat(i){
		i -= 1;
		if variable_struct_exists(dest,entries[i]){
			variable_struct_set(dest,entries[i],ElephantDuplicate(variable_struct_get(source,entries[i])));	
		}else{
			if _error{
				show_debug_message("failed to copy data from field "+string(entries[i]));//.Error();
			}
		}
	}
	
	return dest;
}