/// @description bus_create(name)
/// @param name
//used by editor functions, not to be used during gameplay probably
function bus_create(name,gain=0,parent=undefined) {
	if !ds_map_exists(global.audio_busses,name){
		var ret = new class_audio_bus(name,gain,parent);
		array_push(
			global.bard_audio_data[bard_audio_class.bus], 
			ret
		);
		return ret;
	}
	else{
	    show_message("there's already a bus with this name!");
	    return -1;
	}




}
