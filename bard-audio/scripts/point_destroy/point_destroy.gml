/// @description point_destroy(p)
/// @param p
function point_destroy(argument0) {
	ds_grid_destroy(argument0);


	//if ds_exists(argument0,ds_type_grid){
	/*}else{
	show_debug_message("tried to delete non-existant point "+string(argument0)
	    +" in action "+string(event_type)+" ("+string(event_number)+") "
	    +" of object "+object_get_name(event_object));
	}


/* end point_destroy */
}
