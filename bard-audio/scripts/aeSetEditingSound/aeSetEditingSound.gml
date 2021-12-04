/// @description aeSetEditingSound(id, is_audio, save history)
/// @param id
/// @param  is_audio
/// @param  save history
function aeSetEditingSound() {
	var cid=argument[0],aud=argument[1],clearhist = true, ret = true;
	if argument_count>=3{clearhist = !argument[2];}
	with(objAudioEditor){
	    holding =-1;
	    if editing!=-1{
	    if clearhist{
	        //save_audioedit();
	        repeat(history_id){
	            var map = ds_list_find_value(editing_history,ds_list_size(editing_history)-1);
	            ds_map_destroy(map);
	            ds_list_delete(editing_history,ds_list_size(editing_history)-1)
	        }
	        history_id = 0;
	        ds_list_add_map(editing_history,map_Create("editing",editing,"audio",editing_audio));
	        if ds_list_size(editing_history)>50{
	            var map = ds_list_find_value(editing_history,0);
	            ds_map_destroy(map);
	            ds_list_delete(editing_history,0);
	        }
	    }
	    }
	    var old_edita = editing_audio;
	                editing_audio = aud;
	                if !editing_audio{
	                    if !ds_exists(cid, ds_type_map){
	                        show_message("this container's data doesn't exist for some reason!");
	                        //go back
	                        cid = editing;
	                        editing_audio = old_edita;
	                        return false;
	                        }
	                }
                
	                editing = cid;
                
	                if !editing_audio{
	                    for(var i=0;i<ds_list_size(container_buttons);i+=1){
	                        (ds_list_find_value(container_buttons,i)).visible = true;
	                    }
	                    for(var i=0;i<ds_list_size(asset_buttons);i+=1){
	                        (ds_list_find_value(asset_buttons,i)).visible = false;
	                    }
	                    aeTypeEditingSound(container_type(editing));
	                }else{
	                    for(var i=0;i<ds_list_size(container_buttons);i+=1){
	                        (ds_list_find_value(container_buttons,i)).visible = false;
	                    }
	                    for(var i=0;i<ds_list_size(asset_buttons);i+=1){
	                        (ds_list_find_value(asset_buttons,i)).visible = true;
	                    }
	                    assetgainbut.param = audio_get_name(editing);
	                    var val = (ds_map_Find_value(global.audio_asset_vol,audio_get_name(editing)))/100;
	                    if val>-1{
	                        assetgainbut.text = string(20*log10(val+1))
	                    }else{
	                        assetgainbut.text = "-144";
	                    }
                    
	                    assetbusbut.param = audio_get_name(editing);
	                    assetbusbut.text = string(ds_map_Find_value(global.audio_asset_bus,audio_get_name(editing)));
	                }
                
	}

	return true;



}
