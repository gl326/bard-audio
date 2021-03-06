/// @description aeBusChildren()
function aeGainChildren() {
	with(objAudioEditor){
	var snd = -1,gain = 0;
	if argument_count>0{snd = argument[0]; gain = argument[1];}
	else{if !editing_audio{snd = editing; gain = container_getdata(snd).gain;}}
	if snd!=-1{
	    var con = container_contents(snd);
	    for(var i=0;i<array_length(con);i+=1){
	        var c = con[i];
	        if is_string(c){
	            container_getdata(snd).gain = gain;
	            //aeBusChildren(c,bus);
	        }else{
				audio_asset_set_gain(c,gain);
	        }
	    }
	}
	}

	/*///aeDestroyContainer(container)
	var del = argument0;
	with(objAudioEditor){
	with(objAudioContainer){if container==del{container_stop(container); instance_destroy();}}
        
	        ds_map_delete(global.audio_containers,container_name(del));
	        deleteFromContainerList(containers,del);
        
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


/* end aeGainChildren */
}
