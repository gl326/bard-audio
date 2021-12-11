// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function container_content_serialize(item){
	if is_string(item){
		return item;	
	}else{
		var data = global.audio_assets[?item];
		if data.external{
			return "%"+data.path;
		}else{
			return "$"+data.name;	
		}
	}
}