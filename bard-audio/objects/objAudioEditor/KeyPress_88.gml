if keyboard_check(vk_control) and audio_loaded{
if audio_data_version<audio_data_maxversion
    and file_Exists("working\\backups\\audio\\audio_data_"+string(audio_data_version+1)){
    audio_data_version += 1;
    if file_Exists("working\\backups\\audio\\audioEditor_"+string(audio_data_version)){
        loaded_search = false;
        var n = ds_list_size(container_root_list());
        for(var i=0;i<n;i+=1){
            var con = ds_list_find_value(container_root_list(),i);
            if is_string(con){
                if ds_list_find_index(locked_containers,container_name(real(con)))==-1{
                    ds_list_delete(container_root_list(),i);
                    i -= 1;
                    n -= 1;
                }
            }
        }
    }
    
    load_audioedit(audio_data_version);
    show_message("version "+string(audio_data_version));
}
}


