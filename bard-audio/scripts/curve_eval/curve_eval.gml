/// @description curve_eval(curve map, input)
/// @param curve map
/// @param  input
function curve_eval(argument0, argument1) {
	var curve=argument0, state = argument1;

	                var plist = ds_map_find_value(curve,"points");
	                var mmin = -1,
	                    mmax = -1,
	                    n = ds_list_size(plist),
	                    p1,
	                    p2,
	                    x1=-1,
	                    x2=0;
	                switch(n){
	                    case 1: return ds_map_find_value(ds_list_find_value(plist,0),"y");
	                    case 0: return 0;
	                    default:
	                        if state<=.5{
	                            for(var i=0;i<n;i+=1){
	                                var p = ds_list_find_value(plist,i);
	                                var xx = ds_map_find_value(p,"x");
	                                if xx<state{mmin = i; p1=p; x1=xx;}
	                                else{
										if xx==state{return ds_map_find_value(p,"y");}
	                                //if xx>state and mmax==-1
	                                    mmax = i; p2=p; x2=xx; break;
	                                }
	                            }
	                        }else{
	                            for(var i=n-1;i>=0;i-=1){
	                                var p = ds_list_find_value(plist,i);
	                                var xx = ds_map_find_value(p,"x");
	                                if xx>state{
	                                    mmax = i; p2=p; x2=xx;
	                                }else{
										if xx==state{return ds_map_find_value(p,"y");}
	                                    mmin = i; p1=p; x1=xx; break;
	                                }
	                            }
	                        }
	                        if mmax==mmin or x2==x1{
	                            return ds_map_find_value(ds_list_find_value(plist,max(0,mmin)),"y");
	                        }else{
	                            if mmax==-1{return ds_map_find_value(p1,"y");}
	                            if mmin==-1{return ds_map_find_value(p2,"y");}
	                            return lerp(
	                                ds_map_find_value(p1,"y"),ds_map_find_value(p2,"y"),
	                                (state-x1)/(x2-x1)
	                            );
	                        }
	                }



}
