//copy matching fields from source to dest
function struct_inherit_values(dest,source){
	var entries = variable_struct_get_names(dest);
	
	//add additional arguments to exclude certain entries
	for(var i=2;i<argument_count;i+=1){
		array_delete(entries,array_find_index(entries,argument[i]),1);	
	}
	
	for(var i=array_length(entries)-1;i>=0;i-=1){
		if variable_struct_exists(source,entries[i]){
			variable_struct_set(dest,entries[i],ElephantDuplicate(variable_struct_get(source,entries[i])));	
		}
	}
}