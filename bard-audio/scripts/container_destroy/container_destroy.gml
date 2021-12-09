/// only for use inside the editor. there's no reason for containers to change during gameplay!
function container_destroy(name) {
	if ds_map_exists(global.audio_containers,name){
		var class = global.audio_containers[?name];
		if class.from_project{
			show_message("if you want to delete "+name+", delete the folder from your gamemaker project first!");
		}else{
		if show_question("delete "+name+"?"){
			//delete references 
			var serial = global.bard_audio_data[bard_audio_class.container];
				
			array_delete(serial, array_find_index(serial,class), 1);
			ds_map_delete(global.audio_containers,name);
			
			//delete parameter hooks
			serial = global.bard_audio_data[bard_audio_class.parameter];
			var _i = 0;
			repeat(array_length(serial)){
				serial[_i].hook_delete_container(name);
				_i ++;
			}
			
			///ok done
			return 1;
		}
		}
	}

	return false;
}
