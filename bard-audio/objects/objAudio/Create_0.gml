/// @description PUT THIS IN THE FIRST ROOM OF YOUR GAME. IT LIVES FOREVER

//put this in c:/users/yourname/appdata/local/yourProjectName (auto-generated folder by game maker)
//the contents of the .txt file should be a path to the folder containing your game make project, ending in a slash, like this:
// C:/Users/banov/Wanderrepo/wandersong/
//the audio editor uses this path to look for audio files/folders in your project and create data containers for them
the_audio = id;

global.audio_param_copy_map = ds_map_create();

//probably don't touch these
audio_listener_orientation(0,0,1,0,-1,0);
audio_falloff_set_model(audio_falloff_linear_distance); //_clamped?

//default 3D size for sounds (these were the values in wandersong based on the camera width/height, which was 1920x1080)
default_view_width = 1920; //default width of the view, uses this to track when the camera zooms in or out
global.default_sound_size = 1400;//1000; //if sounds are within this distance of the listener, they're full volume
global.default_sound_atten = 2850;//2125; //at this distance, sounds are inaudible
listener_distance = 1250;//50 //how far the listener is from the screen
global.max_listener_distance = 1500; //farthest the listener can zoom out based on camera size

global.DISABLE_SYNCGROUPS = true; //game maker has a feature called "sync groups" which let multiple audio tracks play in perfect sync
	//unfortunately it's not well supported and just before launch we hit tons of issues with them on various consoles
	//so i rewrote the logic to mimic them without actually using the feature, and it became more stable
	//feel free to set this to false and use the sync groups instead. when they work they're great.

//////audio groups, to augment game maker's built-in audio group loading
global.audio_groups = ds_map_create();
/* example audio group (wandersong had like 30-40 of these)
ds_map_add(global.audio_groups,
	"intro", //this is the name of the group
list_Create(
    ag_intro,ag_bardsword, //these are game maker audio groups
    foley_dream,ag_angel, //these are game maker audio groups
));*/
audio_loaded = "";

music_current = -1; //current music playing

//current "scene" music (if anything (other.id) than -4, it overrides the "current music.")
//so for example, you could enter a cutscene and set music_scene to that character's theme, then set it to -4 when the scene ends.
//the music playing will naturally transition to that character theme during the cutscene,
//then back to whatever is the default for that area afterward.
music_scene = -4; 
//d3d_start();


global.reload_audio = false; //if loading the audio editor and found some new files, this flips true exactly once so it reloads from the project exactly once

auto_fade_time_default = 4;
auto_fade_time = auto_fade_time_default; //2 for wandersong //how long does it take for music to fade out naturally when changing between tracks?

global.audio_emitters = ds_map_create(); //for tracking emitters


audio_debug_on = false;
audio_debug_setting = 0;

current_time_p = current_time;

manual_stop = false;


//bunch of internal stuff for tracking state and fades
music_player = audio_emitter_Create();
music_scene_p = -4;
music_volume = 0;
music_cur_volume = 0;
music_playing = -1;
music_obj = noone;
music_p = -1;
fading_out = true;

music_transition = 0; //0 = normal bgm, 
//1 = msuic_transition goes to 100 for "ambient" version of track. eventually will go to 2 and fade out entirely. 
//2 = music fades to 0 but keeps going in bg
music_can_transition = 1; //does the current song have an ambient version? 
//if 0, then instead of going ambient it will go silent.
//if 2, then when it goes ambient it will NEVER go silent
//music_transitioning = false; //if we're in a transition state
music_transition_time = 0; //time spent in transition
music_transition_maxtime = 60; //after this much time, transition music goes quiet
music_transition_state = 0; //current transition state
music_bpm = 120;
music_start_delay = 0; //extra delay to the start of a lowkey song coming from a high-key one

music_temp_transition = 0;

music_key = "cmaj";


ambiance_player = audio_emitter_Create();
ambiance_p_player = -1;
ambiance_p_volume = 0;
ambiance_p_playing = -1;
ambiance_current = -1;
ambiance_volume = 0;
//ambiance_cur_volume = 0;
ambiance_playing = -1;
ambiance_p = -1;
amb_fading_out = false;
ambiance_obj = noone;
ambiance_p_obj = noone;

music_fade_save = 1;
music_fade_time = 0;
music_fade_to = "";
music_fade_start = 0;

beat_event = false;
doublebeat_event = false;
doublebeated = false;
container_has_beat = false;
beat = 0; //integer beat we're on
beat_time = 0; //ms since start of current beat
beat_prog = 0; //integer beat + fractional progress to next beat
measure = 0;
measure_time = 0;
measure_event = false;
beat_count = 4; //how many beats per measure?

///sound groups
global.audio_containers = ds_map_create(); //settings and contents of all containers
global.audio_params = ds_map_create(); //parameters and default values
global.audio_state = ds_map_create(); //current state of parameters, etc
global.audio_asset_vol = ds_map_create(); //volume settings for each sound asset
global.audio_busses = ds_map_create(); //audio busses
global.audio_asset_bus = ds_map_create(); //bus settings for each sound asset
global.audio_list_index = ds_map_create(); //for random containers
global.audio_bus_calculated = ds_map_create();

audio_loading = ds_list_create();
audio_loading_flag = ds_list_create();
unload_start = 0;
loading_audio = false;
preloading = false;
loading_fade = 0;
loading_prog = 0;
audio_room = false; //if a roomstart was delayed by audio loading

global.listener_x = 0;
global.listener_y = 0;
global.listener_z = 0;

debug_h = 0;

#region music
with(the_audio){
var c = 0, cs = 1, db = 1, d = 2, ds = 3, eb = 3, e = 4, f = 5, fs = 6, gb = 6, g = 7, gs = 8, ab = 8, a = 9, as = 10, bb = 10, b = 11;
	music_key_notes = ds_map_create();
	music_key_define("cmaj",c,d,e,f,g,a,b,c);
	music_key_define("amin",a,b,c,d,e,f,g,a);
	music_key_define("ebmaj",eb,f,g,ab,bb,c,d,eb);
	music_key_define("ebmin",eb,f,gb,ab,bb,b,db,eb);
	music_key_define("bmaj",b,cs,ds,e,fs,gs,as,b);
	music_key_define("gmin",g,a,bb,c,d,eb,f,g);
	music_key_define("gmaj",g,a,b,c,d,e,fs,g);
	music_key_define("bbmin",bb,c,db,eb,f,gb,ab); 
	music_key_define("cmin",c,d,eb,f,g,ab,bb,c);
	
	music_keys = map_Create(
		"music_sweep0","ebmaj",
		"music_sweep1","ebmaj",
		"music_sweep2","ebmaj",
		"music_sweep3","ebmaj",
		"music_sweep","ebmaj",
		"brush_get_music","ebmaj",
		"luncheon_theme","ebmaj",
		"luncheon_postgame_theme","ebmaj",
		"portraits_theme","ebmaj",
		"music_chicory_teacher","ebmaj",
		
		"luncheon_spooky_theme","ebmin",
		
		"music_title","bmaj",
		"music_title_postgame","bmaj",
		
		"woods_theme_blend","gmin",
		"music_mountain","gmin",
		"music_mountain_prologue","gmin",
		"music_buildup","gmin",
		
		"brekkie_music","gmaj",
		"credits_music","gmaj",
		
		"island_theme_intro","bbmin",
		"island_theme_1","bbmin",
		"foothills_theme","bbmin",
		
		"island_theme_2","cmin",
		"music_selfportrait","cmin",
		"music_grubdeep_full","cmin",
		"music_grubdeep","cmin",
		"canyon_theme","cmin",
		"canyon_tree_theme","cmin",
		"luncheon_spookiest_theme","cmin",
		"music_investigation_mystery","cmin",
		"music_investigation_confession","cmin",
		
		"music_drosera","amin",
		"boss6_music","amin",
		
		"music_feast","amin",
		"music_feast_creepy","amin",
	);
}
#endregion

event_user(10); //load and setup audio
