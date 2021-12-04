/// @description aeDeleteBus(name);
/// @param name
function aeDeleteBus() {
	var name = string(argument[0]),option=0;
	if argument_count>1{option = argument[1];}
	with(objAudioEditor){
	    if ds_map_exists(global.audio_busses,name){
	    if show_question("delete bus "+name+"?"){
	    var con = ds_map_find_value(global.audio_busses,name);
	    var l = ds_map_find_value(bushierarchy,name),n=ds_list_size(l);
    
	            for(var i=0;i<n;i+=1){
	                if !aeDeleteBus(ds_list_find_value(l,0),1){
	                    return 0;
	                }
	            }
	            ds_list_destroy(l);
	            ds_list_delete(bushierarchy,name);
        
	    var parlist = busses;
	    if is_string(ds_map_find_value(con,"parent")){parlist = ds_map_find_value(bushierarchy,ds_map_find_value(con,"parent"));}
	    ds_list_delete(parlist,ds_list_find_index(parlist,name));
    
	    ds_map_destroy(con);
	    ds_map_delete(global.audio_busses,name);
      
	    with(objEditorpanel){
	        if title==name{
	            aeClosePanel(id);
	        }
	    } 
	    if !option{
	            //save_audioedit();
	            ds_list_clear(bus_search);
	            rebuild_bussearch = true;
	        }
	    return 1;
	    }else{return 0;}
	    }
	}


	return 0;



}
