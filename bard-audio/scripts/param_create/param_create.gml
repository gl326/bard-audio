/// @description param_create(name, default)
/// @param name
/// @param  default
function param_create(argument0, argument1) {
	var name=argument0;

	if !ds_map_exists(global.audio_params,name){
	    var nnew  = map_Create("name",argument0,"default",argument1);
	    ds_map_add_map(global.audio_params,name,nnew);
	    ds_map_add(global.audio_state,name,param_default(nnew));
	    return nnew;
	}
	else{
	    show_message("there's already a parmeter with this name!");
	    return -1;
	}




}
