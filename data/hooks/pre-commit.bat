set InpFile=tmp.lua
set OutFile=trackassembly_init.lua
set BasPath=%~dp0
set LuaPath=%1
set LogFile=%2
echo %BasPath%, %LuaPath%>%LogFile%
copy %BasPath%..\..\lua\autorun\%OutFile% %BasPath%..\..\lua\autorun\%InpFile%
call %LuaPath%lua.exe %BasPath%pre-commit.lua %BasPath%..\..\lua\autorun\ %OutFile% UNX E:\Desktop\tmp.txt
del %BasPath%..\..\lua\autorun\tmp.lua
exit 0
