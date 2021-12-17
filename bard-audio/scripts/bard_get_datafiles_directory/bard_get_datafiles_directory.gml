function bard_get_datafiles_directory()
{
    if true//(SAVE_LOAD_GAME_DATA_TO_INCLUDED_FILES)
    {
        if (global.__bard_project_datafiles == undefined)
        {
            global.__bard_project_datafiles = bard_get_project_directory() + "datafiles\\";
        }
        
        return global.__bard_project_datafiles;
    }
    else
    {
        return "";
    }
}