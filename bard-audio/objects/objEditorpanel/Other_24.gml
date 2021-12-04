for(var i=0;i<ds_list_size(children);i+=1){
    var c = ds_list_find_value(children,i);
    with(c){instance_destroy();}
}   

ds_list_destroy(children);
for(var i=0;i<ds_list_size(child_points);i+=1){
    ds_grid_destroy(ds_list_find_value(child_points,i));
}
ds_list_destroy(child_points);

