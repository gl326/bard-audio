/// @description ds_list_add_to_list(listFrom, listTo)
/// @param listFrom
/// @param listTo
function ds_list_add_to_list(argument0, argument1) {

	var l1=argument0, l1n = ds_list_size(l1), l2 = argument1;

	for(var i=0;i<l1n;i+=1){
	    ds_list_add(l2,ds_list_find_value(l1,i));
	}

	return l2;



}
