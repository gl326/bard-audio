// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function array_shuffle(array){
array_sort(array,function(){return choose(-1,1);});
}