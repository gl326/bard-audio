/// @description newStackedHighlightable(obj, column, opt dir, opt header)
/// @param obj
/// @param  column
/// @param  opt dir
/// @param  opt header
function newStackedHighlightable() {

	var obj = argument[0],
	    col = argument[1],
	    dir = -1,
	    head = "",
	    yoff = 0;
	if argument_count>2{dir = argument[2];}
	if argument_count>3{
	    head = argument[3];
	    yoff = 24;
	    }
	column[col] += (button_h+button_g+yoff);
	var yy;
	if dir==-1{
	    yy = room_height - column[col];
	}else{
	    yy = (button_g*3)+(button_h*3) + column[col]-button_h-yoff;
	}

	var obj = newHighlightable(obj,xpos[0,col],yy+yoff,xpos[1,col],yy+button_h+yoff);
	if head!=""{
	    ds_list_add(headers,map_Create("text",head,"x",xpos[0,col],"y",yy+yoff-24,"obj",obj));
	}
	return obj;


}
