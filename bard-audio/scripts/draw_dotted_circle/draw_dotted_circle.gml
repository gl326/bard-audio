/// @description draw_dotted_circle(x,y,rad)
/// @param x
/// @param y
/// @param rad
function draw_dotted_circle(argument0, argument1, argument2) {
	var xx=argument0,yy=argument1,rad=argument2;
	var divs=8,angle = (current_time/1000)*90;
	for(var i=0;i<divs;i+=1){
	    var x1 = xx+lengthdir_x(rad,angle+(i/divs*360)),
	        y1 = yy+lengthdir_y(rad,angle+(i/divs*360)),
	        x2 = xx+lengthdir_x(rad,angle+((i+.5)/divs*360)),
	        y2 = yy+lengthdir_y(rad,angle+((i+.5)/divs*360));
	    draw_line(x1,y1,x2,y2);
	}



}
