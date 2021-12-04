/// @description aeDeleteEditingSound()
function aeDeleteEditingSound() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    if ds_list_find_index(locked_containers,container_name(editing))!=-1{
	        show_message("This can only be deleted inside Game Maker");
	    }else{
	        if show_question("delete??"){
	        aeDestroyContainer(editing);
        
	        ds_map_destroy(editing);
	        editing = -1;
	        ds_list_clear(container_search);
	        save_audioedit();
	        }
	    }
	}else{show_message("This can only be deleted inside Game Maker");}
	}
	}



}
