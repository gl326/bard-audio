/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if variable_instance_exists(id,"audio_emitter") and is_array(audio_emitter){
	var i=0;
		repeat(audio_emitter_n){
			audio_emitter_Free(audio_emitter[i]);
			i ++;
		}
	
	audio_emitter = -1;
	audio_emitter_size = -1;
	audio_emitter_n = 0;
	
	if is_struct(audio_emitter_effect_bus){
		audio_emitter_effect_bus.destroy();
		audio_emitter_effect_bus = undefined;
	}
}
