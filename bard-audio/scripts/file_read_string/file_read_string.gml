function file_read_string(_filename)
{
	if file_exists(_filename){
	    var _buffer = buffer_load(_filename);
	    var str = buffer_read(_buffer,buffer_string);
		//?
	    buffer_delete(_buffer);
		return str;
	}else{
		return "";	
	}
}