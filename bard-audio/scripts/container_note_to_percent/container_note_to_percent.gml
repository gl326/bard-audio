	//////get key
function container_note_to_percent(argument0) {
		var key = the_audio.music_key;
	

		/////get pitch integer
		var notes = ds_map_find_value(the_audio.music_key_notes,key),
			n = ds_list_size(notes), //SHOULD always be 8, but...
			nid = argument0,
			nadjust = 0;
		while(nid>=n){
			nid -= n-1;
			nadjust += 12;
		}
		while(nid<0){
			nid += n-1;
			nadjust -= 12;
		}
		var note = ds_list_find_value(notes,nid)+nadjust;
		//if note>12{
		//	note += 1;	
		//}
		while (note>12){
			note -= 12;	
		}
		while (note<-12){
			note += 12;	
		}
		var pitch = 2+(4*((note+12) mod 25));

		return container_pitch_to_percent(pitch);


}
