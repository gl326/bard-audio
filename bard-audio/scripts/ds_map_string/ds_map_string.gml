/// @description ds_map_show(map)
/// @param map
function ds_map_string(argument0) {

	var str = "";
	if ds_exists(argument0,ds_type_map){
	var k =ds_map_find_first(argument0);
	for(var i=0;i<ds_map_size(argument0);i+=1){
	    str += "{"+string(k)+": "+string(ds_map_find_value(argument0,k))+"}#";
	    k = ds_map_find_next(argument0,k);
	}
	}else{
	str = "NONE";
	}
	return str;



}
