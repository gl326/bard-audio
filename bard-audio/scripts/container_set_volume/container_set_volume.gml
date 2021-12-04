///@param name
///@param secs
///@param option
function container_set_volume(argument0, argument1) {
	var con = argument0;
	//	loophead = false;
	//if argument_count>2{loophead = argument[2];}
	
	//show_message("called from "+object_get_name(object_index));
	if is_string(con){
	    con = ds_map_find_value(global.audio_containers,con);
	    }
 
	var obj = noone;
	with(objAudioContainer){
	    if setup and !deleted and container==con {obj = id; break;}
	}
	if obj==noone{return -1;}
	else{
		with(obj){
			volume = argument1;
			return -1;
		
		}
	}


}
