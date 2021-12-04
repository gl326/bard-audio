/// @description point_set(point, x, y)
/// @param point
/// @param  x
/// @param  y
function point_set(argument0, argument1, argument2) {
	var p = argument0;
	ds_grid_set(p,0,0,argument1);
	ds_grid_set(p,1,0,argument2);
	return p;



}
