/// @description container_play_spot_amb(container,x,y)
/// @param container
/// @param x
/// @param y
function container_play_spot_amb(argument0, argument1, argument2) {
	var obj = instance_create_depth(argument1,argument2,0,objSpotsound);
	obj.sound = argument0;
	with(obj){event_user(1);}
	return obj;//.soundobj;



}
