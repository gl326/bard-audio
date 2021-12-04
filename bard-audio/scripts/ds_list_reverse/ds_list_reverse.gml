/// @description ds_list_reverse(list)
/// @param list
function ds_list_reverse(argument0) {
	var r = ds_list_create();
	ds_list_copy(r,argument0);
	ds_list_clear(argument0);

	for(var i=ds_list_size(r)-1;i>=0;i-=1){
	    ds_list_add(argument0,ds_list_find_value(r,i));  
	}

	ds_list_destroy(r);



}
