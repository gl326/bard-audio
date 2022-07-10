// create a new class and add it to the serialization array
function audio_asset_external(path,_project = ""){
	if !ds_map_exists(global.audio_external_assets,path){
		var ret = new class_audio_asset(path,true, _project);
		ret.setup();
		array_push(
			global.bard_audio_data[bard_audio_class.asset], 
			ret
		);
		return ret;
	}else{
		//show_debug_message(concat("WARNING! tried to create an asset class for ",audio_asset_name(assetIndex),", but a class for that asset index already exists"));
		return global.audio_assets[?global.audio_external_assets[?path]];
	}
}