@echo off
setlocal enabledelayedexpansion

:: The location of the script ( Do not change )
set emd_chew_pathb=%~dp0
echo Running in: %emd_chew_pathb%

:: The path to Addons
set emd_chew_addon=F:\Games\Steam\steamapps\common\GarrysMod\garrysmod\addons

:: The path to the "trackassembly_init.lua"
set emd_chew_dbase=%emd_chew_addon%\TrackAssemblyTool_GIT\lua\autorun\trackassembly_init.lua

:: The path to the skipped models list
set emd_chew_skip=%emd_chew_addon%\TrackAssemblyTool_GIT\data\peaces_manager\models_ignored.txt

:: Location of "gmad.exe"
set emd_chew_binloc=F:\Games\Steam\steamapps\common\GarrysMod\bin

:: How many addons are to be processed
set emd_chew_addcnt=2

:: GMA addtons to be processed
set emd_chew_addlst[1]=sligwolfs_minitrains_149759773
set emd_chew_addlst[2]=sligwolfs_modelpack_147812851
:: Folder list for extraction and the directories they will be extracted
set emd_chew_adddir[1]=SligWolf's Minitrains
set emd_chew_adddir[2]=SligWolf's Minihover$SligWolf's White Rails

:: AUTOMATIC STUFF ::

:: Output file for models list
set emd_chew_modls=models_list
set emd_clog_lfile=system_log

:: Refresh model report
del %emd_chew_pathb%%emd_chew_modls%.txt

:: Extract the GMA addons in the matching folders
for /L %%k in (1,1,%emd_chew_addcnt%) do (
  cd %emd_chew_pathb%
  rd /S /Q "!emd_chew_adddir[%%k]!"
  call %emd_chew_binloc%\gmad.exe extract -file "%emd_chew_addon%\!emd_chew_addlst[%%k]!.gma" -out "%emd_chew_pathb%!emd_chew_adddir[%%k]!"
)

:: Get all the model files in the current direcory
dir /a-d /b /s *.mdl >> %emd_chew_pathb%%emd_chew_modls%.txt

:: Refresh output files
del %emd_chew_pathb%addon-db.txt
del %emd_chew_pathb%db-addon.txt

:: Chewing the paths uses base path relative to the executable
echo Rinning pieces manager
call %emd_chew_pathb%chewpath.exe %emd_chew_pathb% %emd_chew_dbase% %emd_chew_skip% %emd_clog_lfile%

timeout 300
