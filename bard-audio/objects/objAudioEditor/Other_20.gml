/// @description RELOAD FROM PROJECT
var project_data = json_parse(file_read_string(project_file)); //get data from project
var _i = 0,
	resources = project_data.resources,
	resource_n = array_length(resources),
	folders = project_data.Folders,
	folder_n = array_length(folders);
	
var parent_from_path = function(path){
	var _parent_end = string_length(path),
			_parent_start = _parent_end;
		while(string_char_at(path,_parent_end)!="/"){
			_parent_end -= 1;	
		}
		_parent_start = _parent_end-1;
		while(string_char_at(path,_parent_start)!="/"){
			_parent_start -= 1;	
		}
		
		return string_copy(path,_parent_start+1,_parent_end-_parent_start-1); //get name of next folder up	
}
	
var _data = global.bard_audio_data[bard_audio_class.container]; //serialized folders data
	
//unlink containers from the project
_i = 0;
repeat(array_length(_data)){
	_data[_i].from_project = false;
	_i ++;
}
	
//turn project folders into containers
_i = 0;
repeat(folder_n){
	var folder = folders[_i];
	var path = folder.folderPath;
	if string_copy(path,1,15)=="folders/Sounds/"{
		//found a sound folder!
		container_from_project(folder.name,parent_from_path(path),folder.order);
	}
	_i ++;	
}

//get resources from project
_i = 0;
repeat(resource_n){
	var resource = resources[_i],
		path = resource.id.path;
	if string_copy(path,1,7)=="sounds/"{
		//found a sound asset!
		var resource_data = json_parse(file_read_string(global.__project_directory+path)),
			parent = resource_data.parent.name,
			_name = resource_data.name;
		
		//insert into parent contents
		var parent_data = container_getdata(parent);
		if !is_undefined(parent_data){
			//create or get matching class
			var asset = audio_asset_create(asset_get_index(_name));
			asset.editor_order = resource.order;
		
			var _j = 0;
			repeat(array_length(parent_data.contents_serialize)){
				var _cdata = parent_data.contents_serialize[_j];
				if string_char_at(_cdata,1)=="$"{
					_cdata = global.audio_assets[?asset_get_index(string_copy(_cdata,2,string_length(_cdata)-1))]; //an asset
				}else{
					_cdata = container_getdata(_cdata); //a container
				}
				
				if _cdata.editor_order<asset.editor_order{
					_j ++;	
				}else{
					break;	
				}
			}
			array_insert(parent_data.contents_serialize,_j,"$"+_name);
		}else{
			show_debug_message(concat("WARNING! couldn't find matching container for folder ",parent," containing asset ",resource_data.name));	
		}
	}
	_i ++;	
}

//unpack all the contents
_i = 0;
repeat(array_length(_data)){
	_data[_i].deserialize_contents();
	_i ++;
}
exit;
///////////////////////////OLD VERSION//////////////////////////
    switch(audio_load_progress){
    case 0: ///////////////////////////////stage 1
	var dir = project_directory+"sounds\\*";
    var foldern = file_find_first(dir,fa_directory);  
	if directory_exists(project_directory){
		show_debug_message("project exists...");
		if directory_exists(dir){
			show_debug_message("sounds exist in there...???");
			
		}
	}
    //get audio assets
	show_debug_message("FIRST FILE "+foldern);
    while(foldern!=""){
        if string_length(foldern)>2{ //seeing "." and ".."
            var file = file_text_open_read(project_directory+"sounds\\"+foldern+"\\"+foldern+".yy"),
                filedata = "";
			if file!=-1{
	            while(!file_text_eof(file)){
	                filedata+=file_text_read_string(file);
	                file_text_readln(file);
	            }
				//show_debug_message(foldern+" data: "+filedata);
	            filedata = json_decode(filedata);
	            if filedata!=-1{
	                    //var key = ds_map_find_value(filedata,"id");
	                    //var aname = ds_map_find_value(filedata,"name"),
	                    //    aindex = asset_get_index(aname);
	                    //ds_map_add(project_keys,key,aindex);
						//ds_map_add(audio_sound_groups,aindex,ds_map_find_value(filedata,"audioGroupGuid"));
						//show_debug_message("sound "+aname+": "+string(aindex));
						var parent = ds_map_find_value(filedata,"parent"),
							parent_name = ds_map_find_value(parent,"name"),
							path = ds_map_find_value(parent,"path"),
							pathlist = string_split(path,"/"),
							pathn= ds_list_size(pathlist);
						ds_list_replace(pathlist,pathn-1,parent_name);
						for(var i=1;i<pathn;i+=1){
							var fol = ds_list_find_value(pathlist,i);
							if !ds_map_exists(project_struct,fol){
								show_debug_message(fol+" discovered");
								ds_map_add_list(project_struct,fol,ds_list_create());	
							}
							var child = foldern;
							if i<pathn-1{
								child = ds_list_find_value(pathlist,i+1);
							}
							var cont = ds_map_find_value(project_struct,fol);
							if ds_list_find_index(cont,child)==-1{
								ds_list_add(cont,child);	
								show_debug_message(child+" > "+fol);
							}
						}
						ds_list_destroy(pathlist);
	                    files_loaded += 1;
	            }
	            file_text_close(file);
	            ds_map_destroy(filedata);
			}
        }
        foldern = file_find_next();
    }
    audio_load_progress = 2;
    break;

    case 2: ///////////////////////////////stage 3
        //create containers from folder strcutres
        var k = ds_map_find_first(project_struct);   
        for(var j=0;j<ds_map_size(project_struct);j+=1){
            var contain = container_create(k);
			show_debug_message("created container "+k);
			
			if contain!=-1{
                ds_list_add(locked_containers,container_name(contain));
	            var nlist = container_contents(contain),
	                clist = ds_map_find_value(project_struct,k);
	            for(var i=0;i<ds_list_size(clist);i+=1){
	                ds_list_add(nlist,ds_list_find_value(clist,i));
	            }
			}
			if k=="Sounds"{
				show_debug_message("================ROOT FOLDER CREATED================");
			}
            k = ds_map_find_next(project_struct,k);
        }
        
        audio_load_progress = 3;
    break;
    
	case 3: ////////////////////////////groups
	/*
	var filen = file_find_first(project_directory+"options\\*",0);
	if filen!=""{
	var file = file_text_open_read(project_directory+"options\\"+filen),
		str = "",
		key =-1;
	show_debug_message("----------AUDIO GROUPS----------");
	//find start of groups
	while(string_pos("\"audioGroups\":",str)<=0 and !file_text_eof(file)){
		str = file_text_read_string(file); file_text_readln(file);	
	}
	while(string_pos("\"Checksum\":",str)<=0 and !file_text_eof(file)){
		str = file_text_read_string(file); file_text_readln(file);
		if string_pos("\"Key\":",str)>0{
			key = real(string_number(str));
		}
		if string_pos("\"id\":",str)>0{
			var p1 = string_pos("\"id\":",str)+7,
				p2 = string_pos("\",",str);
			var gid = string_copy(str,p1,p2-p1);
			show_debug_message("group "+string(key)+" id "+string(gid));
			
			var n = ds_map_size(audio_sound_groups),
				k = ds_map_find_first(audio_sound_groups);
			for(var i=0;i<n;i+=1){
				if gid==ds_map_find_value(audio_sound_groups,k){
					ds_map_replace(audio_sound_groups,k,key);	
				}
				k = ds_map_find_next(audio_sound_groups,k);	
			}
		}
	}
	}else{
		show_debug_message(filen+" doesn't exist!!! :(");	
	}
	*/
	
	
	
	var file = file_text_open_write("audioData_project");
            file_text_write_string(file,json_encode(global.audio_containers)); file_text_writeln(file);
            file_text_write_string(file,ds_list_write(locked_containers)); file_text_writeln(file);
			file_text_write_string(file,ds_map_write(audio_sound_groups)); file_text_writeln(file);
        file_text_close(file);
        
        ds_map_destroy(project_struct);
        audio_loaded = true;
		global.reload_audio = true;
        
        event_user(3);
        
        aeLoadEditor();
        if editing!=-1{
            if !aeSetEditingSound(editing,editing_audio,1){
                editing = -1;
            }
        }
	break;
    }