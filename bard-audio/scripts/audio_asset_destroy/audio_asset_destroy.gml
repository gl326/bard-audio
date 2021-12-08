// create a new class and add it to the serialization array
function audio_asset_destroy(assetIndex){
	if ds_map_exists(global.audio_assets,assetIndex){
		var class = global.audio_assets[?assetIndex],
			serial = global.bard_audio_data[bard_audio_class.asset];
			
		array_delete(serial, array_find_index(serial,class), 1);
		ds_map_delete(global.audio_assets,assetIndex);
		
		show_debug_message(concat("deleted data for audio asset ",assetIndex," (",audio_get_name(assetIndex),")"));
	}
}