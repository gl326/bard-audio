/// @description ds_map_copy_keys_excepting(id,source,key1,key2,etc)
/// @param id
/// @param source
/// @param key1
/// @param key2
/// @param etc
function ds_map_copy_keys_excepting_slow() {
	var map = argument[0], src = argument[1];

	var n = ds_map_size(src),k=ds_map_find_first(src);
	for(var i=0;i<n;i+=1){
	    var doit = true;
	    for(var j=2;j<argument_count;j+=1){
	        if is_string(k)==is_string(argument[j]){
	            if k==argument[j]{doit = false; break;}
	        }
	    }
	    if doit{
	        ds_map_replace(map,k,ds_map_find_value(src,k));
	    }
	    k = ds_map_find_next(src,k);
	}



}
