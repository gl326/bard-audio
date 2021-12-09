// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function bard_audio_data_load(){
		var _filename = "audio_data.json";
        var _path = get_datafiles_directory()+_filename;
        
        if (file_exists(_path))
        {
            global.bard_audio_data = ElephantFromJSON(json_parse(file_read_string(_path)));
        }
        
        
}