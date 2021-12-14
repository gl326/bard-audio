/// @description aePlayEditingSound()
function aeRenameEditingSound() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    if editing.from_project{
	        show_message("This can only be renamed inside Game Maker");
	    }else{
	        var val = get_string("Enter a new name",container_name(editing));
	        if val!=""{
				if !ds_map_exists(global.audio_containers,val){
		            var oldname = container_name(editing);
		            ds_map_delete(global.audio_containers,oldname);
				
					editing.name = val;
		            ds_map_add(global.audio_containers,container_name(editing),editing);
					
					//update all attachments...
					var _i, _data;
					
					
					//container parents and children
					_data = global.bard_audio_data[bard_audio_class.container];
					_i = 0;
					repeat(array_length(_data)){
						if _data[_i].parent==oldname{
							_data[_i].parent = val;	
						}
						
						var cont = _data[_i].contents_serialize,
							_j = 0;
						repeat(array_length(cont)){
							if cont[_j]==oldname{
								cont[_j] = val;
								_data[_i].contents[_j] = val;
							}
							_j ++;
						}
						_i ++;	
					}
					
					//parameter hooks
					_data = global.bard_audio_data[bard_audio_class.parameter];
					_i = 0;
					repeat(array_length(_data)){
						var hooks = _data[_i].hooks;
						if hooks.Exists(oldname){
							hooks.Add(val,hooks.Get(oldname));
							hooks.Delete(oldname);
						}
						_i ++;	
					}
				}else{
					show_message("This new name is already in use by another container!");
				}
	        }
	    }
	}else{
	    show_message("This can only be renamed inside Game Maker");
	}
	}
	}



}
