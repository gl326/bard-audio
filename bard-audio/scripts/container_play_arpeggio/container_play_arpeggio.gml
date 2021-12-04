///@param container
///@param note0to3
function container_play_arpeggio(argument0, argument1) {
	if argument1>0{
	container_play_note(argument0,choice(
										choose(0,2,4,7+0),
										choose(1,3,5,7+0),
										choose(7+1,4,6,7+0),
										choose(3,5,7+0,4),
										argument1 mod 4));
	}else{
		container_play_note(argument0,choose(-1,-3,-5,-7));
	}


}
