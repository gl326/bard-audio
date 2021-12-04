///@param name
///@param id
///@param option
function container_pause() {
	var con = argument[0],
	    sid = -1,
	    option = false;
	if argument_count>1{sid = argument[1];}
	if argument_count>2{option = argument[2];}
	//show_message("called from "+object_get_name(object_index));
	if is_string(con){
	    con = ds_map_find_value(global.audio_containers,con);
	    }
 
	var obj = noone;
	with(objAudioContainer){
	    if !paused and setup and !deleted and container==con {obj = id; break;}
	}
	if obj==noone{return -1;}
	else{
		with(obj){
			paused = true;
			paused_time = current_time;
		
			var n = ds_list_size(playing);
			for(var i=0;i<n;i+=1){
			    var s = ds_list_find_value(playing,i),
			        aud = ds_map_find_value(s,"aud");
			    audio_pause_sound(aud);
			}
		}
	}


}
