if visible{
if slider and !slide_setup{
        if slide_l==0{slide_l = r+8+butt_w;}
        if slide_r==0{slide_r = room_width - 8 - butt_w;}	
}

if (container_edit and !objAudioEditor.editing_audio and (editing!=objAudioEditor.editing or force_update)){
    editing = objAudioEditor.editing;
    force_update = 0;
    if is_struct(objAudioEditor.editing){
        text = string(variable_struct_get(editing,param));
		var param_str = editing.variable_has_hook(param);
        if param_str!=""{param_ref = param_str; draggable=false;}
        else{
            param_ref = ""; draggable = true;
            if dB{
                var val = real(text)/100;
                if val>-1{
                    text = string(PercentToDB(val))
                }else{
                    text = "-144";
                }
                }
            }
    }
}   

///drag and drop params
if container_edit and objAudioEditor.dropped!=-1 and objAudioEditor.holding_param and !istext
    and mouse_in_region(l,t,r,b){
    var pid = objAudioEditor.dropped;
    param_ref = param_name(pid);
    text = param_ref;
    param_new_connection(pid,objAudioEditor.editing,param)
    objAudioEditor.dropped = -1;
    draggable = false;
}

if objAudioEditor.dragging==id and editing>0{
    if objAudioEditor.drag_start{
        var c_val = real(text);
        c_val += (mouse_x-drag_px)*.5*(1/max(1,200 - abs(mouse_y-objAudioEditor.drag_y)));
        text = string(c_val);
        if editing!=-1 and (!objAudioEditor.editing_audio or !container_edit){
            var val = c_val;
            if dB{
				val = DBToPercent(val)*100;//*100;
			}
            if variable_struct_get(editing,param)!=val{
                variable_struct_set(editing,param,val);
            }
        }
        
    }
    drag_px = mouse_x;
}

if am_highlighted(){
    if param_ref==""{
    if string_length(text)>0 and keyboard_check_pressed(vk_backspace){
        text = string_copy(text,1,string_length(text)-1);
    }
    
    if keyboard_check_pressed(vk_anykey){
        if string_typable(keyboard_lastchar)!=""{
            text += keyboard_lastchar;
            keyboard_lastchar = "";
        }
    }
    //alt click reset
    if keyboard_check(vk_alt) and mouse_check_button_pressed(mb_left) and mouse_in_region(l,t,r,b) and editing>0 and param_ref==""{
        text = "0";
        variable_struct_set(editing,param,0);
    }
    if keyboard_check_pressed(vk_enter) or (mouse_check_button_pressed(mb_left) and !mouse_in_region(l,t,r,b)){
        global.highlighted = noone;
    }
    }else{
    ////////////////////open curve editor////////////////////////
        var cw = 850,ch=600,mx = max(cw/2,min(room_width-(cw/2),mouse_x)),my = max(ch/2,min(room_height-(ch/2),mouse_y));
        var cur = newHighlightable(objaeParamEditor,mx-(cw/2),my-(ch/2),mx+(cw/2),my+(ch/2));
        /*
        cur.points = ds_map_find_value(
                        ds_map_find_value(
                            ds_map_find_value(
                                ds_map_find_value(
                                    global.audio_params,
                                    param_ref),
                                    container_name(editing)),
                                    param),
                                    "points");//yep
                                    */

        cur.curves = global.audio_params[?param_ref].container_variable_hook(editing,param).curve;
		/*ds_map_find_value(
                                ds_map_find_value(
                                    global.audio_params,
                                    param_ref),
                                    container_name(editing));*/
		cur.curve_name = param;//param_ref;
        cur.attribute = param;
        cur.param = param_ref;
		cur.editing = editing;
        global.highlighted = cur;
    }
}else{
    typetime = current_time;
    if editing>0 and param_ref==""{
        if !istext and (string_number(text)!=text or string_digits(text)==""){text = "0";}
        if (editing!=-1 and !objAudioEditor.editing_audio) or !container_edit{
            if !istext{
            var val = real(text);
            if dB{
				val = DBToPercent(val)*100;//*100;
			}
            if variable_struct_get(editing,param)!=val{
                variable_struct_set(editing,param,val);
            }}else{
            if !is_equal(variable_struct_get(editing,param),string(text)){
                variable_struct_set(editing,param,string(text));
            }
            }
        }else{
            text = "";
        }
    }
}

//remove param ref
if param_ref!="" and mouse_in_region(l,t,r,b) and mouse_check_button_pressed(mb_right)
    and (am_highlighted() or global.highlighted==noone){
		param_delete_connection(param_ref,editing.name,param);
		/*
    ds_map_destroy(ds_map_find_value(
                        ds_map_find_value(
                            ds_map_find_value(
                                global.audio_params,
                                param_ref),
                                container_name(editing)),
                                param));
    ds_map_delete(ds_map_find_value(
                        ds_map_find_value(
                                global.audio_params,
                                param_ref),
                                container_name(editing)),
                                param);
								*/
    param_ref = "";
    text = "0";
    if editing>0{
		variable_struct_set(editing,param,0);
		}
    global.highlighted = id;
    draggable = true;
}

if slider and param_ref=="" and editing!=-1 and !objAudioEditor.editing_audio{
    var slide_x;
	if is_real(variable_struct_get(editing,param)){
    if dB{
        slide_x = 
            lerp(slide_l,slide_r,
            clamp(InvQuadInOut(((variable_struct_get(editing,param) )-slider_min)/(slider_max-slider_min)),0,1)
            );
    }else{
    slide_x = 
        lerp(slide_l,slide_r,
        clamp((variable_struct_get(editing,param)-slider_min)/(slider_max-slider_min),0,1)
        );
    }
    
    if !slider_select{
        if mouse_check_button_pressed(mb_left) and mouse_in_region(slide_x-butt_w,t,slide_x+butt_w,b) and global.highlighted==noone{
            slider_select = true;
            slide_select_x = mouse_x-slide_x;
        }
    }else{
        if !mouse_check_button(mb_left){
            slider_select = false;
        }else{
            var amt = clamp((mouse_x-slide_select_x-slide_l)/(slide_r-slide_l),0,1),
                c_val = amt,
                ;
            if dB{
                c_val = lerp(slider_min,slider_max,QuadInOut(amt));///100;
                if c_val<=-100{
                    text = "-144";
                }else{
                    text = string(PercentToDB(c_val/100));
                }
            }else{
                c_val = lerp(slider_min,slider_max,amt);
                text = string(c_val);
            }
            
            if editing!=-1 and (!objAudioEditor.editing_audio or !container_edit){
                var val = c_val;
                //if dB{val = (power(10,(val)/(20))-1)*100;}
                if variable_struct_get(editing,param)!=val{
                    variable_struct_set(editing,param,val);
                }
            }
        }
    }
	}
}
}

if !is_undefined(update_func){
	update_func(editing);
}

/* */
/*  */
