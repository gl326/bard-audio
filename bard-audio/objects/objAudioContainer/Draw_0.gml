if group!=-1 and debug_mode{
    var sg = group;
draw_set_color(c_white);
var real_secs = audio_sync_group_get_track_pos(sg);
 var secs = real_secs mod 60;
 var mins = string(real_secs div 60);
 if (secs > 9)
    {
    secs = string(secs);
    }
 else
    {
    secs = "0" + string(secs);
    }
 draw_text(32, 32, string_Hash_to_newline("Time = " + mins + ":" + secs));
 }

