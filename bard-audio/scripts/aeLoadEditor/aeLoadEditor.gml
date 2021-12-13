function aeLoadEditor() {
	with(objAudioEditor){

	var loaded_hier = false;
	var filename = "audioEditor";
	if argument_count>0{if argument[0]>=0{filename = "working\\backups\\audio\\audioEditor_"+string(argument[0]);}}
	if file_exists(filename){
	    var file = file_text_open_read(filename);
	    var str = file_text_read_string(file); file_text_readln(file);
	    history_id = file_text_read_real(file); file_text_readln(file);
    
		show_debug_message("about to delete ediitng history?");
		var exists = variable_instance_exists(id,editing_history);
		show_debug_message("exists = "+string(exists));
		if exists{
			ds_list_destroy(editing_history);
		}
		show_debug_message("deleted editing history");
	    var fakemap = json_decode(file_text_read_string(file));
	    editing_history = ds_map_find_value(fakemap,"history");
	    file_text_readln(file);
    
	    file_text_close(file);
    
    
	    ds_map_delete(fakemap,"history");
	    ds_map_destroy(fakemap);
	    if string_number(str)==str{
	        editing=real(str); editing_audio = true;
	        }
	    else{
	        if ds_map_exists(global.audio_containers,str)
	            {
	                editing = ds_map_find_value(global.audio_containers,str);
	            }else{
	                editing = -1;
	            }
	        editing_audio = false;
	        }
	    if !editing_audio{
	        if !is_struct(editing){editing = -1;}
	    }else{
	        if !audio_exists(editing){editing = -1;}
	    }
	}

	}



}
