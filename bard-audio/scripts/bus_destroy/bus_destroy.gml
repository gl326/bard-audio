/// @description bus_destroy(name)
/// @param name
//used by editor functions, not to be used during gameplay probably
function bus_destroy(argument0) {
	var name=argument0;

	if ds_map_exists(global.audio_busses,name){
		var bus = global.audio_busses[?name],
			serial = global.bard_audio_data[bard_audio_class.bus],
			_i = 0;
		repeat(array_length(serial)){
			if serial[_i].parent==name{
				serial[_i].parent = bus.parent;	
			}
			_i ++;
		}
		
		array_delete(serial, array_find_index(serial,bus), 1);
	    ds_map_delete(global.audio_busses,name);
	    return 1;
	}
	else{
	    show_message("already doesnt exist!");
	    return 0;
	}




}
