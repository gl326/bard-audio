//very micro optimisation, but this saves on time creating and destroying maps, which can be not super performant.
//you can replace the _pooled() functions with their normal equivalent if the memory use is scary
//but at least in my experience with using this tool, you tend to have the same number of maps floating around either way
global.bard_audio_map_pool = ds_stack_create();
function ds_map_create_pooled(){
	if ds_stack_empty(global.bard_audio_map_pool){
		return ds_map_create();	
	}else{
		return ds_stack_pop(global.bard_audio_map_pool);	
	}
}
function ds_map_destroy_pooled(map){
	ds_map_clear(map);
	ds_stack_push(global.bard_audio_map_pool);
}

//use this if you want to clean up memory. could be a safety measure that you run after a couple hours of gmaeplay or something. not necessary though.
//just thought someone might want this
function ds_map_pool_clean(){
	repeat(ds_stack_size(global.bard_audio_map_pool)){
		ds_map_destroy(ds_stack_pop(global.bard_audio_map_pool));	
	}
}