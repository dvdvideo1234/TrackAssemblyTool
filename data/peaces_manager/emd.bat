echo off

set DataBase=F:\Games\Steam\steamapps\common\GarrysMod\garrysmod\addons\TrackAssemblyTool_GIT\lua\autorun\trackassembly_init.lua
set ModelLst=models_list.txt
set BasePath=%~dp0

del %ModelLst%
del addon-db.txt
del db-addon.txt

dir /a-d /b /s *.mdl > %ModelLst%

call chewpath.exe %BasePath% %ModelLst% %DataBase%

timeout 300
