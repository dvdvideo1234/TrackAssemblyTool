-- Test in CMD:
-- ..\..\bin\lua.exe go.lua "E:\Documents\Lua-Projs\SVN\TrackAssemblyTool_GIT_master\lua\autorun\trackassembly_init.lua" "Rev." "UNX"
-- Call in CMD: Script { LUA_PATH, LOG_FILE }
-- Work: E:\Documents\Lua-Projs\SVN\TrackAssemblyTool_GIT_master\hooks\pre-commit.bat E:\Documents\Lua-Projs\Lua\Bin\ E:\Desktop\tmp.txt
-- Home: 

local sFile = tostring(arg[1])
      sFile = sFile:gsub("\\","/")
if((sFile == "nil") or (string.len(sFile) == 0)) then
  print("No file")
  return false
end
local sMarker = tostring(arg[2])
if((sMarker == "nil") or (string.len(sMarker) == 0)) then
  print("No marker")
  return false
end
local sEnd = tostring(arg[3])
if((sEnd == "nil") or (string.len(sEnd) == 0)) then
  print("No endline")
  return false
end
if(not (sEnd == "DOS" or sEnd == "UNX")) then
  print("Wrong end line mode: -"..sEnd.."-")
  return false
end

if(sEnd == "DOS") then sEnd = "\r\n" end
if(sEnd == "UNX") then sEnd = "\n"   end

print("\nHook: ",sFile)
print(  "Mark: ",sMarker)
print(  "EndL: ","-"..sEnd.."-")

local F = io.open(sFile,"r+")
if(not F) then
  print("File "..sFile.." not found")
  return false
end
local sI = F:read()
if(not sI) then
  print("File "..sFile.." reached EOF")
  return false
end
local sO = ""
local nB, nE, nS, iLen = 1, 1, 1, 0
while(sI) do
  iLen = sI:len()
  while(sI:sub(iLen,iLen) == "\r" or sI:sub(iLen,iLen) == "\n") do
    iLen = iLen - 1
  end
  sI = sI:sub(nS,iLen)
  nB, nE = sI:find(sMarker,nS,true)
  if(nB and nE) then
    while(nB and nE) do
      print("Line : ",sI)
      print("Found: ",nB, nE)
      sO = sO..sI:sub(nS,nE)
      nS = nE + 1
      local sNum = ""
      local sCh  = ""
      while(true) do
        sCh = sI:sub(nS,nS)
        if(not tonumber(sCh)) then break end
        sNum = sNum..sCh
        nS   = nS + 1
      end
      if(sNum:len() > 0) then
        sNum = tostring(tonumber(sNum) + 1)
      end
      sO = sO..sNum
      nB, nE = sI:find(sMarker,nS,true)
    end
    sO = sO..string.format("%s%s",sI:sub(nS,iLen),sEnd)
  else
    sO = sO..string.format("%s%s",sI:sub(nS,iLen),sEnd)
  end
  nS = 1
  sI = F:read()
end
if(sO:len() > 0) then
  F:seek("set",0)
  F:write(sO)
  F:flush()
end
F:close()

print("Success !")
