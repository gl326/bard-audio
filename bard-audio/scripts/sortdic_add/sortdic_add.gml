// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sortdic_add(sortdic,key,val){
	key = string(key);
	if key==string_digits(key){
		key = string_zeropad(key,5);
	}
	
	var lookup = sortdic[?"lookup"];
	while(ds_map_exists(lookup,key)){
		key+="_"+string(val);
	}
	ds_map_add(lookup,key,val);
	
	ds_map_add(sortdic[?"rlookup"],val,key);
	
	var sort = sortdic[?"sort"];
	ds_list_add(sort,key);
}