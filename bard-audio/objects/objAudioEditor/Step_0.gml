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
    doubleclick+=1;
    if doubleclick>=15{
        clicked = -1;
        doubleclick = 0;
    }
}

container_search = container_root_list();
/* search update...
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
*/

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
}

bard_audio_update();