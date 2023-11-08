@echo off
setlocal enabledelayedexpansion

:: The location of the script ( Do not change )
set emd_chew_pathb=%~dp0

:: Addons file extension
set emd_chew_adext=gma

:: The path to Garry's mod
set emd_chew_gmod=D:\Games\Steam\steamapps\common\GarrysMod

:: Path to the workshop directory
set emd_chew_wshop=D:\Games\Steam\steamapps\workshop\content\4000

:: The path to Garry's mod addons folder
set emd_chew_addon=%emd_chew_gmod%\garrysmod\addons

:: Location of "gmad.exe"
set emd_chew_binloc=%emd_chew_gmod%\bin

:: Repository local clone locatioon
set emd_chew_repo=%emd_chew_addon%\TrackAssemblyTool_GIT

:: The path to the "garrysmod/data/trackassembly/trackasmlib_db.txt"
:: Such file is generated when tool control panel is refreshed in developer mode
set emd_chew_dbase=%emd_chew_gmod%\garrysmod\data\trackassembly\exp\trackasmlib_db.txt

:: The path to the skipped models list
set emd_chew_skip=%emd_chew_repo%\data\trackassembly\tools\peaces_manager\models_ignored.txt

:: How many addons are to be processed
set emd_chew_addcnt=17

:: GMA addons to be processed
set emd_chew_addlst[1]=149759773
set emd_chew_addlst[2]=147812851
set emd_chew_addlst[3]=132843280
set emd_chew_addlst[4]=173482196
set emd_chew_addlst[5]=290130567
set emd_chew_addlst[6]=326640186
set emd_chew_addlst[7]=173717507
set emd_chew_addlst[8]=331192490
set emd_chew_addlst[9]=517442747
set emd_chew_addlst[10]=718239260
set emd_chew_addlst[11]=728833183
set emd_chew_addlst[12]=807162936
set emd_chew_addlst[13]=740453553
set emd_chew_addlst[14]=1658816805
set emd_chew_addlst[15]=1888013789
set emd_chew_addlst[16]=1955876643
set emd_chew_addlst[17]=3071058065

:: Folder list for extraction and the directories they will be extracted
set emd_chew_adddir[1]=SligWolf's Minitrains
set emd_chew_adddir[2]=SligWolf's Minihover$SligWolf's White Rails
set emd_chew_adddir[3]=SligWolf's Rerailers
set emd_chew_adddir[4]=SProps
set emd_chew_adddir[5]=Magnum's Rails
set emd_chew_adddir[6]=Shinji85's Rails
set emd_chew_adddir[7]=SligWolf's Railcar
set emd_chew_adddir[8]=StevenTechno's Buildings 1.0
set emd_chew_adddir[9]=Mr.Train's M-Gauge
set emd_chew_adddir[10]=G Scale Track Pack
set emd_chew_adddir[11]=Ron's Minitrain Props
set emd_chew_adddir[12]=Battleship's abandoned rails
set emd_chew_adddir[13]=AlexCookie's 2ft track pack
set emd_chew_adddir[14]=Joe's track pack
set emd_chew_adddir[15]=StevenTechno's Buildings 2.0
set emd_chew_adddir[16]=Trackmania United Props
set emd_chew_adddir[17]=Fortification Collection

:: Show the current folder
echo Running in: %emd_chew_pathb%

:: Output file for models list
set emd_chew_modls=models_list
set emd_clog_lfile=system_log

:: Refresh model report
del %emd_chew_pathb%%emd_chew_modls%.txt
del %emd_chew_pathb%%emd_clog_lfile%.txt

:: Extract the GMA addons in the matching folders
for /L %%k in (1,1,%emd_chew_addcnt%) do (
  set /A emd_chew_match=0
  :: Try the addons folder
  IF !emd_chew_match! EQU 0 (
    :: Extract addon info
    set "emd_chew_fdid=!emd_chew_addlst[%%k]!"
    set "emd_chew_fdnm=!emd_chew_adddir[%%k]!"
    :: Create search path  
    set emd_chew_fgma=!emd_chew_addon!\*
    set emd_chew_fgma=!emd_chew_fgma!!emd_chew_fdid!*
    set emd_chew_fgma=!emd_chew_fgma!.!emd_chew_adext!
    set "emd_chew_fdnm=!emd_chew_adddir[%%k]!"
    for %%i in (!emd_chew_fgma!) do (
      set /A emd_chew_match=1
      :: Extract the GMA in the current folder
      cd %emd_chew_pathb%
      IF EXIST "!emd_chew_fdnm!\" ( rd /S /Q "!emd_chew_fdnm!" )
      call %emd_chew_binloc%\gmad.exe extract -file "%%i" -out "%emd_chew_pathb%!emd_chew_fdnm!" >> %emd_clog_lfile%.txt
      echo Addons: [%%k]{!emd_chew_fdnm!} @ %TIME%
    )
  )
  :: Try the workshop content folder
  IF !emd_chew_match! EQU 0 (
    :: Extract addon info
    set "emd_chew_fdid=!emd_chew_addlst[%%k]!"
    set "emd_chew_fdnm=!emd_chew_adddir[%%k]!"
    :: Create search path
    set emd_chew_fgma=!emd_chew_wshop!\
    set emd_chew_fgma=!emd_chew_fgma!!emd_chew_fdid!\
    set emd_chew_fgma=!emd_chew_fgma!*.!emd_chew_adext!
    for %%i in (!emd_chew_fgma!) do (
      set /A emd_chew_match=1
      :: Extract the GMA in the current folder
      cd %emd_chew_pathb%
      IF EXIST "!emd_chew_fdnm!\" ( rd /S /Q "!emd_chew_fdnm!" )
      call %emd_chew_binloc%\gmad.exe extract -file "%%i" -out "%emd_chew_pathb%!emd_chew_fdnm!" >> %emd_clog_lfile%.txt
      echo Workshop: [%%k]{!emd_chew_fdnm!} @ %TIME%
    )
  )
  :: Try the workshop content folder
  IF !emd_chew_match! EQU 0 (
    echo Not-Available: [%%k]{!emd_chew_fdnm!} @ %TIME%
  )
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
