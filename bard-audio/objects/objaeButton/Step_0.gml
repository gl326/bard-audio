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
    if objAudioEditor.editing!=-1 and !objAudioEditor.editing_audio{
        lit = ds_map_find_value(objAudioEditor.editing,args[0]);
    }
}

if script==audio_grouplist_load{
    lit = (the_audio.audio_loaded==args[0]);
}

if script==aeAlphabetical{
    lit = (objAudioEditor.alphabetical);
}
}


