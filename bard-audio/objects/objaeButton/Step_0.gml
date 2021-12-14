if visible{
pressed += (0-pressed)*.1;
if am_highlighted(){
    if is_string(args){script_execute(script);}
    else{
        switch(array_length_1d(args)){
            case 1: script_execute(script,args[0]); break;
            case 2: script_execute(script,args[0],args[1]); break;
            case 3: script_execute(script,args[0],args[1],args[2]); break;
            case 4: script_execute(script,args[0],args[1],args[2],args[3]); break;
        }
    }
    global.highlighted = noone;
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
}


