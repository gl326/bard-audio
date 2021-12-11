/// @description aeDeleteEditingSound()
function aeDeleteEditingSound() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
		return container_destroy(editing);
	}else{show_message("This can only be deleted inside Game Maker");}
	}
	}



}
