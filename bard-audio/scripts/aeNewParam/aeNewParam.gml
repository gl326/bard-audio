function aeNewParam() {
	with(objAudioEditor){
	var val = get_string("name the new parameter",""),
	    val2 = get_string("default value? (0-100)","0");
		if val!="" and val2!="" and string_number(val2)==val2{
		    param_create(val,max(0,min(100,real(val2))));
			aeBrowserUpdate();
		}
	}



}
