/// @description /param_new_connection(param id, container id, connected to)
/// @param param id
/// @param  container id
/// @param  connected to
function param_new_connection(param,container,variable) {
	global.audio_params[?param].hook_add(container,variable);
	container_getdata(container).hook_add(param);
}
