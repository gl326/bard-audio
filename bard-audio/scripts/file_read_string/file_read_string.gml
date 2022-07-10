function file_read_string(_filename,_compressed = false)
{
	if file_exists(_filename){
	    var _buffer = buffer_load(_filename);
		
		if _compressed{
			var _oldbuffer = _buffer;
			_buffer = buffer_decompress(_oldbuffer);
			buffer_delete(_oldbuffer);
		}
	
	    var str = buffer_read(_buffer,buffer_string);
		//?
	    buffer_delete(_buffer);
		return str;
	}else{
		return "";	
	}
}