event_inherited();

draw_text(l+8,t+2,(string(param)+": "+string(attribute)));

var gmax = ymax,
	gmin = ymin;

//draw region and guideliens
draw_set_color(c_black);//draw_set_color(choice(c_black,objAudioEditor.color_fg,objAudioEditor.palette_light));
draw_rectangle(gl,gt,gr,gb,false);

draw_set_color(objAudioEditor.color_fg);
draw_line(gl,gt,gl,gb);
draw_line(gl,gb,gr,gb);

var divs=(ceil(ymax-ymin)/25);
while(divs<8){divs*=2;}
draw_set_halign(fa_right); draw_set_valign(fa_middle);
for(var i=0;i<=divs;i+=1){
    draw_set_alpha(1);
    var yy = lerp(gb,gt,i/divs);
	var yperc = lerp(ymin,ymax,i/divs);
	if dB{
		draw_text(gl-2,yy,string(20*log10((yperc/100)+1))+"dB");
	}else{
		draw_text(gl-2,yy,string(yperc)+"%");
	}
    draw_set_alpha(.5);
    draw_line(gl,yy,gr,yy);
}

divs=4;
draw_set_halign(fa_center); draw_set_valign(fa_top);
for(var i=0;i<=divs;i+=1){
    draw_set_alpha(1);
    var xx = lerp(gl,gr,i/divs);
    draw_text(xx,gb+4,(string(lerp(xmin,xmax,i/divs))));
    draw_set_alpha(.5);
    draw_line(xx,gt,xx,gb);
}
draw_set_alpha(1);
draw_text(lerp(gr,gl,.5),gb+4+24+8,(string(param)));

if mouse_in_region(gl,gb,gr,b-32){
    draw_set_color(objAudioEditor.color_fg)
    draw_rectangle(gl,gb+4+24,gr,gb+4+24+8+24+8,false);
    draw_set_color(objAudioEditor.color_bg);
    draw_text(lerp(gr,gl,.5),gb+4+24+8,(string(param)));
    draw_set_color(objAudioEditor.color_fg2);
    var yy = gt;
    var xx = remap_value(audio_param_state(param),0,100,gl,gr);
    if curves!=-1{
        yy = remap_value(curve_eval(curve,audio_param_state(param)),gmin,gmax,gb,gt);
        draw_circle(xx,yy,8,1);
    }
    draw_line(xx,yy,xx,gb+4+24+8);
    draw_line(lerp(gr,gl,.5),gb+4+24+8,xx,gb+4+24+8);
    if mouse_check_button(mb_left){
        //ds_map_Replace(global.audio_state,param,remap_value(mouse_x,gl,gr,0,100));
        audio_param_set(param,remap_value(mouse_x,gl,gr,0,100));
    }
}
//draw blend regions
if is_array(blend) and !is_struct(curves){
    var cn = 0;
    var n = array_length(blend),
        yt = gmax*min(1,n/4);
    draw_set_halign(fa_left);
    for(var i=0;i<n;i+=1){
        var col = ds_list_find_value(objAudioEditor.editor_colors,(cn+i) mod ds_list_size(objAudioEditor.editor_colors)),
            bl = blend[i],
            yy = yt- choice(((i mod 4)*50),(i mod 8)*25,n>4), 
            y1 = remap_value(yy,-gmax,gmax,gb,gt),
            y2 = remap_value(yy-50,-gmax,gmax,gb,gt),
            
            left = remap_value(bl.left,0,100,gl,gr),
            right = remap_value(bl.right,0,100,gl,gr),
            cleft = remap_value(bl.cleft,0,100,gl,gr),
            cright = remap_value(bl.cright,0,100,gl,gr),
            cont = container_contents(objAudioEditor.editing)[i],
            name="";
        if is_real(cont) or is_string(cont){
        if blend_highlight==i{
            col = merge_color(col,c_white,.25);
            draw_set_color(col);
            draw_line_width(left,gt,left,gb,2);
            draw_line(cleft,gt,cleft,gb);
            draw_line(cright,gt,cright,gb);
            draw_line_width(right,gt,right,gb,2);
            switch(blend_param_highlight){
                case "left": draw_line_width(left,gt,left,gb,4); break;
                case "right": draw_line_width(right,gt,right,gb,4); break;
                case "cleft": draw_line_width(cleft,gt,cleft,gb,4); break;
                case "cright": draw_line_width(cright,gt,cright,gb,4); break;
            }
            }
            else{draw_set_color(col);}
            if is_string(cont){name = cont;}
            else{name = audio_get_name(cont);}
        draw_set_alpha(.25);
        draw_blendregion(left,y1,right,y2,cleft,cright,false);
        //draw_rectangle(left,y1,right,y2,false);
        draw_rectangle(cleft,y1,cright,y2,false);
        draw_set_alpha(1);
        draw_blendregion(left,y1,right,y2,cleft,cright,true);
        //draw_rectangle(left,y1,right,y2,true);
        draw_text_ext(cleft+2,y1+2,(name),-1,cright-cleft-4);
        }
    }
}

draw_set_halign(fa_center);
//draw points and lineS
if is_struct(curves){
	var col = ds_list_find_value(objAudioEditor.editor_colors,0);
	var k = curve_name;
	draw_set_color(col);
    draw_text(lerp(l,r,.5/*(j+1)/(cn+1)*/),t+28,(k));
	var _i = 0,
		pts = curves.points,
		pts_n = array_length(pts),
		ppx = "", ppy = "";
	repeat(pts_n){
		var p = pts[_i],
            px = p.x,
            py = p.y,
			xx = lerp(gr,gl,(xmax-px)/(xmax-xmin)),
            yy = lerp(gt,gb,(ymax-py)/(ymax-ymin));
			
		draw_set_color(objAudioEditor.color_fg);
        if grabbed==_i{
            draw_circle(xx,yy,grab_range,false);
        }else{
            if editing_point==_i{
                draw_circle(xx,yy,grab_range,true);
            }
        }
		
		draw_set_color(col);
		draw_circle(xx,yy,8,false);
        if _i==0{draw_line_width(gl,yy,xx,yy,4);}
        if _i==pts_n-1{draw_line_width(gr,yy,xx,yy,4);}
        if !is_string(ppx){
            draw_line_width(ppx,ppy,xx,yy,4);
            if debug_mode{
                draw_set_color(c_white);
                draw_arrow(ppx,ppy,xx,yy,8);
            }
        }
        
        if grabbed==-1{
	        if point_distance(mouse_x,mouse_y,xx,yy)<grab_range{
	            draw_dotted_circle(xx,yy,grab_range+1);
	        }
        }
        ppx = xx; ppy = yy;
		
		_i ++;
	}
	
	draw_set_color(objAudioEditor.color_fg);
	
	//draw underside params
	draw_set_halign(fa_right);
	draw_text(l+text_w-4,b-24,("x"));
	draw_text(lerp(l,r,1/2)+text_w-4,b-24,("y"));
	//draw_text(lerp(l,r,2/3)+text_w-4,b-24,("pow"));
	draw_set_halign(fa_left);
}
exit; ////////////////////////

if curves!=-1{
//var cn = ds_list_size(curve_list);
//var stopdel = false;
//for(var j=cn-1;j>=0;j-=1){
    //var k = ds_list_find_value(curve_list,j);
    var col = ds_list_find_value(objAudioEditor.editor_colors,0);//ds_list_find_index(curve_ind,k) mod ds_list_size(objAudioEditor.editor_colors));
    var k = curve_name;
	draw_set_color(col);
    draw_text(lerp(l,r,.5/*(j+1)/(cn+1)*/),t+28,(k));
    var cur = ds_map_find_value(curves,k);
    var pts = ds_map_find_value(cur,"points");
    var n = ds_list_size(pts),ppx = "", ppy = "";
    for(var i=0;i<n;i+=1){
        var p = ds_list_find_value(pts,i),
            px = ds_map_Find_value(p,"x"),
            py = ds_map_Find_value(p,"y"),
			xx = lerp(gr,gl,(xmax-px)/(xmax-xmin)),
            yy = lerp(gt,gb,(ymax-py)/(ymax-ymin));
        if curve==cur{
        draw_set_color(objAudioEditor.color_fg);
        if grabbed==i{
            draw_circle(xx,yy,grab_range,false);
        }else{
            if editing_point==i{
                draw_circle(xx,yy,grab_range,true);
            }
        }
        }
        if curve_highlight == cur{draw_set_color(merge_color(col,c_white,.5));}
        else{draw_set_color(col);}
        draw_circle(xx,yy,8,false);
        if i==0{draw_line_width(gl,yy,xx,yy,4);}
        if i==n-1{draw_line_width(gr,yy,xx,yy,4);}
        if !is_string(ppx){
            draw_line_width(ppx,ppy,xx,yy,4);
            if debug_mode{
                draw_set_color(c_white);
                draw_arrow(ppx,ppy,xx,yy,8);
            }
        }
        
        if grabbed==-1{
        if point_distance(mouse_x,mouse_y,xx,yy)<grab_range{
            draw_dotted_circle(xx,yy,grab_range+1);
        }
        }
        ppx = xx; ppy = yy;
    }
//}



if grabbed!=-1{
    //debug
    //draw_text(room_width*2/3,room_height*2/3,string(grabbed)+"#"+string(ds_list_find_value(points,grabbed)));
}
}

