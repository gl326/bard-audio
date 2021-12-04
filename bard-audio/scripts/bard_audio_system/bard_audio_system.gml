// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro audio_uses_z false
#macro audio_in_editor (room==rmAudioEditor)

global.audio_players = [];
global.audio_containers = ds_map_create(); //settings and contents of all containers
global.audio_params = ds_map_create(); //parameters, hooks and default values
//global.audio_state = ds_map_create(); //current state of parameters, etc
global.audio_asset_vol = ds_map_create(); //volume settings for each sound asset
global.audio_busses = ds_map_create(); //audio busses
global.audio_asset_bus = ds_map_create(); //bus settings for each sound asset
global.audio_list_index = ds_map_create(); //for random containers
global.audio_bus_calculated = ds_map_create();

function bard_audio_update(){
	var _i = 0;
	repeat(array_length(global.audio_players)){
		if global.audio_players[_i].update(){
			_i ++;
		}
	}
}