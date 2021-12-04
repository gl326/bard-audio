/// @description loadAudioFolder(file, current line str, list to fill)
/// @param file
/// @param  current line str
/// @param  list to fill
function loadAudioFolder(argument0, argument1, argument2) {
	var file = argument0,str = argument1,list=argument2;
	var startstr = "<sound>sound\\", endstr = "</sound>",mstr="",mus;
	FS_file_text_readln(file); str = FS_file_text_read_string(file);
	while(string_pos("</sounds>",str)==0){
	    if string_pos("<sounds ",str)>0{ //new folder
	        var namestart = "<sounds name=\"", nameend = "\">";
	        var name = string_copy(str,string_pos(namestart,str)+string_length(namestart),
	        string_length(str)-(string_length(namestart)+string_length(nameend)+string_pos(namestart,str))+1);
	        var contain = container_create(name);
	        var nlist = container_contents(contain);
	        ds_list_add(list,string(contain));
	        ds_list_add(locked_containers,name);
	        loadAudioFolder(file,str,nlist);
	    }
	    else{ //new asset in current folder
	    mstr = string_copy(str,string_pos(startstr,str)+string_length(startstr),
	        string_length(str)-(string_length(startstr)+string_length(endstr)+string_pos(startstr,str))+1);
	    ds_list_add(list,asset_get_index(mstr));
	    }
        
	    FS_file_text_readln(file); str = FS_file_text_read_string(file);
	}



}
