/// @description draw_blendregion(l, t, r, b, cleft, cright, outline)
/// @param l
/// @param  t
/// @param  r
/// @param  b
/// @param  cleft
/// @param  cright
/// @param  outline
function draw_blendregion(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
	var x1=argument0,y1=argument1,x2=argument2,y2=argument3,
	    xl=argument4,xr=argument5,outl=argument6,
	    mx = lerp(xl,xr,.5),my=lerp(y1,y2,.5);
    
	if outl{draw_primitive_begin(pr_linestrip);}
	else{draw_primitive_begin(pr_trianglestrip);}

	draw_vertex(xl,y1);
	if !outl{draw_vertex(mx,y2);}  

	var qual = 8;
	for(var i=1;i<qual;i+=1){
	    draw_vertex(lerp(xl,x1,i/qual),lerp(y1,y2,QuadInOut(i/qual)));
	    if !outl{draw_vertex(mx,y2);}     
	}

	draw_vertex(x1,y2);
	if !outl{draw_vertex(mx,y2);}  


	draw_vertex(x2,y2);
	if !outl{draw_vertex(mx,y2);}  

	for(var i=1;i<qual;i+=1){
	    draw_vertex(lerp(x2,xr,i/qual),lerp(y2,y1,QuadInOut(i/qual)));
	    if !outl{draw_vertex(mx,y2);}     
	}

	draw_vertex(xr,y1);
	if !outl{draw_vertex(mx,y2);}  

	draw_vertex(xl,y1);

	draw_primitive_end();



}
