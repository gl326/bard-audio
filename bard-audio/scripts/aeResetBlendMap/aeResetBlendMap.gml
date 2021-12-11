/// @description aeResetBlendMap(contaner)
/// @param contaner
function aeResetBlendMap(argument0) {
	var data = container_getdata(argument0);
	if !is_undefined(data){
		data.blend_setup();
	}


}
