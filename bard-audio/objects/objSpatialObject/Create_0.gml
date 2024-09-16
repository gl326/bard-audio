/// @description Setup spatial audio
event_inherited(); //so you can inherit some (other.id) generic properties from your project/engine if you need

audio_emitter = -1;
audio_emitter_size = -1;
audio_emitter_n = 0;
audio_emitter_pan = 0; //not used, but see step event for the original reference to this
audio_emitter_effect_bus = undefined;