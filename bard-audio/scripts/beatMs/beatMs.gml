/// @description beatMs()
function beatMs() {

	return (60*1000)/max(.01,abs(the_audio.music_bpm)); //number of ms per beat



}
