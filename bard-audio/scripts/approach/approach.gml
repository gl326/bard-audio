/// @param orig
/// @param dest
/// @param spd
function approach(argument0, argument1, argument2) {

	if abs(argument0-argument1)<=argument2{
			return argument1;
	}else{
		return argument0 + sign(argument1-argument0)*argument2;	
	}


}
