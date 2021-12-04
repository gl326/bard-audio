// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function container_root_list(){
	var cid = container_id("Sounds");
	if cid==noone{
		cid = container_create("Sounds");	
	}
	return container_contents(cid);
}