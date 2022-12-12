// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function bus_set_custom_effect(bus_name,effect_struct,enabled=true,recursive=true){
	bus_getdata(bus_name).set_audio_effect(effect_struct,enabled,recursive);
}

function bus_set_effect(bus_name,effect_name,enabled=true,recursive=true){
	bus_getdata(bus_name).set_effect(effect_name,enabled,recursive);
}

function bus_clear_effects(bus_name,recursive=true){
	bus_getdata(bus_name).clear_effects(recursive);	
}

function bus_effect_state(bus_name,effect_name){
	return bus_getdata(bus_name).has_effect(effect_name);
}

function bus_audio_effect_state(bus_name,effect_struct){
	return bus_getdata(bus_name).has_audio_effect(effect_struct);
}