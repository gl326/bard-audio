/// @description remap_value(val, original min, original max, new min, new max)
/// @param val
/// @param  original min
/// @param  original max
/// @param  new min
/// @param  new max
function remap_value(argument0, argument1, argument2, argument3, argument4) {
	var in = argument0,
	    omin=min(argument1,argument2),
	    omax=max(argument2,argument1),
	    nmin=argument3,
	    nmax=argument4,
	    val=min(omax,max(omin,in));
	return lerp(nmax,nmin,(omax-val)/(omax-omin));



}
