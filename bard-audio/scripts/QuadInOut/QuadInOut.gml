function QuadInOut(argument0) {
	var t = argument0;
	return  choice(sqr(t * 2) / 2 , QuadOut(t * 2 - 1) / 2 + 0.5, (t > 0.5));


}
