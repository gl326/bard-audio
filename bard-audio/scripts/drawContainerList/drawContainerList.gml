/// @description drawContainerList(list,x,y,contain,optional ind)
/// @param list
/// @param x
/// @param y
/// @param contain
/// @param optional ind
function drawContainerList(list,xx,yy,parent=undefined) {
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
	
	var y_top = list_top_y,
		y_bottom = room_height;
	var tab = 16,
		line_h = 24;
	var _i = 0;
	repeat(array_length(list)){
		if yy>y_bottom{
			return yy;	
		}else{
		var item = list[_i],
			fold = false,
			data;
			if yy>=y_top{
				var _name = "";
				if is_real(item){
					draw_set_color(color_fg2);	
					_name = (item>=0)? audio_asset_name(item): "<MISSING SOUND>";
				}else{
					fold = true;
					data = container_getdata(item);
					_name = item;
					draw_sprite_ext(sprAudioButtons,(data.editor_expand)?3: 2,xx-8,yy+12,1,1,0,color_fg,1);
					draw_set_color(color_fg);
				}
				
				//am editing
				if fold?(editing==data):(editing==item){
					draw_rectangle(xx,yy,room_width/3,yy+line_h,false);
					draw_set_color(color_bg);
				}
				
				//am playing
				if fold?(container_is_playing(item)):(audio_is_playing(item)){
					draw_sprite(sprAudioButtons,1,xx-8,yy+12);
					var time = (fold? (container_get_time(item)*1000): current_time),
						anim = .5+(.5*cos(pi/2*time/beatMS(fold?(container_player(item).get_bpm()): undefined))),
						anim_x = lerp(xx,room_width/3,anim);
					draw_rectangle(anim_x-8,yy,anim_x+8,yy+line_h,false);
				}
				
				if fold{
					if data.from_project{
						draw_sprite_ext(sprAudioButtons,8,xx+8+string_width(_name),yy+12,1,1,0,draw_get_color(),1);
					}	
				}
				
				draw_text(xx,yy,_name);
				
				///////interaction.......
				var can_interact = (global.bard_editor_highlighted==noone and global.bard_editor_clicked==noone);
				if mouse_in_region(0,yy,(room_width/3)-4,yy+(line_h)) and can_interact{
		            draw_rectangle(2,yy,(room_width/3)-8,yy+(line_h),true);
		            if holding!=-1{ 
						if fold{
		                if hold_hover_id!=item{
		                    hold_hover_id = item;
		                    hold_hover = 0;
		                }else{
		                    hold_hover += 1;
		                    if hold_hover >= room_speed*.75{
		                        data.editor_expand = true;
		                    }
		                }
						}
		            }
		            if mouse_check_button_pressed(mb_left){
		                grabbed = item;
		                holding_audio = !fold;
		                if fold{
							if keyboard_check(vk_alt){holding_copy = true;}
		                else{
		                    if !keyboard_check(vk_control)
		                        and containsearch.text==""{
		                        holding_move = true;
		                        holding_list = list;
		                        //if list == container_search{holding_list = container_root_list();}
		                        holding_ind = _i;
		                    }
		                }
		                }
		                hold_x=mouse_x; hold_y=mouse_y;
		                if item==clicked{
		                    aeSetEditingSound(item,!fold);
							 if fold{
			                    data.editor_expand = true;
			                }
		                }else{
			                clicked = item;
							 if fold and !keyboard_check(vk_anykey){
			                    data.editor_expand = !data.editor_expand;
			                }
		                }
		            }
		            if dropped!=-1 and !holding_param and fold{
		                        if holding_copy and !holding_audio and fold{
		                            aeCopyToContainer(dropped,item);
		                            dropped = -1;
		                            //save_audioedit();
		                        }else{
		                            if !data.from_project{
		                                if holding_audio{
		                                    if holding_move{
		                                        if list==holding_list and i>holding_ind{
													_i -= 1;
												}
		                                        aeDeleteDropped();
		                                    }
		                                    array_push(data.contents,dropped);
											array_push(data.contents_serialize,container_content_serialize(dropped));
		                                    dropped = -1;
		                                    //save_audioedit();
		                                    }
		                                else{
		                                    if data.parent!=dropped //if not dropping into myself
		                                        and (!fold or item!=dropped)
		                                    {
		                                        if holding_move{
		                                            if list==holding_list and i>holding_ind{_i -= 1;}
		                                            aeDeleteDropped();
		                                            }
                                            
		                                        if fold{
													array_push(data.contents,dropped);
													array_push(data.contents_serialize,container_content_serialize(dropped));
		                                            aeResetBlendMap(item);
		                                            }
		                                        else{
		                                            array_insert(list,_i,dropped);
													array_insert(parent.contents_serialize,_i,container_content_serialize(dropped));
		                                            aeResetBlendMap(parent);   
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
				
				////////////////
				
			}
		}
		yy += line_h;
		
		if fold{
			if (data.editor_expand){
				yy = drawContainerList(container_getdata(item).contents,xx+tab,yy,item);
			}
		}
		
		_i ++;	
	}
	
	return yy;
	
	exit;
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
	        name = audio_asset_name(con);
	    }
    
	    if ind>=container_scroll{
	        draw_set_color(color_fg2);
	        draw_line(xx-tab-2,yy+12,xx-2,yy+12);
	        if fold{draw_set_color(color_fg);}
                
	        if editing == cid and fold==!editing_audio{
	            draw_rectangle(2,yy,(room_width/3)-8,yy+(24),false);
	            draw_set_color(color_bg2);
	            blend = color_bg2;
	        }
	        /*if con==container{
	            draw_rectangle(8,(72)+24+(36*i),(room_width/3)-8,(72)+24+(36*i)+36,false);
	            d3d_set_fog(0,color_fg,0,0);
	        }*/
	        draw_text(xx,yy,(name)/*+" ("+string(con)+")"*/);
	        //if con==container{d3d_set_fog(true,color_fg,0,0);}
	        if mouse_in_region(8,yy,(room_width/3)-8,yy+(24)){
	            draw_rectangle(2,yy,(room_width/3)-8,yy+(24),true);
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
	            if mouse_check_button_pressed(mb_left) and global.bard_editor_highlighted==noone{
	                grabbed = cid;
	                holding_audio = !fold;
	                if fold{
	                if keyboard_check(vk_alt){holding_copy = true;}
	                else{
	                    if !keyboard_check(vk_control) and ds_list_find_index(locked_containers,cid)==-1
	                        and containsearch.text==""{
	                        holding_move = true;
	                        holding_list = list;
							holding_parent = parent;
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
	        if pl{draw_sprite_ext(sprAudioButtons,1,xx+16+string_width((name))+(16*fold),yy+12,1,1,0,blend,1);}
	    }
	    if fold{
	        if ind>=container_scroll{
	        draw_sprite_ext(sprAudioButtons,2+(open!=-1),xx+16+string_width((name)),yy+12,1,1,0,blend,1);
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
