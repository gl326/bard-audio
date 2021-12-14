
	aeLoadEditor();
	if editing!=-1{
	    if !aeSetEditingSound(editing,editing_audio,1){
	        editing = -1;
	    }
	}

///reset... evertyhing
bard_audio_clear(true);
bus_reset_all();
audio_param_reset_all();

audio_stop_all();
