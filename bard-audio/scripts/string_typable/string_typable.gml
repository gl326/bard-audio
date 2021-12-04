/// @description string_typable(string)
/// @param string
function string_typable(argument0) {
	var str="";
	for(var i=1;i<=string_length(argument0);i+=1){
	    var ch = string_char_at(argument0,i);
	    if ch=="-" or string_digits(ch)==ch or ch=="."
	        or string_letters(ch)==ch or ch=="_"
	    {str+=ch;}
	}

	return str;



}
