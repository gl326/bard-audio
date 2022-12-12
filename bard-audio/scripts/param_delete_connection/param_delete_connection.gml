/// @description /param_new_connection(param id, container id, connected to)
/// @param param id
/// @param  container id
/// @param  connected to
function param_delete_connection(param,container,variable) {
	global.audio_params[?param].hook_delete_container_var(container,variable);
	container_getdata(container).hook_delete(param);
}

function param_delete_effect_connection(param,effect,variable) {
	global.audio_params[?param].hook_delete_effect_var(effect,variable);
	effect.hook_delete(param);
}