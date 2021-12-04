/// @description /param_new_connection(param id, container id, connected to)
/// @param param id
/// @param  container id
/// @param  connected to
function param_new_connection(argument0, argument1, argument2) {
	var pid=argument0,cid=argument1,par=argument2,
	    c_name = container_name(cid);
    
	ds_map_Replace(cid,par,param_name(pid));
	if !ds_map_exists(pid,c_name){
	    ds_map_add_map(pid,c_name,ds_map_create());
	}

	var map = ds_map_find_value(pid,c_name),
	    nnew = map_Create("curve",0),
	    pts = ds_list_create();
	    ds_list_add_map(pts, map_Create("x",0,"y",0));
	    ds_list_add_map(pts, map_Create("x",100,"y",choice(0,100,par=="blend")));
	ds_map_add_list(nnew,"points",pts);
	ds_map_add_map(map,par,nnew);

	return nnew;



}
