/// @description ds_list_combine(list 1, 2, etc, returns new list)
/// @param list 1
/// @param  2
/// @param  etc
/// @param  returns new list
function ds_list_combine() {
	var l = list_Create();
	for(var i=0;i<argument_count;i+=1){
	    ds_list_add_to_list(argument[i],l);
	}
	return l;



}
