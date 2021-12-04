///@param container
///@param noteId
///@param containerId
function container_pitch_note() {
	var con = argument[0],
	    sid = -1;
	if argument_count>2{sid = argument[2];} 
	//show_message("called from "+object_get_name(object_index));

	////find object
	if is_string(con){
	    con = ds_map_find_value(global.audio_containers,con);
	    }
 
	var obj = noone;
	with(objAudioContainer){
	    if !paused and setup and !deleted and container==con {obj = id; break;}
	}
	if obj==noone{return -1;}
	else{
	
		var nid = argument[1],
			perc = 0,
			fract = frac(nid);
		if fract==0{
			perc = container_note_to_percent(nid);
		}else{
			var perca = container_note_to_percent(floor(nid)),
				percb = container_note_to_percent(ceil(nid));
			perc = lerp(perca,percb,fract);
		}

		//set relevant sounds to new pitch
		with(obj){
			live_update = false;
		
			var n = ds_list_size(playing);
			for(var i=0;i<n;i+=1){
			    var s = ds_list_find_value(playing,i);
				if (sid==-1 or ds_map_find_value(s,"playid")==sid){
				    var aud = ds_map_find_value(s,"aud");
				    audio_sound_pitch(aud,1+(perc/100));
				}
			}
		}
	}

	//audio_param_set("note",pitch);


}
