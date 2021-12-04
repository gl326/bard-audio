/// @description drawContainerList(list,x,y,contain,optional ind)
/// @param list
/// @param x
/// @param y
/// @param contain
/// @param optional ind
function drawContainerList() {
	var list=argument[0], xx=argument[1],yy=argument[2],parent=-1,ind = 0,yst = yy,king = false;
	if argument_count>=4{parent = argument[3];}else{parent = ds_list_create();}
	if argument_count>=5{ind = argument[4];}else{king = true;}
	var tab = 36;
	var n = ds_list_size(list);
	for(var i=0;i<n;i+=1){
	    var con = ds_list_find_value(list,i),
	        fold = is_string(con),
	        name,
	        open = -1,
	        blend = color_fg,
	        cid = real(con),
	        expand_id = string(list)+"_"+string(cid);
	    if fold{
	        open = ds_list_find_index(container_expand,expand_id);
	        name = ds_map_find_value(cid,"name");
	    }else{
	        name = audio_get_name(con);
	    }
    
	    if ind>=container_scroll{
	        draw_set_color(color_fg2);
	        draw_line(xx-tab-2,yy+12,xx-2,yy+12);
	        if fold{draw_set_color(color_fg);}
                
	        if editing == cid and fold==!editing_audio{
	            draw_Rectangle(2,yy,(room_width/3)-8,yy+(24),false);
	            draw_set_color(color_bg2);
	            blend = color_bg2;
	        }
	        /*if con==container{
	            draw_Rectangle(8,(72)+24+(36*i),(room_width/3)-8,(72)+24+(36*i)+36,false);
	            d3d_set_fog(0,color_fg,0,0);
	        }*/
	        draw_text(xx,yy,string_Hash_to_newline(name)/*+" ("+string(con)+")"*/);
	        //if con==container{d3d_set_fog(true,color_fg,0,0);}
	        if mouse_in_region(8,yy,(room_width/3)-8,yy+(24)){
	            draw_Rectangle(2,yy,(room_width/3)-8,yy+(24),true);
	            if holding!=-1{ 
	                if hold_hover_id!=expand_id{
	                    if fold{hold_hover_id = expand_id;}
	                    hold_hover = 0;
	                }else{
	                    hold_hover += 1;
	                    if hold_hover >= room_speed*.75 and fold{
	                        if open==-1{
	                            ds_list_add(container_expand,expand_id); 
	                        }
	                    }
	                }
	            }
	            if mouse_clicked() and global.highlighted==noone{
	                grabbed = cid;
	                holding_audio = !fold;
	                if fold{
	                if keyboard_check(vk_alt){holding_copy = true;}
	                else{
	                    if !keyboard_check(vk_control) and ds_list_find_index(locked_containers,cid)==-1
	                        and containsearch.text==""{
	                        holding_move = true;
	                        holding_list = list;
	                        if list == container_search{holding_list = container_root_list();}
	                        holding_ind = i;
	                    }
	                }
	                }
	                hold_x=mouse_x; hold_y=mouse_y;
	                if cid==clicked{
	                    aeSetEditingSound(cid,!fold)
	                }else{
	                clicked = cid;
	                if fold{
	                    if open==-1{
	                        ds_list_add(container_expand,expand_id); 
	                    }
	                    else{ds_list_delete(container_expand,open);}
	                }
	                }
	            }
	            if dropped!=-1 and !holding_param and fold{
	                        if holding_copy and !holding_audio and fold{
	                            aeCopyToContainer(dropped,cid);
	                            dropped = -1;
	                            //save_audioedit();
	                        }else{
	                            if ds_list_find_index(locked_containers,container_name(cid))==-1{
	                                if holding_audio{
	                                    if holding_move{
	                                        if list==holding_list and i>holding_ind{i -= 1;}
	                                        aeDeleteDropped();
	                                    }
	                                    ds_list_insert(list,i,dropped);
	                                    dropped = -1;
	                                    //save_audioedit();
	                                    }
	                                else{
	                                    if ds_list_find_index(parent,dropped)==-1 //if not dropping into myself
	                                        and (!fold or cid!=dropped)
	                                    {
	                                        if holding_move{
	                                            if list==holding_list and i>holding_ind{i -= 1;}
	                                            aeDeleteDropped();
	                                            }
                                            
	                                        var to_drop = dropped;
	                                        if !holding_audio{to_drop = string(dropped);}
	                                        if fold{
	                                            ds_list_add(container_contents(cid),to_drop);
	                                            aeResetBlendMap(cid);
	                                            }
	                                        else{
	                                            ds_list_insert(list,i,to_drop);
	                                            if ds_list_size(parent)>0{
	                                                aeResetBlendMap(ds_map_find_value(parent,ds_list_size(parent)-1));
	                                                }
	                                            }
                                        
	                                        dropped = -1;
	                                        //save_audioedit();
	                                        }else{
	                                        show_message("This would put a container inside itself, which is bad news!");
	                                        }
	                                    }
	                            }
	                            //aeResetEditingBlendMap();
	                        }
	                        dropped = -1;
	                        break;
	                    }
	        }
        
	        var pl;
	        if fold{pl = container_is_playing(cid);}
	        else{pl = audio_is_playing(cid);}
	        if pl{draw_sprite_ext(sprAudioButtons,1,xx+16+string_width(string_Hash_to_newline(name))+(16*fold),yy+12,1,1,0,blend,1);}
	    }
	    if fold{
	        if ind>=container_scroll{
	        draw_sprite_ext(sprAudioButtons,2+(open!=-1),xx+16+string_width(string_Hash_to_newline(name)),yy+12,1,1,0,blend,1);
	        if ds_list_find_index(locked_containers,container_name(cid))!=-1{
	            draw_sprite_ext(sprAudioButtons,4,xx-8,yy+12,1,1,0,blend,1);
	            }
	        }
	        if open!=-1{
	            var newparent = ds_list_create();
	            ds_list_copy(newparent,parent);
	            ds_list_add(newparent,cid);
	            var hhh = drawContainerList(container_contents(cid),xx+tab,yy+24,newparent,ind);
	                draw_set_color(color_fg2);
	                draw_line(xx-2,yy+12,xx-2,yy+hhh+12);
	                draw_line(xx-8-2,yy+hhh+12,xx+8-2,yy+hhh+12);
	            yy += hhh;
	            ind += round(hhh/24);
	        }
	    }
	    if ind>=container_scroll{yy += 24;}
	    ind += 1;
	    if ind>container_scroll+50{break;} ///just a guess
	}

	if king{container_scroll = min(ind,container_scroll);}

	ds_list_destroy(parent);
	//draw_text(xx + 350,yst,string(yy-yst)+", "+string((yy-yst)/24))

	return yy-yst;//(n*24)+hh;

	//(72)+24 = yy



}
