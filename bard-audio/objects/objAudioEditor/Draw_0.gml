if audio_loaded{
var butt_h = 36,butt_g = 8,
	vx = 0,
	vy = 0,
	vw = room_width,
	vh = room_height,
	vx2=vx+vw,
	vy2=vy+vh;

draw_rectangle_colour(
    vx,vy,vx2,vy2,
    color_bg,color_bg,
    color_bg2,color_bg2,
    false
);

draw_set_font(-1);
draw_set_color(color_fg);

draw_sprite(sprAudioButtons,0,16,24+36); //search

draw_line(room_width/3,0,room_width/3,room_height);
draw_set_halign(fa_left);

switch(tab){
case 2:
drawBusList(bus_search,16,24+72+36);
break;

case 1:
drawParamList(param_search,16,24+72+36);
break;

default:
drawContainerList(container_search,16,24+72+36);
break;
}

if editing!=-1{
    if editing_audio{
        draw_set_color(color_fg2);
        draw_text_transformed(
            (room_width/3) + 8+96+8, 8,
            (audio_get_name(editing)),
            2,2,0
        );
        draw_set_color(color_fg);
        draw_text((room_width/3)+(room_width*3/9)+8,8+48+8+butt_h+8,("GAIN"));
        draw_text((room_width/3)+(room_width*4.5/9)+8,8+48+8+butt_h+8,("BUS"));
        if ds_map_exists(global.audio_busses,assetbusbut.text){
            draw_sprite(sprAudioButtons,7,(room_width/3)+(room_width*4.5/9)+8+string_width(("BUS"))+12,12+8+48+8+butt_h+8);
            }
    }else{
    if ds_exists(editing,ds_type_map){
        draw_set_color(color_fg);
        draw_set_halign(fa_right);
        if container_type(editing)==2{
            draw_text((room_width/3)+(room_width*2/9),(8*4)+(36*4)+4,("AMT"));
        }
        draw_text((room_width/3)+(room_width*4.5/9),8,("BUS"));
        if ds_map_exists(global.audio_busses,busbut.text){
            draw_sprite(sprAudioButtons,7,(room_width/3)+(room_width*4.5/9)-string_width(("BUS"))-12,8+12);
            }
        draw_set_halign(fa_left);
        draw_text_transformed(
            (room_width/3) + 8+96+8, 8,
            (container_name(editing)),
            2,2,0
        );
        
        
        //draw_text((room_width*2/3) + 8,room_height/4,"VOL min-max");
        //draw_text((room_width*2/3) + 8,(room_height/4)+88,"PITCH min-max");
        for(var i=0;i<ds_list_size(headers);i+=1){
            var h = ds_list_find_value(headers,i);
            if ds_map_find_value(h,"obj").visible{
                draw_text(ds_map_find_value(h,"x"),ds_map_find_value(h,"y"),(ds_map_find_value(h,"text")));
            }
        }
        
        draw_text((room_width/3) + 8,room_height/4,("CONTENTS"));
        draw_set_color(choice(c_black,color_bg2,palette_light));
        var l =(room_width/3) + 8,
            t=(room_height/4)+24,
            r=(room_width/3)+(room_width/3)-8,
            b=room_height-8;
        draw_rectangle(l,t,r,b,false);
        var cont = container_contents(editing),cn = ds_list_size(cont),stopdrop = false;
        var locked = !(ds_list_find_index(locked_containers,container_name(editing))==-1);
        for(var i=0;i<cn;i+=1){
            var c = ds_list_find_value(cont,i),name;
            if is_string(c){
                name = container_name(real(c));
                draw_set_color(color_fg);}
            else{
                name = audio_get_name(c);
                draw_set_color(color_fg2)}
            var yy = t+(i*24);
            if mouse_in_region(l,yy,r,yy+24) and global.highlighted==noone{
                draw_rectangle(l,yy,r,yy+24,true);
                //if ds_list_find_index(locked_containers,container_name(editing))==-1
                {
                    if mouse_clicked() and keyboard_check(vk_delete) and !locked{
                        ds_list_delete(cont,i);
                        aeResetBlendMap(editing);
                        aeCountReferences();
                        //save_audioedit();
                        break;
                    }
                    if mouse_clicked(){
                        if !locked{
                        grabbed = real(c);
                        holding_audio = !is_string(c);
                        if keyboard_check(vk_alt){
                                holding_copy = true;
                            }else{
                        if !keyboard_check(vk_control){
                            holding_move = true;
                            holding_ind = i;
                            holding_list = cont;
                            }
                        }
                        hold_x=mouse_x; hold_y=mouse_y;
                        }
                        if real(c)==clicked{
                            aeSetEditingSound(real(c),!is_string(c))
                        }else{
                        clicked = real(c);
                        }
                    }
                    if dropped!=-1 and !locked and !holding_param{
                        stopdrop = true;
                        if holding_copy and !holding_audio and is_string(c){
                            aeCopyToContainer(dropped,real(c));
                            aeResetBlendMap(editing);
                            //save_audioedit();
                        }else{
                            if holding_audio{
                                if holding_move{
                                    if cont==holding_list and i>holding_ind{i -= 1;}
                                    aeDeleteDropped();
                                }
                                ds_list_insert(cont,i,dropped);
                                aeResetBlendMap(editing);
                                //save_audioedit();
                                }
                            else{if dropped!=editing{
                                if holding_move{
                                    if cont==holding_list and i>holding_ind{i -= 1;}
                                    aeDeleteDropped();
                                }
                                ds_list_insert(cont,i,string(dropped));
                                aeResetBlendMap(editing);
                                //save_audioedit();
                                }}
                            
                        }
                        break;
                    }
                }
            }
            name = string_copy(name,1,min(string_length(name),80));
            draw_text(l+8,yy,(name));
            var pl;
            if is_string(c){pl = container_is_playing(c);}
            else{pl = audio_is_playing(c);}
            if pl{draw_sprite_ext(sprAudioButtons,1,l+8+string_width((name)),yy+12,1,1,0,draw_get_color(),1);}
        }
        if !stopdrop and !locked and !holding_param{ //dropped not in list
            if dropped!=-1 and mouse_in_region(l,t,r,b) and !holding_copy{
                    if holding_audio{
                        if holding_move{
                            aeDeleteDropped();
                        }
                        ds_list_add(cont,dropped);
                        aeResetBlendMap(editing);
                        //save_audioedit();
                        }
                    else{if dropped!=editing{
                        if holding_move{
                            aeDeleteDropped();
                        }
                        ds_list_add(cont,string(dropped));
                        aeResetBlendMap(editing);
                        //save_audioedit();
                        }}
                    
            }
        }
        }
    }
}

if holding!=-1{
    if hold_x==-1 and hold_y==-1{
    var name;
        if holding_audio{
            draw_set_color(color_fg2);
            name = audio_get_name(holding);
            }
        else{
            draw_set_color(color_fg);
            name = container_name(real(holding));
            }
        if holding_copy{name+="#COPYING"}
        else{if holding_move{name+="#MOVING"}
            else{name+="#REFERENCING";}}
        draw_text(mouse_x,mouse_y,(name));
    }
}
}else{
    draw_set_color(c_black);
    draw_set_font(ftDebug);
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
	if audio_load_progress<2{
		draw_text_transformed(__view_get( e__VW.XView, 0 ),__view_get( e__VW.YView, 0 )+__view_get( e__VW.HView, 0 ),("Loading "+string(files_loaded)+" files..."),2,2,0);
	}else{
		draw_text_transformed(__view_get( e__VW.XView, 0 ),__view_get( e__VW.YView, 0 )+__view_get( e__VW.HView, 0 ),("Loading "+string(files_loaded)+" files + folders..."),2,2,0);
	}
}

