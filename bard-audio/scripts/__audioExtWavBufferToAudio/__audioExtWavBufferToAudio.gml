function __audioExtWavBufferToAudio(_buff, _is3D = false) {
	var _header = 42;
	
	// Set Seek
	buffer_seek(_buff,buffer_seek_start,0);
	
	// Check RIFF header
	var _chunkID = buffer_peek(_buff, 0, buffer_u32)
	if (_chunkID != 0x46464952) {
		show_debug_message("Invalid chunkID. Is not RIFF!");
		return -1;
	}
	
	var _signature = buffer_peek(_buff,8,buffer_u32);	
	
	if (_signature == 0x45564157) { // WAVE 

		if ((buffer_peek(_buff, 12, buffer_u8) == 0x66) && (buffer_peek(_buff, 13, buffer_u8) == 0x6D) && (buffer_peek(_buff, 14, buffer_u8) == 0x74)  && (buffer_peek(_buff, 15, buffer_u8) == 0x20)) { // fmt
			var _channel;
			if (_is3D == false) {
				switch(buffer_peek(_buff,22,buffer_u16)) {
						case 1: _channel = audio_mono; break;    
						case 2: _channel = audio_stereo; break;
						default: _channel = -1; break;
					}
			} else {
				_channel = audio_3d;	
			}
				
			 var _rate = buffer_peek(_buff,24,buffer_u32);
			 var _bits_per_sample = buffer_peek(_buff,34,buffer_u16);
			 
			 // We're going to skip ahead and find data. As some wav files contain a LIST-INFO chunk.
			 var _i = 0;
			 while(buffer_peek(_buff, 36+_i, buffer_u32) != 0x61746164) {
					++_i; 
			 }
			 var _subchunksize = buffer_peek(_buff,40+_i,buffer_u32);
			
			switch(_bits_per_sample) {
				case 8: _bits_per_sample = buffer_u8; break;
				case 16: _bits_per_sample = buffer_s16; break;
				default: _bits_per_sample = undefined; break;
			}
			
			if (_bits_per_sample == undefined) {
				show_debug_message("Invalid bits per sample. It can only support signed 8 or 16 bit.");
				return -1;
			}
				
			var _soundID = audio_create_buffer_sound(_buff,_bits_per_sample,_rate,_header+_i, _subchunksize, _channel);
			return _soundID;
		} else {
			show_debug_message("fmt is incorrect!!");	
		}
	} else {
	    // Output error, and we return -1.
		show_debug_message("Invalid signature!");
		
		//
		if (debug_mode) {
			show_debug_message("Format not expected! Got" + string(chr(_signature)) + "!");
		}
	    return -1;
	}	
}