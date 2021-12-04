/// @description map_Add(map, key, value, key, value, etc)
/// @param map
/// @param  key
/// @param  value
/// @param  key
/// @param  value
/// @param  etc
function map_Add() {
	var map = argument[0];
	for(var i=1;i+1<argument_count;i+=2){
	    ds_map_add(map,argument[i],argument[i+1]);
	}
	return map;



}
