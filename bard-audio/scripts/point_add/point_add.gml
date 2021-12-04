/// @description point_add(point, x, y)
/// @param point
/// @param  x
/// @param  y
function point_add(argument0, argument1, argument2) {
	var p = argument0;
	ds_grid_add(p,0,0,argument1);
	ds_grid_add(p,1,0,argument2);
	return p;



}
