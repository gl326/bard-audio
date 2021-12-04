/// @description ds_map_copy_keys_excepting(id,source,key1,key2,etc)
/// @param id
/// @param source
/// @param key1
/// @param key2
/// @param etc
function ds_map_copy_keys_excepting() {
	//fast version (dont need to worry about nested structs)
	var map=argument[0],src=argument[1];
	var sarray = -1;
	for(var i=argument_count-1;i>=2;i-=1){
		sarray[i-2] = ds_map_find_value(map,argument[i]);	
	}
	ds_map_copy(map,src);
	for(var i=argument_count-1;i>=2;i-=1){
		if !is_undefined(sarray[i-2]){
			ds_map_replace(map,argument[i],sarray[i-2]);	
		}else{
			ds_map_delete(map,argument[i]);
		}
	}
	/*
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


/* end ds_map_copy_keys_excepting */
}
