function InvQuadInOut(argument0) {
	var t = argument0;
	return  choice(QuadOut(t * 2) / 2 , QuadIn(t * 2 - 1) / 2 + 0.5, (t > 0.5));



}
