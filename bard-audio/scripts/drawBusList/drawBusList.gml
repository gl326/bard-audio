/// @description drawBusList(list,x,y)
/// @param list
/// @param x
/// @param y
function drawBusList() {
	var list=argument[0], 
		xx=argument[1],
		yy=argument[2],
		//parent=-1,
		ind = 0,
		yst = yy;
	var n = ds_list_size(list);
	for(var i=0;i<n;i+=1){
	    var bus = ds_list_find_value(list,i);
	    var con = ds_map_find_value(global.audio_busses,bus);
	    var open = ds_list_find_index(bus_expand,bus);
	        draw_set_color(color_fg);
	    var blend = color_fg;
	    var gain = ds_map_find_value(con,"gain");
		if gain>-100{
			gain = 20*log10((gain/100)+1);
		}else{gain = -144;}
		var line = bus+" ("+string(gain)+"dB)",
	        contlist = ds_map_find_value(bushierarchy,bus);
    
	    if ind>=bus_scroll{
	        /*if editing == cid and fold==!editing_audio{
	            draw_Rectangle(2,yy,(room_width/3)-8,yy+(24),false);
	            draw_set_color(color_bg2);
	            blend = color_bg2;
	        }*/
	        draw_text(xx,yy,string_Hash_to_newline(line));
        
	        if mouse_in_region(8,yy,(room_width/3)-8,yy+(24)){
	            draw_Rectangle(2,yy,(room_width/3)-8,yy+(24),true);
	            if holding!=-1{ 
	                if hold_hover_id!=bus{
	                    hold_hover_id = bus;
	                    hold_hover = 0;
	                }else{
	                    hold_hover += 1;
	                    if hold_hover >= room_speed*.75{
	                        if open==-1{
	                            ds_list_add(bus_expand,bus); 
	                        }
	                    }
	                }
	            }
	            if mouse_clicked() and global.highlighted==noone{
	                grabbed = con;
	                holding_bus = true;
	                if keyboard_check(vk_alt){holding_copy = true;}
	                else{
	                        holding_move = true;
	                        //can find list from parent id
	                }
	                hold_x=mouse_x; hold_y=mouse_y;
	                if clicked==con{
	                    //OPEN EDITOR PANEL
	                    //var pw = 300,ph=128,px=max(0,mouse_x-(pw/2)),py=mouse_y-(py/2);
	                    //var pan = aeNewEditorpanel(objEditorpanel,px,py,pw,ph);
	                    clicked = -1;
	                    var pw=400, ph=124, px = max(0,mouse_x-(pw/2)), py = mouse_y-(ph/2);
	                    var mymap = ds_map_find_value(global.audio_busses,bus);
	                    var pan = aeNewEditorpanel(objEditorpanel,px,py,pw,ph);
	                        pan.title = bus;
	                    var stf = newHighlightable(objTextfield,px+16,py+16+24,px+pw-16,py+24+(50)-8);
	                        stf.editing = mymap; stf.param = "gain"; stf.draggable=true;
	                        stf.dB = true;
	                        var text,val = ds_map_find_value(mymap,"gain")/100;
	                        if val>-1{
	                            text = string(20*log10(val+1))
	                        }else{
	                            text = "-144";
	                        }
	                        stf.text = text; stf.plusmin = true; //stf.percent = true;
	                    var deb = newHighlightable(objaeButton,px+16,py+24+(50)+8,px+pw-16,py+ph-16);
	                        deb.script = aeDeleteBus; deb.name="DELETE"; deb.args[0] = bus;
	                    list_Add(pan.children,stf,deb);
	                }
	            else{
	                clicked = con;
	                    if open==-1{
	                        ds_list_add(bus_expand,bus); 
	                    }
	                    else{ds_list_delete(bus_expand,ds_list_find_index(bus_expand,bus));}
	                }
	            }
	            if dropped!=-1 and holding_bus{
	                        if holding_copy{
	                            ////COPY????
	                            dropped = -1; holding_copy = false;
	                            save_audioedit();
	                        }else{
	                            var oldpar = ds_map_find_value(dropped,"parent"),
	                                dropname = ds_map_find_value(dropped,"name");
	                            var checking = bus,doit=true;
	                            while(is_string(checking)){
	                                if dropname!=checking{
	                                    checking = ds_map_find_value(
	                                        ds_map_find_value(global.audio_busses,checking),
	                                        "parent"
	                                    );
	                                }else{doit = false; break;}
	                            }
	                            if doit{
	                                var oldlist;
	                                if is_string(oldpar){oldlist = ds_map_find_value(bushierarchy,oldpar);}
	                                else{oldlist = busses;}
	                                ds_list_delete(oldlist,ds_list_find_index(oldlist,dropname));
	                                ds_map_replace(dropped,"parent",bus);
	                                ds_list_add(ds_map_find_value(bushierarchy,bus),dropname); 
	                                save_audioedit();
	                            }       
	                        }
	                        dropped = -1;
	                        holding_bus = false;
	                        break;
	                    }
	        }
	    }
	        if ind>=bus_scroll and ds_list_size(contlist)>0{
	        draw_sprite_ext(sprAudioButtons,2+(open!=-1),xx+16+string_width(string_Hash_to_newline(string(line))),yy+12,1,1,0,blend,1);
	        }
	        if open!=-1{
	            var hhh = drawBusList(contlist,xx+16,yy+24);
	            yy += hhh;
	            ind += round(hhh/24);
	        }
	    if ind>=bus_scroll{yy += 24;}
	    ind += 1;
	}

	//draw_text(xx + 350,yst,string(yy-yst)+", "+string((yy-yst)/24))

	return yy-yst;//(n*24)+hh;

	//(72)+24 = yy



}
