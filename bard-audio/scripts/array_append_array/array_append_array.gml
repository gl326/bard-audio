/// @param source
/// @param destination

function array_append_array(_source, _destination)
{
    if (array_length(_source) <= 0) return undefined;
    var _old_length = array_length(_destination);
    array_resize(_destination, _old_length + array_length(_source));
    array_copy(_destination, _old_length, _source, 0, array_length(_source));
}