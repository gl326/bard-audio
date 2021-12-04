function container_map_clean(map){
	//ds_map_Destroy(map);
	ds_map_clear(map);
	ds_queue_enqueue(the_gameobj.container_maps,map);
}