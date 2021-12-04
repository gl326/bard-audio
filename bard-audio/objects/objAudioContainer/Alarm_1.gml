/// @description UNUSED I think?? start fade out, set time to stop forever

var n = ds_list_size(playing);
                for(var i=0;i<n;i+=1){
                    var s = ds_list_find_value(playing,i);
                    audio_sound_gain(ds_map_find_value(s,"aud"),0,
                        ds_map_Find_value(container,"lpfade")*1000);
                    //audio_stop_sound(ds_map_find_value(s,"aud")); //they will delete on their own
                }
alarm[0] = ds_map_Find_value(container,"lpfade")*room_speed;

