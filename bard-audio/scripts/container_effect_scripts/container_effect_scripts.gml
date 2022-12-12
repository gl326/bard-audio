// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function container_set_custom_effect(container,effect_struct,enabled=true){
	container_player(container,true).set_audio_effect(effect_struct,enabled);
}

function container_set_effect(container,effect_name,enabled=true){
	container_player(container,true).set_effect(effect_name,enabled);
}

function container_clear_effects(container){
	container_player(container,true).clear_effects();	
}

function container_effect_state(container,effect_name){
	return container_player(container,true).has_effect(effect_name);
}

function container_audio_effect_state(container,effect_struct){
	return container_player(container,true).has_audio_effect(effect_struct);
}