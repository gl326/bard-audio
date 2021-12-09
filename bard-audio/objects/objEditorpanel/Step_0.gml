if am_highlighted(){
 depth = minHighlightableDepth()-1;
 /////////////dragging//////////
 if (mouse_check_button(mb_left) and mouse_in_region(l,t,r,t+24)) or (tbar_grab_x!=-1 or tbar_grab_y!=-1){
    if tbar_grab_x==-1 or tbar_grab_y==-1{
        tbar_grab_x = l-mouse_x; tbar_grab_y=t-mouse_y;
    }else{
        if !mouse_check_button(mb_left){tbar_grab_x=-1; tbar_grab_y=-1;}
        else{
        l = max(-(w/2),min(room_width-(w/2),mouse_x+tbar_grab_x)); t=max(0,min(room_height-24,mouse_y+tbar_grab_y));
        r = l+w; b = t+h;
        for(var i=0;i<ds_list_size(children);i+=1){
        var c = ds_list_find_value(children,i);
        var p = ds_list_find_value(child_points,i);
            var cw=c.r-c.l,ch=c.b-c.t;
            c.l = l+point_x(p);
            c.t = t+point_y(p);
            c.r = c.l+cw; c.b=c.t+ch;
        }
        }
    }
 }else{tbar_grab_x=-1; tbar_grab_y=-1;}
}else{
    for(var i=0;i<ds_list_size(children);i+=1){
        var c = ds_list_find_value(children,i);
        if global.highlighted==c{
            depth = minHighlightableDepth()-1;
            break;
        }   
        }
    tbar_grab_x=-1; tbar_grab_y=-1;
}

    for(var i=0;i<ds_list_size(children);i+=1){
        var c = ds_list_find_value(children,i);
        c.depth = depth-1;
        }

