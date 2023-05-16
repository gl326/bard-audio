//an audio parameter is basically a number value associated with a string name
//container attributes can be 'hooked' to them such that updating a parameter also changes hooked sounds

function class_audio_parameter(_name="",_default=0) constructor{
	name = _name;
	default_value = _default;
	val = default_value;
	
	hooks = new class_map();
	
	
	ELEPHANT_SCHEMA
    {
        ELEPHANT_VERBOSE_EXCLUDE : [
			"val",
        ],
    }
	
	ELEPHANT_POST_READ_METHOD
    {
		val = default_value;
		track();
    }
	
	static track = function(){
		ds_map_add(global.audio_params,name,self); //track me!	
	}
	
	static set_container_values = function(_container){
		var attrs = container_hook(_container),
			ret = false;
		if !is_undefined(attrs){
			var _i = 0;
			repeat(array_length(attrs)){
				var hook = attrs[_i];
				variable_struct_set(_container,hook.variable,hook.eval(val));
				ret = true;
				_i++;
			}
		}
		return ret;
	}
	
	static set_effect_values = function(_effect){
		var attrs = effect_hook(_effect),
			ret = false;
		if !is_undefined(attrs){
			var _i = 0;
			repeat(array_length(attrs)){
				var hook = attrs[_i];
				_effect.set_value(hook.variable,hook.eval(val));
				ret = true;
				_i++;
			}
		}
		return ret;
	}
	
	//hook editing functions - slow, should only happen in the audio editor.
	static container_variable_hook = function(_container,_container_var){
		return hook_find_variable(container_hook(_container),_container_var);
	}
	
	static effect_variable_hook = function(_container,_container_var){
		return hook_find_variable(effect_hook(_container),_container_var);
	}
	
	static container_hook = function(_container){
		return get_hooks_for(container_getdata(_container).name);
	}
	
	static effect_hook = function(_effect){
		return get_hooks_for(_effect.uid);	
	}
	
	static get_hooks_for = function(_name){
		return hooks.Get(_name);
	}
	
	static get_hook = function(_name,_var_name){
		return hook_find_variable(get_hooks_for(_name),_var_name);
	}
	
	static container_hook_copy = function(_containerFrom,_containerTo){
		hook_delete(_containerTo.name);
		if hooks.Exists(_containerFrom){
			return hooks.Add(_containerTo.name,ElephantDuplicate(container_hook(_containerFrom)));
		}else{
			return false;	
		}
	}
	
	static hook_add_container = function(_container,_container_var){
		var _container_name = _container.name;
		if array_find_index(_container.parameters,name)==-1{
			array_push(_container.parameters,name);	
		}
		
		return hook_add(_container_name, _container_var);
	}
	
	static hook_add_effect = function(_effect,_var_name){
		if array_find_index(_effect.parameters,name)==-1{
			array_push(_effect.parameters,name);	
		}
		
		return hook_add(_effect.uid,_var_name);	
	}
	
	static hook_add = function(_name,_container_var){
		if !hooks.Exists(_name){
			hooks.Add(_name,[]);
		}
		var hook = get_hook(_name,_container_var);

		if is_undefined(hook){
			var _start = 0,
				_end = 0;
			if _container_var=="blend"{
				_end = 100;	
			}
			hook = new class_audio_hook(_container_var,_start,_end);
			array_push(get_hooks_for(_name),hook);
		}
		return hook;
	}
	
	static hook_find_variable = function(attrs,_container_var){
		var _i = 0;
		repeat(array_length(attrs)){
			var hook = attrs[_i];
			if hook.variable==_container_var{
				return hook;	
			}
			_i ++;
		}
		
		return undefined;
	}
	
	static hook_delete_variable = function(_container_name,_container_var_name){
		var attrs = get_hooks_for(_container_name),
			_i = 0;
		if !is_undefined(attrs){
			repeat(array_length(attrs)){
				var hook = attrs[_i];
				if hook.variable==_container_var_name{
					array_delete(attrs,_i,1);
					return true;
				}
				_i ++;
			}
		}
		
		return false; //failed to delete (DNE)
	}
	
	static hook_delete_container_var = function(_container,_container_var){
		var cdata = container_getdata(_container);
		hook_delete_variable(cdata.name,_container_var);
		if !array_length(container_hook(cdata)){
			hook_delete(cdata.name);	
		}
	}
	
	static hook_delete_effect_var = function(_effect,_container_var){
		hook_delete_variable(_effect.uid,_container_var);
		if !array_length(effect_hook(_effect)){
			hook_delete(_effect.uid);	
		}

	}
		
	static hook_delete = function(_name){
		if hooks.Exists(_name){
			hooks.Delete(_name);
		}
	}
	
	////////////////////
	static set = function(newv){
		if newv!=val{
		    val = newv;
			trigger_update();
		}
	}
	
	static reset = function(){
		set(default_value);	
	}
	
	//anytime my value updates, let anyone who cares know
	static trigger_update = function(){
		var _i = 0;
		repeat(array_length(global.audio_players)){
			global.audio_players[_i].param_update(name);
			_i ++;
		}	
		
		var _i = 0;
		repeat(array_length(global.audio_bus_param_watchers)){
			global.audio_bus_param_watchers[_i].param_update(name);
			_i ++;
		}	
	}
}

function class_audio_hook(_variableName,_start=0,_end=0) constructor{
	variable = _variableName;
	curve = new class_audio_hook_curve(_start,_end);
	
	static eval = function(state){
		return curve.eval(state);	
	}
}

function class_audio_hook_curve(_start=0,_end=0) constructor{
	points = [
		new class_audio_hook_curve_point(0,_start),
		new class_audio_hook_curve_point(100,_end)
	];
	sorted = true;
	
	static eval = function(x){
		sort();	
		
		var n = array_length(points);
			        switch(n){
	                    case 1: return points[0].y;
	                    case 0: return 0;
	                    default:
						var	mmin = -1,
							mmax = -1,
							p1,p2,x1=-1,x2=0;
	                        if x<=.5{
								var _i = 0;
								repeat(n){
	                                var p = points[_i];
	                                if p.x<x{
										mmin = _i; p1=p; x1=p.x;
									}else{
										if p.x==x{return p.y;}
	                                    mmax = _i; p2=p; x2=p.x;
										break;
	                                }
									_i ++;
	                            }
	                        }else{
								var _i = n-1;
	                            repeat(n){
	                                var p = points[_i];
	                                if p.x>x{
	                                    mmax = _i; p2=p; x2=p.x;
	                                }else{
										if p.x==x{return p.y;}
	                                    mmin = _i; p1=p; x1=p.x; break;
	                                }
									_i --;
	                            }
	                        }
	                        if mmax==mmin or x2==x1{
	                            return points[max(0,mmin)].y;
	                        }else{
	                            if mmax==-1{return p1.y;}
	                            if mmin==-1{return p2.y;}
	                            return lerp(
	                                p1.y,p2.y,
	                                (x-x1)/(x2-x1)
	                            );
	                        }
	                }
	}
	
	static sort = function(ignoreSorted=false){
		if ignoreSorted or !sorted{
			var prio = ds_priority_create(),_i,n = array_length(points);
			_i=0;
			repeat(n){
				ds_priority_add(prio,points[_i],points[_i].x);
				_i ++;	
			}
			_i = 0;
			repeat(n){
				points[_i] = ds_priority_delete_min(prio);
				_i ++;	
			}
			ds_priority_destroy(prio);
			sorted = true;	
		}
	}
	
	static point_add = function(_x=50,_y=50){
		sorted = false;
		var np = new class_audio_hook_curve_point(_x,_y);
		array_push(points, np);
		return np;
	}
}

function class_audio_hook_curve_point(_x=0,_y=0) constructor{
	x = _x;
	y = _y;
}