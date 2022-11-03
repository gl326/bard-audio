// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function container_getdata(_container,mustExist=false,fromProject=false){
	if is_string(_container){
	    if ds_map_exists(global.audio_containers,_container){
	        _container = ds_map_find_value(global.audio_containers,_container);
			if fromProject{
				if _container.editor_deserialized{
					_container.contents_serialize = [];
					_container.editor_deserialized = false;
				}	
			}
	    }else{
			if mustExist{
				return container_create(_container,true);
			}else{
		        show_debug_message("tried to get nonexistent container "+_container);
		        return undefined;
			}
	    }
	}
	return _container;
}

function container_exists(_containerName){
	return (ds_map_exists(global.audio_containers,_containerName));
}