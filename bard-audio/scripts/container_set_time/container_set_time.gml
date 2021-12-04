///@param name
///@param secs
///@param option
function container_set_time() {
	var con = argument[0],
	    secs = argument[1];
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
			var n = ds_list_size(playing);//get_time = 0;
			//if loophead{n = min(1,n);}
			for(var i=0;i<n;i+=1){
			    var s = ds_list_find_value(playing,i),
			        aud = ds_map_find_value(s,"aud");
					//if loophead{
					//	get_time = audio_sound_get_track_position(aud);
					//}
			    audio_sound_set_track_position(aud,secs);
			}
		

				var n = ds_list_size(delay_sounds);
				for(var i=0;i<n;i+=1){
				    var s = ds_list_find_value(delay_sounds,i);
				    //var del = ds_map_Find_value(s,"delayin") - (delta_time/1000000);//(1/room_speed);
				    //if del>0{ds_map_Replace(s,"delayin",del);}
				    //else
					//var st = ds_map_find_value(s,"playstart");
					//if current_time >= ds_map_find_value(s,"playstart")+(ds_map_find_value(s,"delayin")*1000)
					ds_map_replace(s,"playstart",current_time - (secs*1000));
				}
		
		}
	}


}
