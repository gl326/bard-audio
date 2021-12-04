/// @description aeCountReferences(preserve unlisted)
/// @param preserve unlisted
function aeCountReferences() {
	with(objAudioEditor){
	var ref,list;
	if argument_count>=2{list = argument[0]; ref=argument[1];}
	else{
	    ref = ds_map_create();
	    list = container_root_list();
	    }

	if is_real(list){
	    var n = ds_list_size(list);
	    for(var i=0;i<n;i+=1){
	                var con = ds_list_find_value(list,i),sub = is_string(con);
	                if sub{
	                    var cid = real(con);
	                    if ds_exists(cid,ds_type_map){
	                        var name = container_name(cid);
	                        //if !ds_map_exists(ref,name) and debug_mode
	                        //and name=="amb_act1_town"{show_message("reference found for "+name)}
	                        ds_map_Replace(ref,name,ds_map_Find_value(ref,name)+1);
							var cont = container_contents(cid);
							if cont!=list{
								aeCountReferences(cont,ref);
							}
	                    }
	                }else{
						if is_undefined(con){
							ds_list_delete(list,i);
							i -= 1;
							n -= 1;
						}
					}
	    }
	}

	if argument_count<=1{
	var del = false;
	//if argument_count>0{del = !argument[0];}
	var n = ds_map_size(global.audio_containers),k=ds_map_find_first(global.audio_containers);
	for(var i=0;i<n;i+=1){
	    var next_k = ds_map_find_next(global.audio_containers,k); //get the next one before potentially deleting the current
	    if k!="Sounds" and !ds_map_exists(ref,k) and ds_list_find_index(container_root_list(),string(ds_map_find_value(global.audio_containers,k)))==-1{
	        //i hope this is ok to do in studio2 now
			if !global.reload_audio{
				file_delete("audioData_project2");
				room_restart();
			}
	        if !del// or global.STUDIO2
	        {
	            ds_list_add(container_root_list(),string(ds_map_find_value(global.audio_containers,k)));
	        }else{
	            aeDestroyContainer(ds_map_find_value(global.audio_containers,k));
	        }
	    }
	    k = next_k;
	}
	ds_map_destroy(ref);
	}
	}



}
