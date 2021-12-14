/// @description structs
search_freq = 2;
search_update = 0;
search_t = undefined;

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

//container_scroll = 0;
//param_scroll = 0;

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

dragging = noone; //text field value
drag_start = false;
drag_x = -1; drag_y = -1;

///files
    project_file = get_project_file();
    
    //containers = ds_list_create(); //REAL = audio asset, STRING = id of subcontainer
	loaded_search = false;
	
	browser = [];
	browser_scroll = array_create(3,0);
    
    //container_search = [];//ds_list_create(); //current display list of container
    editing_history = ds_list_create(); //list of visited containers
    history_id = 0;
    
    //param_search = [];//ds_list_create();
    //params = ds_list_create();
    
    //busses = ds_list_create(); //top level list of busses
    //bus_search = [];//ds_list_create(); //current search view list
    //bushierarchy = ds_map_create(); //dictionary of content lists, for editor browsing only
    //bus_expand = ds_list_create(); //which busses are xpanded
	
	audio_sound_groups = ds_map_create();
    //bus_scroll = 0;
    
    audio_loaded = true;
    audio_load_progress = 0;
    files_loaded = 0;
    
    //project_keys = -1;
    //project_struct = -1;

	audio_special_emitter = -1; //... for testing certain things
	
	event_user(10);
	
	event_user(3);
