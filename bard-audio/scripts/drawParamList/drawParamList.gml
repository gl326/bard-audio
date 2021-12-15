/// @description drawParamList(list,x,y)
/// @param list
/// @param x
/// @param y
function drawParamList(list,xx,yy) {
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
			var item = list[_i];
			if yy>=y_top{
				#region draw
					draw_text(xx,yy,(item.name+" ("+string(item.default_value)+")"));
				#endregion
				#region interact
					if mouse_in_region(8,yy,(room_width/3)-8,yy+(24)){
				        draw_rectangle(2,yy,(room_width/3)-8,yy+(24),true);
				        if mouse_check_button_pressed(mb_left) and global.highlighted==noone{
				            holding = item.name;
				            grabbed = item.name;
				            holding_audio = false;
							holding_bus = false;
				            holding_param = true;
				            hold_x=mouse_x; hold_y=mouse_y;
				            if clicked==item.name{
				                    //var pw = 300,ph=128,px=max(0,mouse_x-(pw/2)),py=mouse_y-(py/2);
				                    //var pan = aeNewEditorpanel(objEditorpanel,px,py,pw,ph);
				                    clicked = -1;
				                    var pw=400, ph=124, px = max(0,mouse_x-(pw/2)), py = mouse_y-(ph/2);
				                    var pan = aeNewEditorpanel(objEditorpanel,px,py,pw,ph);
				                        pan.title = item.name;
				                    var stf = newHighlightable(objTextfield,px+16,py+16+24,px+pw-16,py+24+(50)-8);
				                        stf.editing = item; stf.param = "val"; stf.draggable=true;
				                        stf.text = string(audio_param_state(item.name));
				                    var deb = newHighlightable(objaeButton,px+16,py+24+(50)+8,px+pw-16,py+ph-16);
				                        deb.script = aeEditParamDefault; deb.name="EDIT DEFAULT"; deb.args[0] = item;
				                    list_Add(pan.children,stf,deb);
				                }
				            else{clicked = item.name;}
				        }
				        if mouse_check_button_pressed(mb_left) and keyboard_check(vk_delete){
				            if show_question("delete the parameter "+item.name+"?"){
				                ////destroy all references
								var _data = global.bard_audio_data[bard_audio_class.parameter];
								array_delete(_data,array_find_index(_data,item),1);
								ds_map_delete(global.audio_params,item.name);
				                aeBrowserUpdate();
				                break;
				            }
				        }
				    }
				#endregion
			}
		}
		
		yy += line_h;
		
		_i ++;
	}
	
	return yy;
}
