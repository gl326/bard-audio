//an audio parameter is basically a number value associated with a string name
//container attributes can be 'hooked' to them such that updating a parameter also changes hooked sounds

function class_audio_parameter(_name="",_default=0) constructor{
	name = _name;
	default_value = _default;
	val = default_value;
	
	hooks = new class_map();
	
	ds_map_add(global.audio_params,name,self); //track me!
	
	ELEPHANT_SCHEMA
    {
        ELEPHANT_VERBOSE_EXCLUDE : [
			"val",
        ],
    }
	
	ELEPHANT_POST_READ_METHOD
    {
		val = default_value;
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
	
	//hook editing functions - slow, should only happen in the audio editor.
	static container_variable_hook = function(_container,_container_var){
		return hook_find_variable(container_hook(_container),_container_var);
	}
	
	static container_hook = function(_container){
		return hooks.Get(_container.name);
	}
	
	static container_hook_copy = function(_containerFrom,_containerTo){
		hook_delete_container(_containerTo.name);
		if hooks.Exists(_containerFrom){
			return hooks.Add(_containerTo.name,ElephantDuplicate(container_hook(_containerFrom)));
		}else{
			return false;	
		}
	}
	
	static hook_add = function(_container,_container_var){
		var _container_name = _container.name;
		if array_find_index(_container.parameters,name)==-1{
			array_push(_container.parameters,name);	
		}
		
		if !hooks.Exists(_container_name){
			hooks.Add(_container_name,[]);
		}
		var //attrs = container_hook(_container),
			hook = container_variable_hook(_container,_container_var);

		if is_undefined(hook){
			hook = new class_audio_hook(_container_var);
			array_push(container_hook(_container),hook);
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
		var attrs = container_hook(_container_name),
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
	
	static hook_delete_container = function(_container){
		if hooks.Exists(_container){
			hooks.Delete(_container);
		}
	}
		
	static hook_delete = function(_container,_container_var){
		hook_delete_variable(_container.name,_container_var);
		if !array_length(container_hook(_container)){
			hook_delete_container(_container.name);	
		}
	}
}

function class_audio_hook(_variableName) constructor{
	variable = _variableName;
	curve = new class_audio_hook_curve();
	
	static eval = function(state){
		return curve.eval(state);	
	}
}

function class_audio_hook_curve() constructor{
	points = [
		new class_audio_hook_curve_point(0,0),
		new class_audio_hook_curve_point(100,100)
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