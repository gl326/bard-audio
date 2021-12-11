//save_audioedit();
aeSaveEditor();

//containersDSmark(containers); //turns into jsonified with nested DSes 
//not necessary, since we want global.audio_containers to have existing containers always
//ds_list_destroy(containers);

//ds_list_destroy(param_search);
//ds_list_destroy(params);

//ds_list_destroy(busses);
//ds_list_destroy(bus_search);
//ds_list_destroy(bus_expand);
//ds_map_destroy(bushierarchy);

//ds_list_destroy(container_search);
//ds_list_destroy(locked_containers);
//ds_list_destroy(container_expand);
ds_list_destroy(editing_history);

ds_list_destroy(container_buttons);
ds_list_destroy(choice_buttons);
ds_list_destroy(loop_buttons);
ds_list_destroy(multi_buttons);
ds_list_destroy(asset_buttons);

for(var i=0;i<ds_list_size(headers);i+=1){
    ds_map_destroy(ds_list_find_value(headers,i));
}
ds_list_destroy(headers);

//if project_struct!=-1{
//    ds_map_destroy(project_struct);
//}

