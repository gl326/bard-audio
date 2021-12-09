/// @description aeDefaultGainRand()
function aeDefaultGainRand() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    if variable_struct_get(editing,"volmin")==0
	    and variable_struct_get(editing,"volmax")==0{
	        variable_struct_set(editing,"volmin",-20);
	        variable_struct_set(editing,"volmax",20);
	    }else{
	        variable_struct_set(editing,"volmin",0);
	        variable_struct_set(editing,"volmax",0);
	    }
	    with(objTextfield){force_update = 1;}
	}
	}
	}



}
