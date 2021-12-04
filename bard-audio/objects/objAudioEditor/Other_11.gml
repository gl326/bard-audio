/// @description change palette
palette = !palette;

if palette{
    editor_colors = list_Create(
        make_color_rgb(255,0,129),
        make_color_rgb(255,208,24),
        make_color_rgb(76,216,237),
        make_color_rgb(255,91,16),
        make_color_rgb(239,132,255),
        make_color_rgb(255,166,24),
    );
    palette_light = true;
    
	color_bg = make_color_rgb(244,255,232 );
    color_fg = make_color_rgb(66,104,120);//make_color_rgb(232,191,66);
    color_fg2 = ds_list_find_value(editor_colors,0);//make_color_rgb(236,95,19);
    color_bg2 = make_color_rgb(193,252,218);//make_color_rgb(45,28,55);
    color_mg = ds_list_find_value(editor_colors,1);//make_color_rgb(15,183,161);
}else{
    editor_colors = list_Create(
        make_color_rgb(236,95,19),
        make_color_rgb(15,183,161),
        make_color_rgb(182,244,61),
        make_color_rgb(255,77,194),
        make_color_rgb(82,183,248),
        make_color_rgb(142,86,255)
    );
    palette_light = false;
    
    color_bg = make_color_rgb(59,38,66 );
    color_fg = make_color_rgb(232,191,66);
    color_fg2 = ds_list_find_value(editor_colors,0);//make_color_rgb(236,95,19);
    color_bg2 = make_color_rgb(45,28,55);
    color_mg = ds_list_find_value(editor_colors,1);//make_color_rgb(15,183,161);
}

