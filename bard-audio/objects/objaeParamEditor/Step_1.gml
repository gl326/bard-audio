if !setup{
xf = newHighlightable(objTextfield,l+text_w,b-24-8,lerp(l,r,1/3)-8,b-8);
xf.param = "x"; xf.draggable=true;

yf = newHighlightable(objTextfield,lerp(l,r,1/3)+text_w,b-24-8,lerp(l,r,2/3)-8,b-8);
yf.param = "y"; yf.draggable=true;

pf = newHighlightable(objTextfield,lerp(l,r,2/3)+text_w,b-24-8,r-8,b-8);
pf.param = "p"; pf.draggable=true;

list_Add(children,xf,yf,pf);

container = objAudioEditor.editing;

if curves!=-1{
var k = ds_map_find_first(curves);
if k=="blend" and k!=ds_map_find_last(curves)
    {
    k = ds_map_find_next(curves,k);
    }
if k!="blend"{
curve = ds_map_find_value(curves,k);
points = ds_map_find_value(curve,"points");
attribute = k;

var k = ds_map_find_first(curves),cn = ds_map_size(curves);
    for(var j=0;j<cn;j+=1){
        if k=="blend"{
            if ds_map_exists(container,"blend_map"){
                blend = ds_map_find_value(container,"blend_map");
            }
        }else{
        var cur = ds_map_find_value(curves,k);
        ds_list_add(curve_list,k);
        k = ds_map_find_next(curves,k);
        }
    }
ds_list_copy(curve_ind,curve_list);
}else{
    curves = -1;
    if ds_map_exists(container,"blend_map"){
                blend = ds_map_find_value(container,"blend_map");
            }
}
}
}

event_inherited();

