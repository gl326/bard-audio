//pitch a sound to a noteID
//noteID is an integer number that maps to the currently set musical key.
//0 is the "root" note, 1 is the next one up, etc...
//so if the key is set to c major and you want to play note 0, that's a C.

//you can also supply fractional values and it will give you its best approximation of what that is
//using the nearest adjacent integer pitches

//it's set up this way so that one object can have code like "play a random note 0-8" and it will produce
//different results that are in-key with whatever the current music key is set to.

//you could do fancier stuff like defining "keys" that are just a single chord
//and then changing the current global "key" with every chord change in the song
//so stuff hooked into this logic will play very precisely with the BGM
//but man that's a lot of work?!
function container_pitch_note(container,noteID,playID=-1) {
	var player = container_player(container);
	if !is_undefined(player){
		var nid = noteID,
			perc = 0,
			fract = frac(nid);
		if fract==0{
			perc = container_note_to_percent(nid);
		}else{
			var perca = container_note_to_percent(floor(nid)),
				percb = container_note_to_percent(ceil(nid));
			perc = lerp(perca,percb,fract);
		}
		
		player.pitch_sounds(perc,playID);
	}
	
}

//////get data from music key defintions
function container_note_to_percent(noteID) {
		var key = global.music_key;
		/////get pitch integer
		var notes = ds_map_find_value(global.music_keys,key),
			n = array_length(notes), //SHOULD always be 8, but...
			nid = noteID,
			nadjust = 0;
		while(nid>=n){
			nid -= n-1;
			nadjust += 12;
		}
		while(nid<0){
			nid += n-1;
			nadjust -= 12;
		}
		var note = notes[nid]+nadjust;
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

//get a real actual math number to pitch the sound by 
//this assumes the input sound is a Cnote and gives you a percentage to reach other notes
//it is arranged to a whack ass range of numbers like this because........ reasons. accidents. mistakes
function container_pitch_to_percent(argument0) {
	switch(round(argument0)){
		case 2: return -50; 
		case 6: return -47.028246;
		case 10: return -43.878760;
		case 14: return -40.541987;
		case 18: return -37.006460;
		case 22: return -33.260712;
		case 26: return -29.289455;
		case 30: return -25.085044;
		case 34: return -20.632190;
		case 38: return -15.911784;
		case 42: return -10.912357;
		case 46: return -5.614800;
		case 50: return 0.000000;
		case 54: return 5.943508;
		case 58: return 12.242480;
		case 62: return 18.919849;
		case 66: return 25.990903;
		case 70: return 33.482399;
		case 74: return 41.417269;
		case 78: return 49.829912;
		case 82: return 58.735619;
		case 86: return 68.176432;
		case 90: return 78.175286;
		case 94: return 88.770400;
		case 98: return 100;
	}	
}