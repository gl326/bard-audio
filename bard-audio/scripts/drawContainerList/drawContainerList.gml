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
	browser_length += array_length(list);
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
			fold = !is_real(item),
			data = fold? container_getdata(item) : undefined;
			if yy>=y_top{
				var _name = "";
				if is_real(item){
					draw_set_color(color_fg2);	
					_name = (item>=0)? audio_asset_name(item): "<MISSING SOUND>";
				}else{
					//fold = true;
					//data = container_getdata(item);
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
}