if audio_loaded{
	__view_set( e__VW.XView, 0, 0);
	__view_set( e__VW.YView, 0, 0);
if mouse_clicked(){
    var clickdepth = 9999999999;
    //global.highlighted = noone;
    with(objHighlightable){
        if depth<=clickdepth and visible{
            if mouse_in_region(l,t,r,b){
                global.highlighted = id;
                clickdepth = depth;
                if draggable{
                    (other.id).dragging = id; (other.id).drag_x=mouse_x; (other.id).drag_y=mouse_y;
                    (other.id).drag_start=false;
                    }
            }
        }
    }
}

saved_fx += (0-saved_fx)*.06;

if dragging!=noone{
if !drag_start and point_distance(drag_x,drag_y,mouse_x,mouse_y)>10{drag_start = true;}
if !mouse_held(){dragging = noone; drag_start = false;}
}

if clicked!=-1{
    doubleclick+=1;
    if doubleclick>=15{
        clicked = -1;
        doubleclick = 0;
    }
}

search_update -=1;
if search_update<=0{
    search_update = search_freq;
    var ds = container_root_list(); if tab==1{ds=params;} if tab==2{ds=busses;}
    if containsearch.text!=search_t or containsize!=ds_list_size(ds) or rebuild_bussearch{
        rebuild_bussearch = false;
        containsize = ds_list_size(ds);
        search_t = string_lower(containsearch.text);
        
        if tab==0{
        container_scroll = 0;
        if search_t!=""{
            ds_list_clear(container_search);
            containerSearch(container_root_list(),search_t);
        }else{
			if !ds_map_exists(global.audio_containers,"Sounds"){
				container_create("Sounds");
			}
				ds_list_copy(container_search,container_root_list());
        }
            if alphabetical{
                var alist = ds_list_create();
                for(var i=0;i<ds_list_size(container_search);i+=1){
                    var con = ds_list_find_value(container_search,i),
						name,
						sub = is_string(con);
                    if !sub{
                        name = audio_get_name(con);
                    }else{
                        name = ds_map_find_value(real(con),"name");
                    }
                    ds_list_add(alist,name);
                }
                ds_list_sort(alist,1);
                ds_list_clear(container_search);
                for(var i=0;i<ds_list_size(alist);i+=1){
                    var name = ds_list_find_value(alist,i);
                    if asset_get_index(name)!=-1{ds_list_add(container_search,asset_get_index(name));}
                    else{
						var subcont = ds_map_find_value(global.audio_containers,name);
						if !is_undefined(subcont){
							ds_list_add(container_search,string(subcont));}
						}
                }
                ds_list_destroy(alist);
            }
        }
        if tab==1{
        param_scroll = 0;
        if search_t!=""{
            ds_list_clear(param_search);
            paramSearch(params,search_t);
        }else{
            ds_list_copy(param_search,params);
        }
            if alphabetical{
                var alist = ds_list_create();
                for(var i=0;i<ds_list_size(param_search);i+=1){
                    ds_list_add(alist,param_name(ds_list_find_value(param_search,i)));   
                }
                ds_list_sort(alist,1);
                ds_list_clear(param_search);
                for(var i=0;i<ds_list_size(alist);i+=1){
                    ds_list_add(param_search,ds_map_find_value(global.audio_params,ds_list_find_value(alist,i)));
                }
                ds_list_destroy(alist);
            }
        }
        
        if tab==2{
        bus_scroll = 0;
        if search_t!=""{
            //ds_list_clear(bus_search);
            ds_list_clear(bus_expand);
            busSearch();
        }else{
            ds_list_copy(bus_search,busses);
        }
        }
    }
}

if dropped!=-1{
    holding_param = false;
    holding_copy = false;
    holding_move = false;
    holding_bus = false;
    }
dropped = -1;
if mouse_held(){
if point_distance(mouse_x,mouse_y,hold_x,hold_y)>10 and grabbed!=-1{
    hold_x=-1; hold_y=-1;
    holding = grabbed;
    grabbed = -1;
    }
}else{
    if hold_x==-1 and hold_y==-1{dropped = holding;}
    else{
        holding_copy = false;
        holding_move = false;
        }
    holding = -1; grabbed = -1;
    }

if keyboard_check_pressed(vk_up) or mouse_wheel_up(){
    switch(tab){
    case 1: param_scroll = max(0,param_scroll-3); break;
    default: container_scroll = max(0,container_scroll-3); break;
    }
    }
if keyboard_check_pressed(vk_down) or mouse_wheel_down(){
    switch(tab){
    case 1: param_scroll = min(max(0,ds_list_size(param_search)-3),param_scroll+3); break;
    default: container_scroll = min(container_scroll+3); break;
    }
    }
}else{
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
}

