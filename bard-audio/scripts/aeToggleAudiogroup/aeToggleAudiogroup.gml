/// @description aeToggleAudiogroup(group)
/// @param group
function aeToggleAudiogroup(argument0) {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    var set = !ds_map_Find_value(editing,argument0);
	    ds_map_Replace(editing,argument0,set);
	    if argument0=="blend_on"{
	        aeResetEditingBlendMap();
	        ds_map_Replace(editing,argument0,ds_map_exists(editing,"blend_map"));
	    }
	}
	}
	}



}
