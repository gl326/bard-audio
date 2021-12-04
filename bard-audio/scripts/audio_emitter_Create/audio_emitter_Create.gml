function audio_emitter_Create() {
	var em = audio_emitter_create();
	var sstr = object_get_name(object_index)+" "+string(id);
	ds_map_add(global.audio_emitters,em,sstr);
	
	audio_emitter_set_listener_mask(em, audio_get_listener_mask());
	return em;



}
