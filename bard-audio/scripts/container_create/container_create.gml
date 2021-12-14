/// only for use inside the editor. there's no reason for containers to change during gameplay!
function container_create(name,fromProject=false){
	if !ds_map_exists(global.audio_containers,name){
		var ret = new class_audio_container(name,fromProject);
		ret.track();
		array_push(
			global.bard_audio_data[bard_audio_class.container], 
			ret
		);
		return ret;
	}else{
		show_debug_message(concat("WARNING! tried to create container ",name,", but a container with that name already exists"));
		return global.audio_containers[?name];
	}
}