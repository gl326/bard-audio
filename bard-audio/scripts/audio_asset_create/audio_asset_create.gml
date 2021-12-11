// create a new class and add it to the serialization array
function audio_asset_create(assetIndex){
	if !ds_map_exists(global.audio_assets,assetIndex){
		var ret = new class_audio_asset(audio_asset_name(assetIndex));
		ret.setup();
		array_push(
			global.bard_audio_data[bard_audio_class.asset], 
			ret
		);
		return ret;
	}else{
		//show_debug_message(concat("WARNING! tried to create an asset class for ",audio_asset_name(assetIndex),", but a class for that asset index already exists"));
		return global.audio_assets[?assetIndex];
	}
}