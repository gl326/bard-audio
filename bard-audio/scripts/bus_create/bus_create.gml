/// @description bus_create(name)
/// @param name
function bus_create(argument0) {
	var name=argument0;

	if !ds_map_exists(global.audio_busses,name){
	    var nnew  = map_Create("name",argument0,"gain",0,"parent",-1);
	    ds_map_add_map(global.audio_busses,name,nnew);
	    return nnew;
	}
	else{
	    show_message("there's already a bus with this name!");
	    return -1;
	}




}
