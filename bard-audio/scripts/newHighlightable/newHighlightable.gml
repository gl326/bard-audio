/// @description newHighlightable(obj,x1,y1,x2,y2)
/// @param obj
/// @param x1
/// @param y1
/// @param x2
/// @param y2
function newHighlightable(argument0, argument1, argument2, argument3, argument4) {
	var obj = argument0,
	    x1 = argument1,y1=argument2,
	    x2=argument3,y2=argument4;
    
	var ins = instance_create_depth(x1,y1,0,obj);
	ins.l=x1; ins.t=y1;
	ins.r=x2; ins.b=y2;

	return ins;



}
