// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function class_audio_asset(_name,_external=false) constructor{
	external = _external;
	if !external{
		path = "";
		name = _name;
		index = asset_get_index(name);
	}else{
		path = _name;
		name = filename_name(path);
		index = global.external_audio_index;
		global.external_audio_index ++;
	}
	gain = 0;
	bus = "";
	editor_order = 0;
	
	loaded = false;
	
	ELEPHANT_SCHEMA
    {
        ELEPHANT_VERBOSE_EXCLUDE : [
			"loaded",
        ],
    }
	
	if !external{
		if asset_get_index(name)!=-1{
			ds_map_add(global.audio_assets,index,self); //track me!
		}else{
			show_debug_message(concat("WARNING! no matching audio asset for \"",name,"\". was it deleted or renamed?"));
		}
	}else{
		if file_exists(path){
			ds_map_add(global.audio_assets,index,self); //track me!
		}else{
			show_debug_message(concat("WARNING! no file for \"",path,"\". was it deleted or renamed?"));
		}
	}
}