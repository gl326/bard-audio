function container_update_volume() {
	if volume!=volume_p{
	    volume_p = volume;
	    var n = ds_list_size(playing);
	    for(var i=0;i<n;i+=1){
	        var s = ds_list_find_value(playing,i);
	        var snd = ds_map_find_value(s,"aud");
	        if ds_list_find_index(fadeout_sounds,snd)==-1{ //not fading out already
	            var file = ds_map_find_value(s,"file");
	            if ds_map_Find_value(s,"sync"){snd = file;}
	            var file_vol = (ds_map_Find_value(global.audio_asset_vol,file)),
	                bus_vol = ds_map_find_value(s,"bus_vol");
	            if audio_in_editor{file_vol = (ds_map_Find_value(global.audio_asset_vol,audio_get_name(file)))/100;}
	            ds_map_replace(s,"current_vol",(ds_map_Find_value(s,"vol")+1)*(file_vol+1)*(bus_vol+1));
	            audio_sound_gain(snd,lerp(0,clamp(ds_map_find_value(s,"current_vol"),0,1),QuadInOut(volume)*(1+ds_map_Find_value(s,"blend"))),0);
	        }
	    }
	}


}
