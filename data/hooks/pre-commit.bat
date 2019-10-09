set InpFile=tmp.lua
set OutFile=trackassembly_init.lua
set BasPath=%~dp0
set LuaPath=%1
set LogFile=%2
set CpyPath=%BasPath%..\..\lua\autorun
set FrmEnds=UNX
echo Base: %BasPath%>  %LogFile%
echo Lua : %LuaPath%>> %LogFile%
copy %CpyPath%\%OutFile% %CpyPath%\%InpFile%
echo Calling %LuaPath%lua.exe>>%LogFile%
echo Call[0]: %BasPath%pre-commit.lua>>%LogFile%
echo Call[1]: %CpyPath%>>%LogFile%
echo Call[2]: %OutFile%>>%LogFile%
echo Call[3]: %FrmEnds%>>%LogFile%
echo Call[4]: %LogFile%>>%LogFile%
call %LuaPath%\lua.exe %BasPath%pre-commit.lua %CpyPath% %OutFile% %FrmEnds% %LogFile%
del %BasPath%..\..\lua\autorun\tmp.lua
echo Cleanup pieces manager buid...>>%LogFile%
rd /s /q %BasPath%..\..\data\peaces_manager\bin
rd /s /q %BasPath%..\..\data\peaces_manager\obj
del %BasPath%..\..\data\peaces_manager\peaces_manager.layout
exit 0
