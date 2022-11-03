{
if mouse_check_button_pressed(mb_left){
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
			array_sort(browser,1);
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
    if hold_x==-1 and hold_y==-1{dropped = holding;}
    else{
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
	browser_scroll[tab] = min(max(0,array_length(browser)-10),browser_scroll[tab]+3);
    //switch(tab){
    //case 1: param_scroll = min(max(0,ds_list_size(param_search)-3),param_scroll+3); break;
    //default: container_scroll = min(container_scroll+3); break;
    //}
    //}
}

bard_audio_listener_update(room_width/2, room_height/2);
bard_audio_update();