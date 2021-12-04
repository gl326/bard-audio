/// @description audio_param_unique_get(sound, id, new number)
/// @param sound
/// @param  id
/// @param  new number
function audio_param_unique_get(argument0, argument1) {
	with(objAudioContainer){
	    if container==argument0{
	        if unique_param==-1{
	            unique_param = ds_map_create();
	        }
	        return ds_map_Find_value(unique_param,argument1);
	    }
	}
	return noone;
	//return ds_map_replace(globparam nameal.audio_state,argument0,min(100,max(0,argument1)));



}
