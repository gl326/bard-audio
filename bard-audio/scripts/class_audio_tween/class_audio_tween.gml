// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.audio_tweens = [];

function class_audio_tween(_variable_string_name, _dest=1, _length=1, _curve=1,_isColor=false) constructor{
	start_time = current_time;
	dest = _dest;
	length = _length;
	curve = _curve;
	owner = other;
	owner_struct = is_struct(owner);
	if owner_struct{
		owner = weak_ref_create(owner);	
	}
	array = -1;
	
	variable = _variable_string_name;
	from  = get_value();
	isColor = _isColor;
	callback_function = undefined;
	update_function = undefined;
	
	paused = false;
	paused_time = -1;
	paused_length = -1;
	deleted = false;
	
	if _length==0{
		update();	
	}
	
	static update = function(){
		if deleted{
			return false;	
		}
		
		if paused{
			if paused_length<0 or ((current_time-paused_time)<paused_length){
				return true;	
			}else{
				unpause();
			}
		}
		
		if (!owner_struct and instance_exists(owner))
		or (owner_struct and weak_ref_alive(owner)){
			if length>0{
				var anim = min(1,((current_time - start_time) / 1000)/length);
				if is_method(curve){
					anim = curve(anim)
				}else{
					if curve>10{
						anim = script_execute(curve,anim);
					}else{
						anim = power(anim,curve);
					}
				}
				if !isColor{
					set_value(lerp(from,dest,anim));
				}else{
					set_value(merge_color(from,dest,anim));
				}
				
				if is_method(update_function){
					update_function();
				}
				
				if anim<1{
					return true;
				}
			}else{
				set_value(dest);
				
				if is_method(update_function){
					update_function();
				}
			}
		}
		
		deleted = true;
		return false; //this means it's done and can stopped being tracked
	}
	
	static on_update = function(func){
		update_function =  method(owner_struct? owner.ref:owner,func);
		if length<=0{ //skipped to end already
			update_function();	
		}
		return self;
	}
	
	static callback = function(func){
		callback_function = method(owner_struct? owner.ref:owner,func);
		return self;
	}
	
	static array_index = function(index){
		if array!=index{
			array = index;
			from = get_value();
		}
		return self;
	}
	
	static pause = function(pauseForTime=-1){
		paused_length = pauseForTime*1000;
		if !paused{
			paused_time = current_time;
			paused = true;
		}
		return self;
	}
	
	static unpause = function(){
		if paused{
			start_time = current_time - (paused_time-start_time);
			paused = false;
		}
		return self;
	}
	
	static get_value = function(){
		if !owner_struct{
					if array!=-1{
						return variable_instance_get(owner,variable)[array];
					}else{
						return variable_instance_get(owner,variable);
					}
				}else{
					if array!=-1{
						return variable_struct_get(owner.ref,variable)[array];
					}else{
						return variable_struct_get(owner.ref,variable);
					}
				}
	}
	
	static set_value = function(_to){
		if !owner_struct{
					if array!=-1{
						variable_instance_get(owner,variable)[array] = _to;
					}else{
						variable_instance_set(owner,variable,_to);
					}
				}else{
					if array!=-1{
						variable_struct_get(owner.ref,variable)[array] = _to;
					}else{
						variable_struct_set(owner.ref,variable,_to);
					}
				}
	}
	
	static destroy = function(){
		var ind = array_find_index(global.audio_tweens,self);
		if ind!=-1{
			array_delete(global.audio_tweens,ind,1);	
		}
	}
}

function tween_audio(variable_string_name,dest,timeInSeconds=1,curve=1,isColor=false){
	if is_string(variable_string_name){
		tween_audio_destroy(variable_string_name);
	}
	
	var _t = new class_audio_tween(variable_string_name,dest,timeInSeconds,curve,isColor);
	array_push(global.audio_tweens,_t);
	return _t;
}

function tween_audio_destroy(variable_string_name){
	var _old = audio_get_tween(variable_string_name);
	if !is_undefined(_old){
		_old.destroy();
		return true;
	}	
	
	return false;
}

function audio_get_tween(variable_string_name){
	var _i = 0;
	repeat(array_length(global.audio_tweens)){
		var _t = global.audio_tweens[_i];
		if (is_struct(self) and _t.owner_struct and _t.owner.ref==self)
		or (!is_struct(self) and _t.owner==self){
			if _t.variable==variable_string_name{
				return _t;	
			}
		}
		_i ++;	
	}
	return undefined;
}

function audio_is_tweening(variable_string_name){
	return !is_undefined(audio_get_tween(variable_string_name));
}

function audio_tweens_update(){
	var _t = 0;
	repeat(array_length(global.audio_tweens)){
		if global.audio_tweens[_t].update(){
			_t ++;
		}else{
			var _m = global.audio_tweens[_t].callback_function;
			if is_method(_m){
				_m();
			}
			array_delete(global.audio_tweens,_t,1);	
		}
	}	
}