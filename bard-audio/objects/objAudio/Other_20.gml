/// @description load and setup audio
load_audioedit();

    //make lists
    var n = ds_map_size(global.audio_busses),k=ds_map_find_first(global.audio_busses);
    for(var i=0;i<n;i+=1){
        var bb=ds_map_find_value(global.audio_busses,k),
            newl = ds_list_create();
        if ds_map_exists(bb,"children"){ //junk from the load?
            var del = ds_map_find_value(bb,"children");
            if ds_exists(del,ds_type_list){
                ds_list_destroy(ds_map_find_value(bb,"children"));
            }
            ds_map_delete(bb,"children");
        }
        ds_map_add_list(bb,"children",newl); //make the lists
        k = ds_map_find_next(global.audio_busses,k);
    }

     
    ///sort to lists
    k=ds_map_find_first(global.audio_busses)
    for(var i=0;i<n;i+=1){
        var bus = ds_map_find_value(global.audio_busses,k);
        if ds_exists(bus,ds_type_map){
        var par = ds_map_find_value(bus,"parent");
        //show_message(string(par));
        if is_string(par){
            ds_list_add(ds_map_find_value(ds_map_find_value(global.audio_busses,par),"children"),k);
        }
        }
        k = ds_map_find_next(global.audio_busses,k);
    }
    
ds_map_copy(global.audio_bus_gaind,global.audio_busses);
bus_recalculate("master");
bus_recalculate("ui_setting");

//set volume per asset
var n = ds_map_size(global.audio_asset_vol), k =ds_map_find_first(global.audio_asset_vol),
    nnew = ds_map_create();
for(var i=0;i<n;i+=1){
    var next_k = ds_map_find_next(global.audio_asset_vol,k);
    if is_string(k){
    audio_sound_gain(asset_get_index(k), 
        1
        +(ds_map_Find_value(global.audio_asset_vol,k)/100)
        //+(bus_gain(ds_map_Find_value(global.audio_asset_bus,k)))
        ,0);
    ds_map_add(nnew,asset_get_index(k),(ds_map_Find_value(global.audio_asset_vol,k)/100));
    }else{
        //ds_map_delete(global.audio_asset_vol,k)
        }
    k = next_k;
}

ds_map_destroy(global.audio_asset_vol);
global.audio_asset_vol = nnew;
//and then bus
/*
var n = ds_map_size(global.audio_asset_bus), k =ds_map_find_first(global.audio_asset_bus);
for(var i=0;i<n;i+=1){
    var next_k = ds_map_find_next(global.audio_asset_bus,k);
    if is_string(k){
    if ds_list_find_index(set,k)==-1{
    audio_sound_gain(asset_get_index(k), 
        1
        +(ds_map_Find_value(global.audio_asset_vol,k)/100)
        +(bus_gain(ds_map_Find_value(global.audio_asset_bus,k)))
        ,0);
    //show_message("set "+audio_get_name(k)+" to "+string(1+(ds_map_find_value(global.audio_asset_vol,k)/100)));
    }
    }else{ds_map_delete(global.audio_asset_vol,k)}
    k = next_k;
}
*/

/* */
/*  */
