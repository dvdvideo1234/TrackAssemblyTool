local cvX, cvY, cvZ -- Vector Component indexes
local caP, caY, caR -- Angle Component indexes
local wvX, wvY, wvZ -- Wire vector Component indexes
local waP, waY, waR -- Wire angle Component indexes

---------------- Localizing instances ------------------

local SERVER = SERVER
local CLIENT = CLIENT

---------------- Localizing Player keys ----------------

local IN_ALT1      = IN_ALT1
local IN_ALT2      = IN_ALT2
local IN_ATTACK    = IN_ATTACK
local IN_ATTACK2   = IN_ATTACK2
local IN_BACK      = IN_BACK
local IN_DUCK      = IN_DUCK
local IN_FORWARD   = IN_FORWARD
local IN_JUMP      = IN_JUMP
local IN_LEFT      = IN_LEFT
local IN_MOVELEFT  = IN_MOVELEFT
local IN_MOVERIGHT = IN_MOVERIGHT
local IN_RELOAD    = IN_RELOAD
local IN_RIGHT     = IN_RIGHT
local IN_SCORE     = IN_SCORE
local IN_SPEED     = IN_SPEED
local IN_USE       = IN_USE
local IN_WALK      = IN_WALK
local IN_ZOOM      = IN_ZOOM

---------------- Localizing ENT Properties ----------------

local MASK_SOLID            = MASK_SOLID
local SOLID_VPHYSICS        = SOLID_VPHYSICS
local SOLID_NONE            = SOLID_NONE
local MOVETYPE_VPHYSICS     = MOVETYPE_VPHYSICS
local MOVETYPE_NONE         = MOVETYPE_NONE
local COLLISION_GROUP_NONE  = COLLISION_GROUP_NONE
local RENDERMODE_TRANSALPHA = RENDERMODE_TRANSALPHA

---------------- Localizing needed functions ----------------

local next                    = next
local type                    = type
local pcall                   = pcall
local Angle                   = Angle
local Color                   = Color
local pairs                   = pairs
local print                   = print
local tobool                  = tobool
local Vector                  = Vector
local Matrix                  = Matrix
local unpack                  = unpack
local include                 = include
local IsValid                 = IsValid
local Material                = Material
local require                 = require
local Time                    = CurTime
local tonumber                = tonumber
local tostring                = tostring
local GetConVar               = GetConVar
local LocalPlayer             = LocalPlayer
local CreateConVar             = CreateConVar
local SetClipboardText         = SetClipboardText
local CompileString            = CompileString
local getmetatable             = getmetatable
local setmetatable             = setmetatable
local collectgarbage           = collectgarbage
local osClock                  = os and os.clock
local osDate                   = os and os.date
local bitBand                  = bit and bit.band
local sqlQuery                 = sql and sql.Query
local sqlLastError             = sql and sql.LastError
local sqlTableExists           = sql and sql.TableExists
local gameSinglePlayer         = game and game.SinglePlayer
local utilTraceLine            = util and util.TraceLine
local utilIsInWorld            = util and util.IsInWorld
local utilIsValidModel         = util and util.IsValidModel
local utilGetPlayerTrace       = util and util.GetPlayerTrace
local entsCreate               = ents and ents.Create
local entsCreateClientProp     = ents and ents.CreateClientProp
local fileOpen                 = file and file.Open
local fileExists               = file and file.Exists
local fileAppend               = file and file.Append
local fileDelete               = file and file.Delete
local fileCreateDir            = file and file.CreateDir
local mathPi                   = math and math.pi
local mathAbs                  = math and math.abs
local mathSin                  = math and math.sin
local mathCos                  = math and math.cos
local mathCeil                 = math and math.ceil
local mathModf                 = math and math.modf
local mathSqrt                 = math and math.sqrt
local mathFloor                = math and math.floor
local mathClamp                = math and math.Clamp
local mathRandom               = math and math.random
local undoCreate               = undo and undo.Create
local undoFinish               = undo and undo.Finish
local undoAddEntity            = undo and undo.AddEntity
local undoSetPlayer            = undo and undo.SetPlayer
local undoSetCustomUndoText    = undo and undo.SetCustomUndoText
local timerStop                = timer and timer.Stop
local timerStart               = timer and timer.Start
local timerSimple              = timer and timer.Simple
local timerExists              = timer and timer.Exists
local timerCreate              = timer and timer.Create
local timerDestroy             = timer and timer.Destroy
local tableEmpty               = table and table.Empty
local tableMaxn                = table and table.maxn
local tableGetKeys             = table and table.GetKeys
local tableInsert              = table and table.insert
local tableCopy                = table and table.Copy
local debugGetinfo             = debug and debug.getinfo
local renderDrawLine           = render and render.DrawLine
local renderDrawSphere         = render and render.DrawSphere
local renderSetMaterial        = render and render.SetMaterial
local surfaceSetFont           = surface and surface.SetFont
local surfaceDrawLine          = surface and surface.DrawLine
local surfaceDrawText          = surface and surface.DrawText
local surfaceDrawCircle        = surface and surface.DrawCircle
local surfaceSetTexture        = surface and surface.SetTexture
local surfaceSetTextPos        = surface and surface.SetTextPos
local surfaceGetTextSize       = surface and surface.GetTextSize
local surfaceGetTextureID      = surface and surface.GetTextureID
local surfaceSetDrawColor      = surface and surface.SetDrawColor
local surfaceSetTextColor      = surface and surface.SetTextColor
local surfaceDrawTexturedRect  = surface and surface.DrawTexturedRect
local languageAdd              = language and language.Add
local constructSetPhysProp     = construct and construct.SetPhysProp
local constraintWeld           = constraint and constraint.Weld
local constraintNoCollide      = constraint and constraint.NoCollide
local cvarsAddChangeCallback   = cvars and cvars.AddChangeCallback
local cvarsRemoveChangeCallback = cvars and cvars.RemoveChangeCallback
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier

---------------- CASHES SPACE --------------------

local libCache  = {} -- Used to cache stuff in a pool
local libAction = {} -- Used to attach external function to the lib
local libOpVars = {} -- Used to Store operational variable values
local libPlayer = {} -- Used to allocate personal space for players
local libQTable = {} -- Used to allocate SQL table builder objects

module("trackasmlib")

---------------------------- PRIMITIVES ----------------------------

function GetInstPref()
  if    (CLIENT) then return "cl_"
  elseif(SERVER) then return "sv_" end
  return "na_"
end

function GetOpVar(sName)
  return libOpVars[sName]
end

function SetOpVar(sName, vVal)
  libOpVars[sName] = vVal
end

function IsHere(vVal)
  return (vVal ~= nil)
end

function IsString(vVal)
  return (getmetatable(vVal) == GetOpVar("TYPEMT_STRING"))
end

function IsBlank(vVal)
  if(not IsString(vVal)) then return false end
  return (vVal == "")
end

function IsBool(vVal)
  if    (vVal == true ) then return true
  elseif(vVal == false) then return true end
  return false
end

function IsNumber(vVal)
  return ((tonumber(vVal) and true) or false)
end

function IsTable(vVal)
  return (type(vVal) == "table")
end

function IsFunction(vVal)
  return (type(vVal) == "function")
end

function IsPlayer(oPly)
  if(not IsHere(oPly)) then return false end
  if(not oPly:IsValid  ()) then return false end
  if(not oPly:IsPlayer ()) then return false end
  return true
end

function IsOther(oEnt)
  if(not IsHere(oEnt))   then return true end
  if(not oEnt:IsValid()) then return true end
  if(oEnt:IsPlayer())    then return true end
  if(oEnt:IsVehicle())   then return true end
  if(oEnt:IsNPC())       then return true end
  if(oEnt:IsRagdoll())   then return true end
  if(oEnt:IsWeapon())    then return true end
  if(oEnt:IsWidget())    then return true end
  return false
end

-- Gets the date according to the specified format
function GetDate()
  return (osDate(GetOpVar("DATE_FORMAT"))
   .." "..osDate(GetOpVar("TIME_FORMAT")))
end

-- Strips a string from quotes
function GetStrip(vV, vQ)
  local sV = tostring(vV or ""):Trim()
  local sQ = tostring(vQ or "\""):sub(1,1)
  if(sV:sub( 1, 1) == sQ) then sV = sV:sub(2,-1) end
  if(sV:sub(-1,-1) == sQ) then sV = sV:sub(1,-2) end
  return sV:Trim()
end

------------------ LOGS ------------------------

local function GetLogID()
  local nNum, nMax = GetOpVar("LOG_CURLOGS"), GetOpVar("LOG_MAXLOGS")
  if(not (nNum and nMax)) then return "" end
  return ("%"..(tostring(mathFloor(nMax))):len().."d"):format(nNum)
end

local function Log(vMsg, bCon)
  local iMax = GetOpVar("LOG_MAXLOGS")
  if(iMax <= 0) then return end
  local iCur = GetOpVar("LOG_CURLOGS") + 1
  local sLast, sData = GetOpVar("LOG_LOGLAST"), tostring(vMsg)
  if(sLast == sData) then return end
  SetOpVar("LOG_LOGLAST",sData); SetOpVar("LOG_CURLOGS",iCur)
  if(GetOpVar("LOG_LOGFILE") and not bCon) then
    local lbNam = GetOpVar("NAME_LIBRARY")
    local fName = GetOpVar("DIRPATH_BAS")..lbNam.."_log.txt"
    if(iCur > iMax) then iCur = 0; fileDelete(fName) end
    fileAppend(fName,GetLogID().." ["..GetDate().."] "..sData.."\n")
  else -- The current has values 1..nMaxLogs(0)
    if(iCur > iMax) then iCur = 0 end
    print(GetLogID().." ["..GetDate().."] "..sData)
  end
end

--[[
  vMsg  > Message being displayed
  bCon  > Force output in console flag
  tDbg  > Debug table overrive
  vData > Name of the sub-routine call
]]
function LogInstance(vMsg, bCon, tDbg, vData)
  local nMax = (tonumber(GetOpVar("LOG_MAXLOGS")) or 0)
  if(nMax and (nMax <= 0)) then return end
  local sMsg, oStat = tostring(vMsg), GetOpVar("LOG_SKIP")
  if(oStat and oStat[1]) then
    local iCnt = 1; while(oStat[iCnt]) do
      if(sMsg:find(tostring(oStat[iCnt]))) then return end; iCnt = iCnt + 1 end
  end; oStat = GetOpVar("LOG_ONLY") -- Should the current log being skipped
  if(oStat and oStat[1]) then
    local iCnt, logMe = 1, false; while(oStat[iCnt]) do
      if(sMsg:find(tostring(oStat[iCnt]))) then logMe = true end; iCnt = iCnt + 1 end
    if(not logMe) then return end -- Only the chosen messages are processed
  end; local sDbg, tInfo = "", ((tDbg or debugGetinfo(2)) or {})
  local sFunc = (tInfo.name and tInfo.name or "Main")
  if(GetOpVar("LOG_DEBUGEN")) then
    local snID, snAV = GetOpVar("MISS_NOID"), GetOpVar("MISS_NOAV")
    sDbg = sDbg.." "..(tInfo.linedefined and "["..tInfo.linedefined.."]" or snAV)
    sDbg = sDbg..(tInfo.currentline and ("["..tInfo.currentline.."]") or snAV)
    sDbg = sDbg.."@"..(tInfo.source and (tInfo.source:gsub("^%W+", ""):gsub("\\","/")) or snID)
  end; local sData = (vData and tostring(vData).."." or "")
  local sInst   = ((SERVER and "SERVER" or nil) or (CLIENT and "CLIENT" or nil) or "NOINST")
  local sMoDB, sToolMD = tostring(GetOpVar("MODE_DATABASE")), tostring(GetOpVar("TOOLNAME_NU"))
  Log(sInst.." > "..sToolMD.." ["..sMoDB.."]"..sDbg.." "..sData..sFunc..": "..sMsg, bCon)
end

function Print(tT,sS,tP)
  local vS, vT, vK, sS = type(sS), type(tT), "", tostring(sS or "Data")
  if(vT ~= "table") then
    LogInstance("{"..vT.."}["..sS.."] = <"..tostring(tT)..">"); return nil end
  if(next(tT) == nil) then
    LogInstance(sS.." = {}"); return nil end; LogInstance(sS.." = {}")
  for k,v in pairs(tT) do
    if(type(k) == "string") then
      vK = sS.."[\""..k.."\"]"
    else sK = tostring(k)
      if(tP and tP[k]) then sK = tostring(tP[k]) end
      vK = sS.."["..sK.."]"
    end
    if(type(v) ~= "table") then
      if(type(v) == "string") then
        LogInstance(vK.." = \""..v.."\"")
      else sK = tostring(v)
        if(tP and tP[v]) then sK = tostring(tP[v]) end
        LogInstance(vK.." = "..sK)
      end
    else
      if(v == tT) then LogInstance(vK.." = "..sS)
      else Print(v,vK,tP) end
    end
  end
end

----------------- INITAIALIZATION -----------------

-- Golden retriever. Retrieves file line as string
-- But seriously returns the sting line and EOF flag
local function GetStringFile(pFile)
  if(not pFile) then LogInstance("No file"); return "", true end
  local sCh, sLine = "X", "" -- Use a value to start cycle with
  while(sCh) do sCh = pFile:Read(1); if(not sCh) then break end
    if(sCh == "\n") then return sLine:Trim(), false else sLine = sLine..sCh end
  end; return sLine:Trim(), true -- EOF has been reached. Return the last data
end

function SetLogControl(nLines,bFile)
  SetOpVar("LOG_CURLOGS",0)
  SetOpVar("LOG_LOGFILE",tobool(bFile))
  SetOpVar("LOG_MAXLOGS",mathFloor(tonumber(nLines) or 0))
  local sBas = GetOpVar("DIRPATH_BAS")
  local sMax = tostring(GetOpVar("LOG_MAXLOGS"))
  local sNam = tostring(GetOpVar("LOG_LOGFILE"))
  if(sBas and not fileExists(sBas,"DATA") and
     not IsBlank(GetOpVar("LOG_LOGFILE"))) then fileCreateDir(sBas)
  end; LogInstance("("..sMax..","..sNam..")",true)
end

function SettingsLogs(sHash)
  local sKey = tostring(sHash or ""):upper():Trim()
  if(not (sKey == "SKIP" or sKey == "ONLY")) then
    LogInstance("Invalid <"..sKey..">"); return false end
  local tLogs, lbNam = GetOpVar("LOG_"..sKey), GetOpVar("NAME_LIBRARY")
  if(not tLogs) then LogInstance("Skip <"..sKey..">"); return false end
  local fName = GetOpVar("DIRPATH_BAS")..lbNam.."_sl"..sKey:lower()..".txt"
  local S = fileOpen(fName, "rb", "DATA"); tableEmpty(tLogs)
  if(S) then local sLine, isEOF = "", false
    while(not isEOF) do sLine, isEOF = GetStringFile(S)
      if(not IsBlank(sLine)) then tableInsert(tLogs, sLine) end
    end; S:Close(); LogInstance("Success <"..sKey.."/"..fName..">"); return false
  else LogInstance("Missing <"..sKey.."/"..fName..">"); return false end
end

function GetIndexes(sType)
  if(not IsString(sType)) then
    LogInstance("Type {"..type(sType).."}<"..tostring(sType).."> not string"); return nil end
  if    (sType == "V")  then return cvX, cvY, cvZ
  elseif(sType == "A")  then return caP, caY, caR
  elseif(sType == "WA") then return wvX, wvY, wvZ
  elseif(sType == "WV") then return waP, waY, waR
  else LogInstance("Type <"..sType.."> not found"); return nil end
end

function SetIndexes(sType,...)
  if(not IsString(sType)) then
    LogInstance("Type {"..type(sType).."}<"..tostring(sType).."> not string"); return false end
  if    (sType == "V")  then cvX, cvY, cvZ = ...
  elseif(sType == "A")  then caP, caY, caR = ...
  elseif(sType == "WA") then wvX, wvY, wvZ = ...
  elseif(sType == "WV") then waP, waY, waR = ...
  else LogInstance("Type <"..sType.."> not found"); return false end
  LogInstance("Success"); return true
end

function UseIndexes(pB1,pB2,pB3,pD1,pD2,pD3)
  return (pB1 or pD1), (pB2 or pD2), (pB3 or pD3)
end

function InitBase(sName,sPurpose)
  SetOpVar("TYPEMT_STRING",getmetatable("TYPEMT_STRING"))
  SetOpVar("TYPEMT_SCREEN",{})
  SetOpVar("TYPEMT_CONTAINER",{})
  if(not IsString(sName)) then
    LogInstance("Name <"..tostring(sName).."> not string", true); return false end
  if(not IsString(sPurpose)) then
    LogInstance("Purpose <"..tostring(sPurpose).."> not string", true); return false end
  if(IsBlank(sName) or tonumber(sName:sub(1,1))) then
    LogInstance("Name invalid <"..sName..">", true); return false end
  if(IsBlank(sPurpose) or tonumber(sPurpose:sub(1,1))) then
    LogInstance("Purpose invalid <"..sPurpose..">", true); return false end
  SetOpVar("TIME_INIT",Time())
  SetOpVar("LOG_MAXLOGS",0)
  SetOpVar("LOG_CURLOGS",0)
  SetOpVar("LOG_SKIP",{})
  SetOpVar("LOG_ONLY",{})
  SetOpVar("LOG_LOGFILE","")
  SetOpVar("LOG_LOGLAST","")
  SetOpVar("MAX_ROTATION",360)
  SetOpVar("DELAY_FREEZE",0.01)
  SetOpVar("ANG_ZERO",Angle())
  SetOpVar("VEC_ZERO",Vector())
  SetOpVar("ANG_REV",Angle(0,180,0))
  SetOpVar("VEC_FW",Vector(1,0,0))
  SetOpVar("VEC_RG",Vector(0,-1,1))
  SetOpVar("VEC_UP",Vector(0,0,1))
  SetOpVar("OPSYM_DISABLE","#")
  SetOpVar("OPSYM_REVISION","@")
  SetOpVar("OPSYM_DIVIDER","_")
  SetOpVar("OPSYM_DIRECTORY","/")
  SetOpVar("OPSYM_SEPARATOR",",")
  SetOpVar("OPSYM_ENTPOSANG","!")
  SetOpVar("DEG_RAD", mathPi / 180)
  SetOpVar("EPSILON_ZERO", 1e-5)
  SetOpVar("COLOR_CLAMP", {0, 255})
  SetOpVar("GOLDEN_RATIO",1.61803398875)
  SetOpVar("DATE_FORMAT","%d-%m-%y")
  SetOpVar("TIME_FORMAT","%H:%M:%S")
  SetOpVar("NAME_INIT",sName:lower())
  SetOpVar("NAME_PERP",sPurpose:lower())
  SetOpVar("NAME_LIBRARY", GetOpVar("NAME_INIT").."asmlib")
  SetOpVar("TOOLNAME_NL",(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")):lower())
  SetOpVar("TOOLNAME_NU",(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")):upper())
  SetOpVar("TOOLNAME_PL",GetOpVar("TOOLNAME_NL").."_")
  SetOpVar("TOOLNAME_PU",GetOpVar("TOOLNAME_NU").."_")
  SetOpVar("DIRPATH_BAS",GetOpVar("TOOLNAME_NL")..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_INS","exp"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_DSV","dsv"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("MISS_NOID","N")    -- No ID selected
  SetOpVar("MISS_NOAV","N/A")  -- Not Available
  SetOpVar("MISS_NOMD","X")    -- No model
  SetOpVar("ARRAY_DECODEPOA",{0,0,0})
  if(CLIENT) then
    SetOpVar("ARRAY_GHOST",{Size=0, Slot=GetOpVar("MISS_NOMD")})
    SetOpVar("LOCALIFY_AUTO","en")
    SetOpVar("LOCALIFY_TABLE",{})
    SetOpVar("TABLE_CATEGORIES",{})
    SetOpVar("STRUCT_SPAWN",{
      {"--- Origin ---"},
      {"F"     ,"VEC", "Forward direction"},
      {"R"     ,"VEC", "Right direction"},
      {"U"     ,"VEC", "Up direction"},
      {"OPos"  ,"VEC", "Origin position"},
      {"OAng"  ,"ANG", "Origin angles"},
      {"SPos"  ,"VEC", "Spawn position"},
      {"SAng"  ,"ANG", "Spawn angles"},
      {"RLen"  ,"FLT", "Active radius"},
      {"--- Holder ---"},
      {"HID"   ,"INT", "Point ID"},
      {"HPnt"  ,"VEC", "Search location"},
      {"HOrg"  ,"VEC", "Custom offset"},
      {"HAng"  ,"ANG", "Custom angles"},
      {"--- Traced ---"},
      {"TID"   ,"INT", "Point ID"},
      {"TPnt"  ,"VEC", "Search location"},
      {"TOrg"  ,"VEC", "Custom offset"},
      {"TAng"  ,"ANG", "Custom angles"},
      {"--- Offset ---"},
      {"PNxt"  ,"VEC", "Custom user position"},
      {"ANxt"  ,"ANG", "Custom user angles"}})
  end
  SetOpVar("MODELNAM_FILE","%.mdl")
  SetOpVar("MODELNAM_FUNC",function(x) return " "..x:sub(2,2):upper() end)
  SetOpVar("QUERY_STORE", {})
  SetOpVar("TABLE_BORDERS",{})
  SetOpVar("ENTITY_DEFCLASS", "prop_physics")
  SetOpVar("TABLE_FREQUENT_MODELS",{})
  SetOpVar("OOP_DEFAULTKEY","(!@<#_$|%^|&>*)DEFKEY(*>&|^%|$_#<@!)")
  SetOpVar("CVAR_LIMITNAME","asm"..GetOpVar("NAME_INIT").."s")
  SetOpVar("MODE_DATABASE",GetOpVar("MISS_NOAV"))
  SetOpVar("HASH_USER_PANEL",GetOpVar("TOOLNAME_PU").."USER_PANEL")
  SetOpVar("HASH_PROPERTY_NAMES","PROPERTY_NAMES")
  SetOpVar("HASH_PROPERTY_TYPES","PROPERTY_TYPES")
  SetOpVar("TRACE_CLASS", {[GetOpVar("ENTITY_DEFCLASS")]=true})
  SetOpVar("TRACE_DATA",{ -- Used for general trace result storage
    start  = Vector(),    -- Start position of the trace
    endpos = Vector(),    -- End position of the trace
    mask   = MASK_SOLID,  -- Mask telling it what to hit
    filter = function(oEnt) -- Only valid props which are not the main entity or world or TRACE_FILTER ( if set )
      if(oEnt and oEnt:IsValid() and oEnt ~= GetOpVar("TRACE_FILTER") and
        GetOpVar("TRACE_CLASS")[oEnt:GetClass()]) then return true end end })
  SetOpVar("RAY_INTERSECT",{}) -- General structure for handling rail crosses and curves
  LogInstance("Success"); return true
end

------------- COLOR ---------------

function FixColor(nC)
  local tC = GetOpVar("COLOR_CLAMP")
  return mathFloor(mathClamp(tonumber(nC) or 0, tC[1], tC[2]))
end

function GetColor(xR, xG, xB, xA)
  local nR, nG = FixColor(xR), FixColor(xG)
  local nB, nA = FixColor(xB), FixColor(xA)
  return Color(nR, nG, nB, nA)
end

function ToColor(vBase, pX, pY, pZ, vA)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  local iX, iY, iZ = UseIndexes(pX, pY, pZ, cvX, cvY, cvZ)
  return GetColor(vBase[iX], vBase[iY], vBase[iZ], vA)
end

------------- ANGLE ---------------

function ToAngle(aBase, pP, pY, pR)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  local aP, aY, aR = UseIndexes(pP, pY, pR, caP, caY, caR)
  return Angle((tonumber(aBase[aP]) or 0), (tonumber(aBase[aY]) or 0), (tonumber(aBase[aR]) or 0))
end

function ExpAngle(aBase, pP, pY, pR)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  local aP, aY, aR = UseIndexes(pP, pY, pR, caP, caY, caR)
  return (tonumber(aBase[aP]) or 0), (tonumber(aBase[aY]) or 0), (tonumber(aBase[aR]) or 0)
end

function AddAngle(aBase, aUnit)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  if(not aUnit) then LogInstance("Unit invalid"); return nil end
  aBase[caP] = (tonumber(aBase[caP]) or 0) + (tonumber(aUnit[caP]) or 0)
  aBase[caY] = (tonumber(aBase[caY]) or 0) + (tonumber(aUnit[caY]) or 0)
  aBase[caR] = (tonumber(aBase[caR]) or 0) + (tonumber(aUnit[caR]) or 0)
end

function AddAnglePYR(aBase, nP, nY, nR)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  aBase[caP] = (tonumber(aBase[caP]) or 0) + (tonumber(nP) or 0)
  aBase[caY] = (tonumber(aBase[caY]) or 0) + (tonumber(nY) or 0)
  aBase[caR] = (tonumber(aBase[caR]) or 0) + (tonumber(nR) or 0)
end

function SubAngle(aBase, aUnit)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  if(not aUnit) then LogInstance("Unit invalid"); return nil end
  aBase[caP] = (tonumber(aBase[caP]) or 0) - (tonumber(aUnit[caP]) or 0)
  aBase[caY] = (tonumber(aBase[caY]) or 0) - (tonumber(aUnit[caY]) or 0)
  aBase[caR] = (tonumber(aBase[caR]) or 0) - (tonumber(aUnit[caR]) or 0)
end

function SubAnglePYR(aBase, nP, nY, nR)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  aBase[caP] = (tonumber(aBase[caP]) or 0) - (tonumber(nP) or 0)
  aBase[caY] = (tonumber(aBase[caY]) or 0) - (tonumber(nY) or 0)
  aBase[caR] = (tonumber(aBase[caR]) or 0) - (tonumber(nR) or 0)
end

function NegAngle(vBase, bP, bY, bR)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  local P = (tonumber(vBase[caP]) or 0); P = (IsHere(bP) and (bP and -P or P) or -P)
  local Y = (tonumber(vBase[caY]) or 0); Y = (IsHere(bY) and (bY and -Y or Y) or -Y)
  local R = (tonumber(vBase[caR]) or 0); R = (IsHere(bR) and (bR and -R or R) or -R)
  vBase[caP], vBase[caY], vBase[caR] = P, Y, R
end

function SetAngle(aBase, aUnit)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  if(not aUnit) then LogInstance("Unit invalid"); return nil end
  aBase[caP] = (tonumber(aUnit[caP]) or 0)
  aBase[caY] = (tonumber(aUnit[caY]) or 0)
  aBase[caR] = (tonumber(aUnit[caR]) or 0)
end

function SetAnglePYR(aBase, nP, nY, nR)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  aBase[caP] = (tonumber(nP) or 0)
  aBase[caY] = (tonumber(nY) or 0)
  aBase[caR] = (tonumber(nR) or 0)
end

------------- VECTOR ---------------

function ToVector(vBase, pX, pY, pZ)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  local vX, vY, vZ = UseIndexes(pX, pY, pZ, cvX, cvY, cvZ)
  return Vector((tonumber(vBase[vX]) or 0), (tonumber(vBase[vY]) or 0), (tonumber(vBase[vZ]) or 0))
end

function ExpVector(vBase, pX, pY, pZ)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  local vX, vY, vZ = UseIndexes(pX, pY, pZ, cvX, cvY, cvZ)
  return (tonumber(vBase[vX]) or 0), (tonumber(vBase[vY]) or 0), (tonumber(vBase[vZ]) or 0)
end

function GetLengthVector(vBase)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  local X = (tonumber(vBase[cvX]) or 0); X = X * X
  local Y = (tonumber(vBase[cvY]) or 0); Y = Y * Y
  local Z = (tonumber(vBase[cvZ]) or 0); Z = Z * Z
  return mathSqrt(X + Y + Z)
end

function RoundVector(vBase,nvRound)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  local R = tonumber(nvRound); if(not IsHere(R)) then
    LogInstance("Round NAN {"..type(nvRound).."}<"..tostring(nvRound)..">"); return nil end
  local X = (tonumber(vBase[cvX]) or 0); X = RoundValue(X,R); vBase[cvX] = X
  local Y = (tonumber(vBase[cvY]) or 0); Y = RoundValue(Y,R); vBase[cvY] = Y
  local Z = (tonumber(vBase[cvZ]) or 0); Z = RoundValue(Z,R); vBase[cvZ] = Z
end

function AddVector(vBase, vUnit)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  if(not vUnit) then LogInstance("Unit invalid"); return nil end
  vBase[cvX] = (tonumber(vBase[cvX]) or 0) + (tonumber(vUnit[cvX]) or 0)
  vBase[cvY] = (tonumber(vBase[cvY]) or 0) + (tonumber(vUnit[cvY]) or 0)
  vBase[cvZ] = (tonumber(vBase[cvZ]) or 0) + (tonumber(vUnit[cvZ]) or 0)
end

function AddVectorXYZ(vBase, nX, nY, nZ)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  vBase[cvX] = (tonumber(vBase[cvX]) or 0) + (tonumber(nX) or 0)
  vBase[cvY] = (tonumber(vBase[cvY]) or 0) + (tonumber(nY) or 0)
  vBase[cvZ] = (tonumber(vBase[cvZ]) or 0) + (tonumber(nZ) or 0)
end

function SubVector(vBase, vUnit)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  if(not vUnit) then LogInstance("Unit invalid"); return nil end
  vBase[cvX] = (tonumber(vBase[cvX]) or 0) - (tonumber(vUnit[cvX]) or 0)
  vBase[cvY] = (tonumber(vBase[cvY]) or 0) - (tonumber(vUnit[cvY]) or 0)
  vBase[cvZ] = (tonumber(vBase[cvZ]) or 0) - (tonumber(vUnit[cvZ]) or 0)
end

function SubVectorXYZ(vBase, nX, nY, nZ)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  vBase[cvX] = (tonumber(vBase[cvX]) or 0) - (tonumber(nX) or 0)
  vBase[cvY] = (tonumber(vBase[cvY]) or 0) - (tonumber(nY) or 0)
  vBase[cvZ] = (tonumber(vBase[cvZ]) or 0) - (tonumber(nZ) or 0)
end

function NegVector(vBase, bX, bY, bZ)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  local X = (tonumber(vBase[cvX]) or 0); X = (IsHere(bX) and (bX and -X or X) or -X)
  local Y = (tonumber(vBase[cvY]) or 0); Y = (IsHere(bY) and (bY and -Y or Y) or -Y)
  local Z = (tonumber(vBase[cvZ]) or 0); Z = (IsHere(bZ) and (bZ and -Z or Z) or -Z)
  vBase[cvX], vBase[cvY], vBase[cvZ] = X, Y, Z
end

function SetVector(vBase, vUnit)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  if(not vUnit) then LogInstance("Unit invalid"); return nil end
  vBase[cvX] = (tonumber(vUnit[cvX]) or 0)
  vBase[cvY] = (tonumber(vUnit[cvY]) or 0)
  vBase[cvZ] = (tonumber(vUnit[cvZ]) or 0)
end

function SetVectorXYZ(vBase, nX, nY, nZ)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  vBase[cvX] = (tonumber(nX or 0))
  vBase[cvY] = (tonumber(nY or 0))
  vBase[cvZ] = (tonumber(nZ or 0))
end

function MulVectorXYZ(vBase, nX, nY, nZ)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  vBase[cvX] = vBase[cvX] * (tonumber(nX or 0))
  vBase[cvY] = vBase[cvY] * (tonumber(nY or 0))
  vBase[cvZ] = vBase[cvZ] * (tonumber(nZ or 0))
end

function DecomposeByAngle(vBase, aUnit)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  if(not aUnit) then LogInstance("Unit invalid"); return nil end
  local X = vBase:Dot(aUnit:Forward())
  local Y = vBase:Dot(aUnit:Right())
  local Z = vBase:Dot(aUnit:Up())
  SetVectorXYZ(vBase,X,Y,Z)
end

-------------- 2DVECTOR ----------------

function NewXY(nX, nY)
  return {x=(tonumber(nX) or 0), y=(tonumber(nY) or 0)}
end

function SetXY(xyR, xyA)
  if(not xyR) then LogInstance("Base R invalid"); return nil end
  if(not xyA) then LogInstance("Base A invalid"); return nil end
  local xA, yA = (tonumber(xyA.x) or 0), (tonumber(xyA.y) or 0)
  xyR.x, xyR.y = xA, yA; return xyR
end

function AddXY(xyR, xyA, xyB)
  if(not xyR) then LogInstance("Base R invalid"); return nil end
  if(not xyA) then LogInstance("Base A invalid"); return nil end
  if(not xyB) then LogInstance("Base B invalid"); return nil end
  local xA, yA = (tonumber(xyA.x) or 0), (tonumber(xyA.y) or 0)
  local xB, yB = (tonumber(xyB.x) or 0), (tonumber(xyB.y) or 0)
  xyR.x, xyR.y = (xA + xB), (yA + yB); return xyR
end

function SubXY(xyR, xyA, xyB)
  if(not xyR) then LogInstance("Base R invalid"); return nil end
  if(not xyA) then LogInstance("Base A invalid"); return nil end
  if(not xyB) then LogInstance("Base B invalid"); return nil end
  local xA, yA = (tonumber(xyA.x) or 0), (tonumber(xyA.y) or 0)
  local xB, yB = (tonumber(xyB.x) or 0), (tonumber(xyB.y) or 0)
  xyR.x, xyR.y = (xA - xB), (yA - yB); return xyR
end

function LenXY(xyA)
  if(not xyA) then LogInstance("Base A invalid"); return nil end
  local xA, yA = (tonumber(xyA.x) or 0), (tonumber(xyA.y) or 0)
  return mathSqrt(xA * xA + yA * yA)
end

function ExpXY(xyA)
  if(not xyA) then LogInstance("Base A invalid"); return nil end
  return (tonumber(xyA.x) or 0), (tonumber(xyA.y) or 0)
end

function RotateXY(xyV, nR)
  if(not xyV) then LogInstance("Base invalid"); return nil end
  local nA = (tonumber(nR) or 0)
  if(nA == 0) then return xyV end
  local nX = (tonumber(xyV.x) or 0)
  local nY = (tonumber(xyV.y) or 0)
  local nS, nC = mathSin(nA), mathCos(nA)
  xyV.x = (nX * nC - nY * nS)
  xyV.y = (nX * nS + nY * nC); return xyV
end

----------------- OOP ------------------

function MakeContainer(sInfo,sDefKey)
  local Curs, Data, self = 0, {}, {}
  local sSel, sIns, sDel, sMet = "", "", "", ""
  local Info = tostring(sInfo or "Storage container")
  local Key  = sDefKey or GetOpVar("OOP_DEFAULTKEY")
  function self:GetInfo() return Info end
  function self:GetSize() return Curs end
  function self:GetData() return Data end
  function self:Insert(nsKey,vVal)
    sIns = nsKey or Key; sMet = "I"
    if(not IsHere(Data[sIns])) then Curs = Curs + 1; end
    Data[sIns] = vVal
  end
  function self:Select(nsKey)
    sSel = nsKey or Key; return Data[sSel]
  end
  function self:Delete(nsKey,fnDel)
    sDel = nsKey or Key; sMet = "D"
    if(IsHere(Data[sDel])) then
      if(IsHere(fnDel)) then fnDel(Data[sDel]) end
      Curs, Data[sDel] = (Curs - 1), nil
    end
  end
  function self:GetHistory()
    return tostring(sMet)..GetOpVar("OPSYM_REVISION")..
           tostring(sSel)..GetOpVar("OPSYM_DIRECTORY")..
           tostring(sIns)..GetOpVar("OPSYM_DIRECTORY")..tostring(sDel)
  end
  setmetatable(self,GetOpVar("TYPEMT_CONTAINER"))
  return self
end

--[[
 * Creates a screen object better user API for drawing on the gmod screens
 * The drawing methods are the following:
 * SURF - Uses the surface library to draw directly
 * SEGM - Uses the surface library to draw line segment interpolations
 * CAM3 - Uses the render  library to draw shapes in 3D space
 * Operation keys for storing initial arguments are the following:
 * TXT - Drawing text
 * LIN - Drawing lines
 * REC - Drawing a rectangle
 * CIR - Drawing a circle
]]--
function MakeScreen(sW,sH,eW,eH,conColors)
  if(SERVER) then return nil end
  local sW, sH = (tonumber(sW) or 0), (tonumber(sH) or 0)
  local eW, eH = (tonumber(eW) or 0), (tonumber(eH) or 0)
  if(sW < 0 or sH < 0) then LogInstance("Start dimension invalid"); return nil end
  if(eW < 0 or eH < 0) then LogInstance("End dimension invalid"); return nil end
  local xyS, xyE, self = NewXY(sW, sH), NewXY(eW, eH), {}
  local Colors = {List = conColors, Key = GetOpVar("OOP_DEFAULTKEY"), Default = GetColor(255,255,255,255)}
  if(Colors.List) then -- Container check
    if(getmetatable(Colors.List) ~= GetOpVar("TYPEMT_CONTAINER"))
      then LogInstance("Color list not container"); return nil end
  else -- Color list is not present then create one
    Colors.List = MakeContainer("Colors")
  end
  local DrawMeth, DrawArgs, Text = {}, {}, {}
  Text.DrwX, Text.DrwY = 0, 0
  Text.ScrW, Text.ScrH = 0, 0
  Text.LstW, Text.LstH = 0, 0
  function self:GetCorners() return xyS, xyE end
  function self:GetSize() return (eW-sW), (eH-sH) end
  function self:GetCenter(nX,nY)
    local nW, nH = self:GetSize()
    local nX = (nW / 2) + (tonumber(nX) or 0)
    local nY = (nH / 2) + (tonumber(nY) or 0)
    return nX, nY
  end
  function self:SetColor(keyColor,sMeth)
    if(not IsHere(keyColor) and not IsHere(sMeth)) then
      Colors.Key = GetOpVar("OOP_DEFAULTKEY")
      LogInstance("Color reset"); return nil end
    local keyColor = (keyColor or Colors.Key)
    if(not IsHere(keyColor)) then
      LogInstance("Indexing skipped"); return nil end
    if(not IsString(sMeth)) then
      LogInstance("Method <"..tostring(method).."> invalid"); return nil end
    local rgbColor = Colors.List:Select(keyColor)
    if(not IsHere(rgbColor)) then rgbColor = Colors.Default end
    if(tostring(Colors.Key) ~= tostring(keyColor)) then -- Update the color only on change
      surfaceSetDrawColor(rgbColor.r, rgbColor.g, rgbColor.b, rgbColor.a)
      surfaceSetTextColor(rgbColor.r, rgbColor.g, rgbColor.b, rgbColor.a)
      Colors.Key = keyColor;
    end -- The drawing color for these two methods uses surface library
    return rgbColor, keyColor
  end
  function self:SetDrawParam(sMeth,tArgs,sKey)
    tArgs = (tArgs or DrawArgs[sKey])
    sMeth = tostring(sMeth or DrawMeth[sKey])
    if(sMeth == "SURF") then
      if(sKey == "TXT" and tArgs ~= DrawArgs[sKey]) then
        surfaceSetFont(tostring(tArgs[1] or "Default")) end -- Time to set the font again
    end; DrawMeth[sKey], DrawArgs[sKey] = sMeth, tArgs; return sMeth, tArgs
  end
  function self:SetTextEdge(nX,nY)
    Text.ScrW, Text.ScrH = 0, 0
    Text.LstW, Text.LstH = 0, 0
    Text.DrwX = (tonumber(nX) or 0)
    Text.DrwY = (tonumber(nY) or 0)
  end
  function self:GetTextState(nX,nY,nW,nH)
    return (Text.DrwX + (nX or 0)), (Text.DrwY + (nY or 0)),
           (Text.ScrW + (nW or 0)), (Text.ScrH + (nH or 0)),
            Text.LstW, Text.LstH
  end
  function self:DrawText(sText,keyColor,sMeth,tArgs)
    local sMeth, tArgs = self:SetDrawParam(sMeth,tArgs,"TXT")
    self:SetColor(keyColor, sMeth)
    if(sMeth == "SURF") then
      surfaceSetTextPos(Text.DrwX,Text.DrwY); surfaceDrawText(sText)
      Text.LstW, Text.LstH = surfaceGetTextSize(sText)
      Text.DrwY = Text.DrwY + Text.LstH
      if(Text.LstW > Text.ScrW) then Text.ScrW = Text.LstW end
      Text.ScrH = Text.DrwY
    else LogInstance("Draw method <"..sMeth.."> invalid"); return nil end
  end
  function self:DrawTextAdd(sText,keyColor,sMeth,tArgs)
    local sMeth, tArgs = self:SetDrawParam(sMeth,tArgs,"TXT")
    self:SetColor(keyColor, sMeth)
    if(sMeth == "SURF") then
      surfaceSetTextPos(Text.DrwX + Text.LstW,Text.DrwY - Text.LstH)
      surfaceDrawText(sText)
      local LstW, LstH = surfaceGetTextSize(sText)
      Text.LstW, Text.LstH = (Text.LstW + LstW), LstH
      if(Text.LstW > Text.ScrW) then Text.ScrW = Text.LstW end
      Text.ScrH = Text.DrwY
    else LogInstance("Draw method <"..sMeth.."> invalid"); return nil end
  end
  function self:Enclose(xyPnt)
    if(xyPnt.x < sW) then return -1 end
    if(xyPnt.x > eW) then return -1 end
    if(xyPnt.y < sH) then return -1 end
    if(xyPnt.y > eH) then return -1 end; return 1
  end
  function self:GetDistance(pS, pE)
    if(self:Enclose(pS) == -1) then
      LogInstance("Start out of border"); return nil end
    if(self:Enclose(pE) == -1) then
      LogInstance("End out of border"); return nil end
    return mathSqrt((pE.x - pS.x)^2 + (pE.y - pS.y)^2)
  end
  function self:DrawLine(pS,pE,keyColor,sMeth,tArgs)
    if(not (pS and pE)) then return end
    local sMeth, tArgs = self:SetDrawParam(sMeth,tArgs,"LIN")
    local rgbCl, keyCl = self:SetColor(keyColor, sMeth)
    if(sMeth == "SURF") then
      if(self:Enclose(pS) == -1) then
        LogInstance("Start out of border"); return nil end
      if(self:Enclose(pE) == -1) then
        LogInstance("End out of border"); return nil end
      surfaceDrawLine(pS.x,pS.y,pE.x,pE.y)
    elseif(sMeth == "SEGM") then
      if(self:Enclose(pS) == -1) then
        LogInstance("Start out of border"); return nil end
      if(self:Enclose(pE) == -1) then
        LogInstance("End out of border"); return nil end
      local nItr = mathClamp((tonumber(tArgs[1]) or 1),1,200)
      if(nIter <= 0) then return end
      local xyD = NewXY((pE.x - pS.x) / nItr, (pE.y - pS.y) / nItr)
      local xyOld, xyNew = NewXY(pS.x, pS.y), NewXY()
      while(nItr > 0) do AddXY(xyNew, xyOld, xyD)
        surfaceDrawLine(xyOld.x,xyOld.y,xyNew.x,xyNew.y)
        SetXY(xyOld, xyNew); nItr = nItr - 1
      end
    elseif(sMeth == "CAM3") then
      renderDrawLine(pS,pE,rgbCl,(tArgs[1] and true or false))
    else LogInstance("Draw method <"..sMeth.."> invalid"); return nil end
  end
  function self:DrawRect(pS,pE,keyColor,sMeth,tArgs)
    local sMeth, tArgs = self:SetDrawParam(sMeth,tArgs,"REC")
    self:SetColor(keyColor,sMeth)
    if(sMeth == "SURF") then
      if(self:Enclose(pS) == -1) then
        LogInstance("Start out of border"); return nil end
      if(self:Enclose(pE) == -1) then
        LogInstance("End out of border"); return nil end
      surfaceSetTexture(surfaceGetTextureID(tostring(tArgs[1])))
      surfaceDrawTexturedRect(pS.x,pS.y,pE.x-pS.x,pE.y-pS.y)
    else LogInstance("Draw method <"..sMeth.."> invalid"); return nil end
  end
  function self:DrawCircle(pC,nRad,keyColor,sMeth,tArgs)
    local sMeth, tArgs = self:SetDrawParam(sMeth,tArgs,"CIR")
    local rgbCl, keyCl = self:SetColor(keyColor,sMeth)
    if(sMeth == "SURF") then surfaceDrawCircle(pC.x, pC.y, nRad, rgbCl)
    elseif(sMeth == "SEGM") then
      local nItr = mathClamp((tonumber(tArgs[1]) or 1),1,200)
      local nMax = (GetOpVar("MAX_ROTATION") * GetOpVar("DEG_RAD"))
      local xyOld, xyNew, xyRad = NewXY(), NewXY(), NewXY(nRad, 0)
      local nStp, nAng = (nMax / nItr), 0; AddXY(xyOld, xyRad, pC)
      while(nItr > 0) do nAng = nAng + nStp
        SetXY(xyNew, xyRad); RotateXY(xyNew, nAng); AddXY(xyNew, xyNew, pC)
        surfaceDrawLine(xyOld.x,xyOld.y,xyNew.x,xyNew.y)
        SetXY(xyOld, xyNew); nItr = (nItr - 1)
      end
    elseif(sMeth == "CAM3") then -- It is a projection of a sphere
      renderSetMaterial(Material(tostring(tArgs[1] or "color")))
      renderDrawSphere (pC,nRad,mathClamp(tArgs[2] or 1,1,200),
                                mathClamp(tArgs[3] or 1,1,200),rgbCl)
    else LogInstance("Draw method <"..sMeth.."> invalid"); return nil end
  end; setmetatable(self, GetOpVar("TYPEMT_SCREEN")); return self
end

function SetAction(sKey,fAct,tDat)
  if(not (sKey and IsString(sKey))) then
    LogInstance("Key {"..type(sKey).."}<"..tostring(sKey).."> not string"); return nil end
  if(not (fAct and type(fAct) == "function")) then
    LogInstance("Act {"..type(fAct).."}<"..tostring(fAct).."> not function"); return nil end
  if(not libAction[sKey]) then libAction[sKey] = {} end
  libAction[sKey].Act, libAction[sKey].Dat = fAct, tDat
  return true
end

function GetActionCode(sKey)
  if(not (sKey and IsString(sKey))) then
    LogInstance("Key {"..type(sKey).."}<"..tostring(sKey).."> not string"); return nil end
  if(not (libAction and libAction[sKey])) then
    LogInstance("Key missing <"..sKey..">"); return nil end
  return libAction[sKey].Act
end

function GetActionData(sKey)
  if(not (sKey and IsString(sKey))) then
    LogInstance("Key {"..type(sKey).."}<"..tostring(sKey).."> not string"); return nil end
  if(not (libAction and libAction[sKey])) then
    LogInstance("Key not located"); return nil end
  return libAction[sKey].Dat
end

function CallAction(sKey,...)
  if(not (sKey and IsString(sKey))) then
    LogInstance("Key {"..type(sKey).."}<"..tostring(sKey).."> not string"); return nil end
  if(not (libAction and libAction[sKey])) then
    LogInstance("Key not located"); return nil end
  return libAction[sKey].Act(libAction[sKey].Dat,...)
end

local function AddLineListView(pnListView,frUsed,ivNdex)
  if(not IsHere(pnListView)) then
    LogInstance("Missing panel"); return false end
  if(not IsValid(pnListView)) then
    LogInstance("Invalid panel"); return false end
  if(not IsHere(frUsed)) then
    LogInstance("Missing data"); return false end
  local iNdex = tonumber(ivNdex); if(not IsHere(iNdex)) then
    LogInstance("Index NAN {"..type(ivNdex).."}<"..tostring(ivNdex)..">"); return false end
  local tValue = frUsed[iNdex]; if(not IsHere(tValue)) then
    LogInstance("Missing data on index #"..tostring(iNdex)); return false end
  local makTab = libQTable["PIECES"]; if(not IsHere(makTab)) then
    LogInstance("Missing table definition"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return false end
  local sModel = tValue.Table[defTab[1][1]]
  local sType  = tValue.Table[defTab[2][1]]
  local sName  = tValue.Table[defTab[3][1]]
  local nAct   = tValue.Table[defTab[4][1]]
  local nUsed  = RoundValue(tValue.Value,0.001)
  local pnLine = pnListView:AddLine(nUsed,nAct,sType,sName,sModel)
        pnLine:SetTooltip(sModel)
  return true
end

--[[
 * Updates a VGUI pnListView with a search preformed in the already generated
 * frequently used pieces "frUsed" for the pattern "sPat" given by the user
 * and a column name selected `sCol`.
 * On success populates "pnListView" with the search preformed
 * On fail a parameter is not valid or missing and returns non-success
]]--
function UpdateListView(pnListView,frUsed,nCount,sCol,sPat)
  if(not (IsHere(frUsed) and IsHere(frUsed[1]))) then
    LogInstance("Missing data"); return false end
  local nCount = tonumber(nCount) or 0
  if(nCount <= 0) then
    LogInstance("Count not applicable"); return false end
  if(IsHere(pnListView)) then
    if(not IsValid(pnListView)) then
      LogInstance("Invalid ListView"); return false end
    pnListView:SetVisible(false)
    pnListView:Clear()
  else LogInstance("Missing ListView"); return false end
  local sCol, sPat = tostring(sCol or ""), tostring(sPat or "")
  local iCnt, sDat = 1, nil
  while(frUsed[iCnt]) do
    if(IsBlank(sPat)) then
      if(not AddLineListView(pnListView,frUsed,iCnt)) then
        LogInstance("Failed to add line on #"..tostring(iCnt)); return false end
    else
      sDat = tostring(frUsed[iCnt].Table[sCol] or "")
      if(sDat:find(sPat)) then
        if(not AddLineListView(pnListView,frUsed,iCnt)) then
          LogInstance("Failed to add line <"..sDat.."> pattern <"..sPat.."> on <"..sCol.."> #"..tostring(iCnt)); return false end
      end
    end; iCnt = iCnt + 1
  end; pnListView:SetVisible(true)
  LogInstance("Crated #"..tostring(iCnt-1)); return true
end

function GetDirectoryObj(pCurr, vName)
  if(not pCurr) then
    LogInstance("Location invalid"); return nil end
  local sName = tostring(vName or "")
        sName = IsBlank(sName) and "Other" or sName
  if(not pCurr[sName]) then
    LogInstance("Name missing <"..sName..">"); return nil end
  return pCurr[sName], pCurr[sName].__ObjPanel__
end

function SetDirectoryObj(pnBase, pCurr, vName, sImage, txCol)
  if(not IsValid(pnBase)) then
    LogInstance("Base panel invalid"); return nil end
  if(not pCurr) then
    LogInstance("Location invalid"); return nil end
  local sName = tostring(vName or "")
        sName = IsBlank(sName) and "Other" or sName
  local pItem = pnBase:AddNode(sName)
  pCurr[sName] = {}; pCurr[sName].__ObjPanel__ = pItem
  pItem.Icon:SetImage(tostring(sImage or "icon16/folder.png"))
  pItem.InternalDoClick = function() end
  pItem.DoClick         = function() return false end
  pItem.DoRightClick    = function() SetClipboardText(pItem:GetText()) end
  pItem.Label.UpdateColours = function(pSelf)
    return pSelf:SetTextStyleColor(txCol or GetColor(0,0,0,255)) end
  return pCurr[sName], pItem
end

local function PushSortValues(tTable,snCnt,nsValue,tData)
  local iCnt = mathFloor(tonumber(snCnt) or 0)
  if(not (tTable and (type(tTable) == "table") and (iCnt > 0))) then return 0 end
  local iInd  = 1
  if(not tTable[iInd]) then
    tTable[iInd] = {Value = nsValue, Table = tData }
    return iInd
  else
    while(tTable[iInd] and (tTable[iInd].Value < nsValue)) do
      iInd = iInd + 1
    end
    if(iInd > iCnt) then return iInd end
    while(iInd < iCnt) do
      tTable[iCnt] = tTable[iCnt - 1]
      iCnt = iCnt - 1
    end
    tTable[iInd] = { Value = nsValue, Table = tData }
    return iInd
  end
end

function GetFrequentModels(snCount)
  local snCount = (tonumber(snCount) or 0); if(snCount < 1) then
    LogInstance("Count not applicable"); return nil end
  local makTab = libQTable["PIECES"]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  local tCache = libCache[defTab.Name]; if(not IsHere(tCache)) then
    LogInstance("Missing table cache space"); return nil end
  local iInd, tmNow, frUsed = 1, Time(), GetOpVar("TABLE_FREQUENT_MODELS"); tableEmpty(frUsed)
  for mod, rec in pairs(tCache) do
    if(IsHere(rec.Used) and IsHere(rec.Size) and rec.Size > 0) then
      iInd = PushSortValues(frUsed,snCount,tmNow-rec.Used,{
               [defTab[1][1]] = mod,
               [defTab[2][1]] = rec.Type,
               [defTab[3][1]] = rec.Name,
               [defTab[4][1]] = rec.Size
             })
      if(iInd < 1) then LogInstance("Array index out of border"); return nil end
    end
  end
  if(IsHere(frUsed) and IsHere(frUsed[1])) then return frUsed, snCount end
  LogInstance("Array is empty or not available"); return nil
end

function RoundValue(nvEx, nFr)
  local nEx = tonumber(nvEx); if(not IsHere(nEx)) then
    LogInstance("Cannot round NAN {"..type(nvEx).."}<"..tostring(nvEx)..">"); return nil end
  local nFr = (tonumber(nFr) or 0); if(nFr == 0) then
    LogInstance("Fraction must be <> 0"); return nil end
  local q, f = mathModf(nEx / nFr); return nFr * (q + (f > 0.5 and 1 or 0))
end

function GetCenter(oEnt) -- Set the ENT's Angles first!
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity Invalid"); return Vector(0,0,0) end
  local vRez = oEnt:OBBCenter()
        vRez[cvX] = -vRez[cvX]; vRez[cvY] = -vRez[cvY]; vRez[cvZ] = 0
  return vRez
end

function IsPhysTrace(Trace)
  if(not Trace) then return false end
  if(not Trace.Hit) then return false end
  if(Trace.HitWorld) then return false end
  local eEnt = Trace.Entity
  if(not eEnt) then return false end
  if(not eEnt:IsValid()) then return false end
  if(not eEnt:GetPhysicsObject():IsValid()) then return false end
  return true
end

local function RollValue(nVal,nMin,nMax)
  if(nVal > nMax) then return nMin end
  if(nVal < nMin) then return nMax end
  return nVal
end

local function BorderValue(nsVal, sKey, sNam)
  if(not IsHere(sKey)) then return nsVal end
  if(not IsHere(sNam)) then return nsVal end
  if(not (IsString(nsVal) or tonumber(nsVal))) then
    LogInstance("Value not comparable"); return nsVal end
  local tB = GetOpVar("TABLE_BORDERS"); tB = tB[sKey]; if(not IsHere(tB)) then
    LogInstance("Missing <"..tostring(sKey)..">"); return nsVal end
  tB = tB[sNam]; if(IsHere(tB)) then
    if(tB[1] and nsVal < tB[1]) then return tB[1] end
    if(tB[2] and nsVal > tB[2]) then return tB[2] end
  end; return nsVal
end

function SnapReview(ivPoID, ivPnID, ivMaxK)
  local iMaxK = (tonumber(ivMaxK) or 0)
  local iPoID = (tonumber(ivPoID) or 0)
  local iPnID = (tonumber(ivPnID) or 0)
  if(iMaxK <= 0) then return 1, 2 end
  if(iPoID <= 0) then return 1, 2 end
  if(iPnID <= 0) then return 1, 2 end
  if(iPoID  > iMaxK) then return 1, 2 end
  if(iPnID  > iMaxK) then return 1, 2 end -- One active point
  if(iPoID == iPnID) then return 1, 2 end
  return iPoID, iPnID
end

function IncDecPointID(ivPoID,nDir,rPiece)
  local iPoID = tonumber(ivPoID); if(not IsHere(iPoID)) then
    LogInstance("Point ID NAN {"..type(ivPoID).."}<"..tostring(ivPoID)..">"); return 1 end
  local stPOA = LocatePOA(rPiece,iPoID); if(not IsHere(stPOA)) then
    LogInstance("Point ID #"..tostring(iPoID).." not located"); return 1 end
  local nDir = (tonumber(nDir) or 0); nDir = (((nDir > 0) and 1) or ((nDir < 0) and -1) or 0)
  if(nDir == 0) then LogInstance("Direction mismatch"); return iPoID end
  iPoID = RollValue(iPoID + nDir,1,rPiece.Size)
  stPOA = LocatePOA(rPiece,iPoID) -- Skip disabled origin parameter
  while(stPOA) do
    LogInstance("Point ID #"..tostring(iPoID).." disabled")
    iPoID = RollValue(iPoID + nDir,1,rPiece.Size)
    stPOA = LocatePOA(rPiece,iPoID) -- Skip disabled origin parameter
  end; iPoID = RollValue(iPoID,1,rPiece.Size)
  if(not IsHere(LocatePOA(rPiece,iPoID))) then
    LogInstance("Offset PnextID #"..tostring(iPoID).." not located"); return 1 end
  return iPoID
end

function IncDecPnextID(ivPnID,ivPoID,nDir,rPiece)
  local iPoID, iPnID = tonumber(ivPoID), tonumber(ivPnID); if(not IsHere(iPoID)) then
    LogInstance("PointID NAN {"..type(ivPoID).."}<"..tostring(ivPoID)..">"); return 1 end
  if(not IsHere(iPnID)) then
    LogInstance("PnextID NAN {"..type(ivPnID).."}<"..tostring(ivPnID)..">"); return 1 end
  if(not IsHere(LocatePOA(rPiece,iPoID))) then
    LogInstance("Offset PointID #"..tostring(iPoID).." not located"); return 1 end
  if(not IsHere(LocatePOA(rPiece,iPnID))) then
    LogInstance("Offset PnextID #"..tostring(iPnID).." not located"); return 1 end
  local Dir = (tonumber(nDir) or 0); Dir = (((Dir > 0) and 1) or ((Dir < 0) and -1) or 0)
  if(Dir == 0) then LogInstance("Direction mismatch"); return iPnID end
  iPnID = RollValue(iPnID + Dir,1,rPiece.Size)
  if(iPnID == iPoID) then iPnID = RollValue(iPnID + Dir,1,rPiece.Size) end
  if(not IsHere(LocatePOA(rPiece,iPnID))) then
    LogInstance("Offset PnextID #"..tostring(iPnID).." not located"); return 1 end
  return iPnID
end

function GetPointElevation(oEnt,ivPoID)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity Invalid"); return nil end
  local sModel, iPoID = oEnt:GetModel(), tonumber(ivPoID); if(not IsHere(iPoID)) then
    LogInstance("PointID NAN {"..type(ivPoID)..tostring(ivPoID).."> for <"..sModel..">"); return nil end
  local hdRec = CacheQueryPiece(sModel); if(not IsHere(hdRec)) then
    LogInstance("Record not found for <"..sModel..">"); return nil end
  local hdPnt = LocatePOA(hdRec,iPoID); if(not IsHere(hdPnt)) then
    LogInstance("Point #"..tostring(iPoID).." not located on model <"..sModel..">"); return nil end
  if(not (hdPnt.O and hdPnt.A)) then
    LogInstance("Invalid POA #"..tostring(iPoID).." for <"..sModel..">"); return nil end
  local aDiffBB, vDiffBB = Angle(), oEnt:OBBMins()
  SetAngle(aDiffBB,hdPnt.A) ; aDiffBB:RotateAroundAxis(aDiffBB:Up(),180)
  SubVector(vDiffBB,hdPnt.O); DecomposeByAngle(vDiffBB,aDiffBB)
  return mathAbs(vDiffBB[cvZ])
end

function ModelToName(sModel, bNoSet)
  if(not IsString(sModel)) then
    LogInstance("Argument {"..type(sModel).."}<"..tostring(sModel)..">"); return "" end
  if(IsBlank(sModel)) then LogInstance("Empty string"); return "" end
  local sSymDiv, sSymDir = GetOpVar("OPSYM_DIVIDER"), GetOpVar("OPSYM_DIRECTORY")
  local sModel = (sModel:sub(1, 1) ~= sSymDir) and (sSymDir..sModel) or sModel
        sModel = (sModel:GetFileFromFilename():gsub(GetOpVar("MODELNAM_FILE"),""))
  local gModel = (sModel:sub(1,-1)) -- Create a copy so we can select cut-off parts later
  if(not bNoSet) then local iCnt = 1
    local tCut, tSub, tApp = SettingsModelToName("GET")
    if(tCut and tCut[1]) then
      while(tCut[iCnt] and tCut[iCnt+1]) do
        local fCh, bCh = tonumber(tCut[iCnt]), tonumber(tCut[iCnt+1])
        if(not (IsHere(fCh) and IsHere(bCh))) then
          LogInstance("Cannot cut the model in {"..tostring(tCut[iCnt])..","..tostring(tCut[iCnt+1]).."} for "..sModel); return "" end
        gModel = gModel:gsub(sModel:sub(fCh,bCh),"")
        LogInstance("{"..tostring(tCut[iCnt])..", "..tostring(tCut[iCnt+1]).."} >> "..gModel)
        iCnt = iCnt + 2
      end; iCnt = 1
    end -- Replace the unneeded parts by finding an in-string gModel
    if(tSub and tSub[1]) then
      while(tSub[iCnt]) do
        local fCh, bCh = tostring(tSub[iCnt] or ""), tostring(tSub[iCnt+1] or "")
        gModel = gModel:gsub(fCh,bCh)
        LogInstance("{"..tostring(tSub[iCnt])..", "..tostring(tSub[iCnt+1]).."} >> "..gModel)
        iCnt = iCnt + 2
      end; iCnt = 1
    end -- Append something if needed
    if(tApp and tApp[1]) then
      gModel = tostring(tApp[1] or "")..gModel..tostring(tApp[2] or "")
      LogInstance("{"..tostring(tSub[iCnt])..", "..tostring(tSub[iCnt+1]).."} >> "..gModel)
    end
  end -- Trigger the capital spacing using the divider ( _aaaaa_bbbb_ccccc )
  if(gModel:sub(1,1) ~= sSymDiv) then gModel = sSymDiv..gModel end
  return gModel:gsub(sSymDiv.."%w",GetOpVar("MODELNAM_FUNC")):sub(2,-1)
end

--[[
 * Creates a basis instance for entity-related operations
 * The instance is invisible and cannot be hit by traces
 * By default spawns at origin  and angle {0,0,0}
 * sModel --> The model to use for creating the entity
]]
local function MakeEntityNone(sModel) local eNone
  if(SERVER) then eNone = entsCreate(GetOpVar("ENTITY_DEFCLASS"))
  elseif(CLIENT) then eNone = entsCreateClientProp(sModel) end
  if(not (eNone and eNone:IsValid())) then
    LogInstance("Entity invalid"); return nil end
  eNone:SetCollisionGroup(COLLISION_GROUP_NONE)
  eNone:SetSolid(SOLID_NONE); eNone:SetMoveType(MOVETYPE_NONE)
  eNone:SetNotSolid(true); eNone:SetNoDraw(true); eNone:SetModel(sModel)
  LogInstance(""..tostring(eNone)..sModel); return eNone
end

--[[
 * Locates an active point on the piece offset record.
 * This function is used to check the correct offset and return it.
 * It also returns the normalized active point ID if needed
 * oRec   --> Record structure of a track piece
 * ivPoID --> The POA offset ID to check and locate
]]--
function LocatePOA(oRec, ivPoID)
  if(not oRec) then
    LogInstance("Missing record"); return nil end
  if(not oRec.Offs) then
    LogInstance("Missing offsets for <"..tostring(oRec.Slot)..">"); return nil end
  local iPoID = mathFloor(tonumber(ivPoID) or 0)
  local stPOA = oRec.Offs[iPoID]; if(not IsHere(stPOA)) then
    LogInstance("Missing ID #"..tostring(iPoID)..tostring(ivPoID).."> for <"..tostring(oRec.Slot)..">"); return nil end
  return stPOA, iPoID
end

local function ReloadPOA(nXP,nYY,nZR)
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
        arPOA[1] = (tonumber(nXP) or 0)
        arPOA[2] = (tonumber(nYY) or 0)
        arPOA[3] = (tonumber(nZR) or 0)
  return arPOA
end

local function IsEqualPOA(staPOA,stbPOA)
  if(not IsHere(staPOA)) then
    LogInstance("Missing offset A"); return false end
  if(not IsHere(stbPOA)) then
    LogInstance("Missing offset B"); return false end
  for kKey, vComp in pairs(staPOA) do
    if(stbPOA[kKey] ~= vComp) then return false end
  end; return true
end

local function IsZeroPOA(stPOA,sOffs)
  if(not IsString(sOffs)) then
    LogInstance("Mode {"..type(sOffs).."}<"..tostring(sOffs).."> not string"); return nil end
  if(not IsHere(stPOA)) then LogInstance("Missing offset"); return nil end
  local ctA, ctB, ctC = GetIndexes(sOffs); if(not (ctA and ctB and ctC)) then
    LogInstance("Missed offset mode "..sOffs); return nil end
  return (stPOA[ctA] == 0 and stPOA[ctB] == 0 and stPOA[ctC] == 0)
end

local function StringPOA(stPOA,sOffs)
  if(not IsString(sOffs)) then
    LogInstance("Mode {"..type(sOffs).."}<"..tostring(sOffs).."> not string"); return nil end
  if(not IsHere(stPOA)) then
    LogInstance("Missing Offsets"); return nil end
  local ctA, ctB, ctC = GetIndexes(sOffs); if(not (ctA and ctB and ctC)) then
    LogInstance("Missed offset mode "..sOffs); return nil end
  local symSep = GetOpVar("OPSYM_SEPARATOR")
  return (tostring(stPOA[ctA])..symSep..tostring(stPOA[ctB])..symSep..tostring(stPOA[ctC])):gsub("%s","")
end

local function TransferPOA(stOffset,sMode)
  if(not IsHere(stOffset)) then
    LogInstance("Destination needed"); return nil end
  if(not IsString(sMode)) then
    LogInstance("Mode {"..type(sMode).."}<"..tostring(sMode).."> not string"); return nil end
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
  local ctA, ctB, ctC = GetIndexes(sOffs); if(not (ctA and ctB and ctC)) then
    LogInstance("Missed offset mode "..sOffs); return nil end
  stOffset[ctA], stOffset[ctB], stOffset[ctC] = arPOA[1], arPOA[2], arPOA[3]; return arPOA
end

local function DecodePOA(sStr)
  if(not IsString(sStr)) then
    LogInstance("Argument {"..type(sStr).."}<"..tostring(sStr).."> not string"); return nil end
  if(sStr:len() == 0) then return ReloadPOA() end; ReloadPOA()
  local symSep = GetOpVar("OPSYM_SEPARATOR")
  local atPOA, arPOA = symSep:Explode(sStr), GetOpVar("ARRAY_DECODEPOA")
  for iD = 1, #arPOA do arPOA[iD] = tonumber(atPOA[iD]) or arPOA[iD] end
  return arPOA
end

local function GetPieceUnit(stPiece)
  local sD = GetOpVar("ENTITY_DEFCLASS")
  local sU = (stPiece and stPiece.Unit or nil)
  if(not IsHere(sU)) then return sD end
  local bU = (IsString(sU) and (sU ~= "NULL") and not IsBlank(sU))
  return (bU and sU or sD)
end

local function GetTransformPOA(sModel,sKey)
  if(not IsString(sModel)) then
    LogInstance("Model mismatch <"..tostring(sModel)..">"); return nil end
  if(not IsString(sKey)) then
    LogInstance("Key mismatch <"..tostring(sKey)..">@"..sModel); return nil end
  local ePiece = GetOpVar("ENTITY_TRANSFORMPOA")
  if(ePiece and ePiece:IsValid()) then -- There is basis entity then update and extract
    if(ePiece:GetModel() ~= sModel) then ePiece:SetModel(sModel)
      LogInstance("Update "..tostring(ePiece).."@"..sModel) end
  else -- If there is no basis need to create one for attachment extraction
    ePiece = MakeEntityNone(sModel); if(not ePiece) then
      LogInstance("Basis invalid"); return nil end
    LogInstance("Create "..tostring(ePiece).."@"..sModel)
    SetOpVar("ENTITY_TRANSFORMPOA", ePiece) -- Register the entity transform basis
  end -- Transfer the data from the transform attachment location
  local mOA = tableCopy(ePiece:GetAttachment(ePiece:LookupAttachment(sKey))); if(not mOA) then
    LogInstance("Attachment missing <"..sKey..">@"..sModel); return nil end
  local vtPos, atAng = mOA[sKey].Pos, mOA[sKey].Ang -- Extract transform data
  LogInstance("Extract ["..sKey.."]<"..tostring(vtPos).."><"..tostring(atAng)..">")
  return vtPos, atAng -- The function must return transform position and angle
end

local function RegisterPOA(stPiece, ivID, sP, sO, sA)
  if(not stPiece) then
    LogInstance("Cache record invalid"); return nil end
  local iID = tonumber(ivID); if(not IsHere(iID)) then
    LogInstance("OffsetID NAN {"..type(ivID).."}<"..tostring(ivID)..">"); return nil end
  local sP = (sP or "NULL"); if(not IsString(sP)) then
    LogInstance("Point  {"..type(sP).."}<"..tostring(sP)..">"); return nil end
  local sO = (sO or "NULL"); if(not IsString(sO)) then
    LogInstance("Origin {"..type(sO).."}<"..tostring(sO)..">"); return nil end
  local sA = (sA or "NULL"); if(not IsString(sA)) then
    LogInstance("Angle  {"..type(sA).."}<"..tostring(sA)..">"); return nil end
  if(not stPiece.Offs) then
    if(iID > 1) then LogInstance("First ID cannot be #"..tostring(iID)); return nil end
    stPiece.Offs = {}
  end
  local tOffs = stPiece.Offs; if(tOffs[iID]) then
    LogInstance("Exists ID #"..tostring(iID)); return nil
  else
    if((iID > 1) and (not tOffs[iID - 1])) then
      LogInstance("No sequential ID #"..tostring(iID - 1)); return nil end
    tOffs[iID] = {}; tOffs[iID].P = {}; tOffs[iID].O = {}; tOffs[iID].A = {}; tOffs = tOffs[iID]
  end; local sE, sD = GetOpVar("OPSYM_ENTPOSANG"), GetOpVar("OPSYM_DISABLE")
  if(sO:sub(1,1) == sE) then
    local vtPos, atAng = GetTransformPOA(stPiece.Slot, sO:sub(2,-1))
    ---------- Origin ----------
    if(IsHere(vtPos)) then -- Reversing the sign event is not supported
      ReloadPOA(vtPos[cvX], vtPos[cvY], vtPos[cvZ]) else ReloadPOA() end
    if(not IsHere(TransferPOA(tOffs.O, "V"))) then -- Origin
      LogInstance("Cannot transform origin"); return nil end
    ---------- Angle ----------
    if(IsHere(atAng)) then -- Angle disable event reads parameterization
      ReloadPOA(atAng[caP], atAng[caY], atAng[caR]) else
      if((sA ~= "NULL") and not IsBlank(sA)) then DecodePOA(sA) else ReloadPOA() end
    end -- When attachment angle cannot be found read parameterization
    if(not IsHere(TransferPOA(tOffs.A, "A"))) then -- Angle
      LogInstance("Cannot transform angle"); return nil end
  else
    ---------- Origin ----------
    if((sO ~= "NULL") and not IsBlank(sO)) then DecodePOA(sO) else ReloadPOA() end
    if(not IsHere(TransferPOA(tOffs.O, "V"))) then
      LogInstance("Cannot transfer origin"); return nil end
    ---------- Angle ----------
    if((sA ~= "NULL") and not IsBlank(sA)) then DecodePOA(sA) else ReloadPOA() end
    if(not IsHere(TransferPOA(tOffs.A, "A"))) then
      LogInstance("Cannot transfer angle"); return nil end
  end -- The active point is dependent by the events used and the state of the origin
  if((sP ~= "NULL") and not IsBlank(sP)) then DecodePOA(sP) else ReloadPOA() end
  if(not IsHere(TransferPOA(tOffs.P, "V"))) then
    LogInstance("Cannot transfer point"); return nil end
  local sV = sP:gsub(sD,"")
  if((sV == "NULL") or IsBlank(sV)) then -- If empty use origin
    tOffs.P[cvX], tOffs.P[cvY], tOffs.P[cvZ] = tOffs.O[cvX], tOffs.O[cvY], tOffs.O[cvZ]
  end; return tOffs
end

local function QuickSort(tD, iL, iH)
  if(not (iL and iH and (iL > 0) and (iL < iH))) then
    LogInstance("Data dimensions mismatch"); return nil end
  local iM = mathRandom(iH-iL-1)+iL-1
  tD[iL], tD[iM] = tD[iM], tD[iL]; iM = iL
  local vM, iC = tD[iL].Val, (iL + 1)
  while(iC <= iH)do
    if(tD[iC].Val < vM) then iM = iM + 1
      tD[iM], tD[iC] = tD[iC], tD[iM]
    end; iC = iC + 1
  end; tD[iL], tD[iM] = tD[iM], tD[iL]
  QuickSort(tD,iL,iM-1)
  QuickSort(tD,iM+1,iH)
end

local function Sort(tTable, tCols)
  local tS, iS = {Size = 0}, 0
  local tC = tCols or {}; tC.Size = #tC
  for key, rec in pairs(tTable) do
    iS = (iS + 1); tS[iS] = {}; tS[iS].Key = key
    if(type(rec) == "table") then tS[iS].Val = ""
      if(tC.Size > 0) then
        for iI = 1, tC.Size do local sC = tC[iI]; if(not IsHere(rec[sC])) then
          LogInstance("Col <"..sC.."> not found on the current record"); return nil end
            tS[iS].Val = tS[iS].Val..tostring(rec[sC])
        end -- When no sort columns are provided use keys instead
      else tS[iS].Val = key end -- Use the table key
    else tS[iS].Val = rec end -- Use the actual value
  end; tS.Size = iS; QuickSort(tS,1,iS); return tS
end

--------------------- STRING -----------------------

function DisableString(sBase, vDsb, vDef)
  if(IsString(sBase)) then
    local sF, sD = sBase:sub(1,1), GetOpVar("OPSYM_DISABLE")
    if(sF ~= sD and not IsBlank(sBase)) then
      return sBase -- Not disabled or empty
    elseif(sF == sD) then return vDsb end
  end; return vDef
end

function DefaultString(sBase, sDef)
  if(IsString(sBase)) then
    if(not IsBlank(sBase)) then return sBase end end
  if(IsString(sDef)) then return sDef end; return ""
end

------------- VARIABLE INTERFACES --------------

function SettingsModelToName(sMode, gCut, gSub, gApp)
  if(not IsString(sMode)) then
    LogInstance("Mode {"..type(sMode).."}<"..tostring(sMode).."> not string"); return false end
  if(sMode == "SET") then
    if(gCut and gCut[1]) then SetOpVar("TABLE_GCUT_MODEL",gCut) else SetOpVar("TABLE_GCUT_MODEL",{}) end
    if(gSub and gSub[1]) then SetOpVar("TABLE_GSUB_MODEL",gSub) else SetOpVar("TABLE_GSUB_MODEL",{}) end
    if(gApp and gApp[1]) then SetOpVar("TABLE_GAPP_MODEL",gApp) else SetOpVar("TABLE_GAPP_MODEL",{}) end
  elseif(sMode == "GET") then
    return GetOpVar("TABLE_GCUT_MODEL"), GetOpVar("TABLE_GSUB_MODEL"), GetOpVar("TABLE_GAPP_MODEL")
  elseif(sMode == "CLR") then
    SetOpVar("TABLE_GCUT_MODEL",{})
    SetOpVar("TABLE_GSUB_MODEL",{})
    SetOpVar("TABLE_GAPP_MODEL",{})
  else LogInstance("Wrong mode name "..sMode); return false end
end

function DefaultType(anyType,fCat)
  if(not IsHere(anyType)) then
    local sTyp = tostring(GetOpVar("DEFAULT_TYPE") or "")
    local tCat = GetOpVar("TABLE_CATEGORIES")
          tCat = tCat and tCat[sTyp] or nil
    return sTyp, (tCat and tCat.Txt), (tCat and tCat.Cmp)
  end; SettingsModelToName("CLR")
  SetOpVar("DEFAULT_TYPE", tostring(anyType))
  if(CLIENT) then
    local sTyp = GetOpVar("DEFAULT_TYPE")
    if(IsString(fCat)) then -- Categories for the panel
      local tCat = GetOpVar("TABLE_CATEGORIES")
      tCat[sTyp] = {}; tCat[sTyp].Txt = fCat
      tCat[sTyp].Cmp = CompileString("return ("..fCat..")", sTyp)
      local suc, out = pcall(tCat[sTyp].Cmp)
      if(not suc) then
        LogInstance("Compilation failed <"..fCat.."> ["..sTyp.."]"); return nil end
      tCat[sTyp].Cmp = out
    else LogInstance("Avoided "..type(fCat).." <"..tostring(fCat).."> ["..sTyp.."]"); return nil end
  end
end

function DefaultTable(anyTable)
  if(not IsHere(anyTable)) then
    return (GetOpVar("DEFAULT_TABLE") or "") end
  SetOpVar("DEFAULT_TABLE",anyTable)
  SettingsModelToName("CLR")
end

------------------------- PLAYER -----------------------------------

local function GetPlayerSpot(pPly)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly)"> invalid"); return nil end
  local stSpot = libPlayer[pPly]; if(not IsHere(stSpot)) then
    LogInstance("Cached <"..pPly:Nick()..">")
    libPlayer[pPly] = {}; stSpot = libPlayer[pPly]
  end; return stSpot
end

function CacheSpawnPly(pPly)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end
  local stData = stSpot["SPAWN"]
  if(not IsHere(stData)) then
    LogInstance("Allocate <"..pPly:Nick()..">")
    stSpot["SPAWN"] = {}; stData = stSpot["SPAWN"]
    stData.F    = Vector() -- Origin forward vector
    stData.R    = Vector() -- Origin right vector
    stData.U    = Vector() -- Origin up vector
    stData.OPos = Vector() -- Origin position
    stData.OAng = Angle () -- Origin angle
    stData.SPos = Vector() -- Piece spawn position
    stData.SAng = Angle () -- Piece spawn angle
    stData.SMtx = Matrix() -- Spawn translation and rotation matrix
    stData.RLen = 0        -- Piece active radius
    --- Holder ---
    stData.HRec = 0        -- Pointer to the holder record
    stData.HID  = 0        -- Point ID
    stData.HPnt = Vector() -- P > Local location of the active point
    stData.HOrg = Vector() -- O > Local new piece location origin when snapped
    stData.HAng = Angle () -- A > Local new piece orientation origin when snapped
    stData.HMtx = Matrix() -- Holder translation and rotation matrix
    --- Traced ---
    stData.TRec = 0        -- Pointer to the trace record
    stData.TID  = 0
    stData.TPnt = Vector() -- P > Local location of the active point
    stData.TOrg = Vector() -- O > Local new piece location origin when snapped
    stData.TAng = Angle () -- A > Local new piece orientation origin when snapped
    stData.TMtx = Matrix() -- Trace translation and rotation matrix
    --- Offsets ---
    stData.ANxt = Angle () -- Origin angle offsets
    stData.PNxt = Vector() -- Piece position offsets
  end; return stData
end

function CacheClearPly(pPly)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly)"> invalid"); return false end
  local stSpot = libPlayer[pPly]; if(not IsHere(stSpot)) then
    LogInstance("Clean"); return true end
  libPlayer[pPly] = nil; collectgarbage(); return true
end

function GetDistanceHitPly(pPly, vHit)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly)"> invalid"); return nil end
  return (vHit - pPly:GetPos()):Length()
end

function CacheRadiusPly(pPly, vHit, nSca)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end
  local stData = stSpot["RADIUS"]
  if(not IsHere(stData)) then
    LogInstance("Allocate <"..pPly:Nick()..">")
    stSpot["RADIUS"] = {}; stData = stSpot["RADIUS"]
    stData["MAR"] =  (GetOpVar("GOLDEN_RATIO") * 1000)
    stData["LIM"] = ((GetOpVar("GOLDEN_RATIO") - 1) * 100)
  end
  local nMul = (tonumber(nSca) or 1) -- Disable scaling on missing or outside
        nMul = ((nMul <= 1 and nMul >= 0) and nMul or 1)
  local nMar, nLim = stData["MAR"], stData["LIM"]
  local nDst = GetDistanceHitPly(pPly, vHit)
  local nRad = ((nDst ~= 0) and mathClamp((nMar / nDst) * nMul, 1, nLim) or 0)
  return nRad, nDst, nMar, nLim
end

function CacheTracePly(pPly)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end
  local stData, plyTime = stSpot["TRACE"], Time()
  if(not IsHere(stData)) then -- Define trace delta margin
    LogInstance("Allocate <"..pPly:Nick()..">")
    stSpot["TRACE"] = {}; stData = stSpot["TRACE"]
    stData["NXT"] = plyTime + GetOpVar("TRACE_MARGIN") -- Define next trace pending
    stData["DAT"] = utilGetPlayerTrace(pPly)      -- Get out trace data
    stData["REZ"] = utilTraceLine(stData["DAT"]) -- Make a trace
  end -- Check the trace time margin interval
  if(plyTime >= stData["NXT"]) then
    stData["NXT"] = plyTime + GetOpVar("TRACE_MARGIN") -- Next trace margin
    stData["DAT"] = utilGetPlayerTrace(pPly)      -- Get out trace data
    stData["REZ"] = utilTraceLine(stData["DAT"]) -- Make a trace
  end; return stData["REZ"]
end

function ConCommandPly(pPly,sCvar,snValue)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly).."> invalid"); return nil end
  if(not IsString(sCvar)) then -- Make it like so the space will not be forgotten
    LogInstance("Convar {"..type(sCvar).."}<"..tostring(sCvar).."> not string"); return nil end
  return pPly:ConCommand(GetOpVar("TOOLNAME_PL")..sCvar.." "..tostring(snValue).."\n")
end

function PrintNotifyPly(pPly,sText,sNotifType)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly)"> invalid"); return false end
  if(SERVER) then -- Send notification to client that something happened
    pPly:SendLua("GAMEMODE:AddNotify(\""..sText.."\", NOTIFY_"..sNotifType..", 6)")
    pPly:SendLua("surface.PlaySound(\"ambient/water/drip"..mathRandom(1, 4)..".wav\")")
  end; LogInstance("Success"); return true
end

function UndoCratePly(anyMessage)
  SetOpVar("LABEL_UNDO",tostring(anyMessage))
  undoCreate(GetOpVar("LABEL_UNDO"))
  return true
end

function UndoAddEntityPly(oEnt)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity invalid"); return false end
  undoAddEntity(oEnt); return true
end

function UndoFinishPly(pPly,anyMessage)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly)"> invalid"); return false end
  pPly:EmitSound("physics/metal/metal_canister_impact_hard"..mathRandom(1, 3)..".wav")
  undoSetCustomUndoText(GetOpVar("LABEL_UNDO")..tostring(anyMessage or ""))
  undoSetPlayer(pPly)
  undoFinish()
  return true
end

function CachePressPly(pPly)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return false end
  local stData = stSpot["PRESS"]
  if(not IsHere(stData)) then -- Create predicate command
    LogInstance("Allocate <"..pPly:Nick()..">")
    stSpot["PRESS"] = {}; stData = stSpot["PRESS"]
    stData["CMD"] = pPly:GetCurrentCommand()
    if(not IsHere(stData["CMD"])) then
      LogInstance("Command incorrect"); return false end
  end; return true
end

-- https://wiki.garrysmod.com/page/CUserCmd/GetMouseWheel
function GetMouseWheelPly(pPly)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return 0 end
  local stData = stSpot["PRESS"]; if(not IsHere(stData)) then
    LogInstance("Data missing <"..pPly:Nick()..">"); return 0 end
  local cmdPress = stData["CMD"]; if(not IsHere(cmdPress)) then
    LogInstance("Command missing <"..pPly:Nick()..">"); return 0 end
  return (cmdPress and cmdPress:GetMouseWheel() or 0)
end

-- https://wiki.garrysmod.com/page/CUserCmd/GetMouse(XY)
function GetMouseDeltaPly(pPly)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return 0 end
  local stData = stSpot["PRESS"]; if(not IsHere(stData)) then
    LogInstance("Data missing <"..pPly:Nick()..">"); return 0 end
  local cmdPress = stData["CMD"]; if(not IsHere(cmdPress)) then
    LogInstance("Command missing <"..pPly:Nick()..">"); return 0 end
  return cmdPress:GetMouseX(), cmdPress:GetMouseY()
end

-- https://wiki.garrysmod.com/page/Enums/IN
function CheckButtonPly(pPly, iInKey)
  local stSpot, iInKey = GetPlayerSpot(pPly), (tonumber(iInKey) or 0)
  if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return false end
  local stData = stSpot["PRESS"]
  if(not IsHere(stData)) then return pPly:KeyDown(iInKey) end
  local cmdPress = stData["CMD"]
  if(not IsHere(cmdPress)) then return pPly:KeyDown(iInKey) end
  return (bitBand(cmdPress:GetButtons(),iInKey) ~= 0) -- Read the cache
end

-------------------------- BUILDSQL ------------------------------

local function CacheStmt(sHash,sStmt,...)
  if(not IsHere(sHash)) then LogInstance("Missing hash"); return nil end
  local sHash, tStore = tostring(sHash), GetOpVar("QUERY_STORE")
  if(not IsHere(tStore)) then LogInstance("Missing storage"); return nil end
  if(IsHere(sStmt)) then -- If the key is located return the query
    tStore[sHash] = tostring(sStmt); Print(tStore,"STMT") end
  local sBase = tStore[sHash]; if(not IsHere(sBase)) then
    LogInstance("("..sHash..") Mismatch"); return nil end
  return sBase:format(...)
end

function GetBuilderName(sTable)
  if(not IsString(sTable)) then
    LogInstance("Key {"..type(sTable).."}<"..tostring(sTable).."> not string"); return nil end
  local makTab = libQTable[sTable]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder for <"..sTable..">"); return nil end
  if(not makTab:IsValid()) then
    LogInstance("Builder object invalid <"..sTable..">"); return nil end
  return makTab -- Return the dedicated table builder object
end

function GetBuilderID(vD)
  if(not IsHere(vD)) then return libQTable.Size end
  local iD = tonumber(vD) if(not iD) then
    LogInstance("Index NAN {"..type(vD).."}<"..tostring(vD)..">"); return nil end
  local makTab = GetBuilderName(libQTable[iD]); return makTab
end

function CreateTable(sTable,defTab,bDelete,bReload)
  if(not IsString(sTable)) then
    LogInstance("Table key {"..type(sTable).."}<"..tostring(sTable).."> not string"); return false end
  if(IsBlank(sTable)) then
    LogInstance("Table name must not be empty"); return false end
  if(not (type(defTab) == "table")) then
    LogInstance("Table definition missing for "..sTable); return false end
  defTab.Size = #defTab; if(defTab.Size <= 0) then
    LogInstance("Record definition missing for "..sTable); return false end
  for iCnt = 1, defTab.Size do
    local sN = tostring(defTab[iCnt][1] or ""); if(IsBlank(sN)) then
      LogInstance("Missing table "..sTable.." col ["..tostring(iCnt).."] name"); return false end
    local sT = tostring(defTab[iCnt][2] or ""); if(IsBlank(sT)) then
      LogInstance("Missing table "..sTable.." col ["..tostring(iCnt).."] type"); return false end
    defTab[iCnt][1], defTab[iCnt][2] = sN, sT
  end
  if(defTab.Size ~= tableMaxn(defTab)) then
    LogInstance("Record definition mismatch for "..sTable); return false end
  defTab.Nick = sTable:upper(); defTab.Name = GetOpVar("TOOLNAME_PU")..defTab.Nick
  local self, __qtDef, __qtCmd, logArg = {}, defTab, {}, {nil, nil, defTab.Nick}
  local symDis, sMoDB = GetOpVar("OPSYM_DISABLE"), GetOpVar("MODE_DATABASE")
  for iCnt = 1, defTab.Size do local defCol = defTab[iCnt]
    defCol[3] = DefaultString(tostring(defCol[3] or symDis), symDis)
    defCol[4] = DefaultString(tostring(defCol[4] or symDis), symDis)
  end; libCache[defTab.Name] = {}; libQTable[defTab.Nick] = self
  if(not libQTable.Size) then libQTable.Size = 0 end
  -- Read table definition
  function self:GetDefinition(vK)
    if(vK) then return __qtDef[vK] end; return __qtDef
  end
  -- Reads the requested command or returns the whole list
  function self:GetCommand(vK)
    if(vK) then return __qtCmd[vK] end; return __qtCmd
  end
  -- Alias for reading the last created SQL statement
  function self:Get()
    local qtCmd = self:GetCommand(); return qtCmd[qtCmd.STMT]
  end
  -- Reads the method names from the debug information
  function self:GetInfo(vK)
    if(vK) then return debugGetinfo(2, "n")[vK] end
    return debugGetinfo(2, "n")
  end
  -- Returns ID of the found column
  function self:GetColumnID(sN)
    local sN, qtDef = tostring(sN or ""), self:GetDefinition()
    for iD = 1, qtDef.Size do if(qtDef[iD][1] == sN) then return iD end
    end; LogInstance("Mismatch <"..sN..">"); return 0
  end
  -- Reads the method names from the debug information
  function self:UpdateInfo()
    local qtCmd = self:GetCommand()
    qtCmd.STMT = self:GetInfo().name; return self
  end
  -- Removes the object from the list
  function self:Remove(vRet)
    local qtDef = self:GetDefinition()
    libQTable[qtDef.KeyID] = nil
    libQTable[qtDef.Nick]  = nil
    collectgarbage(); return vRet
  end
  -- Generates a timer settings table and keeps the defaults
  function self:TimerSetup(vTim)
    local qtCmd = self:GetCommand()
    local qtDef = self:GetDefinition()
    local sTm = (vTim and tostring(vTim or "") or qtDef.Timer)    
    local tTm = GetOpVar("OPSYM_REVISION"):Explode(sTm)
    tTm[1] =   tostring(tTm[1]  or "CQT")                     -- Timer mode
    tTm[2] =  (tonumber(tTm[2]) or 0)                         -- Record life
    tTm[3] = ((tonumber(tTm[3]) or 0) ~= 0) and true or false -- Kill command
    tTm[4] = ((tonumber(tTm[4]) or 0) ~= 0) and true or false -- Collect garbage call
    qtCmd.Timer = tTm; return self
  end
  -- Navigates the reference in the cache
  function self:GetNavigate(...)
    local tKey = {...}; if(not IsHere(tKey[1])) then
      LogInstance("Missing keys",unpack(logArg)); return nil end
    local oSpot, kKey, iCnt = libCache, tKey[1], 1
    while(tKey[iCnt]) do kKey = tKey[iCnt]; iCnt = iCnt + 1
      if(tKey[iCnt]) then oSpot = oSpot[kKey]; if(not IsHere(oSpot)) then
        LogInstance("Irrelevant key <"..tostring(kKey)..">",unpack(logArg)); return nil
    end; end; end; return oSpot, kKey, tKey
  end
  -- Attaches timer to a record related in the table cache
  function self:TimerAttach(vMsg, ...)
    local oSpot, kKey, tKey = self:GetNavigate(...)
    if(not (IsHere(oSpot) and IsHere(kKey))) then
      LogInstance("Navigation failed",unpack(logArg)); return nil end
    if(not IsHere(oSpot[kKey])) then
      LogInstance("Data not found",unpack(logArg)); return nil end
    local sMoDB = GetOpVar("MODE_DATABASE")
    LogInstance("Called by <"..tostring(vMsg).."> for ["..tostring(kKey).."]",unpack(logArg))
    if(sMoDB == "SQL") then local qtCmd = self:GetCommand() -- Read the command and current time
      local nNow, tTim = Time(), qtCmd.Timer; if(not IsHere(tTim)) then
        LogInstance("Missing timer settings",unpack(logArg)); return oSpot[kKey] end
      oSpot[kKey].Used = nNow -- Make the first selected deletable to avoid phantom records
      local nLif = tTim[2]; if(nLif <= 0) then
        LogInstance("Timer attachment ignored",unpack(logArg)); return oSpot[kKey] end
      local smTM, tmDie, tmCol = tTim[1], tTim[3], tTim[4]
      LogInstance("["..smTM.."] ("..tostring(nLif)..") "..tostring(tmDie)..", "..tostring(tmCol),unpack(logArg))
      if(smTM == "CQT") then
        for k, v in pairs(oSpot) do
          if(IsHere(v.Used) and ((nNow - v.Used) > nLif)) then
            LogInstance("("..tostring(RoundValue(nNow - v.Used,0.01)).." > "..tostring(nLif)..") > Dead",unpack(logArg))
            if(tmDie) then oSpot[k] = nil; LogInstance("Killed <"..tostring(k)..">",unpack(logArg)) end
          end
        end
        if(tmCol) then collectgarbage(); LogInstance("Garbage collected",unpack(logArg)) end
        LogInstance("["..tostring(kKey).."] @"..tostring(RoundValue(nNow,0.01)),unpack(logArg)); return oSpot[kKey]
      elseif(smTM == "OBJ") then
        local tmID = GetOpVar("OPSYM_DIVIDER"):Implode(tKey)
        LogInstance("TimID <"..tmID..">",unpack(logArg))
        if(timerExists(tmID)) then LogInstance("Timer exists",unpack(logArg)); return oSpot[kKey] end
        timerCreate(tmID, nLif, 1, function()
          LogInstance("TimerAttach["..tmID.."]("..nLif..") > Dead",unpack(logArg))
          if(tmDie) then oSpot[kKey] = nil; LogInstance("Killed <"..kKey..">",unpack(logArg)) end
          timerStop(tmID); timerDestroy(tmID)
          if(tmCol) then collectgarbage(); LogInstance("Garbage collected",unpack(logArg)) end
        end); timerStart(tmID); return oSpot[kKey]
      else LogInstance("Mode mismatch <"..smTM..">",unpack(logArg)); return oSpot[kKey] end
    elseif(sMoDB == "LUA") then
      LogInstance("Memory manager impractical",unpack(logArg)); return oSpot[kKey]
    else LogInstance("Wrong database mode",unpack(logArg)); return nil end
  end
  -- Restarts timer to a record related in the table cache
  function self:TimerRestart(vMsg, ...)
    local oSpot, kKey, tKey = self:GetNavigate(...)
    if(not (IsHere(oSpot) and IsHere(kKey))) then
      LogInstance("Navigation failed",unpack(logArg)); return nil end
    if(not IsHere(oSpot[kKey])) then
      LogInstance("Spot not found",unpack(logArg)); return nil end
    local sMoDB = GetOpVar("MODE_DATABASE")
    LogInstance("Called by <"..tostring(vMsg).."> for ["..tostring(kKey).."]",unpack(logArg))
    if(sMoDB == "SQL") then
      local tTimer = defTab.Timer; if(not IsHere(tTimer)) then
        LogInstance("Missing timer settings",unpack(logArg)); return oSpot[kKey] end
      oSpot[kKey].Used = Time() -- Mark the current caching time stamp
      local nLifeTM = tTimer[2]; if(nLifeTM <= 0) then
        LogInstance("Timer life ignored",unpack(logArg)); return oSpot[kKey] end
      local smTM = tTimer[1] -- Just for something to do here and to be known that this is mode CQT
      if(smTM == "CQT") then smTM = "CQT"
      elseif(smTM == "OBJ") then
        local keyTimerID = GetOpVar("OPSYM_DIVIDER"):Implode(tKeys)
        if(not timerExists(keyTimerID)) then
          LogInstance("Timer missing <"..keyTimerID..">",unpack(logArg)); return nil end
        timerStart(keyTimerID)
      else LogInstance("Mode mismatch <"..smTM..">",unpack(logArg)); return nil end
    elseif(sMoDB == "LUA") then oSpot[kKey].Used = Time()
    else LogInstance("Wrong database mode",unpack(logArg)); return nil end
    return oSpot[kKey]
  end
  -- Object internal data validation
  function self:IsValid() local bStat = true
    local qtCmd = self:GetCommand(); if(not qtCmd) then
      LogInstance("Missing commands <"..defTab.Nick..">",unpack(logArg)); bStat = false end
    local qtDef = self:GetDefinition(); if(not qtDef) then
      LogInstance("Missing definition",unpack(logArg)); bStat = false end
    if(qtDef.Size ~= #qtDef) then
      LogInstance("Mismatch count",unpack(logArg)); bStat = false end
    if(qtDef.Size ~= tableMaxn(qtDef)) then
      LogInstance("Mismatch maxN",unpack(logArg)); bStat = false end
    if(not tonumber(qtDef.KeyID)) then
      LogInstance("Mismatch key ID ["..tostring(qtDef.KeyID).."]",unpack(logArg)); bStat = false end
    if(defTab.Nick:upper() ~= defTab.Nick) then
      LogInstance("Nick lower",unpack(logArg)); bStat = false end
    if(defTab.Name:upper() ~= defTab.Name) then
      LogInstance("Name lower <"..defTab.Name..">",unpack(logArg)); bStat = false end
    local nS, nE = defTab.Name:find(defTab.Nick); if(not (nS and nE and nS > 1 and nE == defTab.Name:len())) then
      LogInstance("Mismatch <"..defTab.Name..">",unpack(logArg)); bStat = false end
    for iD = 1, qtDef.Size do local tCol = qtDef[iD] if(type(tCol) ~= "table") then
        LogInstance("Mismatch type ["..iD.."]",unpack(logArg)); bStat = false end
      if(not IsString(tCol[1])) then
        LogInstance("Mismatch name ["..iD.."]",unpack(logArg)); bStat = false end
      if(not IsString(tCol[2])) then
        LogInstance("Mismatch type ["..iD.."]",unpack(logArg)); bStat = false end
      if(tCol[3] and not IsString(tCol[3])) then
        LogInstance("Mismatch ctrl ["..iD.."]",unpack(logArg)); bStat = false end
      if(tCol[4] and not IsString(tCol[4])) then
        LogInstance("Mismatch conv ["..iD.."]",unpack(logArg)); bStat = false end
    end; return bStat -- Succesfully validated the builder table
  end
  -- Creates table column list as string
  function self:GetColumnList(sD)
    if(not IsHere(sD)) then return "" end
    local qtDef, sRes, iCnt = self:GetDefinition(), "", 1
    local sD = tostring(sD or "\t"):sub(1,1); if(IsBlank(sD)) then
      LogInstance("Missing delimiter",unpack(logArg)); return "" end
    while(iCnt <= qtDef.Size) do
      sRes, iCnt = (sRes..qtDef[iCnt][1]), (iCnt + 1)
      if(qtDef[iCnt]) then sRes = sRes..sD end
    end; return sRes
  end
  -- Internal type matching
  function self:Match(snValue,ivID,bQuoted,sQuote,bNoRev,bNoNull)
    local qtDef = self:GetDefinition()
    local nvInd = tonumber(ivID); if(not IsHere(nvInd)) then
      LogInstance("Col NAN {"..type(ivID)..tostring(ivID).."> invalid",unpack(logArg)); return nil end
    local defCol = qtDef[nvInd]; if(not IsHere(defCol)) then
      LogInstance("Invalid col #"..tostring(nvInd),unpack(logArg)); return nil end
    local tipCol, sMoDB, snOut = tostring(defCol[2]), GetOpVar("MODE_DATABASE")
    if(tipCol == "TEXT") then snOut = tostring(snValue or "")
      if(not bNoNull and IsBlank(snOut)) then
        if    (sMoDB == "SQL") then snOut = "NULL"
        elseif(sMoDB == "LUA") then snOut = "NULL"
        else LogInstance("Wrong database empty mode <"..sMoDB..">",unpack(logArg)); return nil end
      end
      if    (defCol[3] == "LOW") then snOut = snOut:lower()
      elseif(defCol[3] == "CAP") then snOut = snOut:upper() end
      if(not bNoRev and sMoDB == "SQL" and defCol[4] == "QMK") then
        snOut = snOut:gsub("'","''") end
      if(bQuoted) then local sqChar
        if(sQuote) then
          sqChar = tostring(sQuote or ""):sub(1,1)
        else
          if    (sMoDB == "SQL") then sqChar = "'"
          elseif(sMoDB == "LUA") then sqChar = "\""
          else LogInstance("Wrong database quote mode <"..sMoDB..">",unpack(logArg)); return nil end
        end; snOut = sqChar..snOut..sqChar
      end
    elseif(tipCol == "REAL" or tipCol == "INTEGER") then
      snOut = tonumber(snValue)
      if(IsHere(snOut)) then
        if(tipCol == "INTEGER") then
          if    (defCol[3] == "FLR") then snOut = mathFloor(snOut)
          elseif(defCol[3] == "CEL") then snOut = mathCeil (snOut) end
        end
      else LogInstance("Failed converting {"..type(snValue).."}<"..tostring(snValue).."> to NUMBER col #"..nvInd,unpack(logArg)); return nil end
    else LogInstance("Invalid col type <"..tipCol..">",unpack(logArg)); return nil
    end; return snOut
  end
  -- Build drop statment
  function self:Drop() self:UpdateInfo()
    local qtDef = self:GetDefinition()
    local qtCmd = self:GetCommand()
    qtCmd.Drop  = "DROP TABLE "..qtDef.Name..";"; return self
  end
  -- Build delete statment
  function self:Delete() self:UpdateInfo()
    local qtDef = self:GetDefinition()
    local qtCmd = self:GetCommand()
    qtCmd.Delete = "DELETE FROM "..qtDef.Name..";"; return self
  end
  -- Build create/drop/delete statment table of statemenrts
  function self:Create() self:UpdateInfo()
    local qtDef = self:GetDefinition()
    local qtCmd, iInd = self:GetCommand(), 1
    qtCmd.Create = "CREATE TABLE "..qtDef.Name.." ( "
    while(qtDef[iInd]) do local v = qtDef[iInd]
      if(not v[1]) then
        LogInstance("Missing col name #"..tostring(iInd),unpack(logArg)); return nil end
      if(not v[2]) then
        LogInstance("Missing col type #"..tostring(iInd),unpack(logArg)); return nil end
      qtCmd.Create = qtCmd.Create..(v[1]):upper().." "..(v[2]):upper()
      iInd = (iInd + 1); if(qtDef[iInd]) then qtCmd.Create = qtCmd.Create ..", " end
    end
    qtCmd.Create = qtCmd.Create.." );"; return self
  end
  -- Build SQL table indexes
  function self:Index(...) local tIndex = {...}
    if(not tIndex[1]) then return self end
    local qtCmd, qtDef = self:GetCommand(), self:GetDefinition()
    local iCnt, iInd = 1, 1; qtCmd.Index = {}
    while(tIndex[iInd]) do
      local vI = tIndex[iInd]; if(type(vI) ~= "table") then
        LogInstance("Mismatch value ["..vI.."] not table for ID ["..tostring(iInd).."]",unpack(logArg)); return nil end
      local cU, cC = "", ""; qtCmd.Index[iInd], iCnt = "CREATE INDEX IND_"..qtDef.Name, 1
      while(vI[iCnt]) do
        local vF = tonumber(vI[iCnt]); if(not vF) then
          LogInstance("Mismatch value ["..vF.."] NaN for ID ["..tostring(iInd).."]["..tostring(iCnt).."]",unpack(logArg)); return nil end
        if(not qtDef[vF]) then
          LogInstance("Mismatch. The col ID #"..vF.." missing, max is #"..Table.Size,unpack(logArg)); return nil end
        cU, cC = (cU.."_" ..(qtDef[vF][1]):upper()), (cC..(qtDef[vF][1]):upper()); vI[iCnt] = vF
        iCnt = iCnt + 1; if(vI[iCnt]) then cC = cC ..", " end
      end
      qtCmd.Index[iInd] = qtCmd.Index[iInd]..cU.." ON "..qtDef.Name.." ( "..cC.." );"
      iInd = iInd + 1
    end; return self
  end
  -- Build SQL select statement
  function self:Select(...) self:UpdateInfo()
    local qtCmd = self:GetCommand()
    local qtDef = self:GetDefinition()
    local sStmt, iCnt, tCols = "SELECT ", 1, {...}
    if(tCols[1]) then
      while(tCols[iCnt]) do
        local v = tonumber(tCols[iCnt]); if(not IsHere(v)) then
          LogInstance("Index NAN {"..type(tCols[iCnt]).."}<"..tostring(tCols[iCnt]).."> type mismatch",unpack(logArg)); return nil end
        if(not qtDef[v]) then
          LogInstance("Missing col by index #"..v,unpack(logArg)); return nil end
        if(qtDef[v][1]) then sStmt = sStmt..qtDef[v][1]
        else LogInstance("Missing col name by index #"..v,unpack(logArg)); return nil end
        iCnt = (iCnt + 1); if(tCols[iCnt]) then sStmt = sStmt ..", " end
      end
    else sStmt = sStmt.."*" end
    qtCmd.Select = sStmt .." FROM "..qtDef.Name..";"; return self
  end
  -- Add where clause to the select statement
  function self:Where(...) local tWhere = {...}
    if(not tWhere[1]) then return self end
    local iCnt, qtDef, qtCmd = 1, self:GetDefinition(), self:GetCommand()
    qtCmd.Select = qtCmd.Select:Trim("%s"):Trim(";")
    while(tWhere[iCnt]) do local k = tonumber(tWhere[iCnt][1])
      local v, t = tWhere[iCnt][2], qtDef[k][2]; if(not (k and v and t) ) then
        LogInstance("Where clause inconsistent col index, {"..tostring(k)..","..tostring(v)..","..tostring(t).."}",unpack(logArg)); return nil end
      if(not IsHere(v)) then
        LogInstance("Data matching failed index #"..iCnt.." value <"..tostring(v)..">",unpack(logArg)); return nil end
      if(iCnt == 1) then qtCmd.Select = qtCmd.Select.." WHERE "..qtDef[k][1].." = "..tostring(v)
      else               qtCmd.Select = qtCmd.Select.." AND "  ..qtDef[k][1].." = "..tostring(v) end
      iCnt = iCnt + 1
    end; qtCmd.Select = qtCmd.Select..";"; return self
  end
  -- Add order by clause to the select statement
  function self:Order(...) local tOrder = {...}
    if(not tOrder[1]) then return self end
    local qtCmd, qtDef = self:GetCommand(), self:GetDefinition()
    local sDir, sStmt, iCnt = "", " ORDER BY ", 1
    qtCmd.Select = qtCmd.Select:Trim("%s"):Trim(";")
    while(tOrder[iCnt]) do local v = tOrder[iCnt]
      if(v ~= 0) then if(v > 0) then sDir = " ASC"
        else sDir, tOrder[iCnt] = " DESC", -v; v = -v end
      else LogInstance("Mismatch col index #"..iCnt,unpack(logArg)); return nil end
      sStmt, iCnt = (sStmt..qtDef[v][1]..sDir), (iCnt + 1)
      if(tOrder[iCnt]) then sStmt = sStmt..", " end
    end; qtCmd.Select = qtCmd.Select..sStmt..";" return self
  end
  -- Build SQL insert statement
  function self:Insert(...) self:UpdateInfo()
    local qtCmd, iCnt, qIns = self:GetCommand(), 1, ""
    local tInsert, qtDef = {...}, self:GetDefinition()
    qtCmd.Insert = "INSERT INTO "..qtDef.Name.." ( "
    if(not tInsert[1]) then
      for iCnt = 1, qtDef.Size do qIns = qIns..qtDef[iCnt][1]
        if(iCnt < qtDef.Size) then qIns = qIns..", " else qIns = qIns.." ) " end end
    else
      while(tInsert[iCnt]) do local vInd = tInsert[iCnt]
        local iIns = tonumber(vInd); if(not IsHere(iIns)) then
          LogInstance("Column ID ["..tostring(vInd).."] NaN",unpack(logArg)); return nil end
        local cIns = qtDef[iIns]; if(not IsHere(cIns)) then
          LogInstance("Column ID ["..tostring(iIns).."] mismatch",unpack(logArg)); return nil end
        iCnt, qIns = (iCnt + 1), qIns..cIns[1]
        if(tInsert[iCnt]) then qIns = qIns..", " else qIns = qIns.." ) " end
      end
    end; qtCmd.Insert = qtCmd.Insert..qIns; return self
  end
  -- Build SQL values statement
  function self:Values(...) local tValues = {...}
    local qtCmd, iCnt, qVal = self:GetCommand(), 1, ""
    local tInsert, qtDef = {...}, self:GetDefinition()
    qtCmd.Insert = qtCmd.Insert.." VALUES ( "
    while(tValues[iCnt]) do
      iCnt, qVal = (iCnt + 1), qVal..tostring(tValues[iCnt])
      if(tValues[iCnt]) then qVal = qVal..", " else qVal = qVal.." )" end
    end; qtCmd.Insert = qtCmd.Insert..qVal..";"; return self
  end
  -- Method required initialization
  if(not tonumber(defTab.KeyID)) then
    defTab.KeyID = (libQTable.Size + 1)
  else defTab.KeyID = tonumber(defTab.KeyID) end
  if(libQTable[defTab.KeyID]) then
    LogInstance("Key ID ["..defTab.KeyID.."] exists as <"..tostring(defTab.Nick)..">"); return self:Remove(false)
  end; libQTable[defTab.KeyID] = defTab.Nick; libQTable.Size = (libQTable.Size + 1)
  -- When database mode is SQL create a table in sqlite
  if(sMoDB == "SQL") then local makTab
    makTab = self:Create(); if(not IsHere(makTab)) then
      LogInstance("Build create failed"); return self:Remove(false) end
    makTab = self:Index(unpack(defTab.Index)); if(not IsHere(makTab)) then
      LogInstance("Build index failed"); return self:Remove(false) end
    makTab = self:Drop(); if(not IsHere(makTab)) then
      LogInstance("Build drop failed"); return self:Remove(false) end
    makTab = self:Delete(); if(not IsHere(makTab)) then
      LogInstance("Build delete failed"); return self:Remove(false) end
    makTab = self:TimerSetup(defTab.Timer); if(not IsHere(makTab)) then
      LogInstance("Build timer failed"); return self:Remove(false) end
    local tQ = self:GetCommand(); if(not IsHere(tQ)) then
      LogInstance("Build statement failed"); return self:Remove(false) end
    if(bDelete and sqlTableExists(defTab.Name)) then local qRez = sqlQuery(tQ.Delete)
      if(not qRez and IsBool(qRez)) then
        LogInstance("Table not present. Skipping delete",unpack(logArg))
      else LogInstance("Table deleted",unpack(logArg)) end
    end
    if(bReload) then local qRez = sqlQuery(tQ.Drop)
      if(not qRez and IsBool(qRez)) then
        LogInstance("Table not present. Skipping drop",unpack(logArg))
      else LogInstance("Table dropped",unpack(logArg)) end
    end
    if(sqlTableExists(defTab.Name)) then
      LogInstance("Table exists",unpack(logArg)); return self:IsValid()
    else local qRez = sqlQuery(tQ.Create); if(not qRez and IsBool(qRez)) then
        LogInstance("Table create fail because of "..sqlLastError(),unpack(logArg)); return self:Remove(false) end
      if(sqlTableExists(defTab.Name)) then
        for k, v in pairs(tQ.Index) do qRez = sqlQuery(v); if(not qRez and IsBool(qRez)) then
          LogInstance("Table index create fail ["..k.."] > "..v .." > because of "..sqlLastError(),unpack(logArg)); return self:Remove(false) end
        end; LogInstance("Indexed table created",unpack(logArg)); return self:IsValid()
      else LogInstance("Table create fail because of "..sqlLastError().." Query ran > "..tQ.Create,unpack(logArg)); return self:Remove(false) end
    end
  elseif(sMoDB == "LUA") then LogInstance("Created",unpack(logArg)); return self:IsValid()
  else LogInstance("Wrong database mode <"..sMoDB..">",unpack(logArg)); return self:Remove(false) end
end

function InsertRecord(sTable,arLine)
  if(not IsHere(sTable)) then
    LogInstance("Missing table name/values"); return false end
  if(type(sTable) == "table") then
    arLine, sTable = sTable, DefaultTable()
    if(not (IsHere(sTable) and IsString(sTable) and not IsBlank(sTable))) then
      LogInstance(""..tostring(sTable)); return false end
  end
  if(not IsString(sTable)) then
    LogInstance("Table name {"..type(sTable).."}<"..tostring(sTable).."> not string"); return false end
  if(not arLine) then
    LogInstance("Missing data table for "..sTable); return false end
  if(not arLine[1]) then LogInstance("Missing PK for "..sTable)
    for key, val in pairs(arLine) do LogInstance("PK data ["..tostring(key).."] = <"..tostring(val)..">") end
    return false
  end -- Read SQL builder object
  local makTab = libQTable[sTable]; if(not IsHere(makTab)) then
    LogInstance("Missing builder for "..sTable); return false end
  local defTab, sMoDB, sFunc = makTab:GetDefinition(), GetOpVar("MODE_DATABASE"), debugGetinfo(1).name
  -- Call the trigger when provided
  local tTrg = defTab.Trigs; if(tTrg and IsTable(tTrg) and IsFunction(tTrg[sFunc])) then tTrg[sFunc](arLine) end
  -- Populate the data after the trigger does its thing
  if(sMoDB == "SQL") then local qsKey = sFunc..sTable
    for iD = 1, defTab.Size do arLine[iD] = makTab:Match(arLine[iD],iD,true) end
    local Q = CacheStmt(qsKey, nil, unpack(arLine))
    if(not Q) then local sStmt = makTab:Insert():Values(unpack(defTab.Query[sFunc])):Get()
      if(not IsHere(sStmt)) then LogInstance("Build statement <"..sTable.."> failed"); return nil end
      Q = CacheStmt(qsKey, sStmt, unpack(arLine))
    end -- The query is built based on table definition
    if(not IsHere(Q)) then
      LogInstance( "Internal cache error <"..sTable..">"); return false end
    local qRez = sqlQuery(Q); if(not qRez and IsBool(qRez)) then
       LogInstance("Failed to insert a record because of <"..sqlLastError().."> Query ran <"..Q..">"); return false end
    return true -- The dynamic statement insertion was successful
  elseif(sMoDB == "LUA") then
    local snPrimaryKey = makTab:Match(arLine[1],1)
    if(not IsHere(snPrimaryKey)) then -- If primary key becomes a number
      LogInstance("Cannot match primary key "..sTable.." <"..tostring(arLine[1]).."> to "..defTab[1][1].." for "..tostring(snPrimaryKey)); return nil end
    local tCache = libCache[defTab.Name]; if(not IsHere(tCache)) then
      LogInstance("Cache not allocated for "..defTab.Name); return false end
    if(sTable == "PIECES") then
      local stData = tCache[snPrimaryKey]; if(not stData) then
        tCache[snPrimaryKey] = {}; stData = tCache[snPrimaryKey] end
      if(not IsHere(stData.Type)) then stData.Type = arLine[2] end
      if(not IsHere(stData.Name)) then stData.Name = arLine[3] end
      if(not IsHere(stData.Unit)) then stData.Unit = arLine[8] end
      if(not IsHere(stData.Size)) then stData.Size = 0        end
      if(not IsHere(stData.Slot)) then stData.Slot = snPrimaryKey end
      local nOffsID = makTab:Match(arLine[4],4); if(not IsHere(nOffsID)) then
        LogInstance("Cannot match "..sTable.." <"..tostring(arLine[4]).."> to "..defTab[4][1].." for "..tostring(snPrimaryKey)); return nil end
      local stPOA = RegisterPOA(stData,nOffsID,arLine[5],arLine[6],arLine[7]); if(not IsHere(stPOA)) then
        LogInstance("Cannot process offset #"..tostring(nOffsID).." for "..tostring(snPrimaryKey)); return nil end
      if(nOffsID > stData.Size) then stData.Size = nOffsID else
        LogInstance("Offset #"..tostring(nOffsID).." sequential mismatch"); return nil end
    elseif(sTable == "ADDITIONS") then
      local stData = tCache[snPrimaryKey]; if(not stData) then
        tCache[snPrimaryKey] = {}; stData = tCache[snPrimaryKey] end
      if(not IsHere(stData.Size)) then stData.Size = 0 end
      if(not IsHere(stData.Slot)) then stData.Slot = snPrimaryKey end
      local nCnt, sFld, nAddID = 2, "", makTab:Match(arLine[4],4)
      if(not IsHere(nAddID)) then LogInstance("Cannot match "..sTable.." <"..tostring(arLine[4]).."> to "..defTab[4][1].." for "..tostring(snPrimaryKey)); return nil end
      stData[nAddID] = {} -- LineID has to be set properly
      while(nCnt <= defTab.Size) do
        sFld = defTab[nCnt][1]
        stData[nAddID][sFld] = makTab:Match(arLine[nCnt],nCnt)
        if(not IsHere(stData[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          LogInstance("Cannot match "..sTable.." <"..tostring(arLine[nCnt]).."> to "..defTab[nCnt][1].." for "..tostring(snPrimaryKey)); return nil end
        nCnt = nCnt + 1
      end; stData.Size = nAddID
    elseif(sTable == "PHYSPROPERTIES") then
      local skName, skType = GetOpVar("HASH_PROPERTY_NAMES"), GetOpVar("HASH_PROPERTY_TYPES")
      local tTypes = tCache[skType]; if(not tTypes) then
        tCache[skType] = {}; tTypes = tCache[skType]; tTypes.Size = 0 end
      local tNames = tCache[skName]; if(not tNames) then
        tCache[skName] = {}; tNames = tCache[skName] end
      local iNameID = makTab:Match(arLine[2],2)
      if(not IsHere(iNameID)) then -- LineID has to be set properly
        LogInstance("Cannot match "..sTable.." <"..tostring(arLine[2]).."> to "..defTab[2][1].." for "..tostring(snPrimaryKey)); return nil end
      if(not IsHere(tNames[snPrimaryKey])) then
        -- If a new type is inserted
        tTypes.Size = tTypes.Size + 1
        tTypes[tTypes.Size] = snPrimaryKey
        tNames[snPrimaryKey] = {}
        tNames[snPrimaryKey].Size = 0
        tNames[snPrimaryKey].Slot = snPrimaryKey
      end -- Data matching crashes only on numbers
      tNames[snPrimaryKey].Size = iNameID
      tNames[snPrimaryKey][iNameID] = makTab:Match(arLine[3],3)
    else
      LogInstance("No settings for table "..sTable); return false
    end
  end
end

--------------- TIMER MEMORY MANAGMENT ----------------------------

function CacheBoxLayout(oEnt,nRot,nCamX,nCamZ)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity invalid <"..tostring(oEnt)..">"); return nil end
  local sMod = oEnt:GetModel()
  local oRec = CacheQueryPiece(sMod); if(not IsHere(oRec)) then
    LogInstance("Piece record invalid <"..sMod..">"); return nil end
  local stBox = oRec.Layout; if(not IsHere(stBox)) then
    local vMin, vMax; oRec.Layout = {}; stBox = oRec.Layout
    if    (CLIENT) then vMin, vMax = oEnt:GetRenderBounds()
    elseif(SERVER) then vMin, vMax = oEnt:OBBMins(), oEnt:OBBMaxs()
    else LogInstance("Wrong instance"); return nil end
    stBox.Ang = Angle () -- Layout entity angle
    stBox.Cen = Vector() -- Layout entity center
    stBox.Cen:Set(vMax); stBox.Cen:Add(vMin); stBox.Cen:Mul(0.5)
    stBox.Eye = oEnt:LocalToWorld(stBox.Cen) -- Layout camera eye
    stBox.Len = ((vMax - vMin):Length() / 2) -- Layout border sphere radius
    stBox.Cam = Vector(); stBox.Cam:Set(stBox.Eye)  -- Layout camera position
    AddVectorXYZ(stBox.Cam,stBox.Len*(tonumber(nCamX) or 0),0,stBox.Len*(tonumber(nCamZ) or 0))
    LogInstance(""..tostring(stBox.Cen).." # "..tostring(stBox.Len))
  end; stBox.Ang[caY] = (tonumber(nRot) or 0) * Time(); return stBox
end

--------------------------- PIECE QUERY -----------------------------

function CacheQueryPiece(sModel)
  if(not IsHere(sModel)) then
    LogInstance("Model does not exist"); return nil end
  if(not IsString(sModel)) then
    LogInstance("Model {"..type(sModel).."}<"..tostring(sModel).."> not string"); return nil end
  if(IsBlank(sModel)) then
    LogInstance("Model empty string"); return nil end
  if(not utilIsValidModel(sModel)) then
    LogInstance("Model invalid <"..sModel..">"); return nil end
  local makTab = libQTable["PIECES"]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition()
  local tCache = libCache[defTab.Name] -- Match the model casing
  local sModel = makTab:Match(sModel,1,false,"",true,true)
  if(not IsHere(tCache)) then
    LogInstance("Cache not allocated for <"..defTab.Name..">"); return nil end
  local stPiece = tCache[sModel]
  if(IsHere(stPiece) and IsHere(stPiece.Size)) then
    if(stPiece.Size <= 0) then stPiece = nil else
      stPiece = makTab:TimerRestart("CacheQueryPiece", defTab.Name, sModel) end
    return stPiece
  else
    local sMoDB = GetOpVar("MODE_DATABASE")
    if(sMoDB == "SQL") then
      local qModel = makTab:Match(sModel,1,true)
      LogInstance("Model >> Pool <"..sModel:GetFileFromFilename()..">")
      tCache[sModel] = {}; stPiece = tCache[sModel]; stPiece.Size = 0
      local Q = CacheStmt("stmtSelectPiece", nil, qModel)
      if(not Q) then
        local sStmt = makTab:Select():Where({1,"%s"}):Order(4):Get()
        if(not IsHere(sStmt)) then
          LogInstance("Build statement failed"); return nil end
        Q = CacheStmt("stmtSelectPiece", sStmt, qModel)
      end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
      if(not (qData and qData[1])) then
        LogInstance("No data found <"..Q..">"); return nil end
      local iCnt = 1 --- Nothing registered. Start from the beginning
      stPiece.Slot, stPiece.Size = sModel, 0
      stPiece.Type = qData[1][defTab[2][1]]
      stPiece.Name = qData[1][defTab[3][1]]
      stPiece.Unit = qData[1][defTab[8][1]]
      while(qData[iCnt]) do
        local qRec = qData[iCnt]
        if(not IsHere(RegisterPOA(stPiece,iCnt,
                                      qRec[defTab[5][1]],
                                      qRec[defTab[6][1]],
                                      qRec[defTab[7][1]]))) then
          LogInstance("Cannot process offset #"..tostring(stPiece.Size).." for <"..sModel..">"); return nil end
        stPiece.Size, iCnt = iCnt, (iCnt + 1)
      end; stPiece = makTab:TimerAttach("CacheQueryPiece", defTab.Name, sModel); return stPiece
    elseif(sMoDB == "LUA") then LogInstance("Record not located"); return nil
    else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
  end
end

function CacheQueryAdditions(sModel)
  if(not IsHere(sModel)) then
    LogInstance("Model does not exist"); return nil end
  if(not IsString(sModel)) then
    LogInstance("Model {"..type(sModel).."}<"..tostring(sModel).."> not string"); return nil end
  if(IsBlank(sModel)) then
    LogInstance("Model empty string"); return nil end
  if(not utilIsValidModel(sModel)) then
    LogInstance("Model invalid"); return nil end
  local makTab = libQTable["ADDITIONS"]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition()
  local tCache = libCache[defTab.Name] -- Match the model casing
  local sModel = makTab:Match(sModel,1,false,"",true,true)
  if(not IsHere(tCache)) then
    LogInstance("Cache not allocated for <"..defTab.Name..">"); return nil end
  local stAddit = tCache[sModel]
  if(IsHere(stAddit) and IsHere(stAddit.Size)) then
    if(stAddit.Size <= 0) then stAddit = nil else
      stAddit = TimerRestart(libCache,caInd,defTab,"CacheQueryAdditions") end
    return stAddit
  else
    local sMoDB = GetOpVar("MODE_DATABASE")
    if(sMoDB == "SQL") then
      local qModel = makTab:Match(sModel,1,true)
      LogInstance("Model >> Pool <"..sModel:GetFileFromFilename()..">")
      tCache[sModel] = {}; stAddit = tCache[sModel]; stAddit.Size = 0
      local Q = CacheStmt("stmtSelectAdditions", nil, qModel)
      if(not Q) then
        local sStmt = makTab:Select(2,3,4,5,6,7,8,9,10,11,12):Where({1,"%s"}):Order(4):Get()
        if(not IsHere(sStmt)) then
          LogInstance("Build statement failed"); return nil end
        Q = CacheStmt("stmtSelectAdditions", sStmt, qModel)
      end
      local qData = sqlQuery(Q); if(not qData and IsBool(qData)) then
        LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
      if(not (qData and qData[1])) then
        LogInstance("No data found <"..Q..">"); return nil end
      local iCnt = 1; stAddit.Slot, stAddit.Size = sModel, 0
      while(qData[iCnt]) do
        local qRec = qData[iCnt]; stAddit[iCnt] = {}
        for col, val in pairs(qRec) do stAddit[iCnt][col] = val end
        stAddit.Size, iCnt = iCnt, (iCnt + 1)
      end; stAddit = makTab:TimerAttach("CacheQueryAdditions", defTab.Name, sModel); return stAddit
    elseif(sMoDB == "LUA") then LogInstance("Record not located"); return nil
    else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
  end
end

----------------------- PANEL QUERY -------------------------------

--[[
 * Caches the date needed to populate the CPanel tree
]]--
function CacheQueryPanel()
  local makTab = libQTable["PIECES"]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(libCache[defTab.Name])) then
    LogInstance("Missing cache allocated <"..defTab.Name..">"); return nil end
  local keyPan = GetOpVar("HASH_USER_PANEL")
  local stPanel = libCache[keyPan]
  if(IsHere(stPanel) and IsHere(stPanel.Size)) then LogInstance("From Pool")
    if(stPanel.Size <= 0) then stPanel = nil else
      stPanel = makTab:TimerRestart("CacheQueryPanel", keyPan) end
    return stPanel
  else
    libCache[keyPan] = {}; stPanel = libCache[keyPan]
    local sMoDB = GetOpVar("MODE_DATABASE")
    if(sMoDB == "SQL") then
      local Q = CacheStmt("stmtSelectPanel", nil, 1)
      if(not Q) then
        local sStmt = makTab:Select(1,2,3):Where({4,"%d"}):Order(2,3):Get()
        if(not IsHere(sStmt)) then
          LogInstance("Build statement failed"); return nil end
        Q = CacheStmt("stmtSelectPanel", sStmt, 1)
      end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
      if(not (qData and qData[1])) then
        LogInstance("No data found <"..Q..">"); return nil end
      local iCnt = 1; stPanel.Size = 1
      while(qData[iCnt]) do
        stPanel[iCnt] = qData[iCnt]; stPanel.Size, iCnt = iCnt, (iCnt + 1)
      end; stPanel = makTab:TimerAttach("CacheQueryPanel", keyPan); return stPanel
    elseif(sMoDB == "LUA") then
      local tCache = libCache[defTab.Name]
      local tSort  = Sort(tCache,{"Type","Name"}); if(not tSort) then
        LogInstance("Cannot sort cache data"); return nil end; stPanel.Size = 0
      for iCnt = 1, tSort.Size do stPanel[iCnt] = {}
        local vSort, vPanel = tSort[iCnt], stPanel[iCnt]
        vPanel[defTab[1][1]] = vSort.Key
        vPanel[defTab[2][1]] = tCache[vSort.Key].Type
        vPanel[defTab[3][1]] = tCache[vSort.Key].Name; stPanel.Size = iCnt
      end; return stPanel
    else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
    LogInstance("To Pool")
  end
end

--[[
 * Used to Populate the CPanel Phys Materials
 * If type is chosen, it gets the names for the type
 * If type is not chosen, it gets a list of all types
]]--
function CacheQueryProperty(sType)
  local makTab = libQTable["PHYSPROPERTIES"]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition()
  local tCache = libCache[defTab.Name]; if(not tCache) then
    LogInstance("Cache not allocated for <"..defTab.Name..">"); return nil end
  local sMoDB = GetOpVar("MODE_DATABASE")
  if(IsString(sType) and not IsBlank(sType)) then
    local sType = makTab:Match(sType,1,false,"",true,true)
    local keyName = GetOpVar("HASH_PROPERTY_NAMES")
    local arNames = tCache[keyName]
    if(not IsHere(arNames)) then
      tCache[keyName] = {}; arNames = tCache[keyName] end
    local stName = arNames[sType]
    if(IsHere(stName) and IsHere(stName.Size)) then LogInstance("Names << Pool")
      if(stName.Size <= 0) then stName = nil else
        stName = makTab:TimerRestart("CacheQueryProperty", defTab.Name, keyName, sType) end
      return stName
    else
      if(sMoDB == "SQL") then
        local qType = makTab:Match(sType,1,true)
        arNames[sType] = {}; stName = arNames[sType]; stName.Size = 0
        local Q = CacheStmt("stmtSelectPropertyNames", nil, qType)
        if(not Q) then
          local sStmt = makTab:Select(3):Where({1,"%s"}):Order(2)
          if(not IsHere(sStmt)) then
            LogInstance("Build statement failed"); return nil end
          Q = CacheStmt("stmtSelectPropertyNames", sStmt, qType)
        end
        local qData = sqlQuery(Q)
        if(not qData and IsBool(qData)) then
          LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
        if(not (qData and qData[1])) then
          LogInstance("No data found <"..Q..">"); return nil end
        local iCnt = 1; stName.Size, stName.Slot = 0, sType
        while(qData[iCnt]) do
          stName[iCnt] = qData[iCnt][defTab[3][1]]
          stName.Size, iCnt = iCnt, (iCnt + 1)
        end; LogInstance("Names >> Pool")
        stName = makTab:TimerAttach("CacheQueryProperty", defTab.Name, keyName, sType); return stName
      elseif(sMoDB == "LUA") then LogInstance("Record not located"); return nil
      else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
    end
  else
    local keyType = GetOpVar("HASH_PROPERTY_TYPES")
    local stType  = tCache[keyType]
    if(IsHere(stType) and IsHere(stType.Size)) then
      LogInstance("Types << Pool")
      if(stType.Size <= 0) then stType = nil else
        stType = makTab:TimerRestart("CacheQueryProperty", defTab.Name, keyType) end
      return stType
    else
      if(sMoDB == "SQL") then
        tCache[keyType] = {}; stType = tCache[keyType]; stType.Size = 0
        local Q = CacheStmt("stmtSelectPropertyTypes", nil, 1)
        if(not Q) then
          local sStmt = makTab:Select(1):Where({2,"%d"}):Order(1):Get()
          if(not IsHere(sStmt)) then
            LogInstance("Build statement failed"); return nil end
          Q = CacheStmt("stmtSelectPropertyTypes", sStmt, 1)
        end
        local qData = sqlQuery(Q)
        if(not qData and IsBool(qData)) then
          LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
        if(not (qData and qData[1])) then
          LogInstance("No data found <"..Q..">"); return nil end
        local iCnt = 1; stType.Size = 0
        while(qData[iCnt]) do
          stType[iCnt] = qData[iCnt][defTab[1][1]]
          stType.Size, iCnt = iCnt, (iCnt + 1)
        end; LogInstance("Types >> Pool")
        stType = makTab:TimerAttach("CacheQueryProperty", defTab.Name, keyType); return stType
      elseif(sMoDB == "LUA") then LogInstance("Record not located"); return nil
      else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
    end
  end
end

---------------------- EXPORT --------------------------------

--[[
 * Save/Load the DB Using Excel or
 * anything that supports delimiter separated digital tables
 * sTable > Definition KEY to export
 * tData  > The local data table to be exported ( if given )
 * sPref  > Prefix used on exporting ( if not uses instance prefix)
]]--
function ExportCategory(vEq, tData, sPref)
  if(SERVER) then LogInstance( "ExportCategory: Working on server"); return true end
  local nEq   = (tonumber(vEq) or 0); if(nEq <= 0) then
    LogInstance( "ExportCategory: Wrong equality <"..tostring(vEq)..">"); return false end
  local sPref = tostring(sPref or GetInstPref()); if(IsBlank(sPref)) then
    LogInstance("("..sPref..") Prefix empty"); return false end
  local fName = GetOpVar("DIRPATH_BAS")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..sPref..GetOpVar("TOOLNAME_PU").."CATEGORY.txt"
  local F = fileOpen(fName, "wb", "DATA")
  if(not F) then LogInstance("("..sPref..") fileOpen("..fName..") failed from"); return false end
  local sEq, nLen, sMod = ("="):rep(nEq), (nEq+2), GetOpVar("MODE_DATABASE")
  local tCat = (type(tData) == "table") and tData or GetOpVar("TABLE_CATEGORIES")
  F:Write("# ExportCategory( "..tostring(nEq).." )("..sPref.."): "..GetDate().." [ "..sMod.." ]".."\n")
  for cat, rec in pairs(tCat) do
    if(IsString(rec.Txt)) then
      local exp = "["..sEq.."["..cat..sEq..rec.Txt:Trim().."]"..sEq.."]"
      if(not rec.Txt:find("\n")) then F:Flush(); F:Close()
        LogInstance( "ExportCategory("..sPref.."):("..sPref..") Category one-liner <"..cat..">"); return false end
      F:Write(exp.."\n")
    else F:Flush(); F:Close(); LogInstance( "ExportCategory("..sPref.."):("..sPref..") Category <"..cat.."> code <"..tostring(rec.Txt).."> mismatch"); return false end
  end; F:Flush(); F:Close(); LogInstance( "ExportCategory("..sPref.."):("..sPref..") Success"); return true
end

function ImportCategory(vEq, sPref)
  if(SERVER) then LogInstance( "ImportCategory: Working on server"); return true end
  local nEq = (tonumber(vEq) or 0); if(nEq <= 0) then
    LogInstance("Wrong equality <"..tostring(vEq)..">"); return false end
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..tostring(sPref or GetInstPref())
        fName = fName..GetOpVar("TOOLNAME_PU").."CATEGORY.txt"
  local F = fileOpen(fName, "rb", "DATA")
  if(not F) then LogInstance("fileOpen("..fName..") failed"); return false end
  local sEq, sLine, nLen = ("="):rep(nEq), "", (nEq+2)
  local cFr, cBk = "["..sEq.."[", "]"..sEq.."]"
  local tCat, symOff = GetOpVar("TABLE_CATEGORIES"), GetOpVar("OPSYM_DISABLE")
  local sPar, isPar, isEOF = "", false, false
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if(not IsBlank(sLine)) then
      local sFr, sBk = sLine:sub(1,nLen), sLine:sub(-nLen,-1)
      if(sFr == cFr and sBk == cBk) then
        sLine, isPar, sPar = sLine:sub(nLen+1,-1), true, "" end
      if(sFr == cFr and not isPar) then
        sPar, isPar = sLine:sub(nLen+1,-1).."\n", true
      elseif(sBk == cBk and isPar) then
        sPar, isPar = sPar..sLine:sub(1,-nLen-1), false
        local tBoo = sEq:Explode(sPar)
        local key, txt = tBoo[1]:Trim(), tBoo[2]
        if(not IsBlank(key)) then
          if(txt:find("function")) then
            if(key:sub(1,1) ~= symOff) then
              tCat[key] = {}; tCat[key].Txt = txt:Trim()
              tCat[key].Cmp = CompileString("return ("..tCat[key].Txt..")",key)
              local suc, out = pcall(tCat[key].Cmp)
              if(suc) then tCat[key].Cmp = out else tCat[key].Cmp = nil
                LogInstance("Compilation fail <"..key..">")
              end
            else LogInstance("Key skipped <"..key..">") end
          else LogInstance("Function missing <"..key..">") end
        else LogInstance("Name missing <"..txt..">") end
      else sPar = sPar..sLine.."\n" end
    end
  end; F:Close(); LogInstance( "ImportCategory: Success"); return true
end

--[[
 * This function removes DSV associated with a given prefix
 * sTable > Extremal table database to export
 * sPref  > Prefix used on exporting ( if any ) else instance is used
]]--
function RemoveDSV(sTable, sPref)
  local sPref = tostring(sPref or GetInstPref()); if(IsBlank(sPref)) then
    LogInstance("("..sPref..") Prefix empty"); return false end
  if(not IsString(sTable)) then
    LogInstance("("..sPref..") Table {"..type(sTable).."}<"..tostring(sTable).."> not string"); return false end
  local makTab = libQTable[sTable]; if(not IsHere(makTab)) then
    LogInstance("("..sPref..") Missing table definition"); return nil end
  local defTab = makTab:GetDefinition(); if(not defTab) then
    LogInstance("("..sPref..") Missing table definition for <"..sTable..">"); return false end
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")..sPref..defTab.Name..".txt"
  if(not fileExists(fName,"DATA")) then
    LogInstance("("..sPref..") File <"..fName.."> missing"); return true end
  fileDelete(fName); LogInstance("("..sPref..") Success"); return true
end

--[[
 * This function exports a given table to DSV file format
 * It is used by the user when he wants to export the
 * whole database to a delimiter separator format file
 * sTable > The table you want to export
 * sPref  > The external data prefix to be used
 * sDelim > What delimiter is the server using ( default tab )
]]--
function ExportDSV(sTable, sPref, sDelim)
  if(not IsString(sTable)) then
    LogInstance("Table {"..type(sTable).."}<"..tostring(sTable).."> not string"); return false end
  local makTab = libQTable[sTable]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder for <"..sTable..">"); return false end
  local defTab = makTab:GetDefinition()
  local fName, sPref = GetOpVar("DIRPATH_BAS"), tostring(sPref or GetInstPref())
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..sPref..defTab.Name..".txt"
  local F = fileOpen(fName, "wb", "DATA" ); if(not F) then
    LogInstance("("..sPref..") fileOpen("..fName..") failed"); return false end
  local sDelim, sFunc = tostring(sDelim or "\t"):sub(1,1), debugGetinfo(1).name
  local sMoDB, symOff = GetOpVar("MODE_DATABASE"), GetOpVar("OPSYM_DISABLE")
  F:Write("# "..sFunc..":("..fPref.."@"..sTable..") "..GetDate().." [ "..sMoDB.." ]".."\n")
  F:Write("# Data settings:("..makTab:GetColumnList(sDelim)..")\n")
  if(sMoDB == "SQL") then
    local Q = makTab:Select():Order(defTab.Query[sFunc]):Get()
    if(not IsHere(Q)) then F:Flush(); F:Close()
      LogInstance("("..sPref..") Build statement failed"); return false end
    F:Write("# Query ran: <"..Q..">\n")
    local qData = sqlQuery(Q)
    if(not qData and IsBool(qData)) then F:Flush(); F:Close()
      LogInstance("("..sPref..") SQL exec error <"..sqlLastError()..">"); return nil end
    if(not (qData and qData[1])) then F:Flush(); F:Close()
      LogInstance("("..sPref..") No data found <"..Q..">"); return false end
    local sData, sTab = "", defTab.Name
    for iCnt = 1, #qData do
      local qRec  = qData[iCnt]; sData = sTab
      for iInd = 1, defTab.Size do
        local sHash = defTab[iInd][1]
        sData = sData..sDelim..makTab:Match(qRec[sHash],iInd,true,"\"",true)
      end; F:Write(sData.."\n"); sData = ""
    end -- Matching will not crash as it is matched during insertion
  elseif(sMoDB == "LUA") then
    local tCache = libCache[defTab.Name]
    if(not IsHere(tCache)) then F:Flush(); F:Close()
      LogInstance("("..sPref..") Table <"..defTab.Name.."> cache not allocated"); return false end
    if(sTable == "PIECES") then local tData = {}
      for sModel, tRecord in pairs(tCache) do
        local sSort   = (tRecord.Type..tRecord.Name..sModel)
        tData[sModel] = {[defTab[1][1]] = sSort}
      end
      local tSort = Sort(tData,{defTab[1][1]})
      if(not tSort) then F:Flush(); F:Close()
        LogInstance("("..sPref..") Cannot sort cache data"); return false end
      for iIdx = 1, tSort.Size do
        local stRec = tSort[iIdx]
        local tData = tCache[stRec.Key]
        local sData = defTab.Name
              sData = sData..sDelim..makTab:Match(stRec.Key,1,true,"\"")..sDelim..
                makTab:Match(tData.Type,2,true,"\"")..sDelim..
                makTab:Match(((ModelToName(stRec.Key) == tData.Name) and symOff or tData.Name),3,true,"\"")
        local tOffs = tData.Offs
        -- Matching crashes only for numbers. The number is already inserted, so there will be no crash
        for iInd = 1, #tOffs do
          local stPnt = tData.Offs[iInd]
          F:Write(sData..sDelim..makTab:Match(iInd,4,true,"\"")..sDelim..
                   "\""..(IsEqualPOA(stPnt.P,stPnt.O) and "" or StringPOA(stPnt.P,"V")).."\""..sDelim..
                   "\""..  StringPOA(stPnt.O,"V").."\""..sDelim..
                   "\""..( IsZeroPOA(stPnt.A,"A") and "" or StringPOA(stPnt.A,"A")).."\""..sDelim..
                   "\""..(tData.Unit and tostring(tData.Unit or "") or "").."\"\n")
        end
      end
    elseif(sTable == "ADDITIONS") then
     for mod, rec in pairs(tCache) do
        local sData = defTab.Name..sDelim..mod
        for iIdx = 1, #rec do
          local tData = rec[iIdx]; F:Write(sData)
          for iID = 2, defTab.Size do
            local vData = tData[defTab[iID][1]]
            F:Write(sDelim..makTab:Match(tData[defTab[iID][1]],iID,true,"\""))
          end; F:Write("\n") -- Data is already inserted, there will be no crash
        end
      end
    elseif(sTable == "PHYSPROPERTIES") then
      local tTypes = tCache[GetOpVar("HASH_PROPERTY_TYPES")]
      local tNames = tCache[GetOpVar("HASH_PROPERTY_NAMES")]
      if(not (tTypes or tNames)) then F:Flush(); F:Close()
        LogInstance("("..sPref..") No data found"); return false end
      for iInd = 1, tTypes.Size do
        local sType = tTypes[iInd]
        local tType = tNames[sType]
        if(not tType) then F:Flush(); F:Close()
          LogInstance("("..sPref..") Missing index #"..iInd.." on type <"..sType..">"); return false end
        for iCnt = 1, tType.Size do
          F:Write(defTab.Name..sDelim..makTab:Match(sType      ,1,true,"\"")..
                               sDelim..makTab:Match(iCnt       ,2,true,"\"")..
                               sDelim..makTab:Match(tType[iCnt],3,true,"\"").."\n")
        end
      end
    end
  end; F:Flush(); F:Close()
end

--[[
 * Import table data from DSV database created earlier
 * sTable > Definition KEY to import
 * bComm  > Calls @InsertRecord(sTable,arLine) when set to true
 * sPref  > Prefix used on importing ( if any )
 * sDelim > Delimiter separating the values
]]--
function ImportDSV(sTable, bComm, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref()); if(not IsString(sTable)) then
    LogInstance("("..fPref..") Table {"..type(sTable).."}<"..tostring(sTable).."> not string"); return false end
  local makTab = libQTable[sTable]; if(not IsHere(makTab)) then
    LogInstance("("..fPref..") Missing table definition"); return nil end
  local defTab = makTab:GetDefinition(); if(not defTab) then
    LogInstance("("..fPref..") Missing table definition for <"..sTable..">"); return false end
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..fPref..defTab.Name..".txt"
  local F = fileOpen(fName, "rb", "DATA"); if(not F) then
    LogInstance("("..fPref..") fileOpen("..fName..") failed"); return false end
  local symOff, sDelim = GetOpVar("OPSYM_DISABLE"), tostring(sDelim or "\t"):sub(1,1)
  local sLine, isEOF, nLen = "", false, defTab.Name:len()
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if((not IsBlank(sLine)) and (sLine:sub(1,1) ~= symOff)) then
      if(sLine:sub(1,nLen) == defTab.Name) then
        local tData = sDelim:Explode(sLine:sub(nLen+2,-1))
        for iCnt = 1, defTab.Size do
          tData[iCnt] = GetStrip(tData[iCnt]) end
        if(bComm) then InsertRecord(sTable, tData) end
      end
    end
  end; F:Close(); LogInstance("("..fPref.."@"..sTable.."): Success"); return true
end

--[[
 * This function synchronizes extended database records loaded by the server and client
 * It is used by addon creators when they want to add extra pieces
 * sTable > The table you want to sync
 * tData  > Data you want to add as extended records for the given table
 * bRepl  > If set to /true/ replaces persisting records with the addon
 * sPref  > The external data prefix to be used
 * sDelim > What delimiter is the server using
]]--
function SynchronizeDSV(sTable, tData, bRepl, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref()); if(not IsString(sTable)) then
    LogInstance("("..fPref..") Table {"..type(sTable).."}<"..tostring(sTable).."> not string"); return false end
  local makTab = libQTable[sTable]; if(not IsHere(makTab)) then
    LogInstance("("..fPref..") Missing table builder for <"..sTable..">"); return false end
  local defTab, iD = makTab:GetDefinition(), makTab:GetColumnID("LINEID")
  local fName, sDelim = GetOpVar("DIRPATH_BAS"), tostring(sDelim or "\t"):sub(1,1)
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..fPref..defTab.Name..".txt"
  local I, fData, symOff = fileOpen(fName, "rb", "DATA"), {}, GetOpVar("OPSYM_DISABLE")
  if(I) then local sLine, isEOF = "", false
    while(not isEOF) do sLine, isEOF = GetStringFile(I)
      if((not IsBlank(sLine)) and (sLine:sub(1,1) ~= symOff)) then
        local tLine = sDelim:Explode(sLine)
        if(tLine[1] == defTab.Name) then
          for iCnt = 1, #tLine do tLine[iCnt] = GetStrip(tLine[iCnt]) end
          local sKey = tLine[2]; if(not fData[sKey]) then fData[sKey] = {Size = 0} end
          -- Where the lime ID must be read from
          local tKey, vID, nID = fData[sKey], tLine[iD+1]; nID = (tonumber(vID) or 0)
          if((tKey.Size < 0) or (nID <= tKey.Size) or ((nID - tKey.Size) ~= 1)) then
            I:Close(); LogInstance("("..fPref..") Read point ID #"..
              tostring(vID).." desynchronized <"..sKey.."> of <"..sTable..">"); return false end
          tKey.Size = nID; tKey[tKey.Size] = {}
          local kKey, nCnt = tKey[tKey.Size], 3
          while(tLine[nCnt]) do -- Do a value matching without quotes
            local vM = makTab:Match(tLine[nCnt],nCnt-1); if(not IsHere(vM)) then
              I:Close(); LogInstance("("..fPref..") Read matching failed <"
                ..tostring(tLine[nCnt]).."> to <"..tostring(nCnt-1).." # "
                  ..defTab[nCnt-1][1].."> of <"..sTable..">"); return false
            end; kKey[nCnt-2] = vM; nCnt = nCnt + 1
          end
        else I:Close()
          LogInstance("("..fPref..") Read table name mismatch <"..sTable..">"); return false end
      end
    end; I:Close()
  else LogInstance("("..fPref..") Creating file <"..fName..">") end
  for key, rec in pairs(tData) do -- Check the given table
    for pnID = 1, #rec do -- Where the line ID must be read from
      local tRec, vID, nID = rec[pnID]; vID = tRec[iD-1]
      nID = (tonumber(vID) or 0); if(pnID ~= nID) then
          LogInstance("("..fPref..") Given point ID #"..
            tostring(vID).." desynchronized <"..key.."> of "..sTable); return false end
      for nCnt = 1, #tRec do -- Do a value matching without quotes
        local vM = makTab:Match(tRec[nCnt],nCnt+1); if(not IsHere(vM)) then
          LogInstance("("..fPref..") Given matching failed <"
            ..tostring(tRec[nCnt]).."> to <"..tostring(nCnt+1).." # "
              ..defTab[nCnt+1][1].."> of "..sTable); return false
        end
      end
    end -- Register the read line to the output file
    if(bRepl) then
      if(tData[key]) then -- Update the file with the new data
        fData[key] = rec; fData[key].Size = #rec end
    else --[[ Do not modify fData ]] end
  end
  local tSort = Sort(tableGetKeys(fData)); if(not tSort) then
    LogInstance("("..fPref..") Sorting failed"); return false end
  local O = fileOpen(fName, "wb" ,"DATA"); if(not O) then
    LogInstance("("..fPref..") Write fileOpen("..fName..") failed"); return false end
  local sFunc, sMoDB = debugGetinfo(1).name, GetOpVar("MODE_DATABASE")
  O:Write("# "..sFunc..":("..fPref.."@"..sTable..") "..GetDate().." [ "..sMoDB.." ]".."\n")
  O:Write("# Data settings:("..makTab:GetColumnList(sDelim)..")\n")
  for rcID = 1, tSort.Size do local key = tSort[rcID].Val
    local vRec, sCash, sData = fData[key], defTab.Name..sDelim..key, ""
    for pnID = 1, vRec.Size do local tItem = vRec[pnID]
      for nCnt = 1, #tItem do
        local vM = makTab:Match(tItem[nCnt],nCnt+1,true,"\"",true); if(not IsHere(vM)) then
          O:Flush(); O:Close(); LogInstance("("..fPref..") Write matching failed <"
            ..tostring(tItem[nCnt]).."> to <"..tostring(nCnt+1).." # "..defTab[nCnt+1][1].."> of "..sTable); return false
        end; sData = sData..sDelim..tostring(vM)
      end; O:Write(sCash..sData.."\n"); sData = ""
    end
  end O:Flush(); O:Close()
  LogInstance("("..fPref..") Success"); return true
end

function TranslateDSV(sTable, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref()); if(not IsString(sTable)) then
    LogInstance("("..fPref..") Table {"..type(sTable).."}<"..tostring(sTable).."> not string"); return false end
  local makTab = libQTable[sTable]; if(not IsHere(makTab)) then
    LogInstance("("..fPref..") Missing table builder for <"..sTable..">"); return false end
  local defTab, sFunc, sMoDB = makTab:GetDefinition(), debugGetinfo(1).name, GetOpVar("MODE_DATABASE")
  local sNdsv, sNins = GetOpVar("DIRPATH_BAS"), GetOpVar("DIRPATH_BAS")
  if(not fileExists(sNins,"DATA")) then fileCreateDir(sNins) end
  sNdsv, sNins = sNdsv..GetOpVar("DIRPATH_DSV"), sNins..GetOpVar("DIRPATH_INS")
  if(not fileExists(sNins,"DATA")) then fileCreateDir(sNins) end
  sNdsv, sNins = sNdsv..fPref..defTab.Name..".txt", sNins..fPref..defTab.Name..".txt"
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local D = fileOpen(sNdsv, "rb", "DATA"); if(not D) then
    LogInstance("("..fPref..") fileOpen("..sNdsv..") failed"); return false end
  local I = fileOpen(sNins, "wb", "DATA"); if(not I) then
    LogInstance("("..fPref..") fileOpen("..sNins..") failed"); return false end
  I:Write("# "..sFunc..":("..fPref.."@"..sTable..") "..GetDate().." [ "..sMoDB.." ]".."\n")
  I:Write("# Data settings:("..makTab:GetColumnList(sDelim)..")\n")
  local pfLib = GetOpVar("NAME_LIBRARY"):gsub(GetOpVar("NAME_INIT"),"")
  local sLine, isEOF, symOff = "", false, GetOpVar("OPSYM_DISABLE")
  local sFr, sBk, sHs = pfLib..".InsertRecord(\""..sTable.."\", {", "})\n", (fPref.."@"..sTable)
  while(not isEOF) do sLine, isEOF = GetStringFile(D)
    if((not IsBlank(sLine)) and (sLine:sub(1,1) ~= symOff)) then
      sLine = sLine:gsub(defTab.Name,""):Trim()
      local tBoo, sCat = sDelim:Explode(sLine), ""
      for nCnt = 1, #tBoo do
        local vMatch = makTab:Match(GetStrip(tBoo[nCnt]),nCnt,true,"\"",true)
        if(not IsHere(vMatch)) then D:Close(); I:Flush(); I:Close()
          LogInstance("("..sHs..") Given matching failed <"
            ..tostring(tBoo[nCnt]).."> to <"..tostring(nCnt).." # "
              ..defTab[nCnt][1].."> of "..sTable); return false end
        sCat = sCat..", "..tostring(vMatch)
      end; I:Write(sFr..sCat:sub(3,-1)..sBk)
    end
  end; D:Close(); I:Flush(); I:Close()
  LogInstance("("..sHs..") Success"); return true
end

--[[
 * This function adds the desired database prefix to the auto-include list
 * It is used by addon creators when they want automatically include pieces
 * sProg  > The program which registered the DSV
 * sPref  > The external data prefix to be added
 * sDelim > The delimiter to be used for processing
 * bSkip  > Skip addition for the DSV prefix if exists
]]--
function RegisterDSV(sProg, sPref, sDelim, bSkip)
  if(CLIENT and gameSinglePlayer()) then
    LogInstance("Single client"); return true end
  local sPref = tostring(sPref or GetInstPref()); if(IsBlank(sPref)) then
    LogInstance("("..sPref..") Prefix empty"); return false end
  local sBas = GetOpVar("DIRPATH_BAS")
  if(not fileExists(sBas,"DATA")) then fileCreateDir(sBas) end
  local lbNam = GetOpVar("NAME_LIBRARY")
  local fName = (sBas..lbNam.."_dsv.txt")
  local sMiss, sDelim = GetOpVar("MISS_NOAV"), tostring(sDelim or "\t"):sub(1,1)
  if(bSkip) then
    local symOff = GetOpVar("OPSYM_DISABLE")
    local fPool, isEOF, isAct = {}, false, true
    local F, sLine = fileOpen(fName, "rb" ,"DATA"), ""
    if(not F) then LogInstance("("..sPref..") fileOpen("..fName..") read failed"); return false end
    while(not isEOF) do sLine, isEOF = GetStringFile(F)
      if(not IsBlank(sLine)) then
        if(sLine:sub(1,1) == symOff) then
          isAct, sLine = false, sLine:sub(2,-1) else isAct = true end
        local tab = sDelim:Explode(sLine)
        local prf, src = tab[1]:Trim(), tab[2]:Trim()
        local inf = fPool[prf]
        if(not inf) then
          fPool[prf] = {Cnt = 1}; inf = fPool[prf]
          inf[inf.Cnt] = {src, isAct}
        else
          inf.Cnt = inf.Cnt + 1
          inf[inf.Cnt] = {src, isAct}
        end
      end
    end; F:Close()
    if(fPool[sPref]) then local inf = fPool[sPref]
      for ID = 1, inf.Cnt do local tab = inf[ID]
        LogInstance("("..sPref..") "..(tab[2] and "On " or "Off").." <"..tab[1]..">") end
      LogInstance("("..sPref..") Skip <"..sProg..">"); return true
    end
  end
  local F = fileOpen(fName, "ab" ,"DATA"); if(not F) then
    LogInstance("("..sPref..") fileOpen("..fName..") append failed"); return false end
  F:Write(sPref..sDelim..tostring(sProg or sMiss).."\n"); F:Flush(); F:Close()
  LogInstance("("..sPref..") Register"); return true
end

--[[
 * This function cycles all the lines made via @RegisterDSV(sPref, sDelim, sProg)
 * or manually added and loads all the content bound by the prefix line read
 * to the database. It is used by addon creators when they want automatically
 * include and auto-process their custom pieces. The addon creator must
 * check if the PIECES file is created before calling this function
 * sDelim > The delimiter to be used while processing the DSV list
]]--
function ProcessDSV(sDelim)
  local lbNam = GetOpVar("NAME_LIBRARY")
  local fName = GetOpVar("DIRPATH_BAS")..lbNam.."_dsv.txt"
  local F = fileOpen(fName, "rb" ,"DATA")
  if(not F) then LogInstance("fileOpen("..fName..") failed"); return false end
  local sLine, isEOF, symOff = "", false, GetOpVar("OPSYM_DISABLE")
  local sNt, tProc = GetOpVar("TOOLNAME_PU"), {}
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local sDv = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if(not IsBlank(sLine)) then
      if(sLine:sub(1,1) ~= symOff) then
        local tInf = sDelim:Explode(sLine)
        local fPrf = GetStrip(tostring(tInf[1] or ""):Trim())
        local fSrc = GetStrip(tostring(tInf[2] or ""):Trim())
        if(not IsBlank(fPrf)) then -- Is there something
          if(not tProc[fPrf]) then
            tProc[fPrf] = {Cnt = 1, [1] = {Prog = fSrc, File = (sDv..fPrf..sNt)}}
          else -- Prefix is processed already
            local tStore = tProc[fPrf]
            tStore.Cnt = tStore.Cnt + 1 -- Store the count of the repeated prefixes
            tStore[tStore.Cnt] = {Prog = fSrc, File = (sDv..fPrf..sNt)}
          end -- What user puts there is a problem of his own
        end -- If the line is disabled/comment
      else LogInstance("Skipped <"..sLine..">") end
    end
  end; F:Close()
  for prf, tab in pairs(tProc) do
    if(tab.Cnt > 1) then
      LogInstance("Prefix <"..prf.."> clones #"..tostring(tab.Cnt).." @"..fName,true)
      for i = 1, tab.Cnt do
        LogInstance("Prefix <"..prf.."> "..tab[i].Prog,true)
      end
    else local dir = tab[tab.Cnt].File
      if(CLIENT) then
        if(fileExists(dir.."CATEGORY.txt", "DATA")) then
          if(not ImportCategory(3, prf)) then
            LogInstance("("..prf..") Failed CATEGORY") end
        end
      end
      if(fileExists(dir.."PIECES.txt", "DATA")) then
        if(not ImportDSV("PIECES", true, prf)) then
          LogInstance("("..prf..") Failed PIECES") end
      end
      if(fileExists(dir.."ADDITIONS.txt", "DATA")) then
        if(not ImportDSV("ADDITIONS", true, prf)) then
          LogInstance("("..prf..") Failed ADDITIONS") end
      end
      if(fileExists(dir.."PHYSPROPERTIES.txt", "DATA")) then
        if(not ImportDSV("PHYSPROPERTIES", true, prf)) then
          LogInstance("("..prf..") Failed PHYSPROPERTIES") end
      end
    end
  end; LogInstance("Success"); return true
end

----------------------------- SNAPPING ------------------------------

local function GetSurfaceAngle(oPly, vNorm)
  local vF = oPly:GetAimVector()
  local vR = vF:Cross(vNorm); vF:Set(vNorm:Cross(vR))
  return vF:AngleEx(vNorm)
end

--[[
 * This function calculates the cross product normal angle of
 * a player by a given trace. If the trace is missing it takes player trace
 * It has options for snap to surface and yaw snap
 * oPly    > The player we need the normal angle from
 * stTrace > A trace structure if nil, it takes oPly's
 * bSnap   > Snap to the trace surface flag
 * nYSnp   > Yaw snap amount
]]--
function GetNormalAngle(oPly, stTrace, bSnap, nYSnp)
  local aAng, nYSn = Angle(), (tonumber(nYSnp) or 0); if(not IsPlayer(oPly)) then
    LogInstance("No player <"..tostring(oPly)..">", aAng); return aAng end
  if(bSnap) then local stTr = stTrace -- Snap to the trace surface
    if(not (stTr and stTr.Hit)) then stTr = CacheTracePly(oPly)
      if(not (stTr and stTr.Hit)) then return aAng end
    end; aAng:Set(GetSurfaceAngle(oPly, stTr.HitNormal))
  else aAng[caY] = oPly:GetAimVector():Angle()[caY] end
  if(nYSn and (nYSn > 0) and (nYSn <= GetOpVar("MAX_ROTATION"))) then
    -- Snap player viewing rotation angle for using walls and ceiling
    aAng:SnapTo("pitch", nYSn):SnapTo("yaw", nYSn):SnapTo("roll", nYSn)
  end; return aAng
end

--[[
 * This function is the backbone of the tool snapping and spawning.
 * Anything related to dealing with the track assembly database
 * Calculates SPos, SAng based on the DB inserts and input parameters
 * ucsPos        = Base UCS position
 * ucsAng        = Base UCS angle
 * shdModel      = CLIENT Model
 * ivhdPoID      = CLIENT Point ID
 * ucsPos(X,Y,Z) = Offset position
 * ucsAng(P,Y,R) = Offset angle
]]--
function GetNormalSpawn(oPly,ucsPos,ucsAng,shdModel,ivhdPoID,ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
  local hdRec = CacheQueryPiece(shdModel); if(not IsHere(hdRec)) then
    LogInstance("No record located for <"..shdModel..">"); return nil end
  local ihdPoID = tonumber(ivhdPoID); if(not IsHere(ihdPoID)) then
    LogInstance("Index NAN {"..type(ivhdPoID).."}<"..tostring(ivhdPoID)..">"); return nil end
  local hdPOA = LocatePOA(hdRec,ihdPoID); if(not IsHere(hdPOA)) then
    LogInstance("Holder point ID invalid #"..tostring(ihdPoID)); return nil end
  local stSpawn = CacheSpawnPly(oPly); stSpawn.HRec = hdRec
  if(ucsPos) then SetVector(stSpawn.OPos, ucsPos) end
  if(ucsAng) then SetAngle (stSpawn.OAng, ucsAng) end
  -- Initialize F, R, U Copy the UCS like that to support database POA
  SetAnglePYR (stSpawn.ANxt, (tonumber(ucsAngP) or 0), (tonumber(ucsAngY) or 0), (tonumber(ucsAngR) or 0))
  SetVectorXYZ(stSpawn.PNxt, (tonumber(ucsPosX) or 0), (tonumber(ucsPosY) or 0), (tonumber(ucsPosZ) or 0))

  SetVector(stSpawn.HPnt, hdPOA.P)
  SetVector(stSpawn.HOrg, hdPOA.O)
  SetAngle (stSpawn.HAng, hdPOA.A)

  stData.TMtx:Translate(stSpawn.PNxt)
  stData.TMtx:Rotate(stSpawn.ANxt)

  stSpawn.F:Set(stData.TMtx:GetForward())
  stSpawn.R:Set(stData.TMtx:GetRight())
  stSpawn.U:Set(stData.TMtx:GetUp())

  stData.HMtx:Identity()
  stData.HMtx:Translate(stSpawn.HOrg)
  stData.HMtx:Rotate(stSpawn.HAng)
  stData.HMtx:Rotate(GetOpVar("ANG_REV"))
  stData.HMtx:Invert()

  stData.SMtx:Set(stData.TMtx * stData.HMtx)

  stSpawn.SPos:Set(stData.SMtx:GetTranslation())
  stSpawn.SAng:Set(stData.SMtx:GetAngles())

  -- Store the active point position of holder
  stSpawn.HPnt:Rotate(stSpawn.SAng)
  stSpawn.HPnt:Add(stSpawn.SPos)
  return stSpawn
end

--[[
 * This function is the backbone of the tool on entity snapping
 * Calculates SPos, SAng based on the DB inserts and input parameters
 * trEnt         = Trace.Entity
 * trHitPos      = Trace.HitPos
 * shdModel      = Spawn data will be obtained for this model
 * ivhdPoID      = Active point ID selected via Right click ...
 * nvActRadius   = Minimal radius to get an active point from the client
 * ucsPos(X,Y,Z) = Offset position
 * ucsAng(P,Y,R) = Offset angle
]]--
function GetEntitySpawn(oPly,trEnt,trHitPos,shdModel,ivhdPoID,
                        nvActRadius,enFlatten,enIgnTyp,ucsPosX,
                        ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
  if(not (trEnt and trHitPos and shdModel and ivhdPoID and nvActRadius)) then
    LogInstance("Mismatched input parameters"); return nil end
  if(not trEnt:IsValid()) then
    LogInstance("Trace entity not valid"); return nil end
  if(IsOther(trEnt)) then
    LogInstance("Trace is of other type"); return nil end
  local ihdPoID = tonumber(ivhdPoID); if(not IsHere(ihdPoID)) then
    LogInstance("Holder PointID NAN {"..type(ivhdPoID).."}<"..tostring(ivhdPoID)..">"); return nil end
  local nActRadius = tonumber(nvActRadius); if(not IsHere(nActRadius)) then
    LogInstance("Active radius NAN {"..type(nvActRadius).."}<"..tostring(nvActRadius)..">"); return nil end
  local trRec = CacheQueryPiece(trEnt:GetModel()); if(not IsHere(trRec)) then
    LogInstance("Trace model missing <"..trEnt:GetModel()..">"); return nil end
  if(not IsHere(LocatePOA(trRec,1))) then
    LogInstance("Trace has no points"); return nil end
  local hdRec = CacheQueryPiece(shdModel); if(not IsHere(hdRec)) then
    LogInstance("Holder model missing <"..tostring(shdModel)..">"); return nil end
  local hdOffs = LocatePOA(hdRec,ihdPoID); if(not IsHere(hdOffs)) then
    LogInstance("Holder point invalid #"..tostring(ihdPoID)); return nil end
  -- If there is no Type exit immediately
  if(not (IsHere(trRec.Type) and IsString(trRec.Type))) then
    LogInstance("Trace type invalid <"..tostring(trRec.Type)..">"); return nil end
  if(not (IsHere(hdRec.Type) and IsString(hdRec.Type))) then
    LogInstance("Holder type invalid <"..tostring(hdRec.Type)..">"); return nil end
  -- If the types are different and disabled
  if((not enIgnTyp) and (trRec.Type ~= hdRec.Type)) then
    LogInstance("Types different <"..tostring(trRec.Type)..","..tostring(hdRec.Type)..">"); return nil end
  local stSpawn, trPOA = CacheSpawnPly(oPly) -- We have the next Piece Offset
        stSpawn.TRec, stSpawn.RLen = trRec, nActRadius
        stSpawn.HID , stSpawn.TID  = ihdPoID, 0
        stSpawn.TOrg:Set(trEnt:GetPos())
        stSpawn.TAng:Set(trEnt:GetAngles())
  for ID = 1, trRec.Size do -- Indexing is actually with 70% faster than pairs
    local stPOA = LocatePOA(trRec,ID); if(not IsHere(stPOA)) then
      LogInstance("Trace point count mismatch on #"..tostring(ID)); return nil end
    local vTemp = Vector(); SetVector(vTemp, stPOA.P)
    vTemp:Rotate(stSpawn.TAng); vTemp:Add(stSpawn.TOrg); vTemp:Sub(trHitPos)
    local trAcDis = vTemp:Length()
    if(trAcDis < stSpawn.RLen) then
      trPOA, stSpawn.TID, stSpawn.RLen = stPOA, ID, trAcDis
      stSpawn.TPnt:Set(vTemp); stSpawn.TPnt:Add(trHitPos)
    end
  end
  if(not IsHere(trPOA)) then
    LogInstance("Not hitting active point"); return nil end
  -- Found the active point ID on trEnt. Initialize origins
  SetVector(stSpawn.OPos,trPOA.O) -- Read origin
  SetAngle (stSpawn.OAng,trPOA.A) -- Read angle
  stSpawn.OPos:Rotate(stSpawn.TAng); stSpawn.OPos:Add(stSpawn.TOrg)
  stSpawn.OAng:Set(trEnt:LocalToWorldAngles(stSpawn.OAng))
  -- Do the flatten flag right now Its important !
  if(enFlatten) then stSpawn.OAng[caP] = 0; stSpawn.OAng[caR] = 0 end
  stData.TMtx:Identity()
  stData.TMtx:Translate(stSpawn.OPos)
  stData.TMtx:Rotate(stSpawn.OAng)
  return GetNormalSpawn(oPly,nil,nil,shdModel,ihdPoID,ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
end

--[[
 * This function performs a trace relative to the entity point chosen
 * trEnt  --> Entity chosen for the trace
 * ivPoID --> Point ID selected for its model
 * nLen   --> Length of the trace
]]--
function GetTraceEntityPoint(trEnt, ivPoID, nLen)
  if(not (trEnt and trEnt:IsValid())) then
    LogInstance("Trace entity invalid"); return nil end
  local nLen = (tonumber(nLen) or 0); if(nLen <= 0) then
    LogInstance("Distance skipped"); return nil end
  local trRec = CacheQueryPiece(trEnt:GetModel())
  if(not trRec) then LogInstance("Trace not piece"); return nil end
  local trPOA = LocatePOA(trRec, ivPoID); if(not IsHere(trPOA)) then
    LogInstance("Point <"..tostring(ivPoID).."> invalid"); return nil end
  local trDt, trAng = GetOpVar("TRACE_DATA"), Angle(); SetOpVar("TRACE_FILTER",trEnt)
  SetVector(trDt.start, trPOA.O); trDt.start:Rotate(trEnt:GetAngles()); trDt.start:Add(trEnt:GetPos())
  SetAngle (trAng     , trPOA.A); trAng:Set(trEnt:LocalToWorldAngles(trAng))
  trDt.endpos:Set(trAng:Forward()); trDt.endpos:Mul(nLen); trDt.endpos:Add(trDt.start)
  return utilTraceLine(trDt), trDt
end

--[[
 * Selects a point ID on the entity based on the hit vector provided
 * oEnt --> Entity to search the point on
 * vHit --> World space hit vector to find the closest point to
]]--
function GetEntityHitID(oEnt, vHit)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity invalid"); return nil end
  local oRec = CacheQueryPiece(oEnt:GetModel())
  if(not oRec) then LogInstance("Trace not piece <"..oEnt:GetModel()..">"); return nil end
  local ePos, eAng = oEnt:GetPos(), oEnt:GetAngles()
  local vTmp, nID, nMin, oPOA = Vector(), nil, nil, nil
  for ID = 1, oRec.Size do -- Ignore the point disabled flag
    local tPOA, tID = LocatePOA(oRec, ID)
    if(not IsHere(tPOA)) then -- Get intersection rays list for the player
      LogInstance("Point <"..tostring(ID).."> invalid"); return nil end
    SetVector(vTmp, tPOA.P) -- Translate point to a world-space
    vTmp:Rotate(eAng); vTmp:Add(ePos); vTmp:Sub(vHit)
    if(nID and nMin) then
      if(nMin >= vTmp:Length()) then nID, nMin, oPOA = tID, vTmp:Length(), tPOA end
    else -- The shortest distance if the first one checked until others are looped
      nID, nMin, oPOA = tID, vTmp:Length(), tPOA end
  end; return nID, nMin, oPOA, oRec
end

--[[
 * This function calculates 3x3 determinant of the arguments below
 * Takes three row vectors as arguments:
 *   vR1 = {a b c}
 *   vR2 = {d e f}
 *   vR3 = {g h i}
 * Returns a number: The 3x3 determinant value
]]--
local function DeterminantVector(vR1, vR2, vR3)
  local a, b, c = vR1.x, vR1.y, vR1.z
  local d, e, f = vR2.x, vR2.y, vR2.z
  local g, h, i = vR3.x, vR3.y, vR3.z
  return ((a*e*i)+(b*f*g)+(d*h*c)-(g*e*c)-(h*f*a)-(d*b*i))
end

--[[
 * This function traces both lines and if they are not parallel
 * calculates their point of intersection. Every ray is
 * determined by an origin /vO/ and direction /vD/
 * On success returns the length and point of the closest
 * intersect distance to the orthogonal connecting line.
 * The true center is calculated by using the last two return values
 * Takes:
 *   vO1 --> Position origin of the first ray
 *   vD1 --> Direction of the first ray
 *   vO2 --> Position origin of the second ray
 *   vD2 --> Direction of the second ray
 * Returns:
 *   f1 --> Intersection fraction of the first ray
 *   f2 --> Intersection fraction of the second ray
]]--
local function IntersectRay(vO1, vD1, vO2, vD2)
  local d1 = vD1:GetNormalized(); if(d1:Length() == 0) then
    LogInstance("First ray undefined"); return nil end
  local d2 = vD2:GetNormalized(); if(d2:Length() == 0) then
    LogInstance("Second ray undefined"); return nil end
  local dx, oo = d1:Cross(d2), (vO2 - vO1)
  local dn = (dx:Length())^2; if(dn < GetOpVar("EPSILON_ZERO")) then
    LogInstance("Rays parallel"); return nil end
  local f1 = DeterminantVector(oo, d2, dx) / dn
  local f2 = DeterminantVector(oo, d1, dx) / dn
  local x1, x2 = (vO1 + f1 * d1), (vO2 + f2 * d2)
  local xx = (x2 - x1); xx:Mul(0.5); xx:Add(x1)
  return f1, f2, x1, x2, xx
end

local function IntersectRayParallel(vO1, vD1, vO2, vD2)
  local d1 = vD1:GetNormalized(); if(d1:Length() == 0) then
    LogInstance("First ray undefined"); return nil end
  local d2 = vD2:GetNormalized(); if(d2:Length() == 0) then
    LogInstance("Second ray undefined"); return nil end
  local len = (vO2 - vO1):Length()
  local f1, f2 = (len / 2), (len / 2)
  local x1, x2 = (vO1 + f1 * d1), (vO2 + f2 * d2)
  local xx = (x2 - x1); xx:Mul(0.5); xx:Add(x1)
  return f1, f2, x1, x2, xx
end

local function IntersectRayUpdate(stRay)
  if(not IsHere(stRay)) then
    LogInstance("Ray invalid"); return nil end
  local ryEnt = stRay.Ent
  if(ryEnt and ryEnt:IsValid()) then
    local ePos, eAng = ryEnt:GetPos(), ryEnt:GetAngles()
    stRay.Orw:Set(stRay.Org); stRay.Orw:Rotate(eAng); stRay.Orw:Add(ePos)
    stRay.Diw:Set(ryEnt:LocalToWorldAngles(stRay.Dir))
  end; return stRay
end

--[[
 * This function creates/updates an active ray for a player.
 * Every player has own place in the cache.
 * The dedicated table can contain rays with different purpose
 * oPly  --> Player who wants to register a ray
 * oEnt  --> The trace entity to register the raw with
 * trHit --> The world position to search for point ID
 * sKey  --> String identifier. Used to distinguish rays form one another
]]--
function IntersectRayCreate(oPly, oEnt, vHit, sKey)
  if(not IsString(sKey)) then
    LogInstance("Key invalid <"..tostring(sKey)..">"); return nil end
  if(not IsPlayer(oPly)) then
    LogInstance("Player invalid <"..tostring(oPly)..">"); return nil end
  local trID, trMin, trPOA, trRec = GetEntityHitID(oEnt, vHit); if(not trID) then
    LogInstance("Entity no hit <"..tostring(oEnt).."/"..tostring(vHit)..">"); return nil end
  local tRay = GetOpVar("RAY_INTERSECT"); if(not tRay[oPly]) then tRay[oPly] = {} end; tRay = tRay[oPly]
  local stRay = tRay[sKey] -- Index the ray type. Relate or origin
  if(not stRay) then -- Define a ray via origin and direction
    tRay[sKey] = {Org = Vector(), Dir = Angle(), -- Local direction and origin
                  Orw = Vector(), Diw = Angle(), -- World direction and origin
                   ID = trID    , Ent = oEnt   , -- Point ID and entity relation
                  Key = sKey    , Ply = oPly   , -- Key and player to be stored
                  POA = trPOA   , Rec = trRec  , Min = trMin}; stRay = tRay[sKey]
  else -- Update internal settings
    stRay.Key = sKey
    stRay.Ply, stRay.Ent, stRay.ID  = oPly , oEnt , trID
    stRay.POA, stRay.Rec, stRay.Min = trPOA, trRec, trMin
  end; SetAngle(stRay.Dir, trPOA.A); SetVector(stRay.Org, trPOA.O)
  return IntersectRayUpdate(stRay)
end

function IntersectRayRead(oPly, sKey)
  if(not IsPlayer(oPly)) then
    LogInstance("Player invalid <"..tostring(oPly)..">"); return nil end
  if(not IsString(sKey)) then
    LogInstance("Key invalid <"..tostring(sKey)..">"); return nil end
  local tRay = GetOpVar("RAY_INTERSECT")[oPly]; if(not tRay) then
    LogInstance("No ray <"..tostring(oPly)..">"); return nil end
  local stRay = tRay[sKey]; if(not stRay) then
    LogInstance("No Key <"..sKey..">"); return nil end
  return IntersectRayUpdate(stRay) -- Obtain personal ray from the cache
end

function IntersectRayClear(oPly, sKey)
  if(not IsPlayer(oPly)) then
    LogInstance("Player invalid <"..tostring(oPly)..">"); return false end
  local tRay = GetOpVar("RAY_INTERSECT")[oPly]
  if(not tRay) then LogInstance("Clean"); return true end
  if(sKey) then
    if(not IsString(sKey)) then
      LogInstance("Key invalid <"..type(sKey).."/"..tostring(sKey)..">"); return false end
    tRay[sKey] = nil; collectgarbage()
  else GetOpVar("RAY_INTERSECT")[oPly] = nil; collectgarbage() end
  LogInstance("Clear {"..tostring(sKey).."}<"..tostring(oPly)..">"); return true
end

--[[
 * This function intersects two already cashed rays
 * Used for generating
 * sKey1 --> First ray identifier
 * sKey2 --> Second ray identifier
]]--
function IntersectRayHash(oPly, sKey1, sKey2)
  local stRay1 = IntersectRayRead(oPly, sKey1)
  if(not stRay1) then LogInstance("No read <"..tostring(sKey1)..">"); return nil end
  local stRay2 = IntersectRayRead(oPly, sKey2)
  if(not stRay2) then LogInstance("No read <"..tostring(sKey2)..">"); return nil end
  local f1, f2, x1, x2, xx = IntersectRay(stRay1.Orw, stRay1.Diw:Forward(), stRay2.Orw, stRay2.Diw:Forward())
  if(not xx) then -- Attempts taking the mean vector when the rays are parallel for straight tracks
    f1, f2, x1, x2, xx = IntersectRayParallel(stRay1.Orw, stRay1.Diw:Forward(), stRay2.Orw, stRay2.Diw:Forward()) end
  return xx, x1, x2, stRay1, stRay2
end

--[[
 * This function finds the intersection for the model itself
 * as a local vector so it can be placed precisely in the
 * intersection point when creating
 * sModel --> The model to calculate intersection point for
 * nPntID --> Start (chosen) point of the intersection
 * nNxtID --> End (next) point of the intersection
]]--
function IntersectRayModel(sModel, nPntID, nNxtID)
  local mRec = CacheQueryPiece(sModel); if(not mRec) then
    LogInstance("Not piece <"..tostring(sModel)..">"); return nil end
  local stPOA1 = LocatePOA(mRec, nPntID); if(not stPOA1) then
    LogInstance("No start ID <"..tostring(nPntID)..">"); return nil end
  local stPOA2 = LocatePOA(mRec, nNxtID); if(not stPOA2) then
    LogInstance("No end ID <"..tostring(nNxtID)..">"); return nil end
  local aD1, aD2 = Angle(), Angle(); SetAngle(aD1, stPOA1.A); SetAngle(aD2, stPOA2.A)
  local vO1, vD1 = Vector(), Vector(); SetVector(vO1, stPOA1.O); vD1:Set(-aD1:Forward())
  local vO2, vD2 = Vector(), Vector(); SetVector(vO2, stPOA2.O); vD2:Set(-aD2:Forward())
  local f1, f2, x1, x2, xx = IntersectRay(vO1,vD1,vO2,vD2)
  if(not xx) then -- Attempts taking the mean vector when the rays are parallel for straight tracks
    f1, f2, x1, x2, xx = IntersectRayParallel(vO1,vD1,vO2,vD2) end
  return xx, vO1, vO2
end

function AttachAdditions(ePiece)
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Piece invalid"); return false end
  local eAng, ePos, eMod = ePiece:GetAngles(), ePiece:GetPos(), ePiece:GetModel()
  local stAddit = CacheQueryAdditions(eMod); if(not IsHere(stAddit)) then
    LogInstance("Model <"..eMod.."> has no additions"); return true end
  LogInstance("Called for model <"..eMod..">")
  local makTab = libQTable["ADDITIONS"]; if(not IsHere(makTab)) then
    LogInstance("Missing table definition"); return nil end
  local defTab, iCnt = makTab:GetDefinition(), 1
  while(stAddit[iCnt]) do local arRec = stAddit[iCnt]; LogInstance("")
    local eAddit = entsCreate(arRec[defTab[3][1]])
    if(eAddit and eAddit:IsValid()) then
      LogInstance("Class <"..arRec[defTab[3][1]]..">")
      local adMod = tostring(arRec[defTab[2][1]])
      if(not fileExists(adMod, "GAME")) then
        LogInstance("Missing attachment file "..adMod); return false end
      if(not utilIsValidModel(adMod)) then
        LogInstance("Invalid attachment model "..adMod); return false end
      eAddit:SetModel(adMod) LogInstance("SetModel("..adMod..")")
      local ofPos = arRec[defTab[5][1]]; if(not IsString(ofPos)) then
        LogInstance("Position {"..type(ofPos).."}<"..tostring(ofPos).."> not string"); return false end
      if(ofPos and not IsBlank(ofPos) and ofPos ~= "NULL") then
        local vpAdd, arConv = Vector(), DecodePOA(ofPos)
        arConv[1] = arConv[1] * arConv[4]; vpAdd:Add(arConv[1] * eAng:Forward())
        arConv[2] = arConv[2] * arConv[5]; vpAdd:Add(arConv[2] * eAng:Right())
        arConv[3] = arConv[3] * arConv[6]; vpAdd:Add(arConv[3] * eAng:Up())
        vpAdd:Add(ePos); eAddit:SetPos(vpAdd); LogInstance("SetPos(DB)")
      else eAddit:SetPos(ePos); LogInstance("SetPos(ePos)") end
      local ofAng = arRec[defTab[6][1]]; if(not IsString(ofAng)) then
        LogInstance("Angle {"..type(ofAng).."}<"..tostring(ofAng).."> not string"); return false end
      if(ofAng and not IsBlank(ofAng) and ofAng ~= "NULL") then
        local apAdd, arConv = Angle(), DecodePOA(ofAng)
        apAdd[caP] = arConv[1] * arConv[4] + eAng[caP]
        apAdd[caY] = arConv[2] * arConv[5] + eAng[caY]
        apAdd[caR] = arConv[3] * arConv[6] + eAng[caR]
        eAddit:SetAngles(apAdd); LogInstance("SetAngles(DB)")
      else eAddit:SetAngles(eAng); LogInstance("SetAngles(eAng)") end
      local mvTyp = (tonumber(arRec[defTab[7][1]]) or -1)
      if(mvTyp >= 0) then eAddit:SetMoveType(mvTyp)
        LogInstance("SetMoveType("..mvTyp..")") end
      local phInt = (tonumber(arRec[defTab[8][1]]) or -1)
      if(phInt >= 0) then eAddit:PhysicsInit(phInt)
        LogInstance("PhysicsInit("..phInt..")") end
      local drShd = (tonumber(arRec[defTab[9][1]]) or 0)
      if(drShd ~= 0) then drShd = (drShd > 0)
        eAddit:DrawShadow(drShd); LogInstance("DrawShadow("..tostring(drShd)..")") end
      eAddit:SetParent(ePiece); LogInstance("SetParent(ePiece)")
      eAddit:Spawn(); LogInstance("Spawn()")
      phAddit = eAddit:GetPhysicsObject()
      if(phAddit and phAddit:IsValid()) then
        local enMot = (tonumber(arRec[defTab[10][1]]) or 0)
        if(enMot ~= 0) then enMot = (enMot > 0); phAddit:EnableMotion(enMot)
          LogInstance("EnableMotion("..tostring(enMot)..")") end
        local nbSlp = (tonumber(arRec[defTab[11][1]]) or 0)
        if(nbSlp > 0) then phAddit:Sleep(); LogInstance("Sleep()") end
      end
      eAddit:Activate(); LogInstance("Activate()")
      ePiece:DeleteOnRemove(eAddit); LogInstance("DeleteOnRemove(eAddit)")
      local nbSld = (tonumber(arRec[defTab[12][1]]) or -1)
      if(nbSld >= 0) then eAddit:SetSolid(nbSld)
        LogInstance("SetSolid("..tostring(nbSld)..")") end
    else local sM, sT, sN = defTab[1][1], defTab[2][1], defTab[3][1]
      local sMsg = "\n "..sM.." "..stAddit[iCnt][sM]..
                   "\n "..sT.." "..stAddit[iCnt][sT]..
                   "\n "..sN.." "..stAddit[iCnt][sN]
      LogInstance(""..sMsg); return false
    end; iCnt = iCnt + 1
  end; LogInstance("Success"); return true
end

local function GetEntityOrTrace(oEnt)
  if(oEnt and oEnt:IsValid()) then return oEnt end
  local oPly = LocalPlayer(); if(not IsPlayer(oPly)) then
    LogInstance("Player <"..type(oPly)"> missing"); return nil end
  local stTrace = CacheTracePly(oPly); if(not IsHere(stTrace)) then
    LogInstance("Trace missing"); return nil end
  if(not stTrace.Hit) then -- Boolean
    LogInstance("Trace not hit"); return nil end
  if(stTrace.HitWorld) then -- Boolean
    LogInstance("Trace hit world"); return nil end
  local trEnt = stTrace.Entity; if(not (trEnt and trEnt:IsValid())) then
    LogInstance("Trace entity invalid"); return nil end
  LogInstance("Success "..tostring(trEnt)); return trEnt
end

function GetPropSkin(oEnt)
  local skEnt = GetEntityOrTrace(oEnt); if(not IsHere(skEnt)) then
    LogInstance("Failed to gather entity"); return "" end
  if(IsOther(skEnt)) then
    LogInstance("Entity other type"); return "" end
  local Skin = tonumber(skEnt:GetSkin()); if(not IsHere(Skin)) then
    LogInstance("Skin number mismatch"); return "" end
  LogInstance("Success "..tostring(skEn)); return tostring(Skin)
end

function GetPropBodyGroup(oEnt)
  local bgEnt = GetEntityOrTrace(oEnt); if(not IsHere(bgEnt)) then
    LogInstance("Failed to gather entity"); return "" end
  if(IsOther(bgEnt)) then
    LogInstance("Entity other type"); return "" end
  local BGs = bgEnt:GetBodyGroups(); if(not (BGs and BGs[1])) then
    LogInstance("Bodygroup table empty"); return "" end
  local sRez, iCnt, symSep = "", 1, GetOpVar("OPSYM_SEPARATOR")
  while(BGs[iCnt]) do
    sRez = sRez..symSep..tostring(bgEnt:GetBodygroup(BGs[iCnt].id) or 0)
    iCnt = iCnt + 1
  end; sRez = sRez:sub(2,-1)
  Print(BGs,"GetPropBodyGrp: BGs")
  LogInstance("Success <"..sRez..">"); return sRez
end

function AttachBodyGroups(ePiece,sBgrpIDs)
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Base entity invalid"); return false end
  local sBgrpIDs = tostring(sBgrpIDs or "")
  LogInstance("<"..sBgrpIDs..">")
  local iCnt, BGs = 1, ePiece:GetBodyGroups()
  local IDs = GetOpVar("OPSYM_SEPARATOR"):Explode(sBgrpIDs)
  while(BGs[iCnt] and IDs[iCnt]) do
    local itrBG = BGs[iCnt]
    local maxID = (ePiece:GetBodygroupCount(itrBG.id) - 1)
    local itrID = mathClamp(mathFloor(tonumber(IDs[iCnt]) or 0),0,maxID)
    LogInstance("SetBodygroup("..tostring(itrBG.id)..","..tostring(itrID)..") ["..tostring(maxID).."]")
    ePiece:SetBodygroup(itrBG.id,itrID)
    iCnt = iCnt + 1
  end; LogInstance("Success"); return true
end

function SetPosBound(ePiece,vPos,oPly,sMode)
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Entity invalid"); return false end
  if(not IsHere(vPos)) then
    LogInstance("Position missing"); return false end
  if(not IsPlayer(oPly)) then
    LogInstance("Player <"..tostring(oPly)"> invalid"); return false end
  local sMode = tostring(sMode or "LOG") -- Error mode is "LOG" by default
  if(sMode == "OFF") then ePiece:SetPos(vPos)
    LogInstance("SetPosBound("..sMode..") Skip"); return true end
  if(utilIsInWorld(vPos)) then ePiece:SetPos(vPos) else ePiece:Remove()
    if(sMode == "HINT" or sMode == "GENERIC" or sMode == "ERROR") then
      PrintNotifyPly(oPly,"Position out of map bounds!",sMode) end
    LogInstance("("..sMode..") Position ["..tostring(vPos).."] out of map bounds"); return false
  end; LogInstance("("..sMode..") Success"); return true
end

function MakePiece(pPly,sModel,vPos,aAng,nMass,sBgSkIDs,clColor,sMode)
  if(CLIENT) then LogInstance("Working on client"); return nil end
  if(not IsPlayer(pPly)) then -- If not player we cannot register limit
    LogInstance("Player missing <"..tostring(pPly)..">"); return nil end
  local sLimit = GetOpVar("CVAR_LIMITNAME") -- Get limit name
  if(not pPly:CheckLimit(sLimit)) then -- Check internal limit
    LogInstance("Track limit reached"); return nil end
  if(not pPly:CheckLimit("props")) then -- Check the props limit
    LogInstance("Prop limit reached"); return nil end
  local stPiece = CacheQueryPiece(sModel) if(not IsHere(stPiece)) then
    LogInstance("Record missing for <"..sModel..">"); return nil end
  local ePiece = entsCreate(GetPieceUnit(stPiece)) -- Create the piece unit
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Piece invalid <"..tostring(ePiece)..">"); return nil end
  ePiece:SetCollisionGroup(COLLISION_GROUP_NONE)
  ePiece:SetSolid(SOLID_VPHYSICS)
  ePiece:SetMoveType(MOVETYPE_VPHYSICS)
  ePiece:SetNotSolid(false)
  ePiece:SetModel(sModel)
  if(not SetPosBound(ePiece,vPos or GetOpVar("VEC_ZERO"),pPly,sMode)) then
    LogInstance(pPly:Nick().." spawned <"..sModel.."> outside"); return nil end
  ePiece:SetAngles(aAng or GetOpVar("ANG_ZERO"))
  ePiece:Spawn()
  ePiece:Activate()
  ePiece:SetRenderMode(RENDERMODE_TRANSALPHA)
  ePiece:SetColor(clColor or GetColor(255,255,255,255))
  ePiece:DrawShadow(false)
  ePiece:PhysWake()
  local phPiece = ePiece:GetPhysicsObject()
  if(not (phPiece and phPiece:IsValid())) then ePiece:Remove()
    LogInstance("Entity phys object invalid"); return nil end
  phPiece:EnableMotion(false); ePiece.owner = pPly -- Some SPPs actually use this value
  local Mass = (tonumber(nMass) or 1); phPiece:SetMass((Mass >= 1) and Mass or 1)
  local BgSk = GetOpVar("OPSYM_DIRECTORY"):Explode(sBgSkIDs or "")
  ePiece:SetSkin(mathClamp(tonumber(BgSk[2]) or 0,0,ePiece:SkinCount()-1))
  if(not AttachBodyGroups(ePiece,BgSk[1] or "")) then ePiece:Remove()
    LogInstance("Failed attaching bodygroups"); return nil end
  if(not AttachAdditions(ePiece)) then ePiece:Remove()
    LogInstance("Failed attaching additions"); return nil end
  pPly:AddCount(sLimit , ePiece); pPly:AddCleanup(sLimit , ePiece) -- This sets the ownership
  pPly:AddCount("props", ePiece); pPly:AddCleanup("props", ePiece) -- To be deleted with clearing props
  LogInstance(""..tostring(ePiece)..sModel); return ePiece
end

function ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
  if(CLIENT) then LogInstance("Working on client"); return true end
  local bPi, bFr = (tobool(bPi) or false), (tobool(bFr) or false)
  local bGr, sPh = (tobool(bGr) or false),  tostring(sPh or "")
  LogInstance("{"..tostring(bPi)..","..tostring(bFr)..","..tostring(bGr)..","..sPh.."}")
  if(not (ePiece and ePiece:IsValid())) then   -- Cannot manipulate invalid entities
    LogInstance("Piece entity invalid <"..tostring(ePiece)..">"); return false end
  local pyPiece = ePiece:GetPhysicsObject()    -- Get the physics object
  if(not (pyPiece and pyPiece:IsValid())) then -- Cannot manipulate invalid physics
    LogInstance("Piece physical object invalid <"..tostring(ePiece)..">"); return false end
  local arSettings = {bPi,bFr,bGr,sPh}  -- Initialize dupe settings using this array
  ePiece.PhysgunDisabled = bPi          -- If enabled stop the player from grabbing the track piece
  ePiece:SetUnFreezable(bPi)            -- If enabled stop the player from hitting reload to mess it all up
  ePiece:SetMoveType(MOVETYPE_VPHYSICS) -- Moves and behaves like a normal prop
  -- Delay the freeze by a tiny amount because on physgun snap the piece
  -- is unfrozen automatically after physgun drop hook call
  timerSimple(GetOpVar("DELAY_FREEZE"), function() -- If frozen motion is disabled
    LogInstance("Freeze");  -- Make sure that the physics are valid
    if(pyPiece and pyPiece:IsValid()) then pyPiece:EnableMotion(not bFr) end end )
  constructSetPhysProp(nil,ePiece,0,pyPiece,{GravityToggle = bGr, Material = sPh})
  duplicatorStoreEntityModifier(ePiece,GetOpVar("TOOLNAME_PL").."dupe_phys_set",arSettings)
  LogInstance("Success"); return true
end

function ApplyPhysicalAnchor(ePiece,eBase,bWe,bNc,nFm)
  if(CLIENT) then LogInstance("Working on client"); return true end
  local bWe, bNc, nFm = (tobool(bWe) or false), (tobool(bNc) or false), (tonumber(nFm) or 0)
  LogInstance("{"..tostring(bWe)..","..tostring(bNc)..","..tostring(nFm).."}")
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Piece <"..tostring(ePiece).."> not valid"); return false end
  if(not (eBase and eBase:IsValid())) then
    LogInstance("Base <"..tostring(eBase).."> constraint ignored"); return true end
  if(bNc) then -- NoCollide should be made separately
    local cnN = constraintNoCollide(ePiece, eBase, 0, 0)
    if(cnN and cnN:IsValid()) then
      ePiece:DeleteOnRemove(cnN); eBase:DeleteOnRemove(cnN)
    else LogInstance("NoCollide ignored") end
  end
  if(bWe) then -- Weld using force limit given here V
    local cnW = constraintWeld(ePiece, eBase, 0, 0, nFm, false, false)
    if(cnW and cnW:IsValid()) then
      ePiece:DeleteOnRemove(cnW); eBase:DeleteOnRemove(cnW)
    else LogInstance("Weld ignored "..tostring(cnW)) end
  end; LogInstance("Success"); return true
end

function MakeAsmVar(sName, vVal, vBord, nFlag, vInfo)
  if(not IsString(sName)) then
    LogInstance("CVar name {"..type(sName).."}<"..tostring(sName).."> not string"); return nil end
  local sLow = ((sName:sub(1,1) == "*") and sName:sub(2,-1):lower() or (GetOpVar("TOOLNAME_PL")..sName):lower())
  local cVal, sInf, tBrd = (tonumber(vVal) or tostring(vVal)), tostring(vInfo or ""), GetOpVar("TABLE_BORDERS")
  if(not IsHere(tBrd.CVAR)) then tBrd.CVAR = {} end; tBrd = tBrd.CVAR
  if(IsHere(tBrd[sLow])) then LogInstance("Exists <"..var..">"); return nil end
  tBrd[sLow] = (vBord or {}); tBrd = tBrd[sLow]; tBrd[3] = cVal; nFlg = mathFloor(tonumber(nFlag) or 0)
  local mIn, mAx, dEf = tostring(tBrd[1]), tostring(tBrd[2]), tostring(tBrd[3])
  LogInstance("Border ("..sLow..")<"..mIn.."/"..mAx..">["..dEf.."]")
  return CreateConVar(sLow, cVal, nFlg, sInf)
end

function GetAsmVar(sName, sMode)
  if(not IsString(sName)) then
    LogInstance("CVar name {"..type(sName).."}<"..tostring(sName).."> not string"); return nil end
  if(not IsString(sMode)) then
    LogInstance("CVar mode {"..type(sMode).."}<"..tostring(sMode).."> not string"); return nil end
  local sLow = ((sName:sub(1,1) == "*") and sName:sub(2,-1):lower() or (GetOpVar("TOOLNAME_PL")..sName):lower())
  local CVar = GetConVar(sLow); if(not IsHere(CVar)) then
    LogInstance("("..sLow..", "..sMode..") Missing CVar object"); return nil end
  if    (sMode == "INT") then return (tonumber(BorderValue(CVar:GetInt()  , "CVAR", sLow)) or 0)
  elseif(sMode == "FLT") then return (tonumber(BorderValue(CVar:GetFloat(), "CVAR", sLow)) or 0)
  elseif(sMode == "STR") then return  tostring(CVar:GetString() or "")
  elseif(sMode == "BUL") then return (CVar:GetBool() or false)
  elseif(sMode == "DEF") then return  CVar:GetDefault()
  elseif(sMode == "INF") then return  CVar:GetHelpText()
  elseif(sMode == "NAM") then return  CVar:GetName()
  elseif(sMode == "OBJ") then return  CVar
  end; LogInstance("("..sName..", "..sMode..") Missed mode"); return nil
end

function SetAsmVarCallback(sName, sType, sHash, fHand)
  if(not (sName and IsString(sName))) then
    LogInstance("Key {"..type(sName).."}<"..tostring(sName).."> not string"); return nil end
  if(not (sType and IsString(sType))) then
    LogInstance("Key {"..type(sType).."}<"..tostring(sType).."> not string"); return nil end
  if(IsString(sHash)) then local sLong = GetAsmVar(sName, "NAM")
    cvarsRemoveChangeCallback(sLong, sLong.."_call")
    cvarsAddChangeCallback(sLong, function(sVar, vOld, vNew)
      local aVal, bS = GetAsmVar(sName, sType), true
      if(type(fHand) == "function") then bS, aVal = pcall(fHand, aVal)
        if(not bS) then LogInstance(""..tostring(aVal)); return nil end
        LogInstance("("..sName..") Converted")
      end; LogInstance("("..sName..") <"..tostring(aVal)..">")
      SetOpVar(sHash, aVal) -- Make sure we write down the processed value in the hashes
    end, sLong.."_call")
  end
end

function GetPhrase(sKey)
  local tPool = GetOpVar("LOCALIFY_TABLE")
  local sPhrs = tPool[tostring(sKey)]; if(not sPhrs) then
    LogInstance("Miss <"..tostring(sKey)..">") end
  return (sPhrs and tostring(sPhrs) or GetOpVar("MISS_NOAV"))
end

function InitLocalify(sCode)
  if(not CLIENT) then return end; local tPool = GetOpVar("LOCALIFY_TABLE") -- ( Column "ISO 639-1" )
  local sTool, sLmit = GetOpVar("TOOLNAME_NL"), GetOpVar("CVAR_LIMITNAME")
  ------ CONFIGURE TRANSLATIONS ------ https://en.wikipedia.org/wiki/ISO_639-1
  -- con >> control, def >> deafault, hd >> header, lb >> label
  tPool["tool."..sTool..".1"             ] = "Assembles a prop-segmented track"
  tPool["tool."..sTool..".left"          ] = "Spawn/snap a piece. Hold SHIFT to stack"
  tPool["tool."..sTool..".right"         ] = "Switch assembly points. Hold SHIFT for versa (Quick: ALT + SCROLL)"
  tPool["tool."..sTool..".right_use"     ] = "Open frequently used pieces menu"
  tPool["tool."..sTool..".reload"        ] = "Remove a piece. Hold SHIFT to select an anchor"
  tPool["tool."..sTool..".desc"          ] = "Assembles a track for vehicles to run on"
  tPool["tool."..sTool..".name"          ] = "Track assembly"
  tPool["tool."..sTool..".phytype"       ] = "Select physical properties type of the ones listed here"
  tPool["tool."..sTool..".phytype_def"   ] = "<Select Surface Material TYPE>"
  tPool["tool."..sTool..".phyname"       ] = "Select physical properties name to use when creating the track as this will affect the surface friction"
  tPool["tool."..sTool..".phyname_def"   ] = "<Select Surface Material NAME>"
  tPool["tool."..sTool..".bgskids"       ] = "Selection code of comma delimited Bodygroup/Skin IDs > ENTER to accept, TAB to auto-fill from trace"
  tPool["tool."..sTool..".bgskids_def"   ] = "Write selection code here. For example 1,0,0,2,1/3"
  tPool["tool."..sTool..".mass"          ] = "How heavy the piece spawned will be"
  tPool["tool."..sTool..".mass_con"      ] = "Piece mass:"
  tPool["tool."..sTool..".model"         ] = "Select the piece model to be used"
  tPool["tool."..sTool..".model_con"     ] = "Select a piece to start/continue your track with by expanding a type and clicking on a node"
  tPool["tool."..sTool..".activrad"      ] = "Minimum distance needed to select an active point"
  tPool["tool."..sTool..".activrad_con"  ] = "Active radius:"
  tPool["tool."..sTool..".stackcnt"      ] = "Maximum number of pieces to create while stacking"
  tPool["tool."..sTool..".stackcnt_con"  ] = "Pieces count:"
  tPool["tool."..sTool..".angsnap"       ] = "Snap the first piece spawned at this much degrees"
  tPool["tool."..sTool..".angsnap_con"   ] = "Angular alignment:"
  tPool["tool."..sTool..".resetvars"     ] = "Click to reset the additional values"
  tPool["tool."..sTool..".resetvars_con" ] = "V Reset variables V"
  tPool["tool."..sTool..".nextpic"       ] = "Additional origin angular pitch offset"
  tPool["tool."..sTool..".nextpic_con"   ] = "Origin pitch:"
  tPool["tool."..sTool..".nextyaw"       ] = "Additional origin angular yaw offset"
  tPool["tool."..sTool..".nextyaw_con"   ] = "Origin yaw:"
  tPool["tool."..sTool..".nextrol"       ] = "Additional origin angular roll offset"
  tPool["tool."..sTool..".nextrol_con"   ] = "Origin roll:"
  tPool["tool."..sTool..".nextx"         ] = "Additional origin linear X offset"
  tPool["tool."..sTool..".nextx_con"     ] = "Offset X:"
  tPool["tool."..sTool..".nexty"         ] = "Additional origin linear Y offset"
  tPool["tool."..sTool..".nexty_con"     ] = "Offset Y:"
  tPool["tool."..sTool..".nextz"         ] = "Additional origin linear Z offset"
  tPool["tool."..sTool..".nextz_con"     ] = "Offset Z:"
  tPool["tool."..sTool..".gravity"       ] = "Controls the gravity on the piece spawned"
  tPool["tool."..sTool..".gravity_con"   ] = "Apply piece gravity"
  tPool["tool."..sTool..".weld"          ] = "Creates welds between pieces or pieces/anchor"
  tPool["tool."..sTool..".weld_con"      ] = "Weld"
  tPool["tool."..sTool..".forcelim"      ] = "Controls how much force is needed to break the weld"
  tPool["tool."..sTool..".forcelim_con"  ] = "Force limit:"
  tPool["tool."..sTool..".ignphysgn"     ] = "Ignores physics gun grab on the piece spawned/snapped/stacked"
  tPool["tool."..sTool..".ignphysgn_con" ] = "Ignore physics gun"
  tPool["tool."..sTool..".nocollide"     ] = "Puts a no-collide between pieces or pieces/anchor"
  tPool["tool."..sTool..".nocollide_con" ] = "NoCollide"
  tPool["tool."..sTool..".freeze"        ] = "Makes the piece spawn in a frozen state"
  tPool["tool."..sTool..".freeze_con"    ] = "Freeze on spawn"
  tPool["tool."..sTool..".igntype"       ] = "Makes the tool ignore the different piece types on snapping/stacking"
  tPool["tool."..sTool..".igntype_con"   ] = "Ignore track type"
  tPool["tool."..sTool..".spnflat"       ] = "The next piece will be spawned/snapped/stacked horizontally"
  tPool["tool."..sTool..".spnflat_con"   ] = "Spawn horizontally"
  tPool["tool."..sTool..".spawncn"       ] = "Spawns the piece at the center, else spawns relative to the active point chosen"
  tPool["tool."..sTool..".spawncn_con"   ] = "Origin from center"
  tPool["tool."..sTool..".surfsnap"      ] = "Snaps the piece to the surface the player is pointing at"
  tPool["tool."..sTool..".surfsnap_con"  ] = "Snap to trace surface"
  tPool["tool."..sTool..".appangfst"     ] = "Apply the angular offsets only on the first piece"
  tPool["tool."..sTool..".appangfst_con" ] = "Apply angular on first"
  tPool["tool."..sTool..".applinfst"     ] = "Apply the linear offsets only on the first piece"
  tPool["tool."..sTool..".applinfst_con" ] = "Apply linear on first"
  tPool["tool."..sTool..".adviser"       ] = "Controls rendering the tool position/angle adviser"
  tPool["tool."..sTool..".adviser_con"   ] = "Draw adviser"
  tPool["tool."..sTool..".pntasist"      ] = "Controls rendering the tool snap point assistant"
  tPool["tool."..sTool..".pntasist_con"  ] = "Draw assistant"
  tPool["tool."..sTool..".ghostcnt"      ] = "Controls rendering the tool ghosted holder pieces count"
  tPool["tool."..sTool..".ghostcnt_con"  ] = "Draw holder ghosts"
  tPool["tool."..sTool..".engunsnap"     ] = "Controls snapping when the piece is dropped by the player physgun"
  tPool["tool."..sTool..".engunsnap_con" ] = "Enable physgun snap"
  tPool["tool."..sTool..".workmode"      ] = "Change this option to select a different working mode"
  tPool["tool."..sTool..".workmode_1"    ] = "General spawn/snap pieces"
  tPool["tool."..sTool..".workmode_2"    ] = "Active point intersection"
  tPool["tool."..sTool..".pn_export"     ] = "Click to export the client database as a file"
  tPool["tool."..sTool..".pn_export_lb"  ] = "Export DB"
  tPool["tool."..sTool..".pn_routine"    ] = "The list of your frequently used track pieces"
  tPool["tool."..sTool..".pn_routine_hd" ] = "Frequent pieces by: "
  tPool["tool."..sTool..".pn_display"    ] = "The model of your track piece is displayed here"
  tPool["tool."..sTool..".pn_pattern"    ] = "Write a pattern here and hit ENTER to preform a search"
  tPool["tool."..sTool..".pn_srchcol"    ] = "Choose which list column you want to preform a search on"
  tPool["tool."..sTool..".pn_srchcol_lb" ] = "<Search by>"
  tPool["tool."..sTool..".pn_srchcol_lb1"] = "Model"
  tPool["tool."..sTool..".pn_srchcol_lb2"] = "Type"
  tPool["tool."..sTool..".pn_srchcol_lb3"] = "Name"
  tPool["tool."..sTool..".pn_srchcol_lb4"] = "End"
  tPool["tool."..sTool..".pn_routine_lb" ] = "Routine items"
  tPool["tool."..sTool..".pn_routine_lb1"] = "Used"
  tPool["tool."..sTool..".pn_routine_lb2"] = "End"
  tPool["tool."..sTool..".pn_routine_lb3"] = "Type"
  tPool["tool."..sTool..".pn_routine_lb4"] = "Name"
  tPool["tool."..sTool..".pn_display_lb" ] = "Piece display"
  tPool["tool."..sTool..".pn_pattern_lb" ] = "Write pattern"
  tPool["Cleanup_"..sLmit                ] = "Assembled track pieces"
  tPool["Cleaned_"..sLmit                ] = "Cleaned up all track pieces"
  tPool["SBoxLimit_"..sLmit              ] = "You've hit the spawned tracks limit!"
  local auCod = GetOpVar("LOCALIFY_AUTO") -- Automatic translation code
  local suCod = tostring(sCode or auCod)  -- English is used when missing
  if(suCod ~= auCod) then -- Other language used that is not auto
    local sPath = ("%s/lang/%s.lua") -- Translation file path
    local fCode = CompileFile(sPath:format(sTool, suCod))
    local bFunc, fFunc = pcall(fCode); if(bFunc) then
      local bCode, tCode = pcall(fFunc, sTool, sLmit); if(bCode) then
        for key, val in pairs(tPool) do tPool[key] = (tCode[key] or tPool[key]) end
      else LogInstance("("..suCod..") Second: "..tCode) end
    else LogInstance("("..suCod..") First: "..fFunc) end
    LogInstance("("..suCod..") "..tostring(tCode))
  end; for key, val in pairs(tPool) do languageAdd(key, val) end
end

function HasGhosts(bDir)
  local tGho = GetOpVar("ARRAY_GHOST")
  return (tGho and tGho.Size and tGho.Size > 0)
end

function FadeGhosts(bNoD)
  if(not HasGhosts()) then return true end
  local tGho = GetOpVar("ARRAY_GHOST")
  local cPal = GetOpVar("CONTAINER_PALETTE")
  for iD = 1, tGho.Size do local eGho = tGho[iD]
    if(eGho and eGho:IsValid()) then
      eGho:SetNoDraw(bNoD); eGho:DrawShadow(false)
      eGho:SetColor(cPal:Select("gh"))
    end
  end; return true
end

function ClearGhosts(bCol)
  if(not HasGhosts()) then return true end
  local tGho = GetOpVar("ARRAY_GHOST")
  for iD = 1, tGho.Size do local eGho = tGho[iD]
    if(eGho and eGho:IsValid()) then
      eGho:SetNoDraw(true); eGho:Remove()
    end; eGho, tGho[iD] = nil, nil
  end; tGho.Size, tGho.Slot = 0, GetOpVar("MISS_NOMD")
  if(bCol) then collectgarbage() end
end

function MakeGhosts(nCnt, sModel)
  local tGho = GetOpVar("ARRAY_GHOST") -- Read ghosts
  if(nCnt == 0 and tGho.Size == 0) then return true end -- Skip processing
  if(nCnt == 0 and tGho.Size ~= 0) then return ClearGhosts() end -- Disabled ghosting
  local cPal = GetOpVar("CONTAINER_PALETTE"); FadeGhosts(true)
  local vZero, aZero, iD = GetOpVar("VEC_ZERO"), GetOpVar("ANG_ZERO"), 1
  while(iD <= nCnt) do local eGho = tGho[iD]
    if(eGho and eGho:IsValid() and eGho:GetModel() ~= sModel) then
      eGho:Remove(); tGho[iD] = nil; eGho = tGho[iD] end
    if(not (eGho and eGho:IsValid())) then
      tGho[iD] = entsCreateClientProp(sModel); eGho = tGho[iD]
      if(not (eGho and eGho:IsValid())) then
        LogInstance("Invalid"); return false end
      eGho:SetModel(sModel)
      eGho:SetPos(vZero)
      eGho:SetAngles(aZero)
      eGho:Spawn()
      eGho:SetSolid(SOLID_VPHYSICS)
      eGho:SetMoveType(MOVETYPE_NONE)
      eGho:SetNotSolid(true)
      eGho:SetNoDraw(true)
      eGho:DrawShadow(false)
      eGho:SetColor(cPal:Select("gh"))
      eGho:SetRenderMode(RENDERMODE_TRANSALPHA)
    end; iD = iD + 1 -- Fade all the ghosts and refresh these that must be drawn
  end -- Remove all others that must not be drawn to save memory
  for iK = iD, tGho.Size do -- Executes only when (nCnt < tGho.Size)
    local eGho = tGho[iD]; if(eGho and eGho:IsValid()) then
      eGho:SetNoDraw(true); eGho:Remove(); eGho = nil end; tGho[iD] = nil
  end; tGho.Size, tGho.Slot = nCnt, sModel; return true
end

function GetTable(k) return (k and libQTable[k] or libQTable) end
