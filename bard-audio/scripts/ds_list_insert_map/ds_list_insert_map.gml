/// @description ds_list_insert_map(list, pos, thing to add)
/// @param list
/// @param  pos
/// @param  thing to add
function ds_list_insert_map(argument0, argument1, argument2) {
	var list=argument0,pos=max(0,argument1),nnew=argument2;
	ds_list_insert(list,pos,nnew);
	ds_list_mark_as_map(list,pos);



}
