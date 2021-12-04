function event_type_name(argument0) {
	switch(argument0){
	    case ev_create: return "create";
	    case ev_step: return "step";
	    case ev_other: return "(other.id)";
		case ev_destroy: return "destroy";
		case ev_alarm: return "alarm";
		case ev_draw: return "draw";
	    default: return string(argument0);
	}



}
