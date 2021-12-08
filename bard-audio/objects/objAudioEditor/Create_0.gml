/// @description structs
search_freq = 1;
search_update = 0;
search_t = "fakefakefake";

saved_fx = 0;

palette = 0;
audio_data_version = 0;
    audio_data_maxversion = 0;
event_user(1);

global.highlighted = noone; 


line_height = 24;
tab = 24;
padding = 8;

clicked = -1;
doubleclick = 0;

editing = -1;
editing_audio = false;

container_scroll = 0;
param_scroll = 0;

grabbed = -1;
holding = -1;
holding_audio = false;
holding_param = false;
dropped = -1;
hold_x=-1;
hold_y=-1;
copying_container = -1;
holding_copy = false;
holding_move = false;
holding_list = -1;
holding_ind = -1;
hold_hover = 0;
hold_hover_id = "";

rebuild_bussearch = false;

dragging = noone; //text field value
drag_start = false;
drag_x = -1; drag_y = -1;

///files
    project_directory = get_project_directory();
    
    //swap out from the one from the_audio
    ds_map_destroy(global.audio_containers);
    global.audio_containers = ds_map_create();
    
    //containers = ds_list_create(); //REAL = audio asset, STRING = id of subcontainer
    locked_containers = ds_list_create(); //these containers are generated from project folders, so content changes wont save
    loaded_search = false;
    
    container_search = ds_list_create(); //current display list of container
    container_expand = ds_list_create(); //which containers are expanded in the list
    editing_history = ds_list_create(); //list of visited containers
    history_id = 0;
    
    param_search = ds_list_create();
    params = ds_list_create();
    
    busses = ds_list_create(); //top level list of busses
    bus_search = ds_list_create(); //current search view list
    bushierarchy = ds_map_create(); //dictionary of content lists, for editor browsing only
    bus_expand = ds_list_create(); //which busses are xpanded
	
	audio_sound_groups = ds_map_create();
    bus_scroll = 0;
    
    audio_loaded = true;
    audio_load_progress = 0;
    files_loaded = 0;
    
    project_keys = -1;
    project_struct = -1;

    if file_exists("audioData_project"){
        var file = file_text_open_read("audioData_project");
            ds_map_destroy(global.audio_containers);
			var nmap = file_text_read_string(file); 
			file_text_readln(file);
			var nmap_decode = json_decode(nmap);
            global.audio_containers = nmap_decode; 
            //ds_list_read(containers,file_text_read_string(file)); file_text_readln(file);
            ds_list_read(locked_containers,file_text_read_string(file)); file_text_readln(file);
			if !file_text_eof(file){
				ds_map_read(audio_sound_groups,file_text_read_string(file)); file_text_readln(file);	
			}
        file_text_close(file);
	
		event_user(3); //done!
    }else{
    audio_loaded = false;
      //  project_keys = ds_map_create(); //maps game maker keys to asset values
       project_struct = ds_map_create(); //audio folder struct just with keys, to be swapped with names 
    }

audio_special_emitter = -1; //... for testing certain things
