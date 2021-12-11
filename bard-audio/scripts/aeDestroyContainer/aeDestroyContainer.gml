/// @description aeDestroyContainer(container)
/// @param container
function aeDestroyContainer(argument0) {
	var del = argument0;
	if container_destroy(del){

	with(objTextfield){
	            if editing==del{
	                editing = -1;
	            }
	        } 
			
		aeBrowserUpdate();
		return true;
	}else{
		return false;
	}

}
