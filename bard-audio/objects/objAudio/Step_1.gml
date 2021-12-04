/// @description beat time and delta time step
var delta_current_time = (current_time-current_time_p);



if !audio_in_editor{
    beat_time += delta_current_time;
    measure_time += delta_current_time*(1/beat_count);
	global.beat_ms_passed += delta_current_time/beatMs();
	var num_max = 999999998;
	if global.beat_ms_passed>num_max{global.beat_ms_passed -= num_max;}
    
    if !container_has_beat{
       beat_event = false;
		measure_event = false;
		doublebeat_event = false;
        if beat_time>=beatMs()/2 and !doublebeated{
            doublebeated = true;
            doublebeat_event = true;
        }
    }
    
	if !container_has_beat{
	    if beat_time>=beatMs(){
	        //if !container_has_beat{
	            beat_event = true;
            
           
	            //show_debug_message("beat updated from objgame! t:"+string(current_time/500));
			
	            doublebeated = false;
	            doublebeat_event = true;
	            //}else{
	            //    while(measure_time>=beatMs()*4){
	            //        measure_time -= beatMs()*4;
	             //   }
	           // }
		
			while(beat_time>=beatMs()){
				beat_time -= beatMs();
				beat += 1;
				measure_event = ((beat mod beat_count)==0);
	            if measure_event{
	                measure += 1;
	                measure_time -= beatMs()*4;
	                }
			}
	    }else{
	        beat_event = false;
	    }
		
		beat_prog = beat+(beat_time/beatMs());
	}
    
}

current_time_p = current_time;

