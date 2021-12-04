/// @description audio_grouplist_load(name)
/// @param name
function audio_grouplist_load(argument0) {

	with(the_audio){
	    if audio_loaded!=argument0
	    and ds_map_exists(global.audio_groups,argument0){
	        var newl = ds_map_find_value(global.audio_groups,argument0);
	        if audio_loaded!=""{
	            var oldl = ds_map_find_value(global.audio_groups,audio_loaded);
	            for(var i=0;i<ds_list_size(oldl);i+=1){
	                var ag = ds_list_find_value(oldl,i);
	                if ds_list_find_index(newl,ag)==-1{
	                    var unl = audio_group_unload(ag);
	                    //ds_list_add(audio_unloading,ag);
	                    unload_start = current_time;
	                }
	            }
	        }
        
	        for(var i=0;i<ds_list_size(newl);i+=1){
	               //if audio_group_load(ds_list_find_value(newl,i)){
	                    ds_list_add(audio_loading,ds_list_find_value(newl,i));
	                    loading_audio = true;
	               //}
	            }
	        audio_loaded = argument0;
	        if !loading_audio{the_audio.audio_room = false;}
	    }
	}



}
