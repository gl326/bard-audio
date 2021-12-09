///@param name
function container_get_time(_container) {
	var _player = container_player(_container);
	if is_undefined(_player){return 0;}
	return _player.get_time();
}
