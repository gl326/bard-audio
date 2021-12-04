/// @description ds_map_copy_keys(id,source,key1,key2,etc)
/// @param id
/// @param source
/// @param key1
/// @param key2
/// @param etc
function ds_map_copy_keys() {
	var map=argument[0],src=argument[1];
	for(var i=2;i<argument_count;i+=1){
	    var key=argument[i];
	    if ds_map_exists(src,key){
	        ds_map_Replace(map,key,ds_map_find_value(src,key));
	    }
	}



}
