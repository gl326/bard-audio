/// @description drawBusList(list,x,y)
/// @param list
/// @param x
/// @param y
function drawBusList(list,xx,yy) {
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
				data = bus_getdata(item);
			if yy>=y_top{
				#region draw
				////////draw
				draw_set_color(color_fg);
			    var blend = color_fg,
					open = -1;
			    var gain = data.default_gain/100;
				if gain>-1{
					gain = PercentToDB(gain);
				}else{gain = -144;}
				var line = data.name+" ("+string(gain)+"dB)";
				
				draw_sprite_ext(sprAudioButtons,2+(data.editor_expand),xx-8,yy+12,1,1,0,blend,1);
				draw_text(xx,yy,(line));
				#endregion
				#region interact
				/////interact
				var can_interact = (global.bard_editor_highlighted==noone and global.bard_editor_clicked==noone);
				if mouse_in_region(8,yy,(room_width/3)-8,yy+(24)) and can_interact{
		            draw_rectangle(2,yy,(room_width/3)-8,yy+(24),true);
		            if holding!=-1{ 
		                if hold_hover_id!=data.name{
		                    hold_hover_id = data.name;
		                    hold_hover = 0;
		                }else{
		                    hold_hover += 1;
		                    if hold_hover >= room_speed*.75{
		                        if open==-1{
		                            data.editor_expand = true;
		                        }
		                    }
		                }
		            }
		            if mouse_check_button_pressed(mb_left){
		                grabbed = data.name;
		                holding_bus = true;
						holding_audio = false;
		                if keyboard_check(vk_alt){holding_copy = true;}
		                else{
		                        holding_move = true;
		                        //can find list from parent id
		                }
		                hold_x=mouse_x; hold_y=mouse_y;
		                if clicked==data.name{
							data.editor_expand = true;
		                    //OPEN EDITOR PANEL
		                    //var pw = 300,ph=128,px=max(0,mouse_x-(pw/2)),py=mouse_y-(py/2);
		                    //var pan = aeNewEditorpanel(objEditorpanel,px,py,pw,ph);
		                    clicked = -1;
		                    var pw=400, ph=124+40, px = max(0,mouse_x-(pw/2)), py = mouse_y-(ph/2);
		                    var pan = aeNewEditorpanel(objEditorpanel,px,py,pw,ph);
		                        pan.title = data.name;
		                    var stf = newHighlightable(objTextfield,px+16,py+16+24,px+pw-16,py+24+(50)-8);
		                        stf.editing = data; stf.param = "default_gain"; stf.draggable=true;
		                        stf.dB = true;
								stf.update_func = aeUpdateBusGain;
		                        var text,val = data.default_gain/100;
		                        if val>-1{
		                            text = string(PercentToDB(val))
		                        }else{
		                            text = "-144";
		                        }
		                        stf.text = text; stf.plusmin = true; //stf.percent = true;
								
							 var eff = newHighlightable(objaeButton,px+16,py+ph-26-8-55,px+pw-16,py+ph-36-8);
		                        eff.script = aeCreateEffectsPanel; eff.name="EFFECTS ("+string(array_length(data.effects))+")"; eff.args[0] = data;
								
		                    var deb = newHighlightable(objaeButton,px+16,py+ph-36,px+pw-16,py+ph-8);
		                        deb.script = aeDeleteBus; deb.name="DELETE"; deb.args[0] = data.name;
		                    list_Add(pan.children,stf,deb,eff);
		                }
		            else{
		                clicked = data.name;
							if !keyboard_check(vk_anykey){
			                    data.editor_expand = !data.editor_expand;
			                }
		                    else{ds_list_delete(bus_expand,ds_list_find_index(bus_expand,bus));}
		                }
		            }
					//dropped a new child bus
		            if is_string(dropped) and holding_bus{
		                        if holding_copy{
									data.copy_from_bus(dropped);
		                            dropped = -1; holding_copy = false;
		                        }else{
									var dropped_data = global.audio_busses[?dropped];
		                            var oldpar = dropped_data.parent,
		                                dropname = dropped_data.name;
		                            var checking = data.name,
										doit=true;
		                            while(is_string(checking)){
		                                if dropname!=checking{
		                                    checking = global.audio_busses[?checking].parent;
		                                }else{doit = false; break;}
		                            }
		                            if doit{
		                                if is_string(oldpar){
											var oldlist = global.audio_busses[?oldpar].children;
											array_delete(oldlist,array_find_index(oldlist,dropname),1);
										}
										dropped_data.parent = data.name;
		                                array_push(data.children,dropped);
		                            }       
									
									data.editor_expand = true;
									aeBrowserUpdate();
		                        }
		                        dropped = -1;
		                        holding_bus = false;
		                        break;
		                    }
		        }
				#endregion
			}
		}
		
		yy += line_h;
		
		if (data.editor_expand){
			yy = drawBusList(data.children,xx+tab,yy);
		}
		
		_i ++;
	}
	
	return yy;
}