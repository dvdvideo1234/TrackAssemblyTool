-- Test in CMD:
-- ..\..\bin\lua.exe go.lua "E:\Documents\Lua-Projs\SVN\TrackAssemblyTool_GIT_master\lua\autorun\trackassembly_init.lua" "Rev." "UNX"
-- Call in CMD: Script { LUA_PATH, LOG_FILE }
-- Work: E:\Documents\Lua-Projs\SVN\TrackAssemblyTool_GIT_master\hooks\pre-commit.bat E:\Documents\Lua-Projs\Lua\Bin\ E:\Desktop\tmp.txt
-- Home:

local sLog = tostring(arg[4]) -- "test.lua"
if((sLog == "nil") or (string.len(sLog) == 0)) then
  io.write("No output log file")
else
  sLog = sLog:gsub("\\","/")
  fLog = io.open(sLog,"a+")
  if(fLog) then io.output(fLog) end
end

io.write("------------------ ARG ------------------\n")
io.write("arg[1]<"..tostring(arg[1])..">\n")
io.write("arg[2]<"..tostring(arg[2])..">\n")
io.write("arg[3]<"..tostring(arg[3])..">\n")
io.write("arg[4]<"..tostring(arg[4])..">\n")
local sBase = tostring(arg[1])
      sBase = sBase:gsub("\\","/")
if((sBase == "nil") or (string.len(sBase) == 0)) then
  io.write("No file\n")
  return false
end
io.write("------------------ FILE ------------------\n")
local sOut = tostring(arg[2]) -- "test.lua"
if((sOut == "nil") or (string.len(sOut) == 0)) then
  io.write("No output file")
  return false
end
local sOut = sBase..sOut
local sInp = sBase.."tmp.lua"
io.write("<"..sOut..">\n<"..sInp..">\n")
io.write("------------------ END ------------------\n")
local sEnd = tostring(arg[3])
if((sEnd == "nil") or (string.len(sEnd) == 0)) then
  io.write("No end-line\n")
  return false
end
if(not (sEnd == "DOS" or sEnd == "UNX")) then
  io.write("Wrong end line mode: -"..sEnd.."-\n")
  return false
end
if(sEnd == "DOS") then sEnd = "\r\n" end
if(sEnd == "UNX") then sEnd = "\n"   end
io.write("------------------ OPEN FILE ------------------\n")
local fOut = io.open(sOut,"wb")
local fInp = io.open(sInp,"rb")
if(not fOut) then
  io.write("File "..sOut.." not found\n")
  return false
end
if(not fInp) then
  io.write("File "..sInp.." not found\n")
  return false
end
io.write("------------------ STORE ------------------\n")
local sI = fInp:read()
if(not sI) then
  io.write("File "..sInp.." reached EOF\n")
  return false
end
local sO, sCat = "", ""
local sLog = "asmlib.SetLogControl("
local sVer = "asmlib.SetOpVar(\"TOOL_VERSION\",\"5."
local nB, nE, nS, nL, sL = 1, 1, 1, 1, ""
while(sI) do
  sL = "["..tostring(nL).."]"
  nB, nE = sI:find(sLog,1,true)
  if(nB and nE) then
    sCat = "0,\"\")"
    io.write("Disable logs"..sL.."[1]:Found at <"..tostring(nB).."> to <"..tostring(nE).."> end <"..sCat..">\n")
    nB = sI:find(",",1,true)
    if(nB and tonumber(sI:sub(nE+1,nB-1))) then
      io.write("Disable logs"..sL.."[2]:Number at <"..tostring(nB).."> string <"..tostring(sI:sub(nE+1,nB-1)).."> to <"..tonumber(sI:sub(nE+1,nB-1)).."> Updated !\n")
      sI = sLog..sCat
    end
  end
  nB, nE = sI:find(sVer,1,true)
  if(nB and nE) then
    sCat = "\")"
    io.write("Increment the version"..sL.."[1]: Found at <"..tostring(nB).."> to <"..tostring(nE).."> end <"..sCat..">\n")
    nB = sI:find(sCat,1,true)
    if(nB) then
      nS = tonumber(sI:sub(nE+1,nB-1))
      io.write("Increment the version"..sL.."[2]: String <"..tostring(sI:sub(nE+1,nB-1)).."> to <"..tostring(nS)..">\n")
      if(nS) then
        io.write("Increment the version"..sL.."[3]: Increment <"..tostring(nS+1).."> Updated !\n")
        sI = sVer..tostring(nS+1)..sCat
      end
    end
  end; nL = nL + 1
  fOut:write(sI,sEnd)
  sI = fInp:read()
end
io.write("------------------ FINISH ------------------\n")
fOut:flush()
fOut:close()
fInp:close()

if(fLog) then
  fLog:flush()
  fLog:close()
end


