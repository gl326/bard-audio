var gmax = ymax,
	gmin = ymin;
if !firstframe{
	
	if attribute=="gain"{
		dB = true;
		ymax = 25;	
	}
	
/* old curve editing
if curves!=-1 and blend_param_drag==""{
if grabbed!=-1{ //dragging a point
    editing_point = grabbed;
        xf.editing = ds_list_find_value(points,grabbed);
        yf.editing = ds_list_find_value(points,grabbed);
        //pf.editing = grabbed;
    global.highlighted = -1; //NOT noone
    if !mouse_check_button(mb_left){
        grabbed = -1; global.highlighted=noone;
        }
    else{
        var p = ds_list_find_value(points,grabbed),
            xx = remap_value(mouse_x+grab_x,gl,gr,0,100),
            yy = remap_value(mouse_y+grab_y,gt,gb,gmax,gmin);
        ds_map_Replace(p,"x",xx);
        ds_map_Replace(p,"y",yy);
        xf.text = string(xx);
		yf.dB = dB;
		if dB{
			yf.text = string(20*log10((yy/100)+1));
		}else{
			yf.text = string(yy);
		}
        var n = ds_list_size(points);
        for(var i=0;i<n;i+=1){
            var pp = ds_list_find_value(points,i);
            if i<grabbed{
                if ds_map_find_value(pp,"x")>xx{
                    ds_list_delete(points,grabbed);
                    ds_list_insert_map(points,i,p);
                    grabbed = i;
                    break;
                }
            }
            if i>grabbed{
                if ds_map_find_value(pp,"x")<xx{
                    ds_list_delete(points,grabbed);
                    ds_list_insert_map(points,i,p);
                    grabbed = i;
                    break;
                }
            }
        }
        
    }
}else{
    if mouse_in_region(gl-grab_range,gt-grab_range,gr+grab_range,gb+grab_range) and grabbed == -1{ //highlighting and click curves
    var stopdel = false;
     ///////set editing curve//////////
    //var cn = ds_list_size(curve_list);
    curve_highlight = -1;
   // for(var j=0;j<cn;j+=1){
        var k = curve_name;//ds_list_find_value(curve_list,j);
        var cur = ds_map_find_value(curves,k);
        var pts = ds_map_find_value(cur,"points"),n = ds_list_size(pts);
        var ppx="", ppy="";
        for(var i=0;i<n;i+=1){
            var pp = ds_list_find_value(pts,i);
            var px = remap_value(ds_map_find_value(pp,"x"),0,100,gl,gr),
                py = remap_value(ds_map_find_value(pp,"y"),gmin,gmax,gb,gt);
            if !is_string(ppx){
                var dir = point_direction(ppx,ppy,px,py),
                    dis = 4,
                    lx = lengthdir_x(dis,dir+90),
                    ly = lengthdir_y(dis,dir+90);
                if point_in_triangle(mouse_x,mouse_y,ppx+lx,ppy+ly,ppx-lx,ppy-ly,px+lx,py+ly)
                or point_in_triangle(mouse_x,mouse_y,px+lx,py+ly,px-lx,py-ly,ppx-lx,ppy-ly)
                or point_distance(mouse_x,mouse_y,px,py)<=grab_range{
                    curve_highlight = cur;
                    attribute = k;
                    if mouse_check_button_pressed(mb_left){
                        curve = cur; points = pts;
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
    var n = ds_list_size(points),doit=true,pts=points;
    var pp =-1,ins = -1;
    var xx = remap_value(mouse_x,gl,gr,0,100),
        yy = remap_value(mouse_y,gt,gb,gmax,gmin);
        for(var i=0;i<n;i+=1){
            pp = ds_list_find_value(pts,i);
            var px = ds_map_find_value(pp,"x");
            //show_message(string(pp)+": "+string(px));
            var pxx = remap_value(px,0,100,gl,gr),
                pyy = remap_value(ds_map_find_value(pp,"y"),gmin,gmax,gb,gt);
            if point_distance(mouse_x,mouse_y,pxx,pyy)<=grab_range{
                doit = false;
                if mouse_check_button_pressed(mb_left){
                    grabbed = i;
                    editing_point = i;
                    grab_x = pxx-mouse_x;
                    grab_y = pyy-mouse_y;
                    xf.editing = pp;
                    yf.editing = pp;
                    pf.editing = pp;
                }else{
                if mouse_check_button_pressed(mb_right) and ds_list_size(pts)>1 and !stopdel{
                    doit = false;
                    ds_map_destroy(pp);
                    ds_list_delete(pts,i);
                    stopdel = true;
                    if editing_point==i{
                        editing_point = -1;
                        xf.editing = -1;
                        yf.editing = -1;
                        pf.editing = -1;
                    }
                }}
            break;
            }
            if px<xx{ins = i+1;}else{break;}
        }
        
        //////add new point/////////
        if doit and mouse_check_button_pressed(mb_left) and grabbed ==-1{
        var np =map_Create("x",xx,"y",yy,"p",0);
        if ins<ds_list_size(points){ds_list_insert_map(points,ins,np);}
        else{ds_list_add_map(points,np); ins = ds_list_size(points)-1;}
        grabbed = ins;
        }
    }
}   
}
*/

if blend!=-1{
    blend_highlight = -1;
    if curve_highlight==-1 and curves==-1{ //no curve highlighted, let's highlight blends!
        var n = ds_list_size(blend),
            yt = gmax*min(1,n/4);
    draw_set_halign(fa_left);
    for(var i=0;i<n;i+=1){
        var bl = ds_list_find_value(blend,i),
            yy = yt- choice(((i mod 4)*50),(i mod 8)*25,n>4), 
            y1 = remap_value(yy,gmin,gmax,gb,gt),
            y2 = remap_value(yy-50,gmin,gmax,gb,gt),
            
            bleft = ds_map_find_value(bl,"left"),
            bright = ds_map_find_value(bl,"right"),
            bcleft = ds_map_find_value(bl,"cleft"),
            bcright = ds_map_find_value(bl,"cright"),
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
                        blend_drag_x = remap_value(ds_map_find_value(bl,blend_param_drag),0,100,gl,gr)-mouse_x;
                    }
                }else{
                    if mouse_check_button(mb_left){
                    var px = ds_map_find_value(bl,blend_param_drag),
                        nx = remap_value(mouse_x+blend_drag_x,gl,gr,0,100),
                        cl=0,cr=100;
                    switch(blend_param_drag){
                        case "left": cr = bright; break;
                        case "right": cl = bleft; break;
                        case "cleft": cl = bleft; cr = bright; break;
                        case "cright": cl = bleft; cr = bright; break;
                    }
                    nx = max(cl,min(cr,nx));
                    ds_map_replace(bl,blend_param_drag,nx);
                    
                    if blend_param_drag=="left"{
                        bcleft = max(nx,min(bright,bcleft + nx-px));
                       ds_map_replace(bl,"cleft",bcleft);
                       ds_map_replace(bl,"cright",max(bcleft,bcright)); 
                    }
                    if blend_param_drag=="right"{
                        bcright = min(nx,max(bleft,bcright + nx-px));
                       ds_map_replace(bl,"cright",bright);
                       ds_map_replace(bl,"cleft",min(bcleft,bcright)); 
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
