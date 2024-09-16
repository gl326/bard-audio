/// @description audio emitter position update
event_inherited();

if audio_emitter!=-1{
	//you can write your own logic here.
	//I left everything as 0 so that it was compatible with anything, but the logic here was important wandersong
	//what this does is adjust the 3d audio location based on parameters
	//in wandersong, audio_emitter_pan would make certain objects sound closer to the center then they really were
		//this was used for larger sized sounds...
		//it felt right for them to be "sticky" to the camera  bit if that makes sense
	//the z position adjusted based on depth
		//in wandersong, you could change layers forward and back which would make stuff come closer or farther
    var ex = 0,//audio_emitter_pan*((global.xview+(global.wview/2))-x), 
        ey = 0,
        ez = 0;//(depth*lerp(1,5,sqr(min(1,abs(depth)/100))));
	if audio_emitter_pan>0{
		//ex = audio_emitter_pan*((camera_get_view_x(the_scenemanager.camera)+(camera_get_view_width(the_scenemanager.camera)/2))-x);
	}
	for(var i=0;i<audio_emitter_n;i+=1){
		audio_emitter_position(audio_emitter[i],x+ex,y+ey,(AUDIO_USES_Z?z:0)+ ez);
	}
}
