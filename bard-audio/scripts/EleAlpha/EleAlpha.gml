function EleAlpha(argument0) {
	//y = 0.003428571 + 1.148571*x - 1.108571*x^2 + 0.96*x^3
	//y = -0.0005714286 + 1.895238*x - 2.708571*x^2 + 1.813333*x^3'

	//this function tells us how dark each elevation level should appear based on the max onscreen height, 0-1

	var t = argument0;
	if t<=.5{
		t = max(t,0);
		return .1+.9*(((1 - sqr(1-(t*2))))/2);
	}else{
		t = min(t,1);
		return .1+.9*(sqr(t * 2 - 1)/2 + 0.5);
	}
	//InvQuadInOut(clamp(argument0,0,1));

	/*
	inv quadinout
	var t = argument0;
	return  choice(QuadOut(t * 2) / 2 , QuadIn(t * 2 - 1) / 2 + 0.5, (t > 0.5));
	*/

	//0.003428571 + 1.5*argument0 - power(1.4*argument0,2) + power(0.96*argument0,3); //THIS ONE WAS USED FORVEER...

	//return 0.003428571 + 1.148571*argument0 - power(1.108571*argument0,2) + power(0.96*argument0,3);

	//return -0.0005714286 + 1.895238*argument0 - power(2.708571*argument0,2) + power(1.813333*argument0,3);


}
