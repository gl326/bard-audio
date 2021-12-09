// returns the number of milliseconds per beat, useful for scaling animations with current_time
function beatMS(bpm = undefined){
	if is_undefined(bpm){
		bpm = music_bpm();
	}
	if bpm<=0{
		bpm = 120;	
	}
	
	return 1000 * 60 / bpm;
	
	return 
}