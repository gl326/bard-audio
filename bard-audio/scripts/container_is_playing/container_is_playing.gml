/// @description container_is_playing(name)
/// @param name
function container_is_playing(argument0) {
	var con = argument0;
	if is_string(con){
	    con = ds_map_find_value(global.audio_containers,con);
	    }
    
	var obj = noone;
	with(objAudioContainer){if container == con{obj = id; break;}}
	if obj==noone or !obj.setup{return false;}
	else{
	    return obj.am_playing;
	    //if obj.group==-1{return obj.am_playing;}//(ds_list_size(obj.playing)>0);}
	    //else{return obj.group_playing;}
	}



}
