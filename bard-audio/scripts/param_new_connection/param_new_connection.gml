/// @description /param_new_connection(param id, container id, connected to)
/// @param param id
/// @param  container id
/// @param  connected to
function param_new_connection(param,container,variable) {
	var cdata = container_getdata(container);
	global.audio_params[?param].hook_add_container(cdata,variable);
	cdata.hook_add(param);
}

function param_new_effect_connection(param,effect,variable) {
	global.audio_params[?param].hook_add_effect(effect,variable);
	effect.hook_add(param);
}