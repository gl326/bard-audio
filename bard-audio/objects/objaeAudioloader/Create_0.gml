event_inherited();

audio_groups = ds_list_create();

/*ds_map_add(global.audio_groups,"act2_spirit",list_Create(
    ag_act2_global,ag_act2_spirit,
    foley_plant,foley_dream
));*/

var k = ds_map_find_first(global.audio_groups), n = ds_map_size(global.audio_groups);
for(var i=0;i<n;i+=1){
    ds_list_add(audio_groups,k);
    k = ds_map_find_next(global.audio_groups,k);
}

ds_list_delete(audio_groups,ds_list_find_index(audio_groups,"intro"));
ds_list_sort(audio_groups,1);
ds_list_insert(audio_groups,0,"intro");

butt_h = 48;
butt_w = 128;
butt_g = 8;

butt_n = ceil(sqrt(ds_list_size(audio_groups)));
columns = 8;
rows = 4;
w = (columns*butt_w)+((columns+1)*butt_g);
h = 24+(rows*butt_h)+((rows+1)*butt_g);

x = room_width/2;
y = room_height/2;
l = x-(w/2);
r = x+(w/2);
t = y-(h/2);
b = y+(h/2);

/* */
/*  */
