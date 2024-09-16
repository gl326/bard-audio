// macros are moved to here now as of 2022/12/12
// this should hopefully simplify version control for folks who have custom macro settings

#macro TEMP_DISABLE_GM_AUDIO_BUSSES false 
/*temp gm audio bus disable to stop crashing */

#macro AUDIO_USES_Z false 
/*if TRUE, then we will assume every spatial object has an internal variable called "z," the same as every game maker object 
has variables called "x" and "y." if you arent using a z variable then leave this off.
*/

#macro AUDIO_EDITOR_CAN_LOAD_DATA true
/* this should be set to false or debug_mode when making any public build releases. 
when true, this allows the game to look for project files & audio editor data on the user's file system. 
this is important because, when you query the user's file system for project data stuff, it gives users a potential avenue of attack to edit the game or do weird stuff
i prefer to leave this as debug_mode at all times for safety, and only use the audio editor in debug mode.
*/

#macro AUDIO_EDITOR_ROOM rmAudioEditor 
/*The GameMaker room used as the audio editor. it can be named anything, just make sure its a room that contains objAudioEditor.
*/

#macro EDITOR_PLAY_ROOM rmAudioDemo
/* When you hit CTRL+ENTER in the editor, it will go to this room. make it a room that could be a reasonable entrypoint to begin
gameplay! that way you can edit sounds, test them in-game, and then go back to adjust.
*/

#macro ROOT_SOUND_FOLDER "Sounds" 
/*root folder for all audio *inside the game maker project* */

#macro EXTERN_SOUND_FOLDER "audio/" 
/* folder for any external audio files, should be located in your project datafiles
*DO include the final slash* */

#macro BARD_AUDIO_DATA_FILE "audio_data.json"

#macro DISABLE_SYNCGROUPS true 
/* game maker has a "sync group" feature but it had some weird issues on some platforms right when we were trying to ship wandersong so we rerouted all the logic to avoid using them
	this might be a decision we could go back on but in general the fewer different features we're relying on, the better. even at their best sync groups have a lot of weird/unpredictable/unique behavior that 
	forces you to treat them different from other types of playing sounds.*/
	
#macro AUDIO_EDITOR_AUTO_SAVE true 
/*when 'true' it auto-saves. could be very slow in a giant project so leaving the option to disable this later*/

#macro AUDIO_ENABLE true
/* when 'false,' no audio is loaded or played through the system ever. might be useful for saving processing or load time etc. */

#macro MUSIC_DEFAULT_FADEOUT 4
/*when using the music_* functions to change from one trakc ot another, this is the default fadeout length before starting the next song */

#macro MUSIC_DEFAULT_GAP 0
/*when using the music_* functions to change from one track to another, this is the default gap of silence starting the next song (this time always follows the previous song fading out) */

#macro AUDIO_EDITOR_KEY_SHORTCUT [vk_control,vk_enter]

//////////default values for spatial audio//////////
audio_listener_orientation(0,0,1,0,-1,0);
audio_falloff_set_model(audio_falloff_linear_distance); //_clamped?

global.default_sound_size = 800;// //if sounds are within this distance of the listener, theyre full volume
global.default_sound_atten = 2500;// //at this distance, sounds are inaudible
global.listener_distance = 1250;//50 //how far the listener is from the screen
global.max_listener_distance = 1500; //farthest the listener can be from the screen - the distance is alered based on the view scale

////////// if you want to add music keys, add them in *bard_audio_system_music_keys* //////////