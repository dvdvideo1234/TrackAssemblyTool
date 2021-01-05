-- Test in CMD:
-- ..\..\bin\lua.exe go.lua "E:\Documents\Lua-Projs\SVN\TrackAssemblyTool_GIT_master\lua\autorun\trackassembly_init.lua" "Rev." "UNX"
-- Call in CMD: Script { LUA_PATH, LOG_FILE }
-- Work: pre-commit.bat E:\Documents\Lua-Projs\Lua\Bin D:\WindowsTemp\tmp.txt
-- Home:

local fSta = "------------------ %s ------------------\n"
local fVer = "asmlib.SetOpVar%s*%(%s*\"TOOL_VERSION\"%s*,%s*\"%d+%.%d+\"%s*%)"
local fNum = "%s*%d+%s*%.%s*%d+%s*"
local tEnd = {["DOS"]="\r\n", ["UNX"]="\n"}

function trim(s) return s:match("^%s*(.-)%s*$") end

local sLog = tostring(arg[4]):gsub("\\","/")

local fLog, sE = io.open(sLog,"a+")
if(fLog) then io.output(fLog) else io.output("Error: "..sE) end

io.write(fSta:format("START"))

local sBas = tostring(arg[1]):gsub("\\","/")
      sBas = ((sBas:sub(-1,-1) == "/") and sBas or sBas.."/")
local sOut = tostring(arg[2])
local sEnd = tostring(arg[3])

io.write("arg[1]<"..sBas..">: Process file folder\n")
io.write("arg[2]<"..sOut..">: Process file name\n")
io.write("arg[3]<"..sEnd..">: Dos or unix\n")
io.write("arg[4]<"..sLog..">: Log file path\n")

if(tEnd[sEnd]) then sEnd = tEnd[sEnd]
else io.write("Line end mismatch ["..sEnd.."]\n"); return false end

local sInp = sBas.."tmp.lua"
local fInp = io.open(sInp,"rb")
if(fInp) then io.write("Inp: ["..sInp.."]\n")
else io.write("File ["..sInp.."] not found\n"); return false end

local sOut = sBas..sOut
local fOut = io.open(sOut,"wb")
if(fOut) then io.write("Out: ["..sOut.."]\n")
else io.write("File ["..sOut.."] not found\n"); return false end

-- Read first line
local sI = fInp:read("*line"); if(not sI) then -- Line by line
  io.write("File "..sInp.." reached EOF\n"); return false end

io.write(fSta:format("PROCESS"))

local nL = 1-- Process file
while(sI) do
  local nB, nE = sI:find(fVer)
  if(nB and nE) then
    io.write("Version found at line ["..nL.."]\n")
    local vB, vE = sI:find(fNum)
    if(vB and vE) then
      print(sI:sub(vB, vE))
      local nD = sI:sub(vB, vE):find(".", 1, true)
      if(nD) then
        local sW = trim(sI:sub(vB, vB + nD - 2))
        local sF = trim(sI:sub(vB + nD, vE))
        io.write("Version > ["..sW.."]["..sF.."]\n")
        sF = tostring(tonumber(sF) + 1)
        sI = sI:sub(1,vB-1)..sW.."."..sF..sI:sub(vE+1,-1)
        io.write("Extract > ["..sF.."]\n")
      end
    end
  end
  nL = nL + 1
  fOut:write(sI,sEnd)
  sI = fInp:read("*line")
end
io.write(fSta:format("FINISH"))
fOut:flush()
fOut:close()
fInp:close()

if(fLog) then
  fLog:flush()
  fLog:close()
end
