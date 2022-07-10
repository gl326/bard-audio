function file_write_string(_filename, _string, _compressed = false)
{
    var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _string);
	
	if _compressed{
		var _oldbuffer = _buffer;
		_buffer = buffer_compress(_oldbuffer,0,buffer_get_size(_oldbuffer));
		buffer_delete(_oldbuffer);
	}
	
    buffer_save(_buffer, _filename);
    buffer_delete(_buffer);
}