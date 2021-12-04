function aeDeleteDropped() {
	with(objAudioEditor){
	if holding_ind!=-1 and holding_list!=-1{
	        ds_list_delete(holding_list,holding_ind);
	        holding_list = -1;
	        holding_ind = -1;
	        //reset blend map?
	        }
	}



}
