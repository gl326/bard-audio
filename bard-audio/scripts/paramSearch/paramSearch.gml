/// @description paramSearch(list, text)
/// @param list
/// @param  text
function paramSearch(argument0, argument1) {
	var list=argument0,search=argument1;
	var n = ds_list_size(list);
	for(var i=0;i<n;i+=1){
	            var con = ds_list_find_value(list,i),name;//,sub = is_string(con);
	            name = string_lower(param_name(con));
	            if string_pos(search_t,name)>0 and ds_list_find_index(param_search,con)==-1
	            {
	                ds_list_add(param_search,con);
	            }

	        }



}
