/// @description gameaudio_volume(sound,volume)
/// @param sound
/// @param volume
function gameaudio_volume(argument0, argument1) {

	if is_real(argument0){
	    return audio_sound_gain(argument0,argument1,0);
	}else{
	    var obj = noone;
	    with(objAudioContainer){if container==argument0{obj = id; break;}}
	    if obj!=noone{
	        obj.volume = argument1;
	        return true;
	    }
	    return false;
	}



}
