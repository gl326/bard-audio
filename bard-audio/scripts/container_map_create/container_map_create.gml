// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function container_map_create(){
	var map;
			if ds_queue_empty(the_gameobj.container_maps){
				map = ds_map_create();
			}else{
				map = ds_queue_dequeue(the_gameobj.container_maps);
			}
	return map;
}