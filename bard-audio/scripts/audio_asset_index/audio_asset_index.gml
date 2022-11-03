// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_asset_index(_path,_container = undefined, _index = 0){
	var ret = global.audio_external_assets[?_path];
	if is_undefined(ret){
		ret = -1;
		
		var search_name = filename_name(_path);
		var _i = 0,
			files = ds_map_keys_to_array(global.audio_external_assets);
			
		repeat(array_length(files)){
			var file = files[_i];
			var file_name = filename_name(file);
			if file_name==search_name{
				if ret==-1{
					var _item = global.audio_external_assets[?file];
					ret = _item; //return the intended index from the new location
					
					if !is_undefined(_container){
						_container.contents_serialize[_index] = container_content_serialize(_item);	//move the reference to the new moved location
					}
					//show_debug_message(_path+" [>>MOVED TO>>] "+file);
					break; //you could remove this to keep searching and make sure there arent duplicates, but for the sake of speed on big projects its probably not worth a warning
				}else{
					show_debug_message("WARNING! "+_path+" matches more than one file so it might be weird now");
					break;
				}
			}
			_i ++;	
		}
	}
	
	return ret;
}