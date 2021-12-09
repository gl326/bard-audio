/// @description aeDeleteBus(name);
/// @param name
function aeDeleteBus() {
	var name = string(argument[0]),option=0;
	if argument_count>1{option = argument[1];}
	with(objAudioEditor){
	    if ds_map_exists(global.audio_busses,name){
	    if show_question("delete bus "+name+"?"){
	    bus_destroy(name);
      
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
