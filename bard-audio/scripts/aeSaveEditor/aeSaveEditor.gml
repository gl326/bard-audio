function aeSaveEditor() {
	with(objAudioEditor){
	var file = file_text_open_write("audioEditor");
	var fakemap = ds_map_create();
	ds_map_add_list(fakemap,"history",editing_history);


	var str=string(editing);
	if !editing_audio and editing!=-1{str = container_name(editing)}

	file_text_write_string(file,str); file_text_writeln(file);
	file_text_write_real(file,history_id); file_text_writeln(file);
	file_text_write_string(file,json_encode(fakemap)); file_text_writeln(file);
	file_text_write_string(file,string(the_audio.audio_loaded)); file_text_writeln(file);
	file_text_close(file);

	ds_map_delete(fakemap,"history");
	ds_map_destroy(fakemap);

	file_copy("audioEditor",
	"working\\backups\\audio\\audioEditor_"+string(audio_data_version)); //for undo
	}



}
