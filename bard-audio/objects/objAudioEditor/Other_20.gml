/// @description RELOAD ALL FILES
if AUDIO_EDITOR_CAN_LOAD_DATA{
#region project
var project_data = json_parse(file_read_string(project_file)); //get data from project
var _i = 0,
	resources = project_data.resources,
	resource_n = array_length(resources),
	folders = project_data.Folders,
	folder_n = array_length(folders);
	
var parent_from_path = function(path){
	var _parent_end = string_length(path),
			_parent_start = _parent_end;
		while(string_char_at(path,_parent_end)!="/"){
			_parent_end -= 1;	
		}
		_parent_start = _parent_end-1;
		while(string_char_at(path,_parent_start)!="/"){
			_parent_start -= 1;	
		}
		
		return string_copy(path,_parent_start+1,_parent_end-_parent_start-1); //get name of next folder up	
}

var audio_group_names = [];
var audio_group_data = project_data.AudioGroups;
_i = 0;
repeat(array_length(audio_group_data)){
	audio_group_names[_i] = audio_group_data[_i].name;
	_i ++;
}
	
var _data = global.bard_audio_data[bard_audio_class.container]; //serialized folders data
	
//unlink containers from the project
_i = 0;
repeat(array_length(_data)){
	_data[_i].from_project = false;
	_i ++;
}
	
//turn project folders into containers
_i = 0;
repeat(folder_n){
	var folder = folders[_i];
	var path = folder.folderPath;
	if string_copy(path,1,15)=="folders/Sounds/"{
		//found a sound folder!
		container_from_project(folder.name,parent_from_path(path),(variable_struct_exists(folder,"order")?folder.order:0));
	}
	_i ++;	
}

//get resources from project
_i = 0;
repeat(resource_n){
	var resource = resources[_i],
		path = resource.id.path;
	if string_copy(path,1,7)=="sounds/"{
		//found a sound asset!
		var resource_data = json_parse(file_read_string(global.__bard_project_directory+path)),
			parent = resource_data.parent.name,
			_name = resource_data.name;
		
		//insert into parent contents
		var parent_data = container_getdata(parent);
		if !is_undefined(parent_data){
			//create or get matching class
			var asset = audio_asset_create(asset_get_index(_name));
			if variable_struct_exists(resource,"order"){asset.editor_order = resource.order;}
			asset.audio_group_id = array_find_index(audio_group_names,resource_data.audioGroupId.name);
			
			var _j = 0;
			repeat(array_length(parent_data.contents_serialize)){
				var _cdata = parent_data.contents_serialize[_j];
				if string_char_at(_cdata,1)=="$"{
					_cdata = global.audio_assets[?asset_get_index(string_copy(_cdata,2,string_length(_cdata)-1))]; //an asset
				}else{
					_cdata = container_getdata(_cdata); //a container
				}
				
				if _cdata.editor_order<=asset.editor_order{
					_j ++;	
				}else{
					break;	
				}
			}
			array_insert(parent_data.contents_serialize,_j,"$"+_name);
		}else{
			show_debug_message(concat("WARNING! couldn't find matching container for folder ",parent," containing asset ",resource_data.name));	
		}
	}
	_i ++;	
}
#endregion

#region external
	_bard_get_project();
	var _project = global.__bard_project_directory + "datafiles/";
	bard_audio_load_external(EXTERN_SOUND_FOLDER, _project);
#endregion

//unpack all the contents
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

}

aeBrowserScrollReset();
aeBrowserUpdate();