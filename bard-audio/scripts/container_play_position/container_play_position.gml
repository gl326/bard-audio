/// @description container_play_position(container,x,y)
/// @param container
/// @param x
/// @param y
function container_play_position(container,_x,_y,_z=0) {
	var obj = location_sound_create(_x,_y,_z);
	obj.container = container;

	with(obj){event_user(0);}
	return obj;//.soundobj;
}

function location_sound_create(_x, _y, _z = 0){
	var _obj, _exists = false;
	while(!ds_queue_empty(global.location_sounds_pool)){
		_obj = ds_queue_dequeue(global.location_sounds_pool);	
		instance_activate_object(_obj);
		_exists = instance_exists(_obj);
		
		if _exists{
			break;
		}
	}
	
	if !_exists{
		_obj = instance_create_depth(_x,_y,_z,objLocationsound);
	}else{
		_obj.x = _x;
		_obj.y = _y;
	}
	_obj.z = _z;	
	_obj.played = false;
	return _obj;
}

function location_sound_destroy(_obj){
	ds_queue_enqueue(global.location_sounds_pool,_obj);
	instance_deactivate_object(_obj);
}