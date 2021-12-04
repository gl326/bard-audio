function aeNewBus() {
	with(objAudioEditor){
	var val = get_string("name the new bus","");
	if val!=""{
	    var nnew = bus_create(val);
	    if nnew!=-1{
	        ds_list_add(busses,val);
	        ds_map_add_list(bushierarchy,val,ds_list_create());
	        save_audioedit();
	        }
	}
	}



}
