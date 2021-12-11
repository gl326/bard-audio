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
	
	ds_map_add(global.audio_busses,name,self); //track me!
	
	//find my mommy
	if parent!=undefined{
		if array_find_index(parent.children,self)==-1{
			array_push(parent.children,self);	
		}
	}
	
	ELEPHANT_SCHEMA
    {
        ELEPHANT_VERBOSE_EXCLUDE : [
			"editor_expand",
			"gain",
			"calc",
        ],
    }
	
	ELEPHANT_POST_READ_METHOD
    {
		gain = default_gain;
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
			
			i = 0;
			repeat(array_length(global.audio_players)){
				global.audio_players[i].bus_updated(name);
				i ++;
			}	
		}
        
			i = 0;
	        repeat(array_length(children)){
	            var newbus = children[i];
	            if array_find_index(calced,newbus)=-1{
	                newbus.recalculate(calc,calced);
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
}