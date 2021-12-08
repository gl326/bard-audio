if audio_loaded{
	aeLoadEditor();
	if editing!=-1{
	    if !aeSetEditingSound(editing,editing_audio,1){
	        editing = -1;
	    }
	}
}

//window_set_cursor(cr_default);
audio_stop_all();
