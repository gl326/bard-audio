/// @description bus_recalculate(bus name,calc)
/// @param bus name
/// @param calc
function bus_recalculate() {
	//rcalculate the given bus gain, given the calculation of its parent.
	//goes recusrively down until all children are in their new form
	var calc = 0,list=-1,calced = -1;
	if argument_count>1{calc = argument[1];}
	if argument_count>2{list = argument[2]; calced = list;} //stop duplicates
	else{calced = ds_list_create();}
	if ds_map_exists(global.audio_busses,argument[0]){
	    ds_list_add(calced,argument[0]);
	    var map = ds_map_find_value(global.audio_busses,argument[0]);
	    //if ds_exists(map,ds_type_map){
	        calc = ((calc+1)
	            *((ds_map_Find_value(map,"gain")/100)+1)
	            )-1;
	        ds_map_replace(global.audio_bus_calculated,argument[0],calc);
        
	        var contlist = ds_map_find_value(map,"children");
	        for(var i=0;i<ds_list_size(contlist);i+=1){
	            var newbus = ds_list_find_value(contlist,i);
	            if ds_list_find_index(calced,newbus)=-1{
	                bus_recalculate(newbus,calc,calced);
	            }else{
	                ds_list_delete(contlist,i);
	                i-=1;
	            }
	        } 
        
	        with(objAudioContainer){
	            if setup and !deleted{
	                if ds_list_find_index(audio_busses,argument[0])!=-1{
	                    ds_list_add(bus_update,argument[0]);
	                }
	            }
	        }
	}
	if list==-1{ds_list_destroy(calced);}
	return calc;



}
