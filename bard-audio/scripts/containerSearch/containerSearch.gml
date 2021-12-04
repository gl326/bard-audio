/// @description containerSearch(list, text)
/// @param list
/// @param  text
function containerSearch(argument0, argument1) {
	var list=argument0,search=argument1;
	var n = ds_list_size(list);
	for(var i=0;i<n;i+=1){
	            var con = ds_list_find_value(list,i),name,sub = is_string(con);
	            if !sub{
	                name = audio_get_name(con);
	            }else{
	                name = ds_map_find_value(real(con),"name");
	            }
	            name = string_lower(name);
	            if string_pos(search_t,name)>0 and ds_list_find_index(container_search,con)==-1
	            {
	                ds_list_add(container_search,con);
	            }
	            if sub{
	                containerSearch(container_contents(real(con)),search);
	            }
	        }



}
