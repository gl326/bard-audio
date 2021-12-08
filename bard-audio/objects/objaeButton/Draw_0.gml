if lit{
    draw_set_color(objAudioEditor.color_mg);
    draw_roundrect(l,t+lerp(0,8,pressed),r,b,false);
    }

draw_set_color(objAudioEditor.color_fg);
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(lerp(l,r,.5),lerp(t,b-8,.5)+lerp(0,8,pressed),name);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_roundrect(l,t+lerp(0,8,pressed),r,b,true)
draw_rectangle(l,b-lerp(8,2,pressed),r,b,false)

