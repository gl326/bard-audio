// recursively unload all external assets that are children of the named container
function container_unload(container){
	var player = container_getdata(container);
	if !is_undefined(player){
		return player.unload();
	}
}