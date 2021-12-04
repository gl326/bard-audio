///@param container
///@param noteId
function container_play_note(argument0, argument1) {
	var sobj = container_play(argument0); 

		sobj.live_update = false;
		container_pitch_note(argument0,argument1,sobj.play_id);
	return sobj;

	/*
	var key = "cmaj";
	if ds_map_exists(the_audio.music_keys,the_audio.music_scene){
		key = ds_map_find_value(the_audio.music_keys,the_audio.music_scene);
	}else{
		if ds_map_exists(the_audio.music_keys,the_audio.music_current	){
			key = ds_map_find_value(the_audio.music_keys,the_audio.music_current);
		}
	}

	var notes = ds_map_find_value(the_audio.music_key_notes,key),
		n = ds_list_size(notes), //SHOULD always be 8, but...
		nid = argument1,
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
	if note>12{
		note += 1;	
	}
	var pitch = 2+(4*((note+12) mod 25));

	//////////////////////DEBUG !!!!!!!!!!!!!!!!!
	if the_audio.audio_debug_on{
	var val = "note",
		name = argument0,
		attr = "pitch";
	        var param = ds_map_find_value(global.audio_params,val);
	        //show_message("found param "+val);
	        if ds_map_exists(param,name){
	            //show_message("found data for "+container_name(con)+" in "+val);
	            var pcon = ds_map_find_value(param,name);
	            if ds_map_exists(pcon,attr){
	                var state = pitch;
						//audio_param_state(val);
	                var perc = curve_eval(ds_map_find_value(pcon,attr), state);
					var c = 0, cs = 1, db = 1, d = 2, ds = 3, eb = 3, e = 4, f = 5, fs = 6, gb = 6, g = 7, gs = 8, ab = 8, a = 9, as = 10, bb = 10, b = 11;
					var notes = "C",
						nnote = note;
					while(nnote<0){
						nnote += 12;	
					}
					nnote = (nnote mod 12);
					if nnote==cs{notes = "Db";}
					if nnote==d{notes = "D";}
					if nnote==eb{notes = "Eb";}
					if nnote==e{notes = "E";}
					if nnote==f{notes = "F";}
					if nnote==gb{notes = "Gb";}
					if nnote==ab{notes = "Ab";}
					if nnote==g{notes = "G";}
					if nnote==a{notes = "A";}
					if nnote==bb{notes = "Bb";}
					if nnote==b{notes = "B";}
					with(instance_create_pooled(x,y,0,objAudiodebugnote)){
						my_text = string(notes)+"\n(+"+string(note)+", "+(string(perc))+"%)";
						show_debug_message(my_text);
					}
				
	            }else{
	                //return 0;
	            } 
	        }else{
	           // return 0;
	        }
	}
	/////////////////////////////////////////////

	audio_param_set("note",pitch);

	var sobj = container_play(argument0);
	sobj.live_update = false;
	return sobj;

/* end container_play_note */
}
