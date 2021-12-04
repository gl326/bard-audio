/// As ElephantWrite(), but returns a base64-encoded string. This function also compresses the buffer.
/// 
/// @return base64-encoded string
/// 
/// @param target  Data to serialize

function ElephantExportString(_target)
{
    var _buffer = ElephantWrite(_target);
    
    var _compressed = buffer_compress(_buffer, 0, buffer_get_size(_buffer));
    buffer_delete(_buffer);
    
    var _string = buffer_base64_encode(_compressed, 0, buffer_get_size(_compressed));
    buffer_delete(_compressed);
    
    return _string;
}