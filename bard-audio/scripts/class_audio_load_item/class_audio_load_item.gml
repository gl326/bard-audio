// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function class_audio_load_item(_item="",_from=-1) constructor{
	item = _item;
	from = _from;
	id = -1;
	buffer = -1;
}

function bard_audio_load_queue_add(item,from){
	array_push(global.audio_load_queue,new class_audio_load_item(
		item,from
	));
	
	bard_audio_load_queue_update();
}

function bard_audio_load_queue_update(){
	if array_length(global.audio_load_queue){ //something to load!
		if is_undefined(global.audio_loading){ //nothing loading
			global.audio_loading = global.audio_load_queue[0];
			array_delete(global.audio_load_queue,0,1);
			
			if !is_struct(global.audio_loading) or instanceof(global.audio_loading)!="class_audio_load_item"{
				//...error?!
				global.audio_loading = undefined;
				return false;
			}
			
			if is_string(global.audio_loading.item){
				global.audio_loading.buffer = buffer_create(1, buffer_grow, 1)
				global.audio_loading.id = buffer_load_async(global.audio_loading.buffer,global.audio_loading.item,0,-1);	
			}else{
				if global.audio_loading.item>0{
					if !audio_group_is_loaded(global.audio_loading.item){
						audio_group_load(global.audio_loading.item);
					}else{
						bard_audio_load_queue_end();
					}
				}else{
					if audio_group_is_loaded(global.audio_loading.item){
						audio_group_unload(global.audio_loading.item);
					}else{
						bard_audio_load_queue_end();
					}
				}
			}
		}
	}
}

function bard_audio_isloading(){
	return array_length(global.audio_load_queue)+(!is_undefined(global.audio_loading));	
}

function audio_group_needs_load(groupID){
	if groupID>0 
	and !audio_group_is_loaded(groupID)
	and !audio_group_load_queued(groupID){
		return true;	
	}else{
		return false;	
	}
}

function audio_group_load_queued(groupID){
	var _i = 0;
	repeat(array_length(global.audio_load_queue)){
		if is_real(global.audio_load_queue[_i].item)
		and global.audio_load_queue[_i].item==groupID{
			return true;	
		}
	}
	
	return false;
}

function bard_audio_load_queue_end(){
	global.audio_loading = undefined;
	bard_audio_load_queue_update();
}

