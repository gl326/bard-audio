/// @description audio_param_set(param name, new number)
/// @param param name
/// @param  new number
function audio_param_set(param, newv) {
	var newv = min(100,max(0,newv)),
		paramData = global.audio_params[?param],
	    oldv = paramData.val;
	if newv!=oldv{
	    paramData.val = newv;
		
		var _i = 0;
		repeat(array_length(global.audio_players)){
			global.audio_players[_i].param_update(param);
			_i ++;
		}
	}



}
