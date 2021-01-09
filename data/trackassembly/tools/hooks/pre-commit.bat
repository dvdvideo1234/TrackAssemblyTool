:: The name of the temporary file
set hookInpFile=tmp.lua

:: The name of the modify file
set hookOutFile=trackassembly_init.lua

:: Current path of this batch file
set hookBasPath=%~dp0

:: The path to the Lua eceutable including
set hookLuaPath=%1

:: The path to the log file. Folder must exist!
set hookLogFile=%2

:: Where to read the revision file from
set hookCpyPath=%hookBasPath%..\..\..\..\lua\autorun

:: The path where pieces manager tool is located
set hookPimMath=%hookBasPath%..\peaces_manager

:: The output format of the revision file
set hookFrmEnds=UNX

echo Base: %hookBasPath%>  %hookLogFile%
echo Lua : %hookLuaPath%>> %hookLogFile%
copy %hookCpyPath%\%hookOutFile% %hookCpyPath%\%hookInpFile%
echo Calling %hookLuaPath%>>%hookLogFile%
echo Call[0]: %hookBasPath%pre-commit.lua>>%hookLogFile%
echo Call[1]: %hookCpyPath%>>%hookLogFile%
echo Call[2]: %hookOutFile%>>%hookLogFile%
echo Call[3]: %hookFrmEnds%>>%hookLogFile%
echo Call[4]: %hookLogFile%>>%hookLogFile%
call %hookLuaPath% %hookBasPath%pre-commit.lua %hookCpyPath% %hookOutFile% %hookFrmEnds% %hookLogFile%
del %hookCpyPath%\%hookInpFile%
echo Cleanup pieces manager buid...>>%hookLogFile%
rd /s /q %hookPimMath%\bin
rd /s /q %hookPimMath%\obj
del %hookPimMath%\peaces_manager.layout
timeout 500
exit 0
