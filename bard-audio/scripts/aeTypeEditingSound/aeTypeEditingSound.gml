/// @description aeTypeEditingSound(type)
/// @param type
function aeTypeEditingSound(argument0) {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    with(objaeButton){
	        if script==aeTypeEditingSound{lit=(argument0==args[0]);}
	    }
	    (other.id).lit = true;
	    editing.type = argument0;
		if editing.type==2{
			if !variable_struct_exists(editing,"blend_map") or array_length(editing.blend_map)!=array_length(editing.contents){
				editing.blend_setup();	
			}
		}
    
	    var l = -1;
	    switch(argument0){
	        case 0: l = choice_buttons; break;
	        case 1: l = loop_buttons; break;
	        case 2: l = multi_buttons; break;
	    }
	    for(var i=0;i<ds_list_size(loop_buttons);i+=1){
	        var b = ds_list_find_value(loop_buttons,i);
	        b.visible = (argument0==1) or ds_list_find_index(l,b)!=-1;
	    }
	    for(var i=0;i<ds_list_size(choice_buttons);i+=1){
	        var b = ds_list_find_value(choice_buttons,i);
	        b.visible = (argument0==0) or ds_list_find_index(l,b)!=-1;
	    }
	    for(var i=0;i<ds_list_size(multi_buttons);i+=1){
	        var b = ds_list_find_value(multi_buttons,i);
	        b.visible = (argument0==2) or ds_list_find_index(l,b)!=-1;
	    }
	}
	}
	}





}
