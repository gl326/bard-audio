/// @description param_create(name, default)
/// @param name
/// @param  default
function param_destroy(name) {
	if ds_map_exists(global.audio_params,name){
		if show_question("delete "+name+"? will also delete any existing connections it has to containers"){
			//delete references 
			var serial = global.bard_audio_data[bard_audio_class.parameter],
				class = global.audio_params[?name];
			array_delete(serial, array_find_index(serial,class), 1);
			ds_map_delete(global.audio_params,name);
			
			//delete container hooks
			serial = global.bard_audio_data[bard_audio_class.container];
			var _i = 0;
			repeat(array_length(serial)){
				serial[_i].hook_delete(name);
				_i ++;
			}
			
			//effects aren't strictly tracked, so they cant be iterated thru to delete these... but they will delete the connections once they realize they arent valid anymore
			
			aeBrowserUpdate();
			///ok done
			return 1;
		}
	}

	return false;
}
