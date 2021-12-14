// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function bard_audio_data_save(){
		var _filename = "audio_data.json";
        var _path = get_datafiles_directory()+_filename;
        
        var _string = snap_to_json(GregephantToJSON(global.bard_audio_data), true, true);
        file_write_string(_path, _string);
		
		show_debug_message("audio data saved!");
		with(objAudioEditor){
			saved_fx = 1;	
		}
}