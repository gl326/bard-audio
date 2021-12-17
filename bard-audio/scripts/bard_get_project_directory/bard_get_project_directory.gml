global.__bard_project_path      = undefined;
global.__bard_project_directory = undefined;

function bard_get_project_directory()
{
    if (debug_mode)
    {
        _bard_get_project();
        return global.__bard_project_directory;
    }
    else
    {
        return "";
    }
}

function bard_get_project_file()
{
    if (debug_mode)
    {
        _bard_get_project();
        return global.__bard_project_path;
    }
    else
    {
        return "";
    }
}

function _bard_get_project()
{
    if (debug_mode)
    {
        if (global.__bard_project_directory == undefined)
        {
            var _save_project_path = false;
            
            if (file_exists("bard_project_path"))
            {
				var file = file_text_open_read("bard_project_path");
                global.__bard_project_path = file_text_read_string(file); file_text_readln(file); //file_read_string("bard_project_path"); 
            }
            else
            {
                _save_project_path = true;
            }
            
            while(!is_string(global.__bard_project_path) || !file_exists(global.__bard_project_path))
            {
                _save_project_path = true;
                if (global.__bard_project_path != "") show_message(concat("Could not find project at \"", global.__bard_project_path, "\"\n\nPlease locate the project file."));
                global.__bard_project_path = get_open_filename("GameMaker Studio 2 Project (*.yyp)|*.yyp", "*.yyp");
            }
            
            if (_save_project_path) file_write_string("bard_project_path", global.__bard_project_path);
            
            if (debug_mode) show_debug_message(concat("Project found at \"",  global.__bard_project_path, "\""));
            
            global.__bard_project_directory = filename_dir(global.__bard_project_path) + "\\";
        }
        
    }
}