/*debug info
if container_name(container)=="amb_demomenu"{
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(ftDebug); draw_set_color(c_black);
    draw_text(20,20,container_name(container));
    for(var i=0;i<ds_list_size(playing);i+=1){
        var s = ds_list_find_value(playing,i),
            aud = ds_map_find_value(s,"file");
        draw_text(20,40+(i*20),audio_get_name(aud)+": "+string(ds_map_find_value(s,"vol")));
    }
}*/

/* */
/*  */
