/// @description map_Create(key, value, key, value, etc)
/// @param key
/// @param  value
/// @param  key
/// @param  value
/// @param  etc
function map_Create() {
	var map = ds_map_create();
	for(var i=0;i+1<argument_count;i+=2){
	    ds_map_add(map,argument[i],argument[i+1]);
	}

	return map;



}
