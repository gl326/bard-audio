/// @description aeResetEditingBlendMap
function aeResetEditingBlendMap() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    if ds_map_exists(editing,"blend_map")
	        {
	            ds_list_destroy(ds_map_find_value(editing,"blend_map"));
	            ds_map_delete(editing,"blend_map");
	        }
	        if ds_map_Find_value(editing,"blend_on"){
	            var newblend = ds_list_create(),n=ds_list_size(container_contents(editing));
	            for(var i=0;i<n;i+=1){
	                var amt = .25/2;
	                ds_list_add_map(newblend,
	                    map_Create(
	                        "left",max(0,i-amt)/n*100,
	                        "right",min(n,i+1+amt)/n*100,
	                        "cleft",max(0,i+choice(amt,0,i==0))/n*100,
	                        "cright",min(n,i+1-choice(amt,0,i==(n-1)))/n*100
	                        ));
	            }
	            ds_map_add_list(editing,"blend_map",newblend);
	        }
	}
	}
	}



}
