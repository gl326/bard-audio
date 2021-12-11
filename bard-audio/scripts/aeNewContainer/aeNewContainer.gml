function aeNewContainer() {
	with(objAudioEditor){
	var val = get_string("name the new container","");
	if val!=""{
	    var nnew = container_create(val,false);
	    if nnew{
			container_getdata(val).deserialize_contents();
	        editing = val;
	        editing_audio = false;
			aeBrowserUpdate();
	        }
	}
	}



}
