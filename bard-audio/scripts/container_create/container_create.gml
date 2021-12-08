// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// create a new class and add it to the serialization array
function container_create(name,fromProject=false){
	if !ds_map_exists(global.audio_containers,name){
		var ret = new class_audio_container(name,fromProject);
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