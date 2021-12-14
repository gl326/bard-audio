// recursively unload all external assets that are children of the named container
function container_is_loaded(container,recursive = true){
	var player = container_getdata(container);
	if !is_undefined(player){
		return player.is_loaded(recursive);
	}
}