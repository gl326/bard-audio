/// @description containerSounds(con,list,sound map,obj,idmap,option,sync,depth)
/// @param con
/// @param list
/// @param sound map
/// @param obj
/// @param idmap
/// @param option
/// @param sync
/// @param depth
function containerSounds() {
	var con=argument[0],list=argument[1],sound=argument[2],obj=argument[3],id_map=argument[4],option=false,deep = 0,sync = false;
	if argument_count>=6{option = argument[5];}
	if argument_count>=7{sync = argument[6];}
	if argument_count>=8{deep = argument[7];}

	global.mem_checkzone = 1;
	if deep<50{ //if we got this deep, there was probably an infinite loop or something
	var type = container_type(con);

	if sound==-1{
		sound = container_map_create();
	    ds_map_add(sound,"pitch",0);
	    ds_map_add(sound,"vol",0);
	    ds_map_add(sound,"playid",obj.play_id);
	    ds_list_add(list,sound);
	}

	var contents = container_contents(con),
	    n=ds_list_size(contents);
    
	//sync
	if !sync{
	    sync = !DISABLE_SYNCGROUPS and ds_map_Find_value(con,"sync");
	}
	if sync {
	    ds_map_Replace(sound,"sync",1);
	    obj.sync = true;
	}else{
	    obj.sync = false;
	}
  
	//gain
	//var current_vol = (ds_map_Find_value(s,"vol")+1)*(file_vol+1)*(bus_vol+1);
	var gain = container_attribute(con,"gain",obj);
	if gain!=0{
	    var vol = ds_map_find_value(sound,"vol");
	    ds_map_replace(sound,"vol",((vol+1)*((gain/100)+1))-1);
	}
	//random gain
	var vol_min = container_attribute(con,"volmin",obj),vol_max = container_attribute(con,"volmax",obj);
	if vol_min!=0 or vol_max!=0{
	    var vol = ds_map_find_value(sound,"vol");
	    //ds_map_replace(sound,"vol",vol+(random_range(vol_min,vol_max)/100));
	    ds_map_replace(sound,"vol",((vol+1)*((random_range(vol_min,vol_max)/100)+1))-1);
	}

	var specsnd = obj.spec_snd;
	//if specsnd>0 and !option{
	//    ds_map_replace(sound,"vol",-1);
	//}

	//bus id
	var bus_id = ds_map_find_value(con,"bus");
	ds_map_add(sound,"bus",bus_id);
	ds_map_add(sound,"bus_vol",0);

	//pitchf
	var pitch = container_attribute(con,"pitch",obj);
	if pitch!=0{
	    var oldpitch = ds_map_find_value(sound,"pitch");
	    ds_map_replace(sound,"pitch",oldpitch+(pitch/100));
	}




	//random pitch
	var pitch_min = container_attribute(con,"pitchmin",obj),
		pitch_max = container_attribute(con,"pitchmax",obj);
	if pitch_min!=0 or pitch_max!=0{
	    var pitch = ds_map_find_value(sound,"pitch");
	    ds_map_replace(sound,"pitch",pitch+(random_range(pitch_min,pitch_max)/100));
	}

	if ds_map_Find_value(con,"3d"){
	    ds_map_replace(sound,"3d",true);
		ds_map_replace(sound,"owner",obj.owner);
	}

	if type!=1 and specsnd==0 and ds_map_Find_value(con,"loop"){
	    ds_map_Replace(sound,"loop",true); //loop
	}
	if ds_map_exists(con,"lpfade"){
	    ds_map_Replace(sound,"fadeout",container_attribute(con,"lpfade",obj));
	}
	if ds_map_exists(con,"randstart"){
	    ds_map_Replace(sound,"randstart",container_attribute(con,"randstart",obj));
	}else{
		if ds_map_exists(con,"starttime"){
		    ds_map_Replace(sound,"starttime",container_attribute(con,"starttime",obj));
		}
	}

	if type!=1 and ds_map_exists(con,"lpfadein"){
	    ds_map_Replace(sound,"fadein",container_attribute(con,"lpfadein",obj));
	}

    
	var ret = -1;

	switch(type){
	case 2:
	/////////////multi container///////////////////
	    var newlist = ds_list_create();
	    for(var i=0;i<n;i+=1){
	        var c = ds_list_find_value(contents,i),newsound;
	        if i==0{
	            newsound = sound;
	            ret = c;
	            }
	        else{
				newsound = container_map_create();
	            ds_map_copy(newsound,sound);
	            ds_list_add(list,newsound);
	        }
        
	        ds_list_add(newlist,newsound);
	    }
    
	    var blend=ds_map_Find_value(con,"blend_map");
	    if blend>0{
	    var amt = container_attribute(con,"blend",obj);
	    for(var i=0;i<n;i+=1){
	        var newsound = ds_list_find_value(newlist,i);
	            //var nvol = ds_map_Find_value(newsound,"vol");
	            var ble = ds_list_find_value(blend,i),
	                bl = ds_map_find_value(ble,"left"),
	                br = ds_map_find_value(ble,"right"),
	                bcl = ds_map_find_value(ble,"cleft"),
	                bcr = ds_map_find_value(ble,"cright"),
	                adj = 1;
	            if amt<bl or amt>br{adj = 0;}
	            else{
	                if amt<bcl{if bcl>bl{adj = QuadInOut(lerp(1,0,(bcl-amt)/(bcl-bl)));}}
	                else{if amt>bcr and br>bcr{adj = QuadInOut(lerp(0,1,(br-amt)/(br-bcr)));}}
	            } 
	            if ds_map_exists(newsound,"blend"){
	                var obl = ds_map_find_value(newsound,"blend");
	                ds_map_replace(newsound,"blend",lerp(-1,obl,adj));
	            }else{
	                ds_map_add(newsound,"blend",lerp(-1,0,adj));
	            }
	            //var newv = lerp(-1,nvol,adj);
	            //ds_map_Replace(newsound,"vol",newv);
	            }
	    }
    
    
	    for(var i=1;i<n;i+=1){
	    var newsound = ds_list_find_value(newlist,i);
	    var c = ds_list_find_value(contents,i);
	    //show_message("playing "+string(c));
	    if is_string(c){
	                containerSounds(real(c),list,newsound,obj,id_map,option,sync,deep+1); //dig deeper on this one
	            }else{
	            if !is_equal(ret,c){
	                var idd = ds_map_Find_value(id_map,c),
	                    sid = string(c)+"_"+string(idd);
	                ds_map_Replace(newsound,"id",sid);
	                ds_map_add(id_map,sid,newsound);
	                ds_map_Replace(id_map,c,idd+1); //id
	                ds_map_replace(newsound,"file",c); //found audio, stop
	            }
	            }
	    }
	    ds_list_destroy(newlist);
	break;
	/////////////looping container//////////////////
	case 1: 
	    var cs = ds_list_size(contents),
	        looptail = container_attribute(con,"looptail");
		ds_map_Replace(sound,"delayout",container_attribute(con,"lpdelay",obj));
	    if !option{
	            var s1 = ds_list_find_value(contents,0), s2 = ds_list_find_value(contents,1 mod max(1,cs)),
	            t1 = is_string(s1), t2 = is_string(s2);
	        if cs>=2 and (t1!=t2 or s1!=s2) and !looptail{ //head
	            newsound = container_map_create();
	            ds_map_copy(newsound,sound);
	            ds_list_add(list,newsound);
            
	            if t1{
	                containerSounds(real(s1),list,newsound,obj,id_map,option,sync,deep+1); //dig deeper
	            }else{
	                var idd = ds_map_Find_value(id_map,s1),
	                sid = string(s1)+"_"+string(idd);
	                ds_map_Replace(newsound,"id",sid);
	                ds_map_add(id_map,sid,newsound);
	                ds_map_Replace(id_map,s1,idd+1); //id
	                ds_map_replace(newsound,"file",s1); //found audio, stop
	            }
            
	            ds_map_Replace(newsound,"loop",false); //head
	        }
        
	        if ds_map_exists(con,"lpfadein"){
	            ds_map_Replace(sound,"fadein",container_attribute(con,"lpfadein",obj));
	        }

	        ds_map_Replace(sound,"loop",true); //loop
	        if !looptail{ret = s2;}
	        else{ret = s1;}
	    }else{ //tail
	       if cs>=3 or looptail{
	            ret = ds_list_find_value(contents,min(2,cs-1));
	            ds_map_Replace(sound,"tail",1);
	       }
	    }
	break;

	/////////////choice container//////////////////
	default:
	var chosen = -1,ind=-1;
	if is_string(ds_map_Find_value(con,"choose")){
	    chosen = container_attribute(con,"choose");
	    ind = min(floor(ds_list_size(contents)*chosen/100),ds_list_size(contents)-1);
	}
	else{
	    var seq = ds_map_Find_value(con,"seq");
	    var first = !ds_map_exists(global.audio_list_index,con);
	    if !first{
	        ind = ds_map_find_value(global.audio_list_index,con);
	        if ind>=n{ind = 0;}
	        }
	    else{ind = 0;}
	    if !seq and ind==0{
	        var lp = ds_list_find_value(contents,n-1);
	        ds_list_shuffle(contents);
	        if !first and n>1 and lp==ds_list_find_value(contents,0){
	                ds_list_delete(contents,0);
	                ds_list_add(contents,lp);
	            }
	        }
	    //if !obj.randomed and !seq{ds_list_shuffle(contents); obj.randomed = true; obj.index = 0;}
	    //else{if obj.index>=n{obj.index = 0; if !seq{ds_list_shuffle(contents);}}}
    
	    if !first{ds_map_replace(global.audio_list_index,con,ind+1);}
	    else{ds_map_add(global.audio_list_index,con,ind+1);}
	}
	ds_map_Replace(sound,"index",ind); ds_map_Replace(sound,"container",con);
	ret = ds_list_find_value(contents,ind);
	//obj.index += 1;
	break;
	}

	if sync and ds_map_Find_value(sound,"loop"){obj.group_loop = true;}

	if is_string(ret) or ret!=-1{
	if type==1{
	        ds_map_Replace(sound,"playstart",current_time);
	        //ds_map_Replace(sound,"fadein",container_attribute(con,"lpfadein",obj));//ds_map_Find_value(con,"lpfadein"));
	        ds_map_Replace(sound,"delayin",container_attribute(con,"lpdelayin",obj));//ds_map_Find_value(con,"lpdelayin"));
	        //ds_map_Find_value(con,"lpfade"));
	        //ds_map_Find_value(con,"lpdelay"));
	    }
	if specsnd{
		ds_map_Replace(sound,"playstart",current_time);
		ds_map_Replace(sound,"delayin",random_range(container_attribute(con,"specmin",obj),container_attribute(con,"specmax",obj)));
	}
    
	if is_string(ret){
	    containerSounds(real(ret),list,sound,obj,id_map,option,sync,deep+1); //dig deeper
	}else{
	    var idd = ds_map_Find_value(id_map,ret),
	        sid = string(ret)+"_"+string(idd);
	    ds_map_Replace(sound,"id",sid);
	    ds_map_add(id_map,sid,sound);
	    ds_map_Replace(id_map,ret,idd+1); //id
	    ds_map_replace(sound,"file",ret); //found audio, stop
	}
	}
	}

	global.mem_checkzone = 0;



}
