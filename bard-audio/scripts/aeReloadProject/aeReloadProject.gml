/// @description aeReloadProject()
function aeReloadProject() {
	//if global.STUDIO2{
	    if file_Exists("audioData_project2"){
	        file_delete("audioData_project2");
	    }
	    audio_stop_all();
	    room_restart();
	//}



}
