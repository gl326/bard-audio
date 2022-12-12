if visible{
pressed += (0-pressed)*.3;
if am_bard_editor_highlighted(){
	global.bard_editor_highlighted = noone;
		
    if is_string(args){script_execute(script);}
    else{
        switch(array_length(args)){
            case 1: script_execute(script,args[0]); break;
            case 2: script_execute(script,args[0],args[1]); break;
            case 3: script_execute(script,args[0],args[1],args[2]); break;
            case 4: script_execute(script,args[0],args[1],args[2],args[3]); break;
        }
    }
    pressed = 1;
}

if script==aeToggleSoundAttribute{
    if is_struct(objAudioEditor.editing){
        lit = variable_struct_get(objAudioEditor.editing,args[0]);
    }
}

if script==aeAlphabetical{
    lit = (objAudioEditor.alphabetical);
}

if script==aeToggleEffectOn{
	lit = args[0].has_effect_class(args[1]);	
}

if script==aeToggleEffectDefaultOn{
	lit = args[0].default_on;	
}
}


