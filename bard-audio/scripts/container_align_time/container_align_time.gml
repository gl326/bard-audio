///@param name
///@param secs
///@param option
function container_align_time(argument0) {
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
			var n = ds_list_size(playing),
				t = -1;//get_time = 0;
			for(var i=0;i<n;i+=1){
			    var s = ds_list_find_value(playing,i),
			        aud = ds_map_find_value(s,"aud");
				if t==-1{
					t = audio_sound_get_track_position(aud); //return 1st one
				}else{
					if abs(audio_sound_get_track_position(aud)-t)>.05{
						audio_sound_set_track_position(aud,t);
					}
				}
			}
		
			return -1;
		
		}
	}


}
