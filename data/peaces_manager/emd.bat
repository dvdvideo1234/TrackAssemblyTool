@echo off
setlocal enabledelayedexpansion

:: The location of the script ( Do not change )
set emd_chew_pathb=%~dp0
echo Running in: %emd_chew_pathb%

:: The path to Addons
set emd_chew_addon=F:\Games\Steam\steamapps\common\GarrysMod\garrysmod\addons

:: The path to the "trackassembly_init.lua"
set emd_chew_dbase=%emd_chew_addon%\TrackAssemblyTool_GIT\lua\autorun\trackassembly_init.lua

:: Output file for models list
set emd_chew_modls=models_list.txt

:: Location of "gmad.exe"
set emd_chew_binloc=F:\Games\Steam\steamapps\common\GarrysMod\bin

:: How many addons are to be processed
set emd_chew_addcnt=1

:: GMA addtons to be processed
set emd_chew_addlst[1]=rons_2ft_trackpack_634000136

:: Folder list for extraction and the directories they will be extracted
set emd_chew_adddir[1]=Ron's 2ft track pack

:: Refresh model report
del %emd_chew_pathb%%emd_chew_modls%

:: Refresh output files
del %emd_chew_pathb%addon-db.txt
del %emd_chew_pathb%db-addon.txt

:: Extract the GMA addons in the matching folders
for /L %%k in (1,1,%emd_chew_addcnt%) do (
  cd %emd_chew_pathb%
  rd /S /Q "!emd_chew_adddir[%%k]!"
  call %emd_chew_binloc%\gmad.exe extract -file "%emd_chew_addon%\!emd_chew_addlst[%%k]!.gma" -out "%emd_chew_pathb%!emd_chew_adddir[%%k]!"
  cd "%emd_chew_pathb%!emd_chew_adddir[%%k]!"
  dir /a-d /b /s *.mdl >> %emd_chew_pathb%%emd_chew_modls%
)

:: Chewing the paths uses base path relative to the executable
call %emd_chew_pathb%chewpath.exe %emd_chew_pathb% %emd_chew_modls% %emd_chew_dbase%

timeout 300
