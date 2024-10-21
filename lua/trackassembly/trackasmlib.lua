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

local TOP                   = TOP
local KEY_LSHIFT            = KEY_LSHIFT
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
local select                         = select
local pcall                          = pcall
local Angle                          = Angle
local Color                          = Color
local pairs                          = pairs
local print                          = print
local tobool                         = tobool
local isbool                         = isbool
local istable                        = istable
local isnumber                       = isnumber
local isstring                       = isstring
local isvector                       = isvector
local isangle                        = isangle
local ismatrix                       = ismatrix
local isfunction                     = isfunction
local Vector                         = Vector
local Matrix                         = Matrix
local unpack                         = unpack
local include                        = include
local IsEntity                       = IsEntity
local IsValid                        = IsValid
local Material                       = Material
local require                        = require
local Time                           = CurTime
local EntityID                       = Entity
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
local LocalToWorld                   = LocalToWorld
local IsUselessModel                 = IsUselessModel
local SafeRemoveEntityDelayed        = SafeRemoveEntityDelayed
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
local utilPrecacheModel              = util and util.PrecacheModel
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
local mathMax                        = math and math.max
local mathMin                        = math and math.min
local mathCeil                       = math and math.ceil
local mathModf                       = math and math.modf
local mathSqrt                       = math and math.sqrt
local mathFloor                      = math and math.floor
local mathClamp                      = math and math.Clamp
local mathAtan2                      = math and math.atan2
local mathRemap                      = math and math.Remap
local mathRound                      = math and math.Round
local mathRandom                     = math and math.random
local drawRoundedBox                 = draw and draw.RoundedBox
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
local tableSort                      = table and table.sort
local tableConcat                    = table and table.concat
local tableRemove                    = table and table.remove
local debugGetinfo                   = debug and debug.getinfo
local debugTrace                     = debug and debug.Trace
local renderDrawLine                 = render and render.DrawLine
local renderDrawSphere               = render and render.DrawSphere
local renderSetMaterial              = render and render.SetMaterial
local renderSetBlend                 = render and render.SetBlend
local renderGetBlend                 = render and render.GetBlend
local stringGetFileName              = string and string.GetFileFromFilename
local surfaceSetFont                 = surface and surface.SetFont
local surfaceDrawPoly                = surface and surface.DrawPoly
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
local languageGetPhrase              = language and language.GetPhrase
local constructSetPhysProp           = construct and construct.SetPhysProp
local constraintWeld                 = constraint and constraint.Weld
local constraintGetTable             = constraint and constraint.GetTable
local constraintNoCollide            = constraint and constraint.NoCollide
local constraintCanConstrain         = constraint and constraint.CanConstrain
local constraintAdvBallsocket        = constraint and constraint.AdvBallsocket
local duplicatorStoreEntityModifier  = duplicator and duplicator.StoreEntityModifier

---------------- CACHES SPACE --------------------

local libCache  = {} -- Used to cache stuff in a pool
local libAction = {} -- Used to attach external function to the lib
local libOpVars = {} -- Used to Store operational variable values
local libPlayer = {} -- Used to allocate personal space for players
local libQTable = {} -- Used to allocate SQL table builder objects
local libModel  = {} -- Used to store the the valid models status

module("trackasmlib")

---------------------------- PRIMITIVES ----------------------------

function IsHere(vVal)
  return (vVal ~= nil)
end

function GetOpVar(sName)
  return libOpVars[sName]
end

function SetOpVar(sName, vVal)
  libOpVars[sName] = vVal
end

function IsInit()
  return IsHere(GetOpVar("TIME_INIT"))
end

function GetInstPref()
  return (CLIENT and "cl_" or SERVER and "sv_" or "na_")
end

function IsBlank(vVal)
  if(not isstring(vVal)) then return false end
  return (vVal == "")
end

function IsNull(vVal)
  if(not isstring(vVal)) then return false end
  return (vVal == GetOpVar("MISS_NOSQL"))
end

function IsDisable(vVal)
  if(not isstring(vVal)) then return false end
  return (vVal:sub(1,1) == GetOpVar("OPSYM_DISABLE"))
end

function IsEmpty(tVal)
  return (istable(tVal) and not next(tVal))
end

function IsExact(vVal)
  if(not isstring(vVal)) then return false end
  return (vVal:sub(1,1) == "*")
end

function GetNameExp(vVal)
  local bExa = IsExact(vVal)
  local sPrf = GetOpVar("TOOLNAME_PL")
  local sNam = (bExa and vVal:sub(2, -1) or vVal)
  local sKey = (bExa and vVal:sub(2, -1) or (sPrf..vVal))
  return sKey:lower(), sNam:lower(), bExa -- Extracted convar name
end

function IsPlayer(oPly)
  if(not IsHere(oPly))    then return false end
  if(not IsEntity(oPly))  then return false end
  if(not oPly:IsValid())  then return false end
  if(not oPly:IsPlayer()) then return false end
  return true
end

function IsOther(oEnt)
  if(not IsHere(oEnt))   then return true end
  if(not IsEntity(oEnt)) then return true end
  if(not oEnt:IsValid()) then return true end
  if(oEnt:IsPlayer())    then return true end
  if(oEnt:IsVehicle())   then return true end
  if(oEnt:IsNPC())       then return true end
  if(oEnt:IsRagdoll())   then return true end
  if(oEnt:IsWeapon())    then return true end
  if(oEnt:IsWidget())    then return true end
  return false
end

--[[
 * Reports the type and actual value for one argument
 * Reports vararg containing many values concatenated
 * The return value must always return a string
 * Vararg: (66)           > {number}|66|
 * Vararg: (66,nil,"asd") > |66|nil|asd|
]]
function GetReport(...)
  local sD = (GetOpVar("OPSYM_VERTDIV") or "|")
        sD = tostring(sD):sub(1, 1) -- First symbol
  local tV, sV = {...}, sD -- Use vertical divider
  local nV = select("#", ...) -- Read report count
  if(nV == 0) then return sV end -- Nothing to report
  if(nV == 1) then sV = "{"..type(tV[1]).."}"..sV end
  for iV = 1, nV do sV = sV..tostring(tV[iV])..sD end
  return sV -- Concatenate vararg and return a string
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

-- Uses custom model check to remove the pre-caching overhead
libModel.Skip = {} -- General disabled models for spawning
libModel.Skip[""] = true -- Empty string
libModel.Skip["models/error.mdl"] = true
libModel.File = {} -- When the file is available
libModel.Deep = {} -- When the model is spawned
function IsModel(sModel, bDeep)
  if(not IsHere(sModel)) then
    LogInstance("Missing "..GetReport(sModel)); return false end
  if(not isstring(sModel)) then
    LogInstance("Mismatch "..GetReport(sModel)); return false end
  if(libModel.Skip[sModel]) then
    LogInstance("Skipped "..GetReport(sModel)); return false end
  local vDeep = libModel.Deep[sModel] -- Read model validation status
  if(SERVER and bDeep and IsHere(vDeep)) then return vDeep end -- Will spawn
  local vFile = libModel.File[sModel] -- File current status
  if(IsHere(vFile)) then -- File validation status is present
    if(not vFile) then -- File is validated as invalid path
      LogInstance("Invalid file "..GetReport(sModel)); return vFile end
  else  -- File validation status update. Status is missing. Calculate.
    vFile = false; libModel.File[sModel] = vFile -- Assume being invalid
    if(IsUselessModel(sModel)) then --Check model being Aqua from Konosuba
      LogInstance("File useless "..GetReport(sModel)); return vFile end
    if(not fileExists(sModel, "GAME")) then -- Check model being a unicorn
      LogInstance("File missing "..GetReport(sModel)); return vFile end
    vFile = true; libModel.File[sModel] = vFile -- The file validated
    LogInstance("File >> "..GetReport(vDeep, vFile, sModel))
  end -- At this point file path is valid. Have to validate model
  if(CLIENT or not bDeep) then return vFile end -- File is validated
  utilPrecacheModel(sModel); vDeep = utilIsValidModel(sModel)
  libModel.Deep[sModel] = vDeep -- Store deep validation
  LogInstance("Deep >> "..GetReport(vDeep, vFile, sModel))
  return vDeep -- Gonna spawn on the server. Must validate.
end

-- Strips a string from quotes
function GetStrip(vV, vQ)
  local sV = tostring(vV or ""):Trim()
  local sQ = tostring(vQ or "\""):sub(1,1)
  if(sV:sub( 1, 1) == sQ) then sV = sV:sub(2,-1) end
  if(sV:sub(-1,-1) == sQ) then sV = sV:sub(1,-2) end
  return sV:Trim()
end

function GetSnap(nV, aV)
  local aV = tonumber(aV)
  if(not aV) then return nV end
  local mV = mathAbs(aV)
  local cV = mathRound(nV / mV) * mV
  if(aV > 0 and cV > nV) then return cV end
  if(aV > 0 and cV < nV) then return (cV + mV) end
  if(aV < 0 and cV > nV) then return (cV - mV) end
  if(aV < 0 and cV < nV) then return cV end
  return (nV + aV)
end

function GetGrid(nV, aV)
  local aV = tonumber(aV)
  if(not aV) then return nV end
  local nA = GetSnap(nV,  aV)
  local nB = GetSnap(nV, -aV)
  local vA = mathAbs(nV - nA)
  local vB = mathAbs(nV - nB)
  if(vA < vB and nV > 0) then
    return mathCeil(nA)
  elseif(vA < vB and nV < 0) then
    return mathFloor(nA)
  elseif(vA > vB and nV > 0) then
    return mathFloor(nB)
  elseif(vA > vB and nV < 0) then
    return mathCeil(nB)
  end; return nV
end

function GetOwner(oEnt)
  if(not (oEnt and oEnt:IsValid())) then return nil end
  local set, ows = oEnt.OnDieFunctions
  -- Use CPPI first when installed. If fails search down
  ows = ((CPPI and oEnt.CPPIGetOwner) and oEnt:CPPIGetOwner() or nil)
  if(IsPlayer(ows)) then return ows else ows = nil end
  -- Try the direct entity methods. Extract owner from functions
  ows = (oEnt.GetOwner and oEnt:GetOwner() or nil)
  if(IsPlayer(ows)) then return ows else ows = nil end
  ows = (oEnt.GetCreator and oEnt:GetCreator() or nil)
  if(IsPlayer(ows)) then return ows else ows = nil end
  -- Try then various entity internal key values
  ows = oEnt.player; if(IsPlayer(ows)) then return ows else ows = nil end
  ows = oEnt.Owner; if(IsPlayer(ows)) then return ows else ows = nil end
  ows = oEnt.owner; if(IsPlayer(ows)) then return ows else ows = nil end
  if(set) then -- Duplicator the functions are registered
    set = set.GetCountUpdate; ows = (set.Args and set.Args[1] or nil)
    if(IsPlayer(ows)) then return ows else ows = nil end
    set = set.undo1; ows = (set.Args and set.Args[1] or nil)
    if(IsPlayer(ows)) then return ows else ows = nil end
  end; return ows -- No owner is found. Nothing is returned
end

------------------ LOGS ------------------------

function GetLogID()
  local nNum, fMax = GetOpVar("LOG_CURLOGS"), GetOpVar("LOG_FORMLID")
  if(not (nNum and fMax)) then return "" end; return fMax:format(nNum)
end

--[[
  sMsg > Message being displayed
  bCon > Force output in the console
]]
function Log(vMsg, bCon)
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
  Return: setting exist, message found
]]
function IsLogHere(sMsg, sKey)
  local sMsg = tostring(sMsg or "")
  local sKey = tostring(sKey or "")
  if(IsBlank(sKey)) then return nil end
  local tLog = GetOpVar("LOG_"..sKey)
  if(istable(tLog) and tLog[1]) then
    local iCnt = 1; while(tLog[iCnt]) do
      if(sMsg:find(tostring(tLog[iCnt]))) then
        return true, true
      end; iCnt = iCnt + 1
    end; return true, false
  else return false, false end
end

--[[
  vMsg > Message being displayed
  vSrc > Name of the sub-routine call (string) or parameter stack (table)
  bCon > Force output in console flag
  iDbg > Debug table override depth
  tDbg > Debug table override
]]
function LogInstance(vMsg, vSrc, bCon, iDbg, tDbg)
  local nMax = (tonumber(GetOpVar("LOG_MAXLOGS")) or 0)
  if(nMax and (nMax <= 0)) then return end
  local vSrc, bCon, iDbg, tDbg = vSrc, bCon, iDbg, tDbg
  if(vSrc and istable(vSrc)) then -- Receive the stack as table
    vSrc, bCon, iDbg, tDbg = vSrc[1], vSrc[2], vSrc[3], vSrc[4] end
  iDbg = mathFloor(tonumber(iDbg) or 0); iDbg = ((iDbg > 0) and iDbg or nil)
  local tInfo = (iDbg and debugGetinfo(iDbg) or nil) -- Pass stack index
        tInfo = (tInfo or (tDbg and tDbg or nil))    -- Override debug information
        tInfo = (tInfo or debugGetinfo(2))           -- Default value
  local sDbg, sFunc = "", tostring(tInfo.name or "Incognito")
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
  bF, bL = IsLogHere(sData, "SKIP"); if(bF and bL) then return end
  bF, bL = IsLogHere(sData, "ONLY"); if(bF and not bL) then return end
  if(sLast == sData) then return end; SetOpVar("LOG_LOGLAST",sData)
  Log(sInst.." > "..sToolMD.." ["..sMoDB.."]"..sDbg.." "..sData, bCon)
end

function LogCeption(tT,sS,tP)
  local vK, sS = "", tostring(sS or "Data")
  if(not istable(tT)) then
    LogInstance("{"..type(tT).."}["..sS.."] = <"..tostring(tT)..">",tP); return nil end
  if(not IsHere(next(tT))) then
    LogInstance(sS.." = {}",tP); return nil end; LogInstance(sS.." = {}",tP)
  for k,v in pairs(tT) do
    if(isstring(k)) then
      vK = sS.."[\""..k.."\"]"
    else
      vK = sS.."["..tostring(k).."]"
    end
    if(not istable(v)) then
      if(isstring(v)) then
        LogInstance(vK.." = \""..v.."\"",tP)
      else
        LogInstance(vK.." = "..tostring(v),tP)
      end
    else
      if(v == tT) then LogInstance(vK.." = "..sS,tP)
      else LogCeption(v,vK,tP) end
    end
  end
end

function LogTable(tT, sS, vSrc, bCon, iDbg, tDbg)
  local vSrc, bCon, iDbg, tDbg = vSrc, bCon, iDbg, tDbg
  if(vSrc and istable(vSrc)) then -- Receive the stack as table
    vSrc, bCon, iDbg, tDbg = vSrc[1], vSrc[2], vSrc[3], vSrc[4] end
  local tP = {vSrc, bCon, iDbg, tDbg} -- Normalize parameters
  tP[1], tP[2] = tostring(vSrc or ""), tobool(bCon)
  tP[3], tP[4] = (nil), debugGetinfo(2); LogCeption(tT,sS,tP)
end

------------- VALUE ---------------

--[[
 * Applies border if exists to the input value
 * according to the given border name. Basically
 * custom version of a clamp with vararg border limits
]]
function BorderValue(nsVal, vKey)
  if(not IsHere(vKey)) then return nsVal end
  if(not (isstring(nsVal) or isnumber(nsVal))) then
    LogInstance("Value not comparable "..GetReport(nsVal)); return nsVal end
  local tB = GetOpVar("TABLE_BORDERS")[vKey]; if(not IsHere(tB)) then
    LogInstance("Missing "..GetReport(vKey)); return nsVal end
  if(tB[1] and nsVal < tB[1]) then return tB[1] end
  if(tB[2] and nsVal > tB[2]) then return tB[2] end
  return nsVal
end

function SetBorder(vKey, vLow, vHig)
  if(not IsHere(vKey)) then
    LogInstance("Key missing"); return false end
  local tB = GetOpVar("TABLE_BORDERS"); if(not IsHere(tB)) then
    LogInstance("List missing"); return false end
  local tU = tB[vKey]; if(IsHere(tU)) then
    LogInstance("Exists "..GetReport(vKey, tU[1], tU[2]))
  end; tB[vKey] = {vLow, vHig} -- Write the border in the list
  LogInstance("Apply "..GetReport(vKey, vLow, vHig)); return true
end

function GetBorder(vKey)
  if(not IsHere(vKey)) then
    LogInstance("Key missing"); return nil end
  local tB = GetOpVar("TABLE_BORDERS"); if(not IsHere(tB)) then
    LogInstance("List missing"); return nil end
  local tU = tB[vKey]; if(not IsHere(tU)) then
    LogInstance("Entry missing "..GetReport(vKey)); return nil end
  return unpack(tU)
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
  local nD = pPly:GetPos():Distance(vPos)
  return nS * mathClamp(nM / nD, 0, 5000)
end

--[[
 * Golden retriever. Retrieves file line as string
 * But seriously returns the sting line and EOF flag
 * pFile > The file to read the line of characters from
 * bCons > Keeps data consistency. Enable to skip trim
 * sChar > Custom pattern to be used when trimming
 * Returns line contents and reaching EOF flag
 * sLine > The line being read from the file
 * isEOF > Flag indicating pointer reached EOF
]]
function GetStringFile(pFile, bCons, sChar)
  if(not pFile) then LogInstance("No file"); return "", true end
  local sLine = (pFile:ReadLine() or "") -- Read one line at once
  local isEOF = pFile:EndOfFile() -- Check for file EOF status
  if(not bCons) then sLine = sLine:Trim(sChar) end
  return sLine, isEOF
end

function ToIcon(vKey, vVal)
  if(SERVER) then return nil end
  local tIcon = GetOpVar("TABLE_SKILLICON"); if(not IsHere(vKey)) then
    LogInstance("Invalid "..GetReport(vKey)); return nil end
  if(IsHere(vVal)) then tIcon[vKey] = tostring(vVal) end
  local sIcon = tIcon[vKey]; if(not IsHere(sIcon)) then
    LogInstance("Missing "..GetReport(vKey)); return nil end
  return GetOpVar("FORM_ICONS"):format(tostring(sIcon))
end

function WorkshopID(sKey, sID)
  if(SERVER) then return nil end
  local tID = GetOpVar("TABLE_WSIDADDON"); if(not isstring(sKey)) then
    LogInstance("Invalid "..GetReport(sKey)); return nil end
  local sWS = tID[sKey] -- Read the value under the key
  if(sID) then local sPS = tostring(sID or "") -- Convert argument
    local nS, nE = sPS:find(GetOpVar("PATTEM_WORKSHID")) -- Check ID
    if(nS and nE) then -- The number meets the format
      if(not sWS) then tID[sKey], sWS = sPS, sPS else -- Update value
        LogInstance("("..sKey..") Exists "..GetReport(sWS, sID))
      end -- Report overwrite value is present in the list
    else -- The number does not meet the format
      LogInstance("("..sKey..") Mismatch "..GetReport(sWS, sID))
    end -- Return the current value under the specified key
  end; return sWS
end

function IsFlag(vKey, vVal)
  local tFlag = GetOpVar("TABLE_FLAGS")
  if(not IsHere(tFlag)) then LogInstance("Missing "..GetReport(tFlag)); return nil end
  if(not IsHere(vKey)) then LogInstance("Invalid "..GetReport(vKey)); return nil end
  if(IsHere(vVal)) then tFlag[vKey] = tobool(vVal) end
  local bFlag = tFlag[vKey]; if(not IsHere(bFlag)) then
    LogInstance("Missing "..GetReport(vKey)); return nil end
  return tFlag[vKey] -- Return the flag status
end

----------------- INITAIALIZATION -----------------

function SetLogControl(nLines, bFile)
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
    LogInstance("Invalid "..GetReport(sKey)); return false end
  local tLogs, lbNam = GetOpVar("LOG_"..sKey), GetOpVar("NAME_LIBRARY")
  if(not tLogs) then LogInstance("Missing "..GetReport(sKey)); return false end
  local sBas, sSet = GetOpVar("DIRPATH_BAS"), GetOpVar("DIRPATH_SET")
  local fName = (sBas..sSet..lbNam.."_sl"..sKey:lower()..".txt")
  if(not fileExists(fName)) then
    LogInstance("Discard "..GetReport(sKey, fName)); return false end
  local S = fileOpen(fName, "rb", "DATA"); tableEmpty(tLogs)
  if(not S) then LogInstance("Failure "..GetReport(sKey, fName)); return false end
  local sLine, isEOF = "", false
  while(not isEOF) do sLine, isEOF = GetStringFile(S)
    if(not IsBlank(sLine)) then tableInsert(tLogs, sLine) end
  end; S:Close(); LogInstance("Success "..GetReport(sKey, fName)); return true
end

function InitBase(sName, sPurp)
  SetOpVar("TYPEMT_STRING",getmetatable("TYPEMT_STRING"))
  if(not isstring(sName)) then
    LogInstance("Name not string "..GetReport(sName), true); return false end
  if(not isstring(sPurp)) then
    LogInstance("Purpose not string "..GetReport(sPurp), true); return false end
  if(IsBlank(sName) or tonumber(sName:sub(1,1))) then
    LogInstance("Name invalid "..GetReport(sName), true); return false end
  if(IsBlank(sPurp) or tonumber(sPurp:sub(1,1))) then
    LogInstance("Purpose invalid "..GetReport(sPurp), true); return false end
  SetOpVar("LOG_SKIP",{})
  SetOpVar("LOG_ONLY",{})
  SetOpVar("LOG_MAXLOGS",0)
  SetOpVar("LOG_CURLOGS",0)
  SetOpVar("LOG_LOGLAST","")
  SetOpVar("LOG_INIT",{"*Init", false, 0})
  SetOpVar("TIME_INIT",Time())
  SetOpVar("DELAY_ACTION",0.01)
  SetOpVar("DELAY_REMOVE",0.2)
  SetOpVar("MAX_ROTATION",360)
  SetOpVar("ANG_ZERO",Angle())
  SetOpVar("VEC_ZERO",Vector())
  SetOpVar("ANG_REV",Angle(0,180,0))
  SetOpVar("VEC_FW",Vector(1,0,0))
  SetOpVar("VEC_RG",Vector(0,-1,1))
  SetOpVar("VEC_UP",Vector(0,0,1))
  SetOpVar("OPSYM_DISABLE","#")
  SetOpVar("OPSYM_DIVIDER","_")
  SetOpVar("OPSYM_VERTDIV","|")
  SetOpVar("OPSYM_REVISION","@")
  SetOpVar("OPSYM_DIRECTORY","/")
  SetOpVar("OPSYM_SEPARATOR",",")
  SetOpVar("OPSYM_ENTPOSANG","!")
  SetOpVar("KEYQ_BUILDER", "DATA_BUILDER")
  SetOpVar("DEG_RAD", mathPi / 180)
  SetOpVar("EPSILON_ZERO", 1e-5)
  SetOpVar("CURVE_MARGIN", 15)
  SetOpVar("COLOR_CLAMP", {0, 255})
  SetOpVar("GOLDEN_RATIO",1.61803398875)
  SetOpVar("DATE_FORMAT","%y-%m-%d")
  SetOpVar("TIME_FORMAT","%H:%M:%S")
  SetOpVar("NAME_INIT",sName:lower())
  SetOpVar("NAME_PERP",sPurp:lower())
  SetOpVar("NAME_LIBRARY", GetOpVar("NAME_INIT").."asmlib")
  SetOpVar("TOOLNAME_NL",(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")):lower())
  SetOpVar("TOOLNAME_NU",(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")):upper())
  SetOpVar("TOOLNAME_PL",GetOpVar("TOOLNAME_NL").."_")
  SetOpVar("TOOLNAME_PU",GetOpVar("TOOLNAME_NU").."_")
  SetOpVar("DIRPATH_BAS",GetOpVar("TOOLNAME_NL")..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_EXP","exp"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_DSV","dsv"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_SET","set"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("MISS_NOMD","X")      -- No model
  SetOpVar("MISS_NOID","N")      -- No ID selected
  SetOpVar("MISS_NOAV","N/A")    -- Not Available
  SetOpVar("MISS_NOTP","TYPE")   -- No track type
  SetOpVar("MISS_NOBS","0/0")    -- No Bodygroup skin
  SetOpVar("MISS_NOSQL","NULL")  -- No SQL value
  SetOpVar("FORM_PROGRESS", "%5.2f%%")
  SetOpVar("FORM_CONCMD", "%s %s")
  SetOpVar("FORM_INTEGER", "[%d]")
  SetOpVar("FORM_KEYSTMT","%s(%s)")
  SetOpVar("FORM_LOGSOURCE","%s.%s(%s)")
  SetOpVar("FORM_PREFIXDSV", "%s%s.txt")
  SetOpVar("FORM_GITWIKI", "https://github.com/dvdvideo1234/TrackAssemblyTool/wiki/%s")
  SetOpVar("LOG_FILENAME",GetOpVar("DIRPATH_BAS")..GetOpVar("NAME_LIBRARY").."_log.txt")
  SetOpVar("FORM_SNAPSND", "physics/metal/metal_canister_impact_hard%d.wav")
  SetOpVar("FORM_NTFGAME", "notification.AddLegacy(\"%s\", NOTIFY_%s, 6)")
  SetOpVar("FORM_NTFPLAY", "surface.PlaySound(\"ambient/water/drip%d.wav\")")
  SetOpVar("MODELNAM_FILE","%.mdl")
  SetOpVar("VCOMPARE_SPAN", function(u, v)
    if(u.T ~= v.T) then return u.T < v.T end
    local uC = (u.C or {})
    local vC = (v.C or {})
    local uM, vM = #uC, #vC
    for i = 1, mathMax(uM, vM) do
      local uS = tostring(uC[i] or "")
      local vS = tostring(vC[i] or "")
      if(uS ~= vS) then return uS < vS end
    end
    if(u.N ~= v.N) then return u.N < v.N end
    if(u.M ~= v.M) then return u.M < v.M end
    return false end)
  SetOpVar("VCOMPARE_SDAT", function(u, v, c)
    for iD = 1, c.Size do local iR = c[iD]
      local uR, vR = u.Rec, v.Rec
      if(uR[iR] < vR[iR]) then return true end
      if(uR[iR] > vR[iR]) then return false end
    end; return false; end)
  SetOpVar("VCOMPARE_SKEY", function(u, v) return (u.Key < v.Key) end)
  SetOpVar("VCOMPARE_SREC", function(u, v) return (u.Rec < v.Rec) end)
  SetOpVar("MODELNAM_FUNC", function(x) return " "..x:sub(2,2):upper() end)
  SetOpVar("EMPTYSTR_BLNU", function(x) return (IsBlank(x) or IsNull(x)) end)
  SetOpVar("EMPTYSTR_BLDS", function(x) return (IsBlank(x) or IsDisable(x)) end)
  SetOpVar("EMPTYSTR_BNDX", function(x) return (IsBlank(x) or IsNull(x) or IsDisable(x)) end)
  SetOpVar("QUERY_STORE", {})
  SetOpVar("TABLE_QUEUE",{})
  SetOpVar("TABLE_FLAGS", {})
  SetOpVar("TABLE_BORDERS",{})
  SetOpVar("TABLE_MONITOR", {})
  SetOpVar("TABLE_CONTAINER",{})
  SetOpVar("TYPEMT_POA",{})
  SetOpVar("TYPEMT_QUEUE",{})
  SetOpVar("TYPEMT_SCREEN",{})
  SetOpVar("TYPEMT_CONTAINER",{})
  SetOpVar("TYPEMT_VECTOR",getmetatable(GetOpVar("VEC_ZERO")))
  SetOpVar("TYPEMT_ANGLE" ,getmetatable(GetOpVar("ANG_ZERO")))
  SetOpVar("ARRAY_BNDERRMOD",{"OFF", "LOG", "HINT", "GENERIC", "ERROR"})
  SetOpVar("ARRAY_MODEDB",{"LUA", "SQL"})
  SetOpVar("ARRAY_MODETM",{"CQT", "OBJ"})
  SetOpVar("TABLE_FREQUENT_MODELS",{})
  SetOpVar("ENTITY_DEFCLASS", "prop_physics")
  SetOpVar("KEY_DEFAULT","(!@<#_$|%^|&>*)DEFKEY(*>&|^%|$_#<@!)")
  SetOpVar("KEY_FLIPOVER", "FLIPOVER")
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
    filter = function(oEnt) -- Only valid props which are not the main entity, world or TRACE_FILTER
      if(oEnt and oEnt:IsValid() and oEnt ~= GetOpVar("TRACE_FILTER") and
        GetOpVar("TRACE_CLASS")[oEnt:GetClass()]) then return true end end })
  SetOpVar("CONSTRAINT_LIST", {"Weld", "AdvBallsocket", "NoCollide"})
  SetOpVar("PATTEX_CATEGORY", "%s*local%s+myCategory%s*=%s*")
  SetOpVar("PATTEX_WORKSHID", "%s*asmlib%.WorkshopID%s*")
  SetOpVar("PATTEX_TABLEDPS", "%s*local%s+myPieces%s*=%s*")
  SetOpVar("PATTEX_TABLEDAD", "%s*local%s+myAdditions%s*=%s*")
  SetOpVar("PATTEX_VARADDON", "%s*local%s+myAddon%s*=%s*")
  SetOpVar("PATTEM_WORKSHID", "^%d+$")
  SetOpVar("HOVER_TRIGGER"  , {})
  if(CLIENT) then
    SetOpVar("TABLE_IHEADER", {name = "", stage = 0, op = 0, icon = "", icon2 = ""})
    SetOpVar("TABLE_TOOLINF", {
      {name = "workmode"} ,
      {name = "info"      , icon = "gui/info"   },
      {name = "left"      , icon = "gui/lmb.png"},
      {name = "right"     , icon = "gui/rmb.png"},
      {name = "right_use" , icon = "gui/rmb.png" , icon2 = "gui/e.png"},
      {name = "reload"    , icon = "gui/r.png"  },
      {name = "reload_use", icon = "gui/r.png"   , icon2 = "gui/e.png"}
    })
    SetOpVar("MISS_NOTR","Oops, missing ?") -- No translation found
    SetOpVar("TOOL_DEFMODE","gmod_tool")
    SetOpVar("FORM_FILENAMEAR", "z_autorun_[%s].txt")
    SetOpVar("FORM_DRAWDBG", "%s{%s}: %s > %s")
    SetOpVar("FORM_DRWSPKY", "%+6s")
    SetOpVar("FORM_ICONS","icon16/%s.png")
    SetOpVar("FORM_URLADDON", "https://steamcommunity.com/sharedfiles/filedetails/?id=%s")
    SetOpVar("TABLE_SKILLICON",{})
    SetOpVar("TABLE_WSIDADDON", {})
    SetOpVar("ARRAY_GHOST",{Size=0, Slot=GetOpVar("MISS_NOMD")})
    SetOpVar("TABLE_CATEGORIES",{})
    SetOpVar("CLIPBOARD_TEXT","")
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

function UpdateColor(oEnt, sVar, sCol, bSet)
  if(IsOther(oEnt)) then return nil end
  local cPal = GetContainer("COLORS_LIST")
  local sPrf = GetOpVar("TOOLNAME_PL")..sVar
  if(IsHere(bSet)) then
    if(bSet) then
      oEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
      oEnt:SetColor(cPal:Select(sCol))
      oEnt:SetNWBool(sPrf, true)
    else
      oEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
      oEnt:SetColor(cPal:Select("w"))
      oEnt:SetNWBool(sPrf, false)
    end
  else
    local bNow = oEnt:GetNWBool(sPrf, false)
    if(bNow) then
      oEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
      oEnt:SetColor(cPal:Select(sCol))
    end
  end
end

------------- ANGLE ---------------

function SnapAngle(aBase, nvDec)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  local D = (tonumber(nvDec) or 0); if(D <= 0) then
    LogInstance("Low mismatch "..GetReport(nvDec)); return nil end
  if(D >= GetOpVar("MAX_ROTATION")) then
    LogInstance("High mismatch "..GetReport(nvDec)); return nil end
  -- Snap player viewing rotation angle for using walls and ceiling
  aBase:SnapTo("pitch", D):SnapTo("yaw", D):SnapTo("roll", D)
  return aBase
end

function GridAngle(aBase, nvDec)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  local D = tonumber(nvDec or 0); if(not IsHere(D)) then
    LogInstance("Grid mismatch "..GetReport(nvDec)); return nil end
  local P, Y, R = aBase:Unpack()
  if(P == 0 and P == 0 and D > 0) then Y = GetGrid(Y, D) end
  aBase:SetUnpacked(P, Y, R) return aBase
end

function NegAngle(aBase, bP, bY, bR)
  if(not aBase) then LogInstance("Base invalid"); return nil end
  local P, Y, R = aBase:Unpack()
  P = (IsHere(bP) and (bP and -P or P) or -P)
  Y = (IsHere(bY) and (bY and -Y or Y) or -Y)
  R = (IsHere(bR) and (bR and -R or R) or -R)
  aBase:SetUnpacked(P, Y, R); return aBase
end
------------- VECTOR ---------------

function BasisVector(vBase, aUnit)
  if(not vBase) then LogInstance("Base invalid"); return nil end
  if(not aUnit) then LogInstance("Unit invalid"); return nil end
  local X = vBase:Dot(aUnit:Forward())
  local Y = vBase:Dot(aUnit:Right())
  local Z = vBase:Dot(aUnit:Up())
  vBase:SetUnpacked(X, Y, Z); return vBase
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

function DivXY(xyR, vM)
  if(not xyR) then LogInstance("Base invalid"); return nil end
  local nM = (tonumber(vM) or 0)
  xyR.x, xyR.y = (xyR.x / nM), (xyR.y / nM); return xyR
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

----------------- OOP ------------------

-- https://github.com/GitSparTV/cavefight/blob/master/gamemodes/cavefight/gamemode/init.lua#L115
function GetQueue(sKey)
  local mKey = tostring(sKey or "QUEUE")
  local mHash = GetOpVar("TABLE_QUEUE")
  if(IsHere(sKey)) then
    if(mHash and mHash[mKey]) then
      return mHash[mKey] end
  end
  local self, mBusy, mS, mE = {}, {}, nil, nil
  -- Returns the queue member key
  function self:GetKey() return mKey end
  -- Returns the last item in the queue
  function self:GetHead() return mS end
  -- Returns the first item in the queue
  function self:GetTail() return mE end
  -- Yo sexy ladies want par with us
  function self:GetBusy() return mBusy end
  -- Checks when the queue is empty
  function self:IsEmpty()
    return (not (IsHere(mS) and IsHere(mE)))
  end
  function self:GetStruct(oP, oA, oM, oD, oN, oS, oE)
    if(not (oP and oP:IsValid() and oP:IsPlayer())) then -- There is no valid player
      LogInstance("Player invalid "..GetReport(oD, oP), mKey); return nil end
    if(not istable(oA)) then -- There is no valid routine arguments for the task
      LogInstance("Arguments invalid "..GetReport(oD, oA), mKey); return nil end
    if(not isfunction(oM)) then -- There is no valid routine function for the task
      LogInstance("Routine invalid "..GetReport(oD, oM), mKey); return nil end
    return {  -- Create task main routine structures
      P = oP, -- Current task player ( mandatory )
      A = oA, -- Current task arguments ( mandatory )
      M = oM, -- Current task main routine ( mandatory )
      S = oS, -- Current task start routine ( optional )
      E = oE, -- Current task end routine ( optional )
      D = tostring(oD), -- Current task start description ( optional )
      N = oN  -- Current task sequential pointer ( optional )
    }
  end
  -- Checks whenever the queue is busy for that player
  function self:IsBusy(oPly)
    if(not IsHere(oPly)) then return true end
    local bB = mBusy[oPly]; return (bB and isbool(bB))
  end
  -- Setups a task to be called in the queue
  function self:Attach(oPly, tArg, fFoo, aDsc)
    local tD = self:GetStruct(oPly, tArg, fFoo, aDsc); if(not tD) then
      LogInstance("Invalid: "..GetReport(aDsc, oPly), mKey); return self end
    if(self:IsEmpty()) then mS, mE = tD, tD else mE.N = tD; mE = tD end
    LogInstance("Create "..GetReport(mS.D, mS.P:Nick()), mKey)
    mBusy[oPly] = true; return self -- Mark as busy
  end
  -- Calls a function before the task starts processing
  function self:OnActive(oPly, fFoo)
    if(not IsHere(mE)) then -- No data to setup the pre-run for just exit
      LogInstance("Configuration missing", mKey); return self end
    if(not (mE.P and mE.P:IsValid())) then -- There is no valid player for task
      LogInstance("Player invalid "..GetReport(mE.D, mE.P), mKey); return self end
    mE.S = fFoo; return self
  end
  -- Calls a function when the task finishes processing
  function self:OnFinish(oPly, fFoo)
    if(not IsHere(mE)) then -- No data to setup the post-run for just exit
      LogInstance("Configuration missing", mKey); return self end
    if(not (mE.P and mE.P:IsValid())) then -- There is no valid player for task
      LogInstance("Player invalid "..GetReport(mE.D, mE.P), mKey); return self end
    mE.E = fFoo; return self
  end
  -- Execute the current task at the queue beginning
  function self:Work()
    if(self:IsEmpty()) then return self end
    if(mS.S) then -- Pre-processing. Return value is ignored
      local bOK, bErr = pcall(mS.S, mS.P, mS.A); if(not bOK) then
        LogInstance("Error "..GetReport(mS.D, mS.P:Nick()).." "..bErr, mKey)
      else LogInstance("Active "..GetReport(mS.D, mS.P:Nick()), mKey) end
      mS.S = nil -- Remove the pre-processing function for other iterations
    end
    local bOK, bBsy = pcall(mS.M, mS.P, mS.A) -- Execute the main routine
    if(not bOK) then mBusy[mS.P] = false -- Error in the routine function
      LogInstance("Error "..GetReport(mS.D, mS.P:Nick()).." "..bBsy, mKey)
    else
      if(bBsy) then -- No error in the routine function and not busy
        LogInstance("Pass "..GetReport(mS.D, mS.P:Nick(), bBsy), mKey)
      else -- The main routine is done and the player is not busy
        LogInstance("Done "..GetReport(mS.D, mS.P:Nick(), bBsy), mKey)
      end -- Update the player busy status according to the execution
    end; mBusy[mS.P] = bBsy; return self
  end
  -- Switch to the next tasks in the list
  function self:Next(bMen) -- Crack open a cold one with!
    if(self:IsEmpty()) then return self end -- List empty
    if(self:IsBusy(mS.P)) then -- Task running. We are busy
      if(not bMen) then return self end -- Multitasking disabled
      if(mS == mE) then return self end -- Only one list element
      mE.N = mS; mE = mS; mS = mE.N; mE.N = nil -- Move entry
      return self -- Moves only busy tasks with work remaining
    else -- Task has been done. Run post processing and clear
      if(mS.E) then -- Post-processing. Return value is ignored
        local bOK, bErr = pcall(mS.E, mS.P, mS.A); if(not bOK) then
          LogInstance("Error "..GetReport(mS.D, mS.P:Nick()).." "..bErr, mKey)
        else LogInstance("Finish "..GetReport(mS.D, mS.P:Nick()), mKey) end
        mS.E = nil -- Remove the post-processing function for memory leaks
      end -- Wipe all the columns in the item and go to the next item
      LogInstance("Clear "..GetReport(mS.D, mS.P:Nick()), mKey)
      local tD = mS.N; tableEmpty(mS); mS = tD; return self -- Wipe entry
    end
  end
  if(IsHere(sKey)) then
    if(mHash) then mHash[sKey] = self end
    LogInstance("Register "..GetReport(mKey)) end
  setmetatable(self, GetOpVar("TYPEMT_QUEUE")); return self
end

function GetContainer(sKey, sDef)
  local mKey = tostring(sKey or "CONTAINER")
  local mHash = GetOpVar("TABLE_CONTAINER")
  if(IsHere(sKey) and mHash[mKey]) then return mHash[mKey] end
  local mData, mID, self = {}, {}, {}
  local mDef = sDef or GetOpVar("KEY_DEFAULT")
  local miTop, miAll, mhCnt = 0, 0, 0
  -- Returns the container name information
  function self:GetKey() return mKey end
  -- Returns the largest index in the array part
  function self:GetSize() return miTop end
  -- Returns the actual populated slots less or equal to [miTop]
  function self:GetCount() return miAll end
  -- The hash part slots maximum count
  function self:GetKept() return mhCnt end
  -- Returns the container data reference
  function self:GetData() return mData end
  -- Returns the container hash ID reference
  function self:GetHashID() return mID end
  -- Calls a manual collect garbage
  function self:Collect() collectgarbage(); return self end
  -- Checks whenever there are wholes in the array part
  function self:IsRagged() return (miAll ~= miTop) end
  -- Reads the data from the container
  function self:Select(nsKey)
    local iK = (nsKey or mDef); return mData[iK]
  end
  -- Retrieves hash ID by a given key
  function self:GetKeyID(nsKey)
    local iK = (nsKey or mDef); return mID[iK]
  end
  -- Refreshes the top populated index
  function self:Refresh()
    while(not IsHere(mData[miTop]) and miTop > 0) do
      miTop = (miTop - 1) end; return self
  end
  -- Finds a value in the container
  function self:Find(vVal)
    for iK, vV in pairs(mData) do
      if(vV == vVal) then
        return iK, (isstring(iK) and mID[iK] or nil)
      end
    end; return nil, nil
  end
  -- Arranges the container data
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
  -- Wipes all the container elements
  function self:Clear()
    tableEmpty(self:GetData())
    tableEmpty(self:GetHashID())
    miTop, miAll, mhCnt = 0, 0, 0
    return self
  end
  -- Records an element from the container
  function self:Record(nsKey, vVal)
    local iK, bK = (nsKey or mDef), IsHere(nsKey)
    if(isnumber(iK) or not bK) then
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
  -- Deletes an element from the container
  function self:Delete(nsKey)
    local iK, bK = (nsKey or mDef), IsHere(nsKey)
    if(bK and not IsHere(mData[iK])) then return self end
    if(isnumber(iK) or not bK) then
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
  -- Pulls an element from the container-stack
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
  -- Pushes an element to the container-stack
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
    LogInstance("Registered "..GetReport(mKey)) end
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
 * PLY - Drawing a polygon
]]
function GetScreen(sW, sH, eW, eH, conClr, aKey)
  if(SERVER) then return nil end
  local tLogs, tMon = {"GetScreen"}, GetOpVar("TABLE_MONITOR")
  if(IsHere(aKey) and IsHere(tMon) and tMon[aKey]) then -- Return the cached screen
    local oMon = tMon[aKey]; oMon:GetColor(); return oMon end
  local sW, sH = (tonumber(sW) or 0), (tonumber(sH) or 0)
  local eW, eH = (tonumber(eW) or 0), (tonumber(eH) or 0)
  if(sW < 0 or sH < 0) then LogInstance("Start dimension invalid", tLogs); return nil end
  if(eW < 0 or eH < 0) then LogInstance("End dimension invalid", tLogs); return nil end
  local sKeyD, cColD = GetOpVar("KEY_DEFAULT"), GetColor(255,255,255,255)
  local xyS, xyE, self = NewXY(sW, sH), NewXY(eW, eH), {}
  local Colors = {List = conClr, Key = sKeyD, Default = cColD}
  if(Colors.List) then -- Container check
    if(getmetatable(Colors.List) ~= GetOpVar("TYPEMT_CONTAINER"))
      then LogInstance("Color list not container", tLogs); return nil end
  else -- Color list is not present then create one
    Colors.List = GetContainer("COLORS_LIST") -- Default color container
  end
  local Text, TxID = {}, {[sKeyD] = "vgui/white"}
  local DrawMeth, DrawArgs = {}, {}
  Text.DrwX, Text.DrwY, Text.DrxC, Text.DryC = 0, 0, 0, 0
  Text.ScrW, Text.ScrH, Text.LstW, Text.LstH = 0, 0, 0, 0
  function self:GetCorners() return xyS, xyE end
  function self:GetSize() return (eW - sW), (eH - sH) end
  function self:GetCenter(nX, nY)
    local nW, nH = self:GetSize()
    local nX = (nW / 2) + (tonumber(nX) or 0)
    local nY = (nH / 2) + (tonumber(nY) or 0)
    return nX, nY
  end
  function self:GetMaterial(fC, sP)
    local tM, bP = TxID[fC], IsBlank(tostring(sP or ""))
    if(not tM) then TxID[fC] = {}; tM = TxID[fC] end
    local vP = tostring(bP and TxID[sKeyD] or sP)
    if(not tM[vP]) then bS, vV = pcall(fC, vP)
      if(not bS) then -- Report the error in the log
        LogInstance("Error: "..vV, tLogs); return nil end
      tM[vP] = vV -- Store the value in the cache
    end; return tM[vP] -- Return cached material or texture
  end
  function self:GetColor(keyCl, sMeth)
    if(not IsHere(keyCl) and not IsHere(sMeth)) then
      Colors.Key = GetOpVar("KEY_DEFAULT")
      LogInstance("Color reset", tLogs); return self end
    local keyCl = (keyCl or Colors.Key); if(not IsHere(keyCl)) then
      LogInstance("Indexing skipped", tLogs); return self end
    if(not isstring(sMeth)) then
      LogInstance("Method invalid "..GetReport(sMeth), tLogs); return self end
    local rgbCl = Colors.List:Select(keyCl)
    if(not IsHere(rgbCl)) then rgbCl = Colors.Default end
    if(tostring(Colors.Key) ~= tostring(keyCl)) then -- Update the color only on change
      surfaceSetDrawColor(rgbCl.r, rgbCl.g, rgbCl.b, rgbCl.a)
      surfaceSetTextColor(rgbCl.r, rgbCl.g, rgbCl.b, rgbCl.a)
      Colors.Key = keyCl; -- The drawing color for these two methods uses surface library
    end; return rgbCl, keyCl
  end
  function self:GetDrawParam(sMeth, tArgs, sKey)
    local sMeth = tostring(sMeth or DrawMeth[sKey])
    if(not DrawArgs[sMeth]) then DrawArgs[sMeth] = {} end
    local tArgs = (tArgs or DrawArgs[sMeth][sKey])
    if(sMeth == "SURF") then
      if(sKey == "TXT" and tArgs ~= DrawArgs[sKey]) then
        surfaceSetFont(tostring(tArgs[1] or "Default")) end -- Time to set the font again
    end
    DrawMeth[sKey] = sMeth
    DrawArgs[sMeth][sKey] = tArgs; return sMeth, tArgs
  end
  function self:SetTextStart(nX, nY)
    Text.ScrW, Text.ScrH = 0, 0 -- Rectangle where the text is drawn
    Text.LstW, Text.LstH = 0, 0 -- The size of the last text drawn
    Text.DrwX = (tonumber(nX) or 0) -- The location of the last text
    Text.DrwY = (tonumber(nY) or 0) -- Write draw position to center
    Text.DrcX, Text.DrcY = Text.DrwX, Text.DrwY; return self
  end
  function self:GetTextStDraw(nX, nY)
    return (Text.DrwX + (tonumber(nX) or 0)), (Text.DrwY + (tonumber(nY) or 0))
  end
  function self:GetTextStScreen(nW, nH)
    return (Text.ScrW + (tonumber(nW) or 0)), (Text.ScrH + (tonumber(nH) or 0))
  end
  function self:GetTextStLast(nX, nY)
    return (Text.LstW + (tonumber(nW) or 0)), (Text.LstH + (tonumber(nH) or 0))
  end
  function self:GetTextStCenter(nX, nY)
    return (Text.DrxC + (tonumber(nW) or 0)), (Text.DryC + (tonumber(nH) or 0))
  end
  function self:DrawText(sText, keyCl, sMeth, tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"TXT")
    local rgbCl, keyCl = self:GetColor(keyCl, sMeth)
    local bCen = tobool(tArgs[2]); self:GetColor(keyCl, sMeth)
    if(sMeth == "SURF") then
      Text.LstW, Text.LstH = surfaceGetTextSize(sText)
      if(bCen) then
        Text.DrwX = Text.DrcX - (Text.LstW / 2)
        Text.DrwY = Text.DrcY - (Text.LstH / 2)
        Text.DrcY = Text.DrcY + Text.LstH
      end
      surfaceSetTextPos(Text.DrwX, Text.DrwY)
      surfaceDrawText(sText)
      Text.DrwY = Text.DrwY + Text.LstH; Text.ScrH = Text.DrwY
      if(Text.LstW > Text.ScrW) then Text.ScrW = Text.LstW end
    else
      LogInstance("Draw method invalid "..GetReport(sMeth), tLogs)
    end; return self
  end
  function self:DrawTextRe(sText, keyCl, sMeth, tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"TXT")
    local rgbCl, keyCl = self:GetColor(keyCl, sMeth)
    local bCen = tobool(tArgs[2]); self:GetColor(keyCl, sMeth)
    if(sMeth == "SURF") then
      surfaceSetTextPos(Text.DrwX + Text.LstW,Text.DrwY - Text.LstH)
      surfaceDrawText(sText)
      local txW, txH = surfaceGetTextSize(sText)
      Text.LstW, Text.LstH = (Text.LstW + txW), txH
      if(Text.LstW > Text.ScrW) then Text.ScrW = Text.LstW end
      Text.ScrH = Text.DrwY
    else
      LogInstance("Draw method invalid "..GetReport(sMeth), tLogs)
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
      local nItr = mathClamp((tonumber(tArgs[1]) or 1),1,200)
      if(nItr <= 0) then return self end
      local xyD = NewXY((pE.x - pS.x) / nItr, (pE.y - pS.y) / nItr)
      local xyOld, xyNew = NewXY(pS.x, pS.y), NewXY()
      while(nItr > 0) do AddXY(xyNew, xyOld, xyD)
        if((self:Enclose(xyOld) ~= -1) and (self:Enclose(xyNew) ~= -1)) then
          surfaceDrawLine(xyOld.x, xyOld.y, xyNew.x, xyNew.y)
        end; SetXY(xyOld, xyNew); nItr = nItr - 1
      end
    elseif(sMeth == "CAM3") then
      renderDrawLine(pS,pE,rgbCl,(tArgs[1] and true or false))
    else LogInstance("Draw method invalid "..GetReport(sMeth), tLogs); return self end
  end
  function self:DrawRect(pO,pS,keyCl,sMeth,tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"REC")
    local rgbCl, keyCl = self:GetColor(keyCl, sMeth)
    if(sMeth == "SURF") then
      if(self:Enclose(pO) == -1) then
        LogInstance("Start out of border", tLogs); return self end
      if(self:Enclose(pS) == -1) then
        LogInstance("End out of border", tLogs); return self end
      local nR, nC = tonumber(tArgs[2]), (tonumber(tArgs[3]) or 0)
      surfaceSetTexture(self:GetMaterial(surfaceGetTextureID, tArgs[1]))
      if(nR and nR ~= 0) then local nD = (nR / GetOpVar("DEG_RAD"))
        surfaceDrawTexturedRectRotated(pO.x,pO.y,pS.x,pS.y,nD)
      else -- Use the regular rectangle function without sin/cos rotation
        if(nC and nC > 0) then
          drawRoundedBox(nC, pO.x, pO.y, pS.x, pS.y, rgbCl)
        else
          surfaceDrawTexturedRect(pO.x, pO.y, pS.x, pS.y)
        end
      end
    else -- Unsupported method
      LogInstance("Draw method invalid "..GetReport(sMeth), tLogs)
    end; return self
  end
  function self:DrawPoly(tV,keyCl,sMeth,tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"PLY")
    local rgbCl, keyCl = self:GetColor(keyCl,sMeth)
    surfaceSetTexture(self:GetMaterial(surfaceGetTextureID, tArgs[1]))
    if(sMeth == "SURF") then surfaceDrawPoly(tV) end; return self
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
      renderSetMaterial(self:GetMaterial(Material, tArgs[1]))
      renderDrawSphere (pC,nRad,mathClamp(tArgs[2] or 1,1,200),
                                mathClamp(tArgs[3] or 1,1,200),rgbCl)
    else LogInstance("Draw method invalid "..GetReport(sMeth), tLogs); return nil end
  end
  function self:DrawUCS(oPly,vO,aO,sMeth,tArgs)
    local sMeth, tArgs = self:GetDrawParam(sMeth,tArgs,"UCS")
    local nSiz = BorderValue(tonumber(tArgs[1]) or 0, "non-neg")
    local xyO, nRad = vO:ToScreen(), GetViewRadius(oPly, vO)
    self:DrawCircle(xyO, nRad, "y", sMeth, tArgs)
    if(nSiz > 0) then
      if(sMeth == "SURF") then
        local xyZ = (vO + nSiz * aO:Up()):ToScreen()
        local xyY = (vO + nSiz * aO:Right()):ToScreen()
        local xyX = (vO + nSiz * aO:Forward()):ToScreen()
        self:DrawLine(xyO,xyX,"r",sMeth)
        self:DrawLine(xyO,xyY,"g")
        self:DrawLine(xyO,xyZ,"b"); return xyO, xyX, xyY, xyZ
      else LogInstance("Draw method invalid "..GetReport(sMeth), tLogs); return nil end
    end; return xyO -- Do not draw the rays when the size is zero
  end
  function self:DrawPOA(oPly,ePOA,stPOA,iIdx,nAct,bNoO)
    if(not (ePOA and ePOA:IsValid())) then
      LogInstance("Entity invalid", tLogs); return nil end
    if(not IsPlayer(oPly)) then
      LogInstance("Player invalid", tLogs); return nil end
    local nAct = BorderValue(tonumber(nAct) or 0, "non-neg")
    local eP, eA = ePOA:GetPos(), ePOA:GetAngles()
    local vO, vP = Vector(), Vector()
    vO:SetUnpacked(stPOA.O:Get())
    vP:SetUnpacked(stPOA.P:Get())
    vO:Rotate(eA); vO:Add(eP)
    vP:Rotate(eA); vP:Add(eP)
    local Op, Pp = vO:ToScreen(), vP:ToScreen()
    local Rv = GetViewRadius(oPly, vP, nAct / 5)
    if(not bNoO) then
      local nR = GetViewRadius(oPly, vO)
      self:DrawCircle(Op, nR,"y","SURF")
    end
    if(iIdx) then local nO = Rv / 5
      if(not stPOA.P:IsSame()) then
        self:SetTextStart(Pp.x + nO, Pp.y - 24 - nO)
      else self:SetTextStart(Op.x + nO, Op.y - 24 - nO) end
      self:DrawText(tostring(iIdx),"g","SURF",{"Trebuchet24"})
    end
    self:DrawCircle(Pp, Rv, "r","SEGM",{35})
    self:DrawLine(Op, Pp)
  end
  setmetatable(self, GetOpVar("TYPEMT_SCREEN"))
  if(IsHere(aKey)) then tMon[aKey] = self
    LogInstance("Screen registered "..GetReport(aKey)) end
  return self -- Register the screen under the key
end

function NewPOA(vA, vB, vC)
  local self, mRaw = {0, 0, 0}
  local mMis = GetOpVar("MISS_NOSQL")
  local mSep = GetOpVar("OPSYM_SEPARATOR")
  local mEoa = GetOpVar("OPSYM_ENTPOSANG")
  function self:Get()
    return unpack(self)
  end
  function self:Array()
    return {self:Get()}
  end
  function self:Vector()
    return Vector(self:Get())
  end
  function self:Angle()
    return Angle(self:Get())
  end
  function self:String(sS)
    local sS = (IsHere(sS) and tostring(sS) or mSep)
    return tableConcat(self, sS) -- Custom separator
  end
  function self:Set(vA, vB, vC)
    if(istable(vA)) then
      self[1] = (tonumber(vA[1]) or 0)
      self[2] = (tonumber(vA[2]) or 0)
      self[3] = (tonumber(vA[3]) or 0)
    else
      self[1] = (tonumber(vA) or 0)
      self[2] = (tonumber(vB) or 0)
      self[3] = (tonumber(vC) or 0)
    end; return self
  end
  function self:Raw(sR)
    if(IsHere(sR)) then
      mRaw = tostring(sR) end
    return mRaw -- Source data manager
  end
  function self:IsSame(vA, vB, vC)
    if(istable(vA)) then
      for iD = 1, 3 do
        local nP = (tonumber(vA[iD]) or 0)
        if(nP ~= self[iD]) then return false end
      end -- Compare with a array of values
    else -- Try to convert to number
      local vA = (tonumber(vA) or 0)
      if(vA ~= self[1]) then return false end
      local vB = (tonumber(vB) or 0)
      if(vB ~= self[2]) then return false end
      local vC = (tonumber(vC) or 0)
      if(vC ~= self[3]) then return false end
    end; return true
  end
  function self:Export(vA, vB, vC)
    local sS, bE = self:String()
    if(vA) then -- Must compare
      bE = self:IsSame(vA, vB, vC)
    else bE = self:IsSame() end
    return (mRaw or (bE and mMis or sS))
  end
  function self:Import(sB, sM, ...)
    local bE, sB = GetEmpty(sB) -- Default to string
    if(bE) then -- Check when entry data is vacant
      self:Set(...) -- Override with the default value provided
    else -- Entry data is missing use default otherwise decode the value
      local sM = (IsHere(sM) and tostring(sM) or GetOpVar("MISS_NOMD"))
      local tPOA = mSep:Explode(sB)  -- Read the components
      for iD = 1, 3 do                 -- Apply on all components
        local nC = tonumber(tPOA[iD])  -- Is the data really a number
        if(not IsHere(nC)) then nC = 0 -- If not write zero and report it
          LogInstance("Mismatch "..GetReport(sM, sB, iD)) end; self[iD] = nC
      end -- Try to decode the entry when present
    end; return self
  end
  function self:Decode(sB, vS, sT, ...)
    local bE, sB = GetEmpty(sB) -- Default to string
    if(bE) -- Check when entry data is vacant
      then self:Set(...) -- Override with the default value provided
    else -- Entry data is missing use default otherwise decode the value
      if(sB:sub(1,1) == mEoa) then -- POA key must extracted from the model
        local sT = tostring(sT or "") -- Default the type index to string
        local sK = sB:sub(2, -1) -- Read key transform ID and try to index
        local tT, sM = GetAttachmentByID(vS, sK) -- Read transform key
        if(IsHere(tT)) then -- Attachment is found. Try to process it
          local uT = tT[sT] -- Extract transform value for the type
          if(IsHere(uT)) then self:Set(uT:Unpack()) -- Load key into POA
          else -- Try decoding the transform key when not applicable
            self:Import(sK, sM, ...) -- Try to process the key when present
            LogInstance("Mismatch "..GetReport(sM, sK, sT)) -- Report mismatch
          end -- Decode the transformation when is not null or empty string
        else -- Try decoding the transform key when not applicable
          self:Import(sK, sM, ...) -- Try to process the key when present
          LogInstance("Missing "..GetReport(sM, sK, sT)) -- Report mismatch
        end -- Decode the transformation when is not null or empty string
      else -- When the value is empty use zero otherwise process the value
        self:Import(sB, sM, ...) -- Try to process the value when present
        LogInstance("Regular "..GetReport(sB, sM)) -- No Attachment call
      end -- Try to decode the entry when present
    end; return self
  end; if(vA or vB or vC) then self:Set(vA, vB, vC) end
  setmetatable(self, GetOpVar("TYPEMT_POA")); return self
end

function SetAction(sKey, fAct, tDat)
  if(not (sKey and isstring(sKey))) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  if(not (fAct and type(fAct) == "function")) then
    LogInstance("Action mismatch "..GetReport(fAct)); return nil end
  if(not libAction[sKey]) then libAction[sKey] = {} end
  local tAct = libAction[sKey]; tAct.Act, tAct.Dat = fAct, {}
  if(istable(tDat)) then
    for key, val in pairs(tDat) do
      tAct.Dat[key] = tDat[key]
    end
  else tAct.Dat = {tDat} end
  tAct.Dat.Slot = sKey; return true
end

function GetActionCode(sKey)
  if(not (sKey and isstring(sKey))) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  if(not (libAction and libAction[sKey])) then
    LogInstance("Missing key "..GetReport(sKey)); return nil end
  return libAction[sKey].Act
end

function GetActionData(sKey)
  if(not (sKey and isstring(sKey))) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  if(not (libAction and libAction[sKey])) then
    LogInstance("Missing key "..GetReport(sKey)); return nil end
  return libAction[sKey].Dat
end

function DoAction(sKey, ...)
  if(not (sKey and isstring(sKey))) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  local tAct = libAction[sKey]; if(not IsHere(tAct)) then
    LogInstance("Missing key "..GetReport(sKey)); return nil end
  return pcall(tAct.Act, tAct.Dat, ...)
end

function AddLineListView(pnListView,frUsed,ivNdex)
  if(not IsHere(pnListView)) then
    LogInstance("Missing panel"); return false end
  if(not IsValid(pnListView)) then
    LogInstance("Invalid panel"); return false end
  if(not IsHere(frUsed)) then
    LogInstance("Missing data"); return false end
  local iNdex = tonumber(ivNdex); if(not IsHere(iNdex)) then
    LogInstance("Index mismatch "..GetReport(ivNdex)); return false end
  local tValue = frUsed[iNdex]; if(not IsHere(tValue)) then
    LogInstance("Missing data on index "..GetReport(iNdex)); return false end
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
 * pnListView  > The panel which must be updated
 * frUsed      > The list of the frequently used tracks
 * nCount      > The amount of pieces to check
 * sCol        > The name of the column it preforms search by
 * sPat        > Search pattern to preform the search with
]]
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
  local sCol = tostring(sCol or "")
  local sPat = tostring(sPat or "")
  for iCnt = 1, frUsed.Size do
    if(IsBlank(sPat)) then
      if(not AddLineListView(pnListView,frUsed,iCnt)) then
        LogInstance("Failed to add line on "..GetReport(iCnt)); return false end
    else
      local sDat = tostring(frUsed[iCnt].Table[sCol] or "")
      if(sDat:find(sPat)) then
        if(not AddLineListView(pnListView,frUsed,iCnt)) then
          LogInstance("Failed to add line "..GetReport(iCnt, sDat, sPat, sCol)); return false end
      end
    end
  end; pnListView:SetVisible(true)
  LogInstance("Updated "..GetReport(frUsed.Size)); return true
end

function SetExpandNode(pnBase)
  local bEx = pnBase:GetExpanded()
  if(inputIsKeyDown(KEY_LSHIFT)) then
    pnBase:ExpandRecurse(not bEx)
  else
    pnBase:SetExpanded(not bEx)
  end
end

function SetDirectory(pnBase, vName)
  if(not IsValid(pnBase)) then
    LogInstance("Base panel invalid"); return nil end
  local tSkin = pnBase:GetSkin()
  local sTool = GetOpVar("TOOLNAME_NL")
  local sName = tostring(vName or "")
        sName = (IsBlank(sName) and "Other" or sName)
  local pNode = pnBase:AddNode(sName)
  pNode:SetTooltip(languageGetPhrase("tool."..sTool..".subfolder"))
  pNode.Icon:SetImage(ToIcon("subfolder_item"))
  pNode.DoClick = function() SetExpandNode(pNode) end
  pNode.Expander.DoClick = function() SetExpandNode(pNode) end
  pNode.DoRightClick = function()
    SetClipboardText(pNode:GetText())
  end
  pNode:UpdateColours(tSkin)
  return pNode
end

function SetDirectoryNode(pnBase, sName, sModel)
  if(not IsValid(pnBase)) then LogInstance("Base invalid "
    ..GetReport(sName, sModel)); return nil end
  local pNode = pnBase:AddNode(sName)
  if(not IsValid(pNode)) then LogInstance("Node invalid "
    ..GetReport(sName, sModel)); return nil end
  local tSkin = pnBase:GetSkin()
  local sTool = GetOpVar("TOOLNAME_NL")
  local sModC = languageGetPhrase("tool."..sTool..".model_con")
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
      val:UpdateColours(tSkin) end
    SetAsmConvar(nil, "model"  , sModel)
    SetAsmConvar(nil, "pointid", 1)
    SetAsmConvar(nil, "pnextid", 2)
  end
  pNode:UpdateColours(tSkin)
  return pNode
end

function GetFrequentModels(iCnt)
  local iCnt = (tonumber(iCnt) or 0); if(iCnt < 1) then
    LogInstance("Count not applicable"); return nil end
  local makTab = GetBuilderNick("PIECES"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  local tCache = libCache[defTab.Name]; if(not IsHere(tCache)) then
    LogInstance("Missing table cache space"); return nil end
  local frUsed = GetOpVar("TABLE_FREQUENT_MODELS")
  local iInd, tmNow = 1, Time(); tableEmpty(frUsed); frUsed.Size = 0
  local coMo, coTy = makTab:GetColumnName(1), makTab:GetColumnName(2)
  local coNm, coSz = makTab:GetColumnName(3), makTab:GetColumnName(4)
  for mod, rec in pairs(tCache) do
    if(IsHere(rec.Used) and IsHere(rec.Size) and rec.Size > 0) then
      local rmComp = (tmNow - rec.Used)
      local stData = {[coMo] = mod     , [coTy] = rec.Type,
                      [coNm] = rec.Name, [coSz] = rec.Size}
      if(frUsed.Size == 0) then frUsed.Size = 1
        tableInsert(frUsed, {Value = rmComp, Table = stData})
      else local bTop = true -- Registered records are more than one
        if(frUsed.Size >= iCnt) then break end -- Reached count
        for iD = 1, frUsed.Size do -- Still something to add
          if(frUsed[iD].Value >= rmComp) then -- Check placement
            frUsed.Size, bTop = (frUsed.Size + 1), false -- Increment
            tableInsert(frUsed, iD, {Value = rmComp, Table = stData})
            break -- Exist the inner check loop and add the record
          end -- Snapshot is inserted and registered
        end -- We have to add the item at the end of the array
        if(bTop) then tableInsert(frUsed, {Value = rmComp, Table = stData}) end
      end -- By default top addition is enabled. When found this is skipped
    end -- Make a report for every record that is valid in the cache
  end -- If there is at least one record added return the array reference
  if(IsHere(frUsed) and IsHere(frUsed[1])) then return frUsed, iCnt end
  LogInstance("Array is empty or not available"); return nil
end

function SetListViewClipboard(pnListView, nX, nY)
  local mX, mY = inputGetCursorPos()
  local nX, nY = (tonumber(nX) or mX), (tonumber(nY) or mY)
  local cC, cX, cY = 0, pnListView:ScreenToLocal(nX, nY)
  while(cX > 0) do
    cC = (cC + 1)
    cX = (cX - pnListView:ColumnWidth(cC))
  end
  local nID, pnRow = pnListView:GetSelectedLine()
  if(nID and nID > 0 and pnRow) then
    SetClipboardText(pnRow:GetColumnText(cC))
  end
end

function SetComboBoxClipboard(pnCombo)
  local sV = pnCombo:GetValue()
  local iD = pnCombo:GetSelectedID()
  local sT = pnCombo:GetOptionText(iD)
  local sS = GetEmpty(sT, nil, sV, gsNoAV)
  SetClipboardText(sS)
end

function SetComboBoxList(cPanel, sVar)
  local tSet  = GetOpVar("ARRAY_"..sVar:upper())
  if(IsHere(tSet)) then
    local tSkin = cPanel:GetSkin()
    local sTool = GetOpVar("TOOLNAME_NL")
    local sKey, sNam, bExa = GetNameExp(sVar)
    local sBase = (bExa and sNam or ("tool."..sTool.."."..sNam))
    local sName = GetAsmConvar(sVar, "NAM")
    local sMenu, sTtip = languageGetPhrase(sBase.."_con"), languageGetPhrase(sBase)
    pItem = cPanel:ComboBox(sMenu, sName)
    pItem:SetSortItems(false); pItem:Dock(TOP); pItem:SetTall(25)
    pItem:SetTooltip(sTtip); pItem:UpdateColours(tSkin)
    pItem:SetValue(GetAsmConvar(sVar, "STR"))
    pItem.DoRightClick = function(pnSelf)
      SetComboBoxClipboard(pnSelf)
    end -- Copy the combo box content shown
    pItem.OnSelect = function(pnSelf, nInd, sVal, anyData)
      SetAsmConvar(nil, sVar, anyData)
    end -- Apply the setting to the specified variable
    for iD = 1, #tSet do local sI = tSet[iD]
      local sIco = ToIcon(sNam.."_"..sI:lower())
      local sPrv = (sBase.."_"..sI:lower())
      pItem:AddChoice(languageGetPhrase(sPrv), sI, false, sIco)
    end
  else LogInstance("Missing "..GetReport(sNam)) end
end

function SetButton(cPanel, sVar)
  local sTool = GetOpVar("TOOLNAME_NL")
  local tConv = GetOpVar("STORE_CONVARS")
  local sKey, sNam, bExa = GetNameExp(sVar)
  local sBase = (bExa and sNam or ("tool."..sTool.."."..sNam))
  local sMenu, sTtip = languageGetPhrase(sBase.."_con"), languageGetPhrase(sBase)
  local pItem = cPanel:Button(sMenu, sKey)
        pItem:SetTooltip(sTtip); return pItem
end

function SetNumSlider(cPanel, sVar, vDig, vMin, vMax, vDev)
  local nMin, nMax, nDev = tonumber(vMin), tonumber(vMax), tonumber(vDev)
  local sTool, tConv = GetOpVar("TOOLNAME_NL"), GetOpVar("STORE_CONVARS")
  local sKey, sNam, bExa, nDum = GetNameExp(sVar)
  local sBase = (bExa and sNam or ("tool."..sTool.."."..sNam))
  local iDig = mathFloor(mathMax(tonumber(vDig) or 0, 0))
  -- Read minimum value form the first available
  if(not IsHere(nMin)) then nMin, nDum = GetBorder(sKey)
    if(not IsHere(nMin)) then nMin = GetAsmConvar(sVar, "MIN")
      if(not IsHere(nMin)) then -- Minimum bound is not located
        nMin = -mathAbs(2 * mathFloor(GetAsmConvar(sVar, "FLT")))
        LogInstance("(L) Miss "..GetReport(sKey))
      else LogInstance("(L) Cvar "..GetReport(sKey, nMin)) end
    else LogInstance("(L) List "..GetReport(sKey, nMin)) end
  else LogInstance("(L) Args "..GetReport(sKey, nMin)) end
  -- Read maximum value form the first available
  if(not IsHere(nMax)) then nDum, nMax = GetBorder(sKey)
    if(not IsHere(nMax)) then nMax = GetAsmConvar(sVar, "MAX")
      if(not IsHere(nMax)) then -- Maximum bound is not located
        nMax = mathAbs(2 * mathCeil(GetAsmConvar(sVar, "FLT")))
        LogInstance("(H) Miss "..GetReport(sKey))
      else LogInstance("(H) Cvar "..GetReport(sKey, nMax)) end
    else LogInstance("(H) List "..GetReport(sKey, nMax)) end
  else LogInstance("(H) Args "..GetReport(sKey, nMax)) end
  -- Read default value form the first available
  if(not IsHere(nDev)) then nDev = tConv[sKey]
    if(not IsHere(nDev)) then nDev = GetAsmConvar(sVar, "DEF")
      if(not IsHere(nDev)) then nDev = nMin + ((nMax - nMin) / 2)
        LogInstance("(D) Miss "..GetReport(sKey))
      else LogInstance("(D) Cvar "..GetReport(sKey, nDev)) end
    else LogInstance("(D) List "..GetReport(sKey, nDev)) end
  else LogInstance("(D) Args "..GetReport(sKey, nDev)) end
  -- Create the slider control using the min, max and default
  local sMenu, sTtip = languageGetPhrase(sBase.."_con"), languageGetPhrase(sBase)
  local pItem = cPanel:NumSlider(sMenu, sKey, nMin, nMax, iDig)
  pItem:SetTooltip(sTtip); pItem:SetDefaultValue(nDev); return pItem
end

function SetButtonSlider(cPanel, sVar, nMin, nMax, nDec, tBtn)
  local tSkin = cPanel:GetSkin()
  local sTool = GetOpVar("TOOLNAME_NL")
  local tConv = GetOpVar("STORE_CONVARS")
  local syDis = GetOpVar("OPSYM_DISABLE")
  local syRev = GetOpVar("OPSYM_REVISION")
  local sKey, sNam, bExa = GetNameExp(sVar)
  local sBase = (bExa and sNam or ("tool."..sTool.."."..sNam))
  local pPanel = vguiCreate("DAsmInSliderButton", cPanel); if(not IsValid(pPanel)) then
    LogInstance("Base invalid"); return nil end
  pPanel:SetParent(cPanel)
  pPanel:SetSlider(sKey, languageGetPhrase(sBase.."_con"), languageGetPhrase(sBase))
  pPanel:Configure(nMin, nMax, tConv[sKey], nDec)
  for iD = 1, #tBtn do
    local vBtn = tBtn[iD] -- Button info
    local sTxt = tostring(vBtn.N or syDis):Trim()
    local sTip = tostring(vBtn.T or syDis):Trim()
    if(sTip:sub(1,1) == syRev) then
      sTip = languageGetPhrase(sBase.."_bas"..sTxt)
    elseif(IsDisable(sTip)) then
      sTip = languageGetPhrase("tool."..sTool..".buttonas"..sTxt)
    end
    if(sTxt:sub(1,1) == syRev) then
      local sVam = sTxt:sub(2,-1)
      if(tonumber(sVam)) then
        local nAmt = (tonumber(sVam) or 0)
        if(not vBtn.L) then
          vBtn.L=function(pB, pS, nS) pS:SetValue(-nAmt) end
        end
        if(not vBtn.R) then
          vBtn.R=function(pB, pS, nS) pS:SetValue(nAmt) end
        end
        sTip = languageGetPhrase("tool."..sTool..".buttonas"..syRev).." "..nAmt
      elseif(sVam == "D") then
        if(not vBtn.L) then
          vBtn.L=function(pB, pS, nS) pS:SetValue(pS:GetDefaultValue()) end
        end
        if(not vBtn.R) then
          vBtn.R=function(pB, pS, nS) SetClipboardText(pS:GetDefaultValue()) end
        end
      elseif(sVam == "M") then
        if(not vBtn.L) then
          vBtn.L=function(pB, pS, nS) pS:SetValue(tonumber(GetOpVar("CLIPBOARD_TEXT")) or 0) end
        end
        if(not vBtn.R) then
          vBtn.R=function(pB, pS, nS) SetClipboardText(nS); SetOpVar("CLIPBOARD_TEXT", nS) end
        end
      end
    elseif(sTxt == "+/-") then
      if(not vBtn.L) then
        vBtn.L=function(pB, pS, nS) pS:SetValue(-nS) end
      end
      if(not vBtn.R) then
        vBtn.R=function(pB, pS, nS) pS:SetValue(mathRemap(nS, pS:GetMin(), pS:GetMax(), pS:GetMax(), pS:GetMin())) end
      end
    elseif(sTxt == "<>") then
      if(not vBtn.L) then
        vBtn.L=function(pB, pS, nS) pS:SetValue(GetSnap(nS,-GetAsmConvar("incsnpang","FLT"))) end
      end
      if(not vBtn.R) then
        vBtn.R=function(pB, pS, nS) pS:SetValue(GetSnap(nS, GetAsmConvar("incsnpang","FLT"))) end
      end
    end
    pPanel:SetButton(sTxt, sTip)
    pPanel:SetAction(vBtn.L, vBtn.R)
  end
  pPanel:SetDelta(1, 8)
  pPanel:SetPadding(0, 0)
  pPanel:IsAutoResize(true, false)
  pPanel:Dock(TOP)
  pPanel:SizeToChildren(true, false)
  pPanel:SizeToContentsY()
  pPanel:InvalidateChildren()
  pPanel:UpdateColours(tSkin)
  pPanel:ApplySchemeSettings()
  pPanel:SetWide(260)
  pPanel:UpdateView()
  cPanel:AddItem(pPanel)
  return pPanel
end

function SetCheckBox(cPanel, sVar)
  local sTool = GetOpVar("TOOLNAME_NL")
  local sKey, sNam, bExa = GetNameExp(sVar)
  local sBase = (bExa and sNam or ("tool."..sTool.."."..sNam))
  local sMenu, sTtip = languageGetPhrase(sBase.."_con"), languageGetPhrase(sBase)
  local pItem = cPanel:CheckBox(sMenu, sKey)
  pItem:SetTooltip(sTtip); return pItem
end

-- Set the ENT's Angles first!
function SetCenter(oEnt, vPos, aAng, nX, nY, nZ)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity Invalid"); return Vector(0,0,0) end
  oEnt:SetPos(vPos); oEnt:SetAngles(aAng)
  local vCen, vMin = oEnt:OBBCenter(), oEnt:OBBMins()
        vCen:Negate() -- Adjust only X and Y
  local nCX, nCY, nCZ = vCen:Unpack()
        nCX, nCY, nCZ = (nCX + nX), (nCY - nY), (nZ - vMin.z)
  vCen:SetUnpacked(nCX, nCY, nCZ)
  vCen:Rotate(aAng); vCen:Add(vPos); oEnt:SetPos(vCen)
  return vCen -- Returns X-Y OBB centered model
end

function GetTransformOBB(eBase, wOrg, vNorm, nX, nY, nZ, rP, rY, rR)
  local vOBB = eBase:OBBCenter()
  local wOBB = eBase:LocalToWorld(vOBB)
  local wAng = eBase:GetAngles()
        wAng:RotateAroundAxis(wAng:Up(), (tonumber(rY) or 0))
        wAng:RotateAroundAxis(wAng:Right(), (tonumber(rP) or 0))
        wAng:RotateAroundAxis(wAng:Forward(), (tonumber(rR) or 0))
  local nRot = (GetOpVar("MAX_ROTATION") / 2)
        wAng:RotateAroundAxis(vNorm, nRot)
  local wDir = Vector(); wDir:Set(wOrg); wDir:Sub(wOBB)
  local pDir = 2 * wDir:Dot(vNorm)
  local wPos = Vector(); wPos:Set(wOrg)
        wPos:Add(wDir); wPos:Sub(pDir * vNorm)
        vOBB:Rotate(wAng)
  local wAim = (wPos - wOBB):AngleEx(vNorm)
        wPos:Sub(vOBB)
        wPos:Add((tonumber(nX) or 0) * wAim:Forward())
        wPos:Add((tonumber(nY) or 0) * wAim:Right())
        wPos:Add((tonumber(nZ) or 0) * wAim:Up())
  return wPos, wAng
end

function IsPhysTrace(Trace)
  if(not Trace) then return false end
  if(not Trace.Hit) then return false end
  if(Trace.HitWorld) then return false end
  local eEnt = Trace.Entity
  if(not eEnt) then return false end
  if(not eEnt:IsValid()) then return false end
  local pEnt = eEnt:GetPhysicsObject()
  if(not pEnt) then return false end
  if(not pEnt:IsValid()) then return false end
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
  local nDir = mathFloor(tonumber(vDir) or 0)
  local iDir = (((nDir > 0) and 1) or ((nDir < 0) and -1) or 0)
  if(iDir == 0) then LogInstance("Direction mismatch"); return ID end
  local nC = (ID + iDir) % oRec.Size -- Reminder of ID increment
  local ID = (nC == 0) and oRec.Size or nC -- Zero default to size
  local stPOA = LocatePOA(oRec,ID); if(not IsHere(stPOA)) then
    LogInstance("Offset missing "..GetReport(ID)); return 1 end
  return ID
end

function GetPointElevation(oEnt,ivPoID)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity Invalid"); return nil end
  local sModel = oEnt:GetModel() -- Read the model
  local hdRec = CacheQueryPiece(sModel); if(not IsHere(hdRec)) then
    LogInstance("Record missing "..GetReport(sModel)); return nil end
  local hdPnt, iPoID = LocatePOA(hdRec,ivPoID); if(not IsHere(hdPnt)) then
    LogInstance("POA missing "..GetReport(ivPoID, sModel)); return nil end
  if(not (hdPnt.O and hdPnt.A)) then
    LogInstance("Transform missing "..GetReport(ivPoID, sModel)); return nil end
  local aA, vV, vOBB = Angle(), Vector(), oEnt:OBBMins()
  aA:SetUnpacked(hdPnt.A:Get()); aA:RotateAroundAxis(aA:Up(), 180)
  vV:SetUnpacked(hdPnt.O:Get()); vOBB:Sub(vV); BasisVector(vOBB, aA)
  return mathAbs(vOBB.z)
end

function GetBeautifyName(sName)
  local sDiv = GetOpVar("OPSYM_DIVIDER")
  local fCon = GetOpVar("MODELNAM_FUNC")
  local sNam = tostring(sName or ""):lower():Trim()
  local sOut = sNam:gsub("_+","_"):gsub("_$", "")
  if(sOut:sub(1,1) ~= "_") then sOut = "_"..sOut end
  return sOut:gsub(sDiv.."%w", fCon):sub(2,-1)
end

function ModelToName(sModel, bNoSet)
  if(not isstring(sModel)) then
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
          LogInstance("Cut mismatch "..GetReport(fCh, bCh, sModel)); return "" end
        gModel = gModel:gsub(sModel:sub(fNu, bNu),""); iCnt, iNxt = (iCnt + 2), (iNxt + 2)
        LogInstance("Cut "..GetReport(fCh, bCh, gModel))
      end
    end -- Replace the unneeded parts by finding an in-string gModel
    if(tSub and tSub[1]) then iCnt, iNxt = 1, 2
      while(tSub[iCnt]) do
        local fCh, bCh = tostring(tSub[iCnt] or ""), tostring(tSub[iNxt] or "")
        gModel = gModel:gsub(fCh,bCh); LogInstance("Sub "..GetReport(fCh, bCh, gModel))
        iCnt, iNxt = (iCnt + 2), (iNxt + 2)
      end
    end -- Append something if needed
    if(tApp and tApp[1]) then
      local fCh, bCh = tostring(tApp[1] or ""), tostring(tApp[2] or "")
      gModel = (fCh..gModel..bCh); LogInstance("App "..GetReport(fCh, bCh, gModel))
    end
  end -- Trigger the capital spacing using the divider ( _aaaaa_bbbb_ccccc )
  return GetBeautifyName(gModel:Trim("_"))
end

--[[
 * Creates a basis instance for entity-related operations
 * The instance is invisible and cannot be hit by traces
 * By default spawns at origin and angle {0,0,0}
 * sModel > The model to use for creating the entity
 * vPos   > Custom position for the placeholder ( zero if none )
 * aAng   > Custom angles for the placeholder ( zero if none )
]]
function NewEntityNone(sModel, vPos, aAng) local eNone
  if(not IsModel(sModel)) then return nil end
  if(SERVER) then eNone = entsCreate(GetOpVar("ENTITY_DEFCLASS"))
  elseif(CLIENT) then eNone = entsCreateClientProp(sModel) end
  if(not (eNone and eNone:IsValid())) then
    LogInstance("Entity invalid "..GetReport(sModel)); return nil end
  local vPos = Vector(vPos or GetOpVar("VEC_ZERO"))
  local aAng =  Angle(aAng or GetOpVar("ANG_ZERO"))
  eNone:SetPos(vPos); eNone:SetAngles(aAng)
  eNone.DoNotDuplicate = true -- Disable duping
  eNone:SetCollisionGroup(COLLISION_GROUP_NONE)
  eNone:SetSolid(SOLID_NONE); eNone:SetMoveType(MOVETYPE_NONE)
  eNone:SetNotSolid(true); eNone:SetNoDraw(true); eNone:SetModel(sModel)
  LogInstance("Create "..GetReport(eNone:EntIndex(),sModel)); return eNone
end

--[[
 * Extracts an attachment as AngPos structure when provided with an ID
 * This function is used to populate POA structures on entity spawn
 * vSrc   > The model source which we must extract the attachments for
 * sID    > Attachment ID any/string being used for the extraction
 * Returns the position and angle transform table POA attachment
]]
function GetAttachmentByID(vSrc, sID)
  if(not IsHere(sID)) then -- No need to extract when no ID is provided
    LogInstance("Index empty "..GetReport(sID, vSrc)); return nil end
  local sID, eBase, sSrc = tostring(sID) if(IsBlank(sID)) then
    LogInstance("Index missing "..GetReport(sID, vSrc)); return nil end
  if(isstring(vSrc)) then -- Source is a model path
    sSrc = vSrc; if(not IsModel(sSrc)) then
      LogInstance("Model mismatch "..GetReport(sID, sSrc)); return nil, sSrc end
    eBase = GetOpVar("ENTITY_TRANSFORMPOA") -- Use transform entity
    if(eBase and eBase:IsValid()) then -- Valid basis entity then
      if(eBase:GetModel() ~= sSrc) then eBase:SetModel(sSrc)
        LogInstance("Update "..GetReport(eBase:EntIndex(), sID, sSrc)) end
    else -- If there is no basis need to create one for attachment extraction
      eBase = NewEntityNone(sSrc); if(not (eBase and eBase:IsValid())) then
        LogInstance("Basis creation error "..GetReport(sID, sSrc)); return nil, sSrc end
      SetOpVar("ENTITY_TRANSFORMPOA", eBase) -- Register the entity transform basis
    end -- Transfer the data from the transform attachment location
  else -- Assume the source is an entity already spawned use it instead
    if(not (vSrc and vSrc:IsValid())) then
      LogInstance("Entity invalid "..GetReport(sID, vSrc)); return nil, sSrc end
    eBase, sSrc = vSrc, vSrc:GetModel(); if(not isstring(sID)) then
      LogInstance("Index mismatch "..GetReport(sID, sSrc)); return nil, sSrc end
  end
  local mID = eBase:LookupAttachment(sID); if(not isnumber(mID)) then
    LogInstance("Attachment invalid ID "..GetReport(sID, sSrc)); return nil, sSrc end
  local mTOA = eBase:GetAttachment(mID); if(not IsHere(mTOA)) then
    LogInstance("Attachment missing "..GetReport(sID, mID, sSrc)); return nil, sSrc end
  LogInstance("Extract "..GetReport(sID, mTOA.Pos, mTOA.Ang))
  return mTOA, sSrc -- The function must return transform table
end

--[[
 * Locates an active point on the piece offset cache record.
 * This function is used to check the correct offset and return it.
 * It also returns the normalized active point ID if needed
 * Updates current record origin and angle when they use attachments
 * oRec   > Record structure of a track piece stored in the cache
 * ivPoID > The POA offset ID to be checked and located
 * Returns a cache record and the converted to number offset ID
]]
function LocatePOA(oRec, ivPoID)
  if(not oRec) then LogInstance("Missing record"); return nil end
  local tOffs = oRec.Offs; if(not tOffs) then
    LogInstance("Missing offsets for "..GetReport(oRec.Slot)); return nil end
  local iPoID = tonumber(ivPoID); if(iPoID) then iPoID = mathFloor(iPoID)
    else LogInstance("ID mismatch "..GetReport(ivPoID)); return nil end
  local stPOA = tOffs[iPoID]; if(not IsHere(stPOA)) then
    LogInstance("Missing ID "..GetReport(iPoID, oRec.Slot)); return nil end
  if(oRec.Tran) then oRec.Tran = nil -- Transforming has started
    local sE = GetOpVar("OPSYM_ENTPOSANG") -- Extract transform from model
    for ID = 1, oRec.Size do local tPOA = tOffs[ID] -- Index current offset
      local sP, sO, sA = tPOA.P:Raw(), tPOA.O:Raw(), tPOA.A:Raw()
      if(sO) then tPOA.O:Decode(sO, oRec.Slot, "Pos")
        LogInstance("Origin spawn "..GetReport(ID, sO))
      end -- Transform origin is decoded from the model and stored in the cache
      if(sA) then tPOA.A:Decode(sA, oRec.Slot, "Ang")
        LogInstance("Angle spawn "..GetReport(ID, sA))
      end -- Transform angle is decoded from the model and stored in the cache
      if(sP) then tPOA.P:Decode(sP, oRec.Slot, "Pos", tPOA.O:Get())
        LogInstance("Point spawn "..GetReport(ID, sP))
      end -- Otherwise point is initialized on registration and we have nothing to do here
      LogInstance("Index "..GetReport(ID, tPOA.P:String(), tPOA.O:String(), tPOA.A:String()))
    end -- Loop and transform all the POA configuration at once. Game model slot will be taken
  end; return stPOA, iPoID
end

function RegisterPOA(stData, ivID, sP, sO, sA)
  local sNull = GetOpVar("MISS_NOSQL"); if(not stData) then
    LogInstance("Cache record invalid"); return nil end
  local iID = tonumber(ivID); if(not IsHere(iID)) then
    LogInstance("Offset ID mismatch "..GetReport(ivID)); return nil end
  local sP = (sP or sNull); if(not isstring(sP)) then
    LogInstance("Point mismatch "..GetReport(sP)); return nil end
  local sO = (sO or sNull); if(not isstring(sO)) then
    LogInstance("Origin mismatch "..GetReport(sO)); return nil end
  local sA = (sA or sNull); if(not isstring(sA)) then
    LogInstance("Angle mismatch "..GetReport(sA)); return nil end
  if(not stData.Offs) then if(iID > 1) then
    LogInstance("Mismatch ID "..GetReport(iID, stData.Slot)); return nil end
    stData.Offs = {}
  end
  local tOffs = stData.Offs; if(tOffs[iID]) then
    LogInstance("Exists ID "..GetReport(iID)); return nil
  else
    if((iID > 1) and (not tOffs[iID - 1])) then
      LogInstance("Scatter ID "..GetReport(iID)); return nil end
    tOffs[iID] = {}; tOffs = tOffs[iID] -- Allocate a local offset index
    tOffs.P = NewPOA(); tOffs.O = NewPOA(); tOffs.A = NewPOA()
  end; local sE = GetOpVar("OPSYM_ENTPOSANG")
  if(sO:sub(1,1) == sE) then -- To be decoded on spawn via locating
    stData.Tran = true; tOffs.O:Set(); tOffs.O:Raw(sO) -- Store transform
    LogInstance("Origin init "..GetReport(iID, sO, stData.Slot))
  else -- When the origin is empty use the zero otherwise decode the value
    tOffs.O:Import(sO, stData.Slot) -- Try to decode the origin when present
  end -- Try decoding the transform point when not applicable
  if(sA:sub(1,1) == sE) then -- To be decoded on spawn via locating
    stData.Tran = true; tOffs.A:Set(); tOffs.A:Raw(sA) -- Store transform
    LogInstance("Angle init "..GetReport(iID, sA, stData.Slot))
  else -- When the angle is empty use the zero otherwise decode the value
    tOffs.A:Import(sA, stData.Slot) -- Try to decode the angle when present
  end -- Try decoding the transform point when not applicable
  if(tOffs.O:Raw() or sP:sub(1,1) == sE) then -- Origin transform trigger
    stData.Tran = true; tOffs.P:Set(); tOffs.P:Raw(sP) -- Store transform
    LogInstance("Point init "..GetReport(iID, sP, stData.Slot))
  else -- When the point is empty use the origin otherwise decode the value
    tOffs.P:Import(sP, stData.Slot, tOffs.O:Get()) -- Try to decode the point when present
  end -- Try decoding the transform point when not applicable
  return tOffs -- On success return the populated POA offset
end

function PrioritySort(tSrc, vPrn, ...)
  local tC = (istable(vPrn) and vPrn or {vPrn, ...})
  local tS = {Size = 0}; tC.Size = #tC
  for key, rec in pairs(tSrc) do -- Scan the entire table
    tS.Size = tS.Size + 1 -- Allocate key/record and store
    tableInsert(tS, {Key = key, Rec = rec}) -- New table
  end -- The table keys are converted to integers
  if(istable(tS[1].Rec)) then -- Data is table
    if(tC.Size > 0) then -- Sorting column names provided
      local fC = GetOpVar("VCOMPARE_SDAT")
      tableSort(tS, function(u, v) return fC(u, v, tC) end)
    else tableSort(tS, GetOpVar("VCOMPARE_SKEY")) end
  else tableSort(tS, GetOpVar("VCOMPARE_SREC")) end; return tS
end

------------- VARIABLE INTERFACES --------------

--[[
 * Returns a string term whenever it is missing or disabled
 * If these conditions are not met the function returns missing token
 * sBas > The string to check whenever it is disabled or missing
 * fEmp > Defines that the value is to be replaced by something else
 * ...  > When missing acts like empty check otherwise picks a value
]]
function GetEmpty(sBas, fEmp, ...)
  local sS, fE = tostring(sBas or ""), fEmp -- Default to string
  -- Use default empty definition when one not provided
  if(not fE) then fE = GetOpVar("EMPTYSTR_BNDX") end
  local bS, oS = pcall(fE, sS); if(not bS) then
    LogInstance("Error "..GetReport(sS, oS)) end
  local iC = select("#", ...) -- Arguments count
  if(iC == 0) then return oS, sS end -- Empty check only
  if(not oS) then return sS end -- Base is not empty
  local sM, tV = GetOpVar("MISS_NOAV"), {...}
  for iD = 1, iC do -- Check all arguments for a value
    local sS = tostring(tV[iD] or "") -- Default to string
    local bS, oS = pcall(fE, sS); if(not bS) then
      LogInstance("Error "..GetReport(iD, sS, oS)) end
    if(not oS) then return sS end
  end; return sM
end

function ModelToNameRule(sRule, gCut, gSub, gApp)
  if(not isstring(sRule)) then
    LogInstance("Rule mismatch "..GetReport(sRule)); return false end
  if(sRule == "GET") then
    return GetOpVar("TABLE_GCUT_MODEL"),
           GetOpVar("TABLE_GSUB_MODEL"),
           GetOpVar("TABLE_GAPP_MODEL")
  elseif(sRule == "CLR" or sRule == "REM") then
    SetOpVar("TABLE_GCUT_MODEL", ((sRule == "CLR") and {} or nil))
    SetOpVar("TABLE_GSUB_MODEL", ((sRule == "CLR") and {} or nil))
    SetOpVar("TABLE_GAPP_MODEL", ((sRule == "CLR") and {} or nil))
  elseif(sRule == "SET") then
    SetOpVar("TABLE_GCUT_MODEL", ((gCut and gCut[1]) and gCut or {}))
    SetOpVar("TABLE_GSUB_MODEL", ((gSub and gSub[1]) and gSub or {}))
    SetOpVar("TABLE_GAPP_MODEL", ((gApp and gApp[1]) and gApp or {}))
  else LogInstance("Wrong mode: "..sRule); return false end
end

function Categorize(oTyp, fCat, ...)
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
    if(isstring(fCat)) then
      tTyp = (tCat[sTyp] or {}); tCat[sTyp] = tTyp; tTyp.Txt = fCat
    elseif(istable(fCat)) then local tArg = {...}
      local sTr = GetOpVar("OPSYM_REVISION") -- Trigger
      local sSe = GetOpVar("OPSYM_DIRECTORY") -- Separator
      tTyp = (tCat[sTyp] or {}); tCat[sTyp] = tTyp
      tTyp.Txt = [[function(m)
        local o = {}
        function setBranch(v, p, b, q)
          if(v:find(p)) then
            local e = v:gsub("%W*"..p.."%W*", "_")
            if(b and o.M) then return e end
            if(b and not o.M) then o.M = true end
            table.insert(o, (q or p)); return e
          end; return v
        end]]
      tTyp.Txt = tTyp.Txt.."\nlocal r = m:gsub(\""..tostring(tArg[1] or "").."\",\"\"):gsub(\"%.mdl$\",\"\");"
      for iD = 1, #fCat do
        local tV = sSe:Explode(fCat[iD])
        local sR = tostring(tV[2] and ("\""..tostring(tV[2]).."\"") or nil)
        if(tV[1]:sub(1,1) == sTr) then tV[1] = tV[1]:sub(2,-1)
          tTyp.Txt = tTyp.Txt.."\nr = setBranch(r, \""..tostring(tV[1]).."\", true, "..sR..")"
        else
          tTyp.Txt = tTyp.Txt.."\nr = setBranch(r, \""..tostring(tV[1]).."\", false, "..sR..")"
        end
      end
      tTyp.Txt = tTyp.Txt.."\no.M = nil; return o, r:gsub(\"^_+\", \"\"):gsub(\"_+$\", \"\"):gsub(\"_+\", \"_\") end"
    elseif(isnumber(fCat)) then local tArg = {...}
      tTyp = (tCat[sTyp] or {}); tCat[sTyp] = tTyp
      tTyp.Txt = "function(m)"
      tTyp.Txt = tTyp.Txt.."\nlocal n = math.floor(tonumber("..fCat..") or 0)"
      tTyp.Txt = tTyp.Txt.."\nlocal m = m:gsub(\""..tostring(tArg[1] or "").."\", \"\")\n"
      for i = 2, #tArg do local aP, aN = tArg[i], tArg[i+1]
        if(aP and aN) then tTyp.Txt = tTyp.Txt.."\nlocal m = m:gsub(\""..aP.."\", \""..aN.."\")\n" end end
      tTyp.Txt = tTyp.Txt..[[local t, x = {n = 0}, m:find("/", 1, true)
        while(x and x > 0) do
          t.n = t.n + 1; t[t.n] = m:sub(1, x-1)
          m = m:sub(x+1, -1); x = m:find("/", 1, true)
        end; m = m:gsub("%.mdl$","")
        if(n == 0) then return t, m end; local a = math.abs(n)
        if(a > t.n) then return t, m end; local s = #t-a
        if(n < 0) then for i = 1, a do t[i] = t[i+s] end end
        while(s > 0) do table.remove(t); s = s - 1 end
        return t, m
      end]]
    else LogInstance("Skip "..GetReport(fCat), ssLog); return nil end
    tTyp.Cmp = CompileString("return ("..tTyp.Txt..")", sTyp)
    local bS, vO = pcall(tTyp.Cmp); if(not bS) then
      LogInstance("Failed "..GetReport(fCat)..": "..vO, ssLog); return nil end
    tTyp.Cmp = vO; return sTyp, tTyp.Txt, tTyp.Cmp
  end
end

------------------------- PLAYER -----------------------------------

function GetPlayerSpot(pPly)
  if(not IsPlayer(pPly)) then
    LogInstance("Invalid "..GetReport(pPly)); return nil end
  local stSpot = libPlayer[pPly]; if(not IsHere(stSpot)) then
    LogInstance("Cached "..GetReport(pPly:Nick()))
    libPlayer[pPly] = {}; stSpot = libPlayer[pPly]
  end; return stSpot
end

function SetCacheSpawn(stData)
  local stSpawn, iD = GetOpVar("STRUCT_SPAWN"), 1
  while(stSpawn[iD]) do local tSec, iK = stSpawn[iD], 1
    while(tSec[iK]) do local def = tSec[iK]
      local key = tostring(def[1] or "") -- Table key
      local typ = tostring(def[2] or ""):upper() -- Type
      local inf = tostring(def[3] or "") -- Key information
      if    (typ == "VEC") then stData[key] = Vector()
      elseif(typ == "ANG") then stData[key] = Angle()
      elseif(typ == "MTX") then stData[key] = Matrix()
      elseif(typ == "RDB") then stData[key] = nil
      elseif(typ == "NUM") then stData[key] = 0
      else LogInstance("Spawn skip "..GetReport(key,typ,inf))
      end; iK = iK + 1 -- Update members count
    end; iD = iD + 1 -- Update categories count
  end; return stData
end

function GetCacheSpawn(pPly, tDat)
  if(tDat) then -- When data spot is forced from user
    local stData = tDat; if(not istable(stData)) then
      LogInstance("Invalid "..GetReport(stData)); return nil end
    if(IsEmpty(stData)) then
      stData = SetCacheSpawn(stData)
      LogInstance("Populate "..GetReport(pPly:Nick()))
    end; return stData
  else -- Use internal data spot
    local stSpot = GetPlayerSpot(pPly)
    if(not IsHere(stSpot)) then
      LogInstance("Spot missing"); return nil end
    local stData = stSpot["SPAWN"]
    if(not IsHere(stData)) then
      stSpot["SPAWN"] = {}; stData = stSpot["SPAWN"]
      stData = SetCacheSpawn(stData)
      LogInstance("Allocate "..GetReport(pPly:Nick()))
    end; return stData
  end
end

function CacheClear(pPly, bNow)
  if(not IsPlayer(pPly)) then
    LogInstance("Invalid "..GetReport(pPly)); return false end
  local stSpot = libPlayer[pPly]; if(not IsHere(stSpot)) then
    LogInstance("Clean"); return true end
  if(SERVER) then
    local qT = GetQueue("THINK")
    if(qT) then qT:GetBusy()[pPly] = nil end
  end
  local cT = GetOpVar("HOVER_TRIGGER")
  if(cT and cT[pPly]) then cT[pPly] = nil end
  libPlayer[pPly] = nil; if(bNow) then collectgarbage() end
  return true
end

--[[
 * Used for scaling hit position circle
 * pPly > Player the radius is scaled for
 * vHit > Hit position circle to be scaled
 * nSca > Radius multiplier value
]]
function GetCacheRadius(pPly, vHit, nSca)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end
  local stData = stSpot["RADIUS"]
  if(not IsHere(stData)) then
    LogInstance("Allocate "..GetReport(pPly, pPly:Nick()))
    stSpot["RADIUS"] = {}; stData = stSpot["RADIUS"]
    stData["MAR"] =  (GetOpVar("GOLDEN_RATIO") * 1000)
    stData["LIM"] = ((GetOpVar("GOLDEN_RATIO") - 1) * 100)
  end
  local nMul = (tonumber(nSca) or 1) -- Disable scaling on missing or outside
        nMul = ((nMul <= 1 and nMul >= 0) and nMul or 1)
  local nMar, nLim = stData["MAR"], stData["LIM"]
  local nDst = vHit:Distance(pPly:GetPos())
        nMul = mathClamp((nMar / nDst) * nMul, 1, nLim)
  local nRad = ((nDst ~= 0) and nMul or 0)
  return nRad, nDst, nMar, nLim
end

function GetCacheTrace(pPly)
  local stSpot = GetPlayerSpot(pPly); if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end
  local stData, plyTime = stSpot["TRACE"], Time()
  if(not IsHere(stData)) then -- Define trace delta margin
    LogInstance("Allocate "..GetReport(pPly, pPly:Nick()))
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
    LogInstance("Allocate "..GetReport(pPly, pPly:Nick()))
    stSpot["CURVE"] = {}; stData = stSpot["CURVE"]
    stData.Info  = {} -- This holds various vectors and angles and other data
    stData.Rays = {} -- Holds hashes whenever given node is an active point
    stData.Info.Pos = {Vector(), Vector()} -- Start and end positions of active points
    stData.Info.Ang = {Angle (), Angle ()} -- Start and end angles of active points
    stData.Info.UCS = {Vector(), Vector()} -- Origin and normal vector for the iteration
    stData.Snap  = {} -- Contains array of position and angle snap information
    stData.Node  = {} -- Contains array of node positions for the curve calculation
    stData.Norm  = {} -- Contains array of normal vector for the curve calculation
    stData.Base  = {} -- Contains array of hit positions for the curve calculation
    stData.CNode = {} -- The place where the curve nodes are stored
    stData.CNorm = {} -- The place where the curve normals are stored
    stData.Size  = 0  -- The amount of points for the primary node array
    stData.CSize = 0  -- The amount of points for the calculated nodes array
    stData.SSize = 0  -- The amount of points for the snaps node array
    stData.SKept = 0  -- The amount of total snap points the snaps node array
  end;
  if(not stData.Size ) then stData.Size  = 0 end
  if(not stData.CSize) then stData.CSize = 0 end
  if(not stData.SSize) then stData.SSize = 0 end
  if(not stData.SKept) then stData.SKept = 0 end
  return stData
end

function Notify(pPly,sText,sType)
  if(not IsPlayer(pPly)) then
    LogInstance("Player invalid "..GetReport(pPly)); return false end
  if(SERVER) then -- Send notification to client that something happened
    pPly:SendLua(GetOpVar("FORM_NTFGAME"):format(sText, sType))
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
    LogInstance("Player invalid "..GetReport(pPly)); return false end
  pPly:EmitSound(GetOpVar("FORM_SNAPSND"):format(mathRandom(1, 3)))
  undoSetCustomUndoText(GetOpVar("LABEL_UNDO")..tostring(vMsg or ""))
  undoSetPlayer(pPly); undoFinish(); return true
end

-------------------------- BUILDSQL ------------------------------

function GetBuilderNick(sTable)
  if(not isstring(sTable)) then
    LogInstance("Table mismatch "..GetReport(sTable)); return nil end
  local makTab = libQTable[sTable]; if(not IsHere(makTab)) then
    LogInstance("Missing table builder for "..GetReport(sTable)); return nil end
  if(not makTab:IsValid()) then
    LogInstance("Builder object invalid "..GetReport(sTable)); return nil end
  return makTab -- Return the dedicated table builder object
end

function GetBuilderID(vID)
  local nID = tonumber(vID); if(not IsHere(nID)) then
    LogInstance("ID mismatch "..GetReport(vID)); return nil end
  if(nID <= 0) then LogInstance("ID invalid "..GetReport(nID)); return nil end
  local makTab = GetBuilderNick(libQTable[nID]); if(not IsHere(makTab)) then
    LogInstance("Builder object missing "..GetReport(nID)); return nil end
  return makTab -- Return the dedicated table builder object
end

function NewTable(sTable,defTab,bDelete,bReload)
  if(not isstring(sTable)) then
    LogInstance("Table nick mismatch "..GetReport(sTable)); return false end
  if(IsBlank(sTable)) then
    LogInstance("Table nick is mandatory"); return false end
  if(not istable(defTab)) then
    LogInstance("Table definition missing for "..GetReport(sTable)); return false end
  defTab.Nick = sTable:upper(); defTab.Name = GetOpVar("TOOLNAME_PU")..defTab.Nick
  defTab.Size = #defTab; if(defTab.Size <= 0) then
    LogInstance("Record definition missing for "..GetReport(sTable), defTab.Nick); return false end
  if(defTab.Size ~= tableMaxn(defTab)) then
    LogInstance("Record definition mismatch for "..GetReport(sTable), defTab.Nick); return false end
  for iCnt = 1, defTab.Size do local defRow = defTab[iCnt]
    local sN = tostring(defRow[1] or ""); if(IsBlank(sN)) then
      LogInstance("Missing table column name "..GetReport(iCnt), defTab.Nick); return false end
    local sT = tostring(defRow[2] or ""); if(IsBlank(sT)) then
      LogInstance("Missing table column type "..GetReport(iCnt), defTab.Nick); return false end
    defRow[1], defRow[2] = sN, sT -- Convert settings to string and store back
  end
  local self, tabDef, tabCmd = {}, defTab, {}
  local sMoDB  = GetOpVar("MODE_DATABASE")
  local symDis = GetOpVar("OPSYM_DISABLE")
  local emFva  = GetOpVar("EMPTYSTR_BLNU")
  for iCnt = 1, defTab.Size do local defCol = defTab[iCnt]
    defCol[3] = GetEmpty(defCol[3], emFva, symDis)
    defCol[4] = GetEmpty(defCol[4], emFva, symDis)
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
  -- Deny the currently built statement
  function self:Deny()
    local qtCmd = self:GetCommand()
    if(not qtCmd.STMT) then return self end
    qtCmd[qtCmd.STMT] = false; return self
  end
  -- Store built query in command list
  function self:Store(vK, sQ)
    if(not IsHere(vK)) then return self end
    local qtCmd = self:GetCommand() -- Current query
    local mQ, tQ = qtCmd.STMT, GetOpVar("QUERY_STORE")
    local sQ = (sQ or (mQ and qtCmd[mQ] or nil))
    LogInstance("Entry "..GetReport(vK, sQ), tabDef.Nick)
    tQ[vK] = sQ; return self
  end
  -- Alias for reading the last created SQL statement
  function self:Get(vK, ...)
    if(vK) then
      local tQ = GetOpVar("QUERY_STORE")
      local sQ = tQ[vK] -- Store entry
      if(not IsHere(sQ)) then return sQ end
      if(not sQ) then return sQ end
      return sQ:format(...)
    else
      local qtCmd = self:GetCommand()
      local iK = (vK or qtCmd.STMT)
      return qtCmd[iK]
    end
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
  -- Returns the column information by the given ID > 0
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
    return vRet
  end
  -- Generates a timer settings table and keeps the defaults
  function self:TimerSetup(vTim)
    local qtCmd, qtDef = self:GetCommand(), self:GetDefinition()
    local vTm, tTm = (vTim and vTim or qtDef.Timer), qtCmd.Timer
    if(not tTm) then qtCmd.Timer = {}; tTm = qtCmd.Timer end
    if(isstring(vTm)) then -- String or table passed
      local cTm = GetOpVar("OPSYM_REVISION"):Explode(vTm)
      tTm[1] =   tostring(cTm[1]  or "CQT")   -- Timer mode
      tTm[2] =  (tonumber(cTm[2]) or 0)       -- Record life
      tTm[3] = ((tonumber(cTm[3]) or 0) ~= 0) -- Kill command
      tTm[4] = ((tonumber(cTm[4]) or 0) ~= 0) -- Collect garbage call
    elseif(istable(vTm)) then -- Transfer table data from definition
      tTm[1] =   tostring(vTm[1] or vTm["Mo"]  or "CQT")   -- Timer mode
      tTm[2] =  (tonumber(vTm[2] or vTm["Li"]) or 0)       -- Record life
      tTm[3] = ((tonumber(vTm[3] or vTm["Rm"]) or 0) ~= 0) -- Kill command
      tTm[4] = ((tonumber(vTm[4] or vTm["Co"]) or 0) ~= 0) -- Collect garbage call
    elseif(isfunction(vTm)) then -- Transfer table data from definition
      local bS, vO = pcall(vTm); if(not bS) then
        LogInstance("Generator "..vO,tabDef.Nick); return self end
      return self:TimerSetup(vO) -- Force function return value
    elseif(isvector(vTm) or isangle(vTm) or ismatrix(vTm)) then
      local cA, cB, cC = vTm:Unpack()
      tTm[2] =  (cA or 0)       -- Record life
      tTm[3] = ((cB or 0) ~= 0) -- Kill command
      tTm[4] = ((cC or 0) ~= 0) -- Collect garbage call
    else -- Transfer table data from definition
      tTm[2] = (tonumber(vTm) or 0) -- Record life
    end; return self
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
    local sDiv  = GetOpVar("OPSYM_DIVIDER")
    local oSpot, kKey, tKey = self:GetNavigate(...)
    local sMoDB, iCnt = GetOpVar("MODE_DATABASE"), select("#", ...)
    if(not (IsHere(oSpot) and IsHere(kKey))) then
      LogInstance("Navigation failed",tabDef.Nick); return nil end
    LogInstance("Called by "..GetReport(vMsg, kKey),tabDef.Nick)
    if(sMoDB == "SQL") then local qtCmd = self:GetCommand() -- Read the command and current time
      local nNow, tTim = Time(), qtCmd.Timer; if(not IsHere(tTim)) then
        LogInstance("Missing timer settings",tabDef.Nick); return oSpot[kKey] end
      oSpot[kKey].Used = nNow -- Make the first selected deleteable to avoid phantom records
      local smTM, tmLif, tmDie, tmCol = tTim[1], tTim[2], tTim[3], tTim[4]; if(tmLif <= 0) then
        LogInstance("Timer attachment ignored",tabDef.Nick); return oSpot[kKey] end
      LogInstance("Stats "..GetReport(iCnt, smTM, tmLif, tmDie, tmCol), tabDef.Nick)
      if(smTM == "CQT") then
        if(iCnt > 1) then -- Record in the placeholder must be cleared
          for key, rec in pairs(oSpot) do -- Check other items that qualify
            if(not rec.Used) then -- Used time is updated correctly. Report it
              LogInstance("Navigation error "..GetReport(iCnt, unpack(tKey)),tabDef.Nick)
              LogInstance("Navigation key "..GetReport(kKey, key),tabDef.Nick)
              LogTable(rec, "Navigation", tabDef.Nick)
            else -- Used time is updated correctly. Try to do some work
              local vDif = (nNow - rec.Used) -- Calculate time difference
              if(IsHere(rec.Used) and (vDif > tmLif)) then -- Check the deletion
                LogInstance("Qualify "..GetReport(vDif, tmLif), tabDef.Nick)
                if(tmDie) then oSpot[key] = nil; LogInstance("Clear "..GetReport(key),tabDef.Nick) end
              end -- Clear one item that qualifies for deletion and time frame is present
            end
          end -- Clear all the items that qualified for deletion
        else -- The whole cache placeholder must be deleted. Identifier is at base pointer
          local key, rec = kKey, oSpot[kKey] -- Index placeholder
          if(not rec.Used) then -- Used time is updated correctly. Report it
            LogInstance("Navigation error "..GetReport(iCnt, unpack(tKey)),tabDef.Nick)
            LogInstance("Navigation key "..GetReport(kKey, key),tabDef.Nick)
            LogTable(rec, "Navigation", tabDef.Nick)
          else -- Used time is updated correctly. Try to do some work
            local vDif = (nNow - rec.Used) -- Calculate time difference
            if(IsHere(rec.Used) and (vDif > tmLif)) then -- Check the deletion
              LogInstance("Qualify "..GetReport(vDif, tmLif), tabDef.Nick)
              if(tmDie) then oSpot[key] = nil; LogInstance("Clear "..GetReport(key),tabDef.Nick) end
            end -- Clear the placeholder that qualifies for deletion and time frame is present
          end
        end
        if(tmCol) then collectgarbage(); LogInstance("Garbage collected",tabDef.Nick) end
        LogInstance("Finish "..GetReport(kKey, nNow), tabDef.Nick); return oSpot[kKey]
      elseif(smTM == "OBJ") then
        local tmID = tableConcat(tKey, sDiv)
        LogInstance("Timer ID "..GetReport(tmID), tabDef.Nick)
        if(timerExists(tmID)) then LogInstance("Timer exists",tabDef.Nick); return oSpot[kKey] end
        timerCreate(tmID, tmLif, 1, function()
          LogInstance("Qualify "..GetReport(tmID, tmLif), tabDef.Nick)
          if(tmDie) then oSpot[kKey] = nil; LogInstance("Clear "..GetReport(kKey),tabDef.Nick) end
          timerStop(tmID); timerRemove(tmID)
          if(tmCol) then collectgarbage(); LogInstance("Garbage collected",tabDef.Nick) end
        end); timerStart(tmID); return oSpot[kKey]
      else LogInstance("Unsupported mode "..GetReport(smTM),tabDef.Nick); return oSpot[kKey] end
    elseif(sMoDB == "LUA") then
      LogInstance("Memory manager impractical",tabDef.Nick); return oSpot[kKey]
    else LogInstance("Unsupported mode "..GetReport(sMoDB),tabDef.Nick); return nil end
  end
  -- Restarts timer to a record related in the table cache
  function self:TimerRestart(vMsg, ...)
    local sDiv  = GetOpVar("OPSYM_DIVIDER")
    local sMoDB = GetOpVar("MODE_DATABASE")
    local oSpot, kKey, tKey = self:GetNavigate(...)
    if(not (IsHere(oSpot) and IsHere(kKey))) then
      LogInstance("Navigation failed",tabDef.Nick); return nil end
    LogInstance("Called by "..GetReport(vMsg, kKey),tabDef.Nick)
    if(sMoDB == "SQL") then local qtCmd = self:GetCommand()
      local tTim = qtCmd.Timer; if(not IsHere(tTim)) then
        LogInstance("Missing timer settings",tabDef.Nick); return oSpot[kKey] end
      oSpot[kKey].Used = Time() -- Mark the current caching time stamp
      local smTM, tmLif = tTim[1], tTim[2]; if(tmLif <= 0) then
        LogInstance("Timer life ignored",tabDef.Nick); return oSpot[kKey] end
      if(smTM == "CQT") then smTM = "CQT" -- Cache query timer does nothing
      elseif(smTM == "OBJ") then -- Just for something to do here for mode CQT
        local tmID = tableConcat(tKey, sDiv); if(not timerExists(tmID)) then
          LogInstance("Timer missing "..GetReport(tmID),tabDef.Nick); return nil end
        timerStart(tmID)
      else LogInstance("Mode mismatch "..GetReport(smTM),tabDef.Nick); return nil end
    elseif(sMoDB == "LUA") then oSpot[kKey].Used = Time()
    else LogInstance("Unsupported mode "..GetReport(sMoDB),tabDef.Nick); return nil end
    return oSpot[kKey]
  end
  -- Object internal data validation
  function self:IsValid() local bStat = true
    local qtCmd = self:GetCommand(); if(not qtCmd) then
      LogInstance("Missing commands "..GetReport(defTab.Nick), tabDef.Nick); bStat = false end
    local qtDef = self:GetDefinition(); if(not qtDef) then
      LogInstance("Missing definition",tabDef.Nick); bStat = false end
    if(qtDef.Size ~= #qtDef) then
      LogInstance("Mismatch count",tabDef.Nick); bStat = false end
    if(qtDef.Size ~= tableMaxn(qtDef)) then
      LogInstance("Mismatch maxN",tabDef.Nick); bStat = false end
    if(defTab.Nick:upper() ~= defTab.Nick) then
      LogInstance("Nick lower",tabDef.Nick); bStat = false end
    if(defTab.Name:upper() ~= defTab.Name) then
      LogInstance("Name lower "..GetReport(defTab.Nick), tabDef.Nick); bStat = false end
    local nS, nE = defTab.Name:find(defTab.Nick); if(not (nS and nE and nS > 1 and nE == defTab.Name:len())) then
      LogInstance("Mismatch "..GetReport(defTab.Name, defTab.Nick), tabDef.Nick); bStat = false end
    for iD = 1, qtDef.Size do local tCol = qtDef[iD] if(not istable(tCol)) then
        LogInstance("Mismatch type "..GetReport(iD),tabDef.Nick); bStat = false end
      if(not isstring(tCol[1])) then -- Check table column name
        LogInstance("Mismatch name "..GetReport(iD, tCol[1]), tabDef.Nick); bStat = false end
      if(not isstring(tCol[2])) then -- Check table column type
        LogInstance("Mismatch type "..GetReport(iD, tCol[2]), tabDef.Nick); bStat = false end
      if(tCol[3] and not isstring(tCol[3])) then -- Check trigger control
        LogInstance("Mismatch ctrl "..GetReport(iD, tCol[3]), tabDef.Nick); bStat = false end
      if(tCol[4] and not isstring(tCol[4])) then -- Check quote conversion
        LogInstance("Mismatch conv "..GetReport(iD, tCol[4]),tabDef.Nick); bStat = false end
    end; return bStat -- Successfully validated the builder table
  end
  -- Creates table column list as string
  function self:GetColumnList(sD)
    if(not IsHere(sD)) then return "" end
    local sD = tostring(sD or "\t"):sub(1,1); if(IsBlank(sD)) then
      LogInstance("Missing delimiter",tabDef.Nick); return "" end
    local qtDef, sRes = self:GetDefinition(), sD
    for iCnt = 1, qtDef.Size do
      local sCon = ((iCnt ~= qtDef.Size) and sD or "")
      local sVac = tostring(qtDef[iCnt][1] or "")
      sRes = (sRes..sVac..sCon)
    end; return sRes
  end
  -- Internal type matching
  function self:Match(snValue,ivID,bQuoted,sQuote,bNoRev,bNoNull)
    local qtDef, sNull = self:GetDefinition(), GetOpVar("MISS_NOSQL")
    local nvID = tonumber(ivID); if(not IsHere(nvID)) then
      LogInstance("Column ID mismatch "..GetReport(ivID),tabDef.Nick); return nil end
    local defCol = qtDef[nvID]; if(not IsHere(defCol)) then
      LogInstance("Invalid column "..GetReport(nvID),tabDef.Nick); return nil end
    local tyCol, opCol, snOut = tostring(defCol[2]), defCol[3]
    local sMoDB = GetOpVar("MODE_DATABASE"); if(sMoDB ~= "SQL" and sMoDB ~= "LUA") then
      LogInstance("Unsupported mode "..GetReport(sMoDB,ivID,tyCol,opCol),tabDef.Nick); return nil end
    if(tyCol == "TEXT") then snOut = tostring(snValue or "")
      if(not bNoNull and IsBlank(snOut)) then
        if    (sMoDB == "SQL") then snOut = sNull
        elseif(sMoDB == "LUA") then snOut = sNull end
      end
      if    (opCol == "LOW") then snOut = snOut:lower()
      elseif(opCol == "CAP") then snOut = snOut:upper() end
      if(not bNoRev and sMoDB == "SQL" and defCol[4] == "QMK") then
        snOut = snOut:gsub("'","''") end
      if(bQuoted) then local sqChar
        if(sQuote) then
          sqChar = tostring(sQuote or ""):sub(1,1)
        else
          if    (sMoDB == "SQL") then sqChar = "'"
          elseif(sMoDB == "LUA") then sqChar = "\"" end
        end; snOut = sqChar..snOut..sqChar
      end
    elseif(tyCol == "REAL" or tyCol == "INTEGER") then
      snOut = tonumber(snValue); if(not IsHere(snOut)) then
        LogInstance("Failed converting number"..GetReport(snValue, nvID),tabDef.Nick); return nil end
      if(tyCol == "INTEGER") then
        if    (opCol == "FLR") then snOut = mathFloor(snOut)
        elseif(opCol == "CEL") then snOut = mathCeil (snOut) end
      end
    else LogInstance("Invalid column type "..GetReport(tyCol),tabDef.Nick); return nil
    end; return snOut
  end
  -- Build SQL drop statement
  function self:Drop()
    local qtDef = self:GetDefinition()
    local qtCmd = self:GetCommand(); qtCmd.STMT = "DROP"
    local qsKey = GetOpVar("FORM_KEYSTMT"):format(qtCmd.STMT, "")
    local sStmt = self:Get(qsKey, qtDef.Name)
    if(not IsHere(sStmt)) then
      sStmt = qtCmd.STMT.." TABLE %s;"
      sStmt = self:Store(qsKey, sStmt):Get(qsKey, qtDef.Name)
    end; qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- Build SQL delete statement
  function self:Delete()
    local qtDef = self:GetDefinition()
    local qtCmd = self:GetCommand(); qtCmd.STMT = "DELETE"
    local qsKey = GetOpVar("FORM_KEYSTMT"):format(qtCmd.STMT, "")
    local sStmt = self:Get(qsKey, qtDef.Name)
    if(not sStmt) then
      sStmt = qtCmd.STMT.." FROM %s;"
      sStmt = self:Store(qsKey, sStmt):Get(qsKey, qtDef.Name)
    end; qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- https://wiki.garrysmod.com/page/sql/Begin
  -- Build SQL begin statement
  function self:Begin()
    local qtCmd = self:GetCommand(); qtCmd.STMT = "BEGIN"
    local qsKey = GetOpVar("FORM_KEYSTMT"):format(qtCmd.STMT, "")
    local sStmt = self:Get(qsKey)
    if(not sStmt) then
      sStmt = qtCmd.STMT..";"
      sStmt = self:Store(qsKey, sStmt):Get(qsKey)
    end; qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- https://wiki.garrysmod.com/page/sql/Commit
  -- Build SQL commit statement
  function self:Commit()
    local qtCmd = self:GetCommand(); qtCmd.STMT = "COMMIT"
    local qsKey = GetOpVar("FORM_KEYSTMT"):format(qtCmd.STMT, "")
    local sStmt = self:Get(qsKey)
    if(not sStmt) then
      sStmt = qtCmd.STMT..";"
      sStmt = self:Store(qsKey, sStmt):Get(qsKey)
    end; qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- Build create/drop/delete statement table of statements
  -- Build SQL create table statement
  function self:Create()
    local qtDef = self:GetDefinition()
    local qtCmd = self:GetCommand(); qtCmd.STMT = "CREATE"
    local sStmt = qtCmd.STMT.." TABLE IF NOT EXISTS "..qtDef.Name.." ( "
    for iCnt = 1, qtDef.Size do
      local tC = qtDef[iCnt]; if(not tC) then
        LogInstance("Column missing "..GetReport(nA,iCnt), tabDef.Nick); return self:Deny() end
      local sC = tostring(tC[1] or ""); if(IsBlank(sC)) then
        LogInstance("Column name mismatch "..GetReport(nA,iCnt),tabDef.Nick); return self:Deny() end
      local sT = tostring(tC[2] or ""); if(IsBlank(sT)) then
        LogInstance("Column type mismatch "..GetReport(nA,iCnt),tabDef.Nick); return self:Deny() end
      sStmt = sStmt..sC.." "..sT..(iCnt ~= qtDef.Size and ", " or " );")
    end; qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- Build SQL table indexes statement
  function self:Index(...)
    local nA, tA = select("#", ...)
    local qtDef = self:GetDefinition()
    if(nA > 0) then tA = {...} else
      tA = qtDef.Index; nA = #tA
      LogInstance("Definition source", tabDef.Nick)
    end
    local qtCmd = self:GetCommand(); qtCmd.STMT = "INDEX"
    local tStmt = qtCmd[qtCmd.STMT]
    if(not tStmt) then tStmt = {}; qtCmd[qtCmd.STMT] = tStmt end
    local sDiv = GetOpVar("OPSYM_DIVIDER"); tableEmpty(tStmt); tStmt.Size = nA
    for iCnt = 1, nA do local vA = tA[iCnt]
      if(isnumber(vA)) then vA = {vA} end; if(not istable(vA)) then
        LogInstance("Argument not table "..GetReport(nA,iCnt,vA),tabDef.Nick); return self:Deny() end
      local sV, nV, bNe = "", #vA, (vA.Ne or not IsHere(vA.Ne))
      tStmt[iCnt] = "CREATE "..(vA.Un and "UNIQUE " or "")..qtCmd.STMT..(bNe and " IF NOT EXISTS " or " ")
                             .."IND_"..qtDef.Name..sDiv..tableConcat(vA,sDiv).." ON "..qtDef.Name.." ( "
      for iInd = 1, nV do
        local iV = mathFloor(tonumber(vA[iInd]) or 0); if(iV == 0) then
          LogInstance("Index mismatch "..GetReport(nA,iCnt,iInd),tabDef.Nick); return self:Deny() end
        local tC = qtDef[iV]; if(not tC) then
          LogInstance("Column missing "..GetReport(nA,iCnt,iInd,iV), tabDef.Nick); return self:Deny() end
        local sC = tostring(tC[1] or ""); if(IsBlank(sC)) then
          LogInstance("Column mismatch "..GetReport(nA,iCnt,iInd,iV),tabDef.Nick); return self:Deny() end
        sV = sV..sC..(iInd ~= nV and ", " or " );")
      end; tStmt[iCnt] = tStmt[iCnt]..sV
    end return self
  end
  -- Builds an SQL select statement
  function self:Select(...)
    local qtCmd = self:GetCommand()
    local qtDef = self:GetDefinition(); qtCmd.STMT = "SELECT"
    local sStmt, nA = qtCmd.STMT.." ", select("#", ...)
    if(nA > 0) then local tA = {...}
      for iCnt = 1, nA do
        local vA = mathFloor(tonumber(tA[iCnt]) or 0); if(vA == 0) then
          LogInstance("Index mismatch "..GetReport(nA,iCnt),tabDef.Nick); return self:Deny() end
        local tC = qtDef[vA]; if(not tC) then
          LogInstance("Column missing "..GetReport(nA,iCnt,vA), tabDef.Nick); return self:Deny() end
        local sC = tostring(tC[1] or ""); if(IsBlank(sC)) then
          LogInstance("Column mismatch "..GetReport(nA,iCnt,vA),tabDef.Nick); return self:Deny() end
        sStmt = sStmt..sC..(iCnt ~= nA and ", " or "")
      end
    else sStmt = sStmt.."*" end
    qtCmd[qtCmd.STMT] = sStmt .." FROM "..qtDef.Name..";"; return self
  end
  -- Add where clause to the current statement
  function self:Where(...)
    local nA = select("#", ...); if(nA == 0) then
      LogInstance("Arguments missing", tabDef.Nick); return self end
    local qtCmd = self:GetCommand(); if(not qtCmd.STMT) then
      LogInstance("Current missing "..GetReport(nA,...), tabDef.Nick); return self end
    local sStmt = qtCmd[qtCmd.STMT]; if(not IsHere(sStmt)) then
      LogInstance("Statement missing "..GetReport(nA,qtCmd.STMT), tabDef.Nick); return self end
    if(not sStmt and isbool(sStmt)) then
      LogInstance("Statement deny "..GetReport(nA,qtCmd.STMT), tabDef.Nick); return self:Deny() end
    if(not isstring(sStmt)) then
      LogInstance("Previous mismatch "..GetReport(nA,qtCmd.STMT,sStmt),tabDef.Nick); return self:Deny() end
    local tA, qtDef = {...}, self:GetDefinition(); sStmt = sStmt:Trim("%s"):Trim(";")
    for iCnt = 1, nA do
      local vA, sW = tA[iCnt], ((iCnt == 1) and " WHERE " or " AND "); if(not istable(vA)) then
        LogInstance("Argument not table "..GetReport(nA,iCnt), tabDef.Nick); return self:Deny() end
      local wC, wV = vA[1], vA[2]; if(not (wC and wV)) then
        LogInstance("Parameters missing "..GetReport(nA,iCnt,wC,wV), tabDef.Nick); return self:Deny() end
      local tC = qtDef[wC]; if(not tC) then
         LogInstance("Column missing "..GetReport(nA,iCnt,wC,wV), tabDef.Nick); return self:Deny() end
      local sC = tostring(tC[1] or ""); if(IsBlank(sC)) then
        LogInstance("Column mismatch "..GetReport(nA,iCnt,wC,wV),tabDef.Nick); return self:Deny() end
      sStmt = sStmt..sW..sC.." = "..tostring(wV)
    end; qtCmd[qtCmd.STMT] = sStmt..";"; return self
  end
  -- Add order by clause to the current statement
  function self:Order(...)
    local nA = select("#", ...); if(nA == 0) then
      LogInstance("Arguments missing", tabDef.Nick); return self end
    local qtCmd = self:GetCommand(); if(not qtCmd.STMT) then
      LogInstance("Current missing "..GetReport(nA,...), tabDef.Nick); return self end
    local sStmt = qtCmd[qtCmd.STMT]; if(not IsHere(sStmt)) then
      LogInstance("Statement missing "..GetReport(nA,qtCmd.STMT), tabDef.Nick); return self end
    if(not sStmt and isbool(sStmt)) then
      LogInstance("Statement deny "..GetReport(nA,qtCmd.STMT), tabDef.Nick); return self:Deny() end
    if(not isstring(sStmt)) then
      LogInstance("Previous mismatch "..GetReport(nA,qtCmd.STMT,sStmt),tabDef.Nick); return self:Deny() end
    local qtDef, tA = self:GetDefinition(), {...}; sStmt = sStmt:Trim("%s"):Trim(";").." ORDER BY "
    for iCnt = 1, nA do
      local vA = mathFloor(tonumber(tA[iCnt]) or 0); if(vA == 0) then
        LogInstance("Column undefined "..GetReport(nA,iCnt,vA),tabDef.Nick); return self:Deny() end
      local sDir = ((vA > 0) and " ASC" or " DESC"); vA = mathAbs(vA)
      local tC = qtDef[vA]; if(not tC) then
        LogInstance("Column missing "..GetReport(nA,iCnt,vA), tabDef.Nick); return self:Deny() end
      local sC = tostring(tC[1] or ""); if(IsBlank(sC)) then
        LogInstance("Column mismatch "..GetReport(nA,iCnt,vA),tabDef.Nick); return self:Deny() end
      sStmt = sStmt..sC..sDir..(iCnt ~= nA and ", " or ";")
    end; qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- Build SQL insert statement
  function self:Insert(...)
    local qtCmd, nA = self:GetCommand(), select("#", ...)
    local qtDef = self:GetDefinition(); qtCmd.STMT = "INSERT"
    local sStmt = qtCmd.STMT.." INTO "..qtDef.Name.." ( "
    if(nA > 0) then local tA = {...}
      for iCnt = 1, nA do -- Assume the user wants to build custom insert
        local vA = mathFloor(tonumber(tA[iCnt]) or 0); if(vA == 0) then
          LogInstance("Column undefined "..GetReport(nA,iCnt,vA),tabDef.Nick); return self:Deny() end
        local tC = qtDef[vA]; if(not tC) then
          LogInstance("Column missing "..GetReport(nA,iCnt,vA), tabDef.Nick); return self:Deny() end
        local sC = tostring(tC[1] or ""); if(IsBlank(sC)) then
          LogInstance("Column mismatch "..GetReport(nA,iCnt,vA),tabDef.Nick); return self:Deny() end
        sStmt = sStmt..sC..(iCnt ~= nA and ", " or " )")
      end
    else nA = qtDef.Size -- When called with no arguments is the same as picking all columns
      for iCnt = 1, nA do
        local tC = qtDef[iCnt]; if(not tC) then
          LogInstance("Column missing "..GetReport(nA,iCnt), tabDef.Nick); return self:Deny() end
        local sC = tostring(tC[1] or ""); if(IsBlank(sC)) then
          LogInstance("Column mismatch "..GetReport(nA,iCnt),tabDef.Nick); return self:Deny() end
        sStmt = sStmt..sC..(iCnt ~= nA and ", " or " )")
      end
    end; qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- Add values clause to the current statement
  function self:Values(...)
    local qtCmd, qtDef = self:GetCommand(), self:GetDefinition()
    local tA, nA, sStmt = {...}, select("#", ...), qtCmd[qtCmd.STMT]
    if(not sStmt and isbool(sStmt)) then
      LogInstance("Statement deny "..GetReport(nA,qtCmd.STMT), tabDef.Nick); return self:Deny() end
    if(not isstring(sStmt)) then
      LogInstance("Previous mismatch "..GetReport(nA,qtCmd.STMT,sStmt),tabDef.Nick); return self:Deny() end
    sStmt = sStmt:Trim("%s"):Trim(";").." VALUES ( "
    for iCnt = 1, nA do sStmt = sStmt..tostring(tA[iCnt])..(iCnt ~= nA and ", " or " );") end
    qtCmd[qtCmd.STMT] = sStmt; return self
  end
  -- Uses the given array to create a record in the table
  function self:Record(arLine)
    local qtDef, sMoDB, sFunc = self:GetDefinition(), GetOpVar("MODE_DATABASE"), "Record"
    if(not arLine) then LogInstance("Missing data table",tabDef.Nick); return false end
    if(not arLine[1]) then LogInstance("Missing PK",tabDef.Nick)
      for key, val in pairs(arLine) do
        LogInstance("Row data "..GetReport(key, val), tabDef.Nick) end
      return false -- Print all other values when the model is missing
    end -- Read the log source format and reduce the number of concatenations
    local fsLog = GetOpVar("FORM_LOGSOURCE") -- The actual format value
    local ssLog = "*"..fsLog:format(qtDef.Nick,sFunc,"%s")
    -- Call the trigger when provided
    if(istable(qtDef.Trigs)) then local bS, sR = pcall(qtDef.Trigs[sFunc], arLine, ssLog:format("Trigs"))
      if(not bS) then LogInstance("Trigger manager "..sR,tabDef.Nick); return false end
      if(not sR) then LogInstance("Trigger routine fail",tabDef.Nick); return false end
    end -- Populate the data after the trigger does its thing
    if(sMoDB == "SQL") then local qsKey = GetOpVar("FORM_KEYSTMT")
      for iD = 1, qtDef.Size do arLine[iD] = self:Match(arLine[iD],iD,true) end
      local qIndx = qsKey:format(sFunc, qtDef.Nick)
      local Q = self:Get(qIndx, unpack(arLine)); if(not IsHere(Q)) then
        Q = self:Insert():Values(unpack(qtDef.Query[sFunc])):Store(qIndx):Get(qIndx, unpack(arLine)) end
      if(not Q) then LogInstance("Build statement failed "..GetReport(qIndx,arLine[1]),tabDef.Nick); return false end
      local qRez = sqlQuery(Q); if(not qRez and isbool(qRez)) then
         LogInstance("Execution error "..GetReport(sqlLastError(), Q),tabDef.Nick); return false end
      return true -- The dynamic statement insertion was successful
    elseif(sMoDB == "LUA") then local snPK = self:Match(arLine[1],1)
      if(not IsHere(snPK)) then -- If primary key becomes a number
        LogInstance("Primary key mismatch "..GetReport(arLine[1], qtDef[1][1], snPK), tabDef.Nick); return false end
      local tCache = libCache[qtDef.Name]; if(not IsHere(tCache)) then
        LogInstance("Cache missing",tabDef.Nick); return false end
      if(not istable(qtDef.Cache)) then
        LogInstance("Cache manager missing",tabDef.Nick); return false end
      local bS, sR = pcall(qtDef.Cache[sFunc], self, tCache, snPK, arLine, ssLog:format("Cache"))
      if(not bS) then LogInstance("Cache manager fail "..sR,tabDef.Nick); return false end
      if(not sR) then LogInstance("Cache routine fail",tabDef.Nick); return false end
    else LogInstance("Unsupported mode "..GetReport(sMoDB,1,qtDef[1][2]),tabDef.Nick); return false end
    return true -- The dynamic cache population was successful
  end
  -- When database mode is SQL create a table in sqlite
  if(sMoDB == "SQL") then local vO
    vO = self:Create():Get(); if(not IsHere(vO)) then
      LogInstance("Build create failed"); return self:Remove(false) end
    vO = self:Index():Get(); if(not IsHere(vO)) then
      LogInstance("Build index failed"); return self:Remove(false) end
    vO = self:Drop():Get(); if(not IsHere(vO)) then
      LogInstance("Build drop failed"); return self:Remove(false) end
    vO = self:Delete():Get(); if(not IsHere(vO)) then
      LogInstance("Build delete failed"); return self:Remove(false) end
    vO = self:Begin():Get(); if(not IsHere(vO)) then
      LogInstance("Build begin failed"); return self:Remove(false) end
    vO = self:Commit():Get(); if(not IsHere(vO)) then
      LogInstance("Build commit failed"); return self:Remove(false) end
    vO = self:TimerSetup(); if(not IsHere(vO)) then
      LogInstance("Build timer failed"); return self:Remove(false) end
    local tQ = self:GetCommand(); if(not IsHere(tQ)) then
      LogInstance("Build command failed"); return self:Remove(false) end
    -- When enabled forces a table drop
    if(bReload) then
      if(sqlTableExists(defTab.Name)) then -- Remove table when SQL error is present
        local qRez = sqlQuery(tQ.DROP); if(not qRez and isbool(qRez)) then
          LogInstance("Table drop fail "..GetReport(sqlLastError(), tQ.DROP), tabDef.Nick)
          return self:Remove(false) -- Remove table when SQL error is present
        else LogInstance("Table drop success",tabDef.Nick) end
      else LogInstance("Table drop skipped",tabDef.Nick) end
    end
    -- Create the table using the given name and properties
    if(sqlTableExists(defTab.Name)) then
      LogInstance("Table create skipped",tabDef.Nick)
    else -- Remove table when SQL error is present
      local qRez = sqlQuery(tQ.CREATE); if(not qRez and isbool(qRez)) then
        LogInstance("Table create fail "..GetReport(sqlLastError(), tQ.CREATE), tabDef.Nick)
        return self:Remove(false) -- Remove table when SQL error is present
      end -- Check when SQL query has passed and the table is not yet created
      if(sqlTableExists(defTab.Name)) then
        for iQ = 1, tQ.INDEX.Size do local qInx = tQ.INDEX[iQ]
          local qRez = sqlQuery(qInx); if(not qRez and isbool(qRez)) then
            LogInstance("Table create index fail "..GetReport(sqlLastError(), iQ, qInx), tabDef.Nick)
            return self:Remove(false) -- Clear table when index is not created
          end -- Check when the index query has passed
          LogInstance("Table create index: "..v,tabDef.Nick)
        end
      else
        LogInstance("Table create check fail "..GetReport(sqlLastError(), tQ.CREATE), tabDef.Nick)
        return self:Remove(false) -- Clear table when it is not created by the first pass
      end
    end
    -- When the table is present delete all records
    if(bDelete) then
      if(sqlTableExists(defTab.Name)) then local qRez = sqlQuery(tQ.DELETE)
        if(not qRez and isbool(qRez)) then -- Remove table when SQL error is present
          LogInstance("Table delete fail "..GetReport(sqlLastError(), tQ.DELETE), tabDef.Nick)
          return self:Remove(false) -- Remove table when SQL error is present
        else LogInstance("Table delete success",tabDef.Nick) end
      else LogInstance("Table delete skipped",tabDef.Nick) end
    end
  elseif(sMoDB == "LUA") then local tCache = libCache[tabDef.Nick]
    if(IsHere(tCache)) then -- Empty the table when its cache is located
      tableEmpty(tCache); LogInstance("Table create empty",tabDef.Nick)
    else libCache[tabDef.Nick] = {}; LogInstance("Table create allocate",tabDef.Nick); end
  else LogInstance("Unsupported mode "..GetReport(sMoDB,sTable),tabDef.Nick); return self:Remove(false) end
end

--------------- TIMER MEMORY MANAGMENT ----------------------------

function CacheBoxLayout(oEnt,nCamX,nCamZ)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity invalid "..GetReport(oEnt)); return nil end
  local sMo  = oEnt:GetModel() -- Extract the entity model
  local oRec = CacheQueryPiece(sMo); if(not IsHere(oRec)) then
    LogInstance("Record invalid "..GetReport(sMo)); return nil end
  local stBox = oRec.Layout; if(not IsHere(stBox)) then
    oRec.Layout = {}; stBox = oRec.Layout -- Allocated chance layout
    stBox.Cen, stBox.Ang = oEnt:OBBCenter(), Angle() -- Layout position and angle
    stBox.Eye = oEnt:LocalToWorld(stBox.Cen) -- Layout camera eye
    stBox.Len = oEnt:BoundingRadius() -- Use bounding radius as entity size
    stBox.Cam = Vector(stBox.Eye) -- Layout camera position
    local nX = stBox.Len * (tonumber(nCamX) or 0) -- Calculate camera X
    local nZ = stBox.Len * (tonumber(nCamZ) or 0) -- Calculate camera Z
    local nCX, nCY, nCZ = stBox.Cam:Unpack()
          nCX, nCZ = (nCX + nX), (nCZ + nZ) -- Apply calculated camera offsets
    stBox.Cam:SetUnpacked(nCX, nCY, nCZ)
    LogInstance("Elevate "..GetReport(stBox.Cen, stBox.Len))
  end; return stBox
end

--------------------------- PIECE QUERY -----------------------------

function CacheQueryPiece(sModel)
  if(not IsModel(sModel)) then
    LogInstance("Model invalid "..GetReport(sModel)); return nil end
  local makTab = GetBuilderNick("PIECES"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  local tCache = libCache[defTab.Name]; if(not IsHere(tCache)) then
    LogInstance("Cache missing for "..GetReport(defTab.Name)); return nil end
  local sModel, qsKey = makTab:Match(sModel,1,false,"",true,true), GetOpVar("FORM_KEYSTMT")
  local stData, sFunc = tCache[sModel], "CacheQueryPiece"
  if(IsHere(stData) and IsHere(stData.Size)) then
    if(stData.Size <= 0) then stData = nil else
      stData = makTab:TimerRestart(sFunc, defTab.Name, sModel) end
    return stData
  else
    local sMoDB = GetOpVar("MODE_DATABASE")
    if(sMoDB == "SQL") then
      local qModel = makTab:Match(sModel,1,true)
      LogInstance("Save >> "..GetReport(sModel))
      tCache[sModel] = {}; stData = tCache[sModel]; stData.Size = 0
      local qIndx = qsKey:format(sFunc, "")
      local Q = makTab:Get(qIndx, qModel); if(not IsHere(Q)) then
        Q = makTab:Select():Where({1,"%s"}):Order(4):Store(qIndx):Get(qIndx, qModel) end
      if(not Q) then -- Query creation has failed so no need to build again
        LogInstance("Build statement failed "..GetReport(qIndx, qModel)); return nil end
      local qData = sqlQuery(Q); if(not qData and isbool(qData)) then
        LogInstance("SQL exec error "..GetReport(sqlLastError(), Q)); return nil end
      if(not IsHere(qData) or IsEmpty(qData)) then
        LogInstance("No data found "..GetReport(Q)); return nil end
      stData.Slot, stData.Size = sModel, #qData
      stData.Type = qData[1][makTab:GetColumnName(2)]
      stData.Name = qData[1][makTab:GetColumnName(3)]
      stData.Unit = qData[1][makTab:GetColumnName(8)]
      local coID, coP = makTab:GetColumnName(4), makTab:GetColumnName(5)
      local coO , coA = makTab:GetColumnName(6), makTab:GetColumnName(7)
      for iCnt = 1, stData.Size do
        local qRec = qData[iCnt]; if(iCnt ~= qRec[coID]) then
          LogInstance("Sequential mismatch "..GetReport(iCnt,sModel)); return nil end
        if(not IsHere(RegisterPOA(stData,iCnt, qRec[coP], qRec[coO], qRec[coA]))) then
          LogInstance("Cannot process offset "..GetReport(iCnt, sModel)); return nil
        end
      end; stData = makTab:TimerAttach(sFunc, defTab.Name, sModel); return stData
    elseif(sMoDB == "LUA") then LogInstance("Record missing"); return nil
    else LogInstance("Unsupported mode "..GetReport(sMoDB,defTab.Nick)); return nil end
  end
end

function CacheQueryAdditions(sModel)
  if(not IsModel(sModel)) then
    LogInstance("Model invalid "..GetReport(sModel)); return nil end
  local makTab = GetBuilderNick("ADDITIONS"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  local tCache = libCache[defTab.Name]; if(not IsHere(tCache)) then
    LogInstance("Cache missing for "..GetReport(defTab.Name, sModel)); return nil end
  local sModel, qsKey = makTab:Match(sModel,1,false,"",true,true), GetOpVar("FORM_KEYSTMT")
  local stData, sFunc = tCache[sModel], "CacheQueryAdditions"
  if(IsHere(stData) and IsHere(stData.Size)) then
    if(stData.Size <= 0) then stData = nil else
      stData = makTab:TimerRestart(sFunc, defTab.Name, sModel) end
    return stData
  else
    local sMoDB = GetOpVar("MODE_DATABASE")
    if(sMoDB == "SQL") then
      local qModel = makTab:Match(sModel,1,true)
      LogInstance("Save >> "..GetReport(sModel))
      tCache[sModel] = {}; stData = tCache[sModel]; stData.Size = 0
      local qIndx = qsKey:format(sFunc, "")
      local Q = makTab:Get(qIndx, qModel); if(not IsHere(Q)) then
        Q = makTab:Select():Where({1,"%s"}):Order(4):Store(qIndx):Get(qIndx, qModel) end
      if(not Q) then
        LogInstance("Build statement failed "..GetReport(qIndx,qModel)); return nil end
      local qData = sqlQuery(Q); if(not qData and isbool(qData)) then
        LogInstance("SQL exec error "..GetReport(sqlLastError(), Q)); return nil end
      if(not IsHere(qData) or IsEmpty(qData)) then
        LogInstance("No data found "..GetReport(Q)); return nil end
      stData.Slot, stData.Size = sModel, #qData
      local coMo, coID = makTab:GetColumnName(1), makTab:GetColumnName(4)
      for iCnt = 1, stData.Size do
        local qRec = qData[iCnt]; qRec[coMo] = nil; if(iCnt ~= qRec[coID]) then
          LogInstance("Sequential mismatch "..GetReport(iCnt,sModel)); return nil end
        stData[iCnt] = {}; for col, val in pairs(qRec) do stData[iCnt][col] = val end
      end; stData = makTab:TimerAttach(sFunc, defTab.Name, sModel); return stData
    elseif(sMoDB == "LUA") then LogInstance("Record missing"); return nil
    else LogInstance("Unsupported mode "..GetReport(sMoDB, sModel)); return nil end
  end
end

----------------------- PANEL QUERY -------------------------------

--[[
 * Export tool panel contents as a sync file
 * stPanel > The actual tool panel information handled
 * sFunc   > Export requestor ( CacheQueryPanel )
 * bExp    > Control flag. Export when enabled
]]
local function DumpCategory(stPanel, sFunc, bExp)
  if(SERVER) then return stPanel end
  if(not bExp) then return stPanel end
  local sFunc  = tostring(sFunc or "")
  local sMiss = GetOpVar("MISS_NOAV")
  local sBase = GetOpVar("DIRPATH_BAS")
  local sExpo = GetOpVar("DIRPATH_EXP")
  local sMoDB = GetOpVar("MODE_DATABASE")
  local symSep, cT = GetOpVar("OPSYM_SEPARATOR")
  if(not fileExists(sBase, "DATA")) then fileCreateDir(sBase) end
  local fName = (sBase..sExpo..GetOpVar("NAME_LIBRARY").."_db.txt")
  local F = fileOpen(fName, "wb" ,"DATA"), sMiss; if(not F) then
    LogInstance("Open fail "..GetReport(fName)); return stPanel end
  F:Write("# "..sFunc..":("..stPanel.Size..") "..GetDateTime().." [ "..sMoDB.." ]\n")
  for iCnt = 1, stPanel.Size do
    local vRec = stPanel[iCnt]
    local sM, sT, sN = vRec.M, vRec.T, vRec.N
    if(not cT or cT ~= sT) then -- Category has been changed
      F:Write("# Categorize [ "..sMoDB.." ]("..sT.."): "..tostring(WorkshopID(sT) or sMiss))
      F:Write("\n"); cT = sT -- Cache category name
    end -- Otherwise just write down the piece active point
    F:Write("\""..sM.."\""..symSep)
    F:Write("\""..sT.."\""..symSep)
    F:Write("\""..sN.."\""); F:Write("\n")
  end; F:Flush(); F:Close(); return stPanel
end

--[[
 * Updates panel category to dedicated hash
 * stPanel > The actual panel information to populate
]]
local function SortCategory(stPanel)
  local tCat = GetOpVar("TABLE_CATEGORIES")
  for iCnt = 1, stPanel.Size do local vRec = stPanel[iCnt]
    -- Register the category if definition functional is given
    if(tCat[vRec.T]) then -- There is a category definition
      local bS, vC, vN = pcall(tCat[vRec.T].Cmp, vRec.M)
      if(bS) then -- When the call is successful in protected mode
        if(vN and not IsBlank(vN)) then vRec.N = GetBeautifyName(vN) end
        -- Custom name override when the addon requests
        if(IsBlank(vC)) then vC = nil end
        if(IsHere(vC)) then
          if(not istable(vC)) then vC = {tostring(vC or "")} end
          vRec.C = vC; vC.Size = #vC -- Make output category to point to local one
          for iD = 1, vC.Size do -- Create category tree path
            vC[iD] = tostring(vC[iD] or ""):lower():Trim()
            if(IsBlank(vC[iD])) then vC[iD] = "other" end
            vC[iD] = GetBeautifyName(vC[iD]) -- Beautify the category
          end -- When the category has at least one element
        end -- Is there is any category apply it. When available process it now
      else -- When there is an error in the category execution report it
        LogInstance("Process "..GetReport(vRec.T, vRec.M).." [[["..tCat[vRec.T].Txt.."]]] execution error: "..vC,sLog)
      end -- Category factory has been executed and sub-folders are created
    end -- Category definition has been processed and nothing more to be done
  end; tableSort(stPanel, GetOpVar("VCOMPARE_SPAN")); return stPanel
end

--[[
 * Caches the data needed to populate the CPanel tree
 * bExp > Export panel data into a DB file
]]
function CacheQueryPanel(bExp)
  local makTab = GetBuilderNick("PIECES"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  if(not IsHere(libCache[defTab.Name])) then
    LogInstance("Missing cache allocated "..GetReport(defTab.Name)); return nil end
  local keyPan , sFunc = GetOpVar("HASH_USER_PANEL"), "CacheQueryPanel"
  local stPanel, qsKey = libCache[keyPan], GetOpVar("FORM_KEYSTMT")
  if(IsHere(stPanel) and IsHere(stPanel.Size)) then LogInstance("Retrieve")
    if(stPanel.Size <= 0) then stPanel = nil else
      stPanel = makTab:TimerRestart(sFunc, keyPan) end
    return stPanel
  else
    local coMo = makTab:GetColumnName(1)
    local coTy = makTab:GetColumnName(2)
    local coNm = makTab:GetColumnName(3)
    local sMoDB = GetOpVar("MODE_DATABASE")
    libCache[keyPan] = {}; stPanel = libCache[keyPan]
    if(sMoDB == "SQL") then
      local qIndx = qsKey:format(sFunc,"")
      local Q = makTab:Get(qIndx, 1); if(not IsHere(Q)) then
        Q = makTab:Select(1,2,3):Where({4,"%d"}):Order(2,1):Store(qIndx):Get(qIndx, 1) end
      if(not Q) then
        LogInstance("Build statement failed "..GetReport(qIndx,1)); return nil end
      local qData = sqlQuery(Q); if(not qData and isbool(qData)) then
        LogInstance("SQL exec error "..GetReport(sqlLastError())); return nil end
      if(not IsHere(qData) or IsEmpty(qData)) then
        LogInstance("No data found "..GetReport(Q)); return nil end
      stPanel.Size = #qData -- Store the amount of SQL rows
      for iCnt = 1, stPanel.Size do local qRow = qData[iCnt]
        stPanel[iCnt] = {M = qRow[coMo], T = qRow[coTy], N = qRow[coNm]}
      end
      SortCategory(stPanel)
      DumpCategory(stPanel, sFunc, bExp)
      return makTab:TimerAttach(sFunc, keyPan)
    elseif(sMoDB == "LUA") then
      local tCache, stPanel = libCache[defTab.Name], {Size = 0}
      for mod, rec in pairs(tCache) do
        local iCnt = stPanel.Size; iCnt = iCnt + 1
        stPanel[iCnt] = {M = rec.Slot, T = rec.Type, N = rec.Name}
        stPanel.Size = iCnt -- Store the amount of rows
      end
      SortCategory(stPanel)
      DumpCategory(stPanel, sFunc, bExp)
      return stPanel
    else LogInstance("Unsupported mode "..GetReport(sMoDB)); return nil end
  end
end

--[[
 * Used to Populate the CPanel Phys Materials
 * If type is chosen, it gets the names for the type
 * If type is not chosen, it gets a list of all types
]]
function CacheQueryProperty(sType)
  local makTab = GetBuilderNick("PHYSPROPERTIES"); if(not IsHere(makTab)) then
    LogInstance("Missing table builder"); return nil end
  local defTab = makTab:GetDefinition(); if(not IsHere(defTab)) then
    LogInstance("Missing table definition"); return nil end
  local tCache = libCache[defTab.Name]; if(not tCache) then
    LogInstance("Cache missing for "..GetReport(defTab.Name)); return nil end
  local sMoDB, sFunc = GetOpVar("MODE_DATABASE"), "CacheQueryProperty"
  local qsKey = GetOpVar("FORM_KEYSTMT")
  if(isstring(sType) and not IsBlank(sType)) then
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
        arNames[sType] = {}; stName = arNames[sType]; stName.Size = 0
        local qType = makTab:Match(sType,1,true)
        local qIndx = qsKey:format(sFunc,keyName)
        local Q = makTab:Get(qIndx, qType); if(not IsHere(Q)) then
          Q = makTab:Select(3):Where({1,"%s"}):Order(2):Store(qIndx):Get(qIndx, qType) end
        if(not Q) then
          LogInstance("Build statement failed "..GetReport(qIndx,qType)); return nil end
        local qData = sqlQuery(Q); if(not qData and isbool(qData)) then
          LogInstance("SQL exec error "..GetReport(sqlLastError(), Q)); return nil end
        if(not IsHere(qData) or IsEmpty(qData)) then
          LogInstance("No data found "..GetReport(Q)); return nil end
        local coID, coNm = makTab:GetColumnName(2), makTab:GetColumnName(3)
        stName.Slot, stName.Size = sType, #qData
        for iCnt = 1, stName.Size do
          local qRec = qData[iCnt]; if(iCnt ~= qRec[coID]) then
            LogInstance("Sequential mismatch "..GetReport(iCnt,sType)); return nil end
          stName[iCnt] = qRec[coNm] -- Properties are stored as arrays of strings
        end
        LogInstance("Save >> "..GetReport(sType, keyName))
        stName = makTab:TimerAttach(sFunc, defTab.Name, keyName, sType); return stName
      elseif(sMoDB == "LUA") then LogInstance("Record missing"); return nil
      else LogInstance("Unsupported mode "..GetReport(sMoDB, keyName)); return nil end
    end
  else
    local keyType = GetOpVar("HASH_PROPERTY_TYPES")
    local stType  = tCache[keyType]
    if(IsHere(stType) and IsHere(stType.Size)) then
      LogInstance("Load >> "..GetReport(keyType))
      if(stType.Size <= 0) then stType = nil else
        stType = makTab:TimerRestart(sFunc, defTab.Name, keyType) end
      return stType
    else
      if(sMoDB == "SQL") then
        tCache[keyType] = {}; stType = tCache[keyType]; stType.Size = 0
        local qIndx = qsKey:format(sFunc,keyType)
        local Q = makTab:Get(qIndx, 1); if(not IsHere(Q)) then
          Q = makTab:Select(1):Where({2,"%d"}):Order(1):Store(qIndx):Get(qIndx, 1) end
        if(not Q) then
          LogInstance("Build statement failed "..GetReport(qIndx,1)); return nil end
        local qData = sqlQuery(Q); if(not qData and isbool(qData)) then
          LogInstance("SQL exec error "..GetReport(sqlLastError(), Q)); return nil end
        if(not IsHere(qData) or IsEmpty(qData)) then
          LogInstance("No data found "..GetReport(Q)); return nil end
        local coNm = makTab:GetColumnName(1); stType.Size = #qData
        for iCnt = 1, stType.Size do stType[iCnt] = qData[iCnt][coNm] end
        LogInstance("Save >> "..GetReport(keyType))
        stType = makTab:TimerAttach(sFunc, defTab.Name, keyType); return stType
      elseif(sMoDB == "LUA") then LogInstance("Record missing"); return nil
      else LogInstance("Unsupported mode "..GetReport(sMoDB, keyType)); return nil end
    end
  end
end

---------------------- EXPORT --------------------------------

--[[
 * Save/Load the category generation
 * vEq    > Amount of internal comment depth
 * tData  > The local data table to be exported ( if given )
 * sPref  > Prefix used on exporting ( if not uses instance prefix )
]]
function ExportCategory(vEq, tData, sPref)
  if(SERVER) then LogInstance("Working on server"); return true end
  local nEq = (tonumber(vEq) or 0); if(nEq <= 0) then
    LogInstance("Wrong equality "..GetReport(vEq)); return false end
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
  local tCat = (istable(tData) and tData or GetOpVar("TABLE_CATEGORIES"))
  F:Write("# "..sFunc..":("..tostring(nEq).."@"..fPref..") "..GetDateTime().." [ "..sMoDB.." ]\n")
  for cat, rec in pairs(tCat) do
    if(isstring(rec.Txt)) then
      local exp = "["..sEq.."["..cat..sEq..rec.Txt:Trim().."]"..sEq.."]"
      if(not rec.Txt:find("\n")) then F:Flush(); F:Close()
        LogInstance("("..fPref.."):("..fPref..") Category one-liner "..GetReport(cat)); return false end
      F:Write(exp.."\n")
    else F:Flush(); F:Close(); LogInstance("("..fPref..") Category code mismatch "..GetReport(cat, rec.Txt)); return false end
  end; F:Flush(); F:Close(); LogInstance("("..fPref..") Success"); return true
end

function ImportCategory(vEq, sPref)
  if(SERVER) then LogInstance("Working on server"); return true end
  local nEq = (tonumber(vEq) or 0); if(nEq <= 0) then
    LogInstance("Wrong equality "..GetReport(vEq)); return false end
  local fPref = tostring(sPref or GetInstPref())
  local fForm, sTool = GetOpVar("FORM_PREFIXDSV"), GetOpVar("TOOLNAME_PU")
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..fForm:format(fPref, sTool.."CATEGORY")
  local F = fileOpen(fName, "rb", "DATA")
  if(not F) then LogInstance("("..fName..") Open fail"); return false end
  local sEq, sLine, nLen = ("="):rep(nEq), "", (nEq+2)
  local cFr, cBk = "["..sEq.."[", "]"..sEq.."]"
  local tCat = GetOpVar("TABLE_CATEGORIES")
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
            if(not IsDisable(key)) then
              tCat[key] = {}; tCat[key].Txt = txt:Trim()
              tCat[key].Cmp = CompileString("return ("..tCat[key].Txt..")",key)
              local bS, vO = pcall(tCat[key].Cmp)
              if(bS) then tCat[key].Cmp = vO else tCat[key].Cmp = nil
                LogInstance("Compilation fail "..GetReport(key, vO))
              end
            else LogInstance("Key skipped "..GetReport(key)) end
          else LogInstance("Function missing "..GetReport(key)) end
        else LogInstance("Name missing "..GetReport(txt)) end
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
]]
function ExportDSV(sTable, sPref, sDelim)
  if(not isstring(sTable)) then
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
  local fsLog = GetOpVar("FORM_LOGSOURCE") -- Read the log source format
  local ssLog = "*"..fsLog:format(defTab.Nick,sFunc,"%s")
  local sMoDB = GetOpVar("MODE_DATABASE") -- Read database mode
  F:Write("#1 "..sFunc..":("..fPref.."@"..sTable..") "..GetDateTime().." [ "..sMoDB.." ]\n")
  F:Write("#2 "..sTable..":("..makTab:GetColumnList(sDelim)..")\n")
  if(sMoDB == "SQL") then
    local Q = makTab:Select():Order(unpack(defTab.Query[sFunc])):Get()
    if(not IsHere(Q)) then F:Flush(); F:Close()
      LogInstance("("..fPref..") Build statement failed",sTable); return false end
    F:Write("#3 Query:<"..Q..">\n")
    local qData = sqlQuery(Q); if(not qData and isbool(qData)) then F:Flush(); F:Close()
      LogInstance("("..fPref..") SQL exec error "..GetReport(sqlLastError(), Q), sTable); return nil end
    if(not IsHere(qData) or IsEmpty(qData)) then F:Flush(); F:Close()
      LogInstance("("..fPref..") No data found "..GetReport(Q), sTable); return false end
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
  else LogInstance("("..fPref..") Unsupported mode "..GetReport(sMoDB, fName),sTable); return false end
  -- The dynamic cache population was successful then send a message
  F:Flush(); F:Close(); LogInstance("("..fPref..") Success",sTable); return true
end

--[[
 * Import table data from DSV database created earlier
 * sTable > Definition KEY to import
 * bComm  > Calls TABLE:Record(arLine) when set to true
 * sPref  > Prefix used on importing ( optional )
 * sDelim > Delimiter separating the values
]]
function ImportDSV(sTable, bComm, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref()); if(not isstring(sTable)) then
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
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  local sLine, isEOF, nLen = "", false, defTab.Name:len()
  if(sMoDB == "SQL") then sqlQuery(cmdTab.Begin)
    LogInstance("("..fPref..") Begin",sTable) end
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if((not IsBlank(sLine)) and (not IsDisable(sLine))) then
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
]]
function SynchronizeDSV(sTable, tData, bRepl, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref()); if(IsBlank(fPref)) then
    LogInstance("("..fPref..") Prefix empty"); return false end
  if(not isstring(sTable)) then
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
  local I, fData = fileOpen(fName, "rb", "DATA"), {}
  if(I) then local sLine, isEOF = "", false
    while(not isEOF) do sLine, isEOF = GetStringFile(I)
      if((not IsBlank(sLine)) and (not IsDisable(sLine))) then
        local tLine = sDelim:Explode(sLine)
        if(tLine[1] == defTab.Name) then local nL = #tLine
          for iCnt = 2, nL do local vV, iL = tLine[iCnt], (iCnt-1); vV = GetStrip(vV)
            vM = makTab:Match(vV,iL,false,"",true,true)
            if(not IsHere(vV)) then LogInstance("("..fPref.."@"..sTable
              ..") Read matching failed "..GetReport(vV, iL, defTab[iL][1])); return false end
            tLine[iCnt] = vM -- Register the matched value
          end -- Allocate table memory for the matched key
          local vK = tLine[2]; if(not fData[vK]) then fData[vK] = {Size = 0} end
          -- Where the line ID must be read from. Validate the value
          local fRec, vID, nID = fData[vK], tLine[iD+1]; nID = (tonumber(vID) or 0)
          if((fRec.Size < 0) or (nID <= fRec.Size) or ((nID - fRec.Size) ~= 1)) then
            I:Close(); LogInstance("("..fPref.."@"..sTable..") Scatter line ID "..GetReport(vID, vK)); return false end
          fRec.Size = nID; fRec[nID] = {}; local fRow = fRec[nID] -- Register the new line
          for iCnt = 3, nL do fRow[iCnt-2] = tLine[iCnt] end -- Transfer the extracted data
        else I:Close()
          LogInstance("("..fPref.."@"..sTable..") Read table name mismatch"); return false end
      end
    end; I:Close()
  else LogInstance("("..fPref.."@"..sTable..") Creating file "..GetReport(fName)) end
  for key, rec in pairs(tData) do -- Check the given table and match the key
    local vK = makTab:Match(key,1,false,"",true,true);
    if(not IsHere(vK)) then LogInstance("("..fPref.."@"..sTable.."@"
      ..tostring(key)..") Sync matching PK failed"); return false end
    local sKey, sVK = tostring(key), tostring(vK); if(sKey ~= sVK) then
      LogInstance("("..fPref.."@"..sTable..") Sync key mismatch "..GetReport(sKey, sVK));
      tData[vK] = tData[key]; tData[key] = nil -- Override the key casing after matching
    end local tRec = tData[vK] -- Create local reference to the record of the matched key
    for iCnt = 1, #tRec do local tRow, vID, nID, sID = tRec[iCnt] -- Read the processed row reference
      vID = tRow[iD-1]; nID, sID = tonumber(vID), tostring(vID)
      nID = (nID or (IsDisable(sID) and iCnt or 0))
      -- Where the line ID must be read from. Skip the key itself and convert the disabled value
      if(iCnt ~= nID) then -- Validate the line ID being in proper borders and sequential
        LogInstance("("..fPref.."@"..sTable.."@"..sKey..") Sync point ID scatter "
          ..GetReport(iCnt, vID, nID, sID)); return false end; tRow[iD-1] = nID
      for nCnt = 1, #tRow do -- Do a value matching without quotes
        local vM = makTab:Match(tRow[nCnt],nCnt+1,false,"",true,true); if(not IsHere(vM)) then
          LogInstance("("..fPref.."@"..sTable.."@"..sKey..") Sync matching failed "
            ..GetReport(tRow[nCnt], (nCnt+1), defTab[nCnt+1][1])); return false
        end; tRow[nCnt] = vM -- Store the matched value in the same place as the original
      end -- Check whenever triggers are available. Run them if present
      if(istable(defTab.Trigs)) then tableInsert(tRow, 1, vK) -- Apply trigger format
        local bS, sR = pcall(defTab.Trigs["Record"], tRow, sFunc); if(not bS) then
          LogInstance("("..fPref.."@"..sTable..") Trigger "..GetReport(nID, vK).." error: "..sR); return false end
        if(not sR) then -- Rise log error when something gets wrong inside the trigger routine
          LogInstance("("..fPref.."@"..sTable..") Trigger "..GetReport(nID, vK).." routine fail"); return false end
        tableRemove(tRow, 1) -- Remove the fictive duplicated primary key from the row data first column
      end
    end -- Register the read line to the output file
    if(bRepl) then -- Replace the data when enabled overwrites the file data
      if(tData[vK]) then -- Update the file with the new data
        fData[vK] = tRec; fData[vK].Size = #tRec end
    end
  end
  local tSort = PrioritySort(fData); if(not tSort) then
    LogInstance("("..fPref.."@"..sTable..") Sorting failed"); return false end
  local O = fileOpen(fName, "wb" ,"DATA"); if(not O) then
    LogInstance("("..fPref.."@"..sTable..")("..fName..") Open fail"); return false end
  O:Write("# "..sFunc..":("..fPref.."@"..sTable..") "..GetDateTime().." [ "..sMoDB.." ]\n")
  O:Write("# "..sTable..":("..makTab:GetColumnList(sDelim)..")\n")
  for iKey = 1, tSort.Size do local key = tSort[iKey].Rec
    local vK = makTab:Match(key,1,true,"\"",true); if(not IsHere(vK)) then
      O:Flush(); O:Close(); LogInstance("("..fPref.."@"..sTable.."@"..tostring(key)..") Write matching PK failed"); return false end
    local fRec, sCash, sData = fData[key], defTab.Name..sDelim..vK, ""
    for iCnt = 1, fRec.Size do local fRow = fRec[iCnt]
      for nCnt = 1, #fRow do
        local vM = makTab:Match(fRow[nCnt],nCnt+1,true,"\"",true); if(not IsHere(vM)) then
          O:Flush(); O:Close(); LogInstance("("..fPref.."@"..sTable.."@"..tostring(key)..") Write matching failed "
            ..GetReport(fRow[nCnt], (nCnt+1), defTab[nCnt+1][1])); return false
        end; sData = sData..sDelim..tostring(vM)
      end; O:Write(sCash..sData.."\n"); sData = ""
    end
  end O:Flush(); O:Close()
  LogInstance("("..fPref.."@"..sTable..") Success"); return true
end

function TranslateDSV(sTable, sPref, sDelim)
  local fPref = tostring(sPref or GetInstPref()); if(IsBlank(fPref)) then
    LogInstance("("..fPref..") Prefix empty"); return false end
  if(not isstring(sTable)) then
    LogInstance("("..fPref..") Table mismatch "..GetReport(sTable)); return false end
  if(IsFlag("en_dsv_datalock")) then
    LogInstance("("..fPref..") User disabled"); return true end
  local makTab = GetBuilderNick(sTable); if(not IsHere(makTab)) then
    LogInstance("("..fPref..") Missing table builder",sTable); return false end
  local defTab, sFunc = makTab:GetDefinition(), "TranslateDSV"
  local sNdsv, sNins = GetOpVar("DIRPATH_BAS"), GetOpVar("DIRPATH_BAS")
  if(not fileExists(sNins,"DATA")) then fileCreateDir(sNins) end
  sNdsv, sNins = sNdsv..GetOpVar("DIRPATH_DSV"), sNins..GetOpVar("DIRPATH_EXP")
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
  local sLine, isEOF = "", false
  local sFr, sBk = sTable:upper()..":Record({", "})\n"
  while(not isEOF) do sLine, isEOF = GetStringFile(D)
    if((not IsBlank(sLine)) and (not IsDisable(sLine))) then
      sLine = sLine:gsub(defTab.Name,""):Trim()
      local tBoo, sCat = sDelim:Explode(sLine), ""
      for nCnt = 1, #tBoo do
        local vMatch = makTab:Match(GetStrip(tBoo[nCnt]),nCnt,true,"\"",true)
        if(not IsHere(vMatch)) then D:Close(); I:Flush(); I:Close()
          LogInstance("("..fPref..") Given matching failed "
            ..GetReport(tBoo[nCnt], nCnt, defTab[nCnt][1]), sTable); return false end
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
]]
function RegisterDSV(sProg, sPref, sDelim, bSkip)
  local fPref = tostring(sPref or GetInstPref()); if(IsBlank(fPref)) then
    LogInstance("("..fPref..") Prefix empty"); return false end
  if(IsFlag("en_dsv_datalock")) then
    LogInstance("("..fPref..") User disabled"); return true end
  if(CLIENT and gameSinglePlayer()) then
    LogInstance("("..fPref..") Single client"); return true end
  local sBas = GetOpVar("DIRPATH_BAS")
  if(not fileExists(sBas,"DATA")) then fileCreateDir(sBas) end
  local sBas = sBas..GetOpVar("DIRPATH_SET")
  if(not fileExists(sBas,"DATA")) then fileCreateDir(sBas) end
  local lbNam, sMiss = GetOpVar("NAME_LIBRARY"), GetOpVar("MISS_NOAV")
  local fName = (sBas..lbNam.."_dsv.txt")
  local sDelim = tostring(sDelim or "\t"):sub(1,1)
  if(bSkip) then
    if(fileExists(fName, "DATA")) then
      local fPool, isEOF, isAct = {}, false, true
      local F, sLine = fileOpen(fName, "rb" ,"DATA"), ""; if(not F) then
        LogInstance("Skip fail "..GetReport(fPref, fName)); return false end
      while(not isEOF) do sLine, isEOF = GetStringFile(F)
        if(not IsBlank(sLine)) then
          if(IsDisable(sLine)) then
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
          local sta = (tab[2] and "On " or "Off")
          LogInstance(GetReport(fPref, sta, tab[1])) end
        LogInstance("Skip "..GetReport(fPref, sProg)); return true
      end
    else LogInstance("Skip miss "..GetReport(fPref, fName)) end
  end
  local F = fileOpen(fName, "ab" ,"DATA"); if(not F) then
    LogInstance("Update fail "..GetReport(fPref, fName)); return false end
  F:Write(fPref..sDelim..tostring(sProg or sMiss).."\n"); F:Flush(); F:Close()
  LogInstance("Register "..GetReport(fPref)); return true
end

--[[
 * This function cycles all the lines made via @RegisterDSV(sProg, sPref, sDelim, bSkip)
 * or manually added and loads all the content bound by the prefix line read
 * to the database. It is used by addon creators when they want automatically
 * include and auto-process their custom pieces. The addon creator must
 * check if the PIECES file is created before calling this function
 * sDelim > The delimiter to be used while processing the DSV list
]]
function ProcessDSV(sDelim)
  local sBas = GetOpVar("DIRPATH_BAS")
  local sSet = GetOpVar("DIRPATH_SET")
  local lbNam = GetOpVar("NAME_LIBRARY")
  local fName = (sBas..sSet..lbNam.."_dsv.txt")
  local F = fileOpen(fName, "rb" ,"DATA"); if(not F) then
    LogInstance("Open fail "..GetReport(fName)); return false end
  local sLine, isEOF = "", false
  local sNt, fForm = GetOpVar("TOOLNAME_PU"), GetOpVar("FORM_PREFIXDSV")
  local sDelim, tProc = tostring(sDelim or "\t"):sub(1,1), {}
  local sDv = sBas..GetOpVar("DIRPATH_DSV")
  while(not isEOF) do sLine, isEOF = GetStringFile(F)
    if(not IsBlank(sLine)) then
      if(not IsDisable(sLine)) then
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
      else LogInstance("Skipped "..GetReport(sLine)) end
    end
  end; F:Close()
  for prf, tab in pairs(tProc) do
    if(tab.Cnt > 1) then
      LogInstance("Prefix clones "..GetReport(prf, tab.Cnt, fName))
      for iD = 1, tab.Cnt do LogInstance("Prefix "..GetReport(iD, prf, tab[iD])) end
    else local irf = GetInstPref()
      if(CLIENT) then
        if(not fileExists(sDv..fForm:format(irf, sNt.."CATEGORY"), "DATA")) then
          if(fileExists(sDv..fForm:format(prf, sNt.."CATEGORY"), "DATA")) then
            if(not ImportCategory(3, prf)) then
              LogInstance("Failed "..GetReport(prf, "CATEGORY")) end
          else LogInstance("Missing "..GetReport(prf, "CATEGORY")) end
        else LogInstance("Generic "..GetReport(prf, "CATEGORY")) end
      end
      for iD = 1, #libQTable do
        local makTab = GetBuilderID(iD)
        local defTab = makTab:GetDefinition()
        if(not fileExists(sDv..fForm:format(irf, sNt..defTab.Nick), "DATA")) then
          if(fileExists(sDv..fForm:format(prf, sNt..defTab.Nick), "DATA")) then
            if(not ImportDSV(defTab.Nick, true, prf)) then
              LogInstance("Failed "..GetReport(prf, defTab.Nick)) end
          else LogInstance("Missing "..GetReport(prf, defTab.Nick)) end
        else LogInstance("Generic "..GetReport(prf, defTab.Nick)) end
      end
    end
  end; LogInstance("Success"); return true
end

--[[
 * This function adds the extracted addition for given model to a list
 * sModel > The model to be checked for additions
 * makTab > Reference to additions table builder
 * qList  > The list to insert the found additions
]]
function SetAdditionsAR(sModel, makTab, qList)
  if(not IsHere(makTab)) then return end
  local defTab = makTab:GetDefinition()
  if(not IsHere(defTab)) then LogInstance("Table definition missing") end
  local sMoDB, sFunc, qData = GetOpVar("MODE_DATABASE"), "SetAdditionsAR"
  if(sMoDB == "SQL") then
    local qsKey = GetOpVar("FORM_KEYSTMT")
    local qModel = makTab:Match(tostring(sModel or ""), 1, true)
    local qIndx = qsKey:format(sFunc, "ADDITIONS")
    local Q = makTab:Get(qIndx, qModel); if(not IsHere(Q)) then
      Q = makTab:Select():Where({1,"%s"}):Order(4):Store(qIndx):Get(qIndx, qModel) end
    if(not IsHere(sStmt)) then
      LogInstance("Build statement failed "..GetReport(qIndx,qModel)); return end
    qData = sqlQuery(Q); if(not qData and isbool(qData)) then
      LogInstance("SQL exec error "..GetReport(sqlLastError(), Q)); return end
    if(not IsHere(qData) or IsEmpty(qData)) then
      LogInstance("No data found "..GetReport(Q))
      if(not IsHere(qData)) then qData = {} end
    end
  elseif(sMoDB == "LUA") then
    local iCnt = 0; qData = {}
    local tCache = libCache[defTab.Name]
    local coMo = makTab:GetColumnName(1)
    local coLn = makTab:GetColumnName(4)
    for mod, rec in pairs(tCache) do
      if(mod == sModel) then
        for iD = 1, rec.Size do iCnt = (iCnt + 1)
          qData[iCnt] = {[coMo] = mod}
          for iC = 2, defTab.Size do
            local sN = defTab[iC][1]
            qData[iCnt][sN] = rec[iD][sN]
          end
        end
      end
    end
    local tSort = PrioritySort(qData, coMo, coLn); if(not tSort) then
        LogInstance("Sort cache mismatch"); return end; tableEmpty(qData)
    for iD = 1, tSort.Size do qData[iD] = tSort[iD].Rec end
  else
    LogInstance("Unsupported mode "..GetReport(sMoDB, sModel)); return
  end; local iE = #qList
  if(not IsHere(qData) or IsEmpty(qData)) then return end
  for iD = 1, #qData do qList[iE + iD] = qData[iD] end
end

function ExportPiecesAR(fF,qData,sName,sInd,qList)
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
  if(IsHere(qList) and istable(qList)) then
    if(IsHere(qList[keyBld])) then makAdd = qList[keyBld] else
      makAdd = GetBuilderNick("ADDITIONS"); if(not IsHere(makAdd)) then
        LogInstance("Missing table list builder"); return end
      qList[keyBld] = makAdd; LogInstance("Store list builder")
    end
  end
  if(istable(qData) and IsHere(qData[1])) then
    fF:Write("local "..sName.." = {\n")
    local pkID, sInd, fRow = 1, "  ", true
    local idxID = makTab:GetColumnID("LINEID")
    local coMo = makTab:GetColumnName(1)
    for iD = 1, #qData do
      local qRow = qData[iD]
      local mMod = qRow[coMo]
      local aRow = makTab:GetArrayRow(qRow)
      for iA = 1, #aRow do local vA = aRow[iA]
        aRow[iA] = makTab:Match(vA,iA,true,"\"",true,true); if(not IsHere(aRow[iA])) then
          LogInstance("Matching error "..GetReport(iA,vA,mMod)); return end
        if(vA == dbNull) then aRow[iA] = "gsMissDB" end
      end
      if(fRow) then fRow = false
        fF:Write(sInd:rep(1).."["..aRow[pkID].."] = {\n")
        SetAdditionsAR(mMod, makAdd, qList)
      else
        if(aRow[idxID] == 1) then fF:Seek(fF:Tell() - 2)
          fF:Write("\n"..sInd:rep(1).."},\n"..sInd:rep(1).."["..aRow[pkID].."] = {\n")
          SetAdditionsAR(mMod, makAdd, qList)
        end
      end
      mgrTab.ExportAR(aRow); tableRemove(aRow, 1)
      fF:Write(sInd:rep(2).."{"..tableConcat(aRow, ", ").."},\n")
    end
    fF:Seek(fF:Tell() - 2)
    fF:Write("\n"..sInd:rep(1).."}\n")
    fF:Write("}\n")
  else
    fF:Write("local "..sName.." = {}\n")
  end
end

--[[
 * This function extracts some track type from the database and creates
 * dedicated autorun control script files adding the given type argument
 * to the database by using external plugable DSV prefix list
 * sType > Track type the autorun file is created for
]]
function ExportTypeAR(sType)
  if(SERVER) then return nil end
  if(IsBlank(sType)) then return nil end
  local qPieces, qAdditions
  local sFunc = "ExportTypeAR"
  local sBase = GetOpVar("DIRPATH_BAS")
  local noSQL = GetOpVar("MISS_NOSQL")
  local sTool = GetOpVar("TOOLNAME_NL")
  local sPref = sType:gsub("[^%w]","_")
  local sMoDB = GetOpVar("MODE_DATABASE")
  local sForm = GetOpVar("FORM_FILENAMEAR")
  local sS = sBase..GetOpVar("DIRPATH_SET")
        sS = sS..sForm:format(sTool)
  local sN = sBase..GetOpVar("DIRPATH_EXP")
        sN = sN..sForm:format(sPref)
  local fE = fileOpen(sN, "wb", "DATA"); if(not fE) then
    LogInstance("Generate fail "..GetReport(sN)); return end
  local fS = fileOpen(sS, "rb", "DATA"); if(not fS) then fE:Flush(); fE:Close()
    LogInstance("Source fail "..GetReport(sS)) return end
  local makP = GetBuilderNick("PIECES"); if(not makP) then
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
    local qIndx = qsKey:format(sFunc, "PIECES")
    local Q = makP:Get(qIndx, qType); if(not IsHere(Q)) then
      Q = makP:Select():Where({2,"%s"}):Order(1,4):Store(qIndx):Get(qIndx, qType) end
    if(not Q) then
      LogInstance("Build statement failed "..GetReport(qIndx,qType))
      fE:Flush(); fE:Close(); fS:Close(); return
    end
    qPieces = sqlQuery(Q); if(not qPieces and isbool(qPieces)) then
      LogInstance("SQL exec error "..GetReport(sqlLastError(), Q))
      fE:Flush(); fE:Close(); fS:Close(); return
    end
    if(not IsHere(qData) or IsEmpty(qData)) then
      LogInstance("No data found "..GetReport(Q))
      if(not IsHere(qData)) then qPieces = {} end
    end
  elseif(sMoDB == "LUA") then
    local iCnt = 0; qPieces = {}
    local tCache = libCache[defP.Name]
    local coMo, coTy = makP:GetColumnName(1), makP:GetColumnName(2)
    local coNm, coLn = makP:GetColumnName(3), makP:GetColumnName(4)
    local coP , coO  = makP:GetColumnName(5), makP:GetColumnName(6)
    local coA , coC  = makP:GetColumnName(7), makP:GetColumnName(8)
    local sClass = GetOpVar("ENTITY_DEFCLASS")
    for mod, rec in pairs(tCache) do
      if(rec.Type == sType) then
        local iID, tOffs = 1, rec.Offs -- Start from the first point
        local rPOA = tOffs[iID]; if(not IsHere(rPOA)) then
          LogInstance("Missing point ID "..GetReport(iID, rec.Slot))
          fE:Flush(); fE:Close(); fS:Close(); return
        end
        for iID = 1, rec.Size do
          iCnt = (iCnt + 1); qPieces[iCnt] = {} -- Allocate row memory
          local qRow = qPieces[iCnt]; rPOA = tOffs[iID]
          local sP, sO, sA = rPOA.P:Export(rPOA.O), rPOA.O:Export(), rPOA.A:Export()
          local sC = (IsHere(rec.Unit) and tostring(rec.Unit) or noSQL)
                sC = ((sC == sClass) and noSQL or sC) -- Export default class as noSQL
          qRow[coMo] = rec.Slot
          qRow[coTy] = rec.Type
          qRow[coNm] = rec.Name
          qRow[coLn] = iID
          qRow[coP ] = sP; qRow[coO ] = sO
          qRow[coA ] = sA; qRow[coC ] = sC
        end
      end
    end
    local tSort = PrioritySort(qPieces, coMo, coLn)
    if(not tSort) then
      LogInstance("Sort cache mismatch")
      fE:Flush(); fE:Close(); fS:Close(); return
    end; tableEmpty(qPieces)
    for iD = 1, tSort.Size do qPieces[iD] = tSort[iD].Rec end
  else
    LogInstance("Unsupported mode "..GetReport(sMoDB))
    fE:Flush(); fE:Close(); fS:Close(); return
  end
  if(IsHere(qPieces) and IsHere(qPieces[1])) then
    local patCateg = GetOpVar("PATTEX_CATEGORY")
    local patWorks = GetOpVar("PATTEX_WORKSHID")
    local patPiece = GetOpVar("PATTEX_TABLEDPS")
    local patAddit = GetOpVar("PATTEX_TABLEDAD")
    local patAddon = GetOpVar("PATTEX_VARADDON")
    local keyBuild = GetOpVar("KEYQ_BUILDER"); qPieces[keyBuild] = makP
    local sLine, isEOF, isSkip, sInd, qAdditions = "", false, false, "  ", {}
    while(not isEOF) do
      sLine, isEOF = GetStringFile(fS, true)
      sLine = sLine:gsub("%s*$", "")
      if(sLine:find(patAddon)) then isSkip = true
        fE:Write("local myAddon = \""..sType.."\"\n")
      elseif(sLine:find(patCateg)) then isSkip = true
        local tCat = GetOpVar("TABLE_CATEGORIES")[sType]
        if(istable(tCat) and tCat.Txt) then
          fE:Write("local myCategory = {\n")
          fE:Write(sInd:rep(1).."[myType] = {Txt = [[\n")
          fE:Write(sInd:rep(2)..tCat.Txt:gsub("\n","\n"..sInd:rep(2)).."\n")
          fE:Write(sInd:rep(1).."]]}\n")
          fE:Write("}\n")
        else
          fE:Write("local myCategory = {}\n")
        end
      elseif(sLine:find(patWorks)) then isSkip = true
        local sID = WorkshopID(sType)
        if(sID and sID:len() > 0) then
          fE:Write("asmlib.WorkshopID(myAddon, \""..sID.."\")\n")
        else
          fE:Write("asmlib.WorkshopID(myAddon)\n")
        end
      elseif(sLine:find(patPiece)) then isSkip = true
        ExportPiecesAR(fE, qPieces, "myPieces", sInd, qAdditions)
      elseif(sLine:find(patAddit)) then isSkip = true
        ExportPiecesAR(fE, qAdditions, "myAdditions", sInd)
      else
        if(isSkip and IsBlank(sLine:Trim())) then isSkip = false end
      end
      if(not isSkip) then
        if(isEOF) then fE:Write(sLine) else fE:Write(sLine.."\n") end
      end
    end
    fE:Write("\n"); fE:Flush()
    fE:Close(); fS:Close()
  end
end

----------------------------- SNAPPING ------------------------------

function GetSurfaceAngle(oPly, vNorm)
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
]]
function GetNormalAngle(oPly, soTr, bSnp, nSnp)
  local aAng, nAsn = Angle(), (tonumber(nSnp) or 0); if(not IsPlayer(oPly)) then
    LogInstance("Invalid "..GetReport(oPly)); return aAng end
  if(bSnp) then local stTr = soTr -- Snap to the trace surface
    if(not (stTr and stTr.Hit)) then stTr = GetCacheTrace(oPly)
      if(not (stTr and stTr.Hit)) then return aAng end
    end; aAng:Set(GetSurfaceAngle(oPly, stTr.HitNormal))
  else -- Modify only the roll of the base angle
    local aP, aY, aR = aAng:Unpack() -- Base angle
    local pP, pY, pR = oPly:GetAimVector():Angle():Unpack()
    aAng:SetUnpacked(aP, pY, aR) -- Apply the player yaw
  end
  SnapAngle(aAng, nAsn); GridAngle(aAng, nAsn); return aAng
end

--[[
 * Selects a point ID on the entity based on the hit vector provided
 * oEnt > Entity to search the point on
 * vHit > World space hit vector to find the closest point to
 * bPnt > Use the point local offset ( true ) else origin offset
]]
function GetEntityHitID(oEnt, vHit, bPnt)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Entity invalid "..GetReport(oEnt)); return nil end
  if(not isvector(vHit)) then
    LogInstance("Origin missing "..GetReport(vHit)); return nil end
  local oRec = CacheQueryPiece(oEnt:GetModel()); if(not oRec) then
    LogInstance("Trace skip "..GetReport(oEnt:GetModel())); return nil end
  local ePos, eAng = oEnt:GetPos(), oEnt:GetAngles()
  local oAnc, oID, oMin, oPOA = Vector(), nil, nil, nil
  for ID = 1, oRec.Size do -- Ignore the point disabled flag
    local tPOA, tID = LocatePOA(oRec, ID); if(not IsHere(tPOA)) then
      LogInstance("Point missing "..GetReport(ID)); return nil end
    if(bPnt) then oAnc:SetUnpacked(tPOA.P:Get())
    else oAnc:SetUnpacked(tPOA.O:Get()) end
    oAnc:Rotate(eAng); oAnc:Add(ePos) -- Convert local to world space
    local tMin = oAnc:DistToSqr(vHit) -- Calculate vector absolute ( distance )
    if(oID and oMin and oPOA) then -- Check if current distance is minimum
      if(oMin >= tMin) then oID, oMin, oPOA = tID, tMin, tPOA end
    else -- The shortest distance if the first one checked until others are looped
      oID, oMin, oPOA = tID, tMin, tPOA end
  end; return oID, mathSqrt(oMin), oPOA, oRec
end

function GetNearest(vHit, tVec)
  if(not isvector(vHit)) then
    LogInstance("Origin missing "..GetReport(vHit)); return nil end
  if(not istable(tVec)) then
    LogInstance("Vertices mismatch "..GetReport(tVec)); return nil end
  local vT, iD, mD, mL = Vector(), 1, nil, nil
  while(tVec[iD]) do -- Get current length
    local nT = vHit:DistToSqr(tVec[iD])
    if(mL and mD) then -- Length is allocated
      if(nT <= mL) then mD, mL = iD, nT end
    else mD, mL = iD, nT end; iD = (iD + 1)
  end; return mD, mathSqrt(mL)
end

--[[
 * This function is the backbone of the tool snapping and spawning.
 * Anything related to dealing with the track assembly database
 * Calculates SPos, SAng based on the DB inserts and input parameters
 * ucsPos        > Forced base UCS position when available
 * ucsAng        > Forced base UCS angle when available
 * shdModel      > Tool holder active model as string
 * ivhdPoID      > Requested point ID received from client
 * ucsPos(X,Y,Z) > Offset position additional translation from user
 * ucsAng(P,Y,R) > Offset angle additional rotation from user
 * stData        > When provided defines where to put the spawn data
]]
function GetNormalSpawn(oPly,ucsPos,ucsAng,shdModel,ivhdPoID,
                        ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR,stData)
  local hdRec = CacheQueryPiece(shdModel); if(not IsHere(hdRec)) then
    LogInstance("No record located "..GetReport(shdModel)); return nil end
  local hdPOA, ihdPoID = LocatePOA(hdRec,ivhdPoID); if(not IsHere(hdPOA)) then
    LogInstance("Holder ID missing "..GetReport(ivhdPoID)); return nil end
  local stSpawn = GetCacheSpawn(oPly, stData)
        stSpawn.HID  = ihdPoID
        stSpawn.HRec = hdRec
  if(ucsPos) then stSpawn.BPos:Set(ucsPos) end
  if(ucsAng) then stSpawn.BAng:Set(ucsAng) end
  stSpawn.OPos:Set(stSpawn.BPos); stSpawn.OAng:Set(stSpawn.BAng);
  -- Initialize F, R, U Copy the UCS like that to support database POA
  stSpawn.ANxt:SetUnpacked(tonumber(ucsAngP) or 0,
                           tonumber(ucsAngY) or 0,
                           tonumber(ucsAngR) or 0)
  stSpawn.PNxt:SetUnpacked(tonumber(ucsPosX) or 0,
                           tonumber(ucsPosY) or 0,
                           tonumber(ucsPosZ) or 0)
  -- Integrate additional position offset into the origin position
  if(not (stSpawn.ANxt:IsZero() and stSpawn.PNxt:IsZero())) then
    NegAngle(stSpawn.ANxt, true, true, false)
    local vW, aW = LocalToWorld(stSpawn.PNxt, stSpawn.ANxt, stSpawn.BPos, stSpawn.BAng)
    stSpawn.OPos:Set(vW); stSpawn.OAng:Set(aW);
    stSpawn.F:Set(stSpawn.OAng:Forward())
    stSpawn.R:Set(stSpawn.OAng:Right())
    stSpawn.U:Set(stSpawn.OAng:Up())
  end
  -- Read holder record
  stSpawn.HPnt:SetUnpacked(hdPOA.P:Get())
  stSpawn.HOrg:SetUnpacked(hdPOA.O:Get())
  stSpawn.HAng:SetUnpacked(hdPOA.A:Get())
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
 * trEnt         > Trace.Entity
 * trHitPos      > Trace.HitPos
 * shdModel      > Spawn data will be obtained for this model
 * ivhdPoID      > Active point ID selected via Right click ...
 * nvActRadius   > Minimal radius to get an active point from the client
 * ucsPos(X,Y,Z) > Offset position additional translation from user
 * ucsAng(P,Y,R) > Offset angle additional rotation from user
 * stData        > When provided defines where to put the spawn data
]]
function GetEntitySpawn(oPly,trEnt,trHitPos,shdModel,ivhdPoID,
                        nvActRadius,enFlatten,enIgnTyp,ucsPosX,
                        ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR,stData)
  if(not (trEnt and trHitPos and shdModel and ivhdPoID and nvActRadius)) then
    LogInstance("Parameters mismatch"); return nil end
  if(not trEnt:IsValid()) then
    LogInstance("Trace entity not valid"); return nil end
  if(IsOther(trEnt)) then
    LogInstance("Trace other type"); return nil end
  local nActRadius = tonumber(nvActRadius); if(not IsHere(nActRadius)) then
    LogInstance("Radius mismatch "..GetReport(nvActRadius)); return nil end
  local trID, trRad, trPOA, trRec = GetEntityHitID(trEnt, trHitPos, true)
  if(not (IsHere(trID) and IsHere(trRad) and IsHere(trPOA) and IsHere(trRec))) then
    LogInstance("Active point missed "..GetReport(trEnt:GetModel())); return nil end
  if(not IsHere(LocatePOA(trRec, 1))) then
    LogInstance("Trace has no points"); return nil end
  if(trRad > nActRadius) then
    LogInstance("Trace outside radius"); return nil end
  local hdRec = CacheQueryPiece(shdModel); if(not IsHere(hdRec)) then
    LogInstance("Holder model missing "..GetReport(shdModel)); return nil end
  local hdOffs, ihdPoID = LocatePOA(hdRec,ivhdPoID); if(not IsHere(hdOffs)) then
    LogInstance("Holder point missing "..GetReport(ivhdPoID)); return nil end
  -- If there is no Type exit immediately
  if(not (IsHere(trRec.Type) and isstring(trRec.Type))) then
    LogInstance("Trace type invalid "..GetReport(trRec.Type)); return nil end
  if(not (IsHere(hdRec.Type) and isstring(hdRec.Type))) then
    LogInstance("Holder type invalid "..GetReport(hdRec.Type)); return nil end
  -- If the types are different and disabled
  if((not enIgnTyp) and (trRec.Type ~= hdRec.Type)) then
    LogInstance("Types different "..GetReport(trRec.Type, hdRec.Type)); return nil end
  local stSpawn = GetCacheSpawn(oPly, stData) -- We have the next Piece Offset
        stSpawn.TRec, stSpawn.RLen = trRec, trRad
        stSpawn.HID , stSpawn.TID  = ihdPoID, trID
        stSpawn.TOrg:Set(trEnt:GetPos())
        stSpawn.TAng:Set(trEnt:GetAngles())
        stSpawn.TPnt:SetUnpacked(trPOA.P:Get())
        stSpawn.TPnt:Rotate(stSpawn.TAng)
        stSpawn.TPnt:Add(stSpawn.TOrg)
  -- Found the active point ID on trEnt. Initialize origins
  stSpawn.BPos:SetUnpacked(trPOA.O:Get()) -- Read origin
  stSpawn.BAng:SetUnpacked(trPOA.A:Get()) -- Read angle
  stSpawn.BPos:Rotate(stSpawn.TAng); stSpawn.BPos:Add(stSpawn.TOrg)
  stSpawn.BAng:Set(trEnt:LocalToWorldAngles(stSpawn.BAng))
  -- Do the flatten flag right now Its important !
  if(enFlatten) then -- Take care of the track flat placing
    local nP, nY, nR = stSpawn.BAng:Unpack()
    nP, nR = 0, 0; stSpawn.BAng:SetUnpacked(nP, nY, nR)
  end -- Base position and angle are ready and calculated
  return GetNormalSpawn(oPly,nil,nil,shdModel,ihdPoID,ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR,stData)
end

--[[
 * This function performs a trace relative to the entity point chosen
 * trEnt  > Entity chosen for the trace
 * ivPoID > Point ID selected for its model
 * nLen   > Length of the trace
]]
function GetTraceEntityPoint(trEnt, ivPoID, nLen)
  if(not (trEnt and trEnt:IsValid())) then
    LogInstance("Trace entity invalid"); return nil end
  local nLen = (tonumber(nLen) or 0); if(nLen <= 0) then
    LogInstance("Distance skipped"); return nil end
  local trRec = CacheQueryPiece(trEnt:GetModel())
  if(not trRec) then LogInstance("Trace not piece"); return nil end
  local trPOA = LocatePOA(trRec, ivPoID); if(not IsHere(trPOA)) then
    LogInstance("Point missing "..GetReport(ivPoID)); return nil end
  local trDt, trAng = GetOpVar("TRACE_DATA"), Angle()
  trDt.start:SetUnpacked(trPOA.O:Get())
  trDt.start:Rotate(trEnt:GetAngles())
  trDt.start:Add(trEnt:GetPos())
  trAng:SetUnpacked(trPOA.A:Get())
  trAng:Set(trEnt:LocalToWorldAngles(trAng))
  trDt.endpos:Set(trAng:Forward()); trDt.endpos:Mul(nLen)
  trDt.endpos:Add(trDt.start); SetOpVar("TRACE_FILTER", trEnt)
  return utilTraceLine(trDt), trDt
end

--[[
 * Projects a point over a defined ray
 * vO > Ray origin location
 * vD > Ray direction vector
 * vP > Position vector to be projected
]]
function ProjectRay(vO, vD, vP)
  local vN = vD:GetNormalized()
  local vX = Vector(vP); vX:Sub(vO)
  local nD = vX:Dot(vN); vX:Set(vN)
  vX:Mul(nD); vX:Add(vO);
  return nD, vN, vX
end

--[[
 * This function calculates 3x3 determinant of the arguments below
 * Takes three row vectors as arguments:
 *   vR1 = {a b c}
 *   vR2 = {d e f}
 *   vR3 = {g h i}
 * Returns a number: The 3x3 determinant value
]]
function DeterminantVector(vR1, vR2, vR3)
  local a, b, c = vR1:Unpack()
  local d, e, f = vR2:Unpack()
  local g, h, i = vR3:Unpack()
  local r = ((a*e*i) + (b*f*g) + (d*h*c))
  local s = ((g*e*c) + (h*f*a) + (d*b*i))
  return (r - s) -- Return 3x3 determinant
end

--[[
 * This function traces both lines and if they are not parallel
 * calculates their point of intersection. Every ray is
 * determined by an origin /vO/ and direction /vD/
 * On success returns the length and point of the closest
 * intersect distance to the orthogonal connecting line.
 * The true center is calculated by using the last two return values
 * Takes:
 *   vO1 > Position origin of the first ray
 *   vD1 > Direction of the first ray
 *   vO2 > Position origin of the second ray
 *   vD2 > Direction of the second ray
 * Returns:
 *   f1  > Intersection fraction of the first ray
 *   f2  > Intersection fraction of the second ray
 *   x1  > Pillar intersection projection for first ray
 *   x2  > Pillar intersection projection for second ray
 *   xx  > Actual calculated pillar intersection point
]]
function IntersectRay(vO1, vD1, vO2, vD2)
  if(vD1:LengthSqr() == 0) then
    LogInstance("First ray undefined"); return nil end
  if(vD2:LengthSqr() == 0) then
    LogInstance("Second ray undefined"); return nil end
  local ez = GetOpVar("EPSILON_ZERO")
  local d1, d2 = vD1:GetNormalized(), vD2:GetNormalized()
  local dx, oo = d1:Cross(d2), (vO2 - vO1)
  local dn = dx:LengthSqr(); if(dn < ez) then
    LogInstance("Rays parallel"); return nil end
  local f1 = DeterminantVector(oo, d2, dx) / dn
  local f2 = DeterminantVector(oo, d1, dx) / dn
  local x1 = Vector(d1); x1:Mul(f1); x1:Add(vO1)
  local x2 = Vector(d2); x2:Mul(f2); x2:Add(vO2)
  local xx = (x2 - x1); xx:Mul(0.5); xx:Add(x1)
  return f1, f2, x1, x2, xx
end

function IntersectRayParallel(vO1, vD1, vO2, vD2)
  if(vD1:LengthSqr() == 0) then
    LogInstance("First ray undefined"); return nil end
  if(vD2:LengthSqr() == 0) then
    LogInstance("Second ray undefined"); return nil end
  local dn = vO2:Distance(vO1)
  local d1 = vD1:GetNormalized()
  local d2 = vD2:GetNormalized()
  local f1, f2 = (dn / 2), (dn / 2)
  local x1 = Vector(d1); x1:Mul(f1); x1:Add(vO1)
  local x2 = Vector(d2); x2:Mul(f2); x2:Add(vO2)
  local xx = (x2 - x1); xx:Mul(0.5); xx:Add(x1)
  return f1, f2, x1, x2, xx
end

-- Attempts taking the mean vector for intersecting straight tracks
function IntersectRayPair(vO1, vD1, vO2, vD2)
  local f1, f2, x1, x2, xx = IntersectRay(vO1, vD1, vO2, vD2)
  if(not xx) then LogInstance("Try intersect parallel")
    f1, f2, x1, x2, xx = IntersectRayParallel(vO1, vD1, vO2, vD2)
  end; return f1, f2, x1, x2, xx
end

function IntersectRayUpdate(stRay)
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
 * oPly  > Player who wants to register a ray
 * oEnt  > The trace entity to register the raw with
 * trHit > The world position to search for point ID
 * sKey  > String identifier. Used to distinguish rays form one another
]]
function IntersectRayCreate(oPly, oEnt, vHit, sKey)
  if(not IsPlayer(oPly)) then
    LogInstance("Player invalid "..GetReport(oPly)); return nil end
  if(not isvector(vHit)) then
    LogInstance("Origin missing "..GetReport(vHit)); return nil end
  if(not isstring(sKey)) then
    LogInstance("Key invalid "..GetReport(sKey)); return nil end
  local trID, trMin, trPOA, trRec = GetEntityHitID(oEnt, vHit); if(not trID) then
    LogInstance("Entity no hit "..GetReport(oEnt, vHit)); return nil end
  local stSpot, iKey = GetPlayerSpot(oPly), "INTERSECT"; if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end -- Retrieve general player spot
  local tRay = stSpot[iKey]; if(not tRay) then stSpot[iKey] = {}; tRay = stSpot[iKey] end
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
  end
  stRay.Dir:SetUnpacked(trPOA.A:Get())
  stRay.Org:SetUnpacked(trPOA.O:Get())
  return IntersectRayUpdate(stRay)
end

function IntersectRayRead(oPly, sKey)
  if(not IsPlayer(oPly)) then
    LogInstance("Player mismatch "..GetReport(oPly)); return nil end
  if(not isstring(sKey)) then
    LogInstance("Key mismatch "..GetReport(sKey)); return nil end
  local stSpot, iKey = GetPlayerSpot(oPly), "INTERSECT"; if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end -- Retrieve general player spot
  local tRay = stSpot[iKey]; if(not tRay) then
    LogInstance("No ray "..GetReport(oPly:Nick())); return nil end
  local stRay = tRay[sKey]; if(not stRay) then
    LogInstance("No key "..GetReport(sKey)); return nil end
  return IntersectRayUpdate(stRay) -- Obtain personal ray from the cache
end

function IntersectRayClear(oPly, sKey)
  if(not IsPlayer(oPly)) then
    LogInstance("Player mismatch "..GetReport(oPly)); return false end
  local stSpot, iKey = GetPlayerSpot(oPly), "INTERSECT"; if(not IsHere(stSpot)) then
    LogInstance("Spot missing"); return nil end -- Retrieve general player spot
  local tRay = stSpot[iKey]; if(not tRay) then LogInstance("Clean"); return true end
  if(not IsHere(sKey)) then stSpot[iKey] = nil else tRay[sKey] = nil end
  LogInstance("Clear "..GetReport(sKey, oPly:Nick())); return true
end

--[[
 * This function intersects two already cached rays
 * Used for generating
 * sKey1 > First ray identifier
 * sKey2 > Second ray identifier
]]
function IntersectRayHash(oPly, sKey1, sKey2)
  local stRay1 = IntersectRayRead(oPly, sKey1); if(not stRay1) then
    LogInstance("Miss read "..GetReport(sKey1)); return nil end
  local stRay2 = IntersectRayRead(oPly, sKey2); if(not stRay2) then
    LogInstance("Miss read "..GetReport(sKey2)); return nil end
  local vO1, vD1 = stRay1.Orw, stRay1.Diw:Forward()
  local vO2, vD2 = stRay2.Orw, stRay2.Diw:Forward()
  -- Attempt taking the mean vector for parallel ray straight tracks
  local f1, f2, x1, x2, xx = IntersectRayPair(vO1, vD1, vO2, vD2)
  return xx, x1, x2, stRay1, stRay2
end

--[[
 * This function finds the intersection for the model itself
 * as a local vector so it can be placed precisely in the
 * intersection point when creating
 * sModel > The model to calculate intersection point for
 * nPntID > Start (chosen) point of the intersection
 * nNxtID > End (next) point of the intersection
]]
function IntersectRayModel(sModel, nPntID, nNxtID)
  local mRec = CacheQueryPiece(sModel); if(not mRec) then
    LogInstance("Not piece "..GetReport(sModel)); return nil end
  local stPOA1 = LocatePOA(mRec, nPntID); if(not stPOA1) then
    LogInstance("Start ID missing "..GetReport(nPntID)); return nil end
  local stPOA2 = LocatePOA(mRec, nNxtID); if(not stPOA2) then
    LogInstance("End ID missing "..GetReport(nNxtID)); return nil end
  local aD1, aD2 = Angle(), Angle()
  aD1:SetUnpacked(stPOA1.A:Get()); aD2:SetUnpacked(stPOA2.A:Get())
  local vO1, vD1 = Vector(), aD1:Forward()
  vO1:SetUnpacked(stPOA1.O:Get()); vD1:Mul(-1)
  local vO2, vD2 = Vector(), aD2:Forward()
  vO2:SetUnpacked(stPOA2.O:Get()); vD2:Mul(-1)
  local f1, f2, x1, x2, xx = IntersectRay(vO1,vD1,vO2,vD2)
  if(not xx) then -- Mean vector when the rays are parallel for straight tracks
    f1, f2, x1, x2, xx = IntersectRayParallel(vO1,vD1,vO2,vD2) end
  return xx, vO1, vO2, aD1, aD2
end

function AttachAdditions(ePiece)
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Piece invalid"); return false end
  local eAng, ePos, sMoc = ePiece:GetAngles(), ePiece:GetPos(), ePiece:GetModel()
  local stData = CacheQueryAdditions(sMoc); if(not IsHere(stData)) then
    LogInstance("Model skip "..GetReport(sMoc)); return true end
  local makTab = GetBuilderNick("ADDITIONS"); if(not IsHere(makTab)) then
    LogInstance("Missing table definition"); return nil end
  local sEoa = GetOpVar("OPSYM_ENTPOSANG"); LogInstance("PIECE:MODEL("..sMoc..")")
  local coMB, coMA = makTab:GetColumnName(1), makTab:GetColumnName(2)
  local coEN, coLI = makTab:GetColumnName(3), makTab:GetColumnName(4)
  local coPO, coAN = makTab:GetColumnName(5), makTab:GetColumnName(6)
  local coMO, coPI = makTab:GetColumnName(7), makTab:GetColumnName(8)
  local coDR, coPM = makTab:GetColumnName(9), makTab:GetColumnName(10)
  local coPS, coSE = makTab:GetColumnName(11), makTab:GetColumnName(12)
  for iCnt = 1, stData.Size do -- While additions are present keep adding them
    local arRec = stData[iCnt]; LogInstance("PIECE:ADDITION("..iCnt..")")
    local dCass, oPOA = GetOpVar("ENTITY_DEFCLASS"), NewPOA()
    local sCass = GetEmpty(arRec[coEN], nil, dCass)
    local eBonus = entsCreate(sCass); LogInstance("ents.Create("..sCass..")")
    if(eBonus and eBonus:IsValid()) then
      local sMoa = tostring(arRec[coMA]); if(not IsModel(sMoa, true)) then
        LogInstance("Invalid attachment "..GetReport(iCnt, sMoc, sMoa)); return false end
      eBonus:SetModel(sMoa) LogInstance("ENT:SetModel("..sMoa..")")
      local sPos = arRec[coPO]; if(not isstring(sPos)) then
        LogInstance("Position mismatch "..GetReport(iCnt, sMoc, sPos)); return false end
      if(not GetEmpty(sPos)) then oPOA:Decode(sPos, eBonus, "Pos")
        local vPos = oPOA:Vector(); vPos:Set(ePiece:LocalToWorld(vPos))
        eBonus:SetPos(vPos); LogInstance("ENT:SetPos(DB)")
      else eBonus:SetPos(ePos); LogInstance("ENT:SetPos(PIECE:POS)") end
      local sAng = arRec[coAN]; if(not isstring(sAng)) then
        LogInstance("Angle mismatch "..GetReport(iCnt, sMoc, sAng)); return false end
      if(not GetEmpty(sAng)) then oPOA:Decode(sAng, eBonus, "Ang")
        local aAng = oPOA:Angle(); aAng:Set(ePiece:LocalToWorldAngles(aAng))
        eBonus:SetAngles(aAng); LogInstance("ENT:SetAngles(DB)")
      else eBonus:SetAngles(eAng); LogInstance("ENT:SetAngles(PIECE:ANG)") end
      local nMo = (tonumber(arRec[coMO]) or -1)
      if(nMo >= 0) then eBonus:SetMoveType(nMo)
        LogInstance("ENT:SetMoveType("..nMo..")") end
      local nPh = (tonumber(arRec[coPI]) or -1)
      if(nPh >= 0) then eBonus:PhysicsInit(nPh)
        LogInstance("ENT:PhysicsInit("..nPh..")") end
      local nSh = (tonumber(arRec[coDR]) or 0)
      if(nSh ~= 0) then nSh = (nSh > 0); eBonus:DrawShadow(nSh)
        LogInstance("ENT:DrawShadow("..tostring(nSh)..")") end
      eBonus:SetParent(ePiece); LogInstance("ENT:SetParent(PIECE)")
      eBonus:Spawn(); LogInstance("ENT:Spawn()")
      pPonus = eBonus:GetPhysicsObject()
      if(pPonus and pPonus:IsValid()) then
        local bEm = (tonumber(arRec[coPM]) or 0)
        if(bEm ~= 0) then bEm = (bEm > 0); pPonus:EnableMotion(bEm)
          LogInstance("ENT:EnableMotion("..tostring(bEm)..")") end
        local nZe = (tonumber(arRec[coPS]) or 0)
        if(nZe > 0) then pPonus:Sleep(); LogInstance("ENT:Sleep()") end
      end
      eBonus:Activate(); LogInstance("ENT:Activate()")
      ePiece:DeleteOnRemove(eBonus); LogInstance("PIECE:DeleteOnRemove(ENT)")
      local nSo = (tonumber(arRec[coSE]) or -1)
      if(nSo >= 0) then eBonus:SetSolid(nSo)
        LogInstance("ENT:SetSolid("..tostring(nSo)..")") end
    else
      local mA, mC = arRec[coMA], arRec[coEN]
      LogInstance("Entity invalid "..GetReport(iCnt, sMoc, mA, mC)); return false
    end
  end; LogInstance("Success"); return true
end

function GetEntityOrTrace(oEnt)
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

--[[
 * Reads a bodygroup code from a given entity
 * oEnt > The entity to read to code from
]]
function GetPropBodyGroup(oEnt)
  local bgEnt = GetEntityOrTrace(oEnt); if(not IsHere(bgEnt)) then
    LogInstance("Failed to gather entity"); return "" end
  if(IsOther(bgEnt)) then
    LogInstance("Entity other type"); return "" end
  local tBG = bgEnt:GetBodyGroups(); if(not (tBG and tBG[1])) then
    LogInstance("Bodygroup table empty"); return "" end
  local sRez, iCnt, symSep = "", 1, GetOpVar("OPSYM_SEPARATOR")
  while(tBG[iCnt]) do local iD = tBG[iCnt].id -- Read ID
    local sD = bgEnt:GetBodygroup(iD) -- Read value by ID
    sRez = sRez..symSep..tostring(sD or 0) -- Attach
    LogInstance("GetBodygroup "..GetReport(iCnt, iD, sD))
    iCnt = iCnt + 1 -- Prepare to take the next value
  end; sRez = sRez:sub(2, -1) -- Remove last separator
  LogInstance("Success "..GetReport(sRez)); return sRez
end

--[[
 * Attach bodygroup code to a given entity
 * oEnt > The entity to attach the code for
]]
function AttachBodyGroups(ePiece,sBgID)
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Base entity invalid"); return false end
  local sBgID = tostring(sBgID or "")
  local iCnt, tBG = 1, ePiece:GetBodyGroups()
  local IDs = GetOpVar("OPSYM_SEPARATOR"):Explode(sBgID)
  while(tBG[iCnt] and IDs[iCnt]) do local vBG = tBG[iCnt]
    local maxID = (ePiece:GetBodygroupCount(vBG.id) - 1)
    local curID = mathClamp(mathFloor(tonumber(IDs[iCnt]) or 0), 0, maxID)
    LogInstance("SetBodygroup "..GetReport(iCnt, vBG.id, maxID, curID))
    ePiece:SetBodygroup(vBG.id, curID); iCnt = iCnt + 1
  end; LogInstance("Success "..GetReport(sBgID)); return true
end

function SetPosBound(ePiece,vPos,oPly,sMode)
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Entity invalid"); return false end
  if(not IsPlayer(oPly)) then
    LogInstance("Player invalid "..GetReport(oPly)); return false end
  local sMode = tostring(sMode or "LOG") -- Error mode is "LOG" by default
  local vPos  = Vector(vPos or GetOpVar("VEC_ZERO"))
  if(sMode == "OFF") then ePiece:SetPos(vPos)
    LogInstance("("..sMode..") Skip"); return true end
  if(utilIsInWorld(vPos)) then ePiece:SetPos(vPos) else ePiece:Remove()
    if(sMode == "HINT" or sMode == "GENERIC" or sMode == "ERROR") then
      Notify(oPly,"Position out of map bounds!", sMode) end
    LogInstance("("..sMode..") Position out of map bounds "..GetReport(oPly, vPos)); return false
  end; LogInstance("("..sMode..") Success"); return true
end

--[[
 * Checks whenever the spawned piece is inside the previous spawn margin
]]
function InSpawnMargin(oPly,oRec,vPos,aAng)
  if(CLIENT) then return true end
  local nMarg = GetOpVar("SPAWN_MARGIN")
  if(nMarg == 0) then return false end
  if(vPos and aAng) then
    if(oRec.Mpos and oRec.Mray) then
      local cMarg = mathAbs(nMarg)
      local nBpos = oRec.Mpos:Distance(vPos) -- Distance
      if(nBpos <= cMarg) then -- Check the margin area
        if(nMarg < 0) then -- When negative check position only
          local sM = ("Spawn pos ["..nBpos.."]["..nMarg.."]")
          Notify(oPly, sM, "ERROR"); LogInstance(sM); return true
        else -- Otherwise check the spawn direction ray for being the same
          local nBray = oRec.Mray:Dot(aAng:Forward())
          local nMray = (1 - (cMarg * GetOpVar("EPSILON_ZERO")))
          if(nBray >= nMray) then -- Positive checks position and direction
            local sM = ("Spawn ray ["..nBpos.."]["..nMarg.."]["..nBray.."]["..nMray.."]")
            Notify(oPly, sM, "ERROR"); LogInstance(sM); return true
          end -- Piece angles will not align when spawned
        end -- Negative checks position
      end; oRec.Mpos:Set(vPos); oRec.Mray:Set(aAng:Forward())
      return false  -- Piece will be spawned outside of spawn margin
    else -- Otherwise create memory entry and sore the piece location
      oRec.Mpos, oRec.Mray = Vector(vPos), aAng:Forward()
      return false -- Store the last location the piece was spawned
    end -- Otherwise wipe the current memoty when not provided
  else oRec.Mpos, oRec.Mray = nil, nil end; return false
end

function NewPiece(pPly,sModel,vPos,aAng,nMass,sBgSkIDs,clColor,sMode)
  if(CLIENT) then LogInstance("Working on client"); return nil end
  if(not IsPlayer(pPly)) then -- If not player we cannot register limit
    LogInstance("Player missing "..GetReport(pPly)); return nil end
  local sLimit  = GetOpVar("CVAR_LIMITNAME")
  if(not pPly:CheckLimit(sLimit)) then -- Check internal limit
    LogInstance("Track limit reached"); return nil end
  if(not pPly:CheckLimit("props")) then -- Check the props limit
    LogInstance("Prop limit reached"); return nil end
  if(not IsModel(sModel, true)) then
    LogInstance("Model invalid"); return nil end
  local stData = CacheQueryPiece(sModel) if(not IsHere(stData)) then
    LogInstance("Record missing for "..GetReport(sModel)); return nil end
  local aAng = Angle(aAng or GetOpVar("ANG_ZERO"))
  if(InSpawnMargin(pPly, stData, vPos, aAng)) then
    LogInstance("Spawn margin stop "..GetReport(sModel)); return nil end
  local sClass = GetEmpty(stData.Unit, nil, GetOpVar("ENTITY_DEFCLASS"))
  local ePiece = entsCreate(sClass); if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Piece invalid "..GetReport(sClass, sModel)); return nil end
  ePiece:SetCollisionGroup(COLLISION_GROUP_NONE)
  ePiece:SetSolid(SOLID_VPHYSICS)
  ePiece:SetMoveType(MOVETYPE_VPHYSICS)
  ePiece:SetNotSolid(false)
  ePiece:SetModel(sModel)
  if(not SetPosBound(ePiece,vPos,pPly,sMode)) then
    LogInstance("Misplaced "..GetReport(pPly:Nick(), sModel)); return nil end
  ePiece:SetAngles(aAng)
  ePiece:SetCreator(pPly) -- Who spawned the sandbox track
  ePiece:Spawn()
  ePiece:Activate()
  ePiece:SetRenderMode(RENDERMODE_TRANSALPHA)
  ePiece:SetColor(clColor or GetColor(255,255,255,255))
  ePiece:DrawShadow(false)
  ePiece:PhysWake()
  local pPiece = ePiece:GetPhysicsObject()
  if(not (pPiece and pPiece:IsValid())) then ePiece:Remove()
    LogInstance("Entity phys object invalid"); return nil end
  ePiece.owner, ePiece.Owner = pPly, pPly -- Some PPs actually use this value
  pPiece:EnableMotion(false) -- Spawn frozen by default to reduce lag
  local nMass = mathMax(0, (tonumber(nMass) or 0))
  if(nMass > 0) then pPiece:SetMass(nMass) end -- Mass equal zero use model mass
  local tBgSk = GetOpVar("OPSYM_DIRECTORY"):Explode(sBgSkIDs or "")
  ePiece:SetSkin(mathClamp(tonumber(tBgSk[2]) or 0, 0, ePiece:SkinCount()-1))
  if(not AttachBodyGroups(ePiece, tBgSk[1])) then ePiece:Remove()
    LogInstance("Failed attaching bodygroups"); return nil end
  if(not AttachAdditions(ePiece)) then ePiece:Remove()
    LogInstance("Failed attaching additions"); return nil end
  pPly:AddCount(sLimit , ePiece); pPly:AddCleanup(sLimit , ePiece) -- This sets the ownership
  pPly:AddCount("props", ePiece); pPly:AddCleanup("props", ePiece) -- Deleted with clearing props
  LogInstance(GetReport(ePiece, sModel)); return ePiece
end

function UnpackPhysicalSettings(ePiece)
  if(CLIENT) then LogInstance("Working on client"); return true end
  if(not (ePiece and ePiece:IsValid())) then   -- Cannot manipulate invalid entities
    LogInstance("Piece entity invalid "..GetReport(ePiece)); return false end
  local pPiece = ePiece:GetPhysicsObject()    -- Get the physics object
  if(not (pPiece and pPiece:IsValid())) then -- Cannot manipulate invalid physics
    LogInstance("Piece physical object invalid "..GetReport(ePiece)); return false end
  local bPi, bFr = ePiece.PhysgunDisabled, (not pPiece:IsMotionEnabled())
  local bGr, sPh = pPiece:IsGravityEnabled(), pPiece:GetMaterial()
  return true, bPi, bFr, bGr, sPh -- Returns status and settings
end

function ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
  if(CLIENT) then LogInstance("Working on client"); return true end
  local bPi, bFr = (tobool(bPi) or false), (tobool(bFr) or false)
  local bGr, sPh = (tobool(bGr) or false),  tostring(sPh or "")
  LogInstance(GetReport(ePiece,bPi,bFr,bGr,sPh))
  if(not (ePiece and ePiece:IsValid())) then   -- Cannot manipulate invalid entities
    LogInstance("Piece entity invalid "..GetReport(ePiece)); return false end
  local pPiece = ePiece:GetPhysicsObject()    -- Get the physics object
  if(not (pPiece and pPiece:IsValid())) then -- Cannot manipulate invalid physics
    LogInstance("Piece physical object invalid "..GetReport(ePiece)); return false end
  local sToolPrefL = GetOpVar("TOOLNAME_PL") -- Use the general tool prefix for networking
  local arSettings = {bPi,bFr,bGr,sPh}  -- Initialize dupe settings using this array
  ePiece.PhysgunDisabled = bPi          -- If enabled stop the player from grabbing the track piece
  ePiece:SetNWBool(sToolPrefL.."physgundisabled", bPi) -- Disable drawing physgun grab and move
  ePiece:SetUnFreezable(bPi)            -- If enabled stop the player from hitting reload to mess it all up
  ePiece:SetMoveType(MOVETYPE_VPHYSICS) -- Moves and behaves like a normal prop
  -- Delay the freeze by a tiny amount because on physgun snap the piece
  -- is unfrozen automatically after physgun drop hook call
  timerSimple(GetOpVar("DELAY_ACTION"), function() -- If frozen motion is disabled
    LogInstance("Freeze "..GetReport(ePiece,bPi,bFr,bGr,sPh), "*DELAY_ACTION");  -- Make sure that the physics are valid
    if(pPiece and pPiece:IsValid()) then pPiece:EnableMotion(not bFr) end end )
  constructSetPhysProp(nil,ePiece,0,pPiece,{GravityToggle = bGr, Material = sPh})
  duplicatorStoreEntityModifier(ePiece,sToolPrefL.."dupe_phys_set",arSettings)
  LogInstance("Success"); return true
end

--[[
 * Creates anchor constraints between the piece and the base prop
 * ePiece > The piece entity to be attached
 * eBase  > Base entity the piece is attached to
 * bWe    > Weld constraint flag ( Weld )
 * bNc    > NoCollide constraint flag ( NoCollide )
 * bNw    > NoCollideWorld constraint flag ( AdvBallsocket )
 * nFm    > Force limit of the constraint created. Defaults to never break
]]
function ApplyPhysicalAnchor(ePiece,eBase,bWe,bNc,bNw,nFm)
  if(CLIENT) then LogInstance("Working on client"); return true end
  local bWe, bNc = (tobool(bWe) or false), (tobool(bNc) or false)
  local nFm, bNw = (tonumber(nFm)  or  0), (tobool(bNw) or false)
  LogInstance(GetReport(ePiece,eBase,bWe,bNc,bNw,nFm))
  local sPr, cnW, cnN, cnG = GetOpVar("TOOLNAME_PL") -- Create local references for constraints
  if(not (ePiece and ePiece:IsValid())) then
    LogInstance("Piece invalid "..GetReport(ePiece)); return false, cnW, cnN, cnG  end
  if(constraintCanConstrain(ePiece, 0)) then -- Check piece for constraints
    -- Weld on pieces between each other
    if(bWe) then -- Weld using force limit given here
      if(eBase and (eBase:IsValid() or eBase:IsWorld())) then
        if(constraintCanConstrain(eBase, 0)) then
          cnW = constraintWeld(ePiece, eBase, 0, 0, nFm, false, false)
          if(cnW and cnW:IsValid()) then
            cnW:SetNWBool(sPr.."physanchor", true)
            ePiece:DeleteOnRemove(cnW); eBase:DeleteOnRemove(cnW)
          else LogInstance("Weld ignored "..GetReport(cnW)) end
        else LogInstance("Weld base unconstrained "..GetReport(eBase)) end
      else LogInstance("Weld base invalid "..GetReport(eBase)) end
    end
    -- NoCollide on pieces between each other made separately
    if(bNc) then -- NoCollide is separate from weld constraints
      if(eBase and (eBase:IsValid() or eBase:IsWorld())) then
        if(constraintCanConstrain(eBase, 0)) then
          cnN = constraintNoCollide(ePiece, eBase, 0, 0)
          if(cnN and cnN:IsValid()) then
            cnN:SetNWBool(sPr.."physanchor", true)
            ePiece:DeleteOnRemove(cnN); eBase:DeleteOnRemove(cnN)
          else LogInstance("NoCollide ignored "..GetReport(cnN)) end
        else LogInstance("NoCollide base unconstrained "..GetReport(eBase)) end
      else LogInstance("NoCollide base invalid "..GetReport(eBase)) end
    end
    -- NoCollide between piece and world
    if(bNw) then local eWorld = gameGetWorld()
      if(eWorld and eWorld:IsWorld()) then
        if(constraintCanConstrain(eWorld, 0)) then
          local nA, vO = 180, Vector(GetOpVar("VEC_ZERO"))
          cnG = constraintAdvBallsocket(ePiece, eWorld,
            0, 0, vO, vO, nFm, 0, -nA, -nA, -nA, nA, nA, nA, 0, 0, 0, 1, 1)
          if(cnG and cnG:IsValid()) then ePiece:DeleteOnRemove(cnG)
            cnG:SetNWBool(sPr.."physanchor", true)
          else LogInstance("AdvBallsocket ignored "..GetReport(cnG)) end
        else LogInstance("AdvBallsocket base unconstrained "..GetReport(eWorld)) end
      else LogInstance("AdvBallsocket base invalid "..GetReport(eWorld)) end
    end
  else LogInstance("Unconstrained "..GetReport(ePiece:GetModel())) end
  LogInstance("Success"); return true, cnW, cnN, cnG
end

function GetConstraintInfo(tC, iD)
  local iD = mathFloor(tonumber(iD) or 0)
  if(IsHere(tC) and istable(tC) and iD > 0) then
    local eO, tO, iO = tC["Ent"..iD]
    if(IsOther(eO)) then tO = tC["Entity"]
      if(istable(tO) and tO[iD]) then tO = tO[iD]
        if(istable(tO)) then -- Try ENTS info
          eO, iO = tO["Entity"], tO["Index"]
          eO = (IsOther(eO) and EntityID(iO) or eO)
        else LogInstance("Missing table "..GetReport(iD, 2)) end
      else LogInstance("Missing table "..GetReport(iD, 1)) end
    end
    -- When still empty extract from constraint
    if(IsOther(eO)) then
      if(tC.Constraint:IsConstraint()) then
        local E1, E2 = vC.Constraint:GetConstrainedEntities()
        local tE = {E1, E2}; eO = tE[iD]
        LogInstance("Obtained from "..GetReport(iD, tC.Type))
         -- Extract first constrained entity
      else LogInstance("Not constraint "..GetReport(tC.Constraint)) end
    end; return eO -- Return the entity fount for the constraint
  else LogInstance("Primary data missing "..GetReport(tC.Constraint)) end
end

function GetRecordOver(oEnt, tI, vD)
  if(not (oEnt and oEnt:IsValid())) then return nil end
  local tS, iD = {}, tonumber(vD)
  tS.Ovr, tS.Ent = false, oEnt
  tS.ID  = oEnt:EntIndex()
  tS.Key = oEnt:GetModel()
  if(istable(tI)) then
    tI[(iD or tS.ID)] = tS
  end
  return tS -- Return the created item
end

function SetRecordOver(tD, tS)
  tD.Ovr, tD.ID, tD.Ent = true, tS.ID, tS.Ent
end

function GetConstraintsEnt(oEnt)
  if(not (oEnt and oEnt:IsValid())) then return nil end
  local tO = {}; tO.Link = {}
        tO.Base = GetRecordOver(oEnt)
  local tC, nC = constraintGetTable(oEnt), 0
  for iD = 1, #tC do local vC = tC[iD]
    local eOne = GetConstraintInfo(vC, 1)
    local eTwo = GetConstraintInfo(vC, 2)
    -- Mark entity IDs for flip over constraint pairs
    if(IsOther(eOne)) then LogInstance("One invalid "..GetReport(eOne)) else
      if(IsOther(eTwo)) then LogInstance("Two invalid "..GetReport(eTwo)) else
        if(eOne ~= oEnt) then GetRecordOver(eOne, tO.Link) end
        if(eTwo ~= oEnt) then GetRecordOver(eTwo, tO.Link) end
      end
    end
  end; return tO
end

--[[
 * Creates a table list of entities constrained to every entity in the list
 * tE > The entity/ID array to build the constrained entities list for
]]
function GetConstraintOver(tE)
  local sK = GetOpVar("KEY_FLIPOVER"); if(not istable(tE)) then
    LogInstance("Missing "..GetReport(tE)); return nil end
  local tC, nC, nF = {[sK] = {}}, 0, 1
  while(tE[nF]) do local vID, eID = tE[nF]
    if(isnumber(vID)) then eID = EntityID(vID) else
      if(vID and vID:IsValid()) then eID = vID
      else LogInstance("Mismatch "..GetReport(vID)) end
    end -- Pass entity list or entity index list
    if(not IsOther(eID)) then nC = (nC + 1)
      tC[nC] = GetConstraintsEnt(eID)
    else LogInstance("Other "..GetReport(eID)) end
    nF, eID = (nF + 1), nil
  end; tC.Size = nC; return tC, nC
end

--[[
 * Registers constraint information for flip over mode
 * tC   > The general constrain information table
 * vK   > Key ( entity ID ) to store the flipped entity for
 * oEnt > The entity to be stored
]]
function RegConstraintOver(tC, vK, oEnt)
  if(not (oEnt and oEnt:IsValid())) then
    LogInstance("Invalid "..GetReport(oEnt)); return tC end
  local sK = GetOpVar("KEY_FLIPOVER"); if(not istable(tC)) then
    LogInstance("Mismatch "..GetReport(tC)); return tC end
  local iK = (tonumber(vK) or 0); if(iK <= 0) then
    LogInstance("Mismatch ID "..GetReport(vK)); return tC end
  local tO = tC[sK]; if(not istable(tO)) then
    LogInstance("Missing "..GetReport(sK, tO)); return tC end
  GetRecordOver(oEnt, tO, iK); return tC, tO
end
--[[
 * Processes the table of constrained entities information
 * tC > The table containing the constraint information
 * nC > Forced size for the entities array
]]
function SetConstraintOver(tC, nE)
  local sK = GetOpVar("KEY_FLIPOVER"); if(not istable(tC)) then
    LogInstance("Missing "..GetReport(tC)); return nil end
  local nC = (tonumber(nE or tC.Size) or 0); if(nC <= 0) then
    LogInstance("Nothing "..GetReport(nE)); return nil end
  local tO = tC[sK]; if(IsEmpty(tO)) then
    LogInstance("Empty "..GetReport(tO)); return tC, nC end
  for key, val in pairs(tO) do
    local oE, iD = val.Ent, val.ID
    if(IsOther(oE)) then tO[key] = nil
      LogInstance("Wipe hash "..GetReport(key))
    end
    if(oE:EntIndex() ~= iD) then tO[key] = nil
      LogInstance("Wipe hash ID "..GetReport(key))
    end
  end -- Flip over items are now entities
  for iD = 1, nC do
    local vC = tC[iD]
    local tB, tL = vC.Base, vC.Link
    if(IsHere(tO[tB.ID])) then
      SetRecordOver(tB, tO[tB.ID])
    end -- Replace the linked entities
    if(IsOther(tB.Ent)) then tC[iD] = nil
      LogInstance("Wipe link "..GetReport(iD))
    else
      for key, val in pairs(tL) do
        local vO = tO[key]
        if(IsHere(vO)) then
          if(vO.Key == val.Key) then
            SetRecordOver(val, vO)
          else
            LogInstance("Wipe model sors: "..GetReport(vO.ID ,  vO.Key))
            LogInstance("Wipe model dest: "..GetReport(val.ID, val.Key))
            tL[key] = nil -- Wipe the link information
          end
        end
        if(IsOther(val.Ent)) then
          LogInstance("Wipe entity: "..GetReport(val.ID, val.Key))
          tL[key] = nil -- Wipe the link information
        end
      end
    end
  end; return tC, nC
end

function NewAsmConvar(sName, vVal, tBord, vFlg, vInf)
  if(not isstring(sName)) then
    LogInstance("Mismatch "..GetReport(sName)); return nil end
  local sKey, cVal = GetNameExp(sName), (tonumber(vVal) or tostring(vVal))
  local sInf, nFlg, vMin, vMax = tostring(vInf or ""), mathFloor(tonumber(vFlg) or 0), 0, 0
  if(IsHere(tBord)) then -- Read the minimum and maximum from convar border provided
    vMin, vMax = tBord[1], tBord[2]; SetBorder(sKey, vMin, vMax) -- Update border
  else vMin, vMax = GetBorder(sKey) end -- Border not provided read it from borders
  LogInstance("Create "..GetReport(sKey, cVal, vMin, vMax))
  return CreateConVar(sKey, cVal, nFlg, sInf, vMin, vMax)
end

function GetAsmConvar(sName, sMode)
  if(not isstring(sName)) then
    LogInstance("Name mismatch "..GetReport(sName)); return nil end
  if(not isstring(sMode)) then
    LogInstance("Mode mismatch "..GetReport(sMode)); return nil end
  local sKey = GetNameExp(sName)
  local CVar = GetConVar(sKey); if(not IsHere(CVar)) then
    LogInstance("Missing "..GetReport(sKey, sMode)); return nil end
  if    (sMode == "INT") then return (tonumber(BorderValue(CVar:GetInt()   , sKey)) or 0)
  elseif(sMode == "FLT") then return (tonumber(BorderValue(CVar:GetFloat() , sKey)) or 0)
  elseif(sMode == "STR") then return (tostring(BorderValue(CVar:GetString(), sKey)) or "")
  elseif(sMode == "OBJ") then return CVar
  elseif(sMode == "MIN") then return CVar:GetMin()
  elseif(sMode == "MAX") then return CVar:GetMax()
  elseif(sMode == "NAM") then return CVar:GetName()
  elseif(sMode == "BUL") then return CVar:GetBool()
  elseif(sMode == "DEF") then return CVar:GetDefault()
  elseif(sMode == "INF") then return CVar:GetHelpText()
  end; LogInstance("("..sName..", "..sMode..") Missed mode"); return nil
end

function SetAsmConvar(pPly, sName, snVal)
  if(not isstring(sName)) then -- Make it like so the space will not be forgotten
    LogInstance("Name mismatch "..GetReport(sName)); return nil end
  local sFmt, sPrf = GetOpVar("FORM_CONCMD"), GetOpVar("TOOLNAME_PL")
  local sKey = GetNameExp(sName); if(IsPlayer(pPly)) then -- Use the player when available
    return pPly:ConCommand(sFmt:format(sKey, "\""..tostring(snVal or "")).."\"\n")
  end; return RunConsoleCommand(sKey, tostring(snVal or ""))
end

--[[
 * Checks if the ghosts stack contains items
 * Ghosting is client side only
 * Could you do it for a Scooby snacks?
]]
function HasGhosts()
  if(SERVER) then return false end
  local tGho = GetOpVar("ARRAY_GHOST")
  if(not IsHere(tGho)) then return false end
  local eGho, nSiz = tGho[1], tGho.Size
  return (eGho and eGho:IsValid() and nSiz and nSiz > 0)
end

--[[
 * Fades the ghosts stack and makes the elements invisible
 * bNoD > The state of the No-Draw flag
 * nMrF > Fade margin in range [0-1]
 * Wait a minute, ghosts can't leave fingerprints!
]]
function FadeGhosts(bNoD, nMrF)
  if(SERVER) then return true end
  if(not HasGhosts()) then return true end
  local nMar = mathClamp((tonumber(nMrF) or 0), 0, 1)
  local tGho = GetOpVar("ARRAY_GHOST")
  if(not IsHere(tGho)) then return true end
  local cPal = GetContainer("COLORS_LIST")
  local sMis, sMo = GetOpVar("MISS_NOMD"), tGho.Slot
  for iD = 1, tGho.Size do local eGho = tGho[iD]
    if(eGho and eGho:IsValid()) then
      if(nMrF) then eGho.marginRender = nMar end
      eGho:SetNoDraw(bNoD); eGho:DrawShadow(false)
      eGho:SetColor(cPal:Select("gh"))
      if(sMo and sMo ~= sMis and sMo ~= eGho:GetModel()) then
        eGho:SetModel(tGho.Slot) end
    end
  end; return true
end

--[[
 * Clears the ghosts stack and deletes all the items
 * vSiz > The custom stack size. Nil makes it take the `tGho.Size`
 * bCol > When enabled calls the garbage collector
 * Well gang, I guess that wraps up the mystery.
]]
function ClearGhosts(vSiz, vStr, bCol)
  if(SERVER) then return true end
  local tGho = GetOpVar("ARRAY_GHOST")
  if(not IsHere(tGho)) then return true end
  if(tGho.Size == 0) then return true end
  local iStr = mathFloor(tonumber(vStr) or 1)
  local iSiz = mathCeil(tonumber(vSiz) or tGho.Size)
  local nDer = GetOpVar("DELAY_REMOVE")
  for iD = iStr, iSiz do local eGho = tGho[iD]
    SafeRemoveEntityDelayed(eGho, nDer)
  end; tGho.Size, tGho.Slot = 0, GetOpVar("MISS_NOMD")
  if(bCol) then collectgarbage() end; return true
end

--[[
 * Helper function to handle models that do not support
 * color alpha channel have draw override. This is run
 * for all the ghosted props to draw all of them correctly
 * There is a very logical explanation for all this.
]]
function BlendGhost(self)
  local mar = self.marginRender
  local cur = renderGetBlend()
  renderSetBlend(mar)
  self:DrawModel()
  renderSetBlend(cur)
end

--[[
 * Creates a single ghost entity for populating the stack
 * sModel > The model which the creation is requested for
 * vPos   > Position for the entity, otherwise zero is used
 * aAng   > Angles for the entity, otherwise zero is used
 * It must have been our imagination.
]]
function NewEntityGhost(sModel, vPos, aAng)
  if(not IsModel(sModel)) then return nil end
  local cPal = GetContainer("COLORS_LIST")
  local eGho = entsCreateClientProp(sModel)
  if(not (eGho and eGho:IsValid())) then eGho = nil
    LogInstance("Ghost invalid "..sModel); return nil end
  local vPos = Vector(vPos or GetOpVar("VEC_ZERO"))
  local aAng =  Angle(aAng or GetOpVar("ANG_ZERO"))
  eGho.marginRender = 1
  eGho.DoNotDuplicate = true -- Disable duping
  eGho.RenderOverride = BlendGhost
  eGho:SetModel(sModel)
  eGho:SetPos(vPos)
  eGho:SetAngles(aAng)
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
function NewGhosts(nCnt, sModel) -- Only he's not a shadow, he's a green ghost!
  if(SERVER) then return true end -- Leave it to Daphne to pick the wrong door!
  local tGho = GetOpVar("ARRAY_GHOST") -- Let's split up and look for clues!
  if(not IsHere(tGho)) then return true end -- Not available then nothing to do
  if(nCnt == 0 and tGho.Size == 0) then return true end -- Skip processing
  if(nCnt == 0 and tGho.Size ~= 0) then return ClearGhosts() end -- Disabled
  FadeGhosts(true); ClearGhosts(nil, nCnt + 1) -- Trim the current ghost stack
  for iD = 1, nCnt do local eGho = tGho[iD] -- Let's set a trap!
    if(eGho and eGho:IsValid()) then eGho:SetNoDraw(true)
      if(eGho:GetModel() ~= sModel) then eGho:SetModel(sModel) end
    else -- Great, but next time, please don't do me any favors.
      tGho[iD] = NewEntityGhost(sModel); eGho = tGho[iD]
      if(not (eGho and eGho:IsValid())) then ClearGhosts(nCnt)
        LogInstance("Invalid "..GetReport(iD, sModel)); return false end
    end -- Fade all the ghosts and refresh these that must be drawn
  end; tGho.Size, tGho.Slot = nCnt, sModel; return true
end

--[[
 * Retrieves hook information player and swep
 * sW > Swep class when different than the current tool is needed
 * Returns player the swep object and the tool object when available
]]
function GetHookInfo(sW)
  if(SERVER) then return nil end
  local sDe = GetOpVar("TOOL_DEFMODE")
  local sWe = tostring(sW or sDe)
  local oPly = LocalPlayer(); if(not IsPlayer(oPly)) then
    LogInstance("Player invalid"); return nil end
  local acSw = oPly:GetActiveWeapon(); if(not IsValid(acSw)) then
    LogInstance("Swep invalid"); return nil end
  if(acSw:GetClass() ~= sWe) then
    LogInstance("Swep other "..GetReport(sWe)); return nil end
  if(sWe ~= sDe) then return oPly, acSw end
  if(acSw:GetMode() ~= GetOpVar("TOOLNAME_NL")) then
    LogInstance("Tool different"); return nil end
  -- Here player is holding the track assembly tool
  local acTo = acSw:GetToolObject(); if(not acTo) then
    LogInstance("Tool invalid"); return nil end
  return oPly, acSw, acTo
end

--[[
 * Creates a linear set of numbers with borders and given amount
 * nBeg > The number to start from ( BEGIN )
 * nEnd > The number to end with ( END )
 * nAmt > Amount of middle points to be generated
 * Returns table with the numbers
]]
function GetLinearSpace(nBeg, nEnd, nAmt)
  local fAmt = mathFloor(tonumber(nAmt) or 0); if(fAmt < 0) then
    LogInstance("Samples count invalid "..GetReport(fAmt)); return nil end
  local iAmt, dAmt = (fAmt + 1), (nEnd - nBeg)
  local fBeg, fEnd, nAdd = 1, (fAmt+2), (dAmt / iAmt)
  local tO = {[fBeg] = nBeg, [fEnd] = nEnd}
  while(fBeg <= fEnd) do fBeg, fEnd = (fBeg + 1), (fEnd - 1)
    tO[fBeg], tO[fEnd] = (tO[fBeg-1] + nAdd), (tO[fEnd+1] - nAdd)
  end return tO
end

--[[
 * Calculates Catmull-Rom curve tangent
 * cS > The start vector ( BEGIN )
 * cE > The end vector ( END )
 * nT > Amount of points to be calculated
 * nA > Parametric constant curve factor [0 ; 1]
 * Returns the value of the tangent
]]
function GetCatmullRomCurveTangent(cS, cE, nT, nA)
  local nL, nM = cE:Distance(cS), GetOpVar("EPSILON_ZERO")
  return ((((nL == 0) and nM or nL) ^ (tonumber(nA) or 0.5)) + nT)
end

--[[
 * Calculates Catmull-Rom curve segment on four points
 * https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline
 * vPN > The given anchor point N ( KNOTS )
 * nN  > Amount of points to be calculated
 * nA  > Parametric constant curve factor [0 ; 1]
 * Returns a table containing the generated sequence
]]
function GetCatmullRomCurveSegment(vP0, vP1, vP2, vP3, nN, nA)
  if(not isvector(vP0)) then
    LogInstance("Mismatch[0] "..GetReport(vP0)); return nil end
  if(not isvector(vP1)) then
    LogInstance("Mismatch[1] "..GetReport(vP1)); return nil end
  if(not isvector(vP2)) then
    LogInstance("Mismatch[2] "..GetReport(vP2)); return nil end
  if(not isvector(vP3)) then
    LogInstance("Mismatch[3] "..GetReport(vP3)); return nil end
  local nT0, tS = 0, {} -- Start point is always zero
  local nT1 = GetCatmullRomCurveTangent(vP0, vP1, nT0, nA)
  local nT2 = GetCatmullRomCurveTangent(vP1, vP2, nT1, nA)
  local nT3 = GetCatmullRomCurveTangent(vP2, vP3, nT2, nA)
  local tTN = GetLinearSpace(nT1, nT2, nN)
  local vB1, vB2 = Vector(), Vector()
  local vA1, vA2, vA3 = Vector(), Vector(), Vector()
  for iD = 1, #tTN do tS[iD] = Vector(); local nTn, vTn = tTN[iD], tS[iD]
    vA1:Set(vP0); vA1:Mul((nT1-nTn)/(nT1-nT0)); vA1:Add(vP1 * ((nTn-nT0)/(nT1-nT0)))
    vA2:Set(vP1); vA2:Mul((nT2-nTn)/(nT2-nT1)); vA2:Add(vP2 * ((nTn-nT1)/(nT2-nT1)))
    vA3:Set(vP2); vA3:Mul((nT3-nTn)/(nT3-nT2)); vA3:Add(vP3 * ((nTn-nT2)/(nT3-nT2)))
    vB1:Set(vA1); vB1:Mul((nT2-nTn)/(nT2-nT0)); vB1:Add(vA2 * ((nTn-nT0)/(nT2-nT0)))
    vB2:Set(vA2); vB2:Mul((nT3-nTn)/(nT3-nT1)); vB2:Add(vA3 * ((nTn-nT1)/(nT3-nT1)))
    vTn:Set(vB1); vTn:Mul((nT2-nTn)/(nT2-nT1)); vTn:Add(vB2 * ((nTn-nT1)/(nT2-nT1)))
  end; return tS
end

--[[
 * Calculates a full Catmull-Rom curve when there are no repeating points
 * https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline
 * tV > A table containing the curve control points ( KNOTS )
 * nT > Amount of points to be calculated between the control points
 * nA > Parametric constant curve factor [0 ; 1]
 * Returns a table containing the generated curve including the control points
]]
function GetCatmullRomCurve(tV, nT, nA, tO)
  if(not istable(tV)) then LogInstance("Vertices mismatch "..GetReport(tV)); return nil end
  if(IsEmpty(tV)) then LogInstance("Vertices missing "..GetReport(tV)); return nil end
  if(not (tV[1] and tV[2])) then LogInstance("Two vertices needed"); return nil end
  if(nA and not isnumber(nA)) then LogInstance("Factor mismatch "..GetReport(nA)); return nil end
  if(nA < 0 or nA > 1) then LogInstance("Factor invalid "..GetReport(nA)); return nil end
  local nT, nV = mathFloor(tonumber(nT) or 200), #tV; if(nT < 0) then
    LogInstance("Samples mismatch "..GetReport(nT)); return nil end
  local vM, iC, cS, cE, tN = GetOpVar("CURVE_MARGIN"), 1, Vector(), Vector(), (tO or {})
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

--[[
 * Calculates a full Catmull-Rom curve when there are repeating points present
 * https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline
 * tV > A table containing the curve control points ( KNOTS )
 * nT > Amount of points to be calculated between the control points
 * nA > Parametric constant curve factor [0 ; 1]
 * Returns a table containing the generated curve including the control points
]]
function GetCatmullRomCurveDupe(tV, nT, nA, tO)
  if(not istable(tV)) then LogInstance("Vertices mismatch "..GetReport(tV)); return nil end
  if(IsEmpty(tV)) then LogInstance("Vertices missing "..GetReport(tV)); return nil end
  if(not (tV[1] and tV[2])) then LogInstance("Two vertices are needed"); return nil end
  if(nA and not isnumber(nA)) then LogInstance("Factor mismatch "..GetReport(nA)); return nil end
  if(nA < 0 or nA > 1) then LogInstance("Factor invalid "..GetReport(nA)); return nil end
  local nT, nV = mathFloor(tonumber(nT) or 200), #tV; if(nT < 0) then
    LogInstance("Samples mismatch "..GetReport(nT)); return nil end
  local nM, nN = GetOpVar("EPSILON_ZERO"), 1
  local tN, tF = {tV[1], ID = {{true, 1}}}, (tO or {})
  for iD = 2, nV do
    if(tV[iD]:DistToSqr(tN[nN]) > nM) then
      tableInsert(tN, tV[iD])
      tN.ID[iD], nN = {true, nN}, (nN + 1)
    else tN.ID[iD] = {false} end
  end
  if(nN > 1) then
    local tC = GetCatmullRomCurve(tN, nT, nA)
    for iD = 1, (nV - 1) do local iC = iD + 1
      tableInsert(tF, Vector(tV[iD]))
      if(not tN.ID[iC][1]) then
        for iK = 1, nT do tableInsert(tF, Vector(tV[iD])) end
      else
        local iP = (tN.ID[iC][2] - 1) * (nT + 1)
        for iK = 1, nT do local iI = (iP + iK + 1)
          tableInsert(tF, Vector(tC[iI])) end
      end
    end; tableInsert(tF, Vector(tV[nV]))
  else
    for iD = 1, (nV - 1) do
      tableInsert(tF, Vector(tV[1]))
      for iK = 1, nT do tableInsert(tF, Vector(tV[1])) end
    end; tableInsert(tF, Vector(tV[1]))
  end
  return tF
end

--[[
 * Intersects a line with a sphere
 * vS > Line start point vector
 * vE > Line end point vector
 * vC > Sphere center vector
 * nR > Sphere radius number
 * Returns the vector position of intersection
]]
function IntersectLineSphere(vS, vE, vC, nR)
  local nE = GetOpVar("EPSILON_ZERO")
  local vD = Vector(vE); vD:Sub(vS)
  local nA = vD:LengthSqr(); if(nA < nE) then
    LogInstance("Norm less than margin"); return nil end
  local vR = Vector(vS) vR:Sub(vC)
  local nB, nC = 2 * vD:Dot(vR), (vR:LengthSqr() - nR^2)
  local nD = (nB^2 - 4*nA*nC); if(nD < 0) then
    LogInstance("Imaginary roots"); return nil end
  local dA = (1/(2*nA)); nD, nB = dA*mathSqrt(nD), -nB*dA
  local xP = Vector(vD); xP:Mul(nB + nD); xP:Add(vS)
  local xM = Vector(vD); xM:Mul(nB - nD); xM:Add(vS)
  return xP, xM -- Return the intersected +/- root point
end

--[[
 * Checks if a point exists on a given line
 * vO > The point position vector
 * vS > Line start point vector
 * vE > Line end point vector
 * Returns boolean if the condition is present
]]
function IsAmongLine(vO, vS, vE)
  local nE = GetOpVar("EPSILON_ZERO")
  local oS = Vector(vO); oS:Sub(vS)
  local oE = Vector(vO); oE:Sub(vE)
  local oR = Vector(vE); oR:Sub(vE)
  local nC = oS:Cross(oR):LengthSqr()
  if(nC > nE) then return false end
  local dS, dE = oS:Dot(oR), oE:Dot(oR)
  if(dS * dE > 0) then return false end
  return true
end

--[[
 * Populates one track location in the snapping stack
 * and prepares the coordinate location to be moved
 * iD  > The current snap ID being populated
 * vvS > Start location vector
 * vnS > Start normal vector
 * vvE > End location vector
 * vnE > End normal vector
 * vO  > Search sphere location vector
 * nD  > Search sphere radius
]]
function UpdateCurveNormUCS(oPly, vvS, vnS, vvE, vnE, vO, nD)
  if(not isvector(vvS)) then
    LogInstance("Start mismatch "..GetReport(vvS)); return nil end
  if(not isvector(vnS)) then
    LogInstance("End mismatch "..GetReport(vnS)); return nil end
  if(not isvector(vvE)) then
    LogInstance("Start mismatch "..GetReport(vvE)); return nil end
  if(not isvector(vnE)) then
    LogInstance("End mismatch "..GetReport(vnE)); return nil end
  if(not isvector(vO)) then
    LogInstance("End mismatch "..GetReport(vO)); return nil end
  local tC = GetCacheCurve(oPly); if(not tC) then
    LogInstance("Curve missing"); return nil end
  local nR, tU = vvE:Distance(vvS), tC.Info.UCS
  local vP, vN = tU[1], tU[2] -- Index origin UCS
  local xP, xM = IntersectLineSphere(vvS, vvE, vO, nD)
  local bOn = IsAmongLine(xP, vvS, vvE)
  local xXX = (bOn and xP or xM) -- The nearest point has more weight
  local nF1 = xXX:Distance(vvS) -- Start point fraction
  local nF2 = xXX:Distance(vvE) -- End point fraction
  local vF1 = Vector(vnS); vF1:Mul(1 - (nF1 / nR))
  local vF2 = Vector(vnE); vF2:Mul(1 - (nF2 / nR))
  local xNN = Vector(vF1); xNN:Add(vF2); xNN:Normalize()
  local vF, vU = (xXX - vP), (vN + xNN) -- Spawn angle as FU
  local tS, tO = tC.Snap[tC.SSize], {Vector(vP), vF:AngleEx(vU)}
  tS.Size, tC.SKept = (tS.Size + 1), (tC.SKept + 1) -- Update snap and nodes
  tS[tS.Size] = tO; vP:Set(xXX); vN:Set(xNN) -- Update the new origin point
  return tS, vvE:Distance(vP) -- Return remaining length
end

--[[
 * Populates one node stack entry with segment snaps
 * oPly > Player to do the calculation for
 * iD   > Stack entry ID ( also the node segment ID )
 * nD   > The desired track interpolation length
]]
function UpdateCurveSnap(oPly, iD, nD)
  local tC = GetCacheCurve(oPly); if(not tC) then
    LogInstance("Curve missing"); return nil end
  local iD = (tonumber(iD) or 0); if(iD <= 0) then
    LogInstance("Index mismatch "..GetReport(iD)); return nil end
  if(mathFloor(iD) ~= mathCeil(iD)) then
    LogInstance("Index fraction "..GetReport(iD)); return nil end
  local vP0, vN0 = tC.Info.UCS[1], tC.Info.UCS[2]
  local vP1, vN1 = tC.CNode[iD + 0], tC.CNorm[iD + 0]
  local vP2, vN2 = tC.CNode[iD + 1], tC.CNorm[iD + 1]
  local nS, nE = vP0:Distance(vP1), vP0:Distance(vP2)
  if(nS <= nD and nE >= nD) then
    tC.SSize = (tC.SSize + 1)  tC.Snap[tC.SSize] = {Size = 0, ID = tC.SSize};
    local tO, nL = UpdateCurveNormUCS(oPly, vP1, vN1, vP2, vN2, vP0, nD)
    while(nL > nD) do -- First segment track is snapped but end is not reached
      tO, nL = UpdateCurveNormUCS(oPly, vP0, vN0, vP2, vN2, vP0, nD) end
    return tO, nL, tC.SSize -- Return the populated segment and the rest of the length
  end; return nil
end

--[[
 * Calculates the curving factor for given curve sample
 * oPly > Player to do the calculation for
 * tS   > The snap list for the current iteration
 * iD   > Snap origin information ID
 * Returns the turn and lean curving factors
 * nF   > Turn factor. The smaller the value turns more
 * nU   > Lean factor. The smaller the value leans more
]]
function GetTurningFactor(oPly, tS, iD)
  local tC = GetCacheCurve(oPly); if(not tC) then
    LogInstance("Curve missing"); return nil end
  if(not istable(tS)) then
    LogInstance("Snap mismatch "..GetReport(tS)); return nil end
  local iD = (tonumber(iD) or 0); if(iD <= 0) then
    LogInstance("Index mismatch "..GetReport(iD)); return nil end
  if(mathFloor(iD) ~= mathCeil(iD)) then
    LogInstance("Index fraction "..GetReport(iD)); return nil end
  local tV = tS[iD]; if(not istable(tV)) then
    LogInstance("Snap mismatch "..GetReport(tV)); return nil end
  local tP = tS[iD - 1]; if(not IsHere(tP)) then
    tP = tC.Snap[tS.ID - 1]; tP = (tP and tP[tP.Size] or nil)
  end -- When a previous entry is not located return nothing
  if(not IsHere(tP)) then -- Previous entry being validated
    LogInstance("Prev mismatch "..GetReport(tP)); return nil end
  local nF = tV[2]:Forward():Dot(tP[2]:Forward())
  local nU = tV[2]:Up():Dot(tP[2]:Up())
  return nF, nU
end

--[[
 * Fills up the the general curve space for the given player
 * https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline
 * oPly > Player to fill the calculation for
 * nSmp > Amount of samples between each node
 * nFac > Parametric constant curve factor [0;1]
]]
function CalculateRomCurve(oPly, nSmp, nFac)
  local tC = GetCacheCurve(oPly); if(not tC) then
    LogInstance("Curve missing"); return nil end
  tableEmpty(tC.Snap) -- The size of all snaps
  tC.SSize, tC.SKept = 0, 0 -- Amount of snapped points
  tableEmpty(tC.CNode) -- Reset the curve and snapping
  tableEmpty(tC.CNorm); tC.CSize = 0 -- And normals
  GetCatmullRomCurveDupe(tC.Node, nSmp, nFac, tC.CNode)
  GetCatmullRomCurveDupe(tC.Norm, nSmp, nFac, tC.CNorm)
  tC.Info.UCS[1]:Set(tC.CNode[1]) -- Put the first node in the UCS
  tC.Info.UCS[2]:Set(tC.CNorm[1]) -- Put the first normal in the UCS
  tC.CSize = (tC.Size - 1) * nSmp + tC.Size -- Get stack depth
  return tC -- Return the updated curve information reference
end

--[[
 * Recursive helper function for Bezier curve vertices
 * https://en.wikipedia.org/wiki/B%C3%A9zier_curve
 * cT > Current sample direction multiplier
 * tV > A table of position vector vertices
 * Returns the calculated recursive control sample
]]
function GetBezierCurveVertex(cT, tV)
  local tD, tP, nD = {}, {}, (#tV - 1)
  for iD = 1, nD do
    tD[iD] = Vector(tV[iD+1])
    tD[iD]:Sub(tV[iD])
    tD[iD]:Mul(cT)
  end
  for iD = 1, nD do
    tP[iD] = Vector(tV[iD])
    tP[iD]:Add(tD[iD])
  end
  if(nD > 1) then
    return GetBezierCurveVertex(cT, tP) end
  return tP[1]
end

--[[
 * Bezier curve calculator
 * https://en.wikipedia.org/wiki/B%C3%A9zier_curve
 * tV > Array of Bezier control nodes
 * nT > Amount of samples between both ends
 * tO > When provided it is filled with the curve
 * Returns the table array of the calculated curve
]]
function GetBezierCurve(tV, nT, tO)
  if(not istable(tV)) then LogInstance("Vertices mismatch "..GetReport(tV)); return nil end
  if(IsEmpty(tV)) then LogInstance("Vertices missing "..GetReport(tV)); return nil end
  if(not (tV[1] and tV[2])) then LogInstance("Two vertices needed"); return nil end
  local nT, nV = (mathFloor(tonumber(nT) or 200) + 1), #tV; if(nT < 0) then
    LogInstance("Samples mismatch "..GetReport(nT)); return nil end
  local iD, cT, dT, tB = 1, 0, (1 / nT), (tO or {})
  tB[iD], cT, iD = Vector(tV[iD]), (cT + dT), (iD + 1)
  while(cT < 1) do -- Recursively populate all the node segments
    tB[iD] = GetBezierCurveVertex(cT, tV) -- Recursive calculation
    cT, iD = (cT + dT), (iD + 1) -- Prepare for next segment
  end; tB[iD] = Vector(tV[nV]) -- Bezier must include both ends
  return tB -- Return the calculated curve table array
end

--[[
 * Fills up the the general curve space for the given player
 * https://en.wikipedia.org/wiki/B%C3%A9zier_curve
 * oPly > Player to fill the calculation for
 * nSmp > Amount of samples between each node
]]
function CalculateBezierCurve(oPly, nSmp)
  local tC = GetCacheCurve(oPly)
  if(not tC) then LogInstance("Curve missing"); return nil end
  local nC = #tC.Node; if(nC <= 0) then
    LogInstance("Nodes missing"); return nil end
  local iSmp = mathFloor((nC - 1) * nSmp)
  if(not tC) then LogInstance("Curve missing"); return nil end
  tableEmpty(tC.Snap) -- The size of all snaps
  tC.SSize, tC.SKept = 0, 0 -- Amount of snapped points
  tableEmpty(tC.CNode) -- Reset the curve and snapping
  tableEmpty(tC.CNorm); tC.CSize = 0 -- And normals
  GetBezierCurve(tC.Node, iSmp, tC.CNode)
  GetBezierCurve(tC.Norm, iSmp, tC.CNorm)
  tC.Info.UCS[1]:Set(tC.CNode[1]) -- Put the first node in the UCS
  tC.Info.UCS[2]:Set(tC.CNorm[1]) -- Put the first normal in the UCS
  tC.CSize = iSmp + 2 -- Get stack depth total samples including ends
  return tC -- Return the updated curve information reference
end

function GetToolInformation()
  local cWM = GetContainer("WORK_MODE")
  local nWM = (cWM and cWM:GetSize() or 0); if(nWM <= 0) then
    LogInstance("Mismatch "..GetReport(nWM)); return nil end
  local tD, tO = GetOpVar("TABLE_TOOLINF"), {}
  local tH, iO = GetOpVar("TABLE_IHEADER"), 0
  local snAV = GetOpVar("MISS_NOAV")
  for iD = 1, #tD do local vD = tD[iD]
    for iW = 1, nWM do
      iO = iO + 1; tO[iO] = tableCopy(tH)
      for k, v in pairs(vD) do tO[iO][k] = v end
      tO[iO].op   = iW -- Transfer mandatory values
      tO[iO].name = tO[iO].name.."."..tostring(iW)
      if(vD.name == "workmode") then
        local sW = tostring(cWM:Select(iW) or snAV):lower()
        tO[iO].icon = ToIcon("workmode_"..sW)
      end
    end
  end; return tO
end
