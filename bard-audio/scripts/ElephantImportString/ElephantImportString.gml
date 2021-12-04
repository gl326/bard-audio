/// As ElephantRead(), but takes a string rather than a buffer as input.
/// 
/// @return  The data that was encoded
/// 
/// @param string  base64-encoded string, as created by ElephantExportString()

function ElephantImportString(_string)
{
    var _compressed = buffer_base64_decode(_string);
    var _buffer = buffer_decompress(_compressed);
    buffer_delete(_compressed);
    
    var _result = ElephantRead(_buffer);
    buffer_delete(_buffer);
    
    return _result;
}