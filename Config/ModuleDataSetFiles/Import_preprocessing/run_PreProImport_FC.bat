set conda_bat     = %1
set conda_env     = %2
set config_dir    = %3
set import_folder = %4
set log_folder    = %5

call %conda_bat% activate %conda_env%
call python PreProImport_FC.py %3 %4 %5
IF %ERRORLEVEL% NEQ 0 EXIT 1
call %conda_bat% deactivate
