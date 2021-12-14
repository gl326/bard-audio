/// @description aeBusChildren()
function aeBusChildren(snd=container_getdata(objAudioEditor.editing), bus = snd.bus) {
	with(objAudioEditor){
	if !is_undefined(snd){
	    var con = container_contents(snd);
	    for(var i=0;i<array_length(con);i+=1){
	        var c = con[i];
	        if is_string(c){
	            container_getdata(c).bus = bus;
	            aeBusChildren(c,bus);
	        }else{
				audio_asset_set_bus(c,bus);
	        }
	    }
	}
	}

/* end aeBusChildren */
}
