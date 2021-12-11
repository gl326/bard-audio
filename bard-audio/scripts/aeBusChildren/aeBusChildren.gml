/// @description aeBusChildren()
function aeBusChildren(snd=objAudioEditor.editing, bus = container_bus(objAudioEditor.editing)) {
	with(objAudioEditor){
	if is_string(snd){
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
