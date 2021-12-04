/// @description busSearch()
/// @param text
function busSearch() {
	var n = ds_map_size(global.audio_busses),k=ds_map_find_first(global.audio_busses);
	ds_list_clear(bus_search);
	    //make lists
	    for(var i=0;i<n;i+=1){
	        if string_pos(search_t,string_lower(k))>0 and ds_list_find_index(bus_search,k)==-1
	            {
	            ds_list_add(bus_search,k);
	            }
	        k = ds_map_find_next(global.audio_busses,k);
	    }



}
