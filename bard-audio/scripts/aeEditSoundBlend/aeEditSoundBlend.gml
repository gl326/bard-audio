/// @description aeEditSoundBlend()
function aeEditSoundBlend() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    if !ds_map_exists(editing,"blend_map"){ //make sure blending is on + there is a blend map
	            ds_map_Replace(editing,"blend_on",1);
	            aeResetEditingBlendMap();
	            //aeToggleSoundAttribute("blend_on");
	        }
        
	    ////////////////////open curve editor////////////////////////
	        var cw = 800,ch=600,mx = max(cw/2,min(room_width-(cw/2),mouse_x)),my = max(ch/2,min(room_height-(ch/2),mouse_y));
	        var cur = newHighlightable(objaeParamEditor,mx-(cw/2),my-(ch/2),mx+(cw/2),my+(ch/2));
	        var param_ref = ds_map_Find_value(editing,"blend");
	        if is_string(param_ref){
			/*
	        cur.curves = ds_map_find_value(
	                                ds_map_find_value(
	                                    global.audio_params,
	                                    param_ref),
	                                    container_name(editing));
			*/
	        cur.param = param_ref;
	        }
        
	        cur.blend = ds_map_find_value(editing,"blend_map");
	        global.highlighted = cur;
    
    
	}
	}
	}



}
