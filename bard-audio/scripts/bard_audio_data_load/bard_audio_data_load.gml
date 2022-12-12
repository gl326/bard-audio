// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function bard_audio_data_load(){
		var _filename = "audio_data.json";
        var _path = _filename;
        
        if (file_exists(_path))
        {
            global.bard_audio_data = ElephantFromJSON(json_parse(file_read_string(_path)));
			
			//these audio assets are stranded without a corresponding file; it was probably renamed or deleted
			var _assets = global.bard_audio_data[bard_audio_class.asset],
				_i = 0;
			repeat(array_length(_assets)){
				if _assets[_i].marked_to_delete{
					array_delete(_assets,_i,1);
				}else{
					_i ++;
				}
			}
			
			//unpack container contents
			var _data = global.bard_audio_data[bard_audio_class.container],
				_i = 0;
			repeat(array_length(_data)){
				_data[_i].deserialize_contents();
				_i ++;
			}
			
			_i = 0;
			repeat(array_length(_data)){
				_data[_i].check_parent();
				_i ++;
			}
			
			//setup initial bus volume
			var _busses = global.bard_audio_data[bard_audio_class.bus],
				_i = 0;
			repeat(array_length(_busses)){
				_busses[_i].recalculate();
				_busses[_i].default_effects();
				_i ++;
			}
        }
        
        
}