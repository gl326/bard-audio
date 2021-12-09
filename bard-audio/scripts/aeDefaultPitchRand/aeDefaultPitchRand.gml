/// @description aeDefaultPitchRand()
function aeDefaultPitchRand() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    if variable_struct_get(editing,"pitchmin")==0
	    and variable_struct_get(editing,"pitchmax")==0{
	        variable_struct_set(editing,"pitchmin",-13);
	        variable_struct_set(editing,"pitchmax",13);
	    }else{
	        variable_struct_set(editing,"pitchmin",0);
	        variable_struct_set(editing,"pitchmax",0);
	    }
	    with(objTextfield){force_update = 1;}
	}
	}
	}



}
