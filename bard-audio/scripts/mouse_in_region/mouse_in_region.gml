/// @description mouse_in_region(x1,y1,x2,y2)
/// @param x1
/// @param y1
/// @param x2
/// @param y2
function mouse_in_region(argument0, argument1, argument2, argument3) {

	var x1=min(argument0,argument2),y1=min(argument1,argument3),
	    x2=max(argument0,argument2),y2=max(argument1,argument3);
	return PointInBox(mouse_x,mouse_y,x1,y1,x2,y2);



}
