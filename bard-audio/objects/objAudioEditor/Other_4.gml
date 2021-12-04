if audio_loaded{
	aeLoadEditor();
	if editing!=-1{
	    if !aeSetEditingSound(editing,editing_audio,1){
	        editing = -1;
	    }
	}
}

window_set_cursor(cr_default);
audio_stop_all();
bus_set("foley_gameplay",0);
bus_set("sfx_gameplay",0);
bus_set("music_gameplay",0);
bus_set("vo_gameplay",0);
//bus_set("singing_gameplay",0);
//bus_set("ambience_gameplay",0);

var test = false;
