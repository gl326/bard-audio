// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function class_audio_bus(_name="",_gain=0,_parent=undefined) constructor{
	name = _name;
	default_gain = _gain;
	gain = _gain;
	parent = _parent;
	calc = 0;
	
	editor_expand = false;
	
	children = [];
	
	//a gamemaker audio bus struct which we keep up-to-date with our own volume
	struct = undefined;
	//a personal emitter that my sounds go to by default (only created on demand when a sound requests it)
	default_emitter = -1;
	
	effects = [];
	parameters = [];
	parent_connect();
	
	ELEPHANT_SCHEMA
    {
        ELEPHANT_VERBOSE_EXCLUDE : [
			"editor_expand",
			"gain",
			"calc",
			"struct",
			"default_emitter",
			"parameters",
			"parameters_setup"
        ],
    }
	
	ELEPHANT_POST_READ_METHOD
    {
		gain = default_gain;
		track();
    }
    
	static track = function(){
		ds_map_add(global.audio_busses,name,self); //track me!

		//our corresponding gamemaker bus for setting volume
		struct = audio_bus_create();
		volume_update();
		
		return self;
	}
	
	static inherit_from = function(_bus_name){
		parent_disconnect();
		
		if is_struct(bus_getdata(_bus_name)){
			parent = _bus_name;
			parent_connect();
		}else{
			parent = undefined;	
		}
		
		return self;
	}
	
	static get_emitter = function(){
		if default_emitter==-1{
			//a non-3D emitter which belongs to our bus (for applying audio effects, etc.)
			default_emitter = audio_emitter_Create();
			audio_emitter_bus(default_emitter,struct);
			audio_emitter_gain(default_emitter,1);
			//audio_emitter_falloff(default_emitter,99999,1,1);
		}
		return default_emitter;
	}
	
	static volume_update = function(){
			//set the associated game maker bus volume
			struct.gain = calc+1;
			
			//the new bus system updates audio for everyone, so we don't need to track this part anymore
			/*
			i = 0;
			repeat(array_length(global.audio_players)){
				global.audio_players[i].bus_updated(name);
				i ++;
			}	
			*/
	}
	
	static parent_connect = function(){
		//find my mommy and make sure we good
		if parent!=undefined{
			var parent_data = bus_getdata(parent);
			if array_find_index(parent_data.children,self)==-1{
				array_push(parent_data.children,self);	
			}
		}		
	}
	
	static recalculate = function(_calc = 0, calced=[]){
		array_push(calced,name);
	    //if ds_exists(map,ds_type_map){
	    var ncalc = ((_calc+1)
	            *((gain/100)+1)
	            )-1;	
		var i;
		
		if ncalc!=calc{
			calc = ncalc;
			
			volume_update();
		}
        
			i = 0;
	        repeat(array_length(children)){
	            var newbus = children[i];
	            if array_find_index(calced,newbus)=-1{
	                bus_getdata(newbus).recalculate(calc,calced);
					i ++;
	            }else{
	                array_delete(children,i,1); //something weird happened. 
	            }
	        } 
			
	}
	
	static copy_from_bus = function(bus_name){
		var copy_data = global.audio_busses[?bus_name];
		if is_struct(copy_data){
			default_gain = copy_data.default_gain;
			gain = copy_data.default_gain;
		}
	}
	
	static default_effects = function(){
		var _i = 0;
		repeat(array_length(effects)){
			if effects[_i].default_on{
				set_effect_class(effects[_i]);	
			}
			_i++;	
		}
	}
	
	static find_effect = function(_name){
		var _i = 0;
		repeat(array_length(effects)){
			if effects[_i].name==name{
				return effects[_i];
			}
			_i ++;
		}
		
		return undefined;
	}
	
	//enable or disable a named child effect
	static set_effect = function(name,enabled,recursive){
		var _i = 0, _found = false;;
		repeat(array_length(effects)){
			if effects[_i].name==name{
				set_effect_class(effects[_i],enabled,recursive);
				_found = true;
			}
			_i ++;
		}
		
		if !_found{
			show_debug_message("AUDIO WARNING! Couldn't find effect with name ("+name+") on bus "+self.name);
		}
	}
	
	//enable or disable an effect class. this should only happen if the class is one i'm tracking in my personal list of effects
	static set_effect_class = function(effect,enabled=true,recursive=true){
		effect.update(); //make sure the effect's state matches up with parameter states
		if set_audio_effect(effect.effect,enabled,recursive){ //if the effect was successfully applied
			//watch or unwatch parameters
			if enabled{
				array_append_array(effect.parameters,parameters);
			}else{
				var _i=0;	
				repeat(array_length(effect.parameters)){
					var _ind = array_find_index(parameters,effect.parameters[_i]);
					if _ind>-1{
						array_delete(parameters,_ind,1);	
					}
					_i ++;	
				}
			}
			
			update_effect_watching();
		}
	}
	
	//an audio parameter updated!
	static param_update = function(param){
		if array_find_index(parameters,param)!=-1{
			//and i'm watching for it! time to update!
			var _i = 0, _found = false;;
			repeat(array_length(effects)){
				effects[_i].param_update(param);
				_i ++;
			}
		}
	}
	
	//assign an actual GM effect to my actual GM bus
	static GM_EFFECT_LIMIT = 8;
	static set_audio_effect = function(_effect,enabled=true,recursive=true){
		var _return  = true;
		if enabled{
			var _i = 0;
			repeat(GM_EFFECT_LIMIT){
				if is_undefined(struct.effects[_i]){
					struct.effects[_i] = _effect;
					break;
				}
				_i ++;
			}
			if _i>=GM_EFFECT_LIMIT{
				show_debug_message("AUDIO WARNING! New effect couldn't be applied because the bus has too many effects already. Try disabling or clearing effects.");	
				_return = false;
			}	
		}else{
			_return = false;
			var _i = 0;
			repeat(GM_EFFECT_LIMIT){
				if !is_undefined(struct.effects[_i]){
					if struct.effects[_i] == _effect{
						struct.effects[_i] = undefined;
						_return = true;
					}
				}
				_i ++;
			}	
		}
		
		if recursive{
			var _i = 0;
			repeat(array_length(children)){
				bus_getdata(children[_i]).set_audio_effect(_effect,enabled,true);
				_i ++;	
			}
		}
		
		return _return;
	}
	
	static has_effect = function(_name){
		var _eff = find_effect(_name);
		if is_undefined(_eff){
			return false;	
		}else{
			return has_effect_class(_eff);	
		}
	}
	
	static has_effect_class = function(_effect){
		return has_audio_effect(_effect.effect);
	}
	
	//any audio effect
	static has_audio_effect = function(_effect){
		var _i = 0;
			repeat(GM_EFFECT_LIMIT){
				if !is_undefined(struct.effects[_i]){
					if struct.effects[_i] == _effect{
						return true;
					}
				}
				_i ++;
			}
		return false;
	}
	
	static clear_effects = function(_recursive){
		var _i = 0;
		repeat(GM_EFFECT_LIMIT){
			struct.effects[_i] = undefined;
			_i ++;
		}
		
		parameters = [];
				
		if _recursive{
			var _i = 0;
			repeat(array_length(children)){
				bus_clear_effects(children[_i],true);
				_i ++;	
			}
		}	
	}
	
	static update_effect_watching = function(){
		var _ind = array_find_index(global.audio_bus_param_watchers,self);
		if array_length(parameters){
			if _ind==-1{
				array_push(global.audio_bus_param_watchers,self);	
			}
		}else{
			while(_ind!=-1){
				array_delete(global.audio_bus_param_watchers,_ind,1);
				_ind = array_find_index(global.audio_bus_param_watchers,self);	
			}
		}
	}
	
		
	static parent_disconnect = function(){
		//find my mommy and make sure we NOT good
		if parent!=undefined{
				var _parent = bus_getdata(parent);
			if !is_undefined(_parent){
				var _ind = array_find_index(_parent.children,name);
				if _ind!=-1{
					array_delete(_parent.children,_ind,1);	
				}
			}
		}		
	}
	
	static destroy = function(){
		if default_emitter!=-1{
			audio_emitter_free(default_emitter);
			default_emitter = -1;
		}
		ds_map_delete(global.audio_busses, name); //stop tracking
		
		//parent also should stop tracking me
		parent_disconnect();
		
		//my children are abandoned! they're their own masters now!
		for(var _i=0;_i<array_length(children);_i++){
			bus_getdata(children[_i]).parent = undefined;	
		}
		
		//if they ever add this...
		//audio_bus_destroy(struct);
	}
}