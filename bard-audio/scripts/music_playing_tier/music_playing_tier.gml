// returns the 'tier' of the actively playing music
// or -1 if no music is active at all
function music_playing_tier(){
	return global.music_player.get_playing_tier();
}