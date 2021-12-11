// the basic structure here is ripped right outta juju's Gumshoe library for browsing files
function bard_audio_load_external(_directory,_parent=undefined){
    var _directories = [],
		_directory_containers = [];
	
    //Search through this directory
    var _file = undefined;
    while(true)
    {
        _file = (_file == undefined)? file_find_first(_directory + "*", fa_directory) : file_find_next();
        if (_file == "") break;
        
		var _path = _directory + _file;
		
        if (directory_exists(_path))
        {
            //queue this directory for processing later
            _directories[@ array_length(_directories)] = _path + "\\";
			
			//create a container
			var _container_name = _file;
			 _directory_containers[@ array_length(_directory_containers)] = container_getdata(_container_name,true,true);
			 
			 if !is_undefined(_parent){
				 //add to parent contents
				 array_push(_parent.contents_serialize,_file);
			 }
        }
        else 
        {
			//create an asset
			var asset = audio_asset_external(_path);
            
			if !is_undefined(_parent){
				//add to parent contents
				array_push(_parent.contents_serialize,"%"+_path);
			}
        }
    }
    
    file_find_close();
    
    //Now handle the directories
    var _i = 0;
    repeat(array_length(_directories))
    {
		bard_audio_load_external(_directories[_i],_directory_containers[_i]);
        ++_i;
    }
    
}