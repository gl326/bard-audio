function file_write_string(_filename, _string)
{
    var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _string);
    buffer_save(_buffer, _filename);
    buffer_delete(_buffer);
}