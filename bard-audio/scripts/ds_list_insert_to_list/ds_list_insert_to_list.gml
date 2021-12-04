/// @description ds_list_insert_to_list(list, add to which list)
/// @param list
/// @param  add to which list
function ds_list_insert_to_list(argument0, argument1) {
	var l1=argument0, l1n = ds_list_size(l1), l2 = argument1;

	for(var i=l1n-1;i>=0;i-=1){
	    ds_list_insert(l2,0,ds_list_find_value(l1,i));
	}

	return l2;



}
