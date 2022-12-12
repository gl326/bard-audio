if !setup{
	xf = newHighlightable(objTextfield,l+text_w,b-24-8,lerp(l,r,1/2)-8,b-8);
	xf.param = "x"; xf.draggable=true;

	yf = newHighlightable(objTextfield,lerp(l,r,1/2)+text_w,b-24-8,r-8,b-8);
	yf.param = "y"; yf.draggable=true;

	//pf = newHighlightable(objTextfield,lerp(l,r,2/3)+text_w,b-24-8,r-8,b-8);
	//pf.param = "p"; pf.draggable=true;

	list_Add(children,xf,yf);//,pf);

	if is_struct(curves){
		//...?
	}

}

event_inherited();

