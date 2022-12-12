/// @description aeEditSoundBlend()
function aeEditSoundBlend() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    //if !ds_map_exists(editing,"blend_map"){ //make sure blending is on + there is a blend map
	     //       variable_struct_set(editing,"blend_on",1);
	    //        aeResetEditingBlendMap();
	    //    }
        
	    ////////////////////open curve editor////////////////////////
	        var cw = 800,ch=600,mx = max(cw/2,min(room_width-(cw/2),mouse_x)),my = max(ch/2,min(room_height-(ch/2),mouse_y));
	        var cur = newHighlightable(objaeParamEditor,mx-(cw/2),my-(ch/2),mx+(cw/2),my+(ch/2));
	        //var param_ref = variable_struct_get(editing,"blend");
	        cur.param = editing.variable_has_hook("blend");
        
	        cur.blend = variable_struct_get(editing,"blend_map");
	        global.bard_editor_highlighted = cur;
    
    
	}
	}
	}



}
