global.__project_path      = undefined;
global.__project_directory = undefined;

function get_project_directory()
{
    if (debug_mode)
    {
        _get_project();
        return global.__project_directory;
    }
    else
    {
        return "";
    }
}

function get_project_file()
{
    if (debug_mode)
    {
        _get_project();
        return global.__project_path;
    }
    else
    {
        return "";
    }
}

function _get_project()
{
    if (debug_mode)
    {
        if (global.__project_directory == undefined)
        {
            var _save_project_path = false;
            
            if (file_exists("project path"))
            {
				var file = file_text_open_read("project path");
                global.__project_path = file_text_read_string(file); file_text_readln(file); //file_read_string("project path"); 
            }
            else
            {
                _save_project_path = true;
            }
            
            while(!is_string(global.__project_path) || !file_exists(global.__project_path))
            {
                _save_project_path = true;
                if (global.__project_path != "") show_message(concat("Could not find project at \"", global.__project_path, "\"\n\nPlease locate the project file."));
                global.__project_path = get_open_filename("GameMaker Studio 2 Project (*.yyp)|*.yyp", "*.yyp");
            }
            
            if (_save_project_path) file_write_string("project path", global.__project_path);
            
            if (debug_mode) show_debug_message(concat("Project found at \"",  global.__project_path, "\""));
            
            global.__project_directory = filename_dir(global.__project_path) + "\\";
        }
        
    }
}