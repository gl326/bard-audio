/// @description aePreviousEditingSound
function aePreviousEditingSound() {
	with(objAudioEditor){
	    if ds_list_size(editing_history)-(history_id+1)>0{
	        var top = (history_id==0);
	        var map = ds_list_find_value(editing_history,ds_list_size(editing_history)-history_id-1);
	        aeSetEditingSound(ds_map_find_value(map,"editing"),ds_map_find_value(map,"audio"),!top);
	        history_id += 1;
	    }
	}



}
