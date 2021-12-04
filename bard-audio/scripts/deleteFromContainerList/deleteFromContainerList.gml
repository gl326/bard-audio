/// @description deleteFromContainerList(list,deleting)
/// @param list
/// @param deleting
function deleteFromContainerList(argument0, argument1) {
	var list=argument0,
	    del=string(argument1);
	if is_real(list){
		var n=ds_list_size(list);
		for(var i=0;i<n;i+=1){
		    if is_string(ds_list_find_value(list,i)){
		        deleteFromContainerList(container_contents(real(ds_list_find_value(list,i))),del);
		    }
		}

		while(ds_list_find_index(list,del)!=-1){
		    ds_list_delete(list,ds_list_find_index(list,del));
		}
	}



}
