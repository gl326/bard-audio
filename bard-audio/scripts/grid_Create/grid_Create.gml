/// @description grid_Create(item 0, item 1, etc)
/// @param item 0
/// @param  item 1
/// @param  etc
function grid_Create() {
	var grid = ds_grid_create(argument_count,1);
	for(var i=0;i<argument_count;i+=1){
	    ds_grid_set(grid,i,0,argument[i]);
	}
        
	return grid;



}
