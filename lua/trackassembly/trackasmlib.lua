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

local next                           = next
local type                           = type
local pcall                          = pcall
local Angle                          = Angle
local Color                          = Color
local pairs                          = pairs
local print                          = print
local tobool                         = tobool
local Vector                         = Vector
local Matrix                         = Matrix
local unpack                         = unpack
local include                        = include
local IsValid                        = IsValid
local Material                       = Material
local require                        = require
local Time                           = CurTime
local tonumber                       = tonumber
local tostring                       = tostring
local GetConVar                      = GetConVar
local LocalPlayer                    = LocalPlayer
local CreateConVar                   = CreateConVar
local RunConsoleCommand              = RunConsoleCommand
local SetClipboardText               = SetClipboardText
local CompileString                  = CompileString
local CompileFile                    = CompileFile
local getmetatable                   = getmetatable
local setmetatable                   = setmetatable
local collectgarbage                 = collectgarbage
local osClock                        = os and os.clock
local osDate                         = os and os.date
local bitBand                        = bit and bit.band
local sqlQuery                       = sql and sql.Query
local sqlLastError                   = sql and sql.LastError
local sqlTableExists                 = sql and sql.TableExists
local gameSinglePlayer               = game and game.SinglePlayer
local gameGetWorld                   = game and game.GetWorld
local utilTraceLine                  = util and util.TraceLine
local utilIsInWorld                  = util and util.IsInWorld
local utilIsValidModel               = util and util.IsValidModel
local utilGetPlayerTrace             = util and util.GetPlayerTrace
local entsCreate                     = ents and ents.Create
local entsCreateClientProp           = ents and ents.CreateClientProp
local fileOpen                       = file and file.Open
local fileExists                     = file and file.Exists
local fileAppend                     = file and file.Append
local fileDelete                     = file and file.Delete
local fileCreateDir                  = file and file.CreateDir
local mathPi                         = math and math.pi
local mathAbs                        = math and math.abs
local mathSin                        = math and math.sin
local mathCos                        = math and math.cos
local mathCeil                       = math and math.ceil
local mathModf                       = math and math.modf
local mathSqrt                       = math and math.sqrt
local mathFloor                      = math and math.floor
local mathClamp                      = math and math.Clamp
local mathAtan2                      = math and math.atan2
local mathRound                      = math and math.Round
local mathRandom                     = math and math.random
local mathNormalizeAngle             = math and math.NormalizeAngle
local vguiCreate                     = vgui and vgui.Create
local undoCreate                     = undo and undo.Create
local undoFinish                     = undo and undo.Finish
local undoAddEntity                  = undo and undo.AddEntity
local undoSetPlayer                  = undo and undo.SetPlayer
local undoSetCustomUndoText          = undo and undo.SetCustomUndoText
local inputIsKeyDown                 = input and input.IsKeyDown
local timerStop                      = timer and timer.Stop
local timerStart                     = timer and timer.Start
local timerSimple                    = timer and timer.Simple
local timerExists                    = timer and timer.Exists
local timerCreate                    = timer and timer.Create
local timerRemove                    = timer and timer.Remove
local tableEmpty                     = table and table.Empty
local tableMaxn                      = table and table.maxn
local tableGetKeys                   = table and table.GetKeys
local tableInsert                    = table and table.insert
local tableCopy                      = table and table.Copy
local tableConcat                    = table and table.concat
local tableRemove                    = table and table.remove
local debugGetinfo                   = debug and debug.getinfo
local debugTrace                     = debug and debug.Trace
local renderDrawLine                 = render and render.DrawLine
local renderDrawSphere               = render and render.DrawSphere
local renderSetMaterial              = render and render.SetMaterial
local stringGetFileName              = string and string.GetFileFromFilename
local surfaceSetFont                 = surface and surface.SetFont
local surfaceDrawLine                = surface and surface.DrawLine
local surfaceDrawText                = surface and surface.DrawText
local surfaceDrawCircle              = surface and surface.DrawCircle
local surfaceSetTexture              = surface and surface.SetTexture
local surfaceSetTextPos              = surface and surface.SetTextPos
local surfaceGetTextSize             = surface and surface.GetTextSize
local surfaceGetTextureID            = surface and surface.GetTextureID
local surfaceSetDrawColor            = surface and surface.SetDrawColor
local surfaceSetTextColor            = surface and surface.SetTextColor
local surfaceScreenWidth             = surface and surface.ScreenWidth
local surfaceScreenHeight            = surface and surface.ScreenHeight
local surfaceDrawTexturedRect        = surface and surface.DrawTexturedRect
local surfaceDrawTexturedRectRotated = surface and surface.DrawTexturedRectRotated
local languageAdd                    = language and language.Add
local constructSetPhysProp           = construct and construct.SetPhysProp
local constraintWeld                 = constraint and constraint.Weld
local constraintNoCollide            = constraint and constraint.NoCollide
local constraintCanConstrain         = constraint and constraint.CanConstrain
local constraintAdvBallsocket        = constraint and constraint.AdvBallsocket
local duplicatorStoreEntityModifier  = duplicator and duplicator.StoreEntityModifier

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

function IsInit()
  return (GetOpVar("TOOLNAME_NU") ~= nil)
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

function IsNull(vVal)
  if(not IsString(vVal)) then return false end
  return (vVal == GetOpVar("MISS_NOSQL"))
end

function IsExact(vVal)
  if(not IsString(vVal)) then return false end
  return (vVal:sub(1,1) == "*")
end

function IsBool(vVal)
  if    (vVal == true ) then return true
  elseif(vVal == false) then return true end
  return false
end

function IsNumber(vVal)
  return (type(vVal) == "number")
end

function IsTable(vVal)
  return (type(vVal) == "table")
end

function IsFunction(vVal)
  return (type(vVal) == "function")
end

function IsEmpty(tVal)
  return (IsTable(tVal) and not next(tVal))
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

-- Reports the type and actual value
function GetReport(vA) local sR = GetOpVar("FORM_VREPORT2")
  return (sR and sR:format(type(vA), tostring(vA)) or "")
end

-- Reports vararg containing two values
function GetReport2(vA, vB) local sR = GetOpVar("FORM_VREPORT2")
  return (sR and sR:format(tostring(vA), tostring(vB)) or "")
end

-- Reports vararg containing three values
function GetReport3(vA, vB, vC) local sR = GetOpVar("FORM_VREPORT3")
  return (sR and sR:format(tostring(vA), tostring(vB), tostring(vC)) or "")
end

-- Reports vararg containing three values
function GetReport4(vA, vB, vC, vD) local sR = GetOpVar("FORM_VREPORT4")
  return (sR and sR:format(tostring(vA), tostring(vB), tostring(vC), tostring(vD)) or "")
end

-- Returns the sign of a number [-1,0,1]
function GetSign(nVal)
  return (nVal / mathAbs(nVal))
end

-- Gets the date according to the specified format
function GetDate(vD, fD)
  return osDate(fD or GetOpVar("DATE_FORMAT"), vD)
end

-- Gets the time according to the specified format
function GetTime(vT, fT)
  return osDate(fT or GetOpVar("TIME_FORMAT"), vT)
end

-- Gets the date and time according to the specified format
function GetDateTime(vDT, fDT)
  return GetDate(vDT, fDT).." "..GetTime(vDT, fDT)
end

-- Strips a string from quotes
function GetStrip(vV, vQ)
  local sV = tostring(vV or ""):Trim()
  local sQ = tostring(vQ or "\""):sub(1,1)
  if(sV:sub( 1, 1) == sQ) then sV = sV:sub(2,-1) end
  if(sV:sub(-1,-1) == sQ) then sV = sV:sub(1,-2) end
  return sV:Trim()
end

function GetSnapInc(pB, nV, aV)
  local mV = mathAbs(aV)
  local cV = mathRound(nV / mV) * mV
  if(aV > 0 and cV > nV) then return cV end
  if(aV > 0 and cV < nV) then return (cV + mV) end
  if(aV < 0 and cV > nV) then return (cV - mV) end
  if(aV < 0 and cV < nV) then return cV end
  return (nV + aV)
end

------------------ LOGS ------------------------

local function GetLogID()
  local nNum, fMax = GetOpVar("LOG_CURLOGS"), GetOpVar("LOG_FORMLID")
  if(not (nNum and fMax)) then return "" end; return fMax:format(nNum)
end

--[[
  sMsg > Message being displayed
  bCon > Force outout in the console
]]
local function Log(vMsg, bCon)
  local iMax = GetOpVar("LOG_MAXLOGS")
  if(iMax <= 0) then return end
  local sMsg = tostring(vMsg)
  local iCur = GetOpVar("LOG_CURLOGS") + 1
  if(IsFlag("en_logging_file") and not bCon) then
    local lbNam = GetOpVar("NAME_LIBRARY")
    local fName = GetOpVar("LOG_FILENAME")
    if(iCur > iMax) then SetOpVar("LOG_CURLOGS", 1)
      fileDelete(fName) else SetOpVar("LOG_CURLOGS", iCur) end
    fileAppend(fName,GetLogID().." ["..GetDateTime().."] "..sMsg.."\n")
  else -- The current has values 1..nMaxLogs(0)
    if(iCur > iMax) then SetOpVar("LOG_CURLOGS", 1)
    else SetOpVar("LOG_CURLOGS", iCur) end
    print(GetLogID().." ["..GetDateTime().."] "..sMsg)
  end
end

--[[
  sMsg > Message being displayed
  sKey > SKIP / ONLY
  Return: exist, found
]]
local function IsLogFound(sMsg, sKey)
  local sMsg = tostring(sMsg or "")
  local sKey = tostring(sKey or "")
  if(IsBlank(sKey)) then return nil end
  local oStat = GetOpVar("LOG_"..sKey)
  if(IsTable(oStat) and oStat[1]) then
    local iCnt = 1; while(oStat[iCnt]) do
      if(sMsg:find(tostring(oStat[iCnt]))) then
        return true, true
      end; iCnt = iCnt + 1
    end; return true, false
  else return false, false end
end

--[[
  vMsg > Message being displayed
  vSrc > Name of the sub-routine call (string) or parameter stack (table)
  bCon > Force output in console flag
  iDbg > Debug table overrive depth
  tDbg > Debug table overrive
]]
function LogInstance(vMsg, vSrc, bCon, iDbg, tDbg)
  local nMax = (tonumber(GetOpVar("LOG_MAXLOGS")) or 0)
  if(nMax and (nMax <= 0)) then return end
  local vSrc, bCon, iDbg, tDbg = vSrc, bCon, iDbg, tDbg
  if(vSrc and IsTable(vSrc)) then -- Recieve the stack as table
    vSrc, bCon, iDbg, tDbg = vSrc[1], vSrc[2], vSrc[3], vSrc[4] end
  iDbg = mathFloor(tonumber(iDbg) or 0); iDbg = ((iDbg > 0) and iDbg or nil)
  local tInfo = (iDbg and debugGetinfo(iDbg) or nil) -- Pass stack index
        tInfo = (tInfo or (tDbg and tDbg or nil))    -- Override debug information
        tInfo = (tInfo or debugGetinfo(2))           -- Default value
  local sDbg, sFunc = "", tostring(sFunc or (tInfo.name and tInfo.name or "Incognito"))
  if(GetOpVar("LOG_DEBUGEN")) then
    local snID, snAV = GetOpVar("MISS_NOID"), GetOpVar("MISS_NOAV")
    sDbg = sDbg.." "..(tInfo.linedefined and "["..tInfo.linedefined.."]" or snAV)
    sDbg = sDbg..(tInfo.currentline and ("["..tInfo.currentline.."]") or snAV)
    sDbg = sDbg.."@"..(tInfo.source and (tInfo.source:gsub("^%W+", ""):gsub("\\","/")) or snID)
  end; local sSrc, bF, bL = tostring(vSrc or "")
  if(IsExact(sSrc)) then sSrc = sSrc:sub(2,-1); sFunc = "" else
    if(not IsBlank(sSrc)) then sSrc = sSrc.."." end end
  local sInst = ((SERVER and "SERVER" or nil) or (CLIENT and "CLIENT" or nil) or "NOINST")
  local sMoDB, sToolMD = tostring(GetOpVar("MODE_DATABASE")), tostring(GetOpVar("TOOLNAME_NU"))
  local sLast, sData = GetOpVar("LOG_LOGLAST"), (sSrc..sFunc..": "..tostring(vMsg))
  bF, bL = IsLogFound(sData, "SKIP"); if(bF and bL) then return end
  bF, bL = IsLogFound(sData, "ONLY"); if(bF and not bL) then return end
  if(sLast == sData) then return end; SetOpVar("LOG_LOGLAST",sData)
  Log(sInst.." > "..sToolMD.." ["..sMoDB.."]"..sDbg.." "..sData, bCon)
end

local function LogCeption(tT,sS,tP)
  local vK, sS = "", tostring(sS or "Data")
  if(not IsTable(tT)) then
    LogInstance("{"..type(tT).."}["..sS.."] = <"..tostring(tT)..">",tP); return nil end
  if(not IsHere(next(tT))) then
    LogInstance(sS.." = {}",tP); return nil end; LogInstance(sS.." = {}",tP)
  for k,v in pairs(tT) do
    if(IsString(k)) then
      vK = sS.."[\""..k.."\"]"
    else vK = sS.."["..tostring(k).."]" end
    if(not IsTable(v)) then
      if(IsString(v)) then
        LogInstance(vK.." = \""..v.."\"",tP)
      else LogInstance(vK.." = "..tostring(v),tP) end
    else
      if(v == tT) then LogInstance(vK.." = "..sS,tP)
      else LogCeption(v,vK,tP) end
    end
  end
end

function LogTable(tT, sS, vSrc, bCon, iDbg, tDbg)
  local vSrc, bCon, iDbg, tDbg = vSrc, bCon, iDbg, tDbg
  if(vSrc and IsTable(vSrc)) then -- Recieve the stack as table
    vSrc, bCon, iDbg, tDbg = vSrc[1], vSrc[2], vSrc[3], vSrc[4] end
  local tP = {vSrc, bCon, iDbg, tDbg} -- Normalize parameters
  tP[1], tP[2] = tostring(vSrc or ""), tobool(bCon)
  tP[3], tP[4] = (nil), debugGetinfo(2); LogCeption(tT,sS,tP)
end

------------- VALUE ---------------
--[[
 * When requested wraps the first value according to
 * the interval described by the other two values
 * Inp: -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10
 * Out:  3  1  2  3  1  2 3 1 2 3 1 2 3 1 2 3  1
 * This is an example call for the input between 1 and 3
]]
function GetWrap(nVal,nMin,nMax) local nVal = nVal
  while(nVal < nMin or nVal > nMax) do
    nVal = ((nVal < nMin) and (nMax - (nMin - nVal) + 1) or nVal)
    nVal = ((nVal > nMax) and (nMin + (nVal - nMax) - 1) or nVal)
  end; return nVal -- Returns the N-stepped value
end

--[[
 * Applies border if exists to the input value
 * according to the given border name. Basically
 * custom version of a clamp with vararg border limits
]]
function BorderValue(nsVal, vKey)
  if(not IsHere(vKey)) then return nsVal end
  if(not (IsString(nsVal) or IsNumber(nsVal))) then
    LogInstance("Value not comparable "..GetReport(nsVal)); return nsVal end
  local tB = GetOpVar("TABLE_BORDERS")[vKey]; if(not IsHere(tB)) then
    LogInstance("Missing "..GetReport(vKey)); return nsVal end
  if(tB and tB[1] and nsVal < tB[1]) then return tB[1] end
  if(tB and tB[2] and nsVal > tB[2]) then return tB[2] end
  return nsVal
end

function SetBorder(vKey, vLow, vHig)
  if(not IsHere(vKey)) then
    LogInstance("Key missing"); return false end
  local tB = GetOpVar("TABLE_BORDERS")
  if(IsHere(tB[vKey])) then local tU = tB[vKey]
    local vL, vH = tostring(tU[1]), tostring(tU[2])
    LogInstance("Exists ("..tostring(vKey)..")<"..vL.."/"..vH..">")
  end; tB[vKey] = {vLow, vHig}; local vL, vH = tostring(vLow), tostring(vHig)
  LogInstance("Apply ("..tostring(vKey)..")<"..vL.."/"..vH..">"); return true
end

--[[
 * Used for scaling distant circles for player perspective
 * pPly > Player the radius is scaled for
 * vPos > Position of the distance scale
 * nMul > Radius scale resize multiplier
]]
function GetViewRadius(pPly, vPos, nMul)
  local nM = 5000 * (GetOpVar("GOLDEN_RATIO") - 1)
  local nS = mathClamp(tonumber(nMul or 1), 0, 1000)
  local vP = pPly:GetShootPos() vP:Sub(vPos)
  return nS * mathClamp(nM / vP:Length(), 0, 5000)
end

-- Golden retriever. Retrieves file line as string
-- But seriously returns the sting line and EOF flag
function GetStringFile(pFile,bNoTrim)
  if(not pFile) then LogInstance("No file"); return "", true end
  local sCh, sLine = "X", "" -- Use a value to start cycle with
  while(sCh) do sCh = pFile:Read(1); if(not sCh) then break end
    if(sCh == "\n") then
      if(bNoTrim) then return sLine, false end
      return sLine:Trim(), false
    else sLine = sLine..sCh end
  end -- EOF has been reached. Return the last data
  if(bNoTrim) then return sLine, true end
  return sLine:Trim(), true
end

function ToIcon(vKey, vVal)
  if(SERVER) then return nil end
  local tIcon = GetOpVar("TABLE_SKILLICON"); if(not IsHere(vKey)) then
    LogInstance("Invalid "..GetReport(vKey)); return nil end
  if(IsHere(vVal)) then tIcon[vKey] = tostring(vVal) end
  local sIcon = tIcon[vKey]; if(not IsHere(sIcon)) then
    LogInstance("Missing "..GetReport(vKey)); return nil end
  return GetOpVar("FORM_SKILLICON"):format(tostring(sIcon))
end

function WorkshopID(sKey, nVal)
  if(SERVER) then return nil end
  local tID = GetOpVar("TABLE_WSIDADDON"); if(not IsString(sKey)) then
    LogInstance("Invalid "..GetReport(sKey)); return nil end
  if(IsHere(nVal)) then
    if(IsNumber(nVal) and nVal > 0) then tID[sKey] = nVal else
      LogInstance("("..sKey..") Mismatch "..GetReport(nVal)); return nil
    end
  end; return tID[sKey]
end

function IsFlag(vKey, vVal)
  local tFlag = GetOpVar("TABLE_FLAGS"); if(not IsHere(vKey)) then
    LogInstance("Invalid "..GetReport(vKey)); return nil end
  if(IsHere(vVal)) then tFlag[vKey] = tobool(vVal) end
  local bFlag = tFlag[vKey]; if(not IsHere(bFlag)) then
    LogInstance("Missing "..GetReport(vKey)); return nil end
  return tFlag[vKey] -- Return the flag status
end

----------------- INITAIALIZATION -----------------

function SetLogControl(nLines,bFile)
  local bFou, sBas = IsFlag("en_logging_file", bFile), GetOpVar("DIRPATH_BAS")
  local nMax = (tonumber(nLines) or 0); nMax = mathFloor((nMax > 0) and nMax or 0)
  local sMax, sFou = tostring(GetOpVar("LOG_MAXLOGS")), tostring(bFou)
  if(sBas and not fileExists(sBas,"DATA")) then fileCreateDir(sBas) end
  SetOpVar("LOG_CURLOGS", 0); SetOpVar("LOG_MAXLOGS", nMax)
  SetOpVar("LOG_FORMLID", "%"..(tostring(nMax)):len().."d")
  LogInstance("("..sMax..","..sFou..")")
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
    end; S:Close(); LogInstance("Success <"..sKey.."@"..fName..">"); return false
  else LogInstance("Missing <"..sKey.."@"..fName..">"); return false end
end

function GetIndexes(sType)
  if(not IsString(sType)) then
    LogInstance("Type mismatch "..GetReport(sType)); return nil end
  if    (sType == "V")  then return cvX, cvY, cvZ
  elseif(sType == "A")  then return caP, caY, caR
  elseif(sType == "WA") then return wvX, wvY, wvZ
  elseif(sType == "WV") then return waP, waY, waR
  else LogInstance("Type <"..sType.."> not found"); return nil end
end

function SetIndexes(sType,...)
  if(not IsString(sType)) then
    LogInstance("Type mismatch "..GetReport(sType)); return false end
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
  SetOpVar("LOG_SKIP",{})
  SetOpVar("LOG_ONLY",{})
  SetOpVar("LOG_MAXLOGS",0)
  SetOpVar("LOG_CURLOGS",0)
  SetOpVar("LOG_LOGLAST","")
  SetOpVar("TIME_INIT",Time())
  SetOpVar("DELAY_FREEZE",0.01)
  SetOpVar("MAX_ROTATION",360)
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
  SetOpVar("KEYQ_BUILDER", "DATA_BUILDER")
  SetOpVar("DEG_RAD", mathPi / 180)
  SetOpVar("WIDTH_CPANEL", 281)
  SetOpVar("EPSILON_ZERO", 1e-5)
  SetOpVar("COLOR_CLAMP", {0, 255})
  SetOpVar("GOLDEN_RATIO",1.61803398875)
  SetOpVar("DATE_FORMAT","%y-%m-%d")
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
  SetOpVar("MISS_NOMD","X")      -- No model
  SetOpVar("MISS_NOID","N")      -- No ID selected
  SetOpVar("MISS_NOAV","N/A")    -- Not Available
  SetOpVar("MISS_NOTP","TYPE")   -- No track type
  SetOpVar("MISS_NOBS","0/0")    -- No Bodygroup skin
  SetOpVar("MISS_NOSQL","NULL")  -- No SQL value
  SetOpVar("FORM_CONCMD", "%s %s")
  SetOpVar("FORM_KEYSTMT","%s(%s)")
  SetOpVar("FORM_VREPORT2","{%s}[%s]")
  SetOpVar("FORM_VREPORT3","{%s}[%s]<%s>")
  SetOpVar("FORM_VREPORT4","{%s}[%s]<%s>|%s|")
  SetOpVar("FORM_LOGSOURCE","%s.%s(%s)")
  SetOpVar("FORM_LOGBTNSLD","Button(%s)[%s] %s")
  SetOpVar("FORM_PREFIXDSV", "%s%s.txt")
  SetOpVar("LOG_FILENAME",GetOpVar("DIRPATH_BAS")..GetOpVar("NAME_LIBRARY").."_log.txt")
  SetOpVar("FORM_LANGPATH","%s"..GetOpVar("TOOLNAME_NL").."/lang/%s")
  SetOpVar("FORM_SNAPSND", "physics/metal/metal_canister_impact_hard%d.wav")
  SetOpVar("FORM_NTFGAME", "GAMEMODE:AddNotify(\"%s\", NOTIFY_%s, 6)")
  SetOpVar("FORM_NTFPLAY", "surface.PlaySound(\"ambient/water/drip%d.wav\")")
  SetOpVar("MODELNAM_FILE","%.mdl")
  SetOpVar("MODELNAM_FUNC",function(x) return " "..x:sub(2,2):upper() end)
  SetOpVar("QUERY_STORE", {})
  SetOpVar("TABLE_FLAGS", {})
  SetOpVar("TABLE_BORDERS",{})
  SetOpVar("TABLE_MONITOR", {})
  SetOpVar("TABLE_CONTAINER",{})
  SetOpVar("TABLE_CONVARLIST",{})
  SetOpVar("TABLE_FREQUENT_MODELS",{})
  SetOpVar("ARRAY_DECODEPOA",{0,0,0,Size=3})
  SetOpVar("ENTITY_DEFCLASS", "prop_physics")
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
  if(CLIENT) then
    SetOpVar("MISS_NOTR","Oops, missing ?") -- No translation found
    SetOpVar("TOOL_DEFMODE","gmod_tool")
    SetOpVar("FORM_FILENAMEAR", "z_autorun_[%s].txt")
    SetOpVar("FORM_DRAWDBG", "%s{%s}: %s > %s")
    SetOpVar("FORM_DRWSPKY", "%+6s")
    SetOpVar("FORM_SKILLICON","icon16/%s.png")
    SetOpVar("FORM_URLADDON", "https://steamcommunity.com/sharedfiles/filedetails/?id=%d")
    SetOpVar("TABLE_SKILLICON",{})
    SetOpVar("TABLE_WSIDADDON", {})
    SetOpVar("ARRAY_GHOST",{Size=0, Slot=GetOpVar("MISS_NOMD")})
    SetOpVar("HOVER_TRIGGER",{})
    SetOpVar("LOCALIFY_TABLE",{})
    SetOpVar("LOCALIFY_AUTO","en")
    SetOpVar("TABLE_CATEGORIES",{})
    SetOpVar("TREE_KEYPANEL","#$@KEY&*PAN*&OBJ@$#")
  end; LogInstance("Success"); return true
end

------------- COLOR ---------------

function FixColor(nC)
  local tC = GetOpVar("COLOR_CLAMP")
  return mathFloor(mathClamp((tonumber(nC) or 0), tC[1], tC[2]))
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

function GetLength(vBase)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  local X = (tonumber(vBase[cvX]) or 0); X = X * X
  local Y = (tonumber(vBase[cvY]) or 0); Y = Y * Y
  local Z = (tonumber(vBase[cvZ]) or 0); Z = Z * Z
  return mathSqrt(X + Y + Z)
end

function RoundVector(vBase,nvDec)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  local D = tonumber(nvDec); if(not IsHere(R)) then
    LogInstance("Round mismatch "..GetReport(nvDec)); return nil end
  local X = (tonumber(vBase[cvX]) or 0); X = mathRound(X,D); vBase[cvX] = X
  local Y = (tonumber(vBase[cvY]) or 0); Y = mathRound(Y,D); vBase[cvY] = Y
  local Z = (tonumber(vBase[cvZ]) or 0); Z = mathRound(Z,D); vBase[cvZ] = Z
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

function BasisVector(vBase, aUnit)
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

function SetXY(xyR, vA, vB) local xA, yA
  if(not xyR) then LogInstance("Base R invalid"); return nil end
  if(not vA ) then LogInstance("Base A invalid"); return nil end
  if(vB) then xA, yA = (tonumber(vA) or 0), (tonumber(vB) or 0)
  else xA, yA = (tonumber(vA.x) or 0), (tonumber(vA.y) or 0) end
  xyR.x, xyR.y = xA, yA; return xyR
end

function NegXY(xyR)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  xyR.x, xyR.y = -xyR.x, -xyR.y; return xyR
end

function NegX(xyR)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  xyR.x = -xyR.x; return xyR
end

function NegY(xyR)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  xyR.y = -xyR.y; return xyR
end

function MulXY(xyR, vM)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  local nM = (tonumber(vM) or 0)
  xyR.x, xyR.y = (xyR.x * nM), (xyR.y * nM); return xyR
end

function DivXY(xyR, vD)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  local nD = (tonumber(vM) or 0)
  xyR.x, xyR.y = (xyR.x / nD), (xyR.y / nD); return xyR
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

function LenXY(xyR)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  local xA, yA = (tonumber(xyR.x) or 0), (tonumber(xyR.y) or 0)
  return mathSqrt(xA * xA + yA * yA)
end

function ExpXY(xyR)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  return (tonumber(xyR.x) or 0), (tonumber(xyR.y) or 0)
end

function UnitXY(xyR)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  local nL = LenXY(xyR); if(nL == nL ) then
    LogInstance("Length A invalid"); return nil end
  xyR.xm, xyR.y = (tonumber(xyR.x) / nL), (tonumber(xyR.y) / nL)
  return xyR -- Return scaled unit vector
end

function MidXY(xyR, xyA, xyB)
  if(not xyR) then LogInstance("Base R invalid"); return nil end
  if(not xyA) then LogInstance("Base A invalid"); return nil end
  if(not xyB) then LogInstance("Base B invalid"); return nil end
  local xA, yA = (tonumber(xyA.x) or 0), (tonumber(xyA.y) or 0)
  local xB, yB = (tonumber(xyB.x) or 0), (tonumber(xyB.y) or 0)
  xyR.x, xyR.y = ((xA + xB) / 2), ((yA + yB) / 2); return xyR
end

function RotateXY(xyR, nR)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  local nA = (tonumber(nR) or 0)
  if(nA == 0) then return xyR end
  local nX = (tonumber(xyR.x) or 0)
  local nY = (tonumber(xyR.y) or 0)
  local nS, nC = mathSin(nA), mathCos(nA)
  xyR.x = (nX * nC - nY * nS)
  xyR.y = (nX * nS + nY * nC); return xyR
end

function GetAngleXY(xyR)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  return mathAtan2(xyR.y, xyR.x)
end

----------------- OOP ------------------

function MakeContainer(sKey, sDef)
  local mKey = tostring(sKey or "STORAGE_CONTAINER")
  local mHash = GetOpVar("TABLE_CONTAINER")
  if(IsHere(sKey) and mHash[mKey]) then return mHash[mKey] end
  local mData, mID, self = {}, {}, {}
  local mDef = sDef or GetOpVar("OOP_DEFAULTKEY")
  local miTop, miAll, mhCnt = 0, 0, 0
  function self:GetInfo() return mInfo end
  function self:GetSize() return miTop end  -- Largest index in array part
  function self:GetCount() return miAll end -- Actual populated slots <= `miTop`
  function self:GetKept() return mhCnt end  -- The hash part slots maximum count
  function self:GetData() return mData end
  function self:GetHashID() return mID end
  function self:Collect() collectgarbage(); return self end
  function self:IsRagged() return (miAll ~= miTop) end
  function self:Select(nsKey)
    local iK = (nsKey or mDef); return mData[iK]
  end
  function self:GetKeyID(nsKey)
    local iK = (nsKey or mDef); return mID[iK]
  end
  function self:Refresh()
    while(not IsHere(mData[miTop]) and miTop > 0) do
      miTop = (miTop - 1) end; return self
  end
  function self:Find(vVal)
    for iK, vV in pairs(mData) do
      if(vV == vVal) then
        return iK, (IsString(iK) and mID[iK] or nil)
      end
    end; return nil, nil
  end
  function self:Arrange(nKey, bExp)
    if(nKey > 0 and nKey <= miTop) then
      local nStp = (bExp and -1 or 1)
      if(bExp) then
        for iD = miTop, nKey, nStp do mData[iD + 1] = mData[iD] end
      else -- Contract values
        for iD = nKey, miTop, nStp do mData[iD] = mData[iD + 1] end
        mData[miTop] = nil
      end
      miTop = (miTop - nStp)
    end; return self:Refresh()
  end
  function self:Clear()
    tableEmpty(self:GetData())
    tableEmpty(self:GetHashID())
    miTop, miAll, mhCnt = 0, 0, 0
    return self
  end
  function self:Record(nsKey, vVal)
    local iK, bK = (nsKey or mDef), IsHere(nsKey)
    if(IsNumber(iK) or not bK) then
      if(not bK) then iK = (miTop + 1) end
      if(iK > miTop) then miTop = iK end
      if(not IsHere(mData[iK]) and IsHere(vVal)) then
        miAll = (miAll + 1); end; mData[iK] = vVal
    else
      if(not IsHere(mData[iK])) then
        mhCnt = (mhCnt + 1)
        mID[mhCnt] = iK
        mID[iK] = mhCnt
        mData[iK] = vVal
      else mData[iK] = vVal end
    end; return self:Refresh()
  end
  function self:Delete(nsKey)
    local iK, bK = (nsKey or mDef), IsHere(nsKey)
    if(bK and not IsHere(mData[iK])) then return self end
    if(IsNumber(iK) or not bK) then
      if(not bK) then iK = miTop end
      if(iK > miTop) then return self end
      if(0 == miTop) then return self end
      miAll, mData[iK] = (miAll - 1), nil
    else local iD = mID[iK]
      for iC = iD, mhCnt do
        local vK = mID[iC]
        mID[vK] = mID[vK] - 1
      end
      tableRemove(mID, iD)
      mData[iK], mID[iK] = nil, nil
    end; return self:Refresh()
  end
  function self:Pull(nKey)
    if(nKey) then local nKey = tonumber(nKey)
      if(nKey and nKey > 0 and nKey <= miTop) then
        local vVal = mData[nKey]
        local bV = IsHere(vVal)
        if(bV) then miAll = miAll - 1 end
        self:Arrange(nKey, false); return vVal
      end; return nil
    else
      local vVal = mData[miTop]
      self:Delete(); return vVal
    end
  end
  function self:Push(vVal, nKey)
    if(nKey) then
      local bV = IsHere(vVal)
      local nKey = tonumber(nKey)
      if(not nKey) then return self end
      if(nKey > 0 and nKey <= miTop) then
        if(bV) then miAll = miAll + 1 end
        self:Arrange(nKey, true)
        mData[nKey] = vVal
      elseif(nKey > miTop) then
        if(bV) then miAll = miAll + 1 end
        mData[nKey], miTop = vVal, nKey
      end; return self
    else
      return self:Record(nil, vVal)
    end
  end
  if(IsHere(sKey)) then mHash[sKey] = self
    LogInstance("Container registered "..GetReport(mKey)) end
  setmetatable(self, GetOpVar("TYPEMT_CONTAINER")); return self
end

--[[
 * Creates a screen object better user API for drawing on the gmod screens
 * sW     -> Start screen width
 * sH     -> Start screen height
 * eW     -> End screen width
 * eH     -> End screen height
 * conClr -> Screen color container
 * aKey   -> Screen cache storage key
 * The drawing methods are the following:
 * SURF - Uses the surface library to draw directly
 * SEGM - Uses the surface library to draw line segment interpolations
 * CAM3 - Uses the render  library to draw shapes in 3D space
 * Operation keys for storing initial arguments are the following:
 * TXT - Drawing text
 * LIN - Drawing lines
 * REC - Drawing a rectangle
 * CIR - Drawing a circle
 * UCS - Drawing a coordinate system
]]--
function MakeScreen(sW,sH,eW,eH,conClr,aKey)
  if(SERVER) then return nil end
  local tLogs, tMon = {"MakeScreen"}, GetOpVar("TABLE_MONITOR")
  if(IsHere(aKey) and tMon[aKey]) then -- Return the cached screen
    local oMon = tMon[aKey]; oMon:GetColor(); return oMon end
  local sW, sH = (tonumber(sW) or 0), (tonumber(sH) or 0)
  local eW, eH = (tonumber(eW) or 0), (tonumber(eH) or 0)
  if(sW < 0 or sH < 0) then LogInstance("Start dimension invalid", tLogs); return nil end
  if(eW < 0 or eH < 0) then LogInstance("End dimension invalid", tLogs); return nil end
  local xyS, xyE, self = NewXY(sW, sH), NewXY(eW, eH), {}
  local Colors = {List = conClr, Key = GetOpVar("OOP_DEFAULTKEY"), Default = GetColor(255,255,255,255)}
  if(Colors.List) then -- Container check
    if(getmetatable(Colors.List) ~= GetOpVar("TYPEMT_CONTAINER"))
      then LogInstance("Color list not container", tLogs); return nil end
  else -- Color list is not present then create one
    Colors.List = MakeContainer("COLORS_LIST") -- Default color container
  end
  local DrawMeth, DrawArgs, Text, TxID = {}, {}, {}, {}
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
  function self:GetMaterial(fC, sP) local tS = TxID[fC]
    if(not tS) then TxID[fC] = {} end; tS = TxID[fC]
    if(not tS[sP]) then bS, vV = pcall(fC, sP)
      if(not bS) then LogInstance("Call fail <"..vV..">", tLogs); return nil end
      tS[sP] = vV -- Store the value in the cache
    end; return tS[sP] -- Return cached material or texture
  end
  function self:GetColor(keyCl,sMeth)
    if(not IsHere(keyCl) and not IsHere(sMeth)) then
      Colors.Key = GetOpVar("OOP_DEFAULTKEY")
      LogInstance("Color reset", tLogs); return self end
    local keyCl = (keyCl or Colors.Key); if(not IsHere(keyCl)) then
      LogInstance("Indexing skipped", tLogs); return self end
    if(not IsString(sMeth)) then
      LogInstance("Method <"..tostring(method).."> invalid", tLogs); return self end
    local rgbCl = Colors.List:Select(keyCl)
    if(not IsHere(rgbCl)) then rgbCl = Colors.Default end
    if(tostring(Colors.Key) ~= tostring(keyCl)) then -- Update the color only on change
      surfaceSetDrawColor(rgbCl.r, rgbCl.g, rgbCl.b, rgbCl.a)
      surfaceSetTextColor(rgbCl.r, rgbCl.g, rgbCl.b, rgbCl.a)
      Colors.Key = keyCl; -- The drawing color for these two methods uses surface library
    end; return rgbCl, keyCl
  end
  function self:GetDrawParam(sMeth,tArgs,sKey)
    local tArgs = (tArgs or DrawArgs[sKey])
    local sMeth = tostring(sMeth or DrawMeth[sKey])
    if(sMeth == "SURF") then
      if(sKey == "TXT" and tArgs ~= DrawArgs[sKey]) then
        surfaceSetFont(tostring(tArgs[1] or "Default")) end -- Time to set the font again
    end; DrawMeth[sKey], DrawArgs[sKey] = sMeth, tArgs; return sMeth, tArgs
  end
  function self:SetTextEdge(nX,nY)
    Text.ScrW, Text.ScrH = 0, 0
    Text.LstW, Text.LstH = 0, 0
    Text.DrwX = (tonumber(nX) or 0)
    Text.DrwY = (tonumber(nY) or 0); return self
  end
  function self:GetTextState(nX,nY,nW,nH)
    return (Text.DrwX + (nX or 0)), (Text.DrwY + (nY or 0)),
           (Text.ScrW + (nW or 0)), (Text.ScrH + (nH or 0)),
            Text.LstW, Text.LstH
  end
  function self:DrawText(sText,keyCl,sMeth,tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"TXT")
    self:GetColor(keyCl, sMeth)
    if(sMeth == "SURF") then
      surfaceSetTextPos(Text.DrwX,Text.DrwY); surfaceDrawText(sText)
      Text.LstW, Text.LstH = surfaceGetTextSize(sText)
      Text.DrwY = Text.DrwY + Text.LstH
      if(Text.LstW > Text.ScrW) then Text.ScrW = Text.LstW end
      Text.ScrH = Text.DrwY
    else
      LogInstance("Draw method <"..sMeth.."> invalid", tLogs)
    end; return self
  end
  function self:DrawTextAdd(sText,keyCl,sMeth,tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"TXT")
    self:GetColor(keyCl, sMeth)
    if(sMeth == "SURF") then
      surfaceSetTextPos(Text.DrwX + Text.LstW,Text.DrwY - Text.LstH)
      surfaceDrawText(sText)
      local LstW, LstH = surfaceGetTextSize(sText)
      Text.LstW, Text.LstH = (Text.LstW + LstW), LstH
      if(Text.LstW > Text.ScrW) then Text.ScrW = Text.LstW end
      Text.ScrH = Text.DrwY
    else
      LogInstance("Draw method <"..sMeth.."> invalid", tLogs)
    end; return self
  end
  function self:DrawTextCenter(xyP,sText,keyCl,sMeth,tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"TXT")
    self:GetColor(keyCl, sMeth)
    if(sMeth == "SURF") then
      local LstW, LstH = surfaceGetTextSize(sText)
      LstW, LstH = (LstW / 2), (LstH / 2)
      surfaceSetTextPos(xyP.x - LstW, xyP.y - LstH)
      surfaceDrawText(sText)
    end; return self
  end
  function self:Enclose(xyP)
    if(xyP.x < sW) then return -1 end
    if(xyP.x > eW) then return -1 end
    if(xyP.y < sH) then return -1 end
    if(xyP.y > eH) then return -1 end; return 1
  end
  function self:GetDistance(pS, pE)
    if(self:Enclose(pS) == -1) then
      LogInstance("Start out of border", tLogs); return nil end
    if(self:Enclose(pE) == -1) then
      LogInstance("End out of border", tLogs); return nil end
    return mathSqrt((pE.x - pS.x)^2 + (pE.y - pS.y)^2)
  end
  function self:DrawLine(pS,pE,keyCl,sMeth,tArgs)
    if(not (pS and pE)) then return self end
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"LIN")
    local rgbCl, keyCl = self:GetColor(keyCl, sMeth)
    if(sMeth == "SURF") then
      if(self:Enclose(pS) == -1) then
        LogInstance("Start out of border", tLogs); return self end
      if(self:Enclose(pE) == -1) then
        LogInstance("End out of border", tLogs); return self end
      surfaceDrawLine(pS.x,pS.y,pE.x,pE.y)
    elseif(sMeth == "SEGM") then
      if(self:Enclose(pS) == -1) then
        LogInstance("Start out of border", tLogs); return self end
      if(self:Enclose(pE) == -1) then
        LogInstance("End out of border", tLogs); return self end
      local nItr = mathClamp((tonumber(tArgs[1]) or 1),1,200)
      if(nIter <= 0) then return self end
      local xyD = NewXY((pE.x - pS.x) / nItr, (pE.y - pS.y) / nItr)
      local xyOld, xyNew = NewXY(pS.x, pS.y), NewXY()
      while(nItr > 0) do AddXY(xyNew, xyOld, xyD)
        surfaceDrawLine(xyOld.x,xyOld.y,xyNew.x,xyNew.y)
        SetXY(xyOld, xyNew); nItr = nItr - 1
      end
    elseif(sMeth == "CAM3") then
      renderDrawLine(pS,pE,rgbCl,(tArgs[1] and true or false))
    else LogInstance("Draw method <"..sMeth.."> invalid", tLogs); return self end
  end
  function self:DrawRect(pO,pS,keyCl,sMeth,tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"REC")
    self:GetColor(keyCl,sMeth)
    if(sMeth == "SURF") then
      if(self:Enclose(pO) == -1) then
        LogInstance("Start out of border", tLogs); return self end
      if(self:Enclose(pS) == -1) then
        LogInstance("End out of border", tLogs); return self end
      local nR = tonumber(tArgs[2])
      surfaceSetTexture(self:GetMaterial(surfaceGetTextureID, tArgs[1]))
      if(nR) then local nD = (nR / GetOpVar("DEG_RAD"))
        surfaceDrawTexturedRectRotated(pO.x,pO.y,pS.x,pS.y,nD)
      else -- Use the regular rectangle function without sin/cos rotation
        surfaceDrawTexturedRect(pO.x,pO.y,pS.x,pS.y)
      end
    else -- Unsupported method
      LogInstance("Draw method <"..sMeth.."> invalid", tLogs)
    end; return self
  end
  function self:DrawCircle(pC,nRad,keyCl,sMeth,tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"CIR")
    local rgbCl, keyCl = self:GetColor(keyCl,sMeth)
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
      renderSetMaterial(self:GetMaterial(Material, (tArgs[1] or "color")))
      renderDrawSphere (pC,nRad,mathClamp(tArgs[2] or 1,1,200),
                                mathClamp(tArgs[3] or 1,1,200),rgbCl)
    else LogInstance("Draw method <"..sMeth.."> invalid", tLogs); return nil end
  end
  function self:DrawUCS(oPly,vO,aO,sMeth,tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"UCS")
    local nSiz = BorderValue(tonumber(tArgs[1]) or 0, "non-neg")
    if(nSiz > 0) then
      if(sMeth == "SURF") then
        local xyO = vO:ToScreen()
        local xyZ = (vO + nSiz * aO:Up()):ToScreen()
        local xyY = (vO + nSiz * aO:Right()):ToScreen()
        local xyX = (vO + nSiz * aO:Forward()):ToScreen()
        self:DrawCircle(xyO,GetViewRadius(oPly, vO),"y",sMeth)
        self:DrawLine(xyO,xyX,"r",sMeth)
        self:DrawLine(xyO,xyY,"g")
        self:DrawLine(xyO,xyZ,"b"); return xyO, xyX, xyY, xyZ
      else LogInstance("Draw method <"..sMeth.."> invalid", tLogs); return nil end
    end
  end
  function self:DrawPOA(oPly,ePOA,stPOA,nAct)
    if(not (ePOA and ePOA:IsValid())) then
      LogInstance("Entity invalid", tLogs); return nil end
    if(not IsPlayer(oPly)) then
      LogInstance("Player invalid", tLogs); return nil end
    local nAct = BorderValue(tonumber(nAct) or 0, "non-neg")
    local eP, eA = ePOA:GetPos(), ePOA:GetAngles()
    local vO, vP = Vector(), Vector()
    SetVector(vO,stPOA.O); vO:Rotate(eA); vO:Add(eP)
    SetVector(vP,stPOA.P); vP:Rotate(eA); vP:Add(eP)
    local Op, Pp = vO:ToScreen(), vP:ToScreen()
    local Rv = GetViewRadius(oPly, vP, nAct)
    self:DrawCircle(Op, GetViewRadius(oPly, vO),"y","SURF")
    self:DrawCircle(Pp, Rv, "r","SEGM",{35})
    self:DrawLine(Op, Pp)
  end
  setmetatable(self, GetOpVar("TYPEMT_SCREEN"))
  if(IsHere(aKey)) then tMon[aKey] = self
    LogInstance("Screen registered "..GetReport(aKey)) end
  return self -- Register the screen under the key
end

function SetAction(sKey,fAct,tDat,...)
  if(not (sKey and IsString(sKey))) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  if(not (fAct and type(fAct) == "function")) then
    LogInstance("Action mismatch "..GetReport(fAct)); return nil end
  if(not libAction[sKey]) then libAction[sKey] = {} end
  local tAct = libAction[sKey]; tAct.Act, tAct.Dat = fAct, {}
  if(IsTable(tDat)) then
    for key, val in pairs(tDat) do
      tAct.Dat[key] = tDat[key]
    end
  else tAct.Dat = {tDat, ...} end
  tAct.Dat.Slot = sKey; return true
end

function GetActionCode(sKey)
  if(not (sKey and IsString(sKey))) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  if(not (libAction and libAction[sKey])) then
    LogInstance("Missing key <"..sKey..">"); return nil end
  return libAction[sKey].Act
end

function GetActionData(sKey)
  if(not (sKey and IsString(sKey))) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  if(not (libAction and libAction[sKey])) then
    LogInstance("Missing key <"..sKey..">"); return nil end
  return libAction[sKey].Dat
end

function CallAction(sKey,...)
  if(not (sKey and IsString(sKey))) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  if(not (libAction and libAction[sKey])) then
    LogInstance("Missing key <"..sKey..">"); return nil end
  local fAct, tDat = libAction[sKey].Act, libAction[sKey].Dat
  return pcall(fAct, tDat, ...)
end

local function AddLineListView(pnListView,frUsed,ivNdex)
  if(not IsHere(pnListView)) then
    LogInstance("Missing panel"); return false end
  if(not IsValid(pnListView)) then
    LogInstance("Invalid panel"); return false end
  if(not IsHere(frUsed)) then
    LogInstance("Missing data"); return false end
  local iNdex = tonumber(ivNdex); if(not IsHere(iNdex)) then
    LogInstance("Index mismatch "..GetReport(ivNdex)); return false end
  local tValue = frUsed[iNdex]; if(not IsHere(tValue)) then
    LogInstance("Missing data on index #"..tostring(iNdex)); return false end
  local makTab = GetBuilderNick("PIECES"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local sModel = tValue.Table[makTab:GetColumnName(1)]
  local sType  = tValue.Table[makTab:GetColumnName(2)]
  local sName  = tValue.Table[makTab:GetColumnName(3)]
  local nAct   = tValue.Table[makTab:GetColumnName(4)]
  local nUsed  = mathRound(tValue.Value,3)
  local pnLine = pnListView:AddLine(nUsed,nAct,sType,sName,sModel)
        pnLine:SetTooltip(sModel)
  return true
end

--[[
 * Updates a VGUI pnListView with a search preformed in the already generated
 * frequently used pieces "frUsed" for the pattern "sPat" given by the user
 * and a column name selected `sCol`.
 * On success populates `pnListView` with the search preformed
 * On fail a parameter is not valid or missing and returns non-success
 * pnListView -> The panel which must be updated
 * frUsed     -> The list of the frequently used tracks
 * nCount     -> The amount of pieces to check
 * sCol       -> The name of the column it preforms search by
 * sPat       -> Search pattern to preform the search with
]]--
function UpdateListView(pnListView,frUsed,nCount,sCol,sPat)
  if(not (IsHere(frUsed) and IsHere(frUsed[1]))) then
    LogInstance("Missing data"); return false end
  local nCount = (tonumber(nCount) or 0); if(nCount <= 0) then
    LogInstance("Count not applicable"); return false end
  if(IsHere(pnListView)) then
    if(not IsValid(pnListView)) then
      LogInstance("Invalid ListView"); return false end
    pnListView:SetVisible(false); pnListView:Clear()
  else LogInstance("Missing ListView"); return false end
  local sCol, iCnt = tostring(sCol or ""), 1
  local sPat, sDat = tostring(sPat or ""), nil
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

function GetDirectory(pCurr, vName)
  if(not pCurr) then
    LogInstance("Location invalid"); return nil end
  local keyOb = GetOpVar("TREE_KEYPANEL")
  local sName = tostring(vName or "")
        sName = IsBlank(sName) and "Other" or sName
  local pItem = pCurr[sName]; if(not IsHere(pItem)) then
    LogInstance("Name missing <"..sName..">"); return nil end
  return pItem, pItem[keyOb]
end

function SetDirectory(pnBase, pCurr, vName)
  if(not IsValid(pnBase)) then
    LogInstance("Base panel invalid"); return nil end
  if(not pCurr) then
    LogInstance("Location invalid"); return nil end
  local tSkin = pnBase:GetSkin()
  local sTool = GetOpVar("TOOLNAME_NL")
  local keyOb = GetOpVar("TREE_KEYPANEL")
  local sName = tostring(vName or "")
        sName = (IsBlank(sName) and "Other" or sName)
  local pNode = pnBase:AddNode(sName)
  pCurr[sName] = {}; pCurr[sName][keyOb] = pNode
  pNode:SetTooltip(GetPhrase("tool."..sTool..".category"))
  pNode.Icon:SetImage(ToIcon("category_item"))
  pNode.InternalDoClick = function() end
  pNode.DoClick         = function() return false end
  pNode.DoRightClick    = function() SetClipboardText(pNode:GetText()) end
  pNode.Label:UpdateColours(tSkin)
  pNode:UpdateColours(tSkin)
  return pCurr[sName], pNode
end

function SetDirectoryNode(pnBase, sName, sModel)
  if(not IsValid(pnBase)) then LogInstance("Base invalid "
    ..GetReport2(sName, sModel)); return nil end
  local pNode = pnBase:AddNode(sName)
  if(not IsValid(pNode)) then LogInstance("Node invalid "
    ..GetReport2(sName, sModel)); return nil end
  local tSkin = pnBase:GetSkin()
  local sTool = GetOpVar("TOOLNAME_NL")
  local sModC = GetPhrase("tool."..sTool..".model_con")
  pNode.DoRightClick = function()
    if(inputIsKeyDown(KEY_LSHIFT)) then
      SetClipboardText(sModel)
    else SetClipboardText(sName) end
  end
  pNode:SetTooltip(sModC.." "..sModel)
  pNode.Icon:SetImage(ToIcon("model"))
  pNode.DoClick = function(pnSelf)
    local pnP = pnSelf:GetParent()
    local tpC = pnP:GetSelectedChildren()
    for key, val in pairs(tpC) do
      val:UpdateColours(tSkin)
      val.Label:UpdateColours(tSkin)
    end
    SetAsmConvar(nil, "model"  , sModel)
    SetAsmConvar(nil, "pointid", 1)
    SetAsmConvar(nil, "pnextid", 2)
  end
  pNode.Label:UpdateColours(tSkin)
  pNode:UpdateColours(tSkin)
  return pNode
end

local function PushSortValues(tTable,snCnt,nsValue,tData)
  local iCnt, iInd = mathFloor(tonumber(snCnt) or 0), 1
  if(not (tTable and IsTable(tTable) and (iCnt > 0))) then return 0 end
  if(not tTable[iInd]) then
    tTable[iInd] = {Value = nsValue, Table = tData }; return iInd
  else
    while(tTable[iInd] and (tTable[iInd].Value < nsValue)) do iInd = iInd + 1 end
    if(iInd > iCnt) then return iInd end
    while(iInd < iCnt) do
      tTable[iCnt] = tTable[iCnt - 1]
      iCnt = iCnt - 1
    end; tTable[iInd] = { Value = nsValue, Table = tData }; return iInd
  end
end

function GetFrequentModels(snCount)
  local snCount = (tonumber(snCount) or 0); if(snCount < 1) then
    LogInstance("Count not applicable"); return nil end
  local makTab = GetBuilderNick("PIECES"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  local tCache = libCache[defTab.Name]; if(not IsHere(tCache)) then
    LogInstance("Missing table cache space"); return nil end
  local frUsed = GetOpVar("TABLE_FREQUENT_MODELS")
  local iInd, tmNow = 1, Time(); tableEmpty(frUsed)
  for mod, rec in pairs(tCache) do
    if(IsHere(rec.Used) and IsHere(rec.Size) and rec.Size > 0) then
      iInd = PushSortValues(frUsed,snCount,tmNow-rec.Used,{
               [makTab:GetColumnName(1)] = mod,
               [makTab:GetColumnName(2)] = rec.Type,
               [makTab:GetColumnName(3)] = rec.Name,
               [makTab:GetColumnName(4)] = rec.Size
             })
      if(iInd < 1) then LogInstance("Array index out of border"); return nil end
    end
  end
  if(IsHere(frUsed) and IsHere(frUsed[1])) then return frUsed, snCount end
  LogInstance("Array is empty or not available"); return nil
end

function SetButtonSlider(cPanel,sVar,sTyp,nMin,nMax,nDec,tBtn)
  local pPanel = vguiCreate("DSizeToContents"); if(not IsValid(pPanel)) then
    LogInstance("Panel invalid"); return nil end
  local sY, pY, dX, dY = 45, 0, 2, 2; pY = dY
  local sX = GetOpVar("WIDTH_CPANEL")
  local sNam = GetOpVar("TOOLNAME_PL")..sVar
  local sTag = "tool."..GetOpVar("TOOLNAME_NL").."."..sVar
  pPanel:SetParent(cPanel)
  cPanel:InvalidateLayout(true)
  pPanel:SetSize(sX, sY)
  if(IsTable(tBtn) and tBtn[1]) then
    local sPtn = GetOpVar("FORM_LOGBTNSLD")
    local nBtn, iCnt, bX, bY = #tBtn, 1, dX, pY
    local wB, hB = ((sX - ((nBtn + 1) * dX)) / nBtn), 20
    while(tBtn[iCnt]) do local vBtn = tBtn[iCnt]
      local sTxt = tostring(vBtn.Text)
      local pButton = vguiCreate("DButton"); if(not IsValid(pButton)) then
        LogInstance(sPtn:format(sVar,sTxt,"Panel invalid")); return nil end
      pButton:SetParent(pPanel)
      pButton:InvalidateLayout(true)
      pButton:SizeToContents()
      pButton:SetText(sTxt)
      if(vBtn.Tip) then pButton:SetTooltip(tostring(vBtn.Tip)) end
      pButton:SetPos(bX, bY)
      pButton:SetSize(wB, hB)
      pButton.DoClick = function()
        local pS, sE = pcall(vBtn.Click, pButton, sVar, GetAsmConvar(sVar, sTyp))
        if(not pS) then LogInstance(sPtn:format(sVar,sTxt,"Error: "..sE)); return nil end
      end
      pButton:SetVisible(true)
      bX, iCnt = (bX + (wB + dX)), (iCnt + 1)
    end; pY = pY + (dY + hB)
  end
  local pSlider = vguiCreate("DNumSlider"); if(not IsValid(pSlider)) then
    LogInstance("Slider invalid"); return nil end
  pSlider:SetParent(pPanel)
  pSlider:InvalidateLayout(true)
  pSlider:SizeToContents()
  pSlider:SetPos(0, pY)
  pSlider:SetSize(sX-2*dX, sY-pY-dY)
  pSlider:SetText(GetPhrase(sTag.."_con"))
  pSlider:SetTooltip(GetPhrase(sTag))
  pSlider:SetMin(nMin)
  pSlider:SetMax(nMax)
  pSlider:SetDecimals(nDec)
  pSlider:SetDark(true)
  pSlider:SetConVar(sNam)
  pSlider:SetVisible(true)
  pPanel:InvalidateChildren()
  pPanel:SizeToContents()
  pPanel:SizeToChildren(true, false)
  cPanel:AddPanel(pPanel)
  return pPanel
end

function SetCenter(oEnt, vPos, aAng, nX, nY, nZ) -- Set the ENT's Angles first!
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity Invalid"); return Vector(0,0,0) end
  oEnt:SetPos(vPos); oEnt:SetAngles(aAng)
  local vCen, vMin = oEnt:OBBCenter(), oEnt:OBBMins()
  NegVector(vCen); vCen[cvZ] = 0 -- Adjust only X and Y
  AddVectorXYZ(vCen, nX, -nY, nZ-vMin[cvZ])
  vCen:Rotate(aAng); vCen:Add(vPos); oEnt:SetPos(vCen)
  return vCen -- Returns X-Y OBB centered model
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

function SnapReview(ivPoID, ivPnID, ivMaxN)
  local iMaxN = (tonumber(ivMaxN) or 0)
  local iPoID = (tonumber(ivPoID) or 0)
  local iPnID = (tonumber(ivPnID) or 0)
  if(iMaxN <= 0) then return 1, 2 end
  if(iPoID <= 0) then return 1, 2 end
  if(iPnID <= 0) then return 1, 2 end
  if(iPoID  > iMaxN) then return 1, 2 end
  if(iPnID  > iMaxN) then return 1, 2 end -- One active point
  if(iPoID == iPnID) then return 1, 2 end
  return iPoID, iPnID
end

function SwitchID(vID,vDir,oRec)
  local stPOA, ID = LocatePOA(oRec,vID); if(not IsHere(stPOA)) then
    LogInstance("ID missing "..GetReport(vID)); return 1 end
  local nDir = (tonumber(vDir) or 0); nDir = (((nDir > 0) and 1) or ((nDir < 0) and -1) or 0)
  if(nDir == 0) then LogInstance("Direction mismatch"); return ID end
  ID = GetWrap(ID + nDir,1,oRec.Size) -- Move around the snap location selected
  stPOA = LocatePOA(oRec,ID); if(not IsHere(stPOA)) then
    LogInstance("Offset missing "..GetReport(ID)); return 1 end
  return ID
end

function GetPointElevation(oEnt,ivPoID)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity Invalid"); return nil end
  local sModel = oEnt:GetModel() -- Read the model
  local hdRec = CacheQueryPiece(sModel); if(not IsHere(hdRec)) then
    LogInstance("Record not found for <"..sModel..">"); return nil end
  local hdPnt, iPoID = LocatePOA(hdRec,ivPoID); if(not IsHere(hdPnt)) then
    LogInstance("Point missing "..GetReport(ivPoID).." on <"..sModel..">"); return nil end
  if(not (hdPnt.O and hdPnt.A)) then
    LogInstance("POA missing "..GetReport(ivPoID).." for <"..sModel..">"); return nil end
  local aDiffBB, vDiffBB = Angle(), oEnt:OBBMins()
  SetAngle(aDiffBB,hdPnt.A) ; aDiffBB:RotateAroundAxis(aDiffBB:Up(),180)
  SubVector(vDiffBB,hdPnt.O); BasisVector(vDiffBB,aDiffBB)
  return mathAbs(vDiffBB[cvZ])
end

function GetBeautifyName(sName)
  local sDiv = GetOpVar("OPSYM_DIVIDER")
  local fCon = GetOpVar("MODELNAM_FUNC")
  local sNam = tostring(sName or ""):lower():Trim()
  return ("_"..sNam):gsub(sDiv.."%w", fCon):sub(2,-1)
end

function ModelToName(sModel, bNoSet)
  if(not IsString(sModel)) then
    LogInstance("Argument mismatch "..GetReport(sModel)); return "" end
  if(IsBlank(sModel)) then LogInstance("Empty string"); return "" end
  local sSymDiv, sSymDir = GetOpVar("OPSYM_DIVIDER"), GetOpVar("OPSYM_DIRECTORY")
  local sModel = (sModel:sub(1, 1) ~= sSymDir) and (sSymDir..sModel) or sModel
        sModel = (stringGetFileName(sModel):gsub(GetOpVar("MODELNAM_FILE"),""))
  local gModel = (sModel:sub(1,-1)) -- Create a copy so we can select cut-off parts later
  if(not bNoSet) then local iCnt, iNxt
    local tCut, tSub, tApp = ModelToNameRule("GET")
    if(tCut and tCut[1]) then iCnt, iNxt = 1, 2
      while(tCut[iCnt] and tCut[iNxt]) do
        local fNu, bNu = tonumber(tCut[iCnt]), tonumber(tCut[iNxt])
        local fCh, bCh = tostring(tCut[iCnt]), tostring(tCut[iNxt])
        if(not (IsHere(fNu) and IsHere(bNu))) then
          LogInstance("Cut mismatch{"..fCh..","..bCh.."}@"..sModel); return "" end
        gModel = gModel:gsub(sModel:sub(fNu, bNu),""); iCnt, iNxt = (iCnt + 2), (iNxt + 2)
        LogInstance("Cut{"..fCh..","..bCh.."}@"..gModel)
      end
    end -- Replace the unneeded parts by finding an in-string gModel
    if(tSub and tSub[1]) then iCnt, iNxt = 1, 2
      while(tSub[iCnt]) do
        local fCh, bCh = tostring(tSub[iCnt] or ""), tostring(tSub[iNxt] or "")
        gModel = gModel:gsub(fCh,bCh); LogInstance("Sub{"..fCh..","..bCh.."}@"..gModel)
        iCnt, iNxt = (iCnt + 2), (iNxt + 2)
      end
    end -- Append something if needed
    if(tApp and tApp[1]) then
      local fCh, bCh = tostring(tApp[1] or ""), tostring(tApp[2] or "")
      gModel = (fCh..gModel..bCh); LogInstance("App{"..fCh..","..bCh.."}@"..gModel)
    end
  end -- Trigger the capital spacing using the divider ( _aaaaa_bbbb_ccccc )
  return GetBeautifyName(gModel:Trim("_"))
end

--[[
 * Creates a basis instance for entity-related operations
 * The instance is invisible and cannot be hit by traces
 * By default spawns at origin and angle {0,0,0}
 * sModel --> The model to use for creating the entity
 * vPos   --> Custom position for the placeholder ( zero if none )
 * vAng   --> Custom angles for the placeholder ( zero if none )
]]
local function MakeEntityNone(sModel, vPos, vAng) local eNone
  if(SERVER) then eNone = entsCreate(GetOpVar("ENTITY_DEFCLASS"))
  elseif(CLIENT) then eNone = entsCreateClientProp(sModel) end
  if(not (eNone and eNone:IsValid())) then
    LogInstance("Entity invalid @"..sModel); return nil end
  eNone:SetPos(vPos or GetOpVar("VEC_ZERO"))
  eNone:SetAngles(vAng or GetOpVar("ANG_ZERO"))
  eNone:SetCollisionGroup(COLLISION_GROUP_NONE)
  eNone:SetSolid(SOLID_NONE); eNone:SetMoveType(MOVETYPE_NONE)
  eNone:SetNotSolid(true); eNone:SetNoDraw(true); eNone:SetModel(sModel)
  LogInstance("{"..tostring(eNone).."}@"..sModel); return eNone
end

--[[
 * Locates an active point on the piece offset record.
 * This function is used to check the correct offset and return it.
 * It also returns the normalized active point ID if needed
 * oRec   --> Record structure of a track piece
 * ivPoID --> The POA offset ID to check and locate
]]--
function LocatePOA(oRec, ivPoID)
  if(not oRec) then LogInstance("Missing record"); return nil end
  if(not oRec.Offs) then LogInstance("Missing offsets for <"..tostring(oRec.Slot)..">"); return nil end
  local iPoID = tonumber(ivPoID); if(iPoID) then iPoID = mathFloor(iPoID)
    else LogInstance("ID mismatch "..GetReport(ivPoID)); return nil end
  local stPOA = oRec.Offs[iPoID]; if(not IsHere(stPOA)) then
    LogInstance("Missing ID #"..tostring(iPoID).." for <"..tostring(oRec.Slot)..">"); return nil end
  return stPOA, iPoID
end

function ReloadPOA(nXP,nYY,nZR)
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
        arPOA[1] = (tonumber(nXP) or 0)
        arPOA[2] = (tonumber(nYY) or 0)
        arPOA[3] = (tonumber(nZR) or 0)
  return arPOA
end

function IsEqualPOA(staPOA,stbPOA)
  if(not IsHere(staPOA)) then
    LogInstance("Missing offset A"); return false end
  if(not IsHere(stbPOA)) then
    LogInstance("Missing offset B"); return false end
  for kKey, vComp in pairs(staPOA) do
    if(stbPOA[kKey] ~= vComp) then return false end
  end; return true
end

function IsZeroPOA(stPOA,sMode)
  if(not IsString(sMode)) then
    LogInstance("Mode mismatch "..GetReport(sMode)); return nil end
  if(not IsHere(stPOA)) then LogInstance("Missing offset"); return nil end
  local ctA, ctB, ctC = GetIndexes(sMode); if(not (ctA and ctB and ctC)) then
    LogInstance("Missed offset mode "..sMode); return nil end
  return (stPOA[ctA] == 0 and stPOA[ctB] == 0 and stPOA[ctC] == 0)
end

function StringPOA(stPOA,sMode)
  if(not IsString(sMode)) then
    LogInstance("Mode mismatch "..GetReport(sMode)); return nil end
  if(not IsHere(stPOA)) then
    LogInstance("Missing Offsets"); return nil end
  local ctA, ctB, ctC = GetIndexes(sMode); if(not (ctA and ctB and ctC)) then
    LogInstance("Missed offset mode "..sMode); return nil end
  local symSep, sNo = GetOpVar("OPSYM_SEPARATOR"), ""
  local svA = tostring(stPOA[ctA] or sNo)
  local svB = tostring(stPOA[ctB] or sNo)
  local svC = tostring(stPOA[ctC] or sNo)
  return (svA..symSep..svB..symSep..svC):gsub("%s","")
end

function TransferPOA(tData,sMode)
  if(not IsHere(tData)) then
    LogInstance("Destination needed"); return nil end
  if(not IsString(sMode)) then
    LogInstance("Mode mismatch "..GetReport(sMode)); return nil end
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
  local ctA, ctB, ctC = GetIndexes(sMode); if(not (ctA and ctB and ctC)) then
    LogInstance("Missed offset mode <"..sMode..">"); return nil end
  tData[ctA], tData[ctB], tData[ctC] = arPOA[1], arPOA[2], arPOA[3]; return arPOA
end

function DecodePOA(sStr)
  if(not IsString(sStr)) then
    LogInstance("Argument mismatch "..GetReport(sStr)); return nil end
  if(sStr:len() == 0) then return ReloadPOA() end; ReloadPOA()
  local symSep = GetOpVar("OPSYM_SEPARATOR")
  local arPOA  = GetOpVar("ARRAY_DECODEPOA")
  local atPOA  = symSep:Explode(sStr)   -- Read the components
  for iD = 1, arPOA.Size do             -- Apply on all components
    local nCom = tonumber(atPOA[iD])    -- Is the data really a number
    if(not IsHere(nCom)) then nCom = 0  -- If not write zero and report it
      LogInstance("Mismatch <"..sStr..">") end; arPOA[iD] = nCom
  end; return arPOA -- Return the converted string to POA
end

function GetTransformOA(sModel,sKey)
  if(not IsString(sModel)) then
    LogInstance("Model mismatch "..GetReport(sKey)); return nil end
  if(not IsString(sKey)) then
    LogInstance("Key mismatch "..GetReport(sKey)..sModel); return nil end
  local ePiece = GetOpVar("ENTITY_TRANSFORMPOA")
  if(ePiece and ePiece:IsValid()) then -- There is basis entity then update and extract
    if(ePiece:GetModel() ~= sModel) then ePiece:SetModel(sModel)
      LogInstance("Update ["..tostring(ePiece:EntIndex()).."]"..sModel) end
  else -- If there is no basis need to create one for attachment extraction
    ePiece = MakeEntityNone(sModel); if(not (ePiece and ePiece:IsValid())) then
      LogInstance("Basis creation fail @"..sModel); return nil end
    SetOpVar("ENTITY_TRANSFORMPOA", ePiece) -- Register the entity transform basis
  end -- Transfer the data from the transform attachment location
  local mID = ePiece:LookupAttachment(sKey); if(not IsNumber(mID)) then
    LogInstance("Attachment missing ID "..GetReport(sKey)..sModel); return nil end
  local mTOA = ePiece:GetAttachment(mID); if(not IsHere(mTOA)) then
    LogInstance("Attachment missing OA "..GetReport(mID)..sModel); return nil end
  LogInstance("Extract {"..sKey.."}<"..tostring(mTOA.Pos).."><"..tostring(mTOA.Ang)..">")
  return mTOA.Pos, mTOA.Ang -- The function must return transform origin and angle
end

function RegisterPOA(stPiece, ivID, sP, sO, sA)
  local sNull = GetOpVar("MISS_NOSQL"); if(not stPiece) then
    LogInstance("Cache record invalid"); return nil end
  local iID = tonumber(ivID); if(not IsHere(iID)) then
    LogInstance("Offset ID mismatch "..GetReport(ivID)); return nil end
  local sP = (sP or sNull); if(not IsString(sP)) then
    LogInstance("Point mismatch "..GetReport(sP)); return nil end
  local sO = (sO or sNull); if(not IsString(sO)) then
    LogInstance("Origin mismatch "..GetReport(sO)); return nil end
  local sA = (sA or sNull); if(not IsString(sA)) then
    LogInstance("Angle mismatch "..GetReport(sA)); return nil end
  if(not stPiece.Offs) then if(iID > 1) then
    LogInstance("Mismatch ID <"..tostring(iID)..">"..stPiece.Slot); return nil end
    stPiece.Offs = {}
  end
  local tOffs = stPiece.Offs; if(tOffs[iID]) then
    LogInstance("Exists ID #"..tostring(iID)); return nil
  else
    if((iID > 1) and (not tOffs[iID - 1])) then
      LogInstance("No sequential ID #"..tostring(iID - 1)); return nil end
    tOffs[iID] = {}; tOffs[iID].P = {}; tOffs[iID].O = {}; tOffs[iID].A = {}; tOffs = tOffs[iID]
  end; local sE, sD = GetOpVar("OPSYM_ENTPOSANG"), GetOpVar("OPSYM_DISABLE")
  ---------- Origin ----------
  if(sO:sub(1,1) == sD) then ReloadPOA() else
    if(sO:sub(1,1) == sE) then tOffs.O.Slot = sO; sO = sO:sub(2,-1)
      local vO, aA = GetTransformOA(stPiece.Slot, sO)
      if(IsHere(vO)) then ReloadPOA(vO[cvX], vO[cvY], vO[cvZ])
      else -- Decode the transform origin and angle when not applicable
        if(IsNull(sO) or IsBlank(sO)) then ReloadPOA() else
          if(not DecodePOA(sO)) then LogInstance("Origin mismatch ["..iID.."]"..stPiece.Slot) end
      end end -- Decode the transformation when is not null or empty string
    elseif(IsNull(sO) or IsBlank(sO)) then ReloadPOA() else
      if(not DecodePOA(sO)) then LogInstance("Origin mismatch ["..iID.."]"..stPiece.Slot) end
    end
  end; if(not IsHere(TransferPOA(tOffs.O, "V"))) then LogInstance("Origin mismatch"); return nil end
  ---------- Angle ----------
  if(sA:sub(1,1) == sD) then ReloadPOA() else
    if(sA:sub(1,1) == sE) then tOffs.A.Slot = sA; sA = sA:sub(2,-1)
      local vO, aA = GetTransformOA(stPiece.Slot, sA)
      if(IsHere(aA)) then ReloadPOA(aA[caP], aA[caY], aA[caR])
      else -- Decode the transform origin and angle when not applicable
        if(IsNull(sA) or IsBlank(sA)) then ReloadPOA() else
          if(not DecodePOA(sA)) then LogInstance("Angle mismatch ["..iID.."]"..stPiece.Slot) end
      end end -- Decode the transformation when is not null or empty string
    elseif(IsNull(sA) or IsBlank(sA)) then ReloadPOA() else
      if(not DecodePOA(sA)) then LogInstance("Angle mismatch ["..iID.."]"..stPiece.Slot) end
    end
  end; if(not IsHere(TransferPOA(tOffs.A, "A"))) then LogInstance("Angle mismatch"); return nil end
  ---------- Point ----------
  if(sP:sub(1,1) == sD) then
    ReloadPOA(tOffs.O[cvX], tOffs.O[cvY], tOffs.O[cvZ])
  else -- when the point is disabled take the origin
    if(IsNull(sP) or IsBlank(sP)) then
      ReloadPOA(tOffs.O[cvX], tOffs.O[cvY], tOffs.O[cvZ])
    else -- When the point is empty use the origin otherwise decode the value
      if(not DecodePOA(sP)) then LogInstance("Point mismatch ["..iID.."]"..stPiece.Slot) end
    end
  end; if(not IsHere(TransferPOA(tOffs.P, "V"))) then LogInstance("Point mismatch"); return nil end
  return tOffs
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

function Sort(tTable, tCols)
  local tS, iS = {Size = 0}, 0
  local tC = tCols or {}; tC.Size = #tC
  for key, rec in pairs(tTable) do
    iS = (iS + 1); tS[iS] = {}
    tS[iS].Key, tS[iS].Rec = key, rec
    if(IsTable(rec)) then tS[iS].Val = "" -- Allocate sorting value
      if(tC.Size > 0) then -- When there are sorting column names provided
        for iI = 1, tC.Size do local sC = tC[iI]; if(not IsHere(rec[sC])) then
          LogInstance("Key <"..sC.."> not found on the current record"); return nil end
            tS[iS].Val = tS[iS].Val..tostring(rec[sC]) -- Concatenate sort value
        end -- When no sort columns are provided sort by the keys instead
      else tS[iS].Val = key end -- When column list not specified use the key
    else tS[iS].Val = rec end -- When the element is not a table use the value
  end; tS.Size = iS; QuickSort(tS,1,iS); return tS
end

------------- VARIABLE INTERFACES --------------
--[[
 * Returns a string term whrever it is is missing or disabled
 * If these conditions are not met the function returns missing token
 * sBas > The string to check whenever it is disabled or missing
 * vDef > The default value to return when base is not string
 * vDsb > The disable value to return when the base is disabled string
]]
function GetTerm(sBas, vDef, vDsb)
  local sMiss = GetOpVar("MISS_NOAV")
  if(IsString(sBas)) then local sD = GetOpVar("OPSYM_DISABLE")
    if(sBas:sub(1,1) == sD) then return tostring(vDsb or sMiss)
    elseif(not (IsNull(sBas) or IsBlank(sBas))) then return sBas end
  end; if(IsString(vDef)) then return vDef end; return sMiss
end

function ModelToNameRule(sRule, gCut, gSub, gApp)
  if(not IsString(sRule)) then
    LogInstance("Rule mismatch "..GetReport(sRule)); return false end
  if(sRule == "SET") then
    if(gCut and gCut[1]) then SetOpVar("TABLE_GCUT_MODEL",gCut) else SetOpVar("TABLE_GCUT_MODEL",{}) end
    if(gSub and gSub[1]) then SetOpVar("TABLE_GSUB_MODEL",gSub) else SetOpVar("TABLE_GSUB_MODEL",{}) end
    if(gApp and gApp[1]) then SetOpVar("TABLE_GAPP_MODEL",gApp) else SetOpVar("TABLE_GAPP_MODEL",{}) end
  elseif(sRule == "GET") then
    return GetOpVar("TABLE_GCUT_MODEL"), GetOpVar("TABLE_GSUB_MODEL"), GetOpVar("TABLE_GAPP_MODEL")
  elseif(sRule == "CLR") then
    SetOpVar("TABLE_GCUT_MODEL",{}); SetOpVar("TABLE_GSUB_MODEL",{}); SetOpVar("TABLE_GAPP_MODEL",{})
  elseif(sRule == "REM") then
    SetOpVar("TABLE_GCUT_MODEL",nil); SetOpVar("TABLE_GSUB_MODEL",nil); SetOpVar("TABLE_GAPP_MODEL",nil)
  else LogInstance("Wrong mode name "..sRule); return false end
end

function Categorize(oTyp, fCat, iID)
  local tCat = GetOpVar("TABLE_CATEGORIES")
  if(not IsHere(oTyp)) then
    local sTyp = tostring(GetOpVar("DEFAULT_TYPE") or "")
    local tTyp = (tCat and tCat[sTyp] or nil)
    return sTyp, (tTyp and tTyp.Txt), (tTyp and tTyp.Cmp)
  end; ModelToNameRule("CLR"); SetOpVar("DEFAULT_TYPE", tostring(oTyp))
  if(CLIENT) then local tTyp -- Categories for the panel
    local sTyp = tostring(GetOpVar("DEFAULT_TYPE") or "")
    local fsLog = GetOpVar("FORM_LOGSOURCE") -- The actual format value
    local ssLog = "*"..fsLog:format("TYPE","Categorize",tostring(oTyp))
    if(IsString(fCat)) then tCat[sTyp] = {}
      tCat[sTyp].Txt = fCat; tTyp = (tCat and tCat[sTyp] or nil)
      tCat[sTyp].Cmp = CompileString("return ("..fCat..")", sTyp)
      local bS, vO = pcall(tCat[sTyp].Cmp); if(not bS) then
        LogInstance("Compilation failed "..GetReport(fCat)..": "..vO, ssLog); return nil end
      tCat[sTyp].Cmp = vO; tTyp = tCat[sTyp]
      return sTyp, (tTyp and tTyp.Txt), (tTyp and tTyp.Cmp)
    else LogInstance("Skip code "..GetReport(fCat), ssLog) end
  end
end

------------------------- PLAYER -----------------------------------

local function GetPlayerSpot(pPly)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly).."> invalid"); return nil end
  local stSpot = libPlayer[pPly]; if(not IsHere(stSpot)) then
    LogInstance("Cached <"..pPly:Nick()..">")
    libPlayer[pPly] = {}; stSpot = libPlayer[pPly]
  end; return stSpot
end

function GetCacheSpawn(pPly)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end
  local stData = stSpot["SPAWN"]
  if(not IsHere(stData)) then local stSpawn, iD = GetOpVar("STRUCT_SPAWN"), 1
    if(not IsHere(stSpawn)) then LogInstance("Spawn definition invalid"); return false end
    LogInstance("Allocate <"..pPly:Nick()..">"); stSpot["SPAWN"] = {}; stData = stSpot["SPAWN"]
    while(stSpawn[iD]) do local tSec, iK = stSpawn[iD], 1
      while(tSec[iK]) do local def = tSec[iK]
        local key = tostring(def[1] or "")
        local typ = tostring(def[2] or "")
        local inf = tostring(def[3] or "")
        if    (typ == "VEC") then stData[key] = Vector()
        elseif(typ == "ANG") then stData[key] = Angle()
        elseif(typ == "MTX") then stData[key] = Matrix()
        elseif(typ == "RDB") then stData[key] = nil
        elseif(typ == "NUM") then stData[key] = 0
        else LogInstance("Spawn skip "..GetReport3(key,typ,inf))
        end; iK = iK + 1 -- Update members count
      end; iD = iD + 1 -- Update categories count
    end
  end; return stData
end

function CacheClear(pPly, bNow)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly).."> invalid"); return false end
  local stSpot = libPlayer[pPly]; if(not IsHere(stSpot)) then
    LogInstance("Clean"); return true end
  libPlayer[pPly] = nil; if(bNow) then collectgarbage() end; return true
end

function GetDistanceHit(pPly, vHit)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly).."> invalid"); return nil end
  return (vHit - pPly:GetPos()):Length()
end

--[[
 * Used for scaling hit position circle
 * pPly > Player the radius is scaled for
 * vHit > Hit position circle to be scaled
 * nSca > Radius multiplier scaler
]]
function GetCacheRadius(pPly, vHit, nSca)
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
  local nDst = GetDistanceHit(pPly, vHit)
  local nRad = ((nDst ~= 0) and mathClamp((nMar / nDst) * nMul, 1, nLim) or 0)
  return nRad, nDst, nMar, nLim
end

function GetCacheTrace(pPly)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end
  local stData, plyTime = stSpot["TRACE"], Time()
  if(not IsHere(stData)) then -- Define trace delta margin
    LogInstance("Allocate <"..pPly:Nick()..">")
    stSpot["TRACE"] = {}; stData = stSpot["TRACE"]
    stData["NXT"] = plyTime + GetOpVar("TRACE_MARGIN") -- Define next trace pending
    stData["DAT"] = utilGetPlayerTrace(pPly)           -- Get output trace data
    stData["REZ"] = utilTraceLine(stData["DAT"])       -- Make a trace
  end -- Check the trace time margin interval
  if(plyTime >= stData["NXT"]) then
    stData["NXT"] = plyTime + GetOpVar("TRACE_MARGIN") -- Next trace margin
    stData["DAT"] = utilGetPlayerTrace(pPly)           -- Get output trace data
    stData["REZ"] = utilTraceLine(stData["DAT"])       -- Make a trace
  end; return stData["REZ"]
end

function GetCacheCurve(pPly)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end
  local stData = stSpot["CURVE"]
  if(not IsHere(stData)) then -- Allocate curve data
    LogInstance("Allocate <"..pPly:Nick()..">")
    stSpot["CURVE"] = {}; stData = stSpot["CURVE"]
    stData.Node  = {} -- Contains array of node positions for the curve caculation
    stData.Norm  = {} -- Contains array of normal vector for the curve caculation
    stData.Base  = {} -- Contains array of hit positions for the curve caculation
    stData.CNode = {} -- The place where the curve nodes are stored
    stData.CNorm = {} -- The place where the curve normals are stored
    stData.Size  = 0  -- The amount of points for the primary node array
    stData.CSize = 0  -- The amount of points for the calculated nodes array
  end;
  if(not stData.Size) then stData.Size = 0 end
  if(not stData.CSize) then stData.CSize = 0 end
  return stData
end

function Notify(pPly,sText,sNotifType)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly).."> invalid"); return false end
  if(SERVER) then -- Send notification to client that something happened
    pPly:SendLua(GetOpVar("FORM_NTFGAME"):format(sText, sNotifType))
    pPly:SendLua(GetOpVar("FORM_NTFPLAY"):format(mathRandom(1, 4)))
  end; return true
end

function UndoCrate(vMsg)
  SetOpVar("LABEL_UNDO",tostring(vMsg))
  undoCreate(GetOpVar("LABEL_UNDO")); return true
end

function UndoAddEntity(oEnt)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity invalid"); return false end
  undoAddEntity(oEnt); return true
end

function UndoFinish(pPly,vMsg)
  if(not IsPlayer(pPly)) then
    LogInstance("Player <"..tostring(pPly).."> invalid"); return false end
  pPly:EmitSound(GetOpVar("FORM_SNAPSND"):format(mathRandom(1, 3)))
  undoSetCustomUndoText(GetOpVar("LABEL_UNDO")..tostring(vMsg or ""))
  undoSetPlayer(pPly); undoFinish(); return true
end

-------------------------- BUILDSQL ------------------------------

local function CacheStmt(sHash,sStmt,...)
  if(not IsHere(sHash)) then LogInstance("Missing hash"); return nil end
  local sHash, tStore = tostring(sHash), GetOpVar("QUERY_STORE")
  if(not IsHere(tStore)) then LogInstance("Missing storage"); return nil end
  if(IsHere(sStmt)) then -- If the key is located return the query
    tStore[sHash] = tostring(sStmt); LogTable(tStore,"STMT") end
  local sBase = tStore[sHash]; if(not IsHere(sBase)) then
    LogInstance("STMT["..sHash.."] Mismatch"); return nil end
  return sBase:format(...)
end

function GetBuilderNick(sTable)
  if(not IsString(sTable)) then
    LogInstance("Key mismatch "..GetReport(sTable)); return nil end
  local makTab = libQTable[sTable]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder for <"..sTable..">"); return nil end
  if(not makTab:IsValid()) then
    LogInstance("Builder object invalid <"..sTable..">"); return nil end
  return makTab -- Return the dedicated table builder object
end

function GetBuilderID(vID)
  local nID = tonumber(vID); if(not IsHere(nID)) then
    LogInstance("ID mismatch "..GetReport(vID)); return nil end
  if(nID <= 0) then LogInstance("ID invalid "..tostring(nID)); return nil end
  local makTab = GetBuilderNick(libQTable[nID]); if(not IsHere(makTab)) then
    LogInstance("Builder object missing #"..tostring(nID)); return nil end
  return makTab -- Return the dedicated table builder object
end

function CreateTable(sTable,defTab,bDelete,bReload)
  if(not IsString(sTable)) then
    LogInstance("Table nick mismatch "..GetReport(sTable)); return false end
  if(IsBlank(sTable)) then
    LogInstance("Table name must not be empty"); return false end
  if(not IsTable(defTab)) then
    LogInstance("Table definition missing for "..sTable); return false end
  defTab.Nick = sTable:upper(); defTab.Name = GetOpVar("TOOLNAME_PU")..defTab.Nick
  defTab.Size = #defTab; if(defTab.Size <= 0) then
    LogInstance("Record definition missing for ", defTab.Nick); return false end
  if(defTab.Size ~= tableMaxn(defTab)) then
    LogInstance("Record definition mismatch for ", defTab.Nick); return false end
  for iCnt = 1, defTab.Size do local defRow = defTab[iCnt]
    local sN = tostring(defRow[1] or ""); if(IsBlank(sN)) then
      LogInstance("Missing table column name "..GetReport(iCnt), defTab.Nick); return false end
    local sT = tostring(defRow[2] or ""); if(IsBlank(sT)) then
      LogInstance("Missing table column type "..GetReport(iCnt), defTab.Nick); return false end
    defRow[1], defRow[2] = sN, sT -- Convert settings to string and store back
  end
  local self, tabDef, tabCmd = {}, defTab, {}
  local symDis, sMoDB = GetOpVar("OPSYM_DISABLE"), GetOpVar("MODE_DATABASE")
  for iCnt = 1, defTab.Size do local defCol = defTab[iCnt]
    defCol[3] = GetTerm(tostring(defCol[3] or symDis), symDis)
    defCol[4] = GetTerm(tostring(defCol[4] or symDis), symDis)
  end; tableInsert(libQTable, defTab.Nick)
  libCache[defTab.Name] = {}; libQTable[defTab.Nick] = self
  -- Read table definition
  function self:GetDefinition(vK)
    if(vK) then return tabDef[vK] end; return tabDef
  end
  -- Reads the requested command or returns the whole list
  function self:GetCommand(vK)
    if(vK) then return tabCmd[vK] end; return tabCmd
  end
  -- Alias for reading the last created SQL statement
  function self:Get(vK)
    local qtCmd = self:GetCommand()
    local iK = (vK or qtCmd.STMT); return qtCmd[iK]
  end
  -- Returns ID of the found column valid > 0
  function self:GetColumnID(sN)
    local sN, qtDef = tostring(sN or ""), self:GetDefinition()
    for iD = 1, qtDef.Size do if(qtDef[iD][1] == sN) then return iD end
    end; LogInstance("Mismatch "..GetReport(sN), tabDef.Nick); return 0
  end
  -- Returns the name of the found column
  function self:GetColumnName(vD)
    local iD = (tonumber(vD) or 0)
    local qtDef = self:GetDefinition()
    local qtCol = qtDef[iD]; if(qtCol) then return qtCol[1] end
    LogInstance("Mismatch "..GetReport(vD), tabDef.Nick); return nil
  end
  -- Returns the colomn information by the given ID > 0
  function self:GetColumnInfo(vD, vI)
    local iD = (tonumber(vD) or 0)
    local qtDef = self:GetDefinition()
    local qtCol, iI = qtDef[iD], (tonumber(vI) or 0)
    if(qtCol) then local qtInf = qtCol[iI]
      if(vI and qtInf) then return qtInf end; return qtCol
    end; LogInstance("Mismatch "..GetReport(vD), tabDef.Nick); return nil
  end
  -- Returns the row with swapped column names to indexes
  function self:GetArrayRow(tR, bM) local tA = {} -- Store the values here
    for key, val in pairs(tR) do -- Column name tables are not ordered
      local iD = self:GetColumnID(key); if(iD > 0) then tA[iD] = val
      else LogInstance("Mismatch "..GetReport(key), tabDef.Nick) end
    end; return tA
  end
  -- Removes the object from the list
  function self:Remove(vRet)
    local qtDef = self:GetDefinition()
    libQTable[qtDef.Nick] = nil
    collectgarbage(); return vRet
  end
  -- Generates a timer settings table and keeps the defaults
  function self:TimerSetup(vTim)
    local qtCmd, qtDef = self:GetCommand(), self:GetDefinition()
    local sTm = tostring((vTim and vTim or qtDef.Timer) or "")
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
      LogInstance("Missing keys",tabDef.Nick); return nil end
    local oSpot, kKey, iCnt = libCache, tKey[1], 1
    while(tKey[iCnt]) do kKey = tKey[iCnt]; iCnt = iCnt + 1
      if(tKey[iCnt]) then oSpot = oSpot[kKey]; if(not IsHere(oSpot)) then
        LogTable(tKey,"Diverge("..tostring(kKey)..")",tabDef.Nick); return nil
    end; end; end; if(not oSpot[kKey]) then
      LogTable(tKey,"Missing",tabDef.Nick); return nil end
    return oSpot, kKey, tKey
  end
  -- Attaches timer to a record related in the table cache
  function self:TimerAttach(vMsg, ...)
    local sMoDB, oSpot, kKey, tKey = GetOpVar("MODE_DATABASE"), self:GetNavigate(...)
    if(not (IsHere(oSpot) and IsHere(kKey))) then
      LogInstance("Navigation failed",tabDef.Nick); return nil end
    LogInstance("Called by <"..tostring(vMsg).."> for ["..tostring(kKey).."]",tabDef.Nick)
    if(sMoDB == "SQL") then local qtCmd = self:GetCommand() -- Read the command and current time
      local nNow, tTim = Time(), qtCmd.Timer; if(not IsHere(tTim)) then
        LogInstance("Missing timer settings",tabDef.Nick); return oSpot[kKey] end
      oSpot[kKey].Used = nNow -- Make the first selected deletable to avoid phantom records
      local smTM, tmLif, tmDie, tmCol = tTim[1], tTim[2], tTim[3], tTim[4]; if(tmLif <= 0) then
        LogInstance("Timer attachment ignored",tabDef.Nick); return oSpot[kKey] end
      LogInstance("["..smTM.."] ("..tmLif..") "..tostring(tmDie)..", "..tostring(tmCol),tabDef.Nick)
      if(smTM == "CQT") then
        for k, v in pairs(oSpot) do
          if(IsHere(v.Used) and ((nNow - v.Used) > tmLif)) then
            LogInstance("("..tostring(mathRound(nNow - v.Used,2)).." > "..tmLif..") > Dead",tabDef.Nick)
            if(tmDie) then oSpot[k] = nil; LogInstance("Killed <"..tostring(k)..">",tabDef.Nick) end
          end
        end
        if(tmCol) then collectgarbage(); LogInstance("Garbage collected",tabDef.Nick) end
        LogInstance("["..tostring(kKey).."] @"..tostring(mathRound(nNow,2)),tabDef.Nick); return oSpot[kKey]
      elseif(smTM == "OBJ") then
        local tmID = GetOpVar("OPSYM_DIVIDER"):Implode(tKey)
        LogInstance("TimID <"..tmID..">",tabDef.Nick)
        if(timerExists(tmID)) then LogInstance("Timer exists",tabDef.Nick); return oSpot[kKey] end
        timerCreate(tmID, tmLif, 1, function()
          LogInstance("["..tmID.."]("..tmLif..") > Dead",tabDef.Nick)
          if(tmDie) then oSpot[kKey] = nil; LogInstance("Killed <"..kKey..">",tabDef.Nick) end
          timerStop(tmID); timerRemove(tmID)
          if(tmCol) then collectgarbage(); LogInstance("Garbage collected",tabDef.Nick) end
        end); timerStart(tmID); return oSpot[kKey]
      else LogInstance("Mode mismatch <"..smTM..">",tabDef.Nick); return oSpot[kKey] end
    elseif(sMoDB == "LUA") then
      LogInstance("Memory manager impractical",tabDef.Nick); return oSpot[kKey]
    else LogInstance("Wrong database mode",tabDef.Nick); return nil end
  end
  -- Restarts timer to a record related in the table cache
  function self:TimerRestart(vMsg, ...)
    local sMoDB, oSpot, kKey, tKey = GetOpVar("MODE_DATABASE"), self:GetNavigate(...)
    if(not (IsHere(oSpot) and IsHere(kKey))) then
      LogInstance("Navigation failed",tabDef.Nick); return nil end
    LogInstance("Called by <"..tostring(vMsg).."> for ["..tostring(kKey).."]",tabDef.Nick)
    if(sMoDB == "SQL") then local qtCmd = self:GetCommand()
      local tTim = qtCmd.Timer; if(not IsHere(tTim)) then
        LogInstance("Missing timer settings",tabDef.Nick); return oSpot[kKey] end
      oSpot[kKey].Used = Time() -- Mark the current caching time stamp
      local smTM, tmLif = tTim[1], tTim[2]; if(tmLif <= 0) then
        LogInstance("Timer life ignored",tabDef.Nick); return oSpot[kKey] end
      if(smTM == "CQT") then smTM = "CQT"
      elseif(smTM == "OBJ") then -- Just for something to do here and to be known that this is mode CQT
        local kID = GetOpVar("OPSYM_DIVIDER"):Implode(tKeys); if(not timerExists(kID)) then
          LogInstance("Timer missing <"..kID..">",tabDef.Nick); return nil end
        timerStart(kID)
      else LogInstance("Mode mismatch <"..smTM..">",tabDef.Nick); return nil end
    elseif(sMoDB == "LUA") then oSpot[kKey].Used = Time()
    else LogInstance("Wrong database mode",tabDef.Nick); return nil end
    return oSpot[kKey]
  end
  -- Object internal data validation
  function self:IsValid() local bStat = true
    local qtCmd = self:GetCommand(); if(not qtCmd) then
      LogInstance("Missing commands <"..defTab.Nick..">",tabDef.Nick); bStat = false end
    local qtDef = self:GetDefinition(); if(not qtDef) then
      LogInstance("Missing definition",tabDef.Nick); bStat = false end
    if(qtDef.Size ~= #qtDef) then
      LogInstance("Mismatch count",tabDef.Nick); bStat = false end
    if(qtDef.Size ~= tableMaxn(qtDef)) then
      LogInstance("Mismatch maxN",tabDef.Nick); bStat = false end
    if(defTab.Nick:upper() ~= defTab.Nick) then
      LogInstance("Nick lower",tabDef.Nick); bStat = false end
    if(defTab.Name:upper() ~= defTab.Name) then
      LogInstance("Name lower <"..defTab.Name..">",tabDef.Nick); bStat = false end
    local nS, nE = defTab.Name:find(defTab.Nick); if(not (nS and nE and nS > 1 and nE == defTab.Name:len())) then
      LogInstance("Mismatch <"..defTab.Name..">",tabDef.Nick); bStat = false end
    for iD = 1, qtDef.Size do local tCol = qtDef[iD] if(not IsTable(tCol)) then
        LogInstance("Mismatch type ["..iD.."]",tabDef.Nick); bStat = false end
      if(not IsString(tCol[1])) then
        LogInstance("Mismatch name ["..iD.."]",tabDef.Nick); bStat = false end
      if(not IsString(tCol[2])) then
        LogInstance("Mismatch type ["..iD.."]",tabDef.Nick); bStat = false end
      if(tCol[3] and not IsString(tCol[3])) then
        LogInstance("Mismatch ctrl ["..iD.."]",tabDef.Nick); bStat = false end
      if(tCol[4] and not IsString(tCol[4])) then
        LogInstance("Mismatch conv ["..iD.."]",tabDef.Nick); bStat = false end
    end; return bStat -- Succesfully validated the builder table
  end
  -- Creates table column list as string
  function self:GetColumnList(sD)
    if(not IsHere(sD)) then return "" end
    local qtDef, sRes, iCnt = self:GetDefinition(), "", 1
    local sD = tostring(sD or "\t"):sub(1,1); if(IsBlank(sD)) then
      LogInstance("Missing delimiter",tabDef.Nick); return "" end
    while(iCnt <= qtDef.Size) do
      sRes, iCnt = (sRes..qtDef[iCnt][1]), (iCnt + 1)
      if(qtDef[iCnt]) then sRes = sRes..sD end
    end; return sRes
  end
  -- Internal type matching
  function self:Match(snValue,ivID,bQuoted,sQuote,bNoRev,bNoNull)
    local qtDef, sNull = self:GetDefinition(), GetOpVar("MISS_NOSQL")
    local nvInd = tonumber(ivID); if(not IsHere(nvInd)) then
      LogInstance("Column ID mismatch "..GetReport(ivID),tabDef.Nick); return nil end
    local defCol = qtDef[nvInd]; if(not IsHere(defCol)) then
      LogInstance("Invalid col #"..tostring(nvInd),tabDef.Nick); return nil end
    local tipCol, sMoDB, snOut = tostring(defCol[2]), GetOpVar("MODE_DATABASE")
    if(tipCol == "TEXT") then snOut = tostring(snValue or "")
      if(not bNoNull and IsBlank(snOut)) then
        if    (sMoDB == "SQL") then snOut = sNull
        elseif(sMoDB == "LUA") then snOut = sNull
        else LogInstance("Wrong database empty mode <"..sMoDB..">",tabDef.Nick); return nil end
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
          else LogInstance("Wrong database quote mode <"..sMoDB..">",tabDef.Nick); return nil end
        end; snOut = sqChar..snOut..sqChar
      end
    elseif(tipCol == "REAL" or tipCol == "INTEGER") then
      snOut = tonumber(snValue)
      if(IsHere(snOut)) then
        if(tipCol == "INTEGER") then
          if    (defCol[3] == "FLR") then snOut = mathFloor(snOut)
          elseif(defCol[3] == "CEL") then snOut = mathCeil (snOut) end
        end
      else LogInstance("Failed converting "..GetReport(snValue).." to NUMBER col #"..nvInd,tabDef.Nick); return nil end
    else LogInstance("Invalid col type <"..tipCol..">",tabDef.Nick); return nil
    end; return snOut
  end
  -- Build drop statment
  function self:Drop()
    local qtDef = self:GetDefinition()
    local qtCmd = self:GetCommand(); qtCmd.STMT = "Drop"
    local qsKey = GetOpVar("FORM_KEYSTMT"):format(qtCmd.STMT, "")
    local sStmt = CacheStmt(qsKey, nil, qtDef.Name)
    if(not sStmt) then sStmt = CacheStmt(qsKey, "DROP TABLE %s;", qtDef.Name) end
    qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- Build delete statment
  function self:Delete()
    local qtDef = self:GetDefinition()
    local qtCmd = self:GetCommand(); qtCmd.STMT = "Delete"
    local qsKey = GetOpVar("FORM_KEYSTMT"):format(qtCmd.STMT, "")
    local sStmt = CacheStmt(qsKey, nil, qtDef.Name)
    if(not sStmt) then sStmt = CacheStmt(qsKey, "DELETE FROM %s;", qtDef.Name) end
    qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- Bhttps://wiki.garrysmod.com/page/sql/Begin
  function self:Begin()
    local qtCmd = self:GetCommand()
    qtCmd.Begin = "BEGIN;"; return self
  end
  -- https://wiki.garrysmod.com/page/sql/Commit
  function self:Commit()
    local qtCmd = self:GetCommand()
    qtCmd.Commit = "COMMIT;"; return self
  end
  -- Build create/drop/delete statment table of statemenrts
  function self:Create()
    local qtDef = self:GetDefinition()
    local qtCmd, iInd = self:GetCommand(), 1; qtCmd.STMT = "Create"
    qtCmd.Create = "CREATE TABLE "..qtDef.Name.." ( "
    while(qtDef[iInd]) do local v = qtDef[iInd]
      if(not v[1]) then LogInstance("Missing col name #"..tostring(iInd),tabDef.Nick); return nil end
      if(not v[2]) then LogInstance("Missing col type #"..tostring(iInd),tabDef.Nick); return nil end
      qtCmd.Create = qtCmd.Create..(v[1]):upper().." "..(v[2]):upper()
      iInd = (iInd + 1); if(qtDef[iInd]) then qtCmd.Create = qtCmd.Create ..", " end
    end
    qtCmd.Create = qtCmd.Create.." );"; return self
  end
  -- Build SQL table indexes
  function self:Index(...) local tIndex = {...}
    local qtCmd, qtDef = self:GetCommand(), self:GetDefinition()
    if(not (IsTable(tIndex) and tIndex[1])) then
      tIndex = qtDef.Index end -- Empty stack use table definition
    if(IsTable(qtCmd.Index)) then tableEmpty(qtCmd.Index)
      else qtCmd.Index = {} end; local iCnt, iInd = 1, 1
    while(tIndex[iInd]) do -- Build index query and reload index commands
      local vI = tIndex[iInd]; if(not IsTable(vI)) then
        LogInstance("Mismatch value ["..tostring(vI).."] not table for ID ["..tostring(iInd).."]",tabDef.Nick); return nil end
      local cU, cC = "", ""; qtCmd.Index[iInd], iCnt = "CREATE INDEX IND_"..qtDef.Name, 1
      while(vI[iCnt]) do local vF = tonumber(vI[iCnt]); if(not vF) then
          LogInstance("Mismatch value ["..tostring(vI[iCnt]).."] NaN for ID ["..tostring(iInd).."]["..tostring(iCnt).."]",tabDef.Nick); return nil end
        if(not qtDef[vF]) then
          LogInstance("Mismatch. The col ID #"..tostring(vF).." missing, max is #"..Table.Size,tabDef.Nick); return nil end
        cU, cC = (cU.."_" ..(qtDef[vF][1]):upper()), (cC..(qtDef[vF][1]):upper()); vI[iCnt] = vF
        iCnt = iCnt + 1; if(vI[iCnt]) then cC = cC ..", " end
      end
      qtCmd.Index[iInd] = qtCmd.Index[iInd]..cU.." ON "..qtDef.Name.." ( "..cC.." );"
      iInd = iInd + 1
    end; return self
  end
  -- Build SQL select statement
  function self:Select(...)
    local qtCmd = self:GetCommand()
    local qtDef = self:GetDefinition(); qtCmd.STMT = "Select"
    local sStmt, iCnt, tCols = "SELECT ", 1, {...}
    if(tCols[1]) then
      while(tCols[iCnt]) do
        local v = tonumber(tCols[iCnt]); if(not IsHere(v)) then
          LogInstance("Index type mismatch "..GetReport(tCols[iCnt]),tabDef.Nick); return nil end
        if(not qtDef[v]) then
          LogInstance("Missing col by index #"..tostring(v),tabDef.Nick); return nil end
        if(qtDef[v][1]) then sStmt = sStmt..qtDef[v][1]
        else LogInstance("Missing col name by index #"..tostring(v),tabDef.Nick); return nil end
        iCnt = (iCnt + 1); if(tCols[iCnt]) then sStmt = sStmt ..", " end
      end
    else sStmt = sStmt.."*" end
    qtCmd.Select = sStmt .." FROM "..qtDef.Name..";"; return self
  end
  -- Add where clause to the select statement
  function self:Where(...) local tWhere = {...}
    if(not tWhere[1]) then return self end
    local iCnt, qtDef, qtCmd = 1, self:GetDefinition(), self:GetCommand()
    local sStmt = qtCmd.Select:Trim("%s"):Trim(";")
    while(tWhere[iCnt]) do local k = tonumber(tWhere[iCnt][1])
      local v, t = tWhere[iCnt][2], qtDef[k][2]; if(not (k and v and t) ) then
        LogInstance("Where clause inconsistent col index, {"..tostring(k)..","..tostring(v)..","..tostring(t).."}",tabDef.Nick); return nil end
      if(not IsHere(v)) then
        LogInstance("Data matching failed index #"..tostring(iCnt).." value <"..tostring(v)..">",tabDef.Nick); return nil end
      if(iCnt == 1) then sStmt = sStmt.." WHERE "..qtDef[k][1].." = "..tostring(v)
      else               sStmt = sStmt.." AND "  ..qtDef[k][1].." = "..tostring(v) end
      iCnt = iCnt + 1
    end; qtCmd.Select = sStmt..";"; return self
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
      else LogInstance("Mismatch col index #"..tostring(iCnt),tabDef.Nick); return nil end
      sStmt, iCnt = (sStmt..qtDef[v][1]..sDir), (iCnt + 1)
      if(tOrder[iCnt]) then sStmt = sStmt..", " end
    end; qtCmd.Select = qtCmd.Select..sStmt..";" return self
  end
  -- Build SQL insert statement
  function self:Insert(...)
    local qtCmd, iCnt, qIns = self:GetCommand(), 1, ""
    local tInsert, qtDef = {...}, self:GetDefinition(); qtCmd.STMT = "Insert"
    local sStmt = "INSERT INTO "..qtDef.Name.." ( "
    if(not tInsert[1]) then
      for iCnt = 1, qtDef.Size do qIns = qIns..qtDef[iCnt][1]
        if(iCnt < qtDef.Size) then qIns = qIns..", " else qIns = qIns.." ) " end end
    else
      while(tInsert[iCnt]) do local vInd = tInsert[iCnt]
        local iIns = tonumber(vInd); if(not IsHere(iIns)) then
          LogInstance("Column ID ["..tostring(vInd).."] NaN",tabDef.Nick); return nil end
        local cIns = qtDef[iIns]; if(not IsHere(cIns)) then
          LogInstance("Column ID ["..tostring(iIns).."] mismatch",tabDef.Nick); return nil end
        iCnt, qIns = (iCnt + 1), qIns..cIns[1]
        if(tInsert[iCnt]) then qIns = qIns..", " else qIns = qIns.." ) " end
      end
    end; qtCmd.Insert = sStmt..qIns; return self
  end
  -- Build SQL values statement
  function self:Values(...)
    local qtDef, tValues = self:GetDefinition(), {...}
    local qtCmd, iCnt, qVal = self:GetCommand(), 1, ""
    local sStmt = qtCmd.Insert.." VALUES ( "
    while(tValues[iCnt]) do
      iCnt, qVal = (iCnt + 1), qVal..tostring(tValues[iCnt])
      if(tValues[iCnt]) then qVal = qVal..", " else qVal = qVal.." )" end
    end; qtCmd.Insert = sStmt..qVal..";"; return self
  end
  -- Uses the given array to create a record in the table
  function self:Record(arLine)
    local qtDef, sMoDB, sFunc = self:GetDefinition(), GetOpVar("MODE_DATABASE"), "Record"
    if(not arLine) then LogInstance("Missing data table",tabDef.Nick); return false end
    if(not arLine[1]) then LogInstance("Missing PK",tabDef.Nick)
      for key, val in pairs(arLine) do
        LogInstance("PK data ["..tostring(key).."] = <"..tostring(val)..">",tabDef.Nick) end
      return false -- Print all other values when the model is missing
    end -- Read the log source format and reduce the number of concatenations
    local fsLog = GetOpVar("FORM_LOGSOURCE") -- The actual format value
    local ssLog = "*"..fsLog:format(qtDef.Nick,sFunc,"%s")
    -- Call the trigger when provided
    if(IsTable(qtDef.Trigs)) then local bS, sR = pcall(qtDef.Trigs[sFunc], arLine, ssLog:format("Trigs"))
      if(not bS) then LogInstance("Trigger manager "..sR,tabDef.Nick); return false end
      if(not sR) then LogInstance("Trigger routine fail",tabDef.Nick); return false end
    end -- Populate the data after the trigger does its thing
    if(sMoDB == "SQL") then local qsKey = GetOpVar("FORM_KEYSTMT")
      for iD = 1, qtDef.Size do arLine[iD] = self:Match(arLine[iD],iD,true) end
      local Q = CacheStmt(qsKey:format(sFunc, qtDef.Nick), nil, unpack(arLine))
      if(not Q) then local sStmt = self:Insert():Values(unpack(qtDef.Query[sFunc])):Get()
        if(not IsHere(sStmt)) then LogInstance("Build statement failed",tabDef.Nick); return nil end
        Q = CacheStmt(qsKey:format(sFunc, qtDef.Nick), sStmt, unpack(arLine))
      end -- The query is built based on table definition
      if(not IsHere(Q)) then
        LogInstance("Internal cache error",tabDef.Nick); return false end
      local qRez = sqlQuery(Q); if(not qRez and IsBool(qRez)) then
         LogInstance("Execution error <"..sqlLastError().."> Query ran <"..Q..">",tabDef.Nick); return false end
      return true -- The dynamic statement insertion was successful
    elseif(sMoDB == "LUA") then local snPK = self:Match(arLine[1],1)
      if(not IsHere(snPK)) then -- If primary key becomes a number
        LogInstance("Primary key mismatch <"..tostring(arLine[1]).."> to "..qtDef[1][1].." for "..tostring(snPK),tabDef.Nick); return nil end
      local tCache = libCache[qtDef.Name]; if(not IsHere(tCache)) then
        LogInstance("Cache missing",tabDef.Nick); return false end
      if(not IsTable(qtDef.Cache)) then
        LogInstance("Cache manager missing",tabDef.Nick); return false end
      local bS, sR = pcall(qtDef.Cache[sFunc], self, tCache, snPK, arLine, ssLog:format("Cache"))
      if(not bS) then LogInstance("Cache manager fail "..sR,tabDef.Nick); return false end
      if(not sR) then LogInstance("Cache routine fail",tabDef.Nick); return false end
    else LogInstance("Wrong database mode <"..sMoDB..">",tabDef.Nick); return false end
    return true -- The dynamic cache population was successful
  end
  -- When database mode is SQL create a table in sqlite
  if(sMoDB == "SQL") then local makTab
    makTab = self:Create(); if(not IsHere(makTab)) then
      LogInstance("Build create failed"); return self:Remove(false) end
    makTab = self:Index(); if(not IsHere(makTab)) then
      LogInstance("Build index failed"); return self:Remove(false) end
    makTab = self:Drop(); if(not IsHere(makTab)) then
      LogInstance("Build drop failed"); return self:Remove(false) end
    makTab = self:Delete(); if(not IsHere(makTab)) then
      LogInstance("Build delete failed"); return self:Remove(false) end
    makTab = self:Begin(); if(not IsHere(makTab)) then
      LogInstance("Build begin failed"); return self:Remove(false) end
    makTab = self:Commit(); if(not IsHere(makTab)) then
      LogInstance("Build commit failed"); return self:Remove(false) end
    makTab = self:TimerSetup(); if(not IsHere(makTab)) then
      LogInstance("Build timer failed"); return self:Remove(false) end
    local tQ = self:GetCommand(); if(not IsHere(tQ)) then
      LogInstance("Build statement failed"); return self:Remove(false) end
    -- When enabled forces a table drop
    if(bReload) then
      if(sqlTableExists(defTab.Name)) then local qRez = sqlQuery(tQ.Drop)
        if(not qRez and IsBool(qRez)) then -- Remove table when SQL error is present
          LogInstance("Table drop fail: "..sqlLastError().." Query > "..tQ.Drop,tabDef.Nick)
          return self:Remove(false) -- Remove table when SQL error is present
        else LogInstance("Table drop success",tabDef.Nick) end
      else LogInstance("Table drop skipped",tabDef.Nick) end
    end
    -- Create the table using the given name and properties
    if(sqlTableExists(defTab.Name)) then
      LogInstance("Table create skipped",tabDef.Nick)
    else local qRez = sqlQuery(tQ.Create)
      if(not qRez and IsBool(qRez)) then -- Remove table when SQL error is present
        LogInstance("Table create fail: "..sqlLastError().." Query > "..tQ.Create,tabDef.Nick)
        return self:Remove(false) -- Remove table when SQL error is present
      end -- Check when SQL query has passed and the table is not yet created
      if(sqlTableExists(defTab.Name)) then
        for k, v in pairs(tQ.Index) do local qRez = sqlQuery(v)
          if(not qRez and IsBool(qRez)) then -- Check when the index query has passed
            LogInstance("Table create index fail ["..k.."]: "..sqlLastError().." Query > "..v,tabDef.Nick)
            return self:Remove(false) -- Clear table when index is not created
          end
          LogInstance("Table create index: "..v,tabDef.Nick)
        end
      else
        LogInstance("Table create check fail: "..sqlLastError().." Query > "..tQ.Create,tabDef.Nick)
        return self:Remove(false) -- Clear table when it is not created by the first pass
      end
    end
    -- When the table is present delete all records
    if(bDelete) then
      if(sqlTableExists(defTab.Name)) then local qRez = sqlQuery(tQ.Delete)
        if(not qRez and IsBool(qRez)) then -- Remove table when SQL error is present
          LogInstance("Table delete fail: "..sqlLastError().." Query > "..tQ.Delete,tabDef.Nick)
          return self:Remove(false) -- Remove table when SQL error is present
        else LogInstance("Table delete success",tabDef.Nick) end
      else LogInstance("Table delete skipped",tabDef.Nick) end
    end
  elseif(sMoDB == "LUA") then local tCache = libCache[tabDef.Nick]
    if(IsHere(tCache)) then -- Empty the table when its cache is located
      tableEmpty(tCache); LogInstance("Table create empty",tabDef.Nick)
    else libCache[tabDef.Nick] = {}; LogInstance("Table create allocate",tabDef.Nick); end
  else LogInstance("Wrong database mode <"..sMoDB..">",tabDef.Nick); return self:Remove(false) end
end

--------------- TIMER MEMORY MANAGMENT ----------------------------

function CacheBoxLayout(oEnt,nRot,nCamX,nCamZ)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity invalid <"..tostring(oEnt)..">"); return nil end
  local sMod = oEnt:GetModel() -- Extract the entity model
  local oRec = CacheQueryPiece(sMod); if(not IsHere(oRec)) then
    LogInstance("Record invalid <"..sMod..">"); return nil end
  local stBox = oRec.Layout; if(not IsHere(stBox)) then
    local vMin, vMax; oRec.Layout = {}; stBox = oRec.Layout
    if    (CLIENT) then vMin, vMax = oEnt:GetRenderBounds()
    elseif(SERVER) then vMin, vMax = oEnt:OBBMins(), oEnt:OBBMaxs()
    else LogInstance("Wrong instance"); return nil end
    stBox.Ang = Angle () -- Layout entity angle
    stBox.Cen = Vector() -- Layout entity center
    stBox.Cen:Set(vMax); stBox.Cen:Add(vMin); stBox.Cen:Mul(0.5)
    stBox.Eye = oEnt:LocalToWorld(stBox.Cen) -- Layout camera eye
    stBox.Len = (((vMax - stBox.Cen):Length() + (vMin - stBox.Cen):Length()) / 2)
    stBox.Cam = Vector(); stBox.Cam:Set(stBox.Eye)  -- Layout camera position
    AddVectorXYZ(stBox.Cam,stBox.Len*(tonumber(nCamX) or 0),0,stBox.Len*(tonumber(nCamZ) or 0))
    LogInstance("<"..tostring(stBox.Cen).."><"..tostring(stBox.Len)..">")
  end; stBox.Ang[caY] = (tonumber(nRot) or 0) * Time(); return stBox
end

--------------------------- PIECE QUERY -----------------------------

function CacheQueryPiece(sModel)
  if(not IsHere(sModel)) then
    LogInstance("Model does not exist"); return nil end
  if(not IsString(sModel)) then
    LogInstance("Model mismatch "..GetReport(sModel)); return nil end
  if(IsBlank(sModel)) then
    LogInstance("Model empty string"); return nil end
  if(not utilIsValidModel(sModel)) then
    LogInstance("Model invalid <"..sModel..">"); return nil end
  local makTab = GetBuilderNick("PIECES"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  local tCache = libCache[defTab.Name]; if(not IsHere(tCache)) then
    LogInstance("Cache missing for <"..defTab.Name..">"); return nil end
  local sModel, qsKey = makTab:Match(sModel,1,false,"",true,true), GetOpVar("FORM_KEYSTMT")
  local stPiece, sFunc = tCache[sModel], "CacheQueryPiece"
  if(IsHere(stPiece) and IsHere(stPiece.Size)) then
    if(stPiece.Size <= 0) then stPiece = nil else
      stPiece = makTab:TimerRestart(sFunc, defTab.Name, sModel) end
    return stPiece
  else
    local sMoDB = GetOpVar("MODE_DATABASE")
    if(sMoDB == "SQL") then
      local qModel = makTab:Match(sModel,1,true)
      LogInstance("Model >> Pool <"..stringGetFileName(sModel)..">")
      tCache[sModel] = {}; stPiece = tCache[sModel]; stPiece.Size = 0
      local Q = CacheStmt(qsKey:format(sFunc, ""), nil, qModel)
      if(not Q) then
        local sStmt = makTab:Select():Where({1,"%s"}):Order(4):Get()
        if(not IsHere(sStmt)) then
          LogInstance("Build statement failed"); return nil end
        Q = CacheStmt(qsKey:format(sFunc, ""), sStmt, qModel)
      end
      local qData = sqlQuery(Q); if(not qData and IsBool(qData)) then
        LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
      if(not IsHere(qData) or IsEmpty(qData)) then
        LogInstance("No data found <"..Q..">"); return nil end
      local iCnt   = 1; stPiece.Slot, stPiece.Size = sModel, 0
      stPiece.Type = qData[iCnt][makTab:GetColumnName(2)]
      stPiece.Name = qData[iCnt][makTab:GetColumnName(3)]
      stPiece.Unit = qData[iCnt][makTab:GetColumnName(8)]
      while(qData[iCnt]) do local qRec = qData[iCnt]
        if(not IsHere(RegisterPOA(stPiece,iCnt,
          qRec[makTab:GetColumnName(5)],
          qRec[makTab:GetColumnName(6)],
          qRec[makTab:GetColumnName(7)]))) then
          LogInstance("Cannot process offset #"..tostring(iCnt).." for <"..sModel..">"); return nil
        end; stPiece.Size, iCnt = iCnt, (iCnt + 1)
      end; stPiece = makTab:TimerAttach(sFunc, defTab.Name, sModel); return stPiece
    elseif(sMoDB == "LUA") then LogInstance("Record not located"); return nil
    else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
  end
end

function CacheQueryAdditions(sModel)
  if(not IsHere(sModel)) then
    LogInstance("Model does not exist"); return nil end
  if(not IsString(sModel)) then
    LogInstance("Model mismatch "..GetReport(sModel)); return nil end
  if(IsBlank(sModel)) then
    LogInstance("Model empty string"); return nil end
  if(not utilIsValidModel(sModel)) then
    LogInstance("Model invalid "..GetReport(sModel)); return nil end
  local makTab = GetBuilderNick("ADDITIONS"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  local tCache = libCache[defTab.Name]; if(not IsHere(tCache)) then
    LogInstance("Cache missing for <"..defTab.Name..">"); return nil end
  local sModel, qsKey = makTab:Match(sModel,1,false,"",true,true), GetOpVar("FORM_KEYSTMT")
  local stAddit, sFunc = tCache[sModel], "CacheQueryAdditions"
  if(IsHere(stAddit) and IsHere(stAddit.Size)) then
    if(stAddit.Size <= 0) then stAddit = nil else
      stAddit = makTab:TimerRestart(sFunc, defTab.Name, sModel) end
    return stAddit
  else
    local sMoDB = GetOpVar("MODE_DATABASE")
    if(sMoDB == "SQL") then
      local qModel = makTab:Match(sModel,1,true)
      LogInstance("Model >> Pool <"..stringGetFileName(sModel)..">")
      tCache[sModel] = {}; stAddit = tCache[sModel]; stAddit.Size = 0
      local Q = CacheStmt(qsKey:format(sFunc, ""), nil, qModel)
      if(not Q) then
        local sStmt = makTab:Select(2,3,4,5,6,7,8,9,10,11,12):Where({1,"%s"}):Order(4):Get()
        if(not IsHere(sStmt)) then
          LogInstance("Build statement failed"); return nil end
        Q = CacheStmt(qsKey:format(sFunc, ""), sStmt, qModel)
      end
      local qData = sqlQuery(Q); if(not qData and IsBool(qData)) then
        LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
      if(not IsHere(qData) or IsEmpty(qData)) then
        LogInstance("No data found <"..Q..">"); return nil end
      local iCnt = 1; stAddit.Slot, stAddit.Size = sModel, 0
      while(qData[iCnt]) do local qRec = qData[iCnt]; stAddit[iCnt] = {}
        for col, val in pairs(qRec) do stAddit[iCnt][col] = val end
        stAddit.Size, iCnt = iCnt, (iCnt + 1)
      end; stAddit = makTab:TimerAttach(sFunc, defTab.Name, sModel); return stAddit
    elseif(sMoDB == "LUA") then LogInstance("Record not located"); return nil
    else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
  end
end

----------------------- PANEL QUERY -------------------------------

--[[
 * Exports panel indormation to dedicated DB file
 * stPanel --> The actual panel information to export
 * bExp    --> Export panel data into a DB file
]]
local function ExportPanelDB(stPanel, bExp, makTab, sFunc)
  if(bExp) then
    local sMoDB = GetOpVar("MODE_DATABASE")
    local symSep = GetOpVar("OPSYM_SEPARATOR")
    local iCnt, sBase = 1, GetOpVar("DIRPATH_BAS")
    if(not fileExists(sBase, "DATA")) then fileCreateDir(sBase) end
    local fName = (sBase..GetOpVar("NAME_LIBRARY").."_db.txt")
    local F = fileOpen(fName, "wb" ,"DATA"); if(not F) then
      LogInstance("("..fName..") Open fail"); return stPanel end
    F:Write("# "..sFunc..":("..tostring(bExp)..") "..GetDateTime().." [ "..sMoDB.." ]\n")
    while(stPanel[iCnt]) do local vPanel = stPanel[iCnt]
      local sM = vPanel[makTab:GetColumnName(1)]
      local sT = vPanel[makTab:GetColumnName(2)]
      local sN = vPanel[makTab:GetColumnName(3)]
      F:Write("\""..sM.."\""..symSep.."\""..sT.."\""..symSep.."\""..sN.."\"")
      F:Write("\n"); iCnt = iCnt + 1
    end; F:Flush(); F:Close()
  end; return stPanel
end

--[[
 * Caches the data needed to populate the CPanel tree
 * bExp --> Export panel data into a DB file
]]
function CacheQueryPanel(bExp)
  local makTab = GetBuilderNick("PIECES"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  if(not IsHere(libCache[defTab.Name])) then
    LogInstance("Missing cache allocated <"..defTab.Name..">"); return nil end
  local keyPan , sFunc = GetOpVar("HASH_USER_PANEL"), "CacheQueryPanel"
  local stPanel, qsKey = libCache[keyPan], GetOpVar("FORM_KEYSTMT")
  if(IsHere(stPanel) and IsHere(stPanel.Size)) then LogInstance("From Pool")
    if(stPanel.Size <= 0) then stPanel = nil else
      stPanel = makTab:TimerRestart(sFunc, keyPan) end
    return ExportPanelDB(stPanel, bExp, makTab, sFunc)
  else
    libCache[keyPan] = {}; stPanel = libCache[keyPan]
    local sMoDB = GetOpVar("MODE_DATABASE")
    if(sMoDB == "SQL") then
      local Q = CacheStmt(qsKey:format(sFunc,""), nil, 1)
      if(not Q) then
        local sStmt = makTab:Select(1,2,3):Where({4,"%d"}):Order(2,1):Get()
        if(not IsHere(sStmt)) then
          LogInstance("Build statement failed"); return nil end
        Q = CacheStmt(qsKey:format(sFunc,""), sStmt, 1)
      end
      local qData = sqlQuery(Q); if(not qData and IsBool(qData)) then
        LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
      if(not IsHere(qData) or IsEmpty(qData)) then
        LogInstance("No data found <"..Q..">"); return nil end
      local iCnt = 1; stPanel.Size = 0
      while(qData[iCnt]) do
        stPanel[iCnt] = qData[iCnt]
        stPanel.Size, iCnt = iCnt, (iCnt + 1)
      end; stPanel = makTab:TimerAttach(sFunc, keyPan)
      return ExportPanelDB(stPanel, bExp, makTab, sFunc)
    elseif(sMoDB == "LUA") then
      local tCache = libCache[defTab.Name] -- Sort directly by the model
      local tSort  = Sort(tCache,{"Type","Slot"}); if(not tSort) then
        LogInstance("Cannot sort cache data"); return nil end; stPanel.Size = 0
      for iCnt = 1, tSort.Size do stPanel[iCnt] = {}
        local vSort, vPanel = tSort[iCnt], stPanel[iCnt]
        vPanel[makTab:GetColumnName(1)] = vSort.Key
        vPanel[makTab:GetColumnName(2)] = vSort.Rec.Type
        vPanel[makTab:GetColumnName(3)] = vSort.Rec.Name; stPanel.Size = iCnt
      end; return ExportPanelDB(stPanel, bExp, makTab, sFunc)
    else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
  end
end

--[[
 * Used to Populate the CPanel Phys Materials
 * If type is chosen, it gets the names for the type
 * If type is not chosen, it gets a list of all types
]]--
function CacheQueryProperty(sType)
  local makTab = GetBuilderNick("PHYSPROPERTIES"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  local tCache = libCache[defTab.Name]; if(not tCache) then
    LogInstance("Cache missing for <"..defTab.Name..">"); return nil end
  local sMoDB, sFunc = GetOpVar("MODE_DATABASE"), "CacheQueryProperty"
  local qsKey = GetOpVar("FORM_KEYSTMT")
  if(IsString(sType) and not IsBlank(sType)) then
    local sType = makTab:Match(sType,1,false,"",true,true)
    local keyName = GetOpVar("HASH_PROPERTY_NAMES")
    local arNames = tCache[keyName]
    if(not IsHere(arNames)) then
      tCache[keyName] = {}; arNames = tCache[keyName] end
    local stName = arNames[sType]
    if(IsHere(stName) and IsHere(stName.Size)) then
      if(stName.Size <= 0) then stName = nil else
        stName = makTab:TimerRestart(sFunc, defTab.Name, keyName, sType) end
      return stName
    else
      if(sMoDB == "SQL") then
        local qType = makTab:Match(sType,1,true)
        arNames[sType] = {}; stName = arNames[sType]; stName.Size = 0
        local Q = CacheStmt(qsKey:format(sFunc,keyName), nil, qType)
        if(not Q) then
          local sStmt = makTab:Select(3):Where({1,"%s"}):Order(2):Get()
          if(not IsHere(sStmt)) then
            LogInstance("Build statement failed"); return nil end
          Q = CacheStmt(qsKey:format(sFunc,keyName), sStmt, qType)
        end
        local qData = sqlQuery(Q); if(not qData and IsBool(qData)) then
          LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
        if(not IsHere(qData) or IsEmpty(qData)) then
          LogInstance("No data found <"..Q..">"); return nil end
        local iCnt = 1; stName.Size, stName.Slot = 0, sType
        while(qData[iCnt]) do
          stName[iCnt] = qData[iCnt][makTab:GetColumnName(3)]
          stName.Size, iCnt = iCnt, (iCnt + 1)
        end; LogInstance("Names("..sType..") >> Pool")
        stName = makTab:TimerAttach(sFunc, defTab.Name, keyName, sType); return stName
      elseif(sMoDB == "LUA") then LogInstance("Record not located"); return nil
      else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
    end
  else
    local keyType = GetOpVar("HASH_PROPERTY_TYPES")
    local stType  = tCache[keyType]
    if(IsHere(stType) and IsHere(stType.Size)) then LogInstance("Types << Pool")
      if(stType.Size <= 0) then stType = nil else
        stType = makTab:TimerRestart(sFunc, defTab.Name, keyType) end
      return stType
    else
      if(sMoDB == "SQL") then
        tCache[keyType] = {}; stType = tCache[keyType]; stType.Size = 0
        local Q = CacheStmt(qsKey:format(sFunc,keyType), nil, 1)
        if(not Q) then
          local sStmt = makTab:Select(1):Where({2,"%d"}):Order(1):Get()
          if(not IsHere(sStmt)) then
            LogInstance("Build statement failed"); return nil end
          Q = CacheStmt(qsKey:format(sFunc,keyType), sStmt, 1)
        end
        local qData = sqlQuery(Q); if(not qData and IsBool(qData)) then
          LogInstance("SQL exec error <"..sqlLastError()..">"); return nil end
        if(not IsHere(qData) or IsEmpty(qData)) then
          LogInstance("No data found <"..Q..">"); return nil end
        local iCnt = 1; stType.Size = 0
        while(qData[iCnt]) do
          stType[iCnt] = qData[iCnt][makTab:GetColumnName(1)]
          stType.Size, iCnt = iCnt, (iCnt + 1)
        end; LogInstance("Types >> Pool")
        stType = makTab:TimerAttach(sFunc, defTab.Name, keyType); return stType
      elseif(sMoDB == "LUA") then LogInstance("Record not located"); return nil
      else LogInstance("Wrong database mode <"..sMoDB..">"); return nil end
    end
  end
end

---------------------- EXPORT --------------------------------

function ExportPOA(stPOA,sOut)
  local sE = tostring(sOut or GetOpVar("MISS_NOSQL"))
  local sP = (IsEqualPOA(stPOA.P, stPOA.O) and sE or StringPOA(stPOA.P, "V"))
  local sO = (IsZeroPOA(stPOA.O, "V") and sE or StringPOA(stPOA.O, "V"))
        sO = (stPOA.O.Slot and stPOA.O.Slot or sO)
  local sA = (IsZeroPOA(stPOA.A, "A") and sE or StringPOA(stPOA.A, "A"))
        sA = (stPOA.A.Slot and stPOA.A.Slot or sA)
  return sP, sO, sA -- Recieve three strings as POA exports
end

--[[
 * Save/Load the category generation
 * vEq    > Amount of intenal comment depth
 * tData  > The local data table to be exported ( if given )
 * sPref  > Prefix used on exporting ( if not uses instance prefix)
]]--
function ExportCategory(vEq, tData, sPref)
  if(SERVER) then LogInstance("Working on server"); return true end
  local nEq   = (tonumber(vEq) or 0); if(nEq <= 0) then
    LogInstance("Wrong equality <"..tostring(vEq)..">"); return false end
  local fPref = tostring(sPref or GetInstPref()); if(IsBlank(fPref)) then
    LogInstance("("..fPref..") Prefix empty"); return false end
  if(IsFlag("en_dsv_datalock")) then
    LogInstance("("..fPref..") User disabled"); return true end
  local fName, sFunc = GetOpVar("DIRPATH_BAS"), "ExportCategory"
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  local fForm, sTool = GetOpVar("FORM_PREFIXDSV"), GetOpVar("TOOLNAME_PU")
  fName = fName..fForm:format(fPref, sTool.."CATEGORY")
  local F = fileOpen(fName, "wb", "DATA")
  if(not F) then LogInstance("("..fPref..")("..fName..") Open fail"); return false end
  local sEq, nLen, sMoDB = ("="):rep(nEq), (nEq+2), GetOpVar("MODE_DATABASE")
  local tCat = (IsTable(tData) and tData or GetOpVar("TABLE_CATEGORIES"))
  F:Write("# "..sFunc..":("..tostring(nEq).."@"..fPref..") "..GetDateTime().." [ "..sMoDB.." ]\n")
  for cat, rec in pairs(tCat) do
    if(IsString(rec.Txt)) then
      local exp = "["..sEq.."["..cat..sEq..rec.Txt:Trim().."]"..sEq.."]"
      if(not rec.Txt:find("\n")) then F:Flush(); F:Close()
        LogInstance("("..fPref.."):("..fPref..") Category one-liner <"..cat..">"); return false end
      F:Write(exp.."\n")
    else F:Flush(); F:Close(); LogInstance("("..fPref..") Category <"..cat.."> code <"..tostring(rec.Txt).."> mismatch"); return false end
  end; F:Flush(); F:Close(); LogInstance("("..fPref..") Success"); return true
end

function ImportCategory(vEq, sPref)
  if(SERVER) then LogInstance("Working on server"); return true end
  local nEq = (tonumber(vEq) or 0); if(nEq <= 0) then
    LogInstance("Wrong equality <"..tostring(vEq)..">"); return false end
  local fPref = tostring(sPref or GetInstPref())
  local fForm, sTool = GetOpVar("FORM_PREFIXDSV"), GetOpVar("TOOLNAME_PU")
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..fForm:format(fPref, sTool.."CATEGORY")
  local F = fileOpen(fName, "rb", "DATA")
  if(not F) then LogInstance("("..fName..") Open fail"); return false end
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
              local bS, vO = pcall(tCat[key].Cmp)
              if(bS) then tCat[key].Cmp = vO else tCat[key].Cmp = nil
                LogInstance("Compilation fail <"..key..">: "..vO)
              end
            else LogInstance("Key skipped <"..key..">") end
          else LogInstance("Function missing <"..key..">") end
        else LogInstance("Name missing <"..txt..">") end
      else sPar = sPar..sLine.."\n" end
    end
  end; F:Close(); LogInstance("Success"); return true
end

--[[
 * This function exports a given table to DSV file format
 * It is used by the player when he wants to export the
 * whole database to a delimiter separator format file
 * sTable > The table you want to export
 * sPref  > The external data prefix to be used
 * sDelim > What delimiter is the server using ( default tab )
]]--
function ExportDSV(sTable, sPref, sDelim)
  if(not IsString(sTable)) then
    LogInstance("Table mismatch "..GetReport(sTable)); return false end
  local makTab = GetBuilderNick(sTable); if(not IsHere(makTab)) then
    LogInstance("("..fPref..") Missing table builder",sTable); return false end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("("..fPref..") Missing table definition",sTable); return nil end
  local fName, fPref = GetOpVar("DIRPATH_BAS"), tostring(sPref or GetInstPref())
  if(IsBlank(fPref)) then
    LogInstance("("..fPref..") Prefix empty"); return false end
  if(IsFlag("en_dsv_datalock")) then
    LogInstance("("..fPref..") User disabled"); return true end
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  local fForm = GetOpVar("FORM_PREFIXDSV")
  fName = fName..fForm:format(fPref, defTab.Name)
  local F = fileOpen(fName, "wb", "DATA"); if(not F) then
    LogInstance("("..fPref..")("..fName..") Open fail",sTable); return false end
  local sDelim, sFunc = tostring(sDelim or "\t"):sub(1,1), "ExportDSV"
  local fsLog = GetOpVar("FORM_LOGSOURCE") -- read the log source format
  local ssLog = "*"..fsLog:format(defTab.Nick,sFunc,"%s")
  local sMoDB, symOff = GetOpVar("MODE_DATABASE"), GetOpVar("OPSYM_DISABLE")
  F:Write("#1 "..sFunc..":("..fPref.."@"..sTable..") "..GetDateTime().." [ "..sMoDB.." ]\n")
  F:Write("#2 "..sTable..":("..makTab:GetColumnList(sDelim)..")\n")
  if(sMoDB == "SQL") then
    local Q = makTab:Select():Order(unpack(defTab.Query[sFunc])):Get()
    if(not IsHere(Q)) then F:Flush(); F:Close()
      LogInstance("("..fPref..") Build statement failed",sTable); return false end
    F:Write("#3 Query:<"..Q..">\n")
    local qData = sqlQuery(Q); if(not qData and IsBool(qData)) then F:Flush(); F:Close()
      LogInstance("("..fPref..") SQL exec error <"..sqlLastError()..">",sTable); return nil end
    if(not IsHere(qData) or IsEmpty(qData)) then F:Flush(); F:Close()
      LogInstance("("..fPref..") No data found <"..Q..">",sTable); return false end
    local sData, sTab = "", defTab.Name
    for iCnt = 1, #qData do local qRec = qData[iCnt]; sData = sTab
      for iInd = 1, defTab.Size do local sHash = defTab[iInd][1]
        sData = sData..sDelim..makTab:Match(qRec[sHash],iInd,true,"\"",true)
      end; F:Write(sData.."\n"); sData = ""
    end -- Matching will not crash as it is matched during insertion
  elseif(sMoDB == "LUA") then
    local tCache = libCache[defTab.Name]; if(not IsHere(tCache)) then F:Flush(); F:Close()
      LogInstance("("..fPref..") Cache missing",sTable); return false end
    local bS, sR = pcall(defTab.Cache[sFunc], F, makTab, tCache, fPref, sDelim, ssLog:format("Cache"))
    if(not bS) then LogInstance("("..fPref..") Cache manager fail for "..sR,sTable); return false end
    if(not sR) then LogInstance("("..fPref..") Cache routine fail",sTable); return false end
  else LogInstance("("..fPref..") Wrong database mode <"..sMoDB..">",sTable); return false end
  -- The dynamic cache population was successful then send a message
  F:Flush(); F:Close(); LogInstance("("..fPref..") Success",sTable); return true
end

--[[
 * Import table data from DSV database created earlier
 * sTable > Definition KEY to import
 * bComm  > Calls TABLE:Record(arLine) when set to true
 * sPref  > Prefix used on importing ( if any )
 * sDelim > Delimiter separating the values
]]--
function ImportDSV(sTable, bComm, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref()); if(not IsString(sTable)) then
    LogInstance("("..fPref..") Table mismatch "..GetReport(sTable)); return false end
  local makTab = GetBuilderNick(sTable); if(not IsHere(makTab)) then
    LogInstance("("..fPref..") Missing table builder",sTable); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("("..fPref..") Missing table definition",sTable); return false end
  local cmdTab = makTab:GetCommand(); if(not IsHere(cmdTab)) then
    LogInstance("("..fPref..") Missing table command",sTable); return false end
  local fName = (GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV"))
  local fForm, sMoDB = GetOpVar("FORM_PREFIXDSV"), GetOpVar("MODE_DATABASE")
        fName = fName..fForm:format(fPref, defTab.Name)
  local F = fileOpen(fName, "rb", "DATA"); if(not F) then
    LogInstance("("..fPref..")("..fName..") Open fail",sTable); return false end
  local symOff, sDelim = GetOpVar("OPSYM_DISABLE"), tostring(sDelim or "\t"):sub(1,1)
  local sLine, isEOF, nLen = "", false, defTab.Name:len()
  if(sMoDB == "SQL") then sqlQuery(cmdTab.Begin)
    LogInstance("("..fPref..") Begin",sTable) end
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if((not IsBlank(sLine)) and (sLine:sub(1,1) ~= symOff)) then
      if(sLine:sub(1,nLen) == defTab.Name) then
        local tData = sDelim:Explode(sLine:sub(nLen+2,-1))
        for iCnt = 1, defTab.Size do tData[iCnt] = GetStrip(tData[iCnt]) end
        if(bComm) then makTab:Record(tData) end
      end
    end
  end; F:Close()
  if(sMoDB == "SQL") then sqlQuery(cmdTab.Commit)
    LogInstance("("..fPref..") Commit",sTable)
  end; LogInstance("("..fPref..") Success",sTable); return true
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
  local fPref = tostring(sPref or GetInstPref()); if(IsBlank(fPref)) then
    LogInstance("("..fPref..") Prefix empty"); return false end
  if(not IsString(sTable)) then
    LogInstance("("..fPref..") Table mismatch "..GetReport(sTable)); return false end
  if(IsFlag("en_dsv_datalock")) then
    LogInstance("("..fPref..") User disabled"); return true end
  local makTab = GetBuilderNick(sTable); if(not IsHere(makTab)) then
    LogInstance("("..fPref.."@"..sTable..") Missing table builder"); return false end
  local defTab, iD = makTab:GetDefinition(), makTab:GetColumnID("LINEID")
  local fName, sDelim = GetOpVar("DIRPATH_BAS"), tostring(sDelim or "\t"):sub(1,1)
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..GetOpVar("DIRPATH_DSV")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  local fForm, sMoDB = GetOpVar("FORM_PREFIXDSV"), GetOpVar("MODE_DATABASE")
  local sFunc = "SynchronizeDSV"; fName = fName..fForm:format(fPref, defTab.Name)
  local I, fData, symOff = fileOpen(fName, "rb", "DATA"), {}, GetOpVar("OPSYM_DISABLE")
  if(I) then local sLine, isEOF = "", false
    while(not isEOF) do sLine, isEOF = GetStringFile(I)
      if((not IsBlank(sLine)) and (sLine:sub(1,1) ~= symOff)) then
        local tLine = sDelim:Explode(sLine)
        if(tLine[1] == defTab.Name) then local nL = #tLine
          for iCnt = 2, nL do local vV, iL = tLine[iCnt], (iCnt-1); vV = GetStrip(vV)
            vM = makTab:Match(vV,iL,false,"",true,true); if(not IsHere(vV)) then
            O:Flush(); O:Close(); LogInstance("("..fPref.."@"..sTable
              ..") Read matching failed <"..tostring(vV).."> to <"
                ..tostring(iL).." # "..defTab[iL][1]..">"); return false end
            tLine[iCnt] = vM -- Register the matched value
          end -- Allocate table memory for the matched key
          local vK = tLine[2]; if(not fData[vK]) then fData[vK] = {Size = 0} end
          -- Where the line ID must be read from. Validate the value
          local fRec, vID, nID = fData[vK], tLine[iD+1]; nID = (tonumber(vID) or 0)
          if((fRec.Size < 0) or (nID <= fRec.Size) or ((nID - fRec.Size) ~= 1)) then
            I:Close(); LogInstance("("..fPref.."@"..sTable..") Read line ID #"..
              tostring(vID).." desynchronized <"..tostring(vK)..">"); return false end
          fRec.Size = nID; fRec[nID] = {}; local fRow = fRec[nID] -- Regster the new line
          for iCnt = 3, nL do fRow[iCnt-2] = tLine[iCnt] end -- Transfer the extracted data
        else I:Close()
          LogInstance("("..fPref.."@"..sTable..") Read table name mismatch"); return false end
      end
    end; I:Close()
  else LogInstance("("..fPref.."@"..sTable..") Creating file <"..fName..">") end
  for key, rec in pairs(tData) do -- Check the given table and match the key
    local vK = makTab:Match(key,1,false,"",true,true); if(not IsHere(vK)) then
      O:Flush(); O:Close(); LogInstance("("..fPref.."@"..sTable.."@"
        ..tostring(key)..") Sync matching PK failed"); return false end
    local sKey, sVK = tostring(key), tostring(vK); if(sKey ~= sVK) then
      LogInstance("("..fPref.."@"..sTable..") Sync key mismatch ["..sKey.."]["..sVK.."]");
      tData[vK] = tData[key]; tData[key] = nil -- Override the key casing after matching
    end local tRec = tData[vK] -- Create local reference to the record of the matched key
    for iCnt = 1, #tRec do local tRow, vID, nID, sID = tRec[iCnt] -- Read the processed row reference
      vID = tRow[iD-1]; nID, sID = tonumber(vID), tostring(vID)
      nID = (nID or (sID:sub(1,1) == symOff and iCnt or 0))
      -- Where the line ID must be read from. Skip the key itself and convert the disabled value
      if(iCnt ~= nID) then -- Validate the line ID being in proper borders abd sequential
          LogInstance("("..fPref.."@"..sTable.."@"..tostring(key)..") Sync point ["
            ..tostring(iCnt).."] ID "..tostring(vID).." desynchronized "
            ..tostring(nID)); return false end; tRow[iD-1] = nID
      for nCnt = 1, #tRow do -- Do a value matching without quotes
        local vM = makTab:Match(tRow[nCnt],nCnt+1,false,"",true,true); if(not IsHere(vM)) then
          LogInstance("("..fPref.."@"..sTable.."@"..tostring(key)..") Sync matching failed <"
            ..tostring(tRow[nCnt]).."> to <"..tostring(nCnt+1).." # "..defTab[nCnt+1][1]..">"); return false
        end; tRow[nCnt] = vM -- Store the matched value in the same place as the original
      end
    end -- Register the read line to the output file
    if(bRepl) then -- Replace the data when enabled overwrites the file data
      if(tData[vK]) then -- Update the file with the new data
        fData[vK] = tRec; fData[vK].Size = #tRec end
    end
  end
  local tSort = Sort(tableGetKeys(fData)); if(not tSort) then
    LogInstance("("..fPref.."@"..sTable..") Sorting failed"); return false end
  local O = fileOpen(fName, "wb" ,"DATA"); if(not O) then
    LogInstance("("..fPref.."@"..sTable..")("..fName..") Open fail"); return false end
  O:Write("# "..sFunc..":("..fPref.."@"..sTable..") "..GetDateTime().." [ "..sMoDB.." ]\n")
  O:Write("# "..sTable..":("..makTab:GetColumnList(sDelim)..")\n")
  for iKey = 1, tSort.Size do local key = tSort[iKey].Val
    local vK = makTab:Match(key,1,true,"\"",true); if(not IsHere(vK)) then
      O:Flush(); O:Close(); LogInstance("("..fPref.."@"..sTable.."@"..tostring(key)..") Write matching PK failed"); return false end
    local fRec, sCash, sData = fData[key], defTab.Name..sDelim..vK, ""
    for iCnt = 1, fRec.Size do local fRow = fRec[iCnt]
      for nCnt = 1, #fRow do
        local vM = makTab:Match(fRow[nCnt],nCnt+1,true,"\"",true); if(not IsHere(vM)) then
          O:Flush(); O:Close(); LogInstance("("..fPref.."@"..sTable.."@"..tostring(key)..") Write matching failed <"
            ..tostring(fRow[nCnt]).."> to <"..tostring(nCnt+1).." # "..defTab[nCnt+1][1]..">"); return false
        end; sData = sData..sDelim..tostring(vM)
      end; O:Write(sCash..sData.."\n"); sData = ""
    end
  end O:Flush(); O:Close()
  LogInstance("("..fPref.."@"..sTable..") Success"); return true
end

function TranslateDSV(sTable, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref()); if(IsBlank(fPref)) then
    LogInstance("("..fPref..") Prefix empty"); return false end
  if(not IsString(sTable)) then
    LogInstance("("..fPref..") Table mismatch "..GetReport(sTable)); return false end
  if(IsFlag("en_dsv_datalock")) then
    LogInstance("("..fPref..") User disabled"); return true end
  local makTab = GetBuilderNick(sTable); if(not IsHere(makTab)) then
    LogInstance("("..fPref..") Missing table builder",sTable); return false end
  local defTab, sFunc = makTab:GetDefinition(), "TranslateDSV"
  local sNdsv, sNins = GetOpVar("DIRPATH_BAS"), GetOpVar("DIRPATH_BAS")
  if(not fileExists(sNins,"DATA")) then fileCreateDir(sNins) end
  sNdsv, sNins = sNdsv..GetOpVar("DIRPATH_DSV"), sNins..GetOpVar("DIRPATH_INS")
  if(not fileExists(sNins,"DATA")) then fileCreateDir(sNins) end
  local fForm, sMoDB = GetOpVar("FORM_PREFIXDSV"), GetOpVar("MODE_DATABASE")
  sNdsv, sNins = sNdsv..fForm:format(fPref, defTab.Name), sNins..fForm:format(fPref, defTab.Name)
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local D = fileOpen(sNdsv, "rb", "DATA"); if(not D) then
    LogInstance("("..fPref..")("..sNdsv..") Open fail",sTable); return false end
  local I = fileOpen(sNins, "wb", "DATA"); if(not I) then
    LogInstance("("..fPref..")("..sNins..") Open fail",sTable); return false end
  I:Write("# "..sFunc..":("..fPref.."@"..sTable..") "..GetDateTime().." [ "..sMoDB.." ]\n")
  I:Write("# "..sTable..":("..makTab:GetColumnList(sDelim)..")\n")
  local sLine, isEOF, symOff = "", false, GetOpVar("OPSYM_DISABLE")
  local sFr, sBk = sTable:upper()..":Record({", "})\n"
  while(not isEOF) do sLine, isEOF = GetStringFile(D)
    if((not IsBlank(sLine)) and (sLine:sub(1,1) ~= symOff)) then
      sLine = sLine:gsub(defTab.Name,""):Trim()
      local tBoo, sCat = sDelim:Explode(sLine), ""
      for nCnt = 1, #tBoo do
        local vMatch = makTab:Match(GetStrip(tBoo[nCnt]),nCnt,true,"\"",true)
        if(not IsHere(vMatch)) then D:Close(); I:Flush(); I:Close()
          LogInstance("("..fPref..") Given matching failed <"
            ..tostring(tBoo[nCnt]).."> to <"..tostring(nCnt).." # "
              ..defTab[nCnt][1]..">",sTable); return false end
        sCat = sCat..", "..tostring(vMatch)
      end; I:Write(sFr..sCat:sub(3,-1)..sBk)
    end
  end; D:Close(); I:Flush(); I:Close()
  LogInstance("("..fPref..") Success",sTable); return true
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
  local fPref = tostring(sPref or GetInstPref()); if(IsBlank(fPref)) then
    LogInstance("("..fPref..") Prefix empty"); return false end
  if(IsFlag("en_dsv_datalock")) then
    LogInstance("("..fPref..") User disabled"); return true end
  if(CLIENT and gameSinglePlayer()) then
    LogInstance("("..fPref..") Single client"); return true end
  local sBas = GetOpVar("DIRPATH_BAS")
  if(not fileExists(sBas,"DATA")) then fileCreateDir(sBas) end
  local lbNam, sMiss  = GetOpVar("NAME_LIBRARY"), GetOpVar("MISS_NOAV")
  local fName, sDelim = (sBas..lbNam.."_dsv.txt"), tostring(sDelim or "\t"):sub(1,1)
  if(bSkip) then
    local symOff = GetOpVar("OPSYM_DISABLE")
    local fPool, isEOF, isAct = {}, false, true
    local F, sLine = fileOpen(fName, "rb" ,"DATA"), ""
    if(not F) then LogInstance("("..fPref..")("..fName..") Open fail"); return false end
    while(not isEOF) do sLine, isEOF = GetStringFile(F)
      if(not IsBlank(sLine)) then
        if(sLine:sub(1,1) == symOff) then
          isAct, sLine = false, sLine:sub(2,-1) else isAct = true end
        local tab = sDelim:Explode(sLine)
        local prf, src = tab[1]:Trim(), tab[2]:Trim()
        local inf = fPool[prf]; if(not inf) then
          fPool[prf] = {Size = 0}; inf = fPool[prf] end
        inf.Size = inf.Size + 1; inf[inf.Size] = {src, isAct}
      end
    end; F:Close()
    if(fPool[fPref]) then local inf = fPool[fPref]
      for ID = 1, inf.Size do local tab = inf[ID]
        LogInstance("("..fPref..") "..(tab[2] and "On " or "Off").." <"..tab[1]..">") end
      LogInstance("("..fPref..") Skip <"..sProg..">"); return true
    end
  end
  local F = fileOpen(fName, "ab" ,"DATA"); if(not F) then
    LogInstance("("..fPref..")("..fName..") Open fail"); return false end
  F:Write(fPref..sDelim..tostring(sProg or sMiss).."\n"); F:Flush(); F:Close()
  LogInstance("("..fPref..") Register"); return true
end

--[[
 * This function cycles all the lines made via @RegisterDSV(sProg, sPref, sDelim, bSkip)
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
  if(not F) then LogInstance("("..fName..") Open fail"); return false end
  local sLine, isEOF, symOff = "", false, GetOpVar("OPSYM_DISABLE")
  local sNt, fForm = GetOpVar("TOOLNAME_PU"), GetOpVar("FORM_PREFIXDSV")
  local sDelim, tProc = tostring(sDelim or "\t"):sub(1,1), {}
  local sDv = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if(not IsBlank(sLine)) then
      if(sLine:sub(1,1) ~= symOff) then
        local tInf = sDelim:Explode(sLine)
        local fPrf = GetStrip(tostring(tInf[1] or ""):Trim())
        local fSrc = GetStrip(tostring(tInf[2] or ""):Trim())
        if(not IsBlank(fPrf)) then -- Is there something
          if(not tProc[fPrf]) then
            tProc[fPrf] = {Cnt = 1, [1] = fSrc}
          else local tStore = tProc[fPrf] -- Prefix is processed already
            tStore.Cnt = tStore.Cnt + 1 -- Store the count of the repeated prefixes
            tStore[tStore.Cnt] = fSrc
          end -- What user puts there is a problem of his own
        end -- If the line is disabled/comment
      else LogInstance("Skipped <"..sLine..">") end
    end
  end; F:Close()
  for prf, tab in pairs(tProc) do
    if(tab.Cnt > 1) then
      LogInstance("Prefix <"..prf.."> clones #"..tostring(tab.Cnt).." @"..fName)
      for iD = 1, tab.Cnt do LogInstance("Prefix "..GetReport3(iD, prf, tab[iD])) end
    else local irf = GetInstPref()
      if(CLIENT) then
        if(not fileExists(sDv..fForm:format(irf, sNt.."CATEGORY"), "DATA")) then
          if(fileExists(sDv..fForm:format(prf, sNt.."CATEGORY"), "DATA")) then
            if(not ImportCategory(3, prf)) then
              LogInstance("("..prf..") Failed CATEGORY") end
          else LogInstance("("..prf..") Missing CATEGORY") end
        else LogInstance("("..prf..") Generic CATEGORY") end
      end local iD, makTab = 1, GetBuilderID(1)
      while(makTab) do local defTab = makTab:GetDefinition()
        if(not fileExists(sDv..fForm:format(irf, sNt..defTab.Nick), "DATA")) then
          if(fileExists(sDv..fForm:format(prf, sNt..defTab.Nick), "DATA")) then
            if(not ImportDSV(defTab.Nick, true, prf)) then
              LogInstance("("..prf..") Failed "..defTab.Nick) end
          else LogInstance("("..prf..") Missing "..defTab.Nick) end
        else LogInstance("("..prf..") Generic "..defTab.Nick) end
        iD = (iD + 1); makTab = GetBuilderID(iD)
      end
    end
  end; LogInstance("Success"); return true
end

--[[
 * This function adds the extracted addition for given model to a list
 * sModel > The model to be checked for addotions
 * makTab > Reference to addotions table builder
 * qList  > The list to insert the found addotions
]]--
local function SetAdditionsAR(sModel, makTab, qList)
  if(not IsHere(makTab)) then return end
  local defTab = makTab:GetDefinition()
  if(not IsHere(defTab)) then LogInstance("Table definition missing") end
  local sMoDB, sFunc, qData = GetOpVar("MODE_DATABASE"), "SetAdditionsAR"
  if(sMoDB == "SQL") then
    local qsKey = GetOpVar("FORM_KEYSTMT")
    local qModel = makTab:Match(tostring(sModel or ""), 1, true)
    local Q = CacheStmt(qsKey:format(sFunc, "ADDITIONS"), nil, qModel)
    if(not Q) then
      local sStmt = makTab:Select():Where({1,"%s"}):Order(4):Get()
      if(not IsHere(sStmt)) then LogInstance("Build statement failed"); return
      end; Q = CacheStmt(qsKey:format(sFunc, "ADDITIONS"), sStmt, qModel)
    end
    qData = sqlQuery(Q)
    if(not qData and IsBool(qData)) then
      LogInstance("SQL exec error <"..sqlLastError()..">")
      LogInstance("SQL exec query <"..Q..">"); return
    end
  elseif(sMoDB == "LUA") then
    local iCnt = 0; qData = {}
    local tCache = libCache[defTab.Name]
    local pkModel = makTab:GetColumnName(1)
    local sLineID = makTab:GetColumnName(4)
    for mod, rec in pairs(tCache) do
      if(mod == sModel) then
        for iD = 1, rec.Size do iCnt = (iCnt + 1)
          qData[iCnt] = {[pkModel] = mod}
          for iC = 2, defTab.Size do
            local sN = makTab:GetColumnName(iC)
            qData[iCnt][sN] = rec[iD][sN]
          end
        end
      end
    end
    local tSort = Sort(qData, {pkModel, sLineID}); if(not tSort) then
        LogInstance("Sort cache mismatch"); return end; tableEmpty(qData)
    for iD = 1, tSort.Size do qData[iD] = tSort[iD].Rec end
  else
    LogInstance("Wrong database mode <"..sMoDB..">")
    fE:Flush(); fE:Close(); fS:Close(); return
  end; local iE = #qList
  if(not IsHere(qData) or IsEmpty(qData)) then return end
  for iD = 1, #qData do qList[iE + iD] = qData[iD] end
end

local function ExportPiecesAR(fF,qData,sName,sInd,qList)
  local dbNull = GetOpVar("MISS_NOSQL")
  local keyBld, makAdd = GetOpVar("KEYQ_BUILDER")
  local makTab = qData[keyBld]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return end
  local mgrTab = defTab.Cache; if(not IsHere(mgrTab)) then
    LogInstance("Cache manager missing"); return end
  if(not IsHere(mgrTab.ExportAR)) then
    LogInstance("Missing data handler"); return end
  if(IsHere(qList) and IsTable(qList)) then
    if(IsHere(qList[keyBld])) then makAdd = qList[keyBld] else
      makAdd = GetBuilderNick("ADDITIONS"); if(not IsHere(makAdd)) then
        LogInstance("Missing table list builder"); return end
      qList[keyBld] = makAdd; LogInstance("Store list builder")
    end
  end
  if(IsTable(qData) and IsHere(qData[1])) then
    fF:Write(sInd:rep(1).."local "..sName.." = {\n")
    local pkID, sInd, fRow = 1, "  ", true
    local idxID = makTab:GetColumnID("LINEID")
    for iD = 1, #qData do local qRow = qData[iD]
      local mMod = qRow[makTab:GetColumnName(1)]
      local aRow = makTab:GetArrayRow(qRow)
      for iA = 1, #aRow do local vA = aRow[iA]
        aRow[iA] = makTab:Match(vA,iA,true,"\"",true,true); if(not IsHere(aRow[iA])) then
          LogInstance("Matching error "..GetReport3(iA,vA,mMod)); return end
        if(vA == dbNull) then aRow[iA] = "gsMissDB" end
      end
      if(fRow) then fRow = false
        fF:Write(sInd:rep(2).."["..aRow[pkID].."] = {\n")
        SetAdditionsAR(mMod, makAdd, qList)
      else
        if(aRow[idxID] == 1) then fF:Seek(fF:Tell() - 2)
          fF:Write("\n"..sInd:rep(2).."},\n"..sInd:rep(2).."["..aRow[pkID].."] = {\n")
          SetAdditionsAR(mMod, makAdd, qList)
        end
      end
      mgrTab.ExportAR(aRow); tableRemove(aRow, 1)
      fF:Write(sInd:rep(3).."{"..tableConcat(aRow, ", ").."},\n")
    end
    fF:Seek(fF:Tell() - 2)
    fF:Write("\n"..sInd:rep(2).."}\n")
    fF:Write(sInd:rep(1).."}\n")
  else
    fF:Write(sInd:rep(1).."local "..sName.." = {}\n")
  end
end

--[[
 * This function extracts some track type from the database and creates
 * desicated autorin control script files adding the given type argument
 * to the database by using external pluggable DSV prefix list
 * sType > Track type the autorun file is creaded for
]]--
function ExportTypeAR(sType)
  if(SERVER) then return nil end
  if(not IsBlank(sType)) then
    local qPieces, qAdditions
    local sFunc = "ExportTypeAR"
    local sTool = GetOpVar("TOOLNAME_NL")
    local noSQL = GetOpVar("MISS_NOSQL")
    local sPref = sType:gsub("[^%w]","_")
    local sMoDB = GetOpVar("MODE_DATABASE")
    local sForm = GetOpVar("FORM_FILENAMEAR")
    local sS = "data/autosave/"..sForm:format(sTool)
    local sN = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_INS")
          sN = sN..sForm:format(sPref)
    local fE = fileOpen(sN, "wb", "DATA"); if(not fE) then
      LogInstance("("..sN..") Generate fail "..GetReport(sN)); return end
    local fS = fileOpen(sS, "rb", "GAME"); if(not fS) then fE:Flush(); fE:Close()
      LogInstance("("..sS..") Source fail "..GetReport(sS)) return end
    local makP  = GetBuilderNick("PIECES"); if(not makP) then
      LogInstance("Missing table builder"); return end
    local defP = makP:GetDefinition(); if(not defP) then
      LogInstance("Missing table definition"); return end
    if(sMoDB == "SQL") then
      local qsKey = GetOpVar("FORM_KEYSTMT")
      if(not IsHere(makP)) then
        LogInstance("Missing table builder PIECES")
        fE:Flush(); fE:Close(); fS:Close(); return
      end
      local qType = makP:Match(sType, 2, true)
      local Q = CacheStmt(qsKey:format(sFunc, "PIECES"), nil, qType)
      if(not Q) then
        local sStmt = makP:Select():Where({2,"%s"}):Order(1,4):Get()
        if(not IsHere(sStmt)) then LogInstance("Build statement failed")
          fE:Flush(); fE:Close(); fS:Close(); return
        end; Q = CacheStmt(qsKey:format(sFunc, "PIECES"), sStmt, qType)
      end
      qPieces = sqlQuery(Q)
      if(not qPieces and IsBool(qPieces)) then
        LogInstance("SQL exec error <"..sqlLastError()..">")
        LogInstance("SQL exec query <"..Q..">")
        fE:Flush(); fE:Close(); fS:Close(); return
      end
    elseif(sMoDB == "LUA") then
      local iCnt = 0; qPieces = {}
      local tCache = libCache[defP.Name]
      local pkModel = makP:GetColumnName(1)
      local sLineID = makP:GetColumnName(4)
      for mod, rec in pairs(tCache) do
        if(rec.Type == sType) then local iID = 1
          local rPOA = LocatePOA(rec, iID); if(not IsHere(rPOA)) then
            LogInstance("Missing point ID "..GetReport2(iID, rec.Slot))
            fE:Flush(); fE:Close(); fS:Close(); return
          end
          while(rPOA) do iCnt = (iCnt + 1)
            qPieces[iCnt] = {} -- Allocate row memory
            local qRow = qPieces[iCnt]
            local sP, sO, sA = ExportPOA(rPOA, noSQL)
            local sC = (rec.Unit and tostring(rec.Unit or noSQL) or noSQL)
            qRow[makP:GetColumnName(1)] = rec.Slot
            qRow[makP:GetColumnName(2)] = rec.Type
            qRow[makP:GetColumnName(3)] = rec.Name
            qRow[makP:GetColumnName(4)] = iID
            qRow[makP:GetColumnName(5)] = sP
            qRow[makP:GetColumnName(6)] = sO
            qRow[makP:GetColumnName(7)] = sA
            qRow[makP:GetColumnName(8)] = sC
            iID = (iID + 1); rPOA = LocatePOA(rec, iID)
          end
        end
      end
      local tSort = Sort(qPieces, {pkModel, sLineID}); if(not tSort) then
        LogInstance("Sort cache mismatch"); return end; tableEmpty(qPieces)
      for iD = 1, tSort.Size do qPieces[iD] = tSort[iD].Rec end
    else
      LogInstance("Wrong database mode <"..sMoDB..">")
      fE:Flush(); fE:Close(); fS:Close(); return
    end
    if(IsHere(qPieces) and IsHere(qPieces[1])) then
      local keyBld = GetOpVar("KEYQ_BUILDER"); qPieces[keyBld] = makP
      local sLine, isEOF, isSkip, sInd, qAdditions = "", false, false, "  ", {}
      while(not isEOF) do sLine, isEOF = GetStringFile(fS, true)
        if(sLine:find("%s*local%s+myAddon%s*=%s*")) then isSkip = true
          fE:Write("local myAddon = \""..sType.."\" -- Your addon name goes here\n")
        elseif(sLine:find("%s*local%s+myCategory%s*=%s*")) then isSkip = true
          local tCat = GetOpVar("TABLE_CATEGORIES")[sType]
          if(IsTable(tCat) and tCat.Txt) then
            fE:Write(sInd:rep(1).."local myCategory = {\n")
            fE:Write(sInd:rep(2).."[myType] = {Txt = [[\n")
            fE:Write(sInd:rep(3)..tCat.Txt:gsub("\n","\n"..sInd:rep(3)).."\n")
            fE:Write(sInd:rep(2).."]]}\n")
            fE:Write(sInd:rep(1).."}\n")
          else
            fE:Write(sInd:rep(1).."local myCategory = {}\n")
          end
        elseif(sLine:find("%s*local%s+myPieces%s*=%s*")) then isSkip = true
          ExportPiecesAR(fE, qPieces, "myPieces", sInd, qAdditions)
        elseif(sLine:find("%s*local%s+myAdditions%s*=%s*")) then isSkip = true
          ExportPiecesAR(fE, qAdditions, "myAdditions", sInd)
        else
          if(isSkip and IsBlank(sLine:Trim())) then isSkip = false end
        end
        if(not isSkip) then
          if(isEOF) then fE:Write(sLine) else fE:Write(sLine.."\n") end
        end
      end
      fE:Flush(); fE:Close(); fS:Close()
    end
  end
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
 * oPly > The player we need the normal angle from
 * soTr > A trace structure if nil, it takes oPly's
 * bSnp > Snap to the trace surface flag
 * nSnp > Yaw snap amount
]]--
function GetNormalAngle(oPly, soTr, bSnp, nSnp)
  local aAng, nAsn = Angle(), (tonumber(nSnp) or 0); if(not IsPlayer(oPly)) then
    LogInstance("No player <"..tostring(oPly)..">", aAng); return aAng end
  if(bSnp) then local stTr = soTr -- Snap to the trace surface
    if(not (stTr and stTr.Hit)) then stTr = GetCacheTrace(oPly)
      if(not (stTr and stTr.Hit)) then return aAng end
    end; aAng:Set(GetSurfaceAngle(oPly, stTr.HitNormal))
  else aAng[caY] = oPly:GetAimVector():Angle()[caY] end
  if(nAsn and (nAsn > 0) and (nAsn <= GetOpVar("MAX_ROTATION"))) then
    -- Snap player viewing rotation angle for using walls and ceiling
    aAng:SnapTo("pitch", nAsn):SnapTo("yaw", nAsn):SnapTo("roll", nAsn)
  end; return aAng
end

--[[
 * Selects a point ID on the entity based on the hit vector provided
 * oEnt --> Entity to search the point on
 * vHit --> World space hit vector to find the closest point to
 * bPnt --> Use the point local offset ( true ) else origin offset
]]--
function GetEntityHitID(oEnt, vHit, bPnt)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity invalid"); return nil end
  local oRec = CacheQueryPiece(oEnt:GetModel()); if(not oRec) then
    LogInstance("Trace not piece <"..oEnt:GetModel()..">"); return nil end
  local ePos, eAng = oEnt:GetPos(), oEnt:GetAngles()
  local oAnc, oID, oMin, oPOA = Vector(), nil, nil, nil
  for ID = 1, oRec.Size do -- Ignore the point disabled flag
    local tPOA, tID = LocatePOA(oRec, ID); if(not IsHere(tPOA)) then
      LogInstance("Point missing "..GetReport(ID)); return nil end
    if(bPnt) then SetVector(oAnc, tPOA.P) else SetVector(oAnc, tPOA.O) end
    oAnc:Rotate(eAng); oAnc:Add(ePos); oAnc:Sub(vHit)
    local tMin = oAnc:Length() -- Calculate vector absolute ( distance )
    if(oID and oMin) then -- Check if current distance is minimum
      if(oMin >= tMin) then oID, oMin, oPOA = tID, tMin, tPOA end
    else -- The shortest distance if the first one checked until others are looped
      oID, oMin, oPOA = tID, tMin, tPOA end
  end; return oID, oMin, oPOA, oRec
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
  local hdPOA, ihdPoID = LocatePOA(hdRec,ivhdPoID); if(not IsHere(hdPOA)) then
    LogInstance("Holder point ID missing "..GetReport(ivhdPoID)); return nil end
  local stSpawn = GetCacheSpawn(oPly); stSpawn.HRec, stSpawn.HID = hdRec, ihdPoID
  if(ucsPos) then SetVector(stSpawn.BPos, ucsPos) end
  if(ucsAng) then SetAngle (stSpawn.BAng, ucsAng) end
  stSpawn.OPos:Set(stSpawn.BPos); stSpawn.OAng:Set(stSpawn.BAng);
  -- Initialize F, R, U Copy the UCS like that to support database POA
  SetAnglePYR (stSpawn.ANxt, (tonumber(ucsAngP) or 0), (tonumber(ucsAngY) or 0), (tonumber(ucsAngR) or 0))
  SetVectorXYZ(stSpawn.PNxt, (tonumber(ucsPosX) or 0), (tonumber(ucsPosY) or 0), (tonumber(ucsPosZ) or 0))
  -- Integrate additional position offset into the origin position
  stSpawn.U:Set(stSpawn.OAng:Up())
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.F:Set(stSpawn.OAng:Forward())
  stSpawn.OPos:Add(stSpawn.PNxt[cvX] * stSpawn.F)
  stSpawn.OPos:Add(stSpawn.PNxt[cvY] * stSpawn.R)
  stSpawn.OPos:Add(stSpawn.PNxt[cvZ] * stSpawn.U)
  -- Integrate additional angle offset into the origin angle
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  stSpawn.OAng:RotateAroundAxis(stSpawn.R, stSpawn.ANxt[caP])
  stSpawn.OAng:RotateAroundAxis(stSpawn.U,-stSpawn.ANxt[caY])
  stSpawn.F:Set(stSpawn.OAng:Forward())
  stSpawn.OAng:RotateAroundAxis(stSpawn.F, stSpawn.ANxt[caR])
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  -- Read holder record
  SetVector(stSpawn.HPnt, hdPOA.P)
  SetVector(stSpawn.HOrg, hdPOA.O)
  SetAngle (stSpawn.HAng, hdPOA.A)
  -- Apply origin basis to the trace matrix
  stSpawn.TMtx:Identity()
  stSpawn.TMtx:Translate(stSpawn.OPos)
  stSpawn.TMtx:Rotate(stSpawn.OAng)
  -- Apply origin basis to the holder matrix
  stSpawn.HMtx:Identity()
  stSpawn.HMtx:Translate(stSpawn.HOrg)
  stSpawn.HMtx:Rotate(stSpawn.HAng)
  stSpawn.HMtx:Rotate(GetOpVar("ANG_REV"))
  stSpawn.HMtx:Invert()
  -- Calculate the spawn matrix
  stSpawn.SMtx:Set(stSpawn.TMtx * stSpawn.HMtx)
  -- Read the spawn origin position and angle
  stSpawn.SPos:Set(stSpawn.SMtx:GetTranslation())
  stSpawn.SAng:Set(stSpawn.SMtx:GetAngles())
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
    LogInstance("Trace other type"); return nil end
  local nActRadius = tonumber(nvActRadius); if(not IsHere(nActRadius)) then
    LogInstance("Active radius mismatch "..GetReport(nvActRadius)); return nil end
  local trID, trRad, trPOA, trRec = GetEntityHitID(trEnt, trHitPos, true)
  if(not (IsHere(trID) and IsHere(trRad) and IsHere(trPOA) and IsHere(trRec))) then
    LogInstance("Active point missed <"..trEnt:GetModel()..">"); return nil end
  if(not IsHere(LocatePOA(trRec, 1))) then
    LogInstance("Trace has no points"); return nil end
  if(trRad > nActRadius) then
    LogInstance("Trace outside radius"); return nil end
  local hdRec = CacheQueryPiece(shdModel); if(not IsHere(hdRec)) then
    LogInstance("Holder model missing <"..tostring(shdModel)..">"); return nil end
  local hdOffs, ihdPoID = LocatePOA(hdRec,ivhdPoID); if(not IsHere(hdOffs)) then
    LogInstance("Holder point missing "..GetReport(ivhdPoID)); return nil end
  -- If there is no Type exit immediately
  if(not (IsHere(trRec.Type) and IsString(trRec.Type))) then
    LogInstance("Trace type invalid <"..tostring(trRec.Type)..">"); return nil end
  if(not (IsHere(hdRec.Type) and IsString(hdRec.Type))) then
    LogInstance("Holder type invalid <"..tostring(hdRec.Type)..">"); return nil end
  -- If the types are different and disabled
  if((not enIgnTyp) and (trRec.Type ~= hdRec.Type)) then
    LogInstance("Types different <"..tostring(trRec.Type)..","..tostring(hdRec.Type)..">"); return nil end
  local stSpawn = GetCacheSpawn(oPly) -- We have the next Piece Offset
        stSpawn.TRec, stSpawn.RLen = trRec, trRad
        stSpawn.HID , stSpawn.TID  = ihdPoID, trID
        stSpawn.TOrg:Set(trEnt:GetPos())
        stSpawn.TAng:Set(trEnt:GetAngles())
        SetVector(stSpawn.TPnt, trPOA.P)
        stSpawn.TPnt:Rotate(stSpawn.TAng)
        stSpawn.TPnt:Add(stSpawn.TOrg)
  -- Found the active point ID on trEnt. Initialize origins
  SetVector(stSpawn.BPos, trPOA.O) -- Read origin
  SetAngle (stSpawn.BAng, trPOA.A) -- Read angle
  stSpawn.BPos:Rotate(stSpawn.TAng); stSpawn.BPos:Add(stSpawn.TOrg)
  stSpawn.BAng:Set(trEnt:LocalToWorldAngles(stSpawn.BAng))
  -- Do the flatten flag right now Its important !
  if(enFlatten) then stSpawn.BAng[caP] = 0; stSpawn.BAng[caR] = 0 end
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
    LogInstance("Point missing "..GetReport(ivPoID)); return nil end
  local trDt, trAng = GetOpVar("TRACE_DATA"), Angle(); SetOpVar("TRACE_FILTER",trEnt)
  SetVector(trDt.start, trPOA.O); trDt.start:Rotate(trEnt:GetAngles()); trDt.start:Add(trEnt:GetPos())
  SetAngle (trAng     , trPOA.A); trAng:Set(trEnt:LocalToWorldAngles(trAng))
  trDt.endpos:Set(trAng:Forward()); trDt.endpos:Mul(nLen); trDt.endpos:Add(trDt.start)
  return utilTraceLine(trDt), trDt
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
  local a, b, c = vR1[cvX], vR1[cvY], vR1[cvZ]
  local d, e, f = vR2[cvX], vR2[cvY], vR2[cvZ]
  local g, h, i = vR3[cvX], vR3[cvY], vR3[cvZ]
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
    LogInstance("Player mismatch "..GetReport(oPly)); return nil end
  if(not IsString(sKey)) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  local tRay = GetOpVar("RAY_INTERSECT")[oPly]; if(not tRay) then
    LogInstance("No ray <"..oPly:Nick()..">"); return nil end
  local stRay = tRay[sKey]; if(not stRay) then
    LogInstance("No key <"..sKey..">"); return nil end
  return IntersectRayUpdate(stRay) -- Obtain personal ray from the cache
end

function IntersectRayClear(oPly, sKey)
  if(not IsPlayer(oPly)) then
    LogInstance("Player mismatch "..GetReport(oPly)); return false end
  local tRay = GetOpVar("RAY_INTERSECT")[oPly]
  if(not tRay) then LogInstance("Clean"); return true end
  if(sKey) then
    if(not IsString(sKey)) then
      LogInstance("Key mismatch "..GetReport(sKey)); return false end
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
  local stRay1 = IntersectRayRead(oPly, sKey1); if(not stRay1) then
    LogInstance("No read <"..tostring(sKey1)..">"); return nil end
  local stRay2 = IntersectRayRead(oPly, sKey2); if(not stRay2) then
    LogInstance("No read <"..tostring(sKey2)..">"); return nil end
  local vO1, vD1 = stRay1.Orw, stRay1.Diw:Forward()
  local vO2, vD2 = stRay2.Orw, stRay2.Diw:Forward()
  local f1, f2, x1, x2, xx = IntersectRay(vO1, vD1, vO2, vD2)
  if(not xx) then -- Attempts taking the mean vector when the rays are parallel for straight tracks
    f1, f2, x1, x2, xx = IntersectRayParallel(vO1, vD1, vO2, vD2) end
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
    LogInstance("Start ID missing "..GetReport(nPntID)); return nil end
  local stPOA2 = LocatePOA(mRec, nNxtID); if(not stPOA2) then
    LogInstance("End ID missing "..GetReport(nNxtID)); return nil end
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
  local makTab, iCnt = GetBuilderNick("ADDITIONS"), 1; if(not IsHere(makTab)) then
    LogInstance("Missing table definition"); return nil end
  local sD = GetOpVar("OPSYM_DISABLE"); LogInstance("PIECE:MOD("..eMod..")")
  while(stAddit[iCnt]) do -- While additions are present keep adding them
    local arRec  = stAddit[iCnt]; LogInstance("ADDITION ["..iCnt.."]")
    local eAddit = entsCreate(arRec[makTab:GetColumnName(3)])
    LogInstance("ents.Create("..arRec[makTab:GetColumnName(3)]..")")
    if(eAddit and eAddit:IsValid()) then
      local adMod = tostring(arRec[makTab:GetColumnName(2)])
      if(not fileExists(adMod, "GAME")) then
        LogInstance("Missing attachment file "..adMod); return false end
      if(not utilIsValidModel(adMod)) then
        LogInstance("Invalid attachment model "..adMod); return false end
      eAddit:SetModel(adMod) LogInstance("SetModel("..adMod..")")
      local ofPos = arRec[makTab:GetColumnName(5)]; if(not IsString(ofPos)) then
        LogInstance("Position mismatch "..GetReport(ofPos)); return false end
      if(ofPos and not (IsNull(ofPos) or IsBlank(ofPos) or ofPos:sub(1,1) == sD)) then
        local vpAdd, arPOA = Vector(), DecodePOA(ofPos)
        SetVectorXYZ(vpAdd, arPOA[1], arPOA[2], arPOA[3])
        vpAdd:Set(ePiece:LocalToWorld(vpAdd))
        eAddit:SetPos(vpAdd); LogInstance("SetPos(DB)")
      else eAddit:SetPos(ePos); LogInstance("SetPos(PIECE:POS)") end
      local ofAng = arRec[makTab:GetColumnName(6)]; if(not IsString(ofAng)) then
        LogInstance("Angle mismatch "..GetReport(ofAng)); return false end
      if(ofAng and not (IsNull(ofAng) or IsBlank(ofAng) or ofAng:sub(1,1) == sD)) then
        local apAdd, arPOA = Angle(), DecodePOA(ofAng)
        SetAnglePYR(apAdd, arPOA[1], arPOA[2], arPOA[3])
        apAdd:Set(ePiece:LocalToWorldAngles(apAdd))
        eAddit:SetAngles(apAdd); LogInstance("SetAngles(DB)")
      else eAddit:SetAngles(eAng); LogInstance("SetAngles(PIECE:ANG)") end
      local mvTyp = (tonumber(arRec[makTab:GetColumnName(7)]) or -1)
      if(mvTyp >= 0) then eAddit:SetMoveType(mvTyp)
        LogInstance("SetMoveType("..mvTyp..")") end
      local phInt = (tonumber(arRec[makTab:GetColumnName(8)]) or -1)
      if(phInt >= 0) then eAddit:PhysicsInit(phInt)
        LogInstance("PhysicsInit("..phInt..")") end
      local drSha = (tonumber(arRec[makTab:GetColumnName(9)]) or 0)
      if(drSha ~= 0) then drSha = (drSha > 0); eAddit:DrawShadow(drSha)
        LogInstance("DrawShadow("..tostring(drSha)..")") end
      eAddit:SetParent(ePiece); LogInstance("SetParent(PIECE)")
      eAddit:Spawn(); LogInstance("Spawn()")
      phAddit = eAddit:GetPhysicsObject()
      if(phAddit and phAddit:IsValid()) then
        local enMot = (tonumber(arRec[makTab:GetColumnName(10)]) or 0)
        if(enMot ~= 0) then enMot = (enMot > 0); phAddit:EnableMotion(enMot)
          LogInstance("EnableMotion("..tostring(enMot)..")") end
        local nbZee = (tonumber(arRec[makTab:GetColumnName(11)]) or 0)
        if(nbZee > 0) then phAddit:Sleep(); LogInstance("Sleep()") end
      end
      eAddit:Activate(); LogInstance("Activate()")
      ePiece:DeleteOnRemove(eAddit); LogInstance("DeleteOnRemove()")
      local nbSld = (tonumber(arRec[makTab:GetColumnName(12)]) or -1)
      if(nbSld >= 0) then eAddit:SetSolid(nbSld)
        LogInstance("SetSolid("..tostring(nbSld)..")") end
    else
      local mA = stAddit[iCnt][makTab:GetColumnName(2)]
      local mC = stAddit[iCnt][makTab:GetColumnName(3)]
      LogInstance("Entity invalid "..GetReport4(iCnt, eMod, mA, mC)); return false
    end; iCnt = iCnt + 1
  end; LogInstance("Success"); return true
end

local function GetEntityOrTrace(oEnt)
  if(oEnt and oEnt:IsValid()) then return oEnt end
  local oPly = LocalPlayer(); if(not IsPlayer(oPly)) then
    LogInstance("Player mismatch "..GetReport(oPly)); return nil end
  local stTrace = GetCacheTrace(oPly); if(not IsHere(stTrace)) then
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
  while(BGs[iCnt]) do local sD = bgEnt:GetBodygroup(BGs[iCnt].id)
    sRez = sRez..symSep..tostring(sD or 0); iCnt = iCnt + 1
  end; sRez = sRez:sub(2,-1); LogTable(BGs,"BodyGroup")
  LogInstance("Success <"..sRez..">"); return sRez
end

function AttachBodyGroups(ePiece,sBgID)
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Base entity invalid"); return false end
  local sBgID = tostring(sBgID or ""); LogInstance("<"..sBgID..">")
  local iCnt, BGs = 1, ePiece:GetBodyGroups()
  local IDs = GetOpVar("OPSYM_SEPARATOR"):Explode(sBgID)
  while(BGs[iCnt] and IDs[iCnt]) do local itrBG = BGs[iCnt]
    local maxID = (ePiece:GetBodygroupCount(itrBG.id) - 1)
    local itrID = mathClamp(mathFloor(tonumber(IDs[iCnt]) or 0),0,maxID)
    LogInstance("SetBodygroup("..itrBG.id..","..itrID..") ["..maxID.."]")
    ePiece:SetBodygroup(itrBG.id,itrID); iCnt = iCnt + 1
  end; LogInstance("Success"); return true
end

function SetPosBound(ePiece,vPos,oPly,sMode)
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Entity invalid"); return false end
  if(not IsHere(vPos)) then
    LogInstance("Position missing"); return false end
  if(not IsPlayer(oPly)) then
    LogInstance("Player <"..tostring(oPly).."> invalid"); return false end
  local sMode = tostring(sMode or "LOG") -- Error mode is "LOG" by default
  if(sMode == "OFF") then ePiece:SetPos(vPos)
    LogInstance("("..sMode..") Skip"); return true end
  if(utilIsInWorld(vPos)) then ePiece:SetPos(vPos) else ePiece:Remove()
    if(sMode == "HINT" or sMode == "GENERIC" or sMode == "ERROR") then
      Notify(oPly,"Position out of map bounds!",sMode) end
    LogInstance("("..sMode..") Position ["..tostring(vPos).."] out of map bounds"); return false
  end; LogInstance("("..sMode..") Success"); return true
end

function MakePiece(pPly,sModel,vPos,aAng,nMass,sBgSkIDs,clColor,sMode)
  if(CLIENT) then LogInstance("Working on client"); return nil end
  if(not IsPlayer(pPly)) then -- If not player we cannot register limit
    LogInstance("Player missing <"..tostring(pPly)..">"); return nil end
  local sLimit, sClass = GetOpVar("CVAR_LIMITNAME"), GetOpVar("ENTITY_DEFCLASS")
  if(not pPly:CheckLimit(sLimit)) then -- Check internal limit
    LogInstance("Track limit reached"); return nil end
  if(not pPly:CheckLimit("props")) then -- Check the props limit
    LogInstance("Prop limit reached"); return nil end
  local stPiece = CacheQueryPiece(sModel) if(not IsHere(stPiece)) then
    LogInstance("Record missing for <"..sModel..">"); return nil end
  local ePiece = entsCreate(GetTerm(stPiece.Unit, sClass, sClass))
  if(not (ePiece and ePiece:IsValid())) then -- Create the piece unit
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
  if(not AttachBodyGroups(ePiece,BgSk[1])) then ePiece:Remove()
    LogInstance("Failed attaching bodygroups"); return nil end
  if(not AttachAdditions(ePiece)) then ePiece:Remove()
    LogInstance("Failed attaching additions"); return nil end
  pPly:AddCount(sLimit , ePiece); pPly:AddCleanup(sLimit , ePiece) -- This sets the ownership
  pPly:AddCount("props", ePiece); pPly:AddCleanup("props", ePiece) -- To be deleted with clearing props
  LogInstance("{"..tostring(ePiece).."}"..sModel); return ePiece
end

function UnpackPhysicalSettings(ePiece)
  if(CLIENT) then LogInstance("Working on client"); return true end
  if(not (ePiece and ePiece:IsValid())) then   -- Cannot manipulate invalid entities
    LogInstance("Piece entity invalid "..GetReport(ePiece)); return false end
  local pyPiece = ePiece:GetPhysicsObject()    -- Get the physics object
  if(not (pyPiece and pyPiece:IsValid())) then -- Cannot manipulate invalid physics
    LogInstance("Piece physical object invalid "..GetReport(ePiece)); return false end
  local bPi, bFr = ePiece.PhysgunDisabled, (not pyPiece:IsMotionEnabled())
  local bGr, sPh = pyPiece:IsGravityEnabled(), pyPiece:GetMaterial()
  return true, bPi, bFr, bGr, sPh -- Returns status and settings
end

function ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
  if(CLIENT) then LogInstance("Working on client"); return true end
  local bPi, bFr = (tobool(bPi) or false), (tobool(bFr) or false)
  local bGr, sPh = (tobool(bGr) or false),  tostring(sPh or "")
  LogInstance("{"..tostring(bPi)..","..tostring(bFr)..","..tostring(bGr)..","..sPh.."}")
  if(not (ePiece and ePiece:IsValid())) then   -- Cannot manipulate invalid entities
    LogInstance("Piece entity invalid "..GetReport(ePiece)); return false end
  local pyPiece = ePiece:GetPhysicsObject()    -- Get the physics object
  if(not (pyPiece and pyPiece:IsValid())) then -- Cannot manipulate invalid physics
    LogInstance("Piece physical object invalid "..GetReport(ePiece)); return false end
  local arSettings = {bPi,bFr,bGr,sPh}  -- Initialize dupe settings using this array
  ePiece.PhysgunDisabled = bPi          -- If enabled stop the player from grabbing the track piece
  ePiece:SetUnFreezable(bPi)            -- If enabled stop the player from hitting reload to mess it all up
  ePiece:SetMoveType(MOVETYPE_VPHYSICS) -- Moves and behaves like a normal prop
  -- Delay the freeze by a tiny amount because on physgun snap the piece
  -- is unfrozen automatically after physgun drop hook call
  timerSimple(GetOpVar("DELAY_FREEZE"), function() -- If frozen motion is disabled
    LogInstance("Freeze", "*DELAY_FREEZE");  -- Make sure that the physics are valid
    if(pyPiece and pyPiece:IsValid()) then pyPiece:EnableMotion(not bFr) end end )
  constructSetPhysProp(nil,ePiece,0,pyPiece,{GravityToggle = bGr, Material = sPh})
  duplicatorStoreEntityModifier(ePiece,GetOpVar("TOOLNAME_PL").."dupe_phys_set",arSettings)
  LogInstance("Success"); return true
end

--[[
 * Creates anchor constraints between the pice and the base prop
 * ePiece > The piece entity to be attached
 * eBase  > Base enity the piece is attached to
 * bWe    > Weld constraint flag ( Weld )
 * bNc    > NoCollide constraint flag ( NoCollide )
 * bNw    > NoCollideWorld constraint flag ( AdvBallsocket )
 * nFm    > Force limit of the contraint created. Defaults to never break
]]
function ApplyPhysicalAnchor(ePiece,eBase,bWe,bNc,bNw,nFm)
  if(CLIENT) then LogInstance("Working on client"); return true end
  local bWe, bNc = (tobool(bWe) or false), (tobool(bNc) or false)
  local nFm, bNw = (tonumber(nFm)  or  0), (tobool(bNw) or false)
  LogInstance("{"..tostring(bWe)..","..tostring(bNc)
            ..","..tostring(bNw)..","..tostring(nFm).."}")
  local cnW, cnN, cnG -- Create local references for constraints
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Piece invalid "..GetReport(ePiece)); return false, cnW, cnN, cnG  end
  if(constraintCanConstrain(ePiece, 0)) then -- Check piece for contrainability
    -- Weld on pieces between each other
    if(bWe) then -- Weld using force limit given here V
      if(eBase and eBase:IsValid()) then
        if(constraintCanConstrain(eBase, 0)) then
          cnW = constraintWeld(ePiece, eBase, 0, 0, nFm, false, false)
          if(cnW and cnW:IsValid()) then
            ePiece:DeleteOnRemove(cnW); eBase:DeleteOnRemove(cnW)
          else LogInstance("Weld ignored "..GetReport(cnW)) end
        else LogInstance("Weld base unconstrained "..GetReport(eBase)) end
      else LogInstance("Weld base invalid "..GetReport(eBase)) end
    end
    -- NoCollide on pieces between each other made separately
    if(bNc) then
      if(eBase and eBase:IsValid()) then
        if(constraintCanConstrain(eBase, 0)) then
          cnN = constraintNoCollide(ePiece, eBase, 0, 0)
          if(cnN and cnN:IsValid()) then
            ePiece:DeleteOnRemove(cnN); eBase:DeleteOnRemove(cnN)
          else LogInstance("NoCollide ignored "..GetReport(cnN)) end
        else LogInstance("NoCollide base unconstrained "..GetReport(eBase)) end
      else LogInstance("NoCollide base invalid "..GetReport(eBase)) end
    end
    -- NoCollide between piece and world
    if(bNw) then local eWorld = gameGetWorld()
      if(eWorld and eWorld:IsWorld()) then
        if(constraintCanConstrain(eWorld, 0)) then
          local nA, vO = 180, GetOpVar("VEC_ZERO")
          cnG = constraintAdvBallsocket(ePiece, eWorld,
            0, 0, vO, vO, nFm, 0, -nA, -nA, -nA, nA, nA, nA, 0, 0, 0, 1, 1)
          if(cnG and cnG:IsValid()) then ePiece:DeleteOnRemove(cnG)
          else LogInstance("AdvBallsocket ignored "..GetReport(cnG)) end
        else LogInstance("AdvBallsocket base unconstrained "..GetReport(eWorld)) end
      else LogInstance("AdvBallsocket base invalid "..GetReport(eWorld)) end
    end
  else LogInstance("Unconstrained <"..ePiece:GetModel()..">") end
  LogInstance("Success"); return true, cnW, cnN, cnG
end

function MakeAsmConvar(sName, vVal, tBord, vFlg, vInf)
  if(not IsString(sName)) then
    LogInstance("Name mismatch "..GetReport(sName)); return nil end
  local sLow = (IsExact(sName) and sName:sub(2,-1) or (GetOpVar("TOOLNAME_PL")..sName)):lower()
  local cVal = (tonumber(vVal) or tostring(vVal)); LogInstance("("..sLow..")["..tostring(cVal).."]")
  local sInf, nFlg = tostring(vInf or ""), mathFloor(tonumber(vFlg) or 0)
  SetBorder(sLow, (tBord and tBord[1] or nil), (tBord and tBord[2] or nil))
  return CreateConVar(sLow, cVal, nFlg, sInf)
end

function GetAsmConvar(sName, sMode)
  if(not IsString(sName)) then
    LogInstance("Name mismatch "..GetReport(sName)); return nil end
  if(not IsString(sMode)) then
    LogInstance("Mode mismatch "..GetReport(sMode)); return nil end
  local sLow = (IsExact(sName) and sName:sub(2,-1) or (GetOpVar("TOOLNAME_PL")..sName)):lower()
  local CVar = GetConVar(sLow); if(not IsHere(CVar)) then
    LogInstance("("..sLow..", "..sMode..") Missing object"); return nil end
  if    (sMode == "INT") then return (tonumber(BorderValue(CVar:GetInt()   , sLow)) or 0)
  elseif(sMode == "FLT") then return (tonumber(BorderValue(CVar:GetFloat() , sLow)) or 0)
  elseif(sMode == "STR") then return (tostring(BorderValue(CVar:GetString(), sLow)) or "")
  elseif(sMode == "BUL") then return (CVar:GetBool() or false)
  elseif(sMode == "DEF") then return  CVar:GetDefault()
  elseif(sMode == "INF") then return  CVar:GetHelpText()
  elseif(sMode == "NAM") then return  CVar:GetName()
  elseif(sMode == "OBJ") then return  CVar
  end; LogInstance("("..sName..", "..sMode..") Missed mode"); return nil
end

function SetAsmConvar(pPly,sName,snVal)
  if(not IsString(sName)) then -- Make it like so the space will not be forgotten
    LogInstance("Name mismatch "..GetReport(sName)); return nil end
  local sFmt, sPrf = GetOpVar("FORM_CONCMD"), GetOpVar("TOOLNAME_PL")
  local sLow = (IsExact(sName) and sName:sub(2,-1) or (sPrf..sName)):lower()
  if(IsPlayer(pPly)) then -- Use the player when available
    return pPly:ConCommand(sFmt:format(sLow, tostring(snVal or "")).."\n")
  end; return RunConsoleCommand(sLow, tostring(snVal or ""))
end

function GetPhrase(sKey)
  if(SERVER) then return end
  local sDef = GetOpVar("MISS_NOTR")
  local tSet = GetOpVar("LOCALIFY_TABLE"); if(not IsHere(tSet)) then
    LogInstance("Skip <"..sKey..">"); return GetOpVar("MISS_NOTR") end
  local sKey = tostring(sKey) if(not IsHere(tSet[sKey])) then
    LogInstance("Miss <"..sKey..">"); return GetOpVar("MISS_NOTR") end
  return (tSet[sKey] or GetOpVar("MISS_NOTR")) -- Translation fail safe
end

local function GetLocalify(sCode)
  local sCode = tostring(sCode or GetOpVar("MISS_NOAV"))
  if(SERVER) then LogInstance("("..sCode..") Not client"); return nil end
  local sTool, sLimit = GetOpVar("TOOLNAME_NL"), GetOpVar("CVAR_LIMITNAME")
  local sPath = GetOpVar("FORM_LANGPATH"):format("", sCode..".lua") -- Translation file path
  if(not fileExists("lua/"..sPath, "GAME")) then
    LogInstance("("..sCode..") Missing"); return nil end
  local fCode = CompileFile(sPath); if(not fCode) then
    LogInstance("("..sCode..") No function"); return nil end
  local bFunc, fFunc = pcall(fCode); if(not bFunc) then
    LogInstance("("..sCode..")[1] "..fFunc); return nil end
  local bCode, tCode = pcall(fFunc, sTool, sLimit); if(not bCode) then
    LogInstance("("..sCode..")[2] "..tCode); return nil end
  return tCode -- The successfully extracted translations
end

function InitLocalify(sCode)
  local cuCod = tostring(sCode or GetOpVar("MISS_NOAV"))
  if(not CLIENT) then LogInstance("("..cuCod..") Not client"); return nil end
  local thSet = GetOpVar("LOCALIFY_TABLE"); tableEmpty(thSet)
  local auCod = GetOpVar("LOCALIFY_AUTO") -- Automatic translation code
  local auSet = GetLocalify(auCod); if(not auSet) then
    LogInstance("Base mismatch <"..auCod..">"); return nil end
  if(cuCod ~= auCod) then local cuSet = GetLocalify(cuCod)
    if(cuSet) then -- When the language infornation is extracted apply on success
      for key, val in pairs(auSet) do auSet[key] = (cuSet[key] or auSet[key]) end
    else LogInstance("Custom skipped <"..cuCod..">") end -- Apply auto code
  end; for key, val in pairs(auSet) do thSet[key] = auSet[key]; languageAdd(key, val) end
end

--[[
 * Checks if the ghosts stack contains items
 * Ghosting is client side only
 * Could you do it for a Scooby snacks?
]]
function HasGhosts()
  if(SERVER) then return false end
  local tGho = GetOpVar("ARRAY_GHOST")
  local eGho, nSiz = tGho[1], tGho.Size
  return (eGho and eGho:IsValid() and nSiz and nSiz > 0)
end

--[[
 * Fades the ghosts stack and makes the elements invisible
 * bNoD > The state of the No-Draw flag
 * Wait a minute, ghosts can't leave fingerprints!
]]
function FadeGhosts(bNoD)
  if(SERVER) then return true end
  if(not HasGhosts()) then return true end
  local tGho = GetOpVar("ARRAY_GHOST")
  local cPal = MakeContainer("COLORS_LIST")
  for iD = 1, tGho.Size do local eGho = tGho[iD]
    if(eGho and eGho:IsValid()) then
      eGho:SetNoDraw(bNoD); eGho:DrawShadow(false)
      eGho:SetColor(cPal:Select("gh"))
    end
  end; return true
end

--[[
 * Clears the ghosts stack and deletes all the items
 * vSiz > The custom stack size. Nil makes it take the `tGho.Size`
 * bCol > When enabled calls the garbage collector
 * Well gang, I guess that wraps up the mystery.
]]
function ClearGhosts(vSiz, bCol)
  if(SERVER) then return true end
  local tGho = GetOpVar("ARRAY_GHOST")
  local iSiz = mathCeil(tonumber(vSiz) or tGho.Size)
  for iD = 1, iSiz do local eGho = tGho[iD]
    if(eGho and eGho:IsValid()) then
      eGho:SetNoDraw(true); eGho:Remove()
    end; eGho, tGho[iD] = nil, nil
  end; tGho.Size, tGho.Slot = 0, GetOpVar("MISS_NOMD")
  if(bCol) then collectgarbage() end; return true
end

--[[
 * Creates a single ghost entity for populating the stack
 * sModel > The model which the creation is requested for
 * vPos   > Position for the entity, otherwise zero is used
 * aAng   > Angles for the entity, otherwise zero is used
 * It must have been our imagination.
]]
local function MakeEntityGhost(sModel, vPos, aAng)
  local cPal = MakeContainer("COLORS_LIST")
  local eGho = entsCreateClientProp(sModel)
  if(not (eGho and eGho:IsValid())) then eGho = nil
    LogInstance("Ghost invalid "..sModel); return nil end
  eGho:SetModel(sModel)
  eGho:SetPos(vPos or GetOpVar("VEC_ZERO"))
  eGho:SetAngles(aAng or GetOpVar("ANG_ZERO"))
  eGho:PhysicsDestroy()
  eGho:SetNoDraw(true)
  eGho:SetNotSolid(true)
  eGho:DrawShadow(false)
  eGho:SetSolid(SOLID_NONE)
  eGho:SetMoveType(MOVETYPE_NONE)
  eGho:SetCollisionGroup(COLLISION_GROUP_NONE)
  eGho:SetRenderMode(RENDERMODE_TRANSALPHA)
  eGho:SetColor(cPal:Select("gh"))
  eGho:Spawn()
  return eGho
end

--[[
 * Populates the ghost stack with the requested number of items
 * nCnt   > The ghost stack requested depth
 * sModel > The model which the creation is requested for
 * Not until we walk around the ghost town and see what we can find.
]]
function MakeGhosts(nCnt, sModel) -- Only he's not a shadow, he's a green ghost!
  if(SERVER) then return true end -- Ghosting is client side only
  local tGho = GetOpVar("ARRAY_GHOST") -- Read ghosts
  if(nCnt == 0 and tGho.Size == 0) then return true end -- Skip processing
  if(nCnt == 0 and tGho.Size ~= 0) then return ClearGhosts() end -- Disabled ghosting
  local iD = 1; FadeGhosts(true) -- Fade the current ghost stack
  while(iD <= nCnt) do local eGho = tGho[iD]
    if(eGho and eGho:IsValid() and eGho:GetModel() ~= sModel) then
      eGho:Remove(); tGho[iD] = nil; eGho = tGho[iD] end
    if(not (eGho and eGho:IsValid())) then
      tGho[iD] = MakeEntityGhost(sModel, vPos, vAng); eGho = tGho[iD]
      if(not (eGho and eGho:IsValid())) then ClearGhosts(iD)
        LogInstance("Invalid ["..iD.."]"..sModel); return false end
    end; iD = iD + 1 -- Fade all the ghosts and refresh these that must be drawn
  end -- Remove all others that must not be drawn to save memory
  for iK = iD, tGho.Size do -- Executes only when (nCnt <= tGho.Size)
    local eGho = tGho[iD]; if(eGho and eGho:IsValid()) then
      eGho:SetNoDraw(true); eGho:Remove(); eGho = nil end; tGho[iD] = nil
  end; tGho.Size, tGho.Slot = nCnt, sModel; return true
end

function GetHookInfo(tInfo, sW)
  if(SERVER) then return nil end
  local sMod = GetOpVar("TOOL_DEFMODE")
  local sWep = tostring(sW or sMod)
  local oPly = LocalPlayer(); if(not IsPlayer(oPly)) then
    LogInstance("Player invalid",tInfo); return nil end
  local actSwep = oPly:GetActiveWeapon(); if(not IsValid(actSwep)) then
    LogInstance("Swep invalid",tInfo); return nil end
  if(actSwep:GetClass() ~= sWep) then
    LogInstance("("..sWep..") Swep other",tInfo); return nil end
  if(sWep ~= sMod) then return oPly, actSwep end
  if(actSwep:GetMode() ~= GetOpVar("TOOLNAME_NL")) then
    LogInstance("Tool different",tInfo); return nil end
  -- Here player is holding the track assembly tool
  local actTool = actSwep:GetToolObject(); if(not actTool) then
    LogInstance("Tool invalid",tInfo); return nil end
  return oPly, actSwep, actTool
end

function GetConvarList(tC)
  local sT = GetOpVar("TOOLNAME_PL")
  local tI = GetOpVar("TABLE_CONVARLIST")
  if(IsTable(tC)) then tableEmpty(tI)
    for key, val in pairs(tC) do tI[sT..key] = val end
  end; return tI
end

function GetLinearSpace(nBeg, nEnd, nAmt)
  local fAmt = mathFloor(tonumber(nAmt) or 0); if(fAmt < 0) then
    LogInstance("Samples count invalid <"..tostring(fAmt)..">"); return nil end
  local iAmt, dAmt = (fAmt + 1), (nEnd - nBeg)
  local fBeg, fEnd, nAdd = 1, (fAmt+2), (dAmt / iAmt)
  local tO = {[fBeg] = nBeg, [fEnd] = nEnd}
  while(fBeg <= fEnd) do fBeg, fEnd = (fBeg + 1), (fEnd - 1)
    tO[fBeg], tO[fEnd] = (tO[fBeg-1] + nAdd), (tO[fEnd+1] - nAdd)
  end return tO
end

local function GetCatmullRomCurveTangent(cS, cE, nT, nA)
  local vD = Vector(); vD:Set(cE); vD:Sub(cS)
  return ((vD:Length() ^ (tonumber(nA) or 0.5)) + nT)
end

local function GetCatmullRomCurveSegment(vP0, vP1, vP2, vP3, nN, nA)
  local nT0, tC = 0, {} -- Start point is always zero
  local nT1 = GetCatmullRomCurveTangent(vP0, vP1, nT0, nA)
  local nT2 = GetCatmullRomCurveTangent(vP1, vP2, nT1, nA)
  local nT3 = GetCatmullRomCurveTangent(vP2, vP3, nT2, nA)
  local tTN = GetLinearSpace(nT1, nT2, nN)
  local vB1, vB2 = Vector(), Vector()
  local vA1, vA2, vA3 = Vector(), Vector(), Vector()
  for iD = 1, #tTN do tC[iD] = Vector(); local nTn, vTn = tTN[iD], tC[iD]
    vA1:Set(vP0); vA1:Mul((nT1-nTn)/(nT1-nT0)); vA1:Add(vP1 * ((nTn-nT0)/(nT1-nT0)))
    vA2:Set(vP1); vA2:Mul((nT2-nTn)/(nT2-nT1)); vA2:Add(vP2 * ((nTn-nT1)/(nT2-nT1)))
    vA3:Set(vP2); vA3:Mul((nT3-nTn)/(nT3-nT2)); vA3:Add(vP3 * ((nTn-nT2)/(nT3-nT2)))
    vB1:Set(vA1); vB1:Mul((nT2-nTn)/(nT2-nT0)); vB1:Add(vA2 * ((nTn-nT0)/(nT2-nT0)))
    vB2:Set(vA2); vB2:Mul((nT3-nTn)/(nT3-nT1)); vB2:Add(vA3 * ((nTn-nT1)/(nT3-nT1)))
    vTn:Set(vB1); vTn:Mul((nT2-nTn)/(nT2-nT1)); vTn:Add(vB2 * ((nTn-nT1)/(nT2-nT1)))
  end; return tC
end

local function GetCatmullRomCurve(tV, nT, nA, tO)
  if(not IsTable(tV)) then LogInstance("Vertices mismatch "..GetReport(tV)); return nil end
  if(IsEmpty(tV)) then LogInstance("Vertices missing "..GetReport(tV)); return nil end
  local nT, nV = mathFloor(tonumber(nT) or 200), #tV; if(nT < 0) then
    LogInstance("Curve samples mismatch "..GetReport(nT)); return nil end
  if(not (tV[1] and tV[2])) then LogInstance("Two vertices are needed"); return nil end
  if(nA and not IsNumber(nA)) then LogInstance("Factor mismatch "..GetReport(nA)); return nil end
  local vM, iC, cS, cE, tN = GetOpVar("EPSILON_ZERO"), 1, Vector(), Vector(), (tO or {})
  cS:Set(tV[ 1]); cS:Sub(tV[2])   ; cS:Normalize(); cS:Mul(vM); cS:Add(tV[1])
  cE:Set(tV[nV]); cE:Sub(tV[nV-1]); cE:Normalize(); cE:Mul(vM); cE:Add(tV[nV])
  tableInsert(tV, 1, cS); tableInsert(tV, cE); nV = (nV + 2); tableEmpty(tN)
  for iD = 1, (nV-3) do
    local cA, cB, cC, cD = tV[iD], tV[iD+1], tV[iD+2], tV[iD+3]
    local tS = GetCatmullRomCurveSegment(cA, cB, cC, cD, nT, nA)
    for iK = 1, (nT+1) do tN[iC] = tS[iK]; iC = (iC + 1) end
  end; tN[iC] = Vector(); tN[iC]:Set(tV[nV-1])
  tableRemove(tV, 1); tableRemove(tV); return tN
end

function CalculateRomCurve(oPly, nSmp, nFac)
  local tC = GetCacheCurve(oPly); if(not tC) then
    LogInstance("Curve missing"); return nil end
  GetCatmullRomCurve(tC.Node, nSmp, nFac, tC.CNode)
  GetCatmullRomCurve(tC.Norm, nSmp, nFac, tC.CNorm)
  tC.CSize = (tC.Size - 1) * nSmp + tC.Size
  return tC -- Return the updated reference
end

function IntersectLineSphere(vS, vE, vC, nR)
  local nE = GetOpVar("EPSILON_ZERO")
  local vD = Vector(); vD:Set(vE); vD:Sub(vS)
  local nA = vD:LengthSqr(); if(nA < nE) then
    LogInstance("Norm less than margin"); return nil end
  local vR = Vector(); vR:Set(vS) vR:Sub(vC)
  local nB, nC = 2 * vD:Dot(vR), (vR:LengthSqr() - nR^2)
  local nD = (nB^2 - 4*nA*nC); if(nD < 0) then
    LogInstance("Imaginary roots"); return nil end
  local dA = (1/(2*nA)); nD, nB = dA*math.sqrt(nD), -nB*dA
  local xP = Vector(); xP:Set(vD); xP:Mul(nB + nD); xP:Add(vS)
  local xM = Vector(); xM:Set(vD); xM:Mul(nB - nD); xM:Add(vS)
  return xP, xM -- Return the intersected +/- root point
end

function IsAmongLine(vO, vS, vE)
  local nE = GetOpVar("EPSILON_ZERO")
  local vD = Vector(); vD:Set(vE); vD:Sub(vS)
  local oS = Vector(); oS:Set(vS); oS:Sub(vO)
  local oE = Vector(); oE:Set(vE); oE:Sub(vO)
  local rS = oS:Cross(vD):LengthSqr()
  local rE = oE:Cross(vD):LengthSqr()
  if(rS >= nE or rE >= nE) then return false end
  return (oS:Dot(vD) * oE:Dot(vD) < 0)
end
