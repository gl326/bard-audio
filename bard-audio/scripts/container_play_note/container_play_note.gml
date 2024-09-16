///@param container
///@param noteId
function container_play_note(container, noteID) {
	var sobj = container_play(container); 
		container_player(container,true).live_update = false;
		container_pitch_note(container, noteID, sobj);
	return sobj;
}
