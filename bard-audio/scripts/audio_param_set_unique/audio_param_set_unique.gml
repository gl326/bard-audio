/// @description audio_param_set(param name, new number)
/// @param param
/// @param  newVal
/// @param  soundName
/// @param  soundID
function audio_param_set_unique(param, newVal, _container, playID) {
	var player = container_player(_container);
	if !is_undefined(player){
		return player.param_set_unique(param, newVal, playID);	
	}
	return undefined;
	/*
	_container = container_getdata(_container);
	
	var newv = min(100,max(0,newVal));
	with(objAudioContainer){
	    if container==_container{
			var isnew = true;
			if ds_map_exists(unique_param_settings,playID){
				var imap = ds_map_find_value(unique_param_settings,playID);
				if ds_map_exists(imap,param){
					if ds_map_find_value(imap,param)==newv{
						isnew = false;
					}else{
						ds_map_replace(imap,param,newv);	
					}
				}else{
					ds_map_add(imap,param,newv);
				}
			}else{
				ds_map_add_map(unique_param_settings,playID,map_Create(param,newv));	
			}
			
			if isnew{
				if ds_list_find_index(unique_param,playID)==-1{
					ds_list_add(unique_param,playID);//map_Create("id",playID,"param",param,"val",newv));
					parameters_updated += 1;
				}
			}
		break;
		}
	}
	return noone;
	*/

}
