/// @description aeCopyToContainer(copyFrom, copyTo)
/// @param copyFrom
/// @param  copyTo
function aeCopyToContainer(argument0, argument1) {
	with(objAudioEditor){
	var from = argument0, to=argument1;
	if is_real(from) and is_real(to){
	    ds_map_copy_keys_excepting_slow(to,from,"name","cont");
	    var cn = ds_map_size(to),ck = ds_map_find_first(to),
	        name = container_name(to), name2 = container_name(from);
	                         /////copy param references
	                        var pn=ds_list_size(params);
	                        for(var q=0;q<pn;q+=1){
	                            var pa = ds_list_find_value(params,q);
	                            if ds_map_exists(pa,name){
	                                ds_map_destroy(ds_map_find_value(pa,name));
	                                ds_map_delete(pa,name)
	                            }
	                            if ds_map_exists(pa,name2){
	                                var copymap = json_encode(ds_map_find_value(pa,name2))
	                                ds_map_add_map(pa,name,json_decode(copymap));
	                            }
	                        }
	    if ds_list_find_index(locked_containers,container_name(to))==-1{
	        ds_list_copy(container_contents(to),container_contents(from));
	        search_update = 0;
	    }
	    }
	}



}
