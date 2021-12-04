function ds_list_print(argument0) {
	var list = argument0;
	var str = "";

	for(var i=0;i<ds_list_size(list);i+=1){
	    str += string(ds_list_find_value(list,i))+",";
	}

	return str;




}
