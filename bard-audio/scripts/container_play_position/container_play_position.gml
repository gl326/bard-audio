/// @description container_play_position(container,x,y)
/// @param container
/// @param x
/// @param y
function container_play_position(container,_x,_y,_z=0) {
	var obj = instance_create_depth(_x,_y,_z,objLocationsound);
	obj.container = container;
	obj.z = _z;
	with(obj){event_user(0);}
	return obj;//.soundobj;



}
