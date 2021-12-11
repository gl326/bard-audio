function aeNewBus() {
	with(objAudioEditor){
	var val = get_string("name the new bus","");
	if val!=""{
	    bus_create(val);
		aeBrowserUpdate();
	}
	}



}
