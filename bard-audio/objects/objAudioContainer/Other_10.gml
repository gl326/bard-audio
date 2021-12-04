//show_debug_message(string(id)+" user event 0");
/**/
playing = list_Create(); //currently playing sounds + attributes
parameters = list_Create();//map_Create(); //parameters our sounds are dependent on (watch them for updates)
parameters_update = ds_list_create();
parameters_updated = false;

unique_param_settings = ds_map_create();

index = 0;
firstplay = false;

delay_sounds = list_Create(); //souns that are waiting to play
delayout_sounds = list_Create(); //sounds that are waiting to stop?
fadeout_sounds = list_Create();

audio_busses = list_Create(); //busses that are relevant to me
bus_update = list_Create(); //busses that are updated each frame
deleted = false;

randomed = false;
auto_play = false;

group_delay = false;
group_loop = 0;

owner = noone;

simple_sound = true; //when true, each sound "instance" is just one audio file so we can update params faster

play_id = -1; //each time we are played, this increments so the sounds playing together have the same id
was_beat = false;
am_playing = false;

spec_snd = 0;
space_rand = false;

threed = false;
varyingbpm = false;

parent = noone; 

seed = -1;

bpm = 0;
start_time = 0;
beat_p = -1;
dbeat_p = -1;
beats = 0;
beat_time = 0;
beat_start = 0;
first_beat = true;
had_new_beat = false;

time_p = current_time;

pitch = 1;
dopitch = 1;

spot_size = 0;
spot_atten = 0;

debug_1 = 0;
debug_2 = 0;

unique_param = ds_list_create();

music = false;
sync = false;
group = -1;
group_playing = false;
group_track_pos = 0;

live_update = true; //when off, i dont check parameters after starting

fake_sync = false;

aemitter_size = 0;
aemitter_atten = 0;
aemitter_pan = 1;

volume = 1; //used for fade in/out during gameplay, etc
volume_p = 1;
fading_out = 0;


emitter = -1; //these are made and maintained by props, but this lets us know if we have one
name = "";
made_emitter = false;

setup = true;

if dopitch{
    pitch = 1+(container_attribute(container,"pitch")/100);
}

paused = false;
paused_time = current_time;

/* */
/*  */
