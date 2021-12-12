/// @description finish setup after files are loaded
/*
    ////////swap names with ids        
        var n = ds_map_size(global.audio_containers),
            k = ds_map_find_first(global.audio_containers);
        for(var i=0;i<n;i+=1){
            var c=container_contents(ds_map_find_value(global.audio_containers,k));
			if k=="Sounds"{
				var test = true;	
			}
			if !is_undefined(c) and ds_exists(c,ds_type_list){
            var cn = ds_list_size(c);
            for(var j=0;j<cn;j+=1){
                var cc = ds_list_find_value(c,j);
                if is_string(cc){
                    var asset = asset_get_index(cc);
                    if asset!=-1{
                        ds_list_replace(c,j,asset);
                    }else{
                        if ds_map_exists(global.audio_containers,cc){
                            ds_list_replace(c,j,string(ds_map_find_value(global.audio_containers,cc)));
                        }else{
							if string_number(cc)!=cc{
	                            if debug_mode{show_message(cc+" doesnt exist, inside "+k+". deleting. WARNING: double check in version control!! something might have gone wrong");}
	                            ds_list_delete(c,j);
	                            j-=1;cn-=1;
							}else{
								if !ds_exists(real(cc),ds_type_map){
									if debug_mode{show_message(cc+" was found in "+k+" and looks like a map index but doesn't seem to exist.");}	
								}
							}
                        }
                    }
                }
            }
            k = ds_map_find_next(global.audio_containers,k);
			}else{
				var oldk = k;
				show_debug_message("audio container "+k+" doesnt exist...!");
				k = ds_map_find_next(global.audio_containers,k);
				ds_map_delete(global.audio_containers,oldk);
			}
        }

load_audioedit();
aeCountReferences(1);
*/


tab = 0; //0 = containers, 1 = params
alphabetical = 0;

var butt_h = 36,butt_g = 8;

container_buttons = ds_list_create();
choice_buttons = ds_list_create();
loop_buttons = ds_list_create();
multi_buttons = ds_list_create();
asset_buttons = ds_list_create(); //for non-containers
headers = ds_list_create();

//editor field
//column1
xpos[0,0] = (room_width*2/3)+8;
xpos[1,0] = (room_width*2/3)+(room_width/12)-8;
//column2
xpos[0,1] = (room_width*2/3)+(room_width/12)+8;
xpos[1,1] = (room_width*2/3)+(room_width*2/12)-8;
//column3
xpos[0,2] = (room_width*2/3)+(room_width/6)+8;
xpos[1,2] = (room_width*2/3)+(room_width*3/12)-8;
//column4
xpos[0,3] = (room_width*2/3)+(room_width*3/12)+8;
xpos[1,3] = room_width-8;

button_h = 36;
button_g = 8;
for(var i=3;i>=0;i-=1){
    column[i] = 0;
}

///////////////TOP LAYERS

tab1 = newHighlightable(objaeButton,16,(butt_g*1)+(butt_h*0)-4,(room_width/9) - 8,(butt_g*1)+(butt_h*1)-4);
tab1.script = aeChangeTab; tab1.args[0] = 0;
tab1.name = "Containers"; tab1.lit = true;

tab2 = newHighlightable(objaeButton,(room_width/9) + 8,(butt_g*1)+(butt_h*0)-4,(room_width*2/9) - 8,(butt_g*1)+(butt_h*1)-4);
tab2.script = aeChangeTab; tab2.args[0] = 1;
tab2.name = "Params";

tab3 = newHighlightable(objaeButton,(room_width*2/9) + 8,(butt_g*1)+(butt_h*0)-4,(room_width*3/9) - 8,(butt_g*1)+(butt_h*1)-4);
tab3.script = aeChangeTab; tab3.args[0] = 2;
tab3.name = "Busses";

containsearch = newHighlightable(objTextfield,32,(butt_g*1)+(butt_h*1),(room_width/3) - 8 - (128),(butt_g*1)+(butt_h*2));
//containsize = ds_list_size(container_root_list());

abcbut = newHighlightable(objaeButton,(room_width/3) + 8 - (128),(butt_g*1)+(butt_h*1),(room_width/3) - 8,(butt_g*1)+(butt_h*2));
abcbut.script = aeAlphabetical;
abcbut.name = "ABC";

containbut = newHighlightable(objaeButton,16,(butt_g*2)+(butt_h*2),8+128,(butt_g*2)+(butt_h*3));
containbut.script = aeNewContainer;
containbut.name = "NewContainer";

reloadbut = newHighlightable(objaeButton,128+16,(butt_g*2)+(butt_h*2),(room_width/3) - 8 - (128),(butt_g*2)+(butt_h*3));
reloadbut.script = aeReloadProject;
reloadbut.name = "Reload Project";

/*
loadbut = newHighlightable(objaeButton,(room_width/3) + 8 - (128),(butt_g*2)+(butt_h*2),(room_width/3) - 8,(butt_g*2)+(butt_h*3));
loadbut.script = aeNewEditorpanel;//aeAudioLoadPanel;
loadbut.args[0] = objaeAudioloader;
loadbut.name = "LOAD";*/

testbut = newHighlightable(objaeButton,(room_width/3)+16,8+48+8,(room_width/3)+(room_width*3/9)-8,8+butt_h+8+butt_h+butt_h);
testbut.script = aePlayEditingSound;
testbut.name = "TEST";

namebut = newHighlightable(objaeButton,(room_width/3)+(room_width*3/9)+8,8+48+8,(room_width/3)+(room_width*4.5/9)-8,8+butt_h+8+butt_h+butt_h);
namebut.script = aeRenameEditingSound;
namebut.name = "RENAME";
ds_list_add(container_buttons,namebut);

assetgainbut = newHighlightable(objTextfield,(room_width/3)+(room_width*3/9)+8,8+48+8,(room_width/3)+(room_width*4.5/9)-8,8+48+butt_h+8);
//assetgainbut.editing = global.audio_asset_vol; assetgainbut.param = -1;
assetgainbut.draggable = true; assetgainbut.dB = true; assetgainbut.plusmin = true;
ds_list_add(asset_buttons,assetgainbut);

assetbusbut = newHighlightable(objTextfield,(room_width/3)+(room_width*4.5/9)+8,8+48+8,(room_width/3)+(room_width*6/9)-8,8+48+butt_h+8);
//assetbusbut.editing = global.audio_asset_bus; assetbusbut.param = -1;
assetbusbut.istext = true; assetbusbut.percent = false; assetbusbut.plusmin = false;
ds_list_add(asset_buttons,assetbusbut);

delbut = newHighlightable(objaeButton,(room_width/3)+(room_width*4.5/9)+8,8+48+8,room_width-16,(8*2)+(butt_h*3));
delbut.script = aeDeleteEditingSound;
delbut.name = "DELETE";
ds_list_add(container_buttons,delbut);

busbut = newHighlightable(objTextfield,(room_width/3)+(room_width*4.5/9)+8,8,room_width-16,8+24);
busbut.container_edit = true; busbut.param = "bus"; busbut.percent = false; busbut.istext = true; busbut.plusmin = false;
ds_list_add(container_buttons,busbut);
buschbut = newHighlightable(objaeButton,(room_width/3)+(room_width*4.5/9)+8,8+24+8,room_width-16,8+40+8);
buschbut.script = aeBusChildren;
buschbut.name = "Set children";
ds_list_add(container_buttons,buschbut);

backbut = newHighlightable(objaeButton,(room_width/3)+8,8,(room_width/3)+8+48,8+48);
backbut.script = aePreviousEditingSound;
backbut.name = "<";
forbut = newHighlightable(objaeButton,(room_width/3)+8+48,8,(room_width/3)+8+48+48,8+48);
forbut.script = aeNextEditingSound;
forbut.name = ">";

for(var i=0;i<=2;i+=1){
    var but = newHighlightable(objaeButton,(room_width/3)+(room_width/3*i/3)+8,(butt_g*3)+(butt_h*3),(room_width/3)+(room_width/3*(i+1)/3)-8,(8*3)+(butt_h*4));
    but.script = aeTypeEditingSound;
    but.args[0] = i;
    var str;
    switch(i){
        case 0: str = "CHOICE"; break;
        case 1: str = "H-L-T"; break;
        case 2: str = "MULTI"; break;
    }
    but.name=str;
    ds_list_add(container_buttons,but);
}

seqbut = newHighlightable(objaeButton,(room_width/3)+8,(butt_g*4)+(butt_h*4),(room_width/3)+(room_width/9)+(room_width/18)-8,(8*4)+(butt_h*5));
seqbut.name = "SEQUENCE";
    seqbut.script = aeToggleSoundAttribute;
    seqbut.args[0] = "seq";
    ds_list_add(choice_buttons,seqbut);
	
choosebut = newHighlightable(objTextfield,(room_width/3)+(room_width*2.5/9)+8,(butt_g*4)+(butt_h*4),(room_width/3)+(room_width/3)-8,(8*4)+(butt_h*5));
choosebut.container_edit=true; choosebut.param="chosen";
choosebut.percent=false; choosebut.plusmin = false;
ds_list_add(choice_buttons,choosebut);
    
blendabut = newHighlightable(objTextfield,(room_width/3)+(room_width*2/9)+8,(butt_g*4)+(butt_h*4),(room_width/3)+(room_width/3)-8,(8*4)+(butt_h*5));
blendabut.container_edit = true; blendabut.param = "blend";
ds_list_add(multi_buttons,blendabut);

blendbut = newHighlightable(objaeButton,(room_width/3)+8,(butt_g*4)+(butt_h*4),(room_width/3)+(room_width/12)-8,(8*4)+(butt_h*5));
blendbut.name = "BLEND";
blendbut.script = aeToggleSoundAttribute; blendbut.args[0] = "blend_on";
ds_list_add(multi_buttons,blendbut);

blendebut = newHighlightable(objaeButton,(room_width/3)+8+(room_width/12),(butt_g*4)+(butt_h*4),(room_width/3)+(room_width/6)+(room_width/36)-8,(8*4)+(butt_h*5));
blendebut.name = "EDIT blend";
blendebut.script = aeEditSoundBlend;
ds_list_add(multi_buttons,blendebut);

////////////////////MUSIC CORNER

bpmbut = newStackedHighlightable(objTextfield,3,-1,"BPM");
bpmbut.container_edit=true; bpmbut.param="bpm";
bpmbut.percent=false; bpmbut.plusmin = false;
ds_list_add(multi_buttons,bpmbut);
ds_list_add(loop_buttons,bpmbut);
ds_list_add(choice_buttons,bpmbut);

beatstartbut = newHighlightable(objTextfield,lerp(bpmbut.l,bpmbut.r,.5),bpmbut.t,lerp(bpmbut.l,bpmbut.r,.75),bpmbut.b,"Measure");
beatstartbut.container_edit=true; beatstartbut.param="beatstart";
beatstartbut.percent=false; beatstartbut.plusmin = false;
ds_list_add(multi_buttons,beatstartbut);
ds_list_add(loop_buttons,beatstartbut);
ds_list_add(choice_buttons,beatstartbut);

var b = newHighlightable(objTextfield,lerp(bpmbut.l,bpmbut.r,.75),bpmbut.t,bpmbut.r,bpmbut.b);
    b.container_edit = true; b.param = "beats_per_measure";
    b.percent=false; b.plusmin = false;
    ds_list_add(loop_buttons,b);
    ds_list_add(choice_buttons,b);
    ds_list_add(multi_buttons,b);

bpmbut.r = lerp(bpmbut.l,bpmbut.r,.5);

/*
    var b = newStackedHighlightable(objTextfield,3,-1,"MeasureCount");
    b.container_edit = true; b.param = "beats_per_measure";
    b.percent=false; b.plusmin = false;
    ds_list_add(loop_buttons,b);
    ds_list_add(choice_buttons,b);
    ds_list_add(multi_buttons,b);
	*/

/*
musicbut = newStackedHighlightable(objaeButton,3);
musicbut.script = aeToggleSoundAttribute; musicbut.name="MUSIC";
musicbut.args[0] = "music";
ds_list_add(multi_buttons,musicbut);
ds_list_add(loop_buttons,musicbut);
ds_list_add(choice_buttons,musicbut);
*/

syncbut = newStackedHighlightable(objaeButton,3);
syncbut.script = aeToggleSoundAttribute; syncbut.name="SYNC";
syncbut.args[0] = "sync";
ds_list_add(multi_buttons,syncbut);
ds_list_add(loop_buttons,syncbut);
ds_list_add(choice_buttons,syncbut);

/*
varybut = newStackedHighlightable(objaeButton,3);
varybut.script = aeToggleSoundAttribute; varybut.name="VARYING";
varybut.args[0] = "varybpm";
ds_list_add(multi_buttons,varybut);
ds_list_add(loop_buttons,varybut);
ds_list_add(choice_buttons,varybut);
*/

loopbut = newStackedHighlightable(objaeButton,3);
loopbut.script = aeToggleSoundAttribute; loopbut.name="LOOP";
loopbut.args[0] = "loop";
ds_list_add(choice_buttons,loopbut);
ds_list_add(multi_buttons,loopbut);

    var b = newStackedHighlightable(objTextfield,3,-1,"fadeout");
    b.container_edit = true; b.param = "lpfade";
    b.percent=false; b.plusmin = false;
    ds_list_add(loop_buttons,b);
    ds_list_add(choice_buttons,b);
    ds_list_add(multi_buttons,b);
    
var b = newStackedHighlightable(objTextfield,3,-1,"fadein");
    b.container_edit = true; b.param = "lpfadein";
    b.percent=false; b.plusmin = false;
    ds_list_add(loop_buttons,b);
    ds_list_add(choice_buttons,b);
    ds_list_add(multi_buttons,b);
	
/////start time
var 
b = newStackedHighlightable(objaeButton,3,-1);
b.script = aeToggleSoundAttribute; b.name="RAND start"; b.args[0] = "randstart";
ds_list_add(container_buttons,b);
	
b = newStackedHighlightable(objTextfield,3,-1,"start time");
b.container_edit=true; b.param="starttime";
b.percent=false; b.plusmin = false;
ds_list_add(container_buttons,b);
    
//////////CHOICE STACK
continbut = newStackedHighlightable(objaeButton,2);
continbut.script = aeToggleSoundAttribute; continbut.name="ONGOING";
continbut.args[0] = "contin";
ds_list_add(choice_buttons,continbut);

spacebut = newStackedHighlightable(objaeButton,2);
spacebut.script = aeToggleSoundAttribute; spacebut.name="RANDOM XYZ";
spacebut.args[0] = "spacerand";
ds_list_add(choice_buttons,spacebut);

specmaxbut = newStackedHighlightable(objTextfield,2,-1,"spec max");
specmaxbut.container_edit=true; specmaxbut.param="specmax";
specmaxbut.percent=false; specmaxbut.plusmin = false;
ds_list_add(choice_buttons,specmaxbut);

specminbut = newStackedHighlightable(objTextfield,2,-1,"spec min");
specminbut.container_edit=true; specminbut.param="specmin";
specminbut.percent=false; specminbut.plusmin = false;
ds_list_add(choice_buttons,specminbut);

//////////////////LOOP STACK
column[0] = 0; column[1] = 0; column[2] = 0;
var b = newStackedHighlightable(objaeButton,2);
    b.script = aeToggleSoundAttribute; b.name="L-T";
    b.args[0] = "looptail";
    ds_list_add(loop_buttons,b);
    
loop_edit_list = list_Create("lpdelayin","lpdelay");
var th = 24,plist = loop_edit_list;
for(var i=ds_list_size(plist)-1;i>=0;i-=1){
    var v = ds_list_find_value(plist,i);

    var b = newStackedHighlightable(objTextfield,2,-1,v);
    b.container_edit = true; b.param = v;
    b.percent=false; b.plusmin = false;
    ds_list_add(loop_buttons,b);
}
ds_list_destroy(loop_edit_list);

column[0] = 0; column[1] = 0;

var b = newStackedHighlightable(objTextfield,0,1,"gain");
b.container_edit = true; b.param = "gain"; b.dB = true; b.slider = true; b.slide_r = (room_width*11/12)-28;
ds_list_add(container_buttons,b);
var bb = newHighlightable(objaeButton,(room_width*11/12),b.t,room_width-8,b.b);
ds_list_add(container_buttons,bb);
bb.script = aeGainChildren;
bb.name = "setChild";

var b = newStackedHighlightable(objTextfield,0,1,"random gain min, max");
b.container_edit = true; b.param = "volmin"; b.dB = true; b.slider = true;
ds_list_add(container_buttons,b);
var b = newStackedHighlightable(objTextfield,0,1);
b.container_edit = true; b.param = "volmax"; b.dB = true; b.slider = true;
ds_list_add(container_buttons,b);
var b = newStackedHighlightable(objaeButton,0,1);
b.script = aeDefaultGainRand; b.name="default";
ds_list_add(container_buttons,b);

var b = newStackedHighlightable(objTextfield,0,1,"pitch");
b.container_edit = true; b.param = "pitch"; b.slider = true;
ds_list_add(container_buttons,b);

var b = newStackedHighlightable(objTextfield,0,1,"random pitch min, max");
b.container_edit = true; b.param = "pitchmin"; b.slider = true;
ds_list_add(container_buttons,b);
var b = newStackedHighlightable(objTextfield,0,1);
b.container_edit = true; b.param = "pitchmax"; b.slider = true;
ds_list_add(container_buttons,b);
var b = newStackedHighlightable(objaeButton,0,1);
b.script = aeDefaultPitchRand; b.name="default";
ds_list_add(container_buttons,b);


b = newStackedHighlightable(objaeButton,0,1,);//"3D settings:");
b.script = aeToggleSoundAttribute; b.name="3D"; b.args[0] = "3d";
ds_list_add(container_buttons,b);
var b = newStackedHighlightable(objTextfield,0,1, "size (def "+string(global.default_sound_size)+")");
b.container_edit = true; b.param = "3d_sound_size"; b.percent=false; b.plusmin = false;
ds_list_add(container_buttons,b);
var b = newStackedHighlightable(objTextfield,0,1, "attenuation (def "+string(global.default_sound_atten)+")");
b.container_edit = true; b.param = "3d_sound_falloff"; b.percent=false; b.plusmin = false;
ds_list_add(container_buttons,b);
var b = newStackedHighlightable(objTextfield,0,1, "pan sticky");
b.container_edit = true; b.param = "3d_pan"; b.percent=true; b.plusmin = false;
ds_list_add(container_buttons,b);

/////////////////////SORT STUFFF
for(var i=0;i<ds_list_size(choice_buttons);i+=1){
    ds_list_add(container_buttons,ds_list_find_value(choice_buttons,i));
}
for(var i=0;i<ds_list_size(loop_buttons);i+=1){
    ds_list_add(container_buttons,ds_list_find_value(loop_buttons,i));
}
for(var i=0;i<ds_list_size(multi_buttons);i+=1){
    ds_list_add(container_buttons,ds_list_find_value(multi_buttons,i));
}
//panel = newHighlightable(objEditorpanel,room_width/3,0,room_width*2/3,room_width*2/3);

/* */
/*  */
