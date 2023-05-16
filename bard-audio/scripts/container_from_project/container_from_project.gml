// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function container_from_project(_name,_parent,_order = 0){
	var _data = container_getdata(_name,true,true);
	_data.from_project = true;
	_data.editor_order = _order;	
	_data.parent = _parent;
	
	//add me to my parent using the project order
	_parent = container_getdata(_parent,true,true);
	var _i = 0;
	repeat(array_length(_parent.contents_serialize)){
		if container_getdata(_parent.contents_serialize[_i]).editor_order<=_data.editor_order{
			_i ++;	
		}else{
			break;	
		}
	}
	array_insert(_parent.contents_serialize,_i,_name);
}