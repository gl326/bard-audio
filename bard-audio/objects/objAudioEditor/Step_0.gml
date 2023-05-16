var _shortcut = AUDIO_EDITOR_KEY_SHORTCUT;
if array_length(_shortcut){
	var _i = array_length(_shortcut),
		_pressed = 0;
	repeat(_i){
		_i --;
		if keyboard_check_pressed(_shortcut[_i]){
			_pressed = true;	
		}else if !keyboard_check(_shortcut[_i]){
			_pressed = false;
			break;
		}
	}
	
	if _pressed{
		instance_create_depth(x,y,0,objAudioEditorReturn);
	
		//go wherever you need to go to initiate gameplay
	    room_goto(EDITOR_PLAY_ROOM);	
	}
}

{
global.bard_editor_clicked = noone; 
if mouse_check_button_pressed(mb_left){
    var clickdepth = 9999999999;
	global.bard_editor_clicked = global.bard_editor_highlighted;
    global.bard_editor_highlighted = noone;
    with(objHighlightable){
        if depth<=clickdepth and visible{
            if mouse_in_region(l,t,r,b){
                global.bard_editor_highlighted = id;
				global.bard_editor_clicked = id; 
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
if !mouse_check_button(mb_left){dragging = noone; drag_start = false;}
}

if clicked!=-1{
    doubleclick+=delta_time;
    if doubleclick>=(1000000*.33){
        clicked = -1;
        doubleclick = 0;
    }
}

/* search update...*/
search_update -=1;
if search_update<=0{
    search_update = search_freq;
    //var ds = container_root_list(); if tab==1{ds=params;} if tab==2{ds=busses;}
    if is_undefined(search_t) or string_lower(containsearch.text)!=search_t{
		if !is_undefined(search_t){
			aeBrowserScrollReset();	
		}
        search_t = string_lower(containsearch.text);
		
		browser = [];
		
		var text = search_t;
			if text==""{
				//empty search
				switch(tab){
					case 0:
						var source = container_root_list();
						array_copy(browser,0,source,0,array_length(source));
					break;
					case 1:
						var source = global.bard_audio_data[bard_audio_class.parameter];
						array_copy(browser,0,source,0,array_length(source));
					break;
					case 2:
						var source = global.bard_audio_data[bard_audio_class.bus];
						var _i = 0;
						repeat(array_length(source)){
							var bus = source[_i];
							if is_undefined(bus.parent){
								array_push(browser,bus);
							}
							_i++;	
						}
					break;
				}
			}else{
				//search by name
				var source;	
				switch(tab){
					case 0: source = global.bard_audio_data[bard_audio_class.container]; break;
					case 1: source = global.bard_audio_data[bard_audio_class.parameter]; break;
					case 2: source = global.bard_audio_data[bard_audio_class.bus]; break;
				}
				var _i = 0;
						repeat(array_length(source)){
							var class = source[_i];
							if string_pos(text,string_lower(class.name)){
								if tab==0{
									array_push(browser,class.name);
								}else{
									array_push(browser,class);
								}
							}
							_i++;	
						}
			}
			
		if alphabetical{
			array_sort(browser,true);
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
if mouse_check_button(mb_left){
if point_distance(mouse_x,mouse_y,hold_x,hold_y)>10 and grabbed!=-1{
    hold_x=-1; hold_y=-1;
    holding = grabbed;
    grabbed = -1;
    }
}else{
    if hold_x==-1 and hold_y==-1{
		dropped = holding;
		
		/////////////////drag and drop params
		var _prio = ds_priority_create();
		with(objHighlightable){
			if visible{
				ds_priority_add(_prio,id,depth);	
			}
		}
		repeat(ds_priority_size(_prio)){
			var _found = false;
			with(ds_priority_delete_min(_prio)){
				if mouse_in_region(l,t,r,b){
					if object_index==objTextfield{
						if objAudioEditor.dropped!=-1 and objAudioEditor.holding_param and !istext{
						    var pid = objAudioEditor.dropped;
							if container_edit{ 
								param_ref = param_name(pid);
							    text = param_ref;
							    param_new_connection(pid,objAudioEditor.editing,param);
							}else if effect_edit{
								param_ref = param_name(pid);
							    text = param_ref;
							    param_new_effect_connection(pid,effect_editing,param);	
							}
						    objAudioEditor.dropped = -1;
						    draggable = false;
						}	
					}
					
					_found = true;
					break;
				}
			}
			if _found{
				break;	
			}
		}
		ds_priority_destroy(_prio);
	}else{
        holding_copy = false;
        holding_move = false;
        }
    holding = -1; grabbed = -1;
    }

if keyboard_check_pressed(vk_up) or mouse_wheel_up(){
	browser_scroll[tab] = max(0,browser_scroll[tab]-3);
    //switch(tab){
    //case 1: param_scroll = max(0,param_scroll-3); break;
    //default: container_scroll = max(0,container_scroll-3); break;
    //}
    }
if keyboard_check_pressed(vk_down) or mouse_wheel_down(){
	browser_scroll[tab] = min(max(0,browser_length-10),browser_scroll[tab]+3);
    //switch(tab){
    //case 1: param_scroll = min(max(0,ds_list_size(param_search)-3),param_scroll+3); break;
    //default: container_scroll = min(container_scroll+3); break;
    //}
    //}
}

bard_audio_listener_update(room_width/2, room_height/2);
bard_audio_update();