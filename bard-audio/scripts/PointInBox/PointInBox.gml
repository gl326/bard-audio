/// @description PointInBox(px, py, x1, y1, x2, y2)
/// @param px
/// @param  py
/// @param  x1
/// @param  y1
/// @param  x2
/// @param  y2
function PointInBox(argument0, argument1, argument2, argument3, argument4, argument5) {
	var px = argument0, py = argument1, x1 = argument2, y1 = argument3, x2 = argument4, y2 = argument5;

	return !(px>x2 or px<x1 or py<y1 or py>y2);
	//if px>=x1 and px<=x2 and py>=y1 and py<=y2{return true;}
	//return false;



}
