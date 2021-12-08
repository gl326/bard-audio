// definitions for music keys
// a music key is an array of 8 notes, starting from the lowest and up to the highest
// typically the last note is the same as the first note.
// in theory this could have definitions for every muscal key ever invented
// but
// no thanks
// these are the ones we used in chicory
// add your own if you want to use em
// in wandersong we also did some weird stuff with custom keys

function bard_audio_system_music_keys(){
	music_key_define("cmaj",
		music_note.c,
		music_note.d,
		music_note.e,
		music_note.f,
		music_note.g,
		music_note.a,
		music_note.b,
		music_note.c);
	music_key_define("amin",
		music_note.a,
		music_note.b,
		music_note.c,
		music_note.d,
		music_note.e,
		music_note.f,
		music_note.g,
		music_note.a);
	music_key_define("ebmaj",
		music_note.eb,
		music_note.f,
		music_note.g,
		music_note.ab,
		music_note.bb,
		music_note.c,
		music_note.g,
		music_note.eb);
	music_key_define("ebmin",
		music_note.eb,
		music_note.f,
		music_note.gb,
		music_note.ab,
		music_note.bb,
		music_note.b,
		music_note.db,
		music_note.eb);
	music_key_define("bmaj",
		music_note.b,
		music_note.cs,
		music_note.ds,
		music_note.e,
		music_note.fs,
		music_note.gs,
		music_note.as,
		music_note.b);
	music_key_define("gmin",
		music_note.g,
		music_note.a,
		music_note.bb,
		music_note.c,
		music_note.d,
		music_note.eb,
		music_note.f,
		music_note.g);
	music_key_define("gmaj",
		music_note.g,
		music_note.a,
		music_note.b,
		music_note.c,
		music_note.d,
		music_note.e,
		music_note.fs,
		music_note.g);
	music_key_define("bbmin",
		music_note.bb,
		music_note.c,
		music_note.db,
		music_note.eb,
		music_note.f,
		music_note.gb,
		music_note.ab,
		music_note.bb);
	music_key_define("cmin",
		music_note.c,
		music_note.d,
		music_note.eb,
		music_note.f,
		music_note.g,
		music_note.ab,
		music_note.bb,
		music_note.c);
}

function music_key_define(name){
		var l = [],
			max_note = -1;
		//add notes, and pitching them up octave(s) as necessary to create a rising continuitiy
		for(var i=1;i<argument_count;i+=1){
			var note = argument[i];
			while(note<max_note){
				note += 12;	
			}
			max_note = note;
			array_push(l,note);
		}
		
		//if the highest note is too high, lower the whole set of notes by some number of octaves to put them into a normalized range
		if max_note>12{
			var octs = floor(max_note/12);
			if octs>0{
				for(var i=1;i<argument_count;i+=1){
					l[i-1] -= (octs*12);
				}	
			}
		}
	
		ds_map_add(global.music_keys,name,l);
		if global.music_key==""{
			set_music_key(name); //set default key to whichever was defined first	
		}
}

enum music_note{
	c  = 0,
	cs = 1,
	db = 1,
	d  = 2,
	ds = 3,
	eb = 3,
	e  = 4,
	f  = 5,
	fs = 6,
	gb = 6,
	g  = 7,
	gs = 8,
	ab = 8,
	a  = 9,
	as = 10,
	bb = 10,
	b  = 11
}