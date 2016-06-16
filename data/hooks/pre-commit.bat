set InpFile=tmp.lua
set OutFile=trackassembly_init.lua
set BasPath=%~dp0
set LuaPath=%1
set LogFile=%2
echo %BasPath%, %LuaPath%>%LogFile%
copy %BasPath%..\..\lua\autorun\%OutFile% %BasPath%..\..\lua\autorun\%InpFile%
call %LuaPath%lua.exe %BasPath%pre-commit.lua %BasPath%..\..\lua\autorun\ %OutFile% UNX D:\Desktop\tmp.txt
del %BasPath%..\..\lua\autorun\tmp.lua
rd /s /q %BasPath%..\..\data\peaces_manager\bin
rd /s /q %BasPath%..\..\data\peaces_manager\obj
del %BasPath%..\..\data\peaces_manager\peaces_manager.layout
exit 0
