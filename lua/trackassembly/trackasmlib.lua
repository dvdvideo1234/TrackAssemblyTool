--- Because Vec[1] is actually faster than Vec.X

--- Vector Component indexes ---
local cvX -- Vector X component
local cvY -- Vector Y component
local cvZ -- Vector Z component

--- Angle Component indexes ---
local caP -- Angle Pitch component
local caY -- Angle Yaw   component
local caR -- Angle Roll  component

--- Component Status indexes ---
local csA -- Sign of the first component
local csB -- Sign of the second component
local csC -- Sign of the third component
local csD -- Flag for disabling the point

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
local MOVETYPE_VPHYSICS     = MOVETYPE_VPHYSICS
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
local unpack                  = unpack
local include                 = include
local IsValid                 = IsValid
local Material                = Material
local require                 = require
local Time                    = SysTime
local tonumber                = tonumber
local tostring                = tostring
local GetConVar               = GetConVar
local LocalPlayer             = LocalPlayer
local CreateConVar            = CreateConVar
local SetClipboardText        = SetClipboardText
local CompileString           = CompileString
local getmetatable            = getmetatable
local setmetatable            = setmetatable
local collectgarbage          = collectgarbage
local osClock                 = os and os.clock
local osDate                  = os and os.date
local bitBand                 = bit and bit.band
local sqlQuery                = sql and sql.Query
local sqlLastError            = sql and sql.LastError
local sqlTableExists          = sql and sql.TableExists
local gameSinglePlayer        = game and game.SinglePlayer
local utilTraceLine           = util and util.TraceLine
local utilIsInWorld           = util and util.IsInWorld
local utilIsValidModel        = util and util.IsValidModel
local utilGetPlayerTrace      = util and util.GetPlayerTrace
local entsCreate              = ents and ents.Create
local fileOpen                = file and file.Open
local fileExists              = file and file.Exists
local fileAppend              = file and file.Append
local fileDelete              = file and file.Delete
local fileCreateDir           = file and file.CreateDir
local mathPi                  = math and math.pi
local mathAbs                 = math and math.abs
local mathSin                 = math and math.sin
local mathCos                 = math and math.cos
local mathCeil                = math and math.ceil
local mathModf                = math and math.modf
local mathSqrt                = math and math.sqrt
local mathFloor               = math and math.floor
local mathClamp               = math and math.Clamp
local mathRandom              = math and math.random
local undoCreate              = undo and undo.Create
local undoFinish              = undo and undo.Finish
local undoAddEntity           = undo and undo.AddEntity
local undoSetPlayer           = undo and undo.SetPlayer
local undoSetCustomUndoText   = undo and undo.SetCustomUndoText
local timerStop               = timer and timer.Stop
local timerStart              = timer and timer.Start
local timerSimple             = timer and timer.Simple
local timerExists             = timer and timer.Exists
local timerCreate             = timer and timer.Create
local timerDestroy            = timer and timer.Destroy
local tableEmpty              = table and table.Empty
local tableMaxn               = table and table.maxn
local tableGetKeys            = table and table.GetKeys
local tableInsert             = table and table.insert
local debugGetinfo            = debug and debug.getinfo
local renderDrawLine          = render and render.DrawLine
local renderDrawSphere        = render and render.DrawSphere
local renderSetMaterial       = render and render.SetMaterial
local surfaceSetFont          = surface and surface.SetFont
local surfaceDrawLine         = surface and surface.DrawLine
local surfaceDrawText         = surface and surface.DrawText
local surfaceDrawCircle       = surface and surface.DrawCircle
local surfaceSetTexture       = surface and surface.SetTexture
local surfaceSetTextPos       = surface and surface.SetTextPos
local surfaceGetTextSize      = surface and surface.GetTextSize
local surfaceGetTextureID     = surface and surface.GetTextureID
local surfaceSetDrawColor     = surface and surface.SetDrawColor
local surfaceSetTextColor     = surface and surface.SetTextColor
local surfaceDrawTexturedRect = surface and surface.DrawTexturedRect
local languageAdd             = language and language.Add
local constructSetPhysProp    = construct and construct.SetPhysProp
local constraintWeld          = constraint and constraint.Weld
local constraintNoCollide     = constraint and constraint.NoCollide
local cvarsAddChangeCallback   = cvars and cvars.AddChangeCallback
local cvarsRemoveChangeCallback = cvars and cvars.RemoveChangeCallback
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier

---------------- CASHES SPACE --------------------
local libCache  = {} -- Used to cache stuff in a pool
local libAction = {} -- Used to attach external function to the lib
local libOpVars = {} -- Used to Store operational variable values
local libPlayer = {} -- Used to allocate personal space for players

module("trackasmlib")

---------------------------- PRIMITIVES ----------------------------
function Delay(nAdd)
  local nAdd = tonumber(nAdd) or 0
  if(nAdd > 0) then
    local tmEnd = osClock() + nAdd
    while(osClock() < tmEnd) do end
  end
end

function GetInstPref()
  if    (CLIENT) then return "cl_"
  elseif(SERVER) then return "sv_" end
  return "na_"
end

function GetOpVar(sName)
  return libOpVars[sName]
end

function SetOpVar(sName, anyValue)
  libOpVars[sName] = anyValue
end

function IsExistent(anyValue)
  return (anyValue ~= nil)
end

function IsString(anyValue)
  return (getmetatable(anyValue) == GetOpVar("TYPEMT_STRING"))
end

function IsEmptyString(anyValue)
  if(not IsString(anyValue)) then return false end
  return (anyValue == "")
end

function IsBool(anyValue)
  if    (anyValue == true ) then return true
  elseif(anyValue == false) then return true end
  return false
end

function IsNumber(anyValue)
  return ((tonumber(anyValue) and true) or false)
end

function IsPlayer(oPly)
  if(not IsExistent(oPly)) then return false end
  if(not oPly:IsValid  ()) then return false end
  if(not oPly:IsPlayer ()) then return false end
  return true
end

function IsOther(oEnt)
  if(not IsExistent(oEnt)) then return true end
  if(not oEnt:IsValid())   then return true end
  if(oEnt:IsPlayer())      then return true end
  if(oEnt:IsVehicle())     then return true end
  if(oEnt:IsNPC())         then return true end
  if(oEnt:IsRagdoll())     then return true end
  if(oEnt:IsWeapon())      then return true end
  if(oEnt:IsWidget())      then return true end
  return false
end

-- Gets the date according to the specified format
function GetDate()
  return (osDate(GetOpVar("DATE_FORMAT"))
   .." "..osDate(GetOpVar("TIME_FORMAT")))
end

------------------ LOGS ------------------------

local function FormatNumberMax(nNum,nMax)
  local nNum, nMax = tonumber(nNum), tonumber(nMax)
  if(not (nNum and nMax)) then return "" end
  return ("%"..(tostring(mathFloor(nMax))):len().."d"):format(nNum)
end

local function Log(anyStuff)
  local nMaxLogs = GetOpVar("LOG_MAXLOGS")
  if(nMaxLogs <= 0) then return end
  local nCurLogs = GetOpVar("LOG_CURLOGS") + 1
  local logLast, logData = GetOpVar("LOG_LOGLAST"), tostring(anyStuff)
  if(logLast == logData) then SetOpVar("LOG_CURLOGS",nCurLogs); return end
  SetOpVar("LOG_LOGLAST",logData)
  if(GetOpVar("LOG_LOGFILE")) then
    local lbNam = GetOpVar("NAME_LIBRARY")
    local fName = GetOpVar("DIRPATH_BAS")..lbNam.."_log.txt"
    if(nCurLogs > nMaxLogs) then nCurLogs = 0; fileDelete(fName) end
    fileAppend(fName,FormatNumberMax(nCurLogs,nMaxLogs).." ["..GetDate().."] "..logData.."\n")
  else -- The current has values 1..nMaxLogs(0)
    if(nCurLogs > nMaxLogs) then nCurLogs = 0 end
    print(FormatNumberMax(nCurLogs,nMaxLogs).." >> "..logData)
  end; SetOpVar("LOG_CURLOGS",nCurLogs)
end

function PrintInstance(anyStuff)
  local sModeDB = GetOpVar("MODE_DATABASE")
  if(SERVER) then
    print("["..GetDate().."] SERVER > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..tostring(anyStuff))
  elseif(CLIENT) then
    print("["..GetDate().."] CLIENT > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..tostring(anyStuff))
  else
    print("["..GetDate().."] NOINST > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..tostring(anyStuff))
  end
end

function LogInstance(anyStuff)
  local logMax = (tonumber(GetOpVar("LOG_MAXLOGS")) or 0)
  if(logMax and (logMax <= 0)) then return end
  local anyStuff, logStats = tostring(anyStuff), GetOpVar("LOG_SKIP")
  if(logStats and logStats[1]) then
    local iNdex = 1; while(logStats[iNdex]) do
      if(anyStuff:find(tostring(logStats[iNdex]))) then return end; iNdex = iNdex + 1 end
  end; logStats = GetOpVar("LOG_ONLY") -- Should the current log being skipped
  if(logStats and logStats[1]) then
    local iNdex, logMe = 1, false; while(logStats[iNdex]) do
      if(anyStuff:find(tostring(logStats[iNdex]))) then logMe = true end; iNdex = iNdex + 1 end
    if(not logMe) then return end
  end; local sSors = "" -- Only the chosen messages are processed
  if(GetOpVar("LOG_DEBUGEN")) then
    local sInfo = debugGetinfo(3) or {}
    sSors = sSors..(sInfo.linedefined and "["..sInfo.linedefined.."]" or "[n/a]")
    sSors = sSors..(sInfo.name and sInfo.name or "Main")
    sSors = sSors..(sInfo.currentline and ("["..sInfo.currentline.."]") or "[n/a]")
    sSors = sSors..(sInfo.nparams and (" #"..sInfo.nparams) or " #N")
    sSors = sSors..(sInfo.source and (" "..sInfo.source) or " @N")
  end
  local sInst   = ((SERVER and "SERVER" or nil) or (CLIENT and "CLIENT" or nil) or "NOINST")
  local sModeDB = GetOpVar("MODE_DATABASE")
  Log(sInst.." > "..sSors..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..anyStuff)
end

function StatusPrint(anyStatus,sError)
  PrintInstance(sError); return anyStatus
end

function StatusLog(anyStatus,sError)
  LogInstance(sError); return anyStatus
end

function Print(tT,sS,tP)
  local vS, vT, vK, sS = type(sS), type(tT), "", tostring(sS or "Data")
  if(vT ~= "table") then
    return StatusLog(nil,"{"..vT.."}["..tostring(sS or "Data").."] = <"..tostring(tT)..">") end
  if(next(tT) == nil) then
    return StatusLog(nil,sS.." = {}") end; LogInstance(sS.." = {}")
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
  if(not pFile) then return StatusLog("", "GetStringFile: No file"), true end
  local sCh, sLine = "X", "" -- Use a value to start cycle with
  while(sCh) do sCh = pFile:Read(1); if(not sCh) then break end
    if(sCh == "\n") then return sLine:Trim(), false else sLine = sLine..sCh end
  end; return sLine:Trim(), true -- EOF has been reached. Return the last data
end

function SetLogControl(nLines,bFile)
  SetOpVar("LOG_CURLOGS",0)
  SetOpVar("LOG_LOGFILE",tobool(bFile))
  SetOpVar("LOG_MAXLOGS",mathFloor(tonumber(nLines) or 0))
  if(not fileExists(GetOpVar("DIRPATH_BAS"),"DATA") and
     not IsEmptyString(GetOpVar("LOG_LOGFILE"))) then
    fileCreateDir(GetOpVar("DIRPATH_BAS"))
  end
  PrintInstance("SetLogControl("..tostring(GetOpVar("LOG_MAXLOGS"))..","..tostring(GetOpVar("LOG_LOGFILE"))..")")
end

function SettingsLogs(sHash)
  local sKey = tostring(sHash or ""):upper():Trim()
  if(not (sKey == "SKIP" or sKey == "ONLY")) then
    return StatusLog(false,"SettingsLogs("..sKey.."): Invalid hash") end
  local tLogs, lbNam = GetOpVar("LOG_"..sKey), GetOpVar("NAME_LIBRARY")
  if(not tLogs) then return StatusLog(true,"SettingsLogs("..sKey.."): Skip table") end
  local fName = GetOpVar("DIRPATH_BAS")..lbNam.."_sl"..sKey:lower()..".txt"
  local S = fileOpen(fName, "rb", "DATA"); tableEmpty(tLogs)
  if(S) then local sLine, isEOF = "", false
    while(not isEOF) do sLine, isEOF = GetStringFile(S)
      if(not IsEmptyString(sLine)) then tableInsert(tLogs, sLine) end
    end; S:Close(); return StatusLog(true,"SettingsLogs("..sKey.."): Success <"..fName..">")
  else return StatusLog(true,"SettingsLogs("..sKey.."): Missing <"..fName..">") end
end

function GetIndexes(sType)
  if(not IsString(sType)) then
    return StatusLog(nil,"GetIndexes: Type {"..type(sType).."}<"..tostring(sType).."> not string") end
  if    (sType == "V") then return cvX, cvY, cvZ
  elseif(sType == "A") then return caP, caY, caR
  elseif(sType == "S") then return csA, csB, csC, csD
  else return StatusLog(nil,"GetIndexes: Type <"..sType.."> not found") end
end

function SetIndexes(sType,...)
  if(not IsString(sType)) then
    return StatusLog(false,"SetIndexes: Type {"..type(sType).."}<"..tostring(sType).."> not string") end
  if    (sType == "V") then cvX, cvY, cvZ      = ...
  elseif(sType == "A") then caP, caY, caR      = ...
  elseif(sType == "S") then csA, csB, csC, csD = ...
  else return StatusLog(false,"SetIndexes: Type <"..sType.."> not found") end
  return StatusLog(true,"SetIndexes["..sType.."]: Success")
end

function InitBase(sName,sPurpose)
  SetOpVar("TYPEMT_STRING",getmetatable("TYPEMT_STRING"))
  SetOpVar("TYPEMT_SCREEN",{})
  SetOpVar("TYPEMT_CONTAINER",{})
  if(not IsString(sName)) then
    return StatusPrint(false,"InitBase: Name <"..tostring(sName).."> not string") end
  if(not IsString(sPurpose)) then
    return StatusPrint(false,"InitBase: Purpose <"..tostring(sPurpose).."> not string") end
  if(IsEmptyString(sName) or tonumber(sName:sub(1,1))) then
    return StatusPrint(false,"InitBase: Name invalid <"..sName..">") end
  if(IsEmptyString(sPurpose) or tonumber(sPurpose:sub(1,1))) then
    return StatusPrint(false,"InitBase: Purpose invalid <"..sPurpose..">") end
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
  SetOpVar("VEC_FW",Vector(1,0,0))
  SetOpVar("VEC_RG",Vector(0,-1,1))
  SetOpVar("VEC_UP",Vector(0,0,1))
  SetOpVar("OPSYM_DISABLE","#")
  SetOpVar("OPSYM_REVSIGN","@")
  SetOpVar("OPSYM_DIVIDER","_")
  SetOpVar("OPSYM_DIRECTORY","/")
  SetOpVar("OPSYM_SEPARATOR",",")
  SetOpVar("EPSILON_ZERO", 1e-5)
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
  SetOpVar("ARRAY_DECODEPOA",{0,0,0,1,1,1,false})
  if(CLIENT) then
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
      {"HPos"  ,"VEC", "Custom offset"},
      {"HAng"  ,"ANG", "Custom angles"},
      {"--- Traced ---"},
      {"TID"   ,"INT", "Point ID"},
      {"TPnt"  ,"VEC", "Search location"},
      {"TPos"  ,"VEC", "Custom offset"},
      {"TAng"  ,"ANG", "Custom angles"},
      {"--- Offset ---"},
      {"PNxt"  ,"VEC", "Custom user position"},
      {"ANxt"  ,"VEC", "Custom user angles"}})
  end
  SetOpVar("MODELNAM_FILE","%.mdl")
  SetOpVar("MODELNAM_FUNC",function(x) return " "..x:sub(2,2):upper() end)
  SetOpVar("QUERY_STORE", {})
  SetOpVar("TABLE_BORDERS",{})
  SetOpVar("TABLE_FREQUENT_MODELS",{})
  SetOpVar("OOP_DEFAULTKEY","(!@<#_$|%^|&>*)DEFKEY(*>&|^%|$_#<@!)")
  SetOpVar("CVAR_LIMITNAME","asm"..GetOpVar("NAME_INIT").."s")
  SetOpVar("MODE_DATABASE",GetOpVar("MISS_NOAV"))
  SetOpVar("MODE_WORKING", {"SNAP", "CROSS"})
  SetOpVar("HASH_USER_PANEL",GetOpVar("TOOLNAME_PU").."USER_PANEL")
  SetOpVar("HASH_PROPERTY_NAMES","PROPERTY_NAMES")
  SetOpVar("HASH_PROPERTY_TYPES","PROPERTY_TYPES")
  SetOpVar("TRACE_CLASS", {["prop_physics"]=true})
  SetOpVar("TRACE_DATA",{ -- Used for general trace result storage
    start  = Vector(),    -- Start position of the trace
    endpos = Vector(),    -- End position of the trace
    mask   = MASK_SOLID,  -- Mask telling it what to hit
    filter = function(oEnt) -- Only valid props which are not the main entity or world or TRACE_FILTER ( if set )
      if(oEnt and
         oEnt:IsValid() and
         oEnt ~= GetOpVar("TRACE_FILTER") and
         GetOpVar("TRACE_CLASS")[oEnt:GetClass()]) then return true end end })
  SetOpVar("RAY_INTERSECT",{}) -- General structure for handling rail crosses and curves
  SetOpVar("NAV_PIECE",{})
  SetOpVar("NAV_PANEL",{})
  SetOpVar("NAV_ADDITION",{})
  SetOpVar("NAV_PROPERTY_NAMES",{})
  SetOpVar("NAV_PROPERTY_TYPES",{})
  return StatusPrint(true,"InitBase: Success")
end

------------- ANGLE ---------------
function ToAngle(aBase)
  if(not aBase) then return StatusLog(nil,"ToAngle: Base invalid") end
  return Angle((tonumber(aBase[caP]) or 0), (tonumber(aBase[caY]) or 0), (tonumber(aBase[caR]) or 0))
end

function ExpAngle(aBase)
  if(not aBase) then return StatusLog(nil,"ExpAngle: Base invalid") end
  return (tonumber(aBase[caP]) or 0), (tonumber(aBase[caY]) or 0), (tonumber(aBase[caR]) or 0)
end

function AddAngle(aBase, aUnit)
  if(not aBase) then return StatusLog(nil,"AddAngle: Base invalid") end
  if(not aUnit) then return StatusLog(nil,"AddAngle: Unit invalid") end
  aBase[caP] = (tonumber(aBase[caP]) or 0) + (tonumber(aUnit[caP]) or 0)
  aBase[caY] = (tonumber(aBase[caY]) or 0) + (tonumber(aUnit[caY]) or 0)
  aBase[caR] = (tonumber(aBase[caR]) or 0) + (tonumber(aUnit[caR]) or 0)
end

function AddAnglePYR(aBase, nP, nY, nR)
  if(not aBase) then return StatusLog(nil,"AddAnglePYR: Base invalid") end
  aBase[caP] = (tonumber(aBase[caP]) or 0) + (tonumber(nP) or 0)
  aBase[caY] = (tonumber(aBase[caY]) or 0) + (tonumber(nY) or 0)
  aBase[caR] = (tonumber(aBase[caR]) or 0) + (tonumber(nR) or 0)
end

function SubAngle(aBase, aUnit)
  if(not aBase) then return StatusLog(nil,"SubAngle: Base invalid") end
  if(not aUnit) then return StatusLog(nil,"SubAngle: Unit invalid") end
  aBase[caP] = (tonumber(aBase[caP]) or 0) - (tonumber(aUnit[caP]) or 0)
  aBase[caY] = (tonumber(aBase[caY]) or 0) - (tonumber(aUnit[caY]) or 0)
  aBase[caR] = (tonumber(aBase[caR]) or 0) - (tonumber(aUnit[caR]) or 0)
end

function SubAnglePYR(aBase, nP, nY, nR)
  if(not aBase) then return StatusLog(nil,"SubAnglePYR: Base invalid") end
  aBase[caP] = (tonumber(aBase[caP]) or 0) - (tonumber(nP) or 0)
  aBase[caY] = (tonumber(aBase[caY]) or 0) - (tonumber(nY) or 0)
  aBase[caR] = (tonumber(aBase[caR]) or 0) - (tonumber(nR) or 0)
end

function NegAngle(vBase, bP, bY, bR)
  if(not vBase) then return StatusLog(nil,"NegVector: Base invalid") end
  local P = (tonumber(vBase[caP]) or 0); P = (IsExistent(bP) and (bP and -P or P) or -P)
  local Y = (tonumber(vBase[caY]) or 0); Y = (IsExistent(bY) and (bY and -Y or Y) or -Y)
  local R = (tonumber(vBase[caR]) or 0); R = (IsExistent(bR) and (bR and -R or R) or -R)
  vBase[caP], vBase[caY], vBase[caR] = P, Y, R
end

function SetAngle(aBase, aUnit)
  if(not aBase) then return StatusLog(nil,"SetAngle: Base invalid") end
  if(not aUnit) then return StatusLog(nil,"SetAngle: Unit invalid") end
  aBase[caP] = (tonumber(aUnit[caP]) or 0)
  aBase[caY] = (tonumber(aUnit[caY]) or 0)
  aBase[caR] = (tonumber(aUnit[caR]) or 0)
end

function SetAnglePYR(aBase, nP, nY, nR)
  if(not aBase) then return StatusLog(nil,"SetAnglePYR: Base invalid") end
  aBase[caP] = (tonumber(nP) or 0)
  aBase[caY] = (tonumber(nY) or 0)
  aBase[caR] = (tonumber(nR) or 0)
end

------------- VECTOR ---------------

function ToVector(vBase)
  if(not vBase) then return StatusLog(nil,"ToVector: Base invalid") end
  return Vector((tonumber(vBase[cvX]) or 0), (tonumber(vBase[cvY]) or 0), (tonumber(vBase[cvZ]) or 0))
end

function ExpVector(vBase)
  if(not vBase) then return StatusLog(nil,"ExpVector: Base invalid") end
  return (tonumber(vBase[cvX]) or 0), (tonumber(vBase[cvY]) or 0), (tonumber(vBase[cvZ]) or 0)
end

function GetLengthVector(vBase)
  if(not vBase) then return StatusLog(nil,"GetLengthVector: Base invalid") end
  local X = (tonumber(vBase[cvX]) or 0); X = X * X
  local Y = (tonumber(vBase[cvY]) or 0); Y = Y * Y
  local Z = (tonumber(vBase[cvZ]) or 0); Z = Z * Z
  return mathSqrt(X + Y + Z)
end

function RoundVector(vBase,nvRound)
  if(not vBase) then return StatusLog(nil,"RoundVector: Base invalid") end
  local R = tonumber(nvRound)
  if(not IsExistent(R)) then
    return StatusLog(nil,"RoundVector: Round NAN {"..type(nvRound).."}<"..tostring(nvRound)..">") end
  local X = (tonumber(vBase[cvX]) or 0); X = RoundValue(X,R); vBase[cvX] = X
  local Y = (tonumber(vBase[cvY]) or 0); Y = RoundValue(Y,R); vBase[cvY] = Y
  local Z = (tonumber(vBase[cvZ]) or 0); Z = RoundValue(Z,R); vBase[cvZ] = Z
end

function AddVector(vBase, vUnit)
  if(not vBase) then return StatusLog(nil,"AddVector: Base invalid") end
  if(not vUnit) then return StatusLog(nil,"AddVector: Unit invalid") end
  vBase[cvX] = (tonumber(vBase[cvX]) or 0) + (tonumber(vUnit[cvX]) or 0)
  vBase[cvY] = (tonumber(vBase[cvY]) or 0) + (tonumber(vUnit[cvY]) or 0)
  vBase[cvZ] = (tonumber(vBase[cvZ]) or 0) + (tonumber(vUnit[cvZ]) or 0)
end

function AddVectorXYZ(vBase, nX, nY, nZ)
  if(not vBase) then return StatusLog(nil,"AddVectorXYZ: Base invalid") end
  vBase[cvX] = (tonumber(vBase[cvX]) or 0) + (tonumber(nX) or 0)
  vBase[cvY] = (tonumber(vBase[cvY]) or 0) + (tonumber(nY) or 0)
  vBase[cvZ] = (tonumber(vBase[cvZ]) or 0) + (tonumber(nZ) or 0)
end

function SubVector(vBase, vUnit)
  if(not vBase) then return StatusLog(nil,"SubVector: Base invalid") end
  if(not vUnit) then return StatusLog(nil,"SubVector: Unit invalid") end
  vBase[cvX] = (tonumber(vBase[cvX]) or 0) - (tonumber(vUnit[cvX]) or 0)
  vBase[cvY] = (tonumber(vBase[cvY]) or 0) - (tonumber(vUnit[cvY]) or 0)
  vBase[cvZ] = (tonumber(vBase[cvZ]) or 0) - (tonumber(vUnit[cvZ]) or 0)
end

function SubVectorXYZ(vBase, nX, nY, nZ)
  if(not vBase) then return StatusLog(nil,"SubVectorXYZ: Base invalid") end
  vBase[cvX] = (tonumber(vBase[cvX]) or 0) - (tonumber(nX) or 0)
  vBase[cvY] = (tonumber(vBase[cvY]) or 0) - (tonumber(nY) or 0)
  vBase[cvZ] = (tonumber(vBase[cvZ]) or 0) - (tonumber(nZ) or 0)
end

function NegVector(vBase, bX, bY, bZ)
  if(not vBase) then return StatusLog(nil,"NegVector: Base invalid") end
  local X = (tonumber(vBase[cvX]) or 0); X = (IsExistent(bX) and (bX and -X or X) or -X)
  local Y = (tonumber(vBase[cvY]) or 0); Y = (IsExistent(bY) and (bY and -Y or Y) or -Y)
  local Z = (tonumber(vBase[cvZ]) or 0); Z = (IsExistent(bZ) and (bZ and -Z or Z) or -Z)
  vBase[cvX], vBase[cvY], vBase[cvZ] = X, Y, Z
end

function SetVector(vBase, vUnit)
  if(not vBase) then return StatusLog(nil,"SetVector: Base invalid") end
  if(not vUnit) then return StatusLog(nil,"SetVector: Unit invalid") end
  vBase[cvX] = (tonumber(vUnit[cvX]) or 0)
  vBase[cvY] = (tonumber(vUnit[cvY]) or 0)
  vBase[cvZ] = (tonumber(vUnit[cvZ]) or 0)
end

function SetVectorXYZ(vBase, nX, nY, nZ)
  if(not vBase) then return StatusLog(nil,"SetVector: Base invalid") end
  vBase[cvX] = (tonumber(nX or 0))
  vBase[cvY] = (tonumber(nY or 0))
  vBase[cvZ] = (tonumber(nZ or 0))
end

function MulVectorXYZ(vBase, nX, nY, nZ)
  if(not vBase) then return StatusLog(nil,"SetVector: Base invalid") end
  vBase[cvX] = vBase[cvX] * (tonumber(nX or 0))
  vBase[cvY] = vBase[cvY] * (tonumber(nY or 0))
  vBase[cvZ] = vBase[cvZ] * (tonumber(nZ or 0))
end

function DecomposeByAngle(vBase,aUnit)
  if(not vBase) then return StatusLog(nil,"DecomposeByAngle: Base invalid") end
  if(not aUnit) then return StatusLog(nil,"DecomposeByAngle: Unit invalid") end
  local X = vBase:Dot(aUnit:Forward())
  local Y = vBase:Dot(aUnit:Right())
  local Z = vBase:Dot(aUnit:Up())
  SetVectorXYZ(vBase,X,Y,Z)
end

---------- OOP -----------------

function MakeContainer(sInfo,sDefKey)
  local Curs, Data = 0, {}
  local sSel, sIns, sDel, sMet = "", "", "", ""
  local Info = tostring(sInfo or "Storage container")
  local Key  = sDefKey or GetOpVar("OOP_DEFAULTKEY")
  local self = {}
  function self:GetInfo() return Info end
  function self:GetSize() return Curs end
  function self:GetData() return Data end
  function self:Insert(nsKey,anyValue)
    sIns = nsKey or Key; sMet = "I"
    if(not IsExistent(Data[sIns])) then Curs = Curs + 1; end
    Data[sIns] = anyValue
  end
  function self:Select(nsKey)
    sSel = nsKey or Key; return Data[sSel]
  end
  function self:Delete(nsKey,fnDel)
    sDel = nsKey or Key; sMet = "D"
    if(IsExistent(Data[sDel])) then
      if(IsExistent(fnDel)) then
        fnDel(Data[sDel])
      end
      Data[sDel] = nil
      Curs = Curs - 1
    end
  end
  function self:GetHistory()
    return tostring(sMet)..GetOpVar("OPSYM_REVSIGN")..
           tostring(sSel)..GetOpVar("OPSYM_DIRECTORY")..
           tostring(sIns)..GetOpVar("OPSYM_DIRECTORY")..
           tostring(sDel)
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
  if(sW < 0 or sH < 0) then return StatusLog(nil,"MakeScreen: Start dimension invalid") end
  if(eW < 0 or eH < 0) then return StatusLog(nil,"MakeScreen: End dimension invalid") end
  local Colors = {List = conColors, Key = GetOpVar("OOP_DEFAULTKEY"), Default = Color(255,255,255,255)}
  if(Colors.List) then -- Container check
    if(getmetatable(Colors.List) ~= GetOpVar("TYPEMT_CONTAINER"))
      then return StatusLog(nil,"MakeScreen: Color list not container") end
  else -- Color list is not present then create one
    Colors.List = MakeContainer("Colors")
  end
  local DrawMeth, DrawArgs, Text = {}, {}, {}
  Text.DrwX, Text.DrwY = 0, 0
  Text.ScrW, Text.ScrH = 0, 0
  Text.LstW, Text.LstH = 0, 0
  local self = {}
  function self:GetSize() return (eW-sW), (eH-sH) end
  function self:GetCenter(nX,nY)
    local nW, nH = self:GetSize()
    local nX = (nW / 2) + (tonumber(nX) or 0)
    local nY = (nH / 2) + (tonumber(nY) or 0)
    return nX, nY
  end
  function self:SetColor(keyColor,sMeth)
    if(not IsExistent(keyColor) and not IsExistent(sMeth)) then
      Colors.Key = GetOpVar("OOP_DEFAULTKEY")
      return StatusLog(nil,"MakeScreen.SetColor: Color reset") end
    local keyColor = keyColor or Colors.Key
    if(not IsExistent(keyColor)) then
      return StatusLog(nil,"MakeScreen.SetColor: Indexing skipped") end
    if(not IsString  (   sMeth)) then
      return StatusLog(nil,"MakeScreen.SetColor: Method <"..tostring(method).."> invalid") end
    local rgbColor = Colors.List:Select(keyColor)
    if(not IsExistent(rgbColor)) then rgbColor = Colors.Default end
    if(tostring(Colors.Key) ~= tostring(keyColor)) then -- Update the color only on change
      surfaceSetDrawColor(rgbColor.r, rgbColor.g, rgbColor.b, rgbColor.a)
      surfaceSetTextColor(rgbColor.r, rgbColor.g, rgbColor.b, rgbColor.a)
      Colors.Key = keyColor;
    end -- The drawing color for these two methods uses surface library
    return rgbColor, keyColor
  end
  function self:SetDrawParam(sMeth,tArgs,sKey)
    sMeth = tostring(sMeth or DrawMeth[sKey])
    tArgs =         (tArgs or DrawArgs[sKey])
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
           (Text.ScrW  + (nW or 0)), (Text.ScrH  + (nH or 0)),
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
    else return StatusLog(nil,"MakeScreen.DrawText: Draw method <"..sMeth.."> invalid") end
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
    else return StatusLog(nil,"MakeScreen.DrawTextAdd: Draw method <"..sMeth.."> invalid") end
  end
  function self:Enclose(xyPnt)
    if(xyPnt.x < sW) then return -1 end
    if(xyPnt.x > eW) then return -1 end
    if(xyPnt.y < sH) then return -1 end
    if(xyPnt.y > eH) then return -1 end; return 1
  end
  function self:GetDistance(pS, pE)
    if(self:Enclose(pS) == -1) then
      return StatusLog(nil,"MakeScreen.GetDistance: Start out of border") end
    if(self:Enclose(pE) == -1) then
      return StatusLog(nil,"MakeScreen.GetDistance: End out of border") end
    return mathSqrt((pE.x - pS.x)^2 + (pE.y - pS.y)^2)
  end
  function self:DrawLine(pS,pE,keyColor,sMeth,tArgs)
    if(not (pS and pE)) then return end
    local sMeth, tArgs = self:SetDrawParam(sMeth,tArgs,"LIN")
    local rgbCl, keyCl = self:SetColor(keyColor, sMeth)
    if(sMeth == "SURF") then
      if(self:Enclose(pS) == -1) then
        return StatusLog(nil,"MakeScreen.DrawLine: Start out of border") end
      if(self:Enclose(pE) == -1) then
        return StatusLog(nil,"MakeScreen.DrawLine: End out of border") end
      surfaceDrawLine(pS.x,pS.y,pE.x,pE.y)
    elseif(sMeth == "SEGM") then
      if(self:Enclose(pS) == -1) then
        return StatusLog(nil,"MakeScreen.DrawLine: Start out of border") end
      if(self:Enclose(pE) == -1) then
        return StatusLog(nil,"MakeScreen.DrawLine: End out of border") end
      local nIter = mathClamp((tonumber(tArgs[1]) or 1),1,200)
      if(nIter <= 0) then return end
      local nLx, nLy = (pE.x - pS.x), (pE.y - pS.y)
      local xyD = {x = (nLx / nIter), y = (nLy / nIter)}
      local xyOld, xyNew = {x = pS.x, y = pS.y}, {x = 0,y = 0}
      while(nIter > 0) do
        xyNew.x = xyOld.x + xyD.x
        xyNew.y = xyOld.y + xyD.y
        surfaceDrawLine(xyOld.x,xyOld.y,xyNew.x,xyNew.y)
        xyOld.x, xyOld.y = xyNew.x, xyNew.y
        nIter = nIter - 1;
      end
    elseif(sMeth == "CAM3") then
      renderDrawLine(pS,pE,rgbCl,(tArgs[1] and true or false))
    else return StatusLog(nil,"MakeScreen.DrawLine: Draw method <"..sMeth.."> invalid") end
  end
  function self:DrawRect(pS,pE,keyColor,sMeth,tArgs)
    local sMeth, tArgs = self:SetDrawParam(sMeth,tArgs,"REC")
    self:SetColor(keyColor,sMeth)
    if(sMeth == "SURF") then
      if(self:Enclose(pS) == -1) then
        return StatusLog(nil,"MakeScreen.DrawRect: Start out of border") end
      if(self:Enclose(pE) == -1) then
        return StatusLog(nil,"MakeScreen.DrawRect: End out of border") end
      surfaceSetTexture(surfaceGetTextureID(tostring(tArgs[1])))
      surfaceDrawTexturedRect(pS.x,pS.y,pE.x-pS.x,pE.y-pS.y)
    else return StatusLog(nil,"MakeScreen.DrawRect: Draw method <"..sMeth.."> invalid") end
  end
  function self:DrawCircle(pC,nRad,keyColor,sMeth,tArgs)
    local sMeth, tArgs = self:SetDrawParam(sMeth,tArgs,"CIR")
    local rgbCl, keyCl = self:SetColor(keyColor,sMeth)
    if(sMeth == "SURF") then surfaceDrawCircle(pC.x, pC.y, nRad, rgbCl)
    elseif(sMeth == "SEGM") then
      local nItr = mathClamp((tonumber(tArgs[1]) or 1),1,200)
      local nMax = (GetOpVar("MAX_ROTATION") * mathPi / 180)
      local nStp, nAng = (nMax / nItr), 0
      local xyOld, xyNew, xyRad = {x=0,y=0}, {x=0,y=0}, {x=nRad,y=0}
            xyOld.x = pC.x + xyRad.x
            xyOld.y = pC.y + xyRad.y
      while(nItr > 0) do
        nAng = nAng + nStp
        local nSin, nCos = mathSin(nAng), mathCos(nAng)
        xyNew.x = pC.x + (xyRad.x * nCos - xyRad.y * nSin)
        xyNew.y = pC.y + (xyRad.x * nSin + xyRad.y * nCos)
        surfaceDrawLine(xyOld.x,xyOld.y,xyNew.x,xyNew.y)
        xyOld.x, xyOld.y = xyNew.x, xyNew.y
        nItr = nItr - 1;
      end
    elseif(sMeth == "CAM3") then -- It is a projection of a sphere
      renderSetMaterial(Material(tostring(tArgs[1] or "color")))
      renderDrawSphere (pC,nRad,mathClamp(tArgs[2] or 1,1,200),
                                mathClamp(tArgs[3] or 1,1,200),rgbCl)
    else return StatusLog(nil,"MakeScreen.DrawCircle: Draw method <"..sMeth.."> invalid") end
  end
  setmetatable(self,GetOpVar("TYPEMT_SCREEN"))
  return self
end

function SetAction(sKey,fAct,tDat)
  if(not (sKey and IsString(sKey))) then
    return StatusLog(nil,"SetAction: Key {"..type(sKey).."}<"..tostring(sKey).."> not string") end
  if(not (fAct and type(fAct) == "function")) then
    return StatusLog(nil,"SetAction: Act {"..type(fAct).."}<"..tostring(fAct).."> not function") end
  if(not libAction[sKey]) then libAction[sKey] = {} end
  libAction[sKey].Act, libAction[sKey].Dat = fAct, tDat
  return true
end

function GetActionCode(sKey)
  if(not (sKey and IsString(sKey))) then
    return StatusLog(nil,"GetActionCode: Key {"..type(sKey).."}<"..tostring(sKey).."> not string") end
  if(not (libAction and libAction[sKey])) then
    return StatusLog(nil,"GetActionCode: Key missing <"..sKey..">") end
  return libAction[sKey].Act
end

function GetActionData(sKey)
  if(not (sKey and IsString(sKey))) then
    return StatusLog(nil,"GetActionData: Key {"..type(sKey).."}<"..tostring(sKey).."> not string") end
  if(not (libAction and libAction[sKey])) then
    return StatusLog(nil,"GetActionData: Key not located") end
  return libAction[sKey].Dat
end

function CallAction(sKey,...)
  if(not (sKey and IsString(sKey))) then
    return StatusLog(nil,"CallAction: Key {"..type(sKey).."}<"..tostring(sKey).."> not string") end
  if(not (libAction and libAction[sKey])) then
    return StatusLog(nil,"CallAction: Key not located") end
  return libAction[sKey].Act(libAction[sKey].Dat,...)
end

local function AddLineListView(pnListView,frUsed,ivNdex)
  if(not IsExistent(pnListView)) then
    return StatusLog(false,"LineAddListView: Missing panel") end
  if(not IsValid(pnListView)) then
    return StatusLog(false,"LineAddListView: Invalid panel") end
  if(not IsExistent(frUsed)) then
    return StatusLog(false,"LineAddListView: Missing data") end
  local iNdex = tonumber(ivNdex)
  if(not IsExistent(iNdex)) then
    return StatusLog(false,"LineAddListView: Index NAN {"..type(ivNdex).."}<"..tostring(ivNdex)..">") end
  local tValue = frUsed[iNdex]
  if(not IsExistent(tValue)) then
    return StatusLog(false,"LineAddListView: Missing data on index #"..tostring(iNdex)) end
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not IsExistent(defTable)) then
    return StatusLog(false,"LineAddListView: Missing table definition") end
  local sModel = tValue.Table[defTable[1][1]]
  local sType  = tValue.Table[defTable[2][1]]
  local sName  = tValue.Table[defTable[3][1]]
  local nAct   = tValue.Table[defTable[4][1]]
  local nUsed  = RoundValue(tValue.Value,0.001)
  local pnLine = pnListView:AddLine(nUsed,nAct,sType,sName,sModel)
        pnLine:SetTooltip(sModel)
  return true
end

--[[
 * Updates a VGUI pnListView with a search preformed in the already generated
 * frequently used pieces "frUsed" for the pattern "sPattern" given by the user
 * and a field name selected "sField".
 * On success populates "pnListView" with the search preformed
 * On fail a parameter is not valid or missing and returns non-success
]]--
function UpdateListView(pnListView,frUsed,nCount,sField,sPattern)
  if(not (IsExistent(frUsed) and IsExistent(frUsed[1]))) then
    return StatusLog(false,"UpdateListView: Missing data") end
  local nCount = tonumber(nCount) or 0
  if(nCount <= 0) then
    return StatusLog(false,"UpdateListView: Count not applicable") end
  if(IsExistent(pnListView)) then
    if(not IsValid(pnListView)) then
      return StatusLog(false,"UpdateListView: Invalid ListView") end
    pnListView:SetVisible(false)
    pnListView:Clear()
  else return StatusLog(false,"UpdateListView: Missing ListView") end
  local sField   = tostring(sField   or "")
  local sPattern = tostring(sPattern or "")
  local iNdex, pnRec, sData = 1, nil, nil
  while(frUsed[iNdex]) do
    if(IsEmptyString(sPattern)) then
      if(not AddLineListView(pnListView,frUsed,iNdex)) then
        return StatusLog(false,"UpdateListView: Failed to add line on #"..tostring(iNdex)) end
    else
      sData = tostring(frUsed[iNdex].Table[sField] or "")
      if(sData:find(sPattern)) then
        if(not AddLineListView(pnListView,frUsed,iNdex)) then
          return StatusLog(false,"UpdateListView: Failed to add line <"
            ..sData.."> pattern <"..sPattern.."> on <"..sField.."> #"..tostring(iNdex)) end
      end
    end; iNdex = iNdex + 1
  end; pnListView:SetVisible(true)
  return StatusLog(true,"UpdateListView: Crated #"..tostring(iNdex-1))
end

function GetDirectoryObj(pCurr, vName)
  if(not pCurr) then
    return StatusLog(nil,"GetDirectoryObj: Location invalid") end
  local sName = tostring(vName or "")
        sName = IsEmptyString(sName) and "Other" or sName
  if(not pCurr[sName]) then
    return StatusLog(nil,"GetDirectoryObj: Name missing <"..sName..">") end
  return pCurr[sName], pCurr[sName].__ObjPanel__
end

function SetDirectoryObj(pnBase, pCurr, vName, sImage, txCol)
  if(not IsValid(pnBase)) then
    return StatusLog(nil,"SetDirectoryObj: Base panel invalid") end
  if(not pCurr) then
    return StatusLog(nil,"SetDirectoryObj: Location invalid") end
  local sName = tostring(vName or "")
        sName = IsEmptyString(sName) and "Other" or sName
  local pItem = pnBase:AddNode(sName)
  pCurr[sName] = {}; pCurr[sName].__ObjPanel__ = pItem
  pItem.Icon:SetImage(tostring(sImage or "icon16/folder.png"))
  pItem.InternalDoClick = function() end
  pItem.DoClick         = function() return false end
  pItem.DoRightClick    = function() SetClipboardText(pItem:GetText()) end
  pItem.Label.UpdateColours = function(pSelf)
    return pSelf:SetTextStyleColor(txCol or Color(0,0,0,255)) end
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
  local snCount = tonumber(snCount) or 0
  if(snCount < 1) then
    return StatusLog(nil,"GetFrequentModels: Count not applicable") end
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not IsExistent(defTable)) then
    return StatusLog(nil,"GetFrequentModels: Missing table definition") end
  local tCache = libCache[defTable.Name]
  if(not IsExistent(tCache)) then
    return StatusLog(nil,"GetFrequentModels: Missing table cache space") end
  local iInd, tmNow = 1, Time()
  local frUsed = GetOpVar("TABLE_FREQUENT_MODELS")
  tableEmpty(frUsed)
  for mod, rec in pairs(tCache) do
    if(IsExistent(rec.Used) and IsExistent(rec.Kept) and rec.Kept > 0) then
      iInd = PushSortValues(frUsed,snCount,tmNow-rec.Used,{
               [defTable[1][1]] = mod,
               [defTable[2][1]] = rec.Type,
               [defTable[3][1]] = rec.Name,
               [defTable[4][1]] = rec.Kept
             })
      if(iInd < 1) then return StatusLog(nil,"GetFrequentModels: Array index out of border") end
    end
  end
  if(IsExistent(frUsed) and IsExistent(frUsed[1])) then return frUsed, snCount end
  return StatusLog(nil,"GetFrequentModels: Array is empty or not available")
end

function RoundValue(nvExact, nFrac)
  local nExact = tonumber(nvExact)
  if(not IsExistent(nExact)) then
    return StatusLog(nil,"RoundValue: Cannot round NAN {"..type(nvExact).."}<"..tostring(nvExact)..">") end
  local nFrac = tonumber(nFrac) or 0
  if(nFrac == 0) then
    return StatusLog(nil,"RoundValue: Fraction must be <> 0") end
  local q, f = mathModf(nExact/nFrac)
  return nFrac * (q + (f > 0.5 and 1 or 0))
end

function GetCenter(oEnt)
  -- Set the ENT's Angles first!
  if(not (oEnt and oEnt:IsValid())) then
    return StatusLog(Vector(0,0,0),"GetCenter: Entity Invalid") end
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

local function BorderValue(nsVal,sName)
  if(not IsString(sName)) then return nsVal end
  if(not (IsString(nsVal) or tonumber(nsVal))) then
    return StatusLog(nsVal,"BorderValue: Value not comparable") end
  local Border = GetOpVar("TABLE_BORDERS")
        Border = Border[sName]
  if(IsExistent(Border)) then
    if(Border[1] and nsVal < Border[1]) then return Border[1] end
    if(Border[2] and nsVal > Border[2]) then return Border[2] end
  end; return nsVal
end

function SnapReview(ivPointID, ivPnextID, ivMaxKept)
  local iMaxKept = tonumber(ivMaxKept) or 0
  local iPointID = tonumber(ivPointID) or 0
  local iPnextID = tonumber(ivPnextID) or 0
  if(iMaxKept <= 0) then return 1, 2 end
  if(iPointID <= 0) then return 1, 2 end
  if(iPnextID <= 0) then return 1, 2 end
  if(iPointID  > iMaxKept) then return 1, 2 end
  if(iPnextID  > iMaxKept) then return 1, 2 end -- One active point
  if(iPointID == iPnextID) then return 1, 2 end
  return iPointID, iPnextID
end

function IncDecPointID(ivPointID,nDir,rPiece)
  local iPointID = tonumber(ivPointID)
  if(not IsExistent(iPointID)) then
    return StatusLog(1,"IncDecPointID: Point ID NAN {"..type(ivPointID).."}<"..tostring(ivPointID)..">") end
  local stPOA = LocatePOA(rPiece,iPointID)
  if(not IsExistent(stPOA)) then
    return StatusLog(1,"IncDecPointID: Point ID #"..tostring(iPointID).." not located") end
  local Dir = (tonumber(nDir) or 0); Dir = ((Dir > 0) and 1) or ((Dir < 0) and -1) or 0
  if(Dir == 0) then return StatusLog(iPointID,"IncDecPointID: Direction mismatch") end
  iPointID = RollValue(iPointID + nDir,1,rPiece.Kept)
  stPOA    = LocatePOA(rPiece,iPointID) -- Skip disabled O ( Origin )
  while(stPOA and stPOA.O[csD]) do
    LogInstance("IncDecPointID: Point ID #"..tostring(iPointID).." disabled")
    iPointID = RollValue(iPointID + nDir,1,rPiece.Kept)
    stPOA    = LocatePOA(rPiece,iPointID) -- Skip disabled O ( Origin )
  end; iPointID = RollValue(iPointID,1,rPiece.Kept)
  if(not IsExistent(LocatePOA(rPiece,iPointID))) then
    return StatusLog(1,"IncDecPointID["..tostring(Dir).."]: Offset PnextID #"..tostring(iPointID).." not located") end
  return iPointID
end

function IncDecPnextID(ivPnextID,ivPointID,nDir,rPiece)
  local iPointID, iPnextID = tonumber(ivPointID), tonumber(ivPnextID)
  if(not IsExistent(iPointID)) then
    return StatusLog(1,"IncDecPnextID: PointID NAN {"..type(ivPointID).."}<"..tostring(ivPointID)..">") end
  if(not IsExistent(iPnextID)) then
    return StatusLog(1,"IncDecPnextID: PnextID NAN {"..type(ivPnextID).."}<"..tostring(ivPnextID)..">") end
  if(not IsExistent(LocatePOA(rPiece,iPointID))) then
    return StatusLog(1,"IncDecPointID: Offset PointID #"..tostring(iPointID).." not located") end
  if(not IsExistent(LocatePOA(rPiece,iPnextID))) then
    return StatusLog(1,"IncDecPointID: Offset PnextID #"..tostring(iPnextID).." not located") end
  local Dir = (tonumber(nDir) or 0); Dir = ((Dir > 0) and 1) or ((Dir < 0) and -1) or 0
  if(Dir == 0) then return StatusLog(iPnextID,"IncDecPnextID: Direction mismatch") end
  iPnextID = RollValue(iPnextID + Dir,1,rPiece.Kept)
  if(iPnextID == iPointID) then iPnextID = RollValue(iPnextID + Dir,1,rPiece.Kept) end
  if(not IsExistent(LocatePOA(rPiece,iPnextID))) then
    return StatusLog(1,"IncDecPointID["..tostring(Dir).."]: Offset PnextID #"..tostring(iPnextID).." not located") end
  return iPnextID
end

function GetPointElevation(oEnt,ivPointID)
  if(not (oEnt and oEnt:IsValid())) then
    return StatusLog(nil,"GetPointElevation: Entity Invalid") end
  local sModel = oEnt:GetModel()
  local iPointID = tonumber(ivPointID)
  if(not IsExistent(iPointID)) then
    return StatusLog(nil,"GetPointElevation: PointID NAN {"
             ..type(ivPointID).."}<"..tostring(ivPointID).."> for <"..sModel..">") end
  local hdRec = CacheQueryPiece(sModel)
  if(not IsExistent(hdRec)) then
    return StatusLog(nil,"GetPointElevation: Record not found for <"..sModel..">") end
  local hdPnt = LocatePOA(hdRec,iPointID)
  if(not IsExistent(hdPnt)) then
    return StatusLog(nil,"GetPointElevation: Point #"..tostring(iPointID)
             .." not located on model <"..sModel..">") end
  if(not (hdPnt.O and hdPnt.A)) then
    return StatusLog(nil,"GetPointElevation: Invalid POA #"..tostring(iPointID).." for <"..sModel..">") end
  local aDiffBB, vDiffBB = Angle(), oEnt:OBBMins()
  SetAngle(aDiffBB,hdPnt.A) ; aDiffBB:RotateAroundAxis(aDiffBB:Up(),180)
  SubVector(vDiffBB,hdPnt.O); DecomposeByAngle(vDiffBB,aDiffBB)
  return mathAbs(vDiffBB[cvZ])
end

function ModelToName(sModel,bNoSettings)
  if(not IsString(sModel)) then
    return StatusLog("","ModelToName: Argument {"..type(sModel).."}<"..tostring(sModel)..">") end
  if(IsEmptyString(sModel)) then return StatusLog("","ModelToName: Empty string") end
  local sSymDiv, sSymDir = GetOpVar("OPSYM_DIVIDER"), GetOpVar("OPSYM_DIRECTORY")
  local sModel = (sModel:sub(1, 1) ~= sSymDir) and (sSymDir..sModel) or sModel
        sModel =  sModel:GetFileFromFilename():gsub(GetOpVar("MODELNAM_FILE"),"")
  local gModel =  sModel:sub(1,-1) -- Create a copy so we can select cut-off parts later
  if(not bNoSettings) then local Cnt = 1
    local tCut, tSub, tApp = SettingsModelToName("GET")
    if(tCut and tCut[1]) then
      while(tCut[Cnt] and tCut[Cnt+1]) do
        local fCh, bCh = tonumber(tCut[Cnt]), tonumber(tCut[Cnt+1])
        if(not (IsExistent(fCh) and IsExistent(bCh))) then
          return StatusLog("","ModelToName: Cannot cut the model in {"
                   ..tostring(tCut[Cnt])..","..tostring(tCut[Cnt+1]).."} for "..sModel) end
        gModel = gModel:gsub(sModel:sub(fCh,bCh),"")
        LogInstance("ModelToName[CUT]: {"..tostring(tCut[Cnt])..", "..tostring(tCut[Cnt+1]).."} >> "..gModel)
        Cnt = Cnt + 2
      end; Cnt = 1
    end
    -- Replace the unneeded parts by finding an in-string gModel
    if(tSub and tSub[1]) then
      while(tSub[Cnt]) do
        local fCh, bCh = tostring(tSub[Cnt] or ""), tostring(tSub[Cnt+1] or "")
        gModel = gModel:gsub(fCh,bCh)
        LogInstance("ModelToName[SUB]: {"..tostring(tSub[Cnt])..", "..tostring(tSub[Cnt+1]).."} >> "..gModel)
        Cnt = Cnt + 2
      end; Cnt = 1
    end
    -- Append something if needed
    if(tApp and tApp[1]) then
      gModel = tostring(tApp[1] or "")..gModel..tostring(tApp[2] or "")
      LogInstance("ModelToName[APP]: {"..tostring(tSub[Cnt])..", "..tostring(tSub[Cnt+1]).."} >> "..gModel)
    end
  end
  -- Trigger the capital spacing using the divider
  if(gModel:sub(1,1) ~= sSymDiv) then gModel = sSymDiv..gModel end
  -- Here in gModel we have: _aaaaa_bbbb_ccccc
  return gModel:gsub(sSymDiv.."%w",GetOpVar("MODELNAM_FUNC")):sub(2,-1)
end

--[[
 * Locates an active point on the piece offset record.
 * This function is used to check the correct offset and return it.
 * It also returns the normalized active point ID if needed
 * oRec      --> Record structure of a track piece
 * ivPointID --> The POA offset ID to check and locate
]]--
function LocatePOA(oRec, ivPointID)
  if(not oRec) then
    return StatusLog(nil,"LocatePOA: Missing record") end
  if(not oRec.Offs) then
    return StatusLog(nil,"LocatePOA: Missing offsets for <"..tostring(oRec.Slot)..">") end
  local iPointID = mathFloor(tonumber(ivPointID) or 0)
  local stPOA = oRec.Offs[iPointID]
  if(not IsExistent(stPOA)) then
    return StatusLog(nil,"LocatePOA: Missing ID #"..tostring(iPointID).." <"
             ..tostring(ivPointID).."> for <"..tostring(oRec.Slot)..">") end
  return stPOA, iPointID
end

local function ReloadPOA(nXP,nYY,nZR,nSX,nSY,nSZ,nSD)
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
        arPOA[1] = tonumber(nXP) or 0
        arPOA[2] = tonumber(nYY) or 0
        arPOA[3] = tonumber(nZR) or 0
        arPOA[4] = tonumber(nSX) or 1
        arPOA[5] = tonumber(nSY) or 1
        arPOA[6] = tonumber(nSZ) or 1
        arPOA[7] = tobool(nSD) or false
  return arPOA
end

local function IsEqualPOA(staPOA,stbPOA)
  if(not IsExistent(staPOA)) then
    return StatusLog(false,"EqualPOA: Missing offset A") end
  if(not IsExistent(stbPOA)) then
    return StatusLog(false,"EqualPOA: Missing offset B") end
  for kKey, vComp in pairs(staPOA) do
    if(kKey ~= csD and stbPOA[kKey] ~= vComp) then return false end
  end; return true
end

local function IsZeroPOA(stPOA,sOffs)
  if(not IsString(sOffs)) then
    return StatusLog(nil,"IsZeroPOA: Mode {"..type(sOffs).."}<"..tostring(sOffs).."> not string") end
  if(not IsExistent(stPOA)) then
    return StatusLog(nil,"IsZeroPOA: Missing offset") end
  local ctA, ctB, ctC
  if    (sOffs == "V") then ctA, ctB, ctC = cvX, cvY, cvZ
  elseif(sOffs == "A") then ctA, ctB, ctC = caP, caY, caR
  else return StatusLog(nil,"IsZeroPOA: Missed offset mode "..sOffs) end
  if(stPOA[ctA] == 0 and stPOA[ctB] == 0 and stPOA[ctC] == 0) then return true end
  return false
end

local function StringPOA(stPOA,sOffs)
  if(not IsString(sOffs)) then
    return StatusLog(nil,"StringPOA: Mode {"..type(sOffs).."}<"..tostring(sOffs).."> not string") end
  if(not IsExistent(stPOA)) then
    return StatusLog(nil,"StringPOA: Missing Offsets") end
  local symRevs = GetOpVar("OPSYM_REVSIGN")
  local symDisa = GetOpVar("OPSYM_DISABLE")
  local symSepa = GetOpVar("OPSYM_SEPARATOR")
  local sModeDB = GetOpVar("MODE_DATABASE")
  if    (sOffs == "V") then ctA, ctB, ctC = cvX, cvY, cvZ
  elseif(sOffs == "A") then ctA, ctB, ctC = caP, caY, caR
  else return StatusLog(nil,"StringPOA: Missed offset mode "..sOffs) end
  return ((stPOA[csD] and symDisa or "")  -- Get rid of the spaces
       ..((stPOA[csA] == -1) and symRevs or "")..tostring(stPOA[ctA])..symSepa
       ..((stPOA[csB] == -1) and symRevs or "")..tostring(stPOA[ctB])..symSepa
       ..((stPOA[csC] == -1) and symRevs or "")..tostring(stPOA[ctC])):gsub(" ","")
end

local function TransferPOA(stOffset,sMode)
  if(not IsExistent(stOffset)) then
    return StatusLog(nil,"TransferPOA: Destination needed") end
  if(not IsString(sMode)) then
    return StatusLog(nil,"TransferPOA: Mode {"..type(sMode).."}<"..tostring(sMode).."> not string") end
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
  if    (sMode == "V") then stOffset[cvX] = arPOA[1]; stOffset[cvY] = arPOA[2]; stOffset[cvZ] = arPOA[3]
  elseif(sMode == "A") then stOffset[caP] = arPOA[1]; stOffset[caY] = arPOA[2]; stOffset[caR] = arPOA[3]
  else return StatusLog(nil,"TransferPOA: Missed mode "..sMode) end
  stOffset[csA] = arPOA[4]; stOffset[csB] = arPOA[5]; stOffset[csC] = arPOA[6]; stOffset[csD] = arPOA[7]
  return arPOA
end

local function DecodePOA(sStr)
  if(not IsString(sStr)) then
    return StatusLog(nil,"DecodePOA: Argument {"..type(sStr).."}<"..tostring(sStr).."> not string") end
  local strLen = sStr:len(); ReloadPOA()
  local symOff, symRev = GetOpVar("OPSYM_DISABLE"), GetOpVar("OPSYM_REVSIGN")
  local symSep, arPOA = GetOpVar("OPSYM_SEPARATOR"), GetOpVar("ARRAY_DECODEPOA")
  local S, E, iCnt, dInd, iSep, sCh = 1, 1, 1, 1, 0, ""
  if(sStr:sub(iCnt,iCnt) == symOff) then
    arPOA[7] = true; iCnt = iCnt + 1; S = S + 1 end
  while(iCnt <= strLen) do
    sCh = sStr:sub(iCnt,iCnt)
    if(sCh == symRev) then
      arPOA[3+dInd] = -arPOA[3+dInd]; S = S + 1
    elseif(sCh == symSep) then
      iSep = iSep + 1; E = iCnt - 1
      if(iSep > 2) then break end
      arPOA[dInd] = tonumber(sStr:sub(S,E)) or 0
      dInd = dInd + 1; S = iCnt + 1; E = S
    else E = E + 1 end
    iCnt = iCnt + 1
  end; arPOA[dInd] = (tonumber(sStr:sub(S,E)) or 0); return arPOA
end

local function RegisterPOA(stPiece, ivID, sP, sO, sA)
  if(not stPiece) then
    return StatusLog(nil,"RegisterPOA: Cache record invalid") end
  local iID = tonumber(ivID); if(not IsExistent(iID)) then
    return StatusLog(nil,"RegisterPOA: OffsetID NAN {"..type(ivID).."}<"..tostring(ivID)..">") end
  local sP, sO, sA = (sP or "NULL"), (sO or "NULL"), (sA or "NULL")
  if(not IsString(sP)) then
    return StatusLog(nil,"RegisterPOA: Point  {"..type(sP).."}<"..tostring(sP)..">") end
  if(not IsString(sO)) then
    return StatusLog(nil,"RegisterPOA: Origin {"..type(sO).."}<"..tostring(sO)..">") end
  if(not IsString(sA)) then
    return StatusLog(nil,"RegisterPOA: Angle  {"..type(sA).."}<"..tostring(sA)..">") end
  if(not stPiece.Offs) then
    if(iID > 1) then return StatusLog(nil,"RegisterPOA: First ID cannot be #"..tostring(iID)) end
    stPiece.Offs = {}
  end
  local tOffs = stPiece.Offs; if(tOffs[iID]) then
    return StatusLog(nil,"RegisterPOA: Exists ID #"..tostring(iID))
  else
    if((iID > 1) and (not tOffs[iID - 1])) then
      return StatusLog(nil,"RegisterPOA: No sequential ID #"..tostring(iID - 1))
    end
    tOffs[iID] = {}; tOffs[iID].P = {}; tOffs[iID].O = {}; tOffs[iID].A = {}; tOffs = tOffs[iID]
  end
  ---------------- Origin ----------------
  if((sO ~= "NULL") and not IsEmptyString(sO)) then DecodePOA(sO) else ReloadPOA() end
  if(not IsExistent(TransferPOA(tOffs.O,"V"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer origin") end
  ---------------- Point ----------------
  local sD = sP:gsub(GetOpVar("OPSYM_DISABLE"),"")
  if((sP ~= "NULL") and not IsEmptyString(sP)) then DecodePOA(sP) else ReloadPOA() end
  if(not IsExistent(TransferPOA(tOffs.P,"V"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer point") end
  if((sD == "NULL") or IsEmptyString(sD)) then -- If empty use origin
    tOffs.P[cvX] = tOffs.O[cvX]; tOffs.P[cvY] = tOffs.O[cvY]; tOffs.P[cvZ] = tOffs.O[cvZ];
    tOffs.P[csA] = tOffs.O[csA]; tOffs.P[csB] = tOffs.O[csB]; tOffs.P[csC] = tOffs.O[csC];
  end
  ---------------- Angle ----------------
  if((sA ~= "NULL") and not IsEmptyString(sA)) then DecodePOA(sA) else ReloadPOA() end
  if(not IsExistent(TransferPOA(tOffs.A,"A"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer angle") end
  return tOffs
end

local function Sort(tTable,tKeys,tFields)

  local function QuickSort(Data,Lo,Hi)
    if(not (Lo and Hi and (Lo > 0) and (Lo < Hi))) then
      return StatusLog(nil,"QuickSort: Data dimensions mismatch") end
    local iMid = mathRandom(Hi-(Lo-1))+Lo-1
    Data[Lo], Data[iMid] = Data[iMid], Data[Lo]; iMid = Lo
    local vMid, iCnt = Data[Lo].Val, (Lo + 1)
    while(iCnt <= Hi)do
      if(Data[iCnt].Val < vMid) then iMid = iMid + 1
        Data[iMid], Data[iCnt] = Data[iCnt], Data[iMid]
      end
      iCnt = iCnt + 1
    end
    Data[Lo], Data[iMid] = Data[iMid], Data[Lo]
    QuickSort(Data,Lo,iMid-1)
    QuickSort(Data,iMid+1,Hi)
  end

  local Match = {}
  local tKeys = tKeys or {}
  local tFields = tFields or {}
  local iCnt, iInd, sKey, vRec, sFld = 1, nil, nil, nil, nil
  if(not tKeys[1]) then
    for k,v in pairs(tTable) do
      tKeys[iCnt] = k; iCnt = iCnt + 1
    end; iCnt = 1
  end
  while(tKeys[iCnt]) do
    sKey = tKeys[iCnt]; vRec = tTable[sKey]
    if(not vRec) then
      return StatusLog(nil,"Sort: Key <"..sKey.."> does not exist in the primary table") end
    Match[iCnt] = {}
    Match[iCnt].Key = sKey
    if(type(vRec) == "table") then
      Match[iCnt].Val, iInd = "", 1
      while(tFields[iInd]) do
        sFld = tFields[iInd]
        if(not IsExistent(vRec[sFld])) then
          return StatusLog(nil,"Sort: Field <"..sFld.."> not found on the current record") end
        Match[iCnt].Val = Match[iCnt].Val..tostring(vRec[sFld])
        iInd = iInd + 1
      end
    else Match[iCnt].Val = vRec end
    iCnt = iCnt + 1
  end; QuickSort(Match,1,iCnt-1)
  return Match
end

--------------------- STRING -----------------------

function DisableString(sBase, anyDisable, anyDefault)
  if(IsString(sBase)) then
    local sFirst = sBase:sub(1,1)
    if(sFirst ~= GetOpVar("OPSYM_DISABLE") and not IsEmptyString(sBase)) then
      return sBase
    elseif(sFirst == GetOpVar("OPSYM_DISABLE")) then
      return anyDisable
    end
  end; return anyDefault
end

function DefaultString(sBase, sDefault)
  if(IsString(sBase)) then
    if(not IsEmptyString(sBase)) then return sBase end
  end
  if(IsString(sDefault)) then return sDefault end
  return ""
end

------------- VARIABLE INTERFACES --------------

function SettingsModelToName(sMode, gCut, gSub, gApp)
  if(not IsString(sMode)) then
    return StatusLog(false,"SettingsModelToName: Mode {"..type(sMode).."}<"..tostring(sMode).."> not string") end
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
  else return StatusLog(false,"SettingsModelToName: Wrong mode name "..sMode) end
end

function DefaultType(anyType,fCat)
  if(not IsExistent(anyType)) then
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
        return StatusLog(nil, "DefaultType: Compilation failed <"..fCat.."> ["..sTyp.."]") end
      tCat[sTyp].Cmp = out
    else return StatusLog(nil,"DefaultType: Avoided "..type(fCat).." <"..tostring(fCat).."> ["..sTyp.."]") end
  end
end

function DefaultTable(anyTable)
  if(not IsExistent(anyTable)) then
    return (GetOpVar("DEFAULT_TABLE") or "") end
  SetOpVar("DEFAULT_TABLE",anyTable)
  SettingsModelToName("CLR")
end

------------------------- PLAYER -----------------------------------

local function GetPlayerSpot(pPly)
  if(not IsPlayer(pPly)) then
    return StatusLog(nil,"GetPlayerSpot: Player <"..tostring(pPly)"> invalid") end
  local stSpot = libPlayer[pPly]
  if(not IsExistent(stSpot)) then
    LogInstance("GetPlayerSpot: Cached <"..pPly:Nick()..">")
    libPlayer[pPly] = {}; stSpot = libPlayer[pPly]
  end; return stSpot
end

function CacheSpawnPly(pPly)
  local stSpot = GetPlayerSpot(pPly)
  if(not IsExistent(stSpot)) then
    return StatusLog(nil,"CacheSpawnPly: Place missing") end
  local stData = stSpot["SPAWN"]
  if(not IsExistent(stData)) then
    LogInstance("CacheSpawnPly: Allocate <"..pPly:Nick()..">")
    stSpot["SPAWN"] = {}; stData = stSpot["SPAWN"]
    stData.F    = Vector() -- Origin forward vector
    stData.R    = Vector() -- Origin right vector
    stData.U    = Vector() -- Origin up vector
    stData.OPos = Vector() -- Origin position
    stData.OAng = Angle () -- Origin angle
    stData.SPos = Vector() -- Gear spawn position
    stData.SAng = Angle () -- Gear spawn angle
    stData.RLen = 0        -- Trace active radius
    --- Holder ---
    stData.HRec = 0        -- Pointer to the holder record
    stData.HID  = 0        -- Point ID
    stData.HPnt = Vector() -- P
    stData.HPos = Vector() -- O
    stData.HAng = Angle () -- A
    --- Traced ---
    stData.TRec = 0        -- Pointer to the trace record
    stData.TID  = 0
    stData.TPnt = Vector() -- P
    stData.TPos = Vector() -- O
    stData.TAng = Angle () -- A
    --- Offsets ---
    stData.ANxt = Angle () -- Origin angle offsets
    stData.PNxt = Vector() -- Piece  position offsets
  end; return stData
end

function CacheClearPly(pPly)
  if(not IsPlayer(pPly)) then
    return StatusLog(false,"CacheClearPly: Player <"..tostring(pPly)"> invalid") end
  local stSpot = libPlayer[pPly]
  if(not IsExistent(stSpot)) then
    return StatusLog(true,"CacheClearPly: Clean") end
  libPlayer[pPly] = nil; collectgarbage(); return true
end

function GetDistanceHitPly(pPly, vHit)
  if(not IsPlayer(pPly)) then
    return StatusLog(nil,"GetDistanceHitPly: Player <"..tostring(pPly)"> invalid") end
  return (vHit - pPly:GetPos()):Length()
end

function CacheRadiusPly(pPly, vHit, nSca)
  local stSpot = GetPlayerSpot(pPly)
  if(not IsExistent(stSpot)) then
    return StatusLog(nil,"CacheRadiusPly: Place missing") end
  local stData = stSpot["RADIUS"]
  if(not IsExistent(stData)) then
    LogInstance("CacheRadiusPly: Allocate <"..pPly:Nick()..">")
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
  local stSpot = GetPlayerSpot(pPly)
  if(not IsExistent(stSpot)) then
    return StatusLog(nil,"CacheTracePly: Place missing") end
  local stData, plyTime = stSpot["TRACE"], Time()
  if(not IsExistent(stData)) then -- Define trace delta margin
    LogInstance("CacheTracePly: Allocate <"..pPly:Nick()..">")
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
    return StatusLog(nil,"ConCommandPly: Player <"..tostring(pPly).."> invalid") end
  if(not IsString(sCvar)) then -- Make it like so the space will not be forgotten
    return StatusLog(nil,"ConCommandPly: Convar {"..type(sCvar).."}<"..tostring(sCvar).."> not string") end
  return pPly:ConCommand(GetOpVar("TOOLNAME_PL")..sCvar.." "..tostring(snValue).."\n")
end

function PrintNotifyPly(pPly,sText,sNotifType)
  if(not IsPlayer(pPly)) then
    return StatusLog(false,"PrintNotifyPly: Player <"..tostring(pPly)"> invalid") end
  if(SERVER) then -- Send notification to client that something happened
    pPly:SendLua("GAMEMODE:AddNotify(\""..sText.."\", NOTIFY_"..sNotifType..", 6)")
    pPly:SendLua("surface.PlaySound(\"ambient/water/drip"..mathRandom(1, 4)..".wav\")")
  end; return StatusLog(true,"PrintNotifyPly: Success")
end

function UndoCratePly(anyMessage)
  SetOpVar("LABEL_UNDO",tostring(anyMessage))
  undoCreate(GetOpVar("LABEL_UNDO"))
  return true
end

function UndoAddEntityPly(oEnt)
  if(not (oEnt and oEnt:IsValid())) then
    return StatusLog(false,"UndoAddEntityPly: Entity invalid") end
  undoAddEntity(oEnt); return true
end

function UndoFinishPly(pPly,anyMessage)
  if(not IsPlayer(pPly)) then
    return StatusLog(false,"UndoFinishPly: Player <"..tostring(pPly)"> invalid") end
  pPly:EmitSound("physics/metal/metal_canister_impact_hard"..mathRandom(1, 3)..".wav")
  undoSetCustomUndoText(GetOpVar("LABEL_UNDO")..tostring(anyMessage or ""))
  undoSetPlayer(pPly)
  undoFinish()
  return true
end

function CachePressPly(pPly)
  local stSpot = GetPlayerSpot(pPly)
  if(not IsExistent(stSpot)) then
    return StatusLog(false,"CachePressPly: Place missing") end
  local stData = stSpot["PRESS"]
  if(not IsExistent(stData)) then -- Create predicate command
    LogInstance("CachePressPly: Allocate <"..pPly:Nick()..">")
    stSpot["PRESS"] = {}; stData = stSpot["PRESS"]
    stData["CMD"] = pPly:GetCurrentCommand()
    if(not IsExistent(stData["CMD"])) then
      return StatusLog(false,"CachePressPly: Command incorrect") end
  end; return true
end

-- https://wiki.garrysmod.com/page/CUserCmd/GetMouseWheel
function GetMouseWheelPly(pPly)
  local stSpot = GetPlayerSpot(pPly)
  if(not IsExistent(stSpot)) then
    return StatusLog(0,"GetMouseWheelPly: Place missing") end
  local stData = stSpot["PRESS"]
  if(not IsExistent(stData)) then
    return StatusLog(0,"GetMouseWheelPly: Data missing <"..pPly:Nick()..">") end
  local cmdPress = stData["CMD"]
  if(not IsExistent(cmdPress)) then
    return StatusLog(0,"GetMouseWheelPly: Command missing <"..pPly:Nick()..">") end
  return (cmdPress and cmdPress:GetMouseWheel() or 0)
end

-- https://wiki.garrysmod.com/page/CUserCmd/GetMouse(XY)
function GetMouseVectorPly(pPly)
  local stSpot = GetPlayerSpot(pPly)
  if(not IsExistent(stSpot)) then
    return 0, StatusLog(0,"GetMouseVectorPly: Place missing") end
  local stData = stSpot["PRESS"]
  if(not IsExistent(stData)) then
    return 0, StatusLog(0,"GetMouseVectorPly: Data missing <"..pPly:Nick()..">") end
  local cmdPress = stData["CMD"]
  if(not IsExistent(stData)) then
    return 0, StatusLog(0,"GetMouseVectorPly: Command missing <"..pPly:Nick()..">") end
  return cmdPress:GetMouseX(), cmdPress:GetMouseY()
end

-- https://wiki.garrysmod.com/page/Enums/IN
function CheckButtonPly(pPly, iInKey)
  local stSpot, iInKey = GetPlayerSpot(pPly), (tonumber(iInKey) or 0)
  if(not IsExistent(stSpot)) then
    return StatusLog(false,"GetMouseVectorPly: Place missing") end
  local stData = stSpot["PRESS"]
  if(not IsExistent(stData)) then return pPly:KeyDown(iInKey) end
  local cmdPress = stData["CMD"]
  if(not IsExistent(cmdPress)) then return pPly:KeyDown(iInKey) end
  return (bitBand(cmdPress:GetButtons(),iInKey) ~= 0) -- Read the cache
end

-------------------------- BUILDSQL ------------------------------

local function MatchType(defTable,snValue,ivIndex,bQuoted,sQuote,bStopRevise,bStopEmpty)
  if(not defTable) then
    return StatusLog(nil,"MatchType: Missing table definition") end
  local nIndex = tonumber(ivIndex); if(not IsExistent(nIndex)) then
    return StatusLog(nil,"MatchType: Field NAN {"..type(ivIndex)"}<"
             ..tostring(ivIndex).."> invalid on table "..defTable.Name) end
  local defCol = defTable[nIndex]; if(not IsExistent(defCol)) then
    return StatusLog(nil,"MatchType: Invalid field #"
             ..tostring(nIndex).." on table "..defTable.Name) end
  local tipCol, sModeDB, snOut = tostring(defCol[2]), GetOpVar("MODE_DATABASE")
  if(tipCol == "TEXT") then snOut = tostring(snValue or "")
    if(not bStopEmpty and IsEmptyString(snOut)) then
      if    (sModeDB == "SQL") then snOut = "NULL"
      elseif(sModeDB == "LUA") then snOut = "NULL"
      else return StatusLog(nil,"MatchType: Wrong database empty mode <"..sModeDB..">") end
    end
    if    (defCol[3] == "LOW") then snOut = snOut:lower()
    elseif(defCol[3] == "CAP") then snOut = snOut:upper() end
    if(not bStopRevise and sModeDB == "SQL" and defCol[4] == "QMK") then
      snOut = snOut:gsub("'","''") end
    if(bQuoted) then local sqChar
      if(sQuote) then
        sqChar = tostring(sQuote or ""):sub(1,1)
      else
        if    (sModeDB == "SQL") then sqChar = "'"
        elseif(sModeDB == "LUA") then sqChar = "\""
        else return StatusLog(nil,"MatchType: Wrong database quote mode <"..sModeDB..">") end
      end; snOut = sqChar..snOut..sqChar
    end
  elseif(tipCol == "REAL" or tipCol == "INTEGER") then
    snOut = tonumber(snValue)
    if(IsExistent(snOut)) then
      if(tipCol == "INTEGER") then
        if    (defCol[3] == "FLR") then snOut = mathFloor(snOut)
        elseif(defCol[3] == "CEL") then snOut = mathCeil (snOut) end
      end
    else return StatusLog(nil,"MatchType: Failed converting {"
      ..type(snValue).."}<"..tostring(snValue).."> to NUMBER for table "
      ..defTable.Name.." field #"..nIndex) end
  else return StatusLog(nil,"MatchType: Invalid field type <"
    ..tipCol.."> on table "..defTable.Name)
  end; return snOut
end

local function SQLBuildCreate(defTable)
  if(not defTable) then
    return StatusLog(nil, "SQLBuildCreate: Missing table definition") end
  local indTable = defTable.Index
  if(not defTable[1]) then
    return StatusLog(nil, "SQLBuildCreate: Missing table definition is empty for "..defTable.Name) end
  if(not (defTable[1][1] and defTable[1][2])) then
    return StatusLog(nil, "SQLBuildCreate: Missing table "..defTable.Name.." field definitions") end
  local Command, iInd = {}, 1
  Command.Drop   = "DROP TABLE "..defTable.Name..";"
  Command.Delete = "DELETE FROM "..defTable.Name..";"
  Command.Create = "CREATE TABLE "..defTable.Name.." ( "
  while(defTable[iInd]) do
    local v = defTable[iInd]
    if(not v[1]) then
      return StatusLog(nil, "SQLBuildCreate: Missing Table "..defTable.Name
                          .."'s field #"..tostring(iInd)) end
    if(not v[2]) then
      return StatusLog(nil, "SQLBuildCreate: Missing Table "..defTable.Name
                                  .."'s field type #"..tostring(iInd)) end
    Command.Create = Command.Create..(v[1]):upper().." "..(v[2]):upper()
    if(defTable[iInd+1]) then Command.Create = Command.Create ..", " end
    iInd = iInd + 1
  end
  Command.Create = Command.Create.." );"
  if(indTable and
     indTable[1] and
     type(indTable[1]) == "table" and
     indTable[1][1] and
     type(indTable[1][1]) == "number"
   ) then
    Command.Index = {}
    iInd, iCnt = 1, 1
    while(indTable[iInd]) do
      local vI = indTable[iInd]
      if(type(vI) ~= "table") then
        return StatusLog(nil, "SQLBuildCreate: Index creator mismatch on "
          ..defTable.Name.." value "..vI.." is not a table for index ["..tostring(iInd).."]") end
      local FieldsU = ""
      local FieldsC = ""
      Command.Index[iInd] = "CREATE INDEX IND_"..defTable.Name
      iCnt = 1
      while(vI[iCnt]) do
        local vF = vI[iCnt]
        if(type(vF) ~= "number") then
          return StatusLog(nil, "SQLBuildCreate: Index creator mismatch on "
            ..defTable.Name.." value "..vF.." is not a number for index ["
            ..tostring(iInd).."]["..tostring(iCnt).."]") end
        if(not defTable[vF]) then
          return StatusLog(nil, "SQLBuildCreate: Index creator mismatch on "
            ..defTable.Name..". The table does not have field index #"
            ..vF..", max is #"..Table.Size) end
        FieldsU = FieldsU.."_" ..(defTable[vF][1]):upper()
        FieldsC = FieldsC..(defTable[vF][1]):upper()
        if(vI[iCnt+1]) then FieldsC = FieldsC ..", " end
        iCnt = iCnt + 1
      end
      Command.Index[iInd] = Command.Index[iInd]..FieldsU.." ON "..defTable.Name.." ( "..FieldsC.." );"
      iInd = iInd + 1
    end
  end; return Command
end

local function SQLCacheStmt(sHash,sStmt,...)
  if(not IsExistent(sHash)) then
    return StatusLog(nil, "SQLCacheStmt: Store hash missing") end
  local sHash, tStore = tostring(sHash), GetOpVar("QUERY_STORE")
  if(not IsExistent(tStore)) then
    return StatusLog(nil, "SQLCacheStmt: Store place missing") end
  if(IsExistent(sStmt)) then
    tStore[sHash] = tostring(sStmt); Print(tStore,"SQLCacheStmt: stmt") end
  local sBase = tStore[sHash]; if(not IsExistent(sBase)) then
    return StatusLog(nil, "SQLCacheStmt: Stmt missing <"..sHash..">") end
  return sBase:format(...)
end

local function SQLBuildSelect(defTable,tFields,tWhere,tOrderBy)
  if(not defTable) then
    return StatusLog(nil, "SQLBuildSelect: Missing table definition") end
  if(not (defTable[1][1] and defTable[1][2])) then
    return StatusLog(nil, "SQLBuildSelect: Missing table "..defTable.Name.." field definitions") end
  local Command, Cnt = "SELECT ", 1
  if(tFields) then
    while(tFields[Cnt]) do
      local v = tonumber(tFields[Cnt])
      if(not IsExistent(v)) then
        return StatusLog(nil, "SQLBuildSelect: Index NAN {"
             ..type(tFields[Cnt]).."}<"..tostring(tFields[Cnt])
             .."> type mismatch in "..defTable.Name) end
      if(not defTable[v]) then
        return StatusLog(nil, "SQLBuildSelect: Missing field by index #"
          ..v.." in the table "..defTable.Name) end
      if(defTable[v][1]) then Command = Command..defTable[v][1]
      else return StatusLog(nil, "SQLBuildSelect: Missing field name by index #"
        ..v.." in the table "..defTable.Name) end
      if(tFields[Cnt+1]) then Command = Command ..", " end
      Cnt = Cnt + 1
    end
  else Command = Command.."*" end
  Command = Command .." FROM "..defTable.Name
  if(tWhere and
     type(tWhere == "table") and
     type(tWhere[1]) == "table" and
     tWhere[1][1] and
     tWhere[1][2] and
     type(tWhere[1][1]) == "number" and
     (type(tWhere[1][2]) == "string" or type(tWhere[1][2]) == "number")
  ) then
    Cnt = 1
    while(tWhere[Cnt]) do
      local k = tonumber(tWhere[Cnt][1])
      local v = tWhere[Cnt][2]
      local t = defTable[k][2]
      if(not (k and v and t) ) then
        return StatusLog(nil, "SQLBuildSelect: Where clause inconsistent on "
          ..defTable.Name.." field index, {"..tostring(k)..","..tostring(v)..","..tostring(t)
          .."} value or type in the table definition") end
      if(not IsExistent(v)) then
        return StatusLog(nil, "SQLBuildSelect: Data matching failed on "
          ..defTable.Name.." field index #"..Cnt.." value <"..tostring(v)..">") end
      if(Cnt == 1) then Command = Command.." WHERE "..defTable[k][1].." = "..tostring(v)
      else              Command = Command.." AND "  ..defTable[k][1].." = "..tostring(v) end
      Cnt = Cnt + 1
    end
  end
  if(tOrderBy and (type(tOrderBy) == "table")) then
    local Dire = ""
    Command, Cnt = Command.." ORDER BY ", 1
    while(tOrderBy[Cnt]) do
      local v = tOrderBy[Cnt]
      if(v ~= 0) then
        if(v > 0) then Dire = " ASC"
        else Dire, tOrderBy[Cnt] = " DESC", -v end
      else return StatusLog(nil, "SQLBuildSelect: Order wrong for "
        ..defTable.Name .." field index #"..Cnt) end
      Command = Command..defTable[v][1]..Dire
      if(tOrderBy[Cnt+1]) then Command = Command..", " end
      Cnt = Cnt + 1
    end
  end; return Command..";"
end

local function SQLBuildInsert(defTable,tInsert,tValues)
  if(not defTable) then
    return StatusLog(nil, "SQLBuildInsert: Missing Table definition") end
  if(not tValues) then
    return StatusLog(nil, "SQLBuildInsert: Missing Table value fields") end
  if(not defTable[1]) then
    return StatusLog(nil, "SQLBuildInsert: The table and the chosen fields must not be empty") end
  if(not (defTable[1][1] and defTable[1][2])) then
    return StatusLog(nil, "SQLBuildInsert: Missing table "..defTable.Name.." field definition") end
  local tInsert = tInsert or {}
  if(not tInsert[1]) then
    local iCnt = 1
    while(defTable[iCnt]) do
      tInsert[iCnt] = iCnt; iCnt = iCnt + 1 end
  end
  local iCnt, qVal = 1, " VALUES ( "
  local qIns = "INSERT INTO "..defTable.Name.." ( "
  while(tInsert[iCnt]) do
    local iIns = tInsert[iCnt]; local tIns = defTable[iIns]
    if(not IsExistent(tIns)) then
      return StatusLog(nil, "SQLBuildInsert: No such field #"..iIns.." on table "..defTable.Name) end
    qIns, qVal = qIns..tIns[1], qVal..tostring(tValues[iCnt])
    if(tInsert[iCnt+1]) then qIns, qVal = qIns ..", " , qVal ..", "
    else qIns, qVal = qIns .." ) ", qVal .." );" end; iCnt = iCnt + 1
  end; return qIns..qVal
end

function CreateTable(sTable,defTable,bDelete,bReload)
  if(not IsString(sTable)) then
    return StatusLog(false,"CreateTable: Table key {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  if(not (type(defTable) == "table")) then
    return StatusLog(false,"CreateTable: Table definition missing for "..sTable) end
  if(#defTable <= 0) then
    return StatusLog(false,"CreateTable: Record definition missing for "..sTable) end
  if(#defTable ~= tableMaxn(defTable)) then
    return StatusLog(false,"CreateTable: Record definition mismatch for "..sTable) end
  local sTable  = sTable:upper()
  local sModeDB = GetOpVar("MODE_DATABASE")
  local symDis  = GetOpVar("OPSYM_DISABLE")
  local iCnt, defCol = 1, nil
  SetOpVar("DEFTABLE_"..sTable,defTable)
  defTable.Size = #defTable
  defTable.Name = GetOpVar("TOOLNAME_PU")..sTable
  while(defTable[iCnt]) do
    defCol    = defTable[iCnt]
    defCol[3] = DefaultString(tostring(defCol[3] or symDis), symDis)
    defCol[4] = DefaultString(tostring(defCol[4] or symDis), symDis)
    iCnt = iCnt + 1
  end; libCache[defTable.Name] = {}
  if(sModeDB == "SQL") then
    local tQ = SQLBuildCreate(defTable)
    if(not IsExistent(tQ)) then return StatusLog(false,"CreateTable: Build statement failed") end
    if(bDelete and sqlTableExists(defTable.Name)) then
      local qRez = sqlQuery(tQ.Delete)
      if(not qRez and IsBool(qRez)) then
        LogInstance("CreateTable: Table "..sTable.." is not present. Skipping delete !")
      else
        LogInstance("CreateTable: Table "..sTable.." deleted !")
      end
    end
    if(bReload) then
      local qRez = sqlQuery(tQ.Drop)
      if(not qRez and IsBool(qRez)) then
        LogInstance("CreateTable: Table "..sTable.." is not present. Skipping drop !")
      else
        LogInstance("CreateTable: Table "..sTable.." dropped !")
      end
    end
    if(sqlTableExists(defTable.Name)) then
      return StatusLog(true,"CreateTable: Table "..sTable.." exists!")
    else
      local qRez = sqlQuery(tQ.Create)
      if(not qRez and IsBool(qRez)) then
        return StatusLog(false,"CreateTable: Table "..sTable
          .." failed to create because of "..sqlLastError()) end
      if(sqlTableExists(defTable.Name)) then
        for k, v in pairs(tQ.Index) do
          qRez = sqlQuery(v)
          if(not qRez and IsBool(qRez)) then
            return StatusLog(false,"CreateTable: Table "..sTable..
              " failed to create index ["..k.."] > "..v .." > because of "..sqlLastError()) end
        end return StatusLog(true,"CreateTable: Indexed Table "..sTable.." created !")
      else
        return StatusLog(false,"CreateTable: Table "..sTable..
          " failed to create because of "..sqlLastError().." Query ran > "..tQ.Create) end
    end
  elseif(sModeDB == "LUA") then
    LogInstance("CreateTable: Created "..defTable.Name)
  else return StatusLog(false,"CreateTable: Wrong database mode <"..sModeDB..">") end
end

function InsertRecord(sTable,arLine)
  if(not IsExistent(sTable)) then
    return StatusLog(false,"InsertRecord: Missing table name/values")
  end
  if(type(sTable) == "table") then
    arLine = sTable
    sTable = DefaultTable()
    if(not (IsExistent(sTable) and sTable ~= "")) then
      return StatusLog(false,"InsertRecord: Missing table default name for "..sTable) end
  end
  if(not IsString(sTable)) then
    return StatusLog(false,"InsertRecord: Table name {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"InsertRecord: Missing table definition for "..sTable) end
  if(not defTable[1])  then
    return StatusLog(false,"InsertRecord: Missing table definition is empty for "..sTable) end
  if(not arLine)      then
    return StatusLog(false,"InsertRecord: Missing data table for "..sTable) end
  if(not arLine[1])   then
    for key, val in pairs(arLine) do
      LogInstance("PK data ["..tostring(key).."] = <"..tostring(val)..">") end
    return StatusLog(false,"InsertRecord: Missing PK for "..sTable)
  end

  if(sTable == "PIECES") then
    local trClass = GetOpVar("TRACE_CLASS")
    arLine[2] = DisableString(arLine[2],DefaultType(),"TYPE")
    arLine[3] = DisableString(arLine[3],ModelToName(arLine[1]),"MODEL")
    arLine[8] = DisableString(arLine[8],nil,nil)
    if(IsString(arLine[8]) and (arLine[8] ~= "NULL")
       and not trClass[arLine[8]] and not IsEmptyString(arLine[8])) then
      trClass[arLine[8]] = true -- Register the class provided
      LogInstance("InsertRecord: Register trace <"..tostring(arLine[8]).."@"..arLine[1]..">")
    end -- Add the special class to the trace list
  elseif(sTable == "PHYSPROPERTIES") then
    arLine[1] = DisableString(arLine[1],DefaultType(),"TYPE")
  end

  local sModeDB = GetOpVar("MODE_DATABASE")
  if(sModeDB == "SQL") then local Q
    for iID = 1, defTable.Size, 1 do
      arLine[iID] = MatchType(defTable,arLine[iID],iID,true) end
    if(sTable == "PIECES") then
      Q = SQLCacheStmt("stmtInsertPieces", nil, unpack(arLine))
      if(not Q) then
        local sStmt = SQLBuildInsert(defTable,nil,{"%s","%s","%s","%d","%s","%s","%s","%s"})
        if(not IsExistent(sStmt)) then
          return StatusLog(nil,"InsertRecord: Build statement <"..sTable.."> failed") end
        Q = SQLCacheStmt("stmtInsertPieces", sStmt, unpack(arLine)) end
    elseif(sTable == "ADDITIONS") then
      Q = SQLCacheStmt("stmtInsertAdditions", nil, unpack(arLine))
      if(not Q) then
        local sStmt = SQLBuildInsert(defTable,nil,{"%s","%s","%s","%d","%s","%s","%d","%d","%d","%d","%d","%d"})
        if(not IsExistent(sStmt)) then
          return StatusLog(nil,"InsertRecord: Build statement <"..sTable.."> failed") end
        Q = SQLCacheStmt("stmtInsertAdditions", sStmt, unpack(arLine)) end
    elseif(sTable == "PHYSPROPERTIES") then
      Q = SQLCacheStmt("stmtInsertPhysproperties", nil, unpack(arLine))
      if(not Q) then
        local sStmt = SQLBuildInsert(defTable,nil,{"%s","%d","%s"})
        if(not IsExistent(sStmt)) then
          return StatusLog(nil,"InsertRecord: Build statement <"..sTable.."> failed") end
        Q = SQLCacheStmt("stmtInsertPhysproperties", sStmt, unpack(arLine)) end
    else return StatusLog(false, "InsertRecord: Missed query pattern for <"..sTable..">") end
    if(not IsExistent(Q)) then
      return StatusLog(false, "InsertRecord: Internal cache error <"..sTable..">")end
    local qRez = sqlQuery(Q)
    if(not qRez and IsBool(qRez)) then
       return StatusLog(false,"InsertRecord: Failed to insert a record because of <"
              ..sqlLastError().."> Query ran <"..Q..">") end
    return true
  elseif(sModeDB == "LUA") then
    local snPrimaryKey = MatchType(defTable,arLine[1],1)
    if(not IsExistent(snPrimaryKey)) then -- If primary key becomes a number
      return StatusLog(nil,"InsertRecord: Cannot match primary key "
                          ..sTable.." <"..tostring(arLine[1]).."> to "
                          ..defTable[1][1].." for "..tostring(snPrimaryKey)) end
    local tCache = libCache[defTable.Name]
    if(not IsExistent(tCache)) then
      return StatusLog(false,"InsertRecord: Cache not allocated for "..defTable.Name) end
    if(sTable == "PIECES") then
      local stData = tCache[snPrimaryKey]
      if(not stData) then
        tCache[snPrimaryKey] = {}; stData = tCache[snPrimaryKey] end
      if(not IsExistent(stData.Type)) then stData.Type = arLine[2] end
      if(not IsExistent(stData.Name)) then stData.Name = arLine[3] end
      if(not IsExistent(stData.Unit)) then stData.Unit = arLine[8] end
      if(not IsExistent(stData.Kept)) then stData.Kept = 0        end
      if(not IsExistent(stData.Slot)) then stData.Slot = snPrimaryKey end
      local nOffsID = MatchType(defTable,arLine[4],4) -- LineID has to be set properly
      if(not IsExistent(nOffsID)) then
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(arLine[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimaryKey))
      end
      local stRezul = RegisterPOA(stData,nOffsID,arLine[5],arLine[6],arLine[7])
      if(not IsExistent(stRezul)) then
        return StatusLog(nil,"InsertRecord: Cannot process offset #"..tostring(nOffsID).." for "..tostring(snPrimaryKey)) end
      if(nOffsID > stData.Kept) then stData.Kept = nOffsID else
        return StatusLog(nil,"InsertRecord: Offset #"..tostring(nOffsID).." sequential mismatch") end
    elseif(sTable == "ADDITIONS") then
      local stData = tCache[snPrimaryKey]
      if(not stData) then
        tCache[snPrimaryKey] = {}; stData = tCache[snPrimaryKey] end
      if(not IsExistent(stData.Kept)) then stData.Kept = 0 end
      if(not IsExistent(stData.Slot)) then stData.Slot = snPrimaryKey end
      local nCnt, sFld, nAddID = 2, "", MatchType(defTable,arLine[4],4)
      if(not IsExistent(nAddID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(arLine[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimaryKey)) end
      stData[nAddID] = {}
      while(nCnt <= defTable.Size) do
        sFld = defTable[nCnt][1]
        stData[nAddID][sFld] = MatchType(defTable,arLine[nCnt],nCnt)
        if(not IsExistent(stData[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          return StatusLog(nil,"InsertRecord: Cannot match "
                    ..sTable.." <"..tostring(arLine[nCnt]).."> to "
                    ..defTable[nCnt][1].." for "..tostring(snPrimaryKey)) end
        nCnt = nCnt + 1
      end; stData.Kept = nAddID
    elseif(sTable == "PHYSPROPERTIES") then
      local sKeyName = GetOpVar("HASH_PROPERTY_NAMES")
      local sKeyType = GetOpVar("HASH_PROPERTY_TYPES")
      local tTypes   = tCache[sKeyType]
      local tNames   = tCache[sKeyName]
      -- Handle the Type
      if(not tTypes) then
        tCache[sKeyType] = {}; tTypes = tCache[sKeyType]; tTypes.Kept = 0 end
      if(not tNames) then
        tCache[sKeyName] = {}; tNames = tCache[sKeyName] end
      local iNameID = MatchType(defTable,arLine[2],2)
      if(not IsExistent(iNameID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(arLine[2]).."> to "
                            ..defTable[2][1].." for "..tostring(snPrimaryKey)) end
      if(not IsExistent(tNames[snPrimaryKey])) then
        -- If a new type is inserted
        tTypes.Kept = tTypes.Kept + 1
        tTypes[tTypes.Kept] = snPrimaryKey
        tNames[snPrimaryKey] = {}
        tNames[snPrimaryKey].Kept = 0
        tNames[snPrimaryKey].Slot = snPrimaryKey
      end -- MatchType crashes only on numbers
      tNames[snPrimaryKey].Kept = iNameID
      tNames[snPrimaryKey][iNameID] = MatchType(defTable,arLine[3],3)
    else
      return StatusLog(false,"InsertRecord: No settings for table "..sTable)
    end
  end
end

--------------- TIMER MEMORY MANAGMENT ----------------------------

local function NavigateTable(oArea,tKeys)
  if(not IsExistent(oArea)) then
    return nil, StatusLog(nil,"NavigateTable: Location missing") end
  if(not IsExistent(tKeys)) then
    return nil, StatusLog(nil,"NavigateTable: Key table missing") end
  if(not IsExistent(tKeys[1])) then
    return nil, StatusLog(nil,"NavigateTable: First key missing") end
  local oSpot, kKey, iCnt = oArea, tKeys[1], 1
  while(tKeys[iCnt]) do kKey = tKeys[iCnt]
    if(tKeys[iCnt+1]) then oSpot = oSpot[kKey]
      if(not IsExistent(oSpot)) then
        return nil, StatusLog(nil,"NavigateTable: Key #"..tostring(kKey).." irrelevant to location") end
    end; iCnt = iCnt + 1
  end; return oSpot, kKey
end

function TimerSetting(sTimerSet) -- Generates a timer settings table and keeps the defaults
  if(not IsExistent(sTimerSet)) then
    return StatusLog(nil,"TimerSetting: Timer set missing for setup") end
  if(not IsString(sTimerSet)) then
    return StatusLog(nil,"TimerSetting: Timer set {"..type(sTimerSet).."}<"..tostring(sTimerSet).."> not string") end
  local tBoom = GetOpVar("OPSYM_REVSIGN"):Explode(sTimerSet)
  tBoom[1] =   tostring(tBoom[1]  or "CQT")
  tBoom[2] =  (tonumber(tBoom[2]) or 0)
  tBoom[3] = ((tonumber(tBoom[3]) or 0) ~= 0) and true or false
  tBoom[4] = ((tonumber(tBoom[4]) or 0) ~= 0) and true or false
  return tBoom
end

local function TimerAttach(oArea,tKeys,defTable,anyMessage)
  if(not defTable) then
    return StatusLog(nil,"TimerAttach: Missing table definition") end
  local Spot, Key = NavigateTable(oArea,tKeys)
  if(not (IsExistent(Spot) and IsExistent(Key))) then
    return StatusLog(nil,"TimerAttach: Navigation failed") end
  if(not IsExistent(Spot[Key])) then
    return StatusLog(nil,"TimerAttach: Data not found") end
  local sModeDB = GetOpVar("MODE_DATABASE")
  LogInstance("TimerAttach: Called by <"..tostring(anyMessage).."> for ["..tostring(Key).."]")
  if(sModeDB == "SQL") then
    local nNowTM, tTimer = Time(), defTable.Timer -- See that there is a timer and get "now"
    if(not IsExistent(tTimer)) then
      return StatusLog(Spot[Key],"TimerAttach: Missing timer settings") end
    Spot[Key].Used = nNowTM -- Make the first selected deletable to avoid phantom records
    local nLifeTM = tTimer[2]
    if(nLifeTM <= 0) then
      return StatusLog(Spot[Key],"TimerAttach: Timer attachment ignored") end
    local sModeTM, bKillRC, bCollGB = tTimer[1], tTimer[3], tTimer[4]
    LogInstance("TimerAttach: ["..sModeTM.."] ("..tostring(nLifeTM)..") "..tostring(bKillRC)..", "..tostring(bCollGB))
    if(sModeTM == "CQT") then
      for k, v in pairs(Spot) do
        if(IsExistent(v.Used) and ((nNowTM - v.Used) > nLifeTM)) then
          LogInstance("TimerAttach: ("..tostring(RoundValue(nNowTM - v.Used,0.01)).." > "..tostring(nLifeTM)..") > Dead")
          if(bKillRC) then -- Look for others that are gonna meet their doom
            Spot[k] = nil; LogInstance("TimerAttach: Killed <"..tostring(k)..">") end
        end
      end
      if(bCollGB) then
        collectgarbage(); LogInstance("TimerAttach: Garbage collected") end
      return StatusLog(Spot[Key],"TimerAttach: ["..tostring(Key).."] @"..tostring(RoundValue(nNowTM,0.01)))
    elseif(sModeTM == "OBJ") then
      local TimerID = GetOpVar("OPSYM_DIVIDER"):Implode(tKeys)
      LogInstance("TimerAttach: TimID <"..TimerID..">")
      if(timerExists(TimerID)) then return StatusLog(Spot[Key],"TimerAttach: Timer exists") end
      timerCreate(TimerID, nLifeTM, 1, function()
        LogInstance("TimerAttach["..TimerID.."]("..nLifeTM..") > Dead")
        if(bKillRC) then
          Spot[Key] = nil; LogInstance("TimerAttach: Killed <"..Key..">") end
        timerStop(TimerID); timerDestroy(TimerID)
        if(bCollGB) then
          collectgarbage(); LogInstance("TimerAttach: Garbage collected") end
      end); timerStart(TimerID); return Spot[Key]
    else return StatusLog(Spot[Key],"TimerAttach: Timer mode not found <"..sModeTM..">") end
  elseif(sModeDB == "LUA") then
    return StatusLog(Spot[Key],"TimerAttach: Memory manager not available")
  else return StatusLog(nil,"TimerAttach: Wrong database mode") end
end

local function TimerRestart(oArea,tKeys,defTable,anyMessage)
  if(not defTable) then
    return StatusLog(nil,"TimerRestart: Missing table definition") end
  local Spot, Key = NavigateTable(oArea,tKeys)
  if(not (IsExistent(Spot) and IsExistent(Key))) then
    return StatusLog(nil,"TimerRestart: Navigation failed") end
  if(not IsExistent(Spot[Key])) then
    return StatusLog(nil,"TimerRestart: Spot not found") end
  local sModeDB = GetOpVar("MODE_DATABASE")
  if(sModeDB == "SQL") then
    local tTimer = defTable.Timer; if(not IsExistent(tTimer)) then
      return StatusLog(Spot[Key],"TimerRestart: Missing timer settings") end
    Spot[Key].Used = Time() -- Mark the current caching time stamp
    local nLifeTM = tTimer[2]; if(nLifeTM <= 0) then
      return StatusLog(Spot[Key],"TimerRestart: Timer life ignored") end
    local sModeTM = tTimer[1] -- Just for something to do here and to be known that this is mode CQT
    if(sModeTM == "CQT") then sModeTM = "CQT" 
    elseif(sModeTM == "OBJ") then
      local keyTimerID = GetOpVar("OPSYM_DIVIDER"):Implode(tKeys)
      if(not timerExists(keyTimerID)) then
        return StatusLog(nil,"TimerRestart: Timer missing <"..keyTimerID..">") end
      timerStart(keyTimerID)
    else return StatusLog(nil,"TimerRestart: Timer mode not found <"..sModeTM..">") end
  elseif(sModeDB == "LUA") then Spot[Key].Used = Time()
  else return StatusLog(nil,"TimerRestart: Wrong database mode") end
  return Spot[Key]
end

function CacheBoxLayout(oEnt,nRot,nCamX,nCamZ)
  if(not (oEnt and oEnt:IsValid())) then
    return StatusLog(nil,"CacheBoxLayout: Entity invalid <"..tostring(oEnt)..">") end
  local sMod = oEnt:GetModel()
  local oRec = CacheQueryPiece(sMod)
  if(not IsExistent(oRec)) then
    return StatusLog(nil,"CacheBoxLayout: Piece record invalid <"..sMod..">") end
  local Box = oRec.Layout
  if(not IsExistent(Box)) then
    local vMin, vMax
    oRec.Layout = {}; Box = oRec.Layout
    if    (CLIENT) then vMin, vMax = oEnt:GetRenderBounds()
    elseif(SERVER) then vMin, vMax = oEnt:OBBMins(), oEnt:OBBMaxs()
    else return StatusLog(nil,"CacheBoxLayout: Wrong instance") end
    Box.Ang = Angle () -- Layout entity angle
    Box.Cen = Vector() -- Layout entity centre
    Box.Cen:Set(vMax); Box.Cen:Add(vMin); Box.Cen:Mul(0.5)
    Box.Eye = oEnt:LocalToWorld(Box.Cen) -- Layout camera eye
    Box.Len = ((vMax - vMin):Length() / 2) -- Layout border sphere radius
    Box.Cam = Vector(); Box.Cam:Set(Box.Eye)  -- Layout camera position
    AddVectorXYZ(Box.Cam,Box.Len*(tonumber(nCamX) or 0),0,Box.Len*(tonumber(nCamZ) or 0))
    LogInstance("CacheBoxLayout: "..tostring(Box.Cen).." # "..tostring(Box.Len))
  end; Box.Ang[caY] = (tonumber(nRot) or 0) * Time(); return Box
end

--------------------------- PIECE QUERY -----------------------------

function CacheQueryPiece(sModel)
  if(not IsExistent(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model does not exist") end
  if(not IsString(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model {"..type(sModel).."}<"..tostring(sModel).."> not string") end
  if(IsEmptyString(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model empty string") end
  if(not utilIsValidModel(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model invalid <"..sModel..">") end
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not defTable) then
    return StatusLog(nil,"CacheQueryPiece: Table definition missing") end
  local tCache = libCache[defTable.Name] -- Match the model casing
  local sModel = MatchType(defTable,sModel,1,false,"",true,true)
  if(not IsExistent(tCache)) then
    return StatusLog(nil,"CacheQueryPiece: Cache not allocated for <"..defTable.Name..">") end
  local caInd    = GetOpVar("NAV_PIECE")
  if(not IsExistent(caInd[1])) then caInd[1] = defTable.Name end caInd[2] = sModel
  local stPiece  = tCache[sModel]
  if(IsExistent(stPiece) and IsExistent(stPiece.Kept)) then
    if(stPiece.Kept > 0) then
      return TimerRestart(libCache,caInd,defTable,"CacheQueryPiece") end
    return nil
  else
    local sModeDB = GetOpVar("MODE_DATABASE")
    if(sModeDB == "SQL") then
      local qModel = MatchType(defTable,sModel,1,true)
      LogInstance("CacheQueryPiece: Model >> Pool <"..sModel:GetFileFromFilename()..">")
      tCache[sModel] = {}; stPiece = tCache[sModel]; stPiece.Kept = 0
      local Q = SQLCacheStmt("stmtSelectPiece", nil, qModel)
      if(not Q) then
        local sStmt = SQLBuildSelect(defTable,nil,{{1,"%s"}},{4})
        if(not IsExistent(sStmt)) then
          return StatusLog(nil,"CacheQueryPiece: Build statement failed") end
        Q = SQLCacheStmt("stmtSelectPiece", sStmt, qModel)
      end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        return StatusLog(nil,"CacheQueryPiece: SQL exec error <"..sqlLastError()..">") end
      if(not (qData and qData[1])) then
        return StatusLog(nil,"CacheQueryPiece: No data found <"..Q..">") end
      stPiece.Kept = 0; local iCnt = 1 --- Nothing registered yet
      stPiece.Slot = sModel
      stPiece.Type = qData[1][defTable[2][1]]
      stPiece.Name = qData[1][defTable[3][1]]
      stPiece.Unit = qData[1][defTable[8][1]]
      while(qData[iCnt]) do
        local qRec = qData[iCnt]
        if(not IsExistent(RegisterPOA(stPiece,iCnt,
                                      qRec[defTable[5][1]],
                                      qRec[defTable[6][1]],
                                      qRec[defTable[7][1]]))) then
          return StatusLog(nil,"CacheQueryPiece: Cannot process offset #"..tostring(stPiece.Kept).." for <"..sModel..">") end
        stPiece.Kept, iCnt = iCnt, (iCnt + 1)
      end; return TimerAttach(libCache,caInd,defTable,"CacheQueryPiece")
    elseif(sModeDB == "LUA") then return StatusLog(nil,"CacheQueryPiece: Record not located")
    else return StatusLog(nil,"CacheQueryPiece: Wrong database mode <"..sModeDB..">") end
  end
end

function CacheQueryAdditions(sModel)
  if(not IsExistent(sModel)) then
    return StatusLog(nil,"CacheQueryAdditions: Model does not exist") end
  if(not IsString(sModel)) then
    return StatusLog(nil,"CacheQueryAdditions: Model {"..type(sModel).."}<"..tostring(sModel).."> not string") end
  if(IsEmptyString(sModel)) then
    return StatusLog(nil,"CacheQueryAdditions: Model empty string") end
  if(not utilIsValidModel(sModel)) then
    return StatusLog(nil,"CacheQueryAdditions: Model invalid") end
  local defTable = GetOpVar("DEFTABLE_ADDITIONS")
  if(not defTable) then
    return StatusLog(nil,"CacheQueryAdditions: Missing table definition") end
  local tCache = libCache[defTable.Name] -- Match the model casing
  local sModel = MatchType(defTable,sModel,1,false,"",true,true)
  if(not IsExistent(tCache)) then
    return StatusLog(nil,"CacheQueryAdditions: Cache not allocated for <"..defTable.Name..">") end
  local caInd  = GetOpVar("NAV_ADDITION")
  if(not IsExistent(caInd[1])) then caInd[1] = defTable.Name end caInd[2] = sModel
  local stAddition = tCache[sModel]
  if(IsExistent(stAddition) and IsExistent(stAddition.Kept)) then
    if(stAddition.Kept > 0) then
      return TimerRestart(libCache,caInd,defTable,"CacheQueryAdditions") end
    return nil
  else
    local sModeDB = GetOpVar("MODE_DATABASE")
    if(sModeDB == "SQL") then
      local qModel = MatchType(defTable,sModel,1,true)
      LogInstance("CacheQueryAdditions: Model >> Pool <"..sModel:GetFileFromFilename()..">")
      tCache[sModel] = {}; stAddition = tCache[sModel]; stAddition.Kept = 0
      local Q = SQLCacheStmt("stmtSelectAdditions", nil, qModel)
      if(not Q) then
        local sStmt = SQLBuildSelect(defTable,{2,3,4,5,6,7,8,9,10,11,12},{{1,"%s"}},{4})
        if(not IsExistent(sStmt)) then
          return StatusLog(nil,"CacheQueryAdditions: Build statement failed") end
        Q = SQLCacheStmt("stmtSelectAdditions", sStmt, qModel)
      end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        return StatusLog(nil,"CacheQueryAdditions: SQL exec error <"..sqlLastError()..">") end
      if(not (qData and qData[1])) then
        return StatusLog(nil,"CacheQueryAdditions: No data found <"..Q..">") end
      stAddition.Kept = 0; local iCnt = 1
      stAddition.Slot = sModel
      while(qData[iCnt]) do
        local qRec = qData[iCnt]
        stAddition[iCnt] = {}
        for Field, Val in pairs(qRec) do
          stAddition[iCnt][Field] = Val
        end; stAddition.Kept, iCnt = iCnt, (iCnt + 1)
      end
      return TimerAttach(libCache,caInd,defTable,"CacheQueryAdditions")
    elseif(sModeDB == "LUA") then return StatusLog(nil,"CacheQueryAdditions: Record not located")
    else return StatusLog(nil,"CacheQueryAdditions: Wrong database mode <"..sModeDB..">") end
  end
end

----------------------- PANEL QUERY -------------------------------
--[[
 * Caches the date needed to populate the CPanel tree
]]--
function CacheQueryPanel()
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not defTable) then
    return StatusLog(false,"CacheQueryPanel: Missing table definition") end
  if(not IsExistent(libCache[defTable.Name])) then
    return StatusLog(nil,"CacheQueryPanel: Cache not allocated for <"..defTable.Name..">") end
  local caInd  = GetOpVar("NAV_PANEL")
  local keyPan = GetOpVar("HASH_USER_PANEL")
  if(not IsExistent(caInd[1])) then caInd[1] = keyPan end
  local stPanel  = libCache[keyPan]
  if(IsExistent(stPanel) and IsExistent(stPanel.Kept)) then
    LogInstance("CacheQueryPanel: From Pool")
    if(stPanel.Kept > 0) then
      return TimerRestart(libCache,caInd,defTable,"CacheQueryPanel") end
    return nil
  else
    libCache[keyPan] = {}; stPanel = libCache[keyPan]
    local sModeDB = GetOpVar("MODE_DATABASE")
    if(sModeDB == "SQL") then
      local Q = SQLCacheStmt("stmtSelectPanel", nil, 1)
      if(not Q) then
        local sStmt = SQLBuildSelect(defTable,{1,2,3},{{4,"%d"}},{2,3})
        if(not IsExistent(sStmt)) then
          return StatusLog(nil,"CacheQueryPanel: Build statement failed") end
        Q = SQLCacheStmt("stmtSelectPanel", sStmt, 1)
      end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        return StatusLog(nil,"CacheQueryPanel: SQL exec error <"..sqlLastError()..">") end
      if(not (qData and qData[1])) then
        return StatusLog(nil,"CacheQueryPanel: No data found <"..Q..">") end
      stPanel.Kept = 1; local iCnt = 1
      while(qData[iCnt]) do
        stPanel[iCnt] = qData[iCnt]
        stPanel.Kept, iCnt = iCnt, (iCnt + 1)
      end
      return TimerAttach(libCache,caInd,defTable,"CacheQueryPanel")
    elseif(sModeDB == "LUA") then
      local tCache  = libCache[defTable.Name]
      local tSorted = Sort(tCache,nil,{"Type","Name"})
      if(not tSorted) then
        return StatusLog(nil,"CacheQueryPanel: Cannot sort cache data") end
      stPanel.Kept = 0; local iCnt = 1
      while(tSorted[iCnt]) do
        local vSort = tSorted[iCnt]
        stPanel[iCnt] = {
          [defTable[1][1]] = vSort.Key,
          [defTable[2][1]] = tCache[vSort.Key].Type,
          [defTable[3][1]] = tCache[vSort.Key].Name
        }; stPanel.Kept, iCnt = iCnt, (iCnt + 1)
      end
      return stPanel
    else return StatusLog(nil,"CacheQueryPanel: Wrong database mode <"..sModeDB..">") end
    LogInstance("CacheQueryPanel: To Pool")
  end
end

--[[
 * Used to Populate the CPanel Phys Materials
 * If type is chosen, it gets the names for the type
 * If type is not chosen, it gets a list of all types
]]--
function CacheQueryProperty(sType)
  local defTable = GetOpVar("DEFTABLE_PHYSPROPERTIES")
  if(not defTable) then
    return StatusLog(nil,"CacheQueryProperty: Missing table definition") end
  local tCache = libCache[defTable.Name]
  if(not tCache) then
    return StatusLog(nil,"CacheQueryProperty["..tostring(sType).."]: Cache not allocated for <"..defTable.Name..">") end
  local sModeDB = GetOpVar("MODE_DATABASE")
  if(IsString(sType) and not IsEmptyString(sType)) then
    local sType   = MatchType(defTable,sType,1,false,"",true,true)
    local keyName = GetOpVar("HASH_PROPERTY_NAMES")
    local arNames = tCache[keyName]
    local caInd   = GetOpVar("NAV_PROPERTY_NAMES")
    if(not IsExistent(caInd[1])) then
      caInd[1] = defTable.Name; caInd[2] = keyName end caInd[3] = sType
    if(not IsExistent(arNames)) then
      tCache[keyName] = {}; arNames = tCache[keyName] end
    local stName = arNames[sType]
    if(IsExistent(stName) and IsExistent(stName.Kept)) then
      LogInstance("CacheQueryProperty["..sType.."]: Names << Pool")
      if(stName.Kept > 0) then
        return TimerRestart(libCache,caInd,defTable,"CacheQueryProperty") end
      return nil
    else
      if(sModeDB == "SQL") then
        local qType = MatchType(defTable,sType,1,true)
        arNames[sType] = {}; stName = arNames[sType]; stName.Kept = 0
        local Q = SQLCacheStmt("stmtSelectPropertyNames", nil, qType)
        if(not Q) then
          local sStmt = SQLBuildSelect(defTable,{3},{{1,"%s"}},{2})
          if(not IsExistent(sStmt)) then
            return StatusLog(nil,"CacheQueryProperty["..sType.."]: Build statement failed") end
          Q = SQLCacheStmt("stmtSelectPropertyNames", sStmt, qType)
        end
        local qData = sqlQuery(Q)
        if(not qData and IsBool(qData)) then
          return StatusLog(nil,"CacheQueryProperty: SQL exec error <"..sqlLastError()..">") end
        if(not (qData and qData[1])) then
          return StatusLog(nil,"CacheQueryProperty["..sType.."]: No data found <"..Q..">") end
        stName.Kept, stName.Slot = 0, sType; local iCnt = 1
        while(qData[iCnt]) do
          stName[iCnt] = qData[iCnt][defTable[3][1]]
          stName.Kept, iCnt = iCnt, (iCnt + 1)
        end; LogInstance("CacheQueryProperty["..sType.."]: Names >> Pool")
        return TimerAttach(libCache,caInd,defTable,"CacheQueryProperty")
      elseif(sModeDB == "LUA") then return StatusLog(nil,"CacheQueryProperty["..sType.."]: Record not located")
      else return StatusLog(nil,"CacheQueryProperty["..sType.."]: Wrong database mode <"..sModeDB..">") end
    end
  else
    local keyType = GetOpVar("HASH_PROPERTY_TYPES")
    local stType  = tCache[keyType]
    local caInd   = GetOpVar("NAV_PROPERTY_TYPES")
    if(not IsExistent(caInd[1])) then caInd[1] = defTable.Name; caInd[2] = keyType end
    if(IsExistent(stType) and IsExistent(stType.Kept)) then
      LogInstance("CacheQueryProperty: Types << Pool")
      if(stType.Kept > 0) then
        return TimerRestart(libCache,caInd,defTable,"CacheQueryProperty") end
      return nil
    else
      if(sModeDB == "SQL") then
        tCache[keyType] = {}; stType = tCache[keyType]; stType.Kept = 0
        local Q = SQLCacheStmt("stmtSelectPropertyTypes", nil, 1)
        if(not Q) then
          local sStmt = SQLBuildSelect(defTable,{1},{{2,"%d"}},{1})
          if(not IsExistent(sStmt)) then
            return StatusLog(nil,"CacheQueryProperty: Build statement failed") end
          Q = SQLCacheStmt("stmtSelectPropertyTypes", sStmt, 1)
        end
        local qData = sqlQuery(Q)
        if(not qData and IsBool(qData)) then
          return StatusLog(nil,"CacheQueryProperty: SQL exec error <"..sqlLastError()..">") end
        if(not (qData and qData[1])) then
          return StatusLog(nil,"CacheQueryProperty: No data found <"..Q..">") end
        stType.Kept = 0; local iCnt = 1
        while(qData[iCnt]) do
          stType[iCnt] = qData[iCnt][defTable[1][1]]
          stType.Kept, iCnt = iCnt, (iCnt + 1)
        end
        LogInstance("CacheQueryProperty: Types >> Pool")
        return TimerAttach(libCache,caInd,defTable,"CacheQueryProperty")
      elseif(sModeDB == "LUA") then return StatusLog(nil,"CacheQueryProperty: Record not located")
      else return StatusLog(nil,"CacheQueryProperty: Wrong database mode <"..sModeDB..">") end
    end
  end
end

---------------------- EXPORT --------------------------------

local function StripValue(vVal)
  local sVal = tostring(vVal or ""):Trim()
  if(sVal:sub( 1, 1) == "\"") then sVal = sVal:sub(2,-1) end
  if(sVal:sub(-1,-1) == "\"") then sVal = sVal:sub(1,-2) end
  return sVal:Trim()
end

local function GetColumns(defTable, sDelim)
  if(not IsExistent(sDelim)) then return "" end
  local sDelim  = tostring(sDelim or "\t"):sub(1,1)
  local sResult = ""
  if(IsEmptyString(sDelim)) then
    return StatusLog("","GetColumns: Invalid delimiter for <"..defTable.Name..">") end
  local iCount  = 1
  local namField
  while(defTable[iCount]) do
    namField = defTable[iCount][1]
    if(not IsString(namField)) then
      return StatusLog("","GetColumns: Field #"..iCount
               .." {"..type(namField).."}<"..tostring(namField).."> not string") end
    sResult = sResult..namField
    if(defTable[iCount + 1]) then sResult = sResult..sDelim end
    iCount = iCount + 1
  end
  return sResult
end

--[[
 * Save/Load the DB Using Excel or
 * anything that supports delimiter separated digital tables
 * sTable > Definition KEY to export
 * tData  > The local data table to be exported ( if given )
 * sPref  > Prefix used on exporting ( if not uses instance prefix)
]]--
function ExportCategory(vEq, tData, sPref)
  if(SERVER) then return StatusLog(true, "ExportCategory: Working on server") end
  local nEq   = tonumber(vEq) or 0; if(nEq <= 0) then
    return StatusLog(false, "ExportCategory: Wrong equality <"..tostring(vEq)..">") end
  local sPref = tostring(sPref or GetInstPref())
  local fName = GetOpVar("DIRPATH_BAS")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..sPref..GetOpVar("TOOLNAME_PU").."CATEGORY.txt"
  local F = fileOpen(fName, "wb", "DATA")
  if(not F) then return StatusLog(false,"ExportCategory("..sPref.."): fileOpen("..fName..") failed from") end
  local sEq, nLen, sMod = ("="):rep(nEq), (nEq+2), GetOpVar("MODE_DATABASE")
  local tCat = (type(tData) == "table") and tData or GetOpVar("TABLE_CATEGORIES")
  F:Write("# ExportCategory( "..tostring(nEq).." )("..sPref.."): "..GetDate().." [ "..sMod.." ]".."\n")
  for cat, rec in pairs(tCat) do
    if(IsString(rec.Txt)) then
      local exp = "["..sEq.."["..cat..sEq..rec.Txt:Trim().."]"..sEq.."]"
      if(not rec.Txt:find("\n")) then F:Flush(); F:Close()
        return StatusLog(false, "ExportCategory("..sPref.."): Category one-liner <"..cat..">") end
      F:Write(exp.."\n")
    else F:Flush(); F:Close(); StatusLog(false, "ExportCategory("..sPref.."): Category <"..cat.."> code <"..tostring(rec.Txt).."> invalid from") end
  end; F:Flush(); F:Close(); return StatusLog(true, "ExportCategory("..sPref.."): Success")
end

function ImportCategory(vEq, sPref)
  if(SERVER) then return StatusLog(true, "ImportCategory: Working on server") end
  local nEq = tonumber(vEq) or 0; if(nEq <= 0) then
    return StatusLog(false,"ImportCategory: Wrong equality <"..tostring(vEq)..">") end
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..tostring(sPref or GetInstPref())
        fName = fName..GetOpVar("TOOLNAME_PU").."CATEGORY.txt"
  local F = fileOpen(fName, "rb", "DATA")
  if(not F) then return StatusLog(false,"ImportCategory: fileOpen("..fName..") failed") end
  local sEq, sLine, nLen = ("="):rep(nEq), "", (nEq+2)
  local cFr, cBk = "["..sEq.."[", "]"..sEq.."]"
  local tCat, symOff = GetOpVar("TABLE_CATEGORIES"), GetOpVar("OPSYM_DISABLE")
  local sPar, isPar, isEOF = "", false, false
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if(not IsEmptyString(sLine)) then
      local sFr, sBk = sLine:sub(1,nLen), sLine:sub(-nLen,-1)
      if(sFr == cFr and sBk == cBk) then
        sLine, isPar, sPar = sLine:sub(nLen+1,-1), true, "" end
      if(sFr == cFr and not isPar) then
        sPar, isPar = sLine:sub(nLen+1,-1).."\n", true
      elseif(sBk == cBk and isPar) then
        sPar, isPar = sPar..sLine:sub(1,-nLen-1), false
        local tBoo = sEq:Explode(sPar)
        local key, txt = tBoo[1]:Trim(), tBoo[2]
        if(not IsEmptyString(key)) then
          if(txt:find("function")) then
            if(key:sub(1,1) ~= symOff) then
              tCat[key] = {}; tCat[key].Txt = txt:Trim()
              tCat[key].Cmp = CompileString("return ("..tCat[key].Txt..")",key)
              local suc, out = pcall(tCat[key].Cmp)
              if(suc) then tCat[key].Cmp = out else
                tCat[key].Cmp = StatusLog(nil, "ImportCategory: Compilation fail <"..key..">") end
            else LogInstance("ImportCategory: Key skipped <"..key..">") end
          else LogInstance("ImportCategory: Function missing <"..key..">") end
        else LogInstance("ImportCategory: Name missing <"..txt..">") end
      else sPar = sPar..sLine.."\n" end
    end
  end; F:Close(); return StatusLog(true, "ImportCategory: Success")
end

--[[
 * This function removes DSV associated with a given prefix
 * sTable > Extremal table database to export
 * sPref  > Prefix used on exporting ( if any ) else instance is used
]]--
function RemoveDSV(sTable, sPref)
  local sPref = tostring(sPref or GetInstPref())
  if(not IsString(sTable)) then
    return StatusLog(false,"RemoveDSV("
      ..sPref.."): Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"RemoveDSV("..sPref
      .."): Missing table definition for <"..sTable..">") end
  local fName = GetOpVar("DIRPATH_BAS")
        fName = fName..GetOpVar("DIRPATH_DSV")
        fName = fName..sPref..defTable.Name..".txt"
  if(not fileExists(fName,"DATA")) then
    return StatusLog(true,"RemoveDSV("..sPref.."): File <"..fName.."> missing") end
  fileDelete(fName); return StatusLog(true,"RemoveDSV("..sPref.."): Success")
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
    return StatusLog(false,"StoreExternalDatabase: Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ExportDSV: Missing table definition for <"..sTable..">") end
  local fName, sPref = GetOpVar("DIRPATH_BAS"), tostring(sPref or GetInstPref())
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..sPref..defTable.Name..".txt"
  local F = fileOpen(fName, "wb", "DATA" )
  if(not F) then
    return StatusLog(false,"ExportDSV("..sPref
      .."): fileOpen("..fName..") failed") end
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local sModeDB, symOff = GetOpVar("MODE_DATABASE"), GetOpVar("OPSYM_DISABLE")
  F:Write("# ExportDSV: "..GetDate().." [ "..sModeDB.." ]".."\n")
  F:Write("# Data settings:\t"..GetColumns(defTable,sDelim).."\n")
  if(sModeDB == "SQL") then local Q = ""
    if    (sTable == "PIECES"        ) then Q = SQLBuildSelect(defTable,nil,nil,{2,3,1,4})
    elseif(sTable == "ADDITIONS"     ) then Q = SQLBuildSelect(defTable,nil,nil,{1,4})
    elseif(sTable == "PHYSPROPERTIES") then Q = SQLBuildSelect(defTable,nil,nil,{1,2})
    else                                    Q = SQLBuildSelect(defTable,nil,nil,nil) end
    if(not IsExistent(Q)) then F:Flush(); F:Close()
      return StatusLog(false,"ExportDSV("..sPref.."): Build statement failed") end
    F:Write("# Query ran: <"..Q..">\n")
    local qData = sqlQuery(Q)
    if(not qData and IsBool(qData)) then F:Flush(); F:Close()
      return StatusLog(nil,"ExportDSV: SQL exec error <"..sqlLastError()..">") end
    if(not (qData and qData[1])) then F:Flush(); F:Close()
      return StatusLog(false,"ExportDSV: No data found <"..Q..">") end
    local sData, sTab = "", defTable.Name
    for iCnt = 1, #qData do
      local qRec  = qData[iCnt]; sData = sTab
      for iInd = 1, defTable.Size do
        local sHash = defTable[iInd][1]
        sData = sData..sDelim..MatchType(defTable,qRec[sHash],iInd,true,"\"",true)
      end; F:Write(sData.."\n"); sData = ""
    end -- Matching will not crash as it is matched during insertion
  elseif(sModeDB == "LUA") then
    local tCache = libCache[defTable.Name]
    if(not IsExistent(tCache)) then F:Flush(); F:Close()
      return StatusLog(false,"ExportDSV("..sPref
              .."): Table <"..defTable.Name.."> cache not allocated") end
    if(sTable == "PIECES") then
      local tData = {}
      for sModel, tRecord in pairs(tCache) do
        local sSort   = (tRecord.Type..tRecord.Name..sModel)
        tData[sModel] = {[defTable[1][1]] = sSort}
      end
      local tSorted = Sort(tData,nil,{defTable[1][1]})
      if(not tSorted) then F:Flush(); F:Close()
        return StatusLog(false,"ExportDSV("..sPref.."): Cannot sort cache data") end
      for iIdx = 1, #tSorted do
        local stRec = tSorted[iIdx]
        local tData = tCache[stRec.Key]
        local sData = defTable.Name
              sData = sData..sDelim..MatchType(defTable,stRec.Key,1,true,"\"")..sDelim..
                       MatchType(defTable,tData.Type,2,true,"\"")..sDelim..
                       MatchType(defTable,((ModelToName(stRec.Key) == tData.Name) and symOff or tData.Name),3,true,"\"")
        local tOffs = tData.Offs
        -- Matching crashes only for numbers. The number is already inserted, so there will be no crash
        for iInd = 1, #tOffs do
          local stPnt = tData.Offs[iInd]
          F:Write(sData..sDelim..MatchType(defTable,iInd,4,true,"\"")..sDelim..
                   "\""..(IsEqualPOA(stPnt.P,stPnt.O) and "" or StringPOA(stPnt.P,"V")).."\""..sDelim..
                   "\""..  StringPOA(stPnt.O,"V").."\""..sDelim..
                   "\""..( IsZeroPOA(stPnt.A,"A") and "" or StringPOA(stPnt.A,"A")).."\""..sDelim..
                   "\""..(tData.Unit and tostring(tData.Unit or "") or "").."\"\n")
        end
      end
    elseif(sTable == "ADDITIONS") then
     for mod, rec in pairs(tCache) do
        local sData = defTable.Name..sDelim..mod
        for iIdx = 1, #rec do
          local tData = rec[iIdx]; F:Write(sData)
          for iID = 2, defTable.Size do
            local vData = tData[defTable[iID][1]]
            F:Write(sDelim..MatchType(defTable,tData[defTable[iID][1]],iID,true,"\""))
          end; F:Write("\n") -- Data is already inserted, there will be no crash
        end
      end
    elseif(sTable == "PHYSPROPERTIES") then
      local tTypes = tCache[GetOpVar("HASH_PROPERTY_TYPES")]
      local tNames = tCache[GetOpVar("HASH_PROPERTY_NAMES")]
      if(not (tTypes or tNames)) then F:Flush(); F:Close()
        return StatusLog(false,"ExportDSV("..sPref.."): No data found") end
      for iInd = 1, tTypes.Kept do
        local sType = tTypes[iInd]
        local tType = tNames[sType]
        if(not tType) then F:Flush(); F:Close()
          return StatusLog(false,"ExportDSV("..sPref
            .."): Missing index #"..iInd.." on type <"..sType..">") end
        for iCnt = 1, tType.Kept do
          F:Write(defTable.Name..sDelim..MatchType(defTable,sType      ,1,true,"\"")..
                                 sDelim..MatchType(defTable,iCnt       ,2,true,"\"")..
                                 sDelim..MatchType(defTable,tType[iCnt],3,true,"\"").."\n")
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
  local fPref = tostring(sPref or GetInstPref())
  if(not IsString(sTable)) then
    return StatusLog(false,"ImportDSV("..fPref.."): Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ImportDSV("..fPref.."): Missing table definition for <"..sTable..">") end
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..fPref..defTable.Name..".txt"
  local F = fileOpen(fName, "rb", "DATA")
  if(not F) then return StatusLog(false,"ImportDSV("..fPref.."): fileOpen("..fName..") failed") end
  local symOff, sDelim = GetOpVar("OPSYM_DISABLE"), tostring(sDelim or "\t"):sub(1,1)
  local sLine, isEOF, nLen = "", false, defTable.Name:len()
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if((not IsEmptyString(sLine)) and (sLine:sub(1,1) ~= symOff)) then
      if(sLine:sub(1,nLen) == defTable.Name) then
        local tData = sDelim:Explode(sLine:sub(nLen+2,-1))
        for iCnt = 1, defTable.Size do
          tData[iCnt] = StripValue(tData[iCnt]) end
        if(bComm) then InsertRecord(sTable, tData) end
      end
    end
  end; F:Close(); return StatusLog(true, "ImportDSV("..fPref.."@"..sTable.."): Success")
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
  local fPref = tostring(sPref or GetInstPref())
  if(not IsString(sTable)) then
    return StatusLog(false,"SynchronizeDSV("..fPref.."): Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"SynchronizeDSV("..fPref.."): Missing table definition for <"..sTable..">") end
  local fName, sDelim = GetOpVar("DIRPATH_BAS"), tostring(sDelim or "\t"):sub(1,1)
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..fPref..defTable.Name..".txt"
  local I, fData, smOff = fileOpen(fName, "rb", "DATA"), {}, GetOpVar("OPSYM_DISABLE")
  if(I) then local sLine, isEOF = "", false
    while(not isEOF) do sLine, isEOF = GetStringFile(I)
      if((not IsEmptyString(sLine)) and (sLine:sub(1,1) ~= smOff)) then
        local tLine = sDelim:Explode(sLine)
        if(tLine[1] == defTable.Name) then
          for i = 1, #tLine do tLine[i] = StripValue(tLine[i]) end
          local sKey = tLine[2]
          if(not fData[sKey]) then fData[sKey] = {Kept = 0} end
            tKey = fData[sKey]
          local nID, vID = 0 -- Where the lime ID must be read from
          if    (sTable == "PIECES") then vID = tLine[5]; nID = tonumber(vID) or 0
          elseif(sTable == "ADDITIONS") then vID = tLine[5]; nID = tonumber(vID) or 0
          elseif(sTable == "PHYSPROPERTIES") then vID = tLine[3]; nID = tonumber(vID) or 0 end
          if((tKey.Kept < 0) or (nID <= tKey.Kept) or ((nID - tKey.Kept) ~= 1)) then
            I:Close(); return StatusLog(false,"SynchronizeDSV("..fPref.."): Read point ID #"..
              tostring(vID).." desynchronized <"..sKey.."> of <"..sTable..">") end
          tKey.Kept = nID; tKey[tKey.Kept] = {}
          local kKey, nCnt = tKey[tKey.Kept], 3
          while(tLine[nCnt]) do -- Do a value matching without quotes
            local vMatch = MatchType(defTable,tLine[nCnt],nCnt-1)
            if(not IsExistent(vMatch)) then
              I:Close(); return StatusLog(false,"SynchronizeDSV("..fPref.."): Read matching failed <"
                ..tostring(tLine[nCnt]).."> to <"..tostring(nCnt-1).." # "
                  ..defTable[nCnt-1][1].."> of <"..sTable..">")
            end; kKey[nCnt-2] = vMatch; nCnt = nCnt + 1
          end
        else I:Close()
          return StatusLog(false,"SynchronizeDSV("..fPref.."): Read table name mismatch <"..sTable..">") end
      end
    end; I:Close()
  else LogInstance("SynchronizeDSV("..fPref.."): Creating file <"..fName..">") end
  for key, rec in pairs(tData) do -- Check the given table
    for pnID = 1, #rec do
      local tRec = rec[pnID]
      local nID, vID = 0 -- Where the line ID must be read from
      if(sTable == "PIECES") then
        vID = tRec[3]; nID = tonumber(vID) or 0
        if(pnID ~= nID) then
          return StatusLog(false,"SynchronizeDSV("..fPref.."): Given point ID #"..
            tostring(vID).." desynchronized <"..key.."> of "..sTable) end
        if(not fileExists(key, "GAME")) then
          LogInstance("SynchronizeDSV("..fPref.."): Missing piece <"..key..">") end
      elseif(sTable == "ADDITIONS") then vID = tRec[3]; nID = tonumber(vID) or 0
      elseif(sTable == "PHYSPROPERTIES") then vID = tRec[1]; nID = tonumber(vID) or 0 end
      for nCnt = 1, #tRec do -- Do a value matching without quotes
        local vMatch = MatchType(defTable,tRec[nCnt],nCnt+1)
        if(not IsExistent(vMatch)) then
          return StatusLog(false,"SynchronizeDSV("..fPref.."): Given matching failed <"
            ..tostring(tRec[nCnt]).."> to <"..tostring(nCnt+1).." # "
              ..defTable[nCnt+1][1].."> of "..sTable)
        end
      end
    end -- Register the read line to the output file
    if(bRepl) then
      if(tData[key]) then -- Update the file with the new data
        fData[key] = rec
        fData[key].Kept = #rec
      end
    else --[[ Do not modify fData ]] end
  end
  local tSort = Sort(tableGetKeys(fData))
  if(not tSort) then
    return StatusLog(false,"SynchronizeDSV("..fPref.."): Sorting failed") end
  local O = fileOpen(fName, "wb" ,"DATA")
  if(not O) then return StatusLog(false,"SynchronizeDSV("..fPref.."): Write fileOpen("..fName..") failed") end
  O:Write("# SynchronizeDSV("..fPref.."): "..GetDate().." ["..GetOpVar("MODE_DATABASE").."]\n")
  O:Write("# Data settings:\t"..GetColumns(defTable,sDelim).."\n")
  for rcID = 1, #tSort do
    local key = tSort[rcID].Val
    local rec = fData[key]
    local sCash, sData = defTable.Name..sDelim..key, ""
    for pnID = 1, rec.Kept do
      local tItem = rec[pnID]
      for nCnt = 1, #tItem do
        local vMatch = MatchType(defTable,tItem[nCnt],nCnt+1,true,"\"",true)
        if(not IsExistent(vMatch)) then
          O:Flush(); O:Close()
          return StatusLog(false,"SynchronizeDSV("..fPref.."): Write matching failed <"
            ..tostring(tItem[nCnt]).."> to <"..tostring(nCnt+1).." # "..defTable[nCnt+1][1].."> of "..sTable)
        end; sData = sData..sDelim..tostring(vMatch)
      end; O:Write(sCash..sData.."\n"); sData = ""
    end
  end O:Flush(); O:Close()
  return StatusLog(true,"SynchronizeDSV("..fPref.."): Success")
end

function TranslateDSV(sTable, sPref, sDelim)
  local fPref  = tostring(sPref or GetInstPref())
  if(not IsString(sTable)) then
    return StatusLog(false,"TranslateDSV("..fPref.."): Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"TranslateDSV("..fPref.."): Missing table definition for <"..sTable..">") end
  local sNdsv, sNins = GetOpVar("DIRPATH_BAS"), GetOpVar("DIRPATH_BAS")
  if(not fileExists(sNins,"DATA")) then fileCreateDir(sNins) end
  sNdsv, sNins = sNdsv..GetOpVar("DIRPATH_DSV"), sNins..GetOpVar("DIRPATH_INS")
  if(not fileExists(sNins,"DATA")) then fileCreateDir(sNins) end
  sNdsv, sNins = sNdsv..fPref..defTable.Name..".txt", sNins..fPref..defTable.Name..".txt"
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local D = fileOpen(sNdsv, "rb", "DATA")
  if(not D) then return StatusLog(false,"TranslateDSV("..fPref.."): fileOpen("..sNdsv..") failed") end
  local I = fileOpen(sNins, "wb", "DATA")
  if(not I) then return StatusLog(false,"TranslateDSV("..fPref.."): fileOpen("..sNins..") failed") end
  I:Write("# TranslateDSV("..fPref.."@"..sTable.."): "..GetDate().." ["..GetOpVar("MODE_DATABASE").."]\n")
  I:Write("# Data settings:\t"..GetColumns(defTable, sDelim).."\n")
  local pfLib = GetOpVar("NAME_LIBRARY"):gsub(GetOpVar("NAME_INIT"),"")
  local sLine, isEOF, symOff = "", false, GetOpVar("OPSYM_DISABLE")
  local sFr, sBk, sHs = pfLib..".InsertRecord(\""..sTable.."\", {", "})\n", (fPref.."@"..sTable)
  while(not isEOF) do sLine, isEOF = GetStringFile(D)
    if((not IsEmptyString(sLine)) and (sLine:sub(1,1) ~= symOff)) then
      sLine = sLine:gsub(defTable.Name,""):Trim()
      local tBoo, sCat = sDelim:Explode(sLine), ""
      for nCnt = 1, #tBoo do
        local vMatch = MatchType(defTable,StripValue(tBoo[nCnt]),nCnt,true,"\"",true)
        if(not IsExistent(vMatch)) then D:Close(); I:Flush(); I:Close()
          return StatusLog(false,"TranslateDSV("..sHs.."): Given matching failed <"
            ..tostring(tBoo[nCnt]).."> to <"..tostring(nCnt).." # "
              ..defTable[nCnt][1].."> of "..sTable) end
        sCat = sCat..", "..tostring(vMatch)
      end; I:Write(sFr..sCat:sub(3,-1)..sBk)
    end
  end; D:Close(); I:Flush(); I:Close()
  return StatusLog(true,"TranslateDSV("..sHs.."): Success")
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
    return StatusLog(true,"RegisterDSV: Single client") end
  local sPref = tostring(sPref or GetInstPref())
  if(IsEmptyString(sPref)) then
    return StatusLog(false,"RegisterDSV("..sPref.."): Prefix empty") end
  local sBas = GetOpVar("DIRPATH_BAS")
  if(not fileExists(sBas,"DATA")) then fileCreateDir(sBas) end
  local lbNam = GetOpVar("NAME_LIBRARY")
  local fName = (sBas..lbNam.."_dsv.txt")
  local sMiss, sDelim = GetOpVar("MISS_NOAV"), tostring(sDelim or "\t"):sub(1,1)
  if(bSkip) then
    local symOff = GetOpVar("OPSYM_DISABLE")
    local fPool, isEOF, isAct = {}, false, true
    local F, sLine = fileOpen(fName, "rb" ,"DATA"), ""
    if(not F) then return StatusLog(false,"RegisterDSV("
      ..sPref.."): fileOpen("..fName..") read failed") end
    while(not isEOF) do sLine, isEOF = GetStringFile(F)
      if(not IsEmptyString(sLine)) then
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
        LogInstance("RegisterDSV("..sPref.."): "..(tab[2] and "On " or "Off").." <"..tab[1]..">") end
      return StatusLog(true,"RegisterDSV("..sPref.."): Skip <"..sProg..">")
    end
  end; local F = fileOpen(fName, "ab" ,"DATA")
  if(not F) then return StatusLog(false,"RegisterDSV("
    ..sPref.."): fileOpen("..fName..") append failed") end
  F:Write(sPref..sDelim..tostring(sProg or sMiss).."\n"); F:Flush(); F:Close()
  return StatusLog(true,"RegisterDSV("..sPref.."): Register")
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
  if(not F) then return StatusLog(false,"ProcessDSV: fileOpen("..fName..") failed") end
  local sLine, isEOF, symOff = "", false, GetOpVar("OPSYM_DISABLE")
  local sNt, tProc = GetOpVar("TOOLNAME_PU"), {}
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local sDv = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if(not IsEmptyString(sLine)) then
      if(sLine:sub(1,1) ~= symOff) then
        local tInf = sDelim:Explode(sLine)
        local fPrf = StripValue(tostring(tInf[1] or ""):Trim())
        local fSrc = StripValue(tostring(tInf[2] or ""):Trim())
        if(not IsEmptyString(fPrf)) then -- Is there something
          if(not tProc[fPrf]) then
            tProc[fPrf] = {Cnt = 1, [1] = {Prog = fSrc, File = (sDv..fPrf..sNt)}}
          else -- Prefix is processed already
            local tStore = tProc[fPrf]
            tStore.Cnt = tStore.Cnt + 1 -- Store the count of the repeated prefixes
            tStore[tStore.Cnt] = {Prog = fSrc, File = (sDv..fPrf..sNt)}
          end -- What user puts there is a problem of his own
        end -- If the line is disabled/comment
      else LogInstance("ProcessDSV: Skipped <"..sLine..">") end
    end
  end; F:Close()
  for prf, tab in pairs(tProc) do
    if(tab.Cnt > 1) then
      PrintInstance("ProcessDSV: Prefix <"..prf.."> clones #"..tostring(tab.Cnt).." @"..fName)
      for i = 1, tab.Cnt do
        PrintInstance("ProcessDSV: Prefix <"..prf.."> "..tab[i].Prog)
      end
    else local dir = tab[tab.Cnt].File
      if(CLIENT) then
        if(fileExists(dir.."CATEGORY.txt", "DATA")) then
          if(not ImportCategory(3, prf)) then
            LogInstance("ProcessDSV("..prf.."): Failed CATEGORY") end
        end
      end
      if(fileExists(dir.."PIECES.txt", "DATA")) then
        if(not ImportDSV("PIECES", true, prf)) then
          LogInstance("ProcessDSV("..prf.."): Failed PIECES") end
      end
      if(fileExists(dir.."ADDITIONS.txt", "DATA")) then
        if(not ImportDSV("ADDITIONS", true, prf)) then
          LogInstance("ProcessDSV("..prf.."): Failed ADDITIONS") end
      end
      if(fileExists(dir.."PHYSPROPERTIES.txt", "DATA")) then
        if(not ImportDSV("PHYSPROPERTIES", true, prf)) then
          LogInstance("ProcessDSV("..prf.."): Failed PHYSPROPERTIES") end
      end
    end
  end; return StatusLog(true,"ProcessDSV: Success")
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
    return StatusLog(aAng,"GetNormalAngle: No player <"..tostring(oPly)..">", aAng) end
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
 * shdModel      = Client Model
 * ivhdPointID   = Client Point ID
 * ucsPos(X,Y,Z) = Offset position
 * ucsAng(P,Y,R) = Offset angle
]]--
function GetNormalSpawn(oPly,ucsPos,ucsAng,shdModel,ivhdPointID,ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
  local hdRec = CacheQueryPiece(shdModel)
  if(not IsExistent(hdRec)) then
    return StatusLog(nil,"GetNormalSpawn: No record located for <"..shdModel..">") end
  local ihdPointID = tonumber(ivhdPointID)
  if(not IsExistent(ihdPointID)) then
    return StatusLog(nil,"GetNormalSpawn: Index NAN {"..type(ivhdPointID).."}<"..tostring(ivhdPointID)..">") end
  local hdPOA = LocatePOA(hdRec,ihdPointID)
  if(not IsExistent(hdPOA)) then
    return StatusLog(nil,"GetNormalSpawn: Holder point ID invalid #"..tostring(ihdPointID)) end
  local stSpawn = CacheSpawnPly(oPly); stSpawn.HRec = hdRec
  if(ucsPos) then SetVector(stSpawn.OPos,ucsPos) end
  if(ucsAng) then SetAngle (stSpawn.OAng,ucsAng) end
  -- Initialize F, R, U Copy the UCS like that to support database POA
  SetAnglePYR (stSpawn.ANxt, (tonumber(ucsAngP) or 0), (tonumber(ucsAngY) or 0), (tonumber(ucsAngR) or 0))
  SetVectorXYZ(stSpawn.PNxt, (tonumber(ucsPosX) or 0), (tonumber(ucsPosY) or 0), (tonumber(ucsPosZ) or 0))
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  stSpawn.OAng:RotateAroundAxis(stSpawn.R, stSpawn.ANxt[caP])
  stSpawn.OAng:RotateAroundAxis(stSpawn.U,-stSpawn.ANxt[caY])
  stSpawn.F:Set(stSpawn.OAng:Forward())
  stSpawn.OAng:RotateAroundAxis(stSpawn.F, stSpawn.ANxt[caR])
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  -- Get Holder model data
  SetVector(stSpawn.HPnt,hdPOA.P)
  SetVector(stSpawn.HPos,hdPOA.O); NegVector(stSpawn.HPos) -- Origin to Position
  if(hdPOA.A[csD]) then SetAnglePYR(stSpawn.HAng) else SetAngle(stSpawn.HAng,hdPOA.A) end
  -- Calculate spawn relation
  stSpawn.HAng:RotateAroundAxis(stSpawn.HAng:Up(),180)
  DecomposeByAngle(stSpawn.HPos,stSpawn.HAng)
  -- Spawn Position
  stSpawn.SPos:Set(stSpawn.OPos)
  stSpawn.SPos:Add((hdPOA.O[csA] * stSpawn.HPos[cvX] + stSpawn.PNxt[cvX]) * stSpawn.F)
  stSpawn.SPos:Add((hdPOA.O[csB] * stSpawn.HPos[cvY] + stSpawn.PNxt[cvY]) * stSpawn.R)
  stSpawn.SPos:Add((hdPOA.O[csC] * stSpawn.HPos[cvZ] + stSpawn.PNxt[cvZ]) * stSpawn.U)
  -- Spawn Angle
  stSpawn.SAng:Set(stSpawn.OAng); NegAngle(stSpawn.HAng)
  stSpawn.SAng:RotateAroundAxis(stSpawn.U,stSpawn.HAng[caY] * hdPOA.A[csB])
  stSpawn.SAng:RotateAroundAxis(stSpawn.R,stSpawn.HAng[caP] * hdPOA.A[csA])
  stSpawn.SAng:RotateAroundAxis(stSpawn.F,stSpawn.HAng[caR] * hdPOA.A[csC])
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
 * ivhdPointID   = Active point ID selected via Right click ...
 * nvActRadius   = Minimal radius to get an active point from the client
 * ucsPos(X,Y,Z) = Offset position
 * ucsAng(P,Y,R) = Offset angle
]]--
function GetEntitySpawn(oPly,trEnt,trHitPos,shdModel,ivhdPointID,
                        nvActRadius,enFlatten,enIgnTyp,ucsPosX,
                        ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
  if(not (trEnt and trHitPos and shdModel and ivhdPointID and nvActRadius)) then
    return StatusLog(nil,"GetEntitySpawn: Mismatched input parameters") end
  if(not trEnt:IsValid()) then
    return StatusLog(nil,"GetEntitySpawn: Trace entity not valid") end
  if(IsOther(trEnt)) then
    return StatusLog(nil,"GetEntitySpawn: Trace is of other type") end
  local ihdPointID = tonumber(ivhdPointID)
  if(not IsExistent(ihdPointID)) then
    return StatusLog(nil,"GetEntitySpawn: Holder PointID NAN {"..type(ivhdPointID).."}<"..tostring(ivhdPointID)..">") end
  local nActRadius = tonumber(nvActRadius)
  if(not IsExistent(nActRadius)) then
    return StatusLog(nil,"GetEntitySpawn: Active radius NAN {"..type(nvActRadius).."}<"..tostring(nvActRadius)..">") end
  local trRec = CacheQueryPiece(trEnt:GetModel())
  if(not IsExistent(trRec)) then
    return StatusLog(nil,"GetEntitySpawn: Trace model missing <"..trEnt:GetModel()..">") end
  if(not IsExistent(LocatePOA(trRec,1))) then
    return StatusLog(nil,"GetEntitySpawn: Trace has no points") end
  local hdRec  = CacheQueryPiece(shdModel)
  if(not IsExistent(hdRec)) then
    return StatusLog(nil,"GetEntitySpawn: Holder model missing <"..tostring(shdModel)..">") end
  local hdOffs = LocatePOA(hdRec,ihdPointID)
  if(not IsExistent(hdOffs)) then
    return StatusLog(nil,"GetEntitySpawn: Holder point invalid #"..tostring(ihdPointID)) end
  -- If there is no Type field exit immediately
  if(not (IsExistent(trRec.Type) and IsString(trRec.Type))) then
    return StatusLog(nil,"GetEntitySpawn: Trace type invalid <"..tostring(trRec.Type)..">") end
  if(not (IsExistent(hdRec.Type) and IsString(hdRec.Type))) then
    return StatusLog(nil,"GetEntitySpawn: Holder type invalid <"..tostring(hdRec.Type)..">") end
  -- If the types are different and disabled
  if((not enIgnTyp) and (trRec.Type ~= hdRec.Type)) then
    return StatusLog(nil,"GetEntitySpawn: Types different <"..tostring(trRec.Type)..","..tostring(hdRec.Type)..">") end
  -- We have the next Piece Offset
  local stSpawn, trPOA = CacheSpawnPly(oPly)
        stSpawn.TRec = trRec
        stSpawn.RLen = nActRadius
        stSpawn.HID  = ihdPointID
        stSpawn.TID  = 0
        stSpawn.TPos:Set(trEnt:GetPos())
        stSpawn.TAng:Set(trEnt:GetAngles())
  for ID = 1, trRec.Kept do
    -- Indexing is actually with 70% faster using this method than pairs
    local stPOA = LocatePOA(trRec,ID)
    if(not IsExistent(stPOA)) then
      return StatusLog(nil,"GetEntitySpawn: Trace point count mismatch on #"..tostring(ID)) end
    if(not stPOA.P[csD]) then -- Skip the disabled P
      local vTmp = Vector(); SetVector(vTmp, stPOA.P)
      MulVectorXYZ(vTmp, stPOA.P[csA], stPOA.P[csB], stPOA.P[csC])
      vTmp:Rotate(stSpawn.TAng); vTmp:Add(stSpawn.TPos); vTmp:Sub(trHitPos)
      local trAcDis = vTmp:Length()
      if(trAcDis < stSpawn.RLen) then
        trPOA, stSpawn.TID, stSpawn.RLen = stPOA, ID, trAcDis
        stSpawn.TPnt:Set(vTmp); stSpawn.TPnt:Add(trHitPos)
      end
    end
  end
  if(not IsExistent(trPOA)) then
    return StatusLog(nil,"GetEntitySpawn: Not hitting active point") end
  -- Found the active point ID on trEnt. Initialize origins
  SetVector(stSpawn.OPos,trPOA.O) -- Use {0,0,0} for disabled A (Angle)
  if(trPOA.A[csD]) then SetAnglePYR(stSpawn.OAng) else SetAngle(stSpawn.OAng,trPOA.A) end
  stSpawn.OPos:Rotate(stSpawn.TAng); stSpawn.OPos:Add(stSpawn.TPos)
  stSpawn.OAng:Set(trEnt:LocalToWorldAngles(stSpawn.OAng))
  -- Do the flatten flag right now Its important !
  if(enFlatten) then stSpawn.OAng[caP] = 0; stSpawn.OAng[caR] = 0 end
  return GetNormalSpawn(oPly,nil,nil,shdModel,ihdPointID,ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
end

--[[
 * This function performs a trace relative to the entity point chosen
 * trEnt     --> Entity chosen for the trace
 * ivPointID --> Point ID selected for its model
 * nLen      --> Length of the trace
]]--
function GetTraceEntityPoint(trEnt, ivPointID, nLen)
  if(not (trEnt and trEnt:IsValid())) then
    return StatusLog(nil,"GetTraceEntityPoint: Trace entity invalid") end
  local nLen = (tonumber(nLen) or 0); if(nLen <= 0) then
    return StatusLog(nil,"GetTraceEntityPoint: Distance skipped") end
  local trRec = CacheQueryPiece(trEnt:GetModel())
  if(not trRec) then return StatusLog(nil,"GetTraceEntityPoint: Trace not piece") end
  local trPOA = LocatePOA(trRec, ivPointID)
  if(not IsExistent(trPOA)) then
    return StatusLog(nil,"GetTraceEntityPoint: Point <"..tostring(ivPointID).."> invalid") end
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
    return StatusLog(nil,"GetEntityHitID: Entity invalid") end
  local oRec = CacheQueryPiece(oEnt:GetModel())
  if(not oRec) then return StatusLog(nil,"GetEntityHitID: Trace not piece <"..oEnt:GetModel()..">") end
  local ePos, eAng = oEnt:GetPos(), oEnt:GetAngles()
  local vTmp, nID, nMin, oPOA = Vector(), nil, nil, nil
  for ID = 1, oRec.Kept do -- Ignore the point disabled flag
    local tPOA, tID = LocatePOA(oRec, ID)
    if(not IsExistent(tPOA)) then -- Get intersection rays list for the player
      return StatusLog(nil,"GetEntityHitID: Point <"..tostring(ID).."> invalid") end
    SetVector(vTmp, tPOA.P) -- Translate point to a world-space
    MulVectorXYZ(vTmp, tPOA.P[csA], tPOA.P[csB], tPOA.P[csC])
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
    return StatusLog(nil,"IntersectRay: First ray undefined") end
  local d2 = vD2:GetNormalized(); if(d2:Length() == 0) then
    return StatusLog(nil,"IntersectRay: Second ray undefined") end
  local dx, oo = d1:Cross(d2), (vO2 - vO1)
  local dn = (dx:Length())^2; if(dn < GetOpVar("EPSILON_ZERO")) then
    return StatusLog(nil,"IntersectRay: Rays parallel") end
  local f1 = DeterminantVector(oo, d2, dx) / dn
  local f2 = DeterminantVector(oo, d1, dx) / dn
  local x1, x2 = (vO1 + f1 * d1), (vO2 + f2 * d2)
  local xx = (x2 - x1); xx:Mul(0.5); xx:Add(x1)
  return f1, f2, x1, x2, xx
end

local function IntersectRayParallel(vO1, vD1, vO2, vD2)
  local d1 = vD1:GetNormalized(); if(d1:Length() == 0) then
    return StatusLog(nil,"IntersectRayParallel: First ray undefined") end
  local d2 = vD2:GetNormalized(); if(d2:Length() == 0) then
    return StatusLog(nil,"IntersectRayParallel: Second ray undefined") end
  local len = (vO2 - vO1):Length()
  local f1, f2 = (len / 2), (len / 2)
  local x1, x2 = (vO1 + f1 * d1), (vO2 + f2 * d2)
  local xx = (x2 - x1); xx:Mul(0.5); xx:Add(x1)
  return f1, f2, x1, x2, xx
end

local function IntersectRayUpdate(stRay)
  if(not IsExistent(stRay)) then
    return StatusLog(nil,"IntersectRayUpdate: Ray invalid") end
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
    return StatusLog(nil,"IntersectRayCreate: Key invalid <"..tostring(sKey)..">") end
  if(not IsPlayer(oPly)) then
    return StatusLog(nil,"IntersectRayCreate: Player invalid <"..tostring(oPly)..">") end
  local trID, trMin, trPOA, trRec = GetEntityHitID(oEnt, vHit)
  if(not trID) then
    return StatusLog(nil,"IntersectRayCreate: Entity no hit <"..tostring(oEnt).."/"..tostring(vHit)..">") end
  local tRay = GetOpVar("RAY_INTERSECT")
  if(not tRay[oPly]) then tRay[oPly] = {} end; tRay = tRay[oPly]
  local stRay = tRay[sKey]
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
    return StatusLog(nil,"IntersectRayRead: Player invalid <"..tostring(oPly)..">") end
  if(not IsString(sKey)) then
    return StatusLog(nil,"IntersectRayRead: Key invalid <"..tostring(sKey)..">") end
  local tRay = GetOpVar("RAY_INTERSECT")[oPly]; if(not tRay) then
    return StatusLog(nil,"IntersectRayRead: No player <"..tostring(oPly)..">") end
  local stRay = tRay[sKey]; if(not stRay) then
    return StatusLog(nil,"IntersectRayRead: No Key <"..sKey..">") end
  return IntersectRayUpdate(stRay) -- Obtain personal ray from the cache
end

function IntersectRayClear(oPly, sKey)
  if(not IsPlayer(oPly)) then
    return StatusLog(false,"IntersectRayClear: Player invalid <"..tostring(oPly)..">") end
  local tRay = GetOpVar("RAY_INTERSECT")[oPly]
  if(not tRay) then return StatusLog(true,"IntersectRayClear: Clean") end
  if(sKey) then
    if(not IsString(sKey)) then
      return StatusLog(false,"IntersectRayClear: Key invalid <"..type(sKey).."/"..tostring(sKey)..">") end
    tRay[sKey] = nil; collectgarbage()
  else GetOpVar("RAY_INTERSECT")[oPly] = nil; collectgarbage() end
  return StatusLog(true,"IntersectRayClear: Clear {"..tostring(sKey).."}<"..tostring(oPly)..">")
end

--[[
 * This function intersects two already cashed rays
 * Used for generating
 * sKey1 --> First ray identifier
 * sKey2 --> Second ray identifier
]]--
function IntersectRayHash(oPly, sKey1, sKey2)
  local stRay1 = IntersectRayRead(oPly, sKey1)
  if(not stRay1) then return StatusLog(nil,"IntersectRayHash: No read <"..tostring(sKey1)..">") end
  local stRay2 = IntersectRayRead(oPly, sKey2)
  if(not stRay2) then return StatusLog(nil,"IntersectRayHash: No read <"..tostring(sKey2)..">") end
  local f1, f2, x1, x2, xx = IntersectRay(stRay1.Orw, stRay1.Diw:Forward(), stRay2.Orw, stRay2.Diw:Forward())
  if(not xx) then
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
  local mRec = CacheQueryPiece(sModel)
  if(not mRec) then return StatusLog(nil,"IntersectRayModel: Not piece <"..tostring(sModel)..">") end
  local stPOA1 = LocatePOA(mRec, nPntID)
  if(not stPOA1) then return StatusLog(nil,"IntersectRayModel: No start ID <"..tostring(nPntID)..">") end
  local stPOA2 = LocatePOA(mRec, nNxtID)
  if(not stPOA2) then return StatusLog(nil,"IntersectRayModel: No end ID <"..tostring(nNxtID)..">") end
  local aTmp = Angle()
  SetAngle(aTmp, stPOA1.A)
  local vO1, vD1 = Vector(), Vector(); SetVector(vO1, stPOA1.O); vD1:Set(-aTmp:Forward())
  SetAngle(aTmp, stPOA2.A)
  local vO2, vD2 = Vector(), Vector(); SetVector(vO2, stPOA2.O); vD2:Set(-aTmp:Forward())
  local f1, f2, x1, x2, xx = IntersectRay(vO1,vD1,vO2,vD2)
  -- Attempts taking the mean vector when the rays are parallel for straight tracks
  if(not xx) then
    f1, f2, x1, x2, xx = IntersectRayParallel(vO1,vD1,vO2,vD2) end
  return xx, vO1, vO2
end

function AttachAdditions(ePiece)
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"AttachAdditions: Piece invalid") end
  local aAngLoc = ePiece:GetAngles()
  local vPosLoc = ePiece:GetPos()
  local sModLoc = ePiece:GetModel()
  local stAddition = CacheQueryAdditions(sModLoc)
  if(not IsExistent(stAddition)) then
    return StatusLog(true,"AttachAdditions: Model <"..sModLoc.."> has no additions") end
  LogInstance("AttachAdditions: Called for model <"..sModLoc..">")
  local Cnt, defTable = 1, GetOpVar("DEFTABLE_ADDITIONS")
  while(stAddition[Cnt]) do
    local arRec = stAddition[Cnt]
    LogInstance("\n\nEnt [ "..arRec[defTable[4][1]].." ] INFO : ")
    local eAddition = entsCreate(arRec[defTable[3][1]])
    if(eAddition and eAddition:IsValid()) then
      LogInstance("Addition Class: "..arRec[defTable[3][1]])
      local AdModel = tostring(arRec[defTable[2][1]])
      if(not fileExists(AdModel, "GAME")) then
        return StatusLog(false,"AttachAdditions: Missing attachment file "..AdModel) end
      if(not utilIsValidModel(AdModel)) then
        return StatusLog(false,"AttachAdditions: Invalid attachment model "..AdModel) end
      eAddition:SetModel(AdModel) LogInstance("Addition:SetModel("..AdModel..")")
      local OffPos = arRec[defTable[5][1]]
      if(not IsString(OffPos)) then
        return StatusLog(false,"AttachAdditions: Position {"..type(OffPos).."}<"..tostring(OffPos).."> not string") end
      if(OffPos and OffPos ~= "" and OffPos ~= "NULL") then
        local vAddPos, arConv = Vector(), DecodePOA(OffPos)
        arConv[1] = arConv[1] * arConv[4]
        arConv[2] = arConv[2] * arConv[5]
        arConv[3] = arConv[3] * arConv[6]
        vAddPos:Set(vPosLoc)
        vAddPos:Add(arConv[1] * aAngLoc:Forward())
        vAddPos:Add(arConv[2] * aAngLoc:Right())
        vAddPos:Add(arConv[3] * aAngLoc:Up())
        eAddition:SetPos(vAddPos); LogInstance("Addition:SetPos(Param)")
      else eAddition:SetPos(vPosLoc); LogInstance("Addition:SetPos(Local)") end
      local OffAng = arRec[defTable[6][1]]
      if(not IsString(OffAng)) then
        return StatusLog(false,"AttachAdditions: Angle {"..type(OffAng).."}<"..tostring(OffAng).."> not string") end
      if(OffAng and OffAng ~= "" and OffAng ~= "NULL") then
        local aAddAng, arConv = Angle(), DecodePOA(OffAng)
        aAddAng[caP] = arConv[1] * arConv[4] + aAngLoc[caP]
        aAddAng[caY] = arConv[2] * arConv[5] + aAngLoc[caY]
        aAddAng[caR] = arConv[3] * arConv[6] + aAngLoc[caR]
        eAddition:SetAngles(aAddAng); LogInstance("Addition:SetAngles(Param)")
      else eAddition:SetAngles(aAngLoc); LogInstance("Addition:SetAngles(Local)") end
      local MoveType = (tonumber(arRec[defTable[7][1]]) or -1)
      if(MoveType >= 0) then eAddition:SetMoveType(MoveType)
        LogInstance("Addition:SetMoveType("..MoveType..")") end
      local PhysInit = (tonumber(arRec[defTable[8][1]]) or -1)
      if(PhysInit >= 0) then eAddition:PhysicsInit(PhysInit)
        LogInstance("Addition:PhysicsInit("..PhysInit..")") end
      local DrShadow = (tonumber(arRec[defTable[9][1]]) or 0)
      if(DrShadow ~= 0) then DrShadow = (DrShadow > 0)
        eAddition:DrawShadow(DrShadow); LogInstance("Addition:DrawShadow("..tostring(DrShadow)..")") end
      eAddition:SetParent(ePiece); LogInstance("Addition:SetParent(ePiece)")
      eAddition:Spawn(); LogInstance("Addition:Spawn()")
      phAddition = eAddition:GetPhysicsObject()
      if(phAddition and phAddition:IsValid()) then
        local EnMotion = (tonumber(arRec[defTable[10][1]]) or 0)
        if(EnMotion ~= 0) then EnMotion = (EnMotion > 0); phAddition:EnableMotion(EnMotion)
          LogInstance("phAddition:EnableMotion("..tostring(EnMotion)..")") end
        local EnSleep = (tonumber(arRec[defTable[11][1]]) or 0)
        if(EnSleep > 0) then phAddition:Sleep(); LogInstance("phAddition:Sleep()") end
      end
      eAddition:Activate(); LogInstance("Addition:Activate()")
      ePiece:DeleteOnRemove(eAddition); LogInstance("ePiece:DeleteOnRemove(Addition)")
      local Solid = (tonumber(arRec[defTable[12][1]]) or -1)
      if(Solid >= 0) then eAddition:SetSolid(Solid)
        LogInstance("Addition:SetSolid("..tostring(Solid)..")") end
    else
      return StatusLog(false,"Failed to allocate Addition #"..Cnt.." memory:"
          .."\n     Modelbse: "..stAddition[Cnt][defTable[1][1]]
          .."\n     Addition: "..stAddition[Cnt][defTable[2][1]]
          .."\n     ENTclass: "..stAddition[Cnt][defTable[3][1]])
    end; Cnt = Cnt + 1
  end; return StatusLog(true,"AttachAdditions: Success")
end

local function GetEntityOrTrace(oEnt)
  if(oEnt and oEnt:IsValid()) then return oEnt end
  local oPly = LocalPlayer()
  if(not IsPlayer(oPly)) then
    return StatusLog(nil,"GetEntityOrTrace: Player <"..type(oPly)"> missing") end
  local stTrace = CacheTracePly(oPly)
  if(not IsExistent(stTrace)) then
    return StatusLog(nil,"GetEntityOrTrace: Trace missing") end
  if(not stTrace.Hit) then -- Boolean
    return StatusLog(nil,"GetEntityOrTrace: Trace not hit") end
  if(stTrace.HitWorld) then -- Boolean
    return StatusLog(nil,"GetEntityOrTrace: Trace hit world") end
  local trEnt = stTrace.Entity
  if(not (trEnt and trEnt:IsValid())) then
    return StatusLog(nil,"GetEntityOrTrace: Trace entity invalid") end
  return StatusLog(trEnt,"GetEntityOrTrace: Success "..tostring(trEnt))
end

function GetPropSkin(oEnt)
  local skEnt = GetEntityOrTrace(oEnt)
  if(not IsExistent(skEnt)) then
    return StatusLog("","GetPropSkin: Failed to gather entity") end
  if(IsOther(skEnt)) then
    return StatusLog("","GetPropSkin: Entity other type") end
  local Skin = tonumber(skEnt:GetSkin())
  if(not IsExistent(Skin)) then return StatusLog("","GetPropSkin: Skin number mismatch") end
  return StatusLog(tostring(Skin),"GetPropSkin: Success "..tostring(skEn))
end

function GetPropBodyGroup(oEnt)
  local bgEnt = GetEntityOrTrace(oEnt)
  if(not IsExistent(bgEnt)) then
    return StatusLog("","GetPropBodyGrp: Failed to gather entity") end
  if(IsOther(bgEnt)) then
    return StatusLog("","GetPropBodyGrp: Entity other type") end
  local BGs = bgEnt:GetBodyGroups()
  if(not (BGs and BGs[1])) then
    return StatusLog("","GetPropBodyGrp: Bodygroup table empty") end
  local sRez, iCnt = "", 1
  local symSep = GetOpVar("OPSYM_SEPARATOR")
  while(BGs[iCnt]) do
    sRez = sRez..symSep..tostring(bgEnt:GetBodygroup(BGs[iCnt].id) or 0)
    iCnt = iCnt + 1
  end; sRez = sRez:sub(2,-1)
  Print(BGs,"GetPropBodyGrp: BGs")
  return StatusLog(sRez,"GetPropBodyGrp: Success <"..sRez..">")
end

function AttachBodyGroups(ePiece,sBgrpIDs)
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"AttachBodyGroups: Base entity invalid") end
  local sBgrpIDs = tostring(sBgrpIDs or "")
  LogInstance("AttachBodyGroups: <"..sBgrpIDs..">")
  local iCnt = 1
  local BGs = ePiece:GetBodyGroups()
  local IDs = GetOpVar("OPSYM_SEPARATOR"):Explode(sBgrpIDs)
  while(BGs[iCnt] and IDs[iCnt]) do
    local itrBG = BGs[iCnt]
    local maxID = (ePiece:GetBodygroupCount(itrBG.id) - 1)
    local itrID = mathClamp(mathFloor(tonumber(IDs[iCnt]) or 0),0,maxID)
    LogInstance("ePiece:SetBodygroup("..tostring(itrBG.id)..","..tostring(itrID)..") ["..tostring(maxID).."]")
    ePiece:SetBodygroup(itrBG.id,itrID)
    iCnt = iCnt + 1
  end; return StatusLog(true,"AttachBodyGroups: Success")
end

function SetPosBound(ePiece,vPos,oPly,sMode)
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"SetPosBound: Entity invalid") end
  if(not IsExistent(vPos)) then
    return StatusLog(false,"SetPosBound: Position missing") end
  if(not IsPlayer(oPly)) then
    return StatusLog(false,"SetPosBound: Player <"..tostring(oPly)"> invalid") end
  local sMode = tostring(sMode or "LOG") -- Error mode is "LOG" by default
  if(sMode == "OFF") then
    ePiece:SetPos(vPos)
    return StatusLog(true,"SetPosBound("..sMode..") Tuned off")
  end
  if(utilIsInWorld(vPos)) then ePiece:SetPos(vPos) else
    ePiece:Remove()
    if(sMode == "HINT" or sMode == "GENERIC" or sMode == "ERROR") then
      PrintNotifyPly(oPly,"Position out of map bounds!",sMode) end
    return StatusLog(false,"SetPosBound("..sMode.."): Position ["..tostring(vPos).."] out of map bounds")
  end; return StatusLog(true,"SetPosBound("..sMode.."): Success")
end

function MakePiece(pPly,sModel,vPos,aAng,nMass,sBgSkIDs,clColor,sMode)
  if(CLIENT) then return StatusLog(nil,"MakePiece: Working on client") end
  if(not IsPlayer(pPly)) then -- If not player we cannot register limit
    return StatusLog(nil,"MakePiece: Player missing <"..tostring(pPly)..">") end
  local sLimit = GetOpVar("CVAR_LIMITNAME") -- Get limit name
  if(not pPly:CheckLimit(sLimit)) then -- Check internal limit
    return StatusLog(nil,"MakePiece: Track limit reached") end
  if(not pPly:CheckLimit("props")) then -- Check the props limit
    return StatusLog(nil,"MakePiece: Prop limit reached") end
  local stPiece = CacheQueryPiece(sModel)
  if(not IsExistent(stPiece)) then -- Not present in the database
    return StatusLog(nil,"MakePiece: Record missing for <"..sModel..">") end
  local bcUnit = (IsString(stPiece.Unit) and
    (stPiece.Unit ~= "NULL") and not IsEmptyString(stPiece.Unit))
  LogInstance("MakePiece: Unit("..tostring(bcUnit)..") <"..tostring(stPiece.Unit or "")..">")
  local ePiece = bcUnit and entsCreate(stPiece.Unit) or entsCreate("prop_physics")
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(nil,"MakePiece: Piece <"..tostring(ePiece).."> invalid") end
  ePiece:SetCollisionGroup(COLLISION_GROUP_NONE)
  ePiece:SetSolid(SOLID_VPHYSICS)
  ePiece:SetMoveType(MOVETYPE_VPHYSICS)
  ePiece:SetNotSolid(false)
  ePiece:SetModel(sModel)
  if(not SetPosBound(ePiece,vPos or GetOpVar("VEC_ZERO"),pPly,sMode)) then
    return StatusLog(nil,"MakePiece: "..pPly:Nick().." spawned <"..sModel.."> outside bounds") end
  ePiece:SetAngles(aAng or GetOpVar("ANG_ZERO"))
  ePiece:Spawn()
  ePiece:Activate()
  ePiece:SetRenderMode(RENDERMODE_TRANSALPHA)
  ePiece:SetColor(clColor or Color(255,255,255,255))
  ePiece:DrawShadow(false)
  ePiece:PhysWake()
  local phPiece = ePiece:GetPhysicsObject()
  if(not (phPiece and phPiece:IsValid())) then ePiece:Remove()
    return StatusLog(nil,"MakePiece: Entity phys object invalid") end
  phPiece:EnableMotion(false); ePiece.owner = pPly -- Some SPPs actually use this value
  local Mass = (tonumber(nMass) or 1); phPiece:SetMass((Mass >= 1) and Mass or 1)
  local BgSk = GetOpVar("OPSYM_DIRECTORY"):Explode(sBgSkIDs or "")
  ePiece:SetSkin(mathClamp(tonumber(BgSk[2]) or 0,0,ePiece:SkinCount()-1))
  if(not AttachBodyGroups(ePiece,BgSk[1] or "")) then ePiece:Remove()
    return StatusLog(nil,"MakePiece: Failed to attach bodygroups") end
  if(not AttachAdditions(ePiece)) then ePiece:Remove()
    return StatusLog(nil,"MakePiece: Failed to attach additions") end
  pPly:AddCount(sLimit , ePiece); pPly:AddCleanup(sLimit , ePiece) -- This sets the ownership
  pPly:AddCount("props", ePiece); pPly:AddCleanup("props", ePiece) -- To be deleted with clearing props
  return StatusLog(ePiece,"MakePiece: "..tostring(ePiece)..sModel)
end

function ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
  if(CLIENT) then return StatusLog(true,"ApplyPhysicalSettings: Working on client") end
  local bPi, bFr = (tobool(bPi) or false), (tobool(bFr) or false)
  local bGr, sPh = (tobool(bGr) or false),  tostring(sPh or "")
  LogInstance("ApplyPhysicalSettings: {"..tostring(bPi)..","..tostring(bFr)..","..tostring(bGr)..","..sPh.."}")
  if(not (ePiece and ePiece:IsValid())) then   -- Cannot manipulate invalid entities
    return StatusLog(false,"ApplyPhysicalSettings: Piece entity invalid <"..tostring(ePiece)..">") end
  local pyPiece = ePiece:GetPhysicsObject()    -- Get the physics object
  if(not (pyPiece and pyPiece:IsValid())) then -- Cannot manipulate invalid physics
    return StatusLog(false,"ApplyPhysicalSettings: Piece physical object invalid <"..tostring(ePiece)..">") end
  local arSettings = {bPi,bFr,bGr,sPh}  -- Initialize dupe settings using this array
  ePiece.PhysgunDisabled = bPi          -- If enabled stop the player from grabbing the track piece
  ePiece:SetUnFreezable(bPi)            -- If enabled stop the player from hitting reload to mess it all up
  ePiece:SetMoveType(MOVETYPE_VPHYSICS) -- Moves and behaves like a normal prop
  -- Delay the freeze by a tiny amount because on physgun snap the piece
  -- is unfrozen automatically after physgun drop hook call
  timerSimple(GetOpVar("DELAY_FREEZE"), function() -- If frozen motion is disabled
    LogInstance("ApplyPhysicalSettings: Freeze");  -- Make sure that the physics are valid
    if(pyPiece and pyPiece:IsValid()) then pyPiece:EnableMotion(not bFr) end end )
  constructSetPhysProp(nil,ePiece,0,pyPiece,{GravityToggle = bGr, Material = sPh})
  duplicatorStoreEntityModifier(ePiece,GetOpVar("TOOLNAME_PL").."dupe_phys_set",arSettings)
  return StatusLog(true,"ApplyPhysicalSettings: Success")
end

function ApplyPhysicalAnchor(ePiece,eBase,bWe,bNc,nFm)
  if(CLIENT) then return StatusLog(true,"ApplyPhysicalAnchor: Working on client") end
  local bWe, bNc, nFm = (tobool(bWe) or false), (tobool(bNc) or false), (tonumber(nFm) or 0)
  LogInstance("ApplyPhysicalAnchor: {"..tostring(bWe)..","..tostring(bNc)..","..tostring(nFm).."}")
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"ApplyPhysicalAnchor: Piece <"..tostring(ePiece).."> not valid") end
  if(not (eBase and eBase:IsValid())) then
    return StatusLog(true,"ApplyPhysicalAnchor: Base <"..tostring(eBase).."> constraint ignored") end
  if(bNc) then -- NoCollide should be made separately
    local cnN = constraintNoCollide(ePiece, eBase, 0, 0)
    if(cnN and cnN:IsValid()) then
      ePiece:DeleteOnRemove(cnN); eBase:DeleteOnRemove(cnN)
    else LogInstance("ApplyPhysicalAnchor: NoCollide ignored") end
  end
  if(bWe) then -- Weld using force limit given here V
    local cnW = constraintWeld(ePiece, eBase, 0, 0, nFm, false, false)
    if(cnW and cnW:IsValid()) then
      ePiece:DeleteOnRemove(cnW); eBase:DeleteOnRemove(cnW)
    else LogInstance("ApplyPhysicalAnchor: Weld ignored "..tostring(cnW)) end
  end; return StatusLog(true,"ApplyPhysicalAnchor: Success")
end

function MakeAsmVar(sName, sValue, tBord, nFlag, sInfo)
  if(not IsString(sName)) then
    return StatusLog(nil,"MakeAsmVar: CVar name {"..type(sName).."}<"..tostring(sName).."> not string") end
  if(not IsExistent(sValue)) then
    return StatusLog(nil,"MakeAsmVar: Wrong default value <"..tostring(sValue)..">") end
  if(not IsString(sInfo)) then
    return StatusLog(nil,"MakeAsmVar: CVar info {"..type(sInfo).."}<"..tostring(sInfo).."> not string") end
  local sLow = sName:lower()
  if(tBord and (type(tBord) == "table")) then
    local mIn, mAx = tostring(tBord[1]), tostring(tBord[2])
    LogInstance("MakeAsmVar: Border ("..sLow..")<"..mIn.."/"..mAx..">")
    local tBorder = GetOpVar("TABLE_BORDERS"); tBorder["cvar_"..sLow] = tBord
  end; return CreateConVar(GetOpVar("TOOLNAME_PL")..sLow, sValue, nFlag, sInfo)
end

function GetAsmVar(sName, sMode)
  if(not IsString(sName)) then
    return StatusLog(nil,"GetAsmVar: CVar name {"..type(sName).."}<"..tostring(sName).."> not string") end
  if(not IsString(sMode)) then
    return StatusLog(nil,"GetAsmVar: CVar mode {"..type(sMode).."}<"..tostring(sMode).."> not string") end
  local sLow = sName:lower()
  local CVar = GetConVar(GetOpVar("TOOLNAME_PL")..sLow)
  if(not IsExistent(CVar)) then
    return StatusLog(nil,"GetAsmVar("..sName..", "..sMode.."): Missing CVar object") end
  if    (sMode == "INT") then return (tonumber(BorderValue(CVar:GetInt()  ,"cvar_"..sLow)) or 0)
  elseif(sMode == "FLT") then return (tonumber(BorderValue(CVar:GetFloat(),"cvar_"..sLow)) or 0)
  elseif(sMode == "STR") then return  tostring(CVar:GetString() or "")
  elseif(sMode == "BUL") then return (CVar:GetBool() or false)
  elseif(sMode == "DEF") then return  CVar:GetDefault()
  elseif(sMode == "INF") then return  CVar:GetHelpText()
  elseif(sMode == "NAM") then return  CVar:GetName()
  elseif(sMode == "OBJ") then return  CVar
  end; return StatusLog(nil,"GetAsmVar("..sName..", "..sMode.."): Missed mode")
end

function SetAsmVarCallback(sName, sType, sHash, fHand)
  if(not (sName and IsString(sName))) then
    return StatusLog(nil,"GetActionData: Key {"..type(sName).."}<"..tostring(sName).."> not string") end
  if(not (sType and IsString(sType))) then
    return StatusLog(nil,"GetActionData: Key {"..type(sType).."}<"..tostring(sType).."> not string") end
  if(IsString(sHash)) then local sLong = GetAsmVar(sName, "NAM")
    cvarsRemoveChangeCallback(sLong, sLong.."_call")
    cvarsAddChangeCallback(sLong, function(sVar, vOld, vNew)
      local aVal, bS = GetAsmVar(sName, sType), true
      if(type(fHand) == "function") then bS, aVal = pcall(fHand, aVal)
        if(not bS) then return StatusLog(nil,"GetActionData: "..tostring(aVal)) end
        LogInstance("SetAsmVarCallback("..sName.."): Converted")
      end; LogInstance("SetAsmVarCallback("..sName.."): <"..tostring(aVal)..">")
      SetOpVar(sHash, aVal) -- Make sure we write down the processed value in the hashes
    end, sLong.."_call")
  end
end

function SetLocalify(sCode, sPhrase, sDetail)
  if(not IsString(sCode)) then
    return StatusLog(nil,"SetLocalify: Language code <"..tostring(sCode).."> invalid") end
  if(not IsString(sPhrase)) then
    return StatusLog(nil,"SetLocalify: Phrase words <"..tostring(sPhrase).."> invalid") end
  local tPool = GetOpVar("LOCALIFY_TABLE")
  if(not IsExistent(tPool[sCode])) then tPool[sCode] = {}; end
  tPool[sCode][sPhrase] = tostring(sDetail)
end

function InitLocalify(sCode) -- https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
  local tPool = GetOpVar("LOCALIFY_TABLE") -- ( Column "ISO 639-1" )
  local auCod = GetOpVar("LOCALIFY_AUTO")
  local suCod = tostring(sCode or "") -- English is used when missing
  local auLng, suLng = tPool[auCod], tPool[suCod]
  if(not IsExistent(suLng)) then
    LogInstance("InitLocalify: Missing code <"..suCod..">")
    suCod, suLng = auCod, auLng
  end; LogInstance("InitLocalify: Using code <"..auCod..">")
  for phrase, default in pairs(auLng) do
    local abrev = suLng[phrase] or default
    languageAdd(phrase, abrev)
  end
end
