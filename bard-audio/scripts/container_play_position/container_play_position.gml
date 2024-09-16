/// @description container_play_position(container,x,y)
/// @param container
/// @param x
/// @param y
function container_play_position(container,_x,_y,_z=0,_volumeMultiply=1,_pitchMultiply=1,_effect_struct = undefined) {
	var obj = location_sound_create(_x,_y,_z);
	obj.container = container;
	obj.volumeMultiply = _volumeMultiply;
	obj.pitchMultiply = _pitchMultiply;
	
	if !is_undefined(_effect_struct){
		container_object_set_custom_effect(container, obj, _effect_struct);	
	}
	
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
	with(_obj){
		if is_struct(audio_emitter_effect_bus){
			audio_emitter_effect_bus.destroy();
			audio_emitter_effect_bus = undefined;
		}	
	}
	ds_queue_enqueue(global.location_sounds_pool,_obj);
	instance_deactivate_object(_obj);
}

function container_object_set_custom_effect(_container, _object, _effect_struct, _enabled = true){
	//object needs to be an objSpatialObject or child of it to have the audio emitter effects variables
	with(_object){
		if !is_struct(audio_emitter_effect_bus){
			audio_emitter_effect_bus = container_player(_container,true).new_effect_bus();	
		}
		
		audio_emitter_effect_bus.set_audio_effect(_effect_struct,_enabled);
		
			if audio_emitter!=-1{
				for(var i=0;i<audio_emitter_n;i+=1){
					audio_emitter_bus(audio_emitter[i], audio_emitter_effect_bus.struct);
				}
			}
		}	
}

function container_object_has_custom_effect(_object){
	with(_object){
		return is_struct(audio_emitter_effect_bus);	
	}
	
	return false;
}