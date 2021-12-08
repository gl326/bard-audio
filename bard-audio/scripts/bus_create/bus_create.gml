/// @description bus_create(name)
/// @param name
//used by editor functions, not to be used during gameplay probably
function bus_create(name,gain=0,parent=-1) {
	if !ds_map_exists(global.audio_busses,name){
	    return new class_audio_bus(name,gain,parent);
	}
	else{
	    show_message("there's already a bus with this name!");
	    return -1;
	}




}
