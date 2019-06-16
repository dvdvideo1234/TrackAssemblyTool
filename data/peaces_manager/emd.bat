@echo off
setlocal enabledelayedexpansion

:: The location of the script ( Do not change )
set emd_chew_pathb=%~dp0
echo Running in: %emd_chew_pathb%

:: The path to Garry's mod
set emd_chew_gmod=F:\Games\Steam\steamapps\common\GarrysMod

:: The path to Garry's mod addons folder
set emd_chew_addon=%emd_chew_gmod%\garrysmod\addons

:: Location of "gmad.exe"
set emd_chew_binloc=%emd_chew_gmod%\bin

:: The path to the "trackassembly_init.lua"
set emd_chew_dbase=%emd_chew_addon%\TrackAssemblyTool_GIT\lua\autorun\trackassembly_init.lua

:: The path to the skipped models list
set emd_chew_skip=%emd_chew_addon%\TrackAssemblyTool_GIT\data\peaces_manager\models_ignored.txt

:: How many addons are to be processed
set emd_chew_addcnt=14

:: GMA addons to be processed
set emd_chew_addlst[1]=sligwolfs_minitrains_149759773
set emd_chew_addlst[2]=sligwolfs_modelpack_147812851
set emd_chew_addlst[3]=sligwolfs_rerailer_132843280
set emd_chew_addlst[4]=sprops_workshop_edition_173482196
set emd_chew_addlst[5]=[1-gauge]_magnums_train_model_pack_290130567
set emd_chew_addlst[6]=shinji85s_rails_train_pack_326640186
set emd_chew_addlst[7]=sligwolfs_rail_car_173717507
set emd_chew_addlst[8]=steventechnos_buildings_pack_331192490
set emd_chew_addlst[9]=mr.train_m_gauge_517442747
set emd_chew_addlst[10]=g_scale_track_pack_718239260
set emd_chew_addlst[11]=rons_minitrain_props_728833183
set emd_chew_addlst[12]=battleships_abandoned_rails(penn_central_simulator_2017)(wip)_807162936
set emd_chew_addlst[13]=alexcookies_2ft_track_pack_740453553
set emd_chew_addlst[14]=joes_track_pack_1658816805

:: Folder list for extraction and the directories they will be extracted
set emd_chew_adddir[1]=SligWolf's Minitrains
set emd_chew_adddir[2]=SligWolf's Minihover$SligWolf's White Rails
set emd_chew_adddir[3]=SligWolf's Rerailers
set emd_chew_adddir[4]=SProps
set emd_chew_adddir[5]=Magnum's Rails
set emd_chew_adddir[6]=Shinji85's Rails
set emd_chew_adddir[7]=SligWolf's Railcar
set emd_chew_adddir[8]=StephenTechno's Buildings
set emd_chew_adddir[9]=Mr.Train's M-Gauge
set emd_chew_adddir[10]=G Scale Track Pack
set emd_chew_adddir[11]=Ron's Minitrain Props
set emd_chew_adddir[12]=Battleship's abandoned rails
set emd_chew_adddir[13]=AlexCookie's 2ft track pack
set emd_chew_adddir[14]=Joe's track pack

:: AUTOMATIC STUFF ::

:: Output file for models list
set emd_chew_modls=models_list
set emd_clog_lfile=system_log

:: Refresh model report
del %emd_chew_pathb%%emd_chew_modls%.txt
del %emd_chew_pathb%%emd_clog_lfile%.txt

:: Extract the GMA addons in the matching folders
for /L %%k in (1,1,%emd_chew_addcnt%) do (
  cd %emd_chew_pathb%
  rd /S /Q "!emd_chew_adddir[%%k]!"
  call %emd_chew_binloc%\gmad.exe extract -file "%emd_chew_addon%\!emd_chew_addlst[%%k]!.gma" -out "%emd_chew_pathb%!emd_chew_adddir[%%k]!"
  echo [%%k]!emd_chew_adddir[%%k]! >> %emd_clog_lfile%.txt
)

:: Get all the model files in the current directory
dir /a-d /b /s *.mdl >> %emd_chew_pathb%%emd_chew_modls%.txt

:: Refresh output files
del %emd_chew_pathb%addon-db.txt
del %emd_chew_pathb%db-addon.txt

:: Chewing the paths uses base path relative to the executable
echo Rinning pieces manager
call %emd_chew_pathb%peaces_manager.exe %emd_chew_pathb% %emd_chew_dbase% %emd_chew_skip% %emd_clog_lfile%

timeout 300
