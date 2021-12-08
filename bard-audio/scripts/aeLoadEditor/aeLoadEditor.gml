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
    
	    if !file_text_eof(file){
	        audio_grouplist_load(file_text_read_string(file));
	        file_text_close(file);
	    }
    
	    file_text_close(file);
    
	    ///////////ORGANIZING BUSSES FOR BROWSING////////////
	    var n = ds_map_size(global.audio_busses),k=ds_map_find_first(global.audio_busses);
	    ds_map_destroy(bushierarchy);
	    bushierarchy = ds_map_create();
	    ds_list_clear(busses);
    
	    //make lists
	    for(var i=0;i<n;i+=1){
	        ds_map_add_list(bushierarchy,k,ds_list_create()); //make the lists
	        k = ds_map_find_next(global.audio_busses,k);
	    }
    
	    ///sort to lists
	    k=ds_map_find_first(global.audio_busses)
	    for(var i=0;i<n;i+=1){
	        var bus = ds_map_find_value(global.audio_busses,k);
	        if ds_exists(bus,ds_type_map){
	        var par = ds_map_find_value(bus,"parent");
	        //show_message(string(par));
	        if is_real(par){
	            //show_message("no parent for "+k)
	            ds_list_add(busses,k);
	        }else{
	            ds_list_add(ds_map_find_value(bushierarchy,par),k);
	        }
	        }else{show_message("bus "+k+" is missing ("+string(bus)+")");}
	        k = ds_map_find_next(global.audio_busses,k);
	    }
    
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
	        if !ds_exists(editing,ds_type_map){editing = -1;}
	    }else{
	        if !audio_exists(editing){editing = -1;}
	    }
	}

	}



}
