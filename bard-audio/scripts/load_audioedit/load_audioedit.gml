/// @description load_audioedit()
function load_audioedit() {

	var ver = -1,
		filename = "audio_data";
	if argument_count>0{
		ver = argument[0]; filename = "working\\backups\\audio\\audio_data_"+string(argument[0]);
		audio_data_version = ver;
	}

	
	if file_Exists(filename){
		var fpath = filename_path("audio_data");
	    var file = file_text_open_read(filename);
	    var load_map;
	    load_map = json_decode(file_text_read_lined_json(file));
    
	    if !file_text_eof(file){
	        file_text_readln(file);
	        ds_map_destroy(global.audio_params);
	        global.audio_params = json_decode(file_text_read_lined_json(file));
	    }
    
	    if !file_text_eof(file){
	        file_text_readln(file);
	       // ds_map_read(global.audio_asset_vol,file_text_read_string(file));
		   global.audio_asset_vol = json_decode(file_text_read_lined_json(file));
	    }
    
	    if !file_text_eof(file){
	        file_text_readln(file);
	        ds_map_destroy(global.audio_busses);
			global.audio_busses = json_decode(file_text_read_lined_json(file));
	       // global.audio_busses = json_decode(file_text_read_string(file));
	        //ds_map_read(global.audio_busses,file_text_read_string(file));
	    }
    
	    if !file_text_eof(file){
	        file_text_readln(file);
			global.audio_asset_bus = json_decode(file_text_read_lined_json(file));
	        //ds_map_read(global.audio_asset_bus,file_text_read_string(file));
	    }
	
    
	    var slist = -1;
	    file_text_close(file);
	
		/*
	    var filename = "audioData",ver=-1;
	    if argument_count>0{ver = argument[0]; filename = "working\\backups\\audio\\audioData_"+string(argument[0]);}

	if file_Exists(filename){
	    var file = file_text_open_read(filename);
	    var load_map;
	    load_map = json_decode(file_text_read_string(file));
    
	    if !file_text_eof(file){
	        file_text_readln(file);
	        ds_map_destroy(global.audio_params);
	        global.audio_params = json_decode(file_text_read_string(file));
	    }
    
	    if !file_text_eof(file){
	        file_text_readln(file);
	        audio_data_version = file_text_read_real(file);
	    }
    
	    if !file_text_eof(file){
	        file_text_readln(file);
	        ds_map_read(global.audio_asset_vol,file_text_read_string(file));
	    }
    
	    if !file_text_eof(file){
	        file_text_readln(file);
	        ds_map_destroy(global.audio_busses);
	        global.audio_busses = json_decode(file_text_read_string(file));
	        //ds_map_read(global.audio_busses,file_text_read_string(file));
	    }
    
	    if !file_text_eof(file){
	        file_text_readln(file);
	        ds_map_read(global.audio_asset_bus,file_text_read_string(file));
	    }
    
	    var slist = -1;
	    if !file_text_eof(file){
	        file_text_readln(file);
	        if room==S{
	        with(objAudioEditor){
	            if !loaded_search{
	                loaded_search = true;
	                loaded_hier = true;
	                slist = ds_list_create();
	                ds_list_read(slist,file_text_read_string(file));    
	            }
	        }
	    }
	    }
    
	    file_text_close(file);
		*/
		//////////////////////////////////////////////
    
	    var loaded_containers = ds_list_create();
    
	    var k = ds_map_find_first(load_map),n=ds_map_size(load_map);
	    for(var i=0;i<n;i+=1){
	        if k!="x" and k!="y"{ //hack fix bc i am a hack
	        var c = ds_map_find_value(load_map,k);
	        if ds_exists(c,ds_type_map) and ds_map_exists(c,"name") and ds_map_exists(c,"cont"){
	        var name = container_name(c),nnew;
	        if !ds_map_exists(global.audio_containers,name){
	            //make a ttal nnew copy map with copy contents
	            nnew = ds_map_create();
	            var newcont = ds_list_create(),oldcont = container_contents(c);
	            ds_map_copy(nnew,c);
	            if !is_real(c) or !ds_exists(oldcont,ds_type_list){
					if debug_mode or !is_real(c){show_message("list for "+name+" doesnt exist");}
					}
	                else{ ds_list_copy(newcont,oldcont);}
	            ds_map_replace_list(nnew,"cont",newcont);
            
	            ds_map_add_map(global.audio_containers,name,nnew);
	            ds_list_add(loaded_containers,nnew);
	            //with(objAudioEditor){ds_list_add(containers,string(nnew));}
	        }else{
	            nnew = ds_map_find_value(global.audio_containers,name);
	            ds_map_copy_keys_excepting_slow(nnew,c,"cont","name");
	        }
	        if ds_map_exists(c,"blend_map"){ //oh boy
	            var old_blend = ds_map_find_value(c,"blend_map");
	                if ds_exists(old_blend,ds_type_list){
	                    var new_blend = ds_list_create(),obn = ds_list_size(old_blend);
	                    for(var q=0;q<obn;q+=1){
	                        var nmap = ds_map_create(), omap = ds_list_find_value(old_blend,q);
	                        ds_map_copy(nmap,omap);
	                        ds_list_add_map(new_blend,nmap);
	                    }
	                    ds_map_replace_list(nnew,"blend_map",new_blend);
	                }else{
	                    ds_map_delete(nnew,"blend_map");
	                    ds_map_Replace(nnew,"blend_on",0);
	                    if debug_mode{show_message("blend map "+string(old_blend)+" for "+name+" doesnt exist");}
	                }
	            }   
	        }
	        }
	        k = ds_map_find_next(load_map,k);
	    }
    

    
	    /**/
	    //after all the containers are in, swap out "name"s with "id"s
	    var n=ds_list_size(loaded_containers);
	    for(var i=0;i<n;i+=1){
	        var c=container_contents(ds_list_find_value(loaded_containers,i)),
	            cn = ds_list_size(c);
	        for(var j=0;j<cn;j+=1){
	            var cc = ds_list_find_value(c,j);
	            if is_string(cc){
	                var asset = asset_get_index(cc);
	                if asset!=-1{
	                    ds_list_replace(c,j,asset);
	                }else{
	                    if ds_map_exists(global.audio_containers,cc){
	                        ds_list_replace(c,j,string(ds_map_find_value(global.audio_containers,cc)));
	                    }else{
	                        //if debug_mode{show_message(cc+" doesnt exist");}
	                        ds_list_delete(c,j);
	                        j-=1;cn-=1;
	                    }
	                }
	            }
	        }
	    }
	    ds_list_destroy(loaded_containers);
    
	    ds_map_destroy(load_map);
		

    
	     var p = ds_map_find_first(global.audio_params);
	        for(var k=0;k<ds_map_size(global.audio_params);k+=1){
	            with(objAudioEditor){ds_list_add(params,ds_map_find_value(global.audio_params,p));}
	            ds_map_add(global.audio_state,p,param_default(ds_map_find_value(global.audio_params,p)));
	            p = ds_map_find_next(global.audio_params,p);
	        }
		
	    with(objAudioEditor){
	        aeLoadEditor(ver);
	    }
	}


}
