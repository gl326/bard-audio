/// @description container_play_position_screen(container,x,y)
/// @param container
/// @param x = 0 is screen left edge, 1 is screen right edge
/// @param y = 0 is screen top edge, 1 is screen bottom edge
function container_play_position_screen(container,_x,_y) {
	var spos = container_screen_position_to_listener(_x,_y);
	var obj = instance_create_depth(spos.x,spos.y,0,objLocationsound);
	obj.container = container;
	obj.z = spos.z;
	with(obj){event_user(0);}
	return obj;//.soundobj;
}

function container_set_position_screen(_container,_x,_y){
	with(objLocationsound){
		if container==_container{
			var spos = container_screen_position_to_listener(_x,_y);
			x = spos.x;
			y = spos.y;
			z = spos.z;
			return true;	
		}
	}
	
	return false;
}

function container_screen_position_to_listener(_x,_y){
	var _xx = global.listener_x + lengthdir_x(global.listener_distance,clamp(135 - (_x*90),0,180)),
		_yy = global.listener_y + lengthdir_y(global.listener_distance,clamp(45 - (_y*90),-90,90));
	return {x: _xx, y: _yy, z: global.listener_z + global.listener_distance};
}