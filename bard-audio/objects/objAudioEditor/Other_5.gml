//stop all sounds and set everything to default as if the game just started/booted

bard_audio_clear(true);
bus_reset_all();
audio_param_reset_all();

event_user(14);