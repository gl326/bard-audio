function class_map() constructor{
	//supply args to pre-populate the struct
	for(var i=0;i<argument_count;i+=2){
		Add(argument[i],argument[i+1]);	
	}

	static Add = function(key,value){
		variable_struct_set(self,key,value);
	}
	
	static AddM = function(){
		for(var i=0;i<argument_count;i+=2){
			Add(argument[i],argument[i+1]);	
		}
	}

	static Replace = function(key,value){
		variable_struct_set(self,key,value);
	}

	static Set = function(key,value){
		variable_struct_set(self,key,value);
	}
	
	static Append = function(key, value){
		return Set(key, Is(key) + value);	
	}

	static Get = function(key){
		return variable_struct_get(self,key);
	}

	static Delete = function(key){
		variable_struct_remove(self,key);
	}

	static Exists = function(key){
		return variable_struct_exists(self,key);
	}

	static Keys = function(){
		return variable_struct_get_names(self);	
	}

	static Size = function(){
		return variable_struct_names_count(self);
	}

	static Empty = function(){
		return (Size()==0);
	}

	static CopyFrom = function(source){
		Clear();
		var keys = source.Keys();
		for(var i=array_length(keys)-1;i>=0;i-=1){
			Add(keys[i],source.Get(keys[i]));	
		}
	}

	static CopyTo = function(dest){
		dest.CopyFrom(self);	
	}
	
	static CopyKeysFrom = function(source){
		for(var i = 1;i<argument_count;i+=1){
			Set(argument[i],source.Get(argument[i]));	
		}
	}
	
	static RandomKey = function(){
		var keys = Keys();
		return keys[floor(random(array_length(keys)-1))];
	}

	static Clear = function(){
		var keys = Keys();
		for(var i= array_length(keys)-1;i>=0;i-=1){
			Delete(keys[i]);	
		}
	}
	
	static Is = function(key){
		if Exists(key){
			return Get(key);
		}else{
			return 0;	
		}
	}
	
	static Duplicate = function(){
		return ElephantDuplicate(self,true);	
	}
	
	static Write = function(){
		return ElephantWrite(self);	
	}
	
	static ForEach = function(func){
		var keys = Keys(),
			keys_n = array_length(keys);
		for(var i=0;i<keys_n;i+=1){
			var val = Get(keys[i]), ret;
			switch(argument_count){
				case 1: ret = func(val); break;
				case 2: ret = func(val,argument[1]); break;
				case 3: ret = func(val,argument[1],argument[2]); break;
				case 4: ret = func(val,argument[1],argument[2],argument[3]); break;
				default: ret = func(val,argument[1],argument[2],argument[3],argument[4]); break;
			}
			if !is_undefined(ret){
				return ret;	
			}
		}
		
		return undefined;
	}
	
	static ForEachKey = function(func){
		var keys = Keys(),
			keys_n = array_length(keys);
		for(var i=0;i<keys_n;i+=1){
			var val = keys[i];
			switch(argument_count){
				case 1: func(val); break;
				case 2: func(val,argument[1]); break;
				case 3: func(val,argument[1],argument[2]); break;
				case 4: func(val,argument[1],argument[2],argument[3]); break;
				default: func(val,argument[1],argument[2],argument[3],argument[4]); break;
			}
		}
	}
	
	static FindKey = function(_content){
		var keys = Keys();
		var _i = 0;
		repeat(array_length(keys)){
			if self[$keys[_i]] == _content{
				return keys[_i];
			}
			_i ++;	
		}
		
		return undefined;
	}
}