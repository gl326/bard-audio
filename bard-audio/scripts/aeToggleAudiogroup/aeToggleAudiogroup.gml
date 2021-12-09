/// @description aeToggleAudiogroup(group)
/// @param group
function aeToggleAudiogroup(argument0) {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    var set = !variable_struct_get(editing,argument0);
	    variable_struct_set(editing,argument0,set);
	    if argument0=="blend_on"{
	        aeResetEditingBlendMap();
	        variable_struct_set(editing,argument0,ds_map_exists(editing,"blend_map"));
	    }
	}
	}
	}



}
