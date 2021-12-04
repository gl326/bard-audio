if !setup{ //get offset from children to me
    setup = true;
    event_user(0);
    
    w=r-l; h=b-t;
    xBut = newHighlightable(objaeButton,r-100,t,r,t+24);
    xBut.name="X"; xBut.script=aeClosePanel; xBut.args[0]=id;
    ds_list_add(children,xBut);
    
    for(var i=0;i<ds_list_size(children);i+=1){
        var c = ds_list_find_value(children,i);
        ds_list_add(child_points,point(c.l-l,c.t-t));
    }
}

