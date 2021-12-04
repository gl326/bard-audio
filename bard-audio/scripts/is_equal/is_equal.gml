/// @description not_equal(a, b, etc)
/// @param a
/// @param  b
/// @param  etc
function is_equal() {
	var is = is_string(argument[0]);
	for(var i=1;i<argument_count;i+=1){
	    if is_string(argument[i])!=is
	    or argument[i]!=argument[0]{
	        return false;
	    }
	}

	return true;



}
