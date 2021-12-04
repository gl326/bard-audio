/// @description beatFrames()
function beatFrames() {
	var bpm = the_audio.music_bpm;
	if bpm==0{bpm = 120;}
	return (60*room_speed)/max(.01,abs(bpm)); //number of frames per beat



}
