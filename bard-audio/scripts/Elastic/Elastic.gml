function Elastic(argument0) {
	var t = argument0;
	//if ((t*2) == 2){return 1;} ///????
 
	var p = (0.3 * 1.5);
	var s = p / 4;

	var tt = t-1;

	return sqr(min(1,t*2))+(sin(sqrt(max(0,t-.5)*2)*3*pi)*sqrt(max(0,1-t))*.15);
	/*
	if (t < 1){
	    return -0.5 * (power(2, 10 * (t)) * sin((tt - s) * (2 * pi) / p));
	}
	return power(2, -10 * (t)) * sin((tt - s) * (2 * pi) / p) * 0.5 + 1;


/* end Elastic */
}
