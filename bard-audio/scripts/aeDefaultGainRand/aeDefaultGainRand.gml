/// @description aeDefaultGainRand()
function aeDefaultGainRand() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    if ds_map_Find_value(editing,"volmin")==0
	    and ds_map_Find_value(editing,"volmax")==0{
	        ds_map_Replace(editing,"volmin",-20);
	        ds_map_Replace(editing,"volmax",20);
	    }else{
	        ds_map_Replace(editing,"volmin",0);
	        ds_map_Replace(editing,"volmax",0);
	    }
	    with(objTextfield){force_update = 1;}
	}
	}
	}



}
