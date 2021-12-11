function aeNewContainer() {
	with(objAudioEditor){
	var val = get_string("name the new container","");
	if val!=""{
	    var nnew = container_create(val,false);
	    if nnew{
			editing = container_getdata(val);
			editing.deserialize_contents();
	        editing_audio = false;
			aeBrowserUpdate();
	        }
	}
	}



}
