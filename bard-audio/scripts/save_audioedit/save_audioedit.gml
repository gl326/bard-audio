/// @description save_audioedit()
function save_audioedit() {
	var paramsave = json_encode(global.audio_params);
	var savestr = json_encode(global.audio_containers);
	var save_map = json_decode(savestr);
	//
	var k = ds_map_find_first(save_map),n=ds_map_size(save_map);
	for(var i=0;i<n;i+=1){
	    var c = container_contents(ds_map_find_value(save_map,k)),
	        cn = ds_list_size(c);
	    for(var j=0;j<cn;j+=1){
	        var cc = ds_list_find_value(c,j);
	        if is_string(cc){
				if string_number(cc)==cc{
					ds_list_replace(c,j,container_name(real(cc)));
				}
	        }else{
	            ds_list_replace(c,j,audio_get_name(cc)); //save sound file names too!
	        }
	    }
	    k = ds_map_find_next(save_map,k);
	}

	/*
	var file = file_text_open_write("audioData");
	file_text_write_string(file,json_encode(save_map));

	file_text_writeln(file); file_text_write_string(file,paramsave);

	file_text_close(file);*/

	//ohhh bboyoyoyoyyyyyy
	var final_savestr = json_encode(save_map);

	/*
	//save directly into project (doesn't work in newer game maker versions)
	var file = FS_file_text_open_write(global.project_directory+"datafiles\\audioData");
	FS_file_text_write_string(file,final_savestr);
	FS_file_text_writeln(file); FS_file_text_write_string(file,paramsave);
	FS_file_text_writeln(file); FS_file_text_write_real(file,audio_data_version);
	FS_file_text_writeln(file); FS_file_text_write_string(file,ds_map_write(global.audio_asset_vol));
	FS_file_text_writeln(file); FS_file_text_write_string(file,json_encode(global.audio_busses));
	FS_file_text_writeln(file); FS_file_text_write_string(file,ds_map_write(global.audio_asset_bus));
	FS_file_text_writeln(file); FS_file_text_write_string(file,ds_list_write(searchlist));
	FS_file_text_close(file);

	//save to exact current path that the file is being read from
	var file = FS_file_text_open_write(filename_path("audioData")+"audioData");
	FS_file_text_write_string(file,final_savestr);
	FS_file_text_writeln(file); FS_file_text_write_string(file,paramsave);
	FS_file_text_writeln(file); FS_file_text_write_real(file,audio_data_version);
	FS_file_text_writeln(file); FS_file_text_write_string(file,ds_map_write(global.audio_asset_vol));
	FS_file_text_writeln(file); FS_file_text_write_string(file,json_encode(global.audio_busses));
	FS_file_text_writeln(file); FS_file_text_write_string(file,ds_map_write(global.audio_asset_bus));
	FS_file_text_writeln(file); FS_file_text_write_string(file,ds_list_write(searchlist));
	FS_file_text_close(file);
	*/

	///////////////////////LINED VERSION///////////////////////////
	var ppath = global.project_directory+"datafiles\\audio_data";
	var file = file_text_open_write(ppath);
	file_text_write_lined_json(file,final_savestr);
	file_text_writeln(file); file_text_write_lined_json(file,paramsave);
	file_text_writeln(file); file_text_write_lined_json(file,json_encode(global.audio_asset_vol));
	file_text_writeln(file); file_text_write_lined_json(file,json_encode(global.audio_busses));
	file_text_writeln(file); file_text_write_lined_json(file,json_encode(global.audio_asset_bus),",");
	//file_text_writeln(file); file_text_write_string(file,ds_list_write(searchlist));
	file_text_close(file);

	var fpath = filename_path("audio_data")+"audio_data";
	var file = FS_file_text_open_write(fpath);
	FS_file_text_write_lined_json(file,final_savestr);
	FS_file_text_writeln(file); FS_file_text_write_lined_json(file,paramsave);
	FS_file_text_writeln(file); FS_file_text_write_lined_json(file,json_encode(global.audio_asset_vol));
	FS_file_text_writeln(file); FS_file_text_write_lined_json(file,json_encode(global.audio_busses));
	FS_file_text_writeln(file); FS_file_text_write_lined_json(file,json_encode(global.audio_asset_bus),",");
	FS_file_text_close(file);

	/*
	var file = file_text_open_write(filename_path("audio_data")+"audio_data");
	file_text_write_lined_json(file,final_savestr);
	file_text_writeln(file); file_text_write_lined_json(file,paramsave);
	file_text_writeln(file); file_text_write_lined_json(file,json_encode(global.audio_asset_vol));
	file_text_writeln(file); file_text_write_lined_json(file,json_encode(global.audio_busses));
	file_text_writeln(file); file_text_write_lined_json(file,json_encode(global.audio_asset_bus),",");
	file_text_writeln(file); file_text_write_string(file,ds_list_write(searchlist));
	file_text_close(file);
	*/
	//////////////////////////////////////////////////////

	//save backup
	audio_data_version += 1;
	audio_data_maxversion = audio_data_version;

	var file = file_text_open_write("working\\backups\\audio\\audio_data_"+string(audio_data_version));
	file_text_write_lined_json(file,final_savestr);
	file_text_writeln(file); file_text_write_lined_json(file,paramsave);
	file_text_writeln(file); file_text_write_lined_json(file,json_encode(global.audio_asset_vol));
	file_text_writeln(file); file_text_write_lined_json(file,json_encode(global.audio_busses));
	file_text_writeln(file); file_text_write_lined_json(file,json_encode(global.audio_asset_bus),",");
	file_text_close(file);

	var max_undos = 50;
	if audio_data_version>max_undos{
	    file_delete("working\\backups\\audio\\audio_data_"+string(audio_data_version-max_undos));
	}



	ds_map_destroy(save_map);
//	ds_list_destroy(searchlist);

	with(objAudioEditor){
	    saved_fx = 1;
	    aeSaveEditor();
	    }



}
