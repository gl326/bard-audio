/// @description aeChangeTab()
function aeChangeTab(argument0) {
	with(objAudioEditor){
	    tab = argument0;
	    search_update = -1;
	    containsize = -1;
	    switch(tab){
	    case 2:
	        containbut.script = aeNewBus;
	        containbut.name = "New Bus";
	    break;
    
	    case 1:
	        containbut.script = aeNewParam;
	        containbut.name = "New Param";
	    break;
    
	    default:
	        containbut.script = aeNewContainer;
	        containbut.name = "New Container";
	    break;
	    }
    
	    with(objaeButton){if script==aeChangeTab{
	            if args[0]==argument0{lit = true;}
	            else{lit = false;}
	        }}
	}





}
