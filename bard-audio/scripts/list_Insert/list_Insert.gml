/// @description list_Add(list, val1, val2, etc)
/// @param list
/// @param  val1
/// @param  val2
/// @param  etc
function list_Insert() {
	var list = argument[0],
		pos = argument[1];
	for(var i=argument_count-1;i>=2;i-=1){
	    ds_list_insert(list,pos,argument[i]);
	}
	return list;



}
