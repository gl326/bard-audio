if !setup{

var q = 0,act="1";
for(var i=0;i<columns;i+=1){
    for(var j=0;j<rows;j+=1){
        var gr = ds_list_find_value(audio_groups,q);
        if string_pos("act",gr)>0{
            var a = string_char_at(gr,4);
            if act!=a{
                act = a;
                if j>0{break;}
            }
        }
        var but = newHighlightable(objaeButton,
                l+butt_g+(i*(butt_g+butt_w)),
                t+24+butt_g+(j*(butt_g+butt_h)),
                l+butt_g+butt_w+(i*(butt_g+butt_w)),
                t+24+butt_g+butt_h+(j*(butt_g+butt_h)));
        but.script = audio_grouplist_load;//aeAudioLoadPanel;
        but.args[0] = gr;
        but.name = gr;
        ds_list_add(children,but);
        q+=1;
        if q>=ds_list_size(audio_groups){break;}
    }
    
    if q>=ds_list_size(audio_groups){break;}
}

/*xf = newHighlightable(objTextfield,l+text_w,b-24-8,lerp(l,r,1/3)-8,b-8);
xf.param = "x"; xf.draggable=true;

yf = newHighlightable(objTextfield,lerp(l,r,1/3)+text_w,b-24-8,lerp(l,r,2/3)-8,b-8);
yf.param = "y"; yf.draggable=true;

pf = newHighlightable(objTextfield,lerp(l,r,2/3)+text_w,b-24-8,r-8,b-8);
pf.param = "p"; pf.draggable=true;

list_Add(children,xf,yf,pf);*/
}
event_inherited();

/* */
/*  */
