/// @description string_split(str, delimiter)
/// @param str
/// @param  delimiter
function string_split(argument0, argument1) {
	//ARGUMENTS:
	//0         -       string to split
	//1         -       delimiter to use
	//returns ds_list
	var newVal, delemiter,list=ds_list_create();
	newVal = "";
	delemiter = argument1;

	for (var i=1; i<string_length(argument0)+1; i+=1)
	{
	var split = false;
	switch(argument_count){
		case 4: split = (split or (string_char_at(argument0,i) == argument[3]));	
		case 3: split = (split or (string_char_at(argument0,i) == argument[2]));	
		default: split = (split or (string_char_at(argument0,i) == delemiter));
	}
	if split
	{
	  i += 1
	  if newVal!=""{
	    ds_list_add(list,newVal);
	    newVal = "";
	    }
	}
 
	 newVal += string_char_at(argument0,i)

	}
	if newVal!=""{ds_list_add(list,newVal);}

	return list;



}
