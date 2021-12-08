// returns the currently active music
// either a string name for a container,
// or 0 if it's a mandatory silence,
// or -1 if there's no active music whatsoever
function music_playing(){
	return global.music_player.get_playing();
}