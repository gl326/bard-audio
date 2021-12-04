function list_Add_randorder() {
	var list = argument[0];
	for(var i=1;i<argument_count;i+=1){
	    ds_list_insert(list,ds_list_size(list)-floor(random(i)),argument[i]);
	}
	return list;


}
