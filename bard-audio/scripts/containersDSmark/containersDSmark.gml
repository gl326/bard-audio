/// @description containersDSmark(list)
/// @param list
function containersDSmark(argument0) {
	var list=argument0,n = ds_list_size(list);
	for(var i=0;i<n;i+=1){
	    var c = ds_list_find_value(list,i);
	    if is_string(c){
	        containersDSmark(container_contents(real(c)));
	        ds_list_replace(list,i,real(c));
	        ds_list_mark_as_map(list,i);
	    }
	}



}
