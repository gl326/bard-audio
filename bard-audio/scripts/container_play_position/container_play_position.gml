/// @description container_play_position(container,x,y)
/// @param container
/// @param x
/// @param y
function container_play_position(argument0, argument1, argument2) {
	var obj = instance_create_pooled(argument1,argument2,0,objLocationsound);
	obj.container = argument0;
	with(obj){event_user(0);}
	return obj;//.soundobj;



}
