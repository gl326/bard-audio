/// @description list_Add(list, val1, val2, etc)
/// @param list
/// @param  val1
/// @param  val2
/// @param  etc
function list_Add() {
	var list = argument[0];
	for(var i=1;i<argument_count;i+=1){
	    ds_list_add(list,argument[i]);
	}
	return list;



}
