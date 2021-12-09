global.__project_datafiles = undefined;

function get_datafiles_directory()
{
    if true//(SAVE_LOAD_GAME_DATA_TO_INCLUDED_FILES)
    {
        if (global.__project_datafiles == undefined)
        {
            global.__project_datafiles = get_project_directory() + "datafiles\\";
        }
        
        return global.__project_datafiles;
    }
    else
    {
        return "";
    }
}