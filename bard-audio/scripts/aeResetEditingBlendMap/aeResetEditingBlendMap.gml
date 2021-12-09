/// @description aeResetEditingBlendMap
function aeResetEditingBlendMap() {
	with(objAudioEditor){
	if editing!=-1{
	if !editing_audio{
	    container_getdata(editing).blend_setup();
	}
	}
	}



}
