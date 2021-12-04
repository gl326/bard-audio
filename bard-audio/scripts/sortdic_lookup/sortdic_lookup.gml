// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sortdic_lookup(sortdic,val){
	return ds_list_find_index(sortdic[?"sort"],sortdic[?"rlookup"][?val]);
}