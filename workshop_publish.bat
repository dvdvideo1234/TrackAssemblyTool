:: Hard reset the HEAD: git push origin +<NEW_HEAD_COMMIT_HASH>:master
:: 6af74344a888bdf9fbb35d887c3f77691820a50e
:: git push origin +6af74344a888bdf9fbb35d887c3f77691820a50e:master
:: cd /e
:: cd Documents/Lua-Projs/SVN/TrackAssemblyTool_GIT_master

@echo off

setlocal EnableDelayedExpansion

set gmadGitHEAD=
set gmadRevPath=%~dp0
set gmadNameLOG=gmad_log.txt
set gmadNameGIT=gmad_git.txt
set gmadName=TrackAssemblyTool
set gmadCommits=https://github.com/dvdvideo1234/%gmadName%/commit/
set "gmadPathGIT=%GIT_HOME%\bin\git.exe"
set gmadBinPath=%GMOD_HOME%\bin
set "gmadADTools=%gmadRevPath%data\trackassembly\tools"
set "gmadTime=%date% %time%"
set gmadID=287012681
set gmadDirs=(lua resource)

title Addon %gmadName% updater/publisher

echo Press Crtl+C to terminate^^!
echo Press a key if you do not want to wait^^!
echo Rinning in: %gmadRevPath%
echo Npp Find --\h{1,}\n-- replace --\n-- in dos format before commit^^!
echo Extracting repository source contents^^!
IF EXIST !gmadNameLOG! del !gmadNameLOG!
IF EXIST !gmadNameGIT! del !gmadNameGIT!
IF EXIST Workshop rd /S /Q Workshop

timeout 5

md "%gmadRevPath%Workshop\!gmadName!" >> !gmadNameLOG!
for %%i in %gmadDirs% do (
  echo Exporting addon content: %%i
  call xcopy "!gmadRevPath!%%i" "!gmadRevPath!Workshop\!gmadName!\%%i" /EXCLUDE:!gmadADTools!\workshop\key.txt /E /C /I /F /R /Y >> !gmadNameLOG!
)

call copy "!gmadADTools!\workshop\addon.json" "!gmadRevPath!Workshop\!gmadName!\addon.json" >> !gmadNameLOG!
call "!gmadBinPath!\gmad.exe" create -folder "!gmadRevPath!Workshop\!gmadName!" -out "!gmadRevPath!Workshop\!gmadName!.gma" >> !gmadNameLOG!

echo Obtain the latest repository commit log^^!

for /F "tokens=*" %%i in ('call "!gmadPathGIT!" rev-parse HEAD') do (set "gmadGitHEAD=%%i")

call echo !gmadTime! >> !gmadNameGIT!
call echo. >> !gmadNameGIT!
call echo !gmadCommits!!gmadGitHEAD! >> !gmadNameGIT!
call echo. >> !gmadNameGIT!
call "!gmadPathGIT!" log -1 >> !gmadNameGIT!

timeout 15

IF DEFINED gmadID (
  call "!gmadBinPath!\gmpublish.exe" update -addon "!gmadRevPath!Workshop\!gmadName!.gma" -id "!gmadID!" -icon "!gmadADTools!\pictures\icon.jpg" -changes "Generated by batch" >> !gmadNameLOG!
) ELSE (
  call "!gmadBinPath!\gmpublish.exe" create -addon "!gmadRevPath!Workshop\!gmadName!.gma" -icon "!gmadADTools!\pictures\icon.jpg" >> !gmadNameLOG!
)

echo !gmadName! Published^^!

call "%WINDIR%\System32\notepad.exe" "!gmadRevPath!!gmadNameGIT!"

echo Cleaning up the working directory^^!

rd /S /Q "!gmadRevPath!Workshop"
del "!gmadRevPath!!gmadNameLOG!"
del "!gmadRevPath!!gmadNameGIT!"

timeout 2

exit 0
