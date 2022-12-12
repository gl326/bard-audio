// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function aeCreateEffectsPanel(parent=objAudioEditor.editing,_x=mouse_x,_y=mouse_y){
		if variable_struct_exists(parent,"effects"){
		                    var pw=400, ph=0, px = max(0,_x-(pw/2)), py = _y;
							var _fy = py+40; 
							var _e_height = 25, _e_gap = 8;
							
							ph = 40+(_e_height+_e_gap)*(1+array_length(parent.effects));
							
							var pan = aeNewEditorpanel(objEditorpanel,px,py,pw,ph);
		                    pan.title = parent.name+":effects";
							
							var _i = 0;
							repeat(array_length(parent.effects)){
								var f = newHighlightable(objaeButton,px+5,_fy,px+30,_fy+_e_height); ds_list_add(pan.children,f);
								f.name = "ON"; f.script = aeToggleEffectOn; f.args[0]=parent; f.args[1]=parent.effects[_i];
								
								var f = newHighlightable(objTextfield,px+120,_fy,px+250,_fy+_e_height); ds_list_add(pan.children,f);
								f.editing = parent.effects[_i]; f.param = "name"; f.update_func = aeUpdateEffectName; f.text = f.editing[$ f.param]; f.istext = true;
								f.title = f.editing.type+" ";
								
								var f = newHighlightable(objaeButton,px+255,_fy,px+355,_fy+_e_height); ds_list_add(pan.children,f);
								f.name = "EDIT"; f.script = aeEditEffect; f.args[0]=parent.effects[_i]; f.args[1]=parent.name; f.args[2] = pan;
								
								var f = newHighlightable(objaeButton,px+360,_fy,px+390,_fy+_e_height); ds_list_add(pan.children,f);
								f.name = "DEL"; f.script = aeDestroyEffect; f.args[0]=parent; f.args[1]=_i; f.args[2]=pan;
								
								_fy += _e_height+_e_gap;
								_i ++;
							}
							
							var f = newHighlightable(objaeButton,px+16,_fy,px+400-16,_fy+_e_height); ds_list_add(pan.children,f);
							f.name = "NEW EFFECT..."; f.script = aeAddNewEffect; f.args[0]=parent; f.args[1]=pan;
				global.bard_editor_highlighted = pan;
				return pan;
		}
		
		return noone;
}

function aeAddNewEffect(parent=objAudioEditor.editing,_oldpanel=noone){
	var display = "";
	var _i = 0, _n = 0, ids = [];
	repeat(array_length(global.bard_audio_effect_names)){
		if is_string(global.bard_audio_effect_names[_i]){
			if _n>0{
				display += " | ";	
			}
			display += string(_n)+":"+global.bard_audio_effect_names[_i];
			array_push(ids,_i);
			_n ++;
		}
		_i ++;
	}
	
	var _get_type = get_string("Enter an effect type ("+display+")","0");
	if string_length(_get_type) and string_digits(_get_type)==_get_type{
		_get_type = real(_get_type);
		if is_numeric(_get_type) and _get_type>=0 and _get_type<array_length(ids){
			_get_type = ids[_get_type];
			var _new_effect = new class_audio_effect().set_type(_get_type,parent); //create effect
			
			//assign a unique name
			var _num_str = 1;
			while(true){
				var _i = 0, found = false;
				repeat(array_length(parent.effects)){
					if parent.effects[_i].name==_new_effect.type+string(_num_str){
						_num_str += 1;
						found = true; break;
					}
					_i ++;	
				}
				
				if !found{
					break;
				}
			}
			_new_effect.name = _new_effect.type+string(_num_str);
			
			//add to parent array
			array_push(parent.effects,_new_effect);
			//and turn it on
			parent.set_effect(_new_effect.name,true);
		
			//update editor panels
			var newpan = aeEditEffect(_new_effect,parent.name,_oldpanel);
			aeResetEffectsPanel(parent,_oldpanel);
			
			global.bard_editor_highlighted = newpan;
		}
	}
}

function aeEditEffect(_effect,_parent_name,_panel_from=noone,_x=mouse_x,_y = mouse_y){
			        var pw=400, ph=0, px = max(0,_x-(pw/2)), py = _y;
							var _fy = py+40; 
							var _e_height = 25, _e_gap = 8;
							var _settings_names = variable_struct_get_names(_effect.settings)
							ph = 40+(_e_height+_e_gap)*(array_length(_settings_names)+1);
							
							var pan = aeNewEditorpanel(objEditorpanel,px,py,pw,ph);
		                    pan.title = _parent_name+":"+_effect.name+"("+_effect.type+")";
							pan.struct = _effect;
							if instance_exists(_panel_from){
								pan.parent_window = _panel_from.id;
							}
							
							var _params = _effect.get_template();
							
							var _i = 0;
							repeat(array_length(_settings_names)){
								var _param = _params[$ _settings_names[_i]];
								var f = newHighlightable(objTextfield,px+60,_fy,px+120,_fy+_e_height); ds_list_add(pan.children,f);
								f.editing = _effect.settings; f.param = _settings_names[_i]; f.update_func = aeUpdateEffectSetting; 
								f.text = string(f.editing[$ f.param]);
								f.plusmin = false; f.percent = false;
								if _param.range[0]!=-infinity and _param.range[1]!=infinity{
									f.slider = true; f.slider_min = _param.range[0]; f.slider_max = _param.range[1]; 
									f.slide_l = px+150; f.slide_r = px+370; f.panel_slider = true;
									f.dB_100 = false;
									if _param.isDb{
										f.dB = true;
										f.text = string(PercentToDB(f.editing[$ f.param]-1));
									}
								}
								
								f.title = f.param;
								f.highlight_text = _param.desc;
								f.effect_edit = true; f.effect_editing = _effect; //for param connections...
								f.param_ref = _effect.variable_has_hook(f.param);
								
								_fy += _e_height+_e_gap;
								_i ++;
							}
							
							var f = newHighlightable(objaeButton,px+16,_fy,px+400-16,_fy+_e_height); ds_list_add(pan.children,f);
							f.name = "Default ON"; f.script = aeToggleEffectDefaultOn; f.args[0]=_effect;
							
							global.bard_editor_highlighted = pan;
							return pan;
}

function aeUpdateEffectName(effect){
	effect.name_updated();
}

function aeToggleEffectDefaultOn(effect){
	effect.default_on = !effect.default_on;	
}

function aeUpdateEffectSetting(effect){
	//effect.settings_update();
	///sooo janky sorry
	with(objEditorpanel){
		if is_struct(struct){
			if struct.settings==effect{
				struct.settings_update();
			}
		}
	}
}

function aeDestroyEffect(_parent,_i,_oldpanel=noone){
	if show_question("delete this effect?"){
		_parent.effects[_i].destroy();
		array_delete(_parent.effects,_i,1);
		
		aeResetEffectsPanel(_parent,_oldpanel);
	}
}

function aeToggleEffectOn(_parent,_effect){
	if _parent.has_effect_class(_effect){
		_parent.set_effect_class(_effect,false);
	}else{
		_parent.set_effect_class(_effect,true);
	}
}

function aeResetEffectsPanel(_parent,_oldpanel = noone){
	var _x = mouse_x, _y = mouse_y, _oldid = -99;

			if instance_exists(_oldpanel){
				_oldid = _oldpanel.id;
				_x = _oldpanel.x;
				_y = _oldpanel.y;
				aeClosePanel(_oldpanel);	
			}
	
	var pan = aeCreateEffectsPanel(_parent,_x,_y);
	with(objEditorpanel){ //reparent windows
		if parent_window==_oldid{
			parent_window = pan.id;	
		}
	}
}