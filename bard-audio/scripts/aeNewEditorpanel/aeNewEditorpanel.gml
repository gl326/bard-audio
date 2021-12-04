/// @description aeNewEditorpanel(obj,x,y,w,h)
/// @param obj
/// @param x
/// @param y
/// @param w
/// @param h
function aeNewEditorpanel() {
	if argument_count==1{
	return instance_create_depth(0,0,0,argument[0]);
	}
	else{
	var ins = instance_create_depth(argument[1],argument[2],0,argument[0]);
	ins.l=ins.x; ins.t=ins.y;

	if argument_count>=5{
	ins.r=ins.x+argument[3];
	ins.b=ins.y+argument[4];
	}

	return ins;
	}



}
