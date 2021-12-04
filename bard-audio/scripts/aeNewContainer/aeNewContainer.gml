function aeNewContainer() {
	with(objAudioEditor){
	var val = get_string("name the new container","");
	if val!=""{
	    var nnew = container_create(val);
	    if nnew!=-1{
	        ds_list_add(container_root_list(),string(nnew));
	        editing=nnew;
	        editing_audio = false;
	        save_audioedit();
	        }
	}
	}



}
