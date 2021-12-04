/// @description aeDefaultPitchRand()
function aeDefaultPitchRand() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    if ds_map_Find_value(editing,"pitchmin")==0
	    and ds_map_Find_value(editing,"pitchmax")==0{
	        ds_map_Replace(editing,"pitchmin",-13);
	        ds_map_Replace(editing,"pitchmax",13);
	    }else{
	        ds_map_Replace(editing,"pitchmin",0);
	        ds_map_Replace(editing,"pitchmax",0);
	    }
	    with(objTextfield){force_update = 1;}
	}
	}
	}



}
