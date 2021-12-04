/// @description container_create(name)
/// @param name
function container_create(argument0) {
	var name = argument0;
	if !ds_map_exists(global.audio_containers,name){
	if string_number(name)!=name{
	var nnew = ds_map_create();
	ds_map_add(nnew,"name",argument0);
	ds_map_add_list(nnew,"cont",ds_list_create());

	ds_map_add_map(global.audio_containers,name,nnew);
	return nnew;
	}else{
	  show_message("A container name has to include letters");
	    return -1;  
	}
	}
	else{
	    show_message("Warning! The container name "+name+" is used twice");
	    return -1;
	    }



}
