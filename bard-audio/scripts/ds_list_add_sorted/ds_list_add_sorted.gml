/// @param list
/// @param val
/// @param start
/// @param end
function ds_list_add_sorted(argument0, argument1, argument2, argument3) {
	//returns true if the value did not exist and was added
	//returns false if the value was found in the list already
	if ds_list_empty(argument0){
		ds_list_add(argument0,argument1);
		return true;	
	}
	
	var list = argument0,
		val = argument1,
		minn = argument2,
		maxn = argument3;

	while(minn<maxn){
		var i = ceil((minn+maxn)/2);
		var oval = ds_list_find_value(list,i);
		if oval==val{
			return false;	
		}else{
			if oval>val{
				maxn = i-1;
			}else{
				minn = i;
			}
		}
	}	

	var oval = ds_list_find_value(list,maxn);
		if oval==val{
			return false;	
		}else{
			if oval>val{
				ds_list_insert(list,maxn,val);
			}else{
				ds_list_insert(list,maxn+1,val);
			}
			return true;
		}



}
