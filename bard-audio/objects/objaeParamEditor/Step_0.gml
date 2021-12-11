var gmax = ymax,
	gmin = ymin;
if !firstframe{
	
	if attribute=="gain"{
		dB = true;
		ymax = 25;	
	}
	

/* curve editing *//////////////////////////////////////
if is_struct(curves) and blend_param_drag==""{
	var points = curves.points;
	if grabbed!=-1{ //dragging a point
	    editing_point = grabbed;
	        xf.editing = points[grabbed];
	        yf.editing = points[grabbed];
	        //pf.editing = grabbed;
	    global.highlighted = -1; //NOT noone
	    if !mouse_check_button(mb_left){
	        grabbed = -1; global.highlighted=noone;
	        }
	    else{
	        var p = points[grabbed],
	            xx = clamp(remap_value(mouse_x+grab_x,gl,gr,0,100),0,100),
	            yy = clamp(remap_value(mouse_y+grab_y,gt,gb,gmax,gmin),-100,100);
	        p.x = xx;
	        p.y = yy;
	        xf.text = string(xx);
			yf.dB = dB;
			if dB{
				yf.text = string(20*log10((yy/100)+1));
			}else{
				yf.text = string(yy);
			}
	        curves.sort(true);
			grabbed = array_find_index(curves.points,p);
	    }
	}else{
	    if mouse_in_region(gl-grab_range,gt-grab_range,gr+grab_range,gb+grab_range) and grabbed == -1{ //highlighting and click curves
	    var stopdel = false;
	     ///////set editing curve//////////
	    //var cn = ds_list_size(curve_list);
	    curve_highlight = -1;
	   // for(var j=0;j<cn;j+=1){
	        //var k = curve_name;//ds_list_find_value(curve_list,j);
	        //var cur = ds_map_find_value(curves,k);
	        var pts = points,
			n = array_length(pts);
	        var ppx="", ppy="";
	        for(var i=0;i<n;i+=1){
	            var pp = pts[i];
	            var px = remap_value(pp.x,0,100,gl,gr),
	                py = remap_value(pp.y,gmin,gmax,gb,gt);
	            if !is_string(ppx){
	                var dir = point_direction(ppx,ppy,px,py),
	                    dis = 4,
	                    lx = lengthdir_x(dis,dir+90),
	                    ly = lengthdir_y(dis,dir+90);
	                if point_in_triangle(mouse_x,mouse_y,ppx+lx,ppy+ly,ppx-lx,ppy-ly,px+lx,py+ly)
	                or point_in_triangle(mouse_x,mouse_y,px+lx,py+ly,px-lx,py-ly,ppx-lx,ppy-ly)
	                or point_distance(mouse_x,mouse_y,px,py)<=grab_range{
	                    //curve_highlight = cur;
	                    attribute = curve_name;
	                    if mouse_check_button_pressed(mb_left){
	                        //curve = cur; 
							points = pts;
	                        }
	                    break;
	                }
	            }
	            ppx = px;
	            ppy = py;
	        }
	        //if curve_highlight!=-1{break;}
	    //}
    
	    //////////////grab points///////////
	    var n = array_length(points),doit=true,pts=points;
	    var pp =-1,ins = -1;
	    var xx = remap_value(mouse_x,gl,gr,0,100),
	        yy = remap_value(mouse_y,gt,gb,gmax,gmin);
	        for(var i=0;i<n;i+=1){
	            pp = pts[i];
	            var px = pp.x;
	            //show_message(string(pp)+": "+string(px));
	            var pxx = remap_value(px,0,100,gl,gr),
	                pyy = remap_value(pp.y,gmin,gmax,gb,gt);
	            if point_distance(mouse_x,mouse_y,pxx,pyy)<=grab_range{
	                doit = false;
	                if mouse_check_button_pressed(mb_left){
	                    grabbed = i;
	                    editing_point = i;
	                    grab_x = pxx-mouse_x;
	                    grab_y = pyy-mouse_y;
	                    xf.editing = pp;
	                    yf.editing = pp;
	                    //pf.editing = pp;
	                }else{
	                if mouse_check_button_pressed(mb_right) and array_length(pts)>1 and !stopdel{
	                    doit = false;
	                    array_delete(pts,i,1);
	                    stopdel = true;
	                    if editing_point==i{
	                        editing_point = -1;
	                        xf.editing = -1;
	                        yf.editing = -1;
	                       // pf.editing = -1;
	                    }
	                }}
	            break;
	            }
	            if px<xx{ins = i+1;}else{break;}
	        }
        
	        //////add new point/////////
	        if doit and mouse_check_button_pressed(mb_left) and grabbed ==-1{
		        var np = curves.point_add(xx,yy);
		        curves.sort(true);
		        grabbed = array_find_index(curves.points,np);
	        }
	    }
	}   
}
/////////////////////////////////////////////////

if is_array(blend){
    blend_highlight = -1;
    if curve_highlight==-1 and !is_struct(curves){ //no curve highlighted, let's highlight blends!
        var n = array_length(blend),
            yt = gmax*min(1,n/4);
    draw_set_halign(fa_left);
    for(var i=0;i<n;i+=1){
        var bl = blend[i],
            yy = yt- choice(((i mod 4)*50),(i mod 8)*25,n>4), 
            y1 = remap_value(yy,gmin,gmax,gb,gt),
            y2 = remap_value(yy-50,gmin,gmax,gb,gt),
            
            bleft = bl.left,
            bright = bl.right,
            bcleft = bl.cleft,
            bcright = bl.cright,
            left = remap_value(bleft,0,100,gl,gr),
            right = remap_value(bright,0,100,gl,gr),
            cleft = remap_value(bcleft,0,100,gl,gr),
            cright = remap_value(bcright,0,100,gl,gr);
        
            if mouse_in_region(left-grab_range,y1,right+grab_range,y2) or blend_dragging==i{
                blend_highlight = i;
                if blend_param_drag==""{
                    blend_param_highlight = "";
                    if mouse_in_region(max(cleft+grab_range,cright-grab_range),y1,min(cright+grab_range,right),y2){
                        blend_param_highlight = "cright";
                    }
                    if mouse_in_region(right,y1,right+grab_range,y2){
                        blend_param_highlight = "right";
                    }
                    if mouse_in_region(left-grab_range,y1,min(cleft,left+grab_range),y2){
                        blend_param_highlight = "left";
                    }
                    if mouse_in_region(max(left,cleft-grab_range),y1,cleft+grab_range,y2){
                        blend_param_highlight = "cleft";
                    }
                    if mouse_check_button_pressed(mb_left) and blend_param_highlight!=""{
                        blend_dragging = i;
                        blend_param_drag = blend_param_highlight;
                        blend_drag_x = remap_value(variable_struct_get(bl,blend_param_drag),0,100,gl,gr)-mouse_x;
                    }
                }else{
                    if mouse_check_button(mb_left){
                    var px = variable_struct_get(bl,blend_param_drag),
                        nx = remap_value(mouse_x+blend_drag_x,gl,gr,0,100),
                        cl=0,cr=100;
                    switch(blend_param_drag){
                        case "left": cr = bright; break;
                        case "right": cl = bleft; break;
                        case "cleft": cl = bleft; cr = bright; break;
                        case "cright": cl = bleft; cr = bright; break;
                    }
                    nx = max(cl,min(cr,nx));
                    variable_struct_set(bl,blend_param_drag,nx);
                    
                    if blend_param_drag=="left"{
                        bcleft = max(nx,min(bright,bcleft + nx-px));
                       variable_struct_set(bl,"cleft",bcleft);
                       variable_struct_set(bl,"cright",max(bcleft,bcright)); 
                    }
                    if blend_param_drag=="right"{
                        bcright = min(nx,max(bleft,bcright + nx-px));
                       variable_struct_set(bl,"cright",bright);
                       variable_struct_set(bl,"cleft",min(bcleft,bcright)); 
                    }
                    }else{blend_param_drag=""; blend_dragging=-1;}
                }
                break;
            }
      }
    }
}

}
firstframe = false;

event_inherited();

gl=l+100;
gt=t+36+36;
gr=r-24;
gb=b-112;


/* */
/*  */
