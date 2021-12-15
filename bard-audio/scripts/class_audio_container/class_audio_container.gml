//struct holding data about one audio container
//an audio container can have any number of sounds associated with it as well as other audio containers
enum CONTAINER_TYPE{
	CHOICE,
	HLT,
	MULTI
}
function class_audio_container(_name = "", fromProject = false) constructor{
	name = _name;
	contents = []; //all the audio files and sub-containers that are contained within
	contents_serialize = []; //same data as above, but made firnedly for serialize/deserialize
	
	type = CONTAINER_TYPE.CHOICE;

	bpm = 0;
	beats_per_measure = 4;
//	varybpm = false;
	beatstart = 0;
	
	loop = false;
	looptail = false;
	
	lpfade = 0;
	lpfadein = 0;
	lpdelay = 0;
	lpdelayin = 0;
	fadeout = 0;
	
	specmax = 0;
	specmin = 0;
	contin = false;
	spacerand = false;
	
	threed = false;
	threed_sound_size = 0;
	threed_sound_falloff = 0;
	threed_pan = 0;
	
	volmin = 0;
	volmax = 0;
	pitchmin = 0;
	pitchmax = 0;
	
	sync = false;
	
	gain = 0;
	pitch = 0;
	bus = "";
	
	randstart = 0;
	starttime = 0;
	
	vibration = false; //if true, this plays a second instance that vibrates a ps5 controller :o
	
	blend_on = false;
	blend_map = [];
	blend = 0;
	
	parameters = []; //array of parameter names i watch for updates
	
	chosen = -1;
	seq = false;
	
	from_project = fromProject;
	
	
	editor_expand = false;
	editor_deserialized = false;
	editor_order = 0;
	parent = "";
	
	#region Serialization
    
    ELEPHANT_SCHEMA
    {
        ELEPHANT_VERBOSE_EXCLUDE : [
            "contents",
			"editor_expand",
			"editor_deserialized",
			"editor_order",
        ],
    }
    
    ELEPHANT_POST_READ_METHOD
    {
		//deserialize_contents();
		track();
    }
    
    #endregion
	
	static track = function(){
		ds_map_add(global.audio_containers,name,self); //track me!	
	}
	
	static check_parent = function(){
		//check parent link
		if name!=ROOT_SOUND_FOLDER{ //this is the master container, so dont look at my parent
			var parent_data = ((parent=="")?undefined : container_getdata(parent));
			if is_undefined(parent_data) or array_find_index(parent_data.contents_serialize,name)==-1{
				if parent!=""{
					show_debug_message(concat("WARNING! container ",name," failed to link to its parent, ",parent,". moving to root folder"));
				}
				parent = ROOT_SOUND_FOLDER;
				parent_data = container_getdata(parent,true);
				if array_find_index(parent_data.contents_serialize,name)==-1{
					array_push(parent_data.contents_serialize,name);
				}
				if array_find_index(parent_data.contents,name)==-1{
					array_push(parent_data.contents,name);
				}
			}
		}else{
			parent = "";	
		}	
	}
	
	//turn the serialized contents into game data
	static deserialize_contents = function(){
		var n = array_length(contents_serialize);
		contents = array_create(n);
		
		var _i = 0;
		repeat(n){
			var item = contents_serialize[_i];
			if string_char_at(item,1)=="$"{ //asset
				item = asset_get_index(string_copy(item,2,string_length(item)-1));	
				if item==-1{
					//array_delete(contents_serialize,_i,1);
					show_debug_message(concat("WARNING! ",contents_serialize[_i]," was listed as an asset in ",name," but no longer exists"));
					//continue;	
				}
			}else if string_char_at(item,1)=="%"{ //external file
				item = audio_asset_index(string_copy(item,2,string_length(item)-1));	
				if item==-1{
					//array_delete(contents_serialize,_i,1);
					show_debug_message(concat("WARNING! ",contents_serialize[_i]," was listed as an external asset in ",name," but no longer exists"));
					//continue;	
				}
			}
			contents[_i] = item;
			_i++;	
		}
		
		editor_deserialized = true;
	}
	
	static copy_from_container = function(copyFrom){
		var copyData = container_getdata(copyFrom);
		struct_inherit_values(self,copyData,
			"name",
			"contents",
			"contents_serialize",
			"editor_expand",
			"editor_order",
			"parent",);
			
		//copy parameter hooks
		var entries = copyData.parameters;
		var _i = 0;
		repeat(array_length(entries)){
			global.audio_params[?entries[_i]].container_hook_copy(copyData,self);
			_i ++;	
		}
	}
	
	//look at parameters and update my values accordingly. 
	//this only needs to be done when parameters update or when i play.
	static update = function(){
		var _i = 0;
		repeat(array_length(parameters)){
			if ds_map_exists(global.audio_params,parameters[_i]){
				if global.audio_params[?parameters[_i]].set_container_values(self){
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
	
	static param_eval = function(_variableName,_param){
		return param_getdata(_param).container_variable_hook(self,_variableName).eval(audio_param_state(_param));
	}
	
	//mark that we are hooked up to this parameter, now.
	static hook_add = function(param){
		if array_find_index(parameters,param)==-1{
			array_push(parameters,param);	
		}
	}
	
	//delete a parameter connection
	static hook_delete = function(param){
		while(array_find_index(parameters,param)!=-1){
			array_delete(parameters,array_find_index(parameters,param),1);	
		}
	}
	
	///slow - used for display purposes in editor or debug only
	static variable_has_hook = function(variable_name){
		var _i = 0;
		repeat(array_length(parameters)){
			if ds_map_exists(global.audio_params,parameters[_i]){
				var param = global.audio_params[?parameters[_i]],
					attrs = param.hooks.Get(name);
				if !is_undefined(param.hook_find_variable(attrs,variable_name)){
					return param.name;	
				}
			}
			_i ++;
		}
		return "";
	}

	//using my contents, settings, and current state, populate an array with new audio sound instances which are ready to produce sound 
	static create_instances = function(option=false,list=[],inst=undefined,obj = container_player(self),_sync=false,deep=0){
	var n = array_length(contents);
	if deep<50 and n{ //if we got this deep, there was probably an infinite loop or something
	update(); //update my local variables based on parameter hooks
	
	var con = self,
		container = self;
		
	//add my parameters to the parent object's list of watches
	if !obj.firstplay{
		var _i = 0;
		repeat(array_length(parameters)){
			if array_find_index(obj.parameters,parameters[_i])==-1{
				array_push(obj.parameters,parameters[_i]);
			}
			_i ++;
		}
	}

	if is_undefined(inst){
		inst = new class_audio_instance(container);
		inst.playid = obj.playid;
		inst.instid = array_length(list)
		array_push(list,inst);
	}
    
	//sync
	if !_sync{
		_sync = !DISABLE_SYNCGROUPS and sync;
	}
	
	if sync {
	    if !DISABLE_SYNCGROUPS{
			inst.sync = true;
		}
	    obj.sync = true;
	}else{
	    obj.sync = false;
	}
  
	//gain
	//var current_vol = (ds_map_Find_value(s,"vol")+1)*(file_vol+1)*(bus_vol+1);
	if gain!=0{
	    var vol = inst.vol;
	    inst.vol = ((vol+1)*((gain/100)+1))-1;
	}
	//random gain
	var vol_min = volmin,
		vol_max = volmax;
	if vol_min!=0 or vol_max!=0{
	    var vol = inst.vol;
	    //ds_map_replace(sound,"vol",vol+(random_range(vol_min,vol_max)/100));
	    inst.vol = ((vol+1)*((random_range(vol_min,vol_max)/100)+1))-1;
	}

	var specsnd = obj.spec_snd;

	//bus id
	var bus_id = bus;
	inst.bus = bus_id;

	//pitchf
	if pitch!=0{
	    inst.pitch += (pitch/100);
	}

	//random pitch
	var pitch_min = pitchmin,
		pitch_max = pitchmax;
	if pitch_min!=0 or pitch_max!=0{
	    inst.pitch += (random_range(pitch_min,pitch_max)/100);
	}

	if threed{
	    inst.threed = true;
		inst.owner = obj.owner;
	}

	if type!=1 and specsnd==0 and loop{
	    inst.loop = true; //loop
	}
	if lpfade>0{
	    inst.fadeout = lpfade;
	}
	if randstart{
	    inst.randstart = randstart;
	}else{
		if starttime{
		    inst.starttime = starttime;
		}
	}

	if type!=1 and lpfadein>0{
	    inst.fadein = lpfadein;
	}
    
	var ret = -1;

	switch(type){
	case CONTAINER_TYPE.MULTI:
	    var newlist = [],
			i=0;
	    repeat(n){
	        var c = contents[i],
				newsound;
	        if i==0{
	            newsound = inst;
	            ret = c;
	            }
	        else{
				newsound = ElephantDuplicate(inst);
				newsound.instid = array_length(list);
	            array_push(list,newsound);
	        }
        
	        array_push(newlist,newsound);
			i ++;
	    }
    
		if blend_on{
		    i=0;
		    repeat(min(n,array_length(blend_map))){
		        var newsound = newlist[i];
		            //var nvol = ds_map_Find_value(newsound,"vol");
		            var ble = blend_map[i],
		                bl = ble.left,
		                br = ble.right,
		                bcl = ble.cleft,
		                bcr = ble.cright,
		                adj = 1;
		            if blend<bl or blend>br{
						adj = 0;
					}else{
		                if blend<bcl{if bcl>bl{adj = QuadInOut(lerp(1,0,(bcl-blend)/(bcl-bl)));}}
		                else{if blend>bcr and br>bcr{adj = QuadInOut(lerp(0,1,(br-blend)/(br-bcr)));}}
		            } 
					newsound.blend = lerp(-1,newsound.blend,adj);
	            
					i++;
			}
		}
	    
		i = 1;
	    repeat(n-1){
		    var newsound = newlist[i];
		    var c = contents[i];
		    if is_string(c){
		         container_getdata(c).create_instances(option,list,newsound,obj,sync,deep+1); //dig deeper on this one
		    }else{
		        if !is_equal(ret,c){
		           newsound.file = c; //found audio, stop
		        }
		      }
			  i ++;
	    }
	break;
	
	case CONTAINER_TYPE.HLT:
	    var cs = n;
		inst.delayout = lpdelay;
	    if !option{
	            var s1 = contents[0], 
					s2 = contents[1 mod max(1,cs)],
	            t1 = is_string(s1), 
				t2 = is_string(s2);
	        if cs>=2 and (t1!=t2 or s1!=s2) and !looptail{ //head
	            newsound = ElephantDuplicate(inst);
				newsound.instid = array_length(list);
	            array_push(list,newsound);
            
	            if t1{
	                container_getdata(s1).create_instances(option,list,newsound,obj,sync,deep+1); //dig deeper
	            }else{
	                newsound.file = s1; //found audio, stop
	            }
            
	            newsound.loop = false; //head
	        }
        
	        inst.fadein = lpfadein;
	        inst.loop = true; //loop
	        if !looptail{
				ret = s2;
			}else{
				ret = s1;
				}
	    }else{ //tail
	       if cs>=3 or looptail{
	            ret = contents[min(2,cs-1)];
	            inst.tail = 1;
	       }
	    }
	break;

	/////////////choice container//////////////////
	default:
	var ind=-1;
	if chosen>=0{
	    ind = min(floor(n*chosen/100),n-1);
	}else{
		var first = !ds_map_exists(global.audio_list_index,name);
	    if !first{
	        ind = ds_map_find_value(global.audio_list_index,name);
	        if ind>=n{ind = 0;}
	        }
	    else{ind = 0;}
	    if !seq and ind==0{
	        var lp = contents[n-1]; //last played
			array_shuffle(contents);
	        if !first and n>1 and lp==contents[0]{
	                array_delete(contents,0,1);
	                array_push(contents,lp);
	            }
	        }
    
	    if !first{ds_map_replace(global.audio_list_index,name,ind+1);}
	    else{ds_map_add(global.audio_list_index,name,ind+1);}
	}
	inst.index = ind; 
	inst.container = con;
	ret = contents[ind];
	break;
	}

	if sync and inst.loop{obj.group_loop = true;}

	if is_string(ret) or ret!=-1{
		if type==CONTAINER_TYPE.HLT{
		        inst.playstart = current_time;
		        inst.delayin = lpdelayin;
		    }
		if specsnd{
			inst.playstart = current_time;
			inst.delayin = random_range(specmin,specmax);
		}
    
		if is_string(ret){
		    container_getdata(ret).create_instances(option,list,inst,obj,sync,deep+1); //dig deeper
		}else{
		    inst.file = ret; //found audio, stop
		}
	}
	}
	
	return list;
	}
	
	//create matching blendmaps for exactly each element in our contents
	static blend_setup = function(){
		var _i = 0,
			b_n = array_length(blend_map);
		repeat(array_length(contents)){
			if _i>=b_n{
				array_push(blend_map,new class_audio_container_blendmap());	
			}
			_i ++;	
		}
		while(_i<b_n){
			array_delete(blend_map,_i,1);
			_i ++;	
		}
	}
	
	//load/unload external assets
	static load = function(){
		var _i = 0;
		repeat(array_length(contents)){
			var item = contents[_i];
			if is_string(item){
				container_getdata(item).load();	
			}else{
				audio_asset_load(item);
			}
			_i ++;
		}
	}
	
	static unload = function(){
		var _i = 0;
		repeat(array_length(contents)){
			var item = contents[_i];
			if is_string(item){
				container_getdata(item).unload();	
			}else{
				audio_asset_unload(item);
			}
			_i ++;
		}
	}
	
	static is_loaded = function(_recursive = true){
				var _i = 0;
			repeat(array_length(contents)){
				var item = contents[_i];
				if is_string(item){
					if _recursive{
						if !container_getdata(item).is_loaded(){
							return false;	
						}
					}
				}else{
					if !audio_asset_is_loaded(item){
						return false;	
					}
				}
				_i ++;
			}	
			
			return true;
	}
	
	//recursively find all parameters that might trigger updates in any child containers.
	//called with no arguments to begin a search from this container
	static get_parameters = function(array = [],map = undefined){
		var top = is_undefined(map);
		
		if top{
			map = ds_map_create_pooled();	
			array_copy(array,0,parameters,0,array_length(parameters));
		}else{
			var _i = 0;
			repeat(array_length(parameters)){
				if !ds_map_exists(map,parameters[_i]){
					array_push(array,parameters[_i]);	
					ds_map_add(map,parameters[_i],1);
				}
				_i ++;
			}
		}
		
		//recurse deeper
		var _i = 0;
		repeat(array_length(contents)){
			if is_string(contents[_i]){
				array = container_getdata(contents[_i]).get_parameters(array,map);
			}
			_i ++;
		}
		
		//bubble up
		if top{
			ds_map_destroy_pooled(map);	
		}
		return array;
	}
}



function class_audio_container_blendmap() constructor{
	left = 0;
	right = 100;
	cleft = 0;
	cright = 100;
}