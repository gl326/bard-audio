/// @description aeDestroyContainer(container)
/// @param container
function aeDestroyContainer(argument0) {
	var del = argument0;
	with(objAudioEditor){

	with(objAudioContainer){if container==del{container_stop(container); instance_destroy();}}
        
	        ds_map_delete(global.audio_containers,container_name(del));
	        deleteFromContainerList(container_root_list(),del);
        
	        /////delete param references
	        var name = container_name(del),n=ds_list_size(params);
	        for(var i=0;i<n;i+=1){
	            var pa = ds_list_find_value(params,i);
	            if ds_map_exists(pa,name){
	                ds_map_destroy(ds_map_find_value(pa,name));
	                ds_map_delete(pa,name)
	            }
	        }     
	}

	with(objTextfield){
	            if editing==del{
	                editing = -1;
	            }
	        }   
        


}
