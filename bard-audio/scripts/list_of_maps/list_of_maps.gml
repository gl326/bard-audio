/// @description list_of_maps(item 0, item 1, etc)
/// @param item 0
/// @param  item 1
/// @param  etc
function list_of_maps() {
	var list = ds_list_create();
	for(var i=0;i<argument_count;i+=1){
	    ds_list_add_map(list,argument[i]);
	}


	return list;



}
