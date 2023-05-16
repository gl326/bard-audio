// recursively load all external assets that are children of the named container
function container_load(container){
	var player = container_getdata(container);
	if is_struct(player){
		return player.load();
	}
}