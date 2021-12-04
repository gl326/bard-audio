function audio_emitter_Free(argument0) {
	var em = argument0;
	/*
	    varei = ds_map_Find_value(global.audio_emitters,em);
	    if is_string(ei){
	        show_debug_message("freed aemitter "+string(em)+" from "+ei);
	    }else{
	        show_debug_message("freed untracked aemitter "+string(em));
	    }*/
	ds_map_delete(global.audio_emitters,em);
	audio_emitter_free(em);



}
