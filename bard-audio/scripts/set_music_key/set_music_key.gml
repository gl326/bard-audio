//set the current key for the bgm for playing pitched sounds.
//keys are set up and named in bard_audio_system_music_keys() -  add your own there!
function set_music_key(key_name){
	if ds_map_exists(global.music_keys,key_name){
		global.music_key = key_name;	
	}
}