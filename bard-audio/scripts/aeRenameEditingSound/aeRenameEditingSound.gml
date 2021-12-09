/// @description aePlayEditingSound()
function aeRenameEditingSound() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    if ds_list_find_index(locked_containers,container_name(editing))!=-1{
	        show_message("This can only be renamed inside Game Maker");
	    }else{
	        var val = get_string("Enter a new name",container_name(editing));
	        if val!=""{
	            var oldname = container_name(editing);
	            ds_map_delete(global.audio_containers,oldname);
	            variable_struct_set(editing,"name",val);
	            ds_map_add_map(global.audio_containers,container_name(editing),editing);
	            for(var p=0;p<ds_list_size(params);p+=1){
	                var par = ds_list_find_value(params,p);
	                if ds_map_exists(par,oldname){
	                    var hold = ds_map_find_value(par,oldname);
	                    ds_map_delete(par,oldname);
	                    ds_map_add_map(par,val,hold);
	                }
	            }
	        }
	    }
	}else{
	    show_message("This can only be renamed inside Game Maker");
	}
	}
	}



}
