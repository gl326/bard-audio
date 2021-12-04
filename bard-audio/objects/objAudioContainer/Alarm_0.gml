/// @description UNUSED stop sounds, for loop end delay

var n = ds_list_size(playing);
        for(var i=0;i<n;i+=1){
            var s = ds_list_find_value(playing,i);
            audio_stop_sound(ds_map_find_value(s,"aud")); //they will delete on their own
        }

