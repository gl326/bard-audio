function music_key_define() {
	with(the_audio){
		var l = ds_list_create(),
			max_note = -1;
		for(var i=1;i<argument_count;i+=1){
			var note = argument[i];
			while(note<max_note){
				note += 12;	
			}
			max_note = note;
			ds_list_add(l,note);
		}
		if max_note>12{
			var octs = floor(max_note/12);
			if octs>0{
				for(var i=1;i<argument_count;i+=1){
					ds_list_replace(l,i-1,ds_list_find_value(l,i-1)-(octs*12));
				}	
			}
		}
	
		ds_map_add_list(music_key_notes,argument[0],l);
	}


}
