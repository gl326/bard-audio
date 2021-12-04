function aeAudioLoadPanel() {
	if !instance_exists(objaeAudioloader){
	with(objAudioEditor){
	    aeNewEditorpanel(objaeAudioloader);
	}
	}else{
	    with(objaeAudioloader){
	        instance_destroy();
	    }
	}



}
