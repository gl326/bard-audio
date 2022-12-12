// an editor-friendly representation of gamemaker audio effects
bard_audio_effects_setup();
function bard_audio_effects_setup(){ //get all the intenral effects and identify their parameters and ranges for visual editing
	var array_setup = function(){
		var _arr = [];
		for(var _i=0;_i<argument_count;_i+=2){
			_arr[argument[_i]] = argument[_i+1];	
		}
		return _arr;
	}
	global.bard_audio_effect_names = array_setup(
				AudioEffectType.Reverb1,"reverb",
				AudioEffectType.Delay,"delay",
				AudioEffectType.Bitcrusher,"bitcrusher",
				AudioEffectType.LPF2,"lpf",
				AudioEffectType.HPF2,"hpf",
				AudioEffectType.Gain,"gain",
			);
	global.bard_audio_effect_parameters = array_setup(
				AudioEffectType.Reverb1,
				{
					size: bard_effect_param(.5, [0,1], "Larger sizes mean more reflections and a longer reverberation."),
					damp: bard_effect_param(.5, [0,1], "The amount that higher frequencies should be attenuated"),
					mix: bard_effect_param(1),
					bypass: bard_effect_param(0),
				},
				AudioEffectType.Delay,
				{
					time: bard_effect_param(.1, [0,infinity], "The length of the delay (in seconds)."),
					feedback: bard_effect_param(.5, [0,1], "The proportion of the delayed signal which is fed back into the delay line."),
					mix: bard_effect_param(1),
					bypass: bard_effect_param(0),
				},
				AudioEffectType.Bitcrusher,
				{
					drive: bard_effect_param(1, [0,1], "The input gain going into the effect."),
					feedback: bard_effect_param(50,[0,100],"The factor by which the original signal is downsampled. This is rounded down to an integer."),
					resolution: bard_effect_param(4,[1,16],"The bit depth at which the signal is resampled. This is rounded down to an integer."),
					mix: bard_effect_param(1),
					bypass: bard_effect_param(0),
				},
				AudioEffectType.LPF2,
				{
					cutoff: bard_effect_param(1000, [0,16000], "The cutoff frequency of the filter. Frequencies higher than the cutoff will be attenuated."),
					q: bard_effect_param(50,[1,100],"The quality factor of the filter. A dimensionless parameter which indicates how peaked (in gain) the frequency is around the cutoff. The greater the value, the greater the peak."),
					bypass: bard_effect_param(0),
				},
				AudioEffectType.HPF2,
				{
					cutoff: bard_effect_param(1000, [0,16000], "The cutoff frequency of the filter. Frequencies lower than the cutoff will be attenuated."),
					q: bard_effect_param(50,[1,100],"The quality factor of the filter. A dimensionless parameter which indicates how peaked (in gain) the frequency is around the cutoff. The greater the value, the greater the peak."),
					bypass: bard_effect_param(0),
				},
				AudioEffectType.Gain,
				{
					gain: bard_effect_param(1, [0,2], "The gain value applied to the input signal.", true),
					bypass: bard_effect_param(0),
				},
			);
}
		
//our representation of a gamemaker effect
function class_audio_effect() constructor{
	type_id = -1;
	type = "";
	name = "";
	settings = {};
	default_on = true;
	effect = undefined;
	uid = ""; //unique id - used internally for hookups to parameters
	
	//parameters that we're watching
	parameters = [];
	
	static type_names = global.bard_audio_effect_names;
	static type_parameters = global.bard_audio_effect_parameters;
	
	ELEPHANT_SCHEMA{
		ELEPHANT_VERBOSE_EXCLUDE:[
			"type_parameters",
			"type_names",
			"type_id",
			"effect",
		],
	}
	
	ELEPHANT_POST_READ_METHOD{
		set_type(array_find_index(type_names,type));	
	}
	
	static set_type = function(_id,_parent=undefined){
		if type_id!=-1{
			//type is changing from a different one, so clear old settings
			//this should actually never happen but...
			delete settings;
			settings = {};	
		}
		
		//set type index
		type_id = _id;
		type = type_names[type_id];
		
		assign_uid(_parent);
		
		//get settings defaults for anything not initialized
		var _params = get_template(),
			_names = parameter_names();
		var _i = 0;
		repeat(array_length(_names)){
			if !variable_struct_exists(settings,_names[_i]){
				settings[$ _names[_i]] = _params[$ _names[_i]].def;
			}
			_i ++;
		}
				
		//create a corresponding audio effect
		if !is_undefined(effect){
			effect_destroy();	
		}
		effect = audio_effect_create(type_id);
		
		//match it up with what our settings are set to
		settings_update();
		return self;
	}
	
	static assign_uid = function(_parent){
		if uid==""{
			if !is_undefined(_parent){
				uid += _parent.name+":";	
			}
			uid += type+":";
			uid += md5_string_unicode(string(get_timer())+string(date_current_datetime())+string(random(1000000)));
		}
	}
	
	static get_template = function(){
		if type_id<0{
			return undefined;	
		}
		return type_parameters[type_id];	
	}
	static parameter_names = function(){
		return variable_struct_get_names(get_template());	
	}
	
	static name_updated = function(){
		//...
	}
	
	static set_value = function(_name,_value){
		settings[$ _name] = _value;
		value_updated(_name);
	}
	
	static value_updated = function(_name){
		//editing directly like this doesn't work. 
		//effect[$ _name] = settings[$ _name];	
		
		//sooo janky, but... guess we're doin it by hand here
		var _set = settings[$ _name];
		switch(_name){
			case "mix":			effect.mix			= _set; break;	
			case "time":		effect.time			= _set; break;	
			case "damp":		effect.damp			= _set; break;	
			case "size":		effect.size			= _set; break;	
			case "feedback":	effect.feedback		= _set; break;	
			case "drive":		effect.drive		= _set; break;	
			case "resolution":	effect.resolution	= _set; break;	
			case "cutoff":		effect.cutoff		= _set; break;	
			case "q":			effect.q			= _set; break;	
			case "gain":		effect.gain			= _set; break;	
			case "bypass":		effect.bypass		= _set; break;	
			default: 
				show_message("Attempting to set undefined value "+_name+" for audio effect "+type+" ("+name+") (need to edit class_audio_effect to accomodate the new parameter)"); 
			break;
		}
	}
	
	//update all settings
	static settings_update = function(){
		var _names = parameter_names();
		var _i = 0;
		repeat(array_length(_names)){
			value_updated(_names[_i]);
			_i ++;	
		}
	}
	
	static hook_add = function(param){
		array_push(parameters,param);	
		
		//live update any playing busses hooked to me
		var _all_busses = ds_map_keys_to_array(global.audio_busses);
		var _i = 0;
		repeat(array_length(_all_busses)){
			var _bus = bus_getdata(_all_busses[_i]);
			if _bus.has_effect_class(self){
				array_push(_bus.parameters,param);
				_bus.update_effect_watching();
			}
			_i++;	
		}
		
		param_update(param);
	}
	
	static hook_delete = function(param){
		if(array_find_index(parameters,param)!=-1){
			array_delete(parameters,array_find_index(parameters,param),1);	
			
			//live update any playing busses hooked to me
			var _all_busses = ds_map_keys_to_array(global.audio_busses);
			var _i = 0;
			repeat(array_length(_all_busses)){
				var _bus = bus_getdata(_all_busses[_i]);
				if _bus.has_effect_class(self){
					array_delete(_bus.parameters,array_find_index(_bus.parameters,param),1);	
					_bus.update_effect_watching();
				}
				_i++;	
			}
		}
	}
	
	static param_update = function(param){
		if array_find_index(parameters,param)!=-1{
			update();	
		}
	}
	
	//look at parameters and update my values accordingly. 
	//this only needs to be done when parameters update or when i play.
	static update = function(){
		var _i = 0;
		repeat(array_length(parameters)){
			if ds_map_exists(global.audio_params,parameters[_i]){
				if global.audio_params[?parameters[_i]].set_effect_values(self){
					_i ++;
				}else{
					//show_debug_message("warning! container "+string(name)+" referenced audio parameter "+string(parameters[_i])+" but the parameter didn't have any matching hooks");
					array_delete(parameters,_i,1);	
				}
			}else{
				//show_debug_message("warning! container "+string(name)+" references nonexistent audio parameter "+string(parameters[_i]));	
				array_delete(parameters,_i,1);	
			}
		}
	}
	
	//only used in editor
	static param_eval = function(_variableName,_param){
		return param_getdata(_param).effect_variable_hook(self,_variableName).eval(audio_param_state(_param));
	}
	
	///slow - used for display purposes in editor or debug only
	static variable_has_hook = function(variable_name){
		var _i = 0;
		repeat(array_length(parameters)){
			if ds_map_exists(global.audio_params,parameters[_i]){
				var param = global.audio_params[?parameters[_i]],
					attrs = param.effect_hook(self);
				if !is_undefined(param.hook_find_variable(attrs,variable_name)){
					return param.name;	
				}
			}
			_i ++;
		}
		return "";
	}
	
	static effect_destroy = function(){
		//??? if they ever add this
		//audio_effect_destroy(effect);	
	}
	static destroy = function(){
		//disconnect me from all busses
		var _all_busses = ds_map_keys_to_array(global.audio_busses);
		var _i = 0;
		repeat(array_length(_all_busses)){
			bus_getdata(_all_busses[_i]).set_effect_class(self,false,false);
			_i++;	
		}
		
		effect_destroy();
	}
}

function bard_effect_param(_default=0.5, _range=[0,1], _desc="", _isdb=false){
		return {
			def: _default,
			range: _range,
			desc: _desc,
			isDb: _isdb
		}
	}