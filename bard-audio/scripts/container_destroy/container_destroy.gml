/// only for use inside the editor. there's no reason for containers to change during gameplay!
function container_destroy(name,manual=true) {
	name = container_getdata(name).name;
	if ds_map_exists(global.audio_containers,name){
		var class = global.audio_containers[?name];
		if class.from_project{
			if manual{show_message("if you want to delete "+name+", delete the folder from your gamemaker project first!");}
		}else{
		if !manual or show_question("delete "+name+"?"){
			//delete references 
			var serial = global.bard_audio_data[bard_audio_class.container];
				
			array_delete(serial, array_find_index(serial,class), 1);
			ds_map_delete(global.audio_containers,name);
			
			
			var _i = 0;
				repeat(array_length(serial)){
					var sclass = serial[_i],
						ind = array_find_index(sclass.contents,name);
					if ind!=-1{
						array_delete(sclass.contents,ind,1);
						array_delete(sclass.contents_serialize,ind,1);
					}
					_i ++;	
				}
			
			//delete parameter hooks
			serial = global.bard_audio_data[bard_audio_class.parameter];
			var _i = 0;
			repeat(array_length(serial)){
				serial[_i].hook_delete(name);
				_i ++;
			}
			
			//think about recursively deleting all my children too (horrific)
			var checkkids = true;
			if manual{
				checkkids = false;
				var _i = 0;
				repeat(array_length(class.contents)){
					if is_string(class.contents[_i]){
						checkkids = true;
						break;
					}
					_i ++;	
				}
				
			}
			
			if checkkids{
				if !manual or show_question("recursively delete children of "+name+"? (if not, they will all be dumped into the root container)"){
					var _i = 0;
					repeat(array_length(class.contents)){
						if is_string(class.contents[_i]){
							container_destroy(class.contents[_i],false);
						}
						_i ++;	
					}
				}else{
					var _i = 0;
					repeat(array_length(class.contents)){
						if is_string(class.contents[_i]){
							container_getdata(class.contents[_i]).check_parent();
						}
						_i ++;	
					}	
				}
			}
			
			//update the browser view after all this destruction
			aeBrowserUpdate();
			
			///ok done
			return 1;
		}
		}
	}

	return false;
}
