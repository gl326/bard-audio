/// @description container_attribute(container id, attribute, optional obj)
/// @param container id
/// @param  attribute
/// @param  optional obj
function container_attribute() {
	var con=argument[0], attr=argument[1], obj = noone;
	var val = 0;//ds_map_Find_value(con,attr);
	if ds_map_exists(con,attr){val = ds_map_find_value(con,attr);}
	else{return 0;}

	if !is_string(val)//is_real(val) or is_bool(val)
	{
	    return val;
	}
	else{
	    //show_message("attr "+attr+" has param "+val);
	    if ds_map_exists(global.audio_params,val){
	        var param = ds_map_find_value(global.audio_params,val),
	            name = container_name(con);
	        //show_message("found param "+val);
	        if ds_map_exists(param,name){
	            //show_message("found data for "+container_name(con)+" in "+val);
	            var pcon = ds_map_find_value(param,name);
	            if ds_map_exists(pcon,attr){
	                var state = ds_map_find_value(global.audio_state,val);
						//audio_param_state(val);
	                if argument_count>2{
	                    obj = argument[2];
	                    if !obj.firstplay{
	                        //ONLY DOES THIS ON FIRST PLAY...
	                        //potential bug if on different plays, different parameters are used
	                        //but this hasnt come up, so i am allowing this for efficiency
	                        ds_list_add(obj.parameters,val);
	                    }
	                    }
	                return curve_eval(ds_map_find_value(pcon,attr), state);
	            }else{
	                return 0;
	            } 
	        }else{
	            return 0;
	        }
	    }else{
	        return 0;
	    }
        
	}



}
