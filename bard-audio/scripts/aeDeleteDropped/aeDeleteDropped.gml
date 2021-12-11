function aeDeleteDropped() {
	with(objAudioEditor){
	if holding_ind!=-1 and holding_list!=-1{
			array_delete(holding_parent.contents_serialize,holding_ind,1);
	        array_delete(holding_list,holding_ind,1);
	        holding_list = -1;
	        holding_ind = -1;
	        //reset blend map?
	        }
	}



}
