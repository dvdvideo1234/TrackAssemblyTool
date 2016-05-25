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
local SOLID_VPHYSICS        = SOLID_VPHYSICS
local MOVETYPE_VPHYSICS     = MOVETYPE_VPHYSICS
local COLLISION_GROUP_NONE  = COLLISION_GROUP_NONE
local RENDERMODE_TRANSALPHA = RENDERMODE_TRANSALPHA

---------------- Localizing needed functions ----------------
local next                  = next
local type                  = type
local Angle                 = Angle
local Color                 = Color
local pairs                 = pairs
local print                 = print
local tobool                = tobool
local Vector                = Vector
local include               = include
local IsValid               = IsValid
local require               = require
local Time                  = SysTime
local tonumber              = tonumber
local tostring              = tostring
local GetConVar             = GetConVar
local LocalPlayer           = LocalPlayer
local CreateConVar          = CreateConVar
local getmetatable          = getmetatable
local setmetatable          = setmetatable
local collectgarbage        = collectgarbage
local osClock               = os and os.clock
local osDate                = os and os.date
local sqlQuery              = sql and sql.Query
local sqlLastError          = sql and sql.LastError
local sqlTableExists        = sql and sql.TableExists
local utilTraceLine         = util and util.TraceLine
local utilIsInWorld         = util and util.IsInWorld
local utilIsValidModel      = util and util.IsValidModel
local utilGetPlayerTrace    = util and util.GetPlayerTrace
local entsCreate            = ents and ents.Create
local fileOpen              = file and file.Open
local fileExists            = file and file.Exists
local fileAppend            = file and file.Append
local fileDelete            = file and file.Delete
local fileCreateDir         = file and file.CreateDir
local mathPi                = math and math.pi
local mathAbs               = math and math.abs
local mathSin               = math and math.sin
local mathCos               = math and math.cos
local mathCeil              = math and math.ceil
local mathModf              = math and math.modf
local mathSqrt              = math and math.sqrt
local mathFloor             = math and math.floor
local mathClamp             = math and math.Clamp
local mathRandom            = math and math.random
local undoCreate            = undo and undo.Create
local undoFinish            = undo and undo.Finish
local undoAddEntity         = undo and undo.AddEntity
local undoSetPlayer         = undo and undo.SetPlayer
local undoSetCustomUndoText = undo and undo.SetCustomUndoText
local timerStop             = timer and timer.Stop
local timerStart            = timer and timer.Start
local timerExists           = timer and timer.Exists
local timerCreate           = timer and timer.Create
local timerDestroy          = timer and timer.Destroy
local tableEmpty            = table and table.Empty
local tableMaxn             = table and table.maxn
local stringLen             = string and string.len
local stringSub             = string and string.sub
local stringFind            = string and string.find
local stringGsub            = string and string.gsub
local stringUpper           = string and string.upper
local stringLower           = string and string.lower
local stringFormat          = string and string.format
local stringExplode         = string and string.Explode
local stringImplode         = string and string.Implode
local stringToFileName      = string and string.GetFileFromFilename
local surfaceSetFont        = surface and surface.SetFont
local surfaceDrawLine       = surface and surface.DrawLine
local surfaceDrawText       = surface and surface.DrawText
local surfaceDrawCircle     = surface and surface.DrawCircle
local surfaceSetTexture     = surface and surface.SetTexture
local surfaceSetTextPos     = surface and surface.SetTextPos
local surfaceGetTextSize    = surface and surface.GetTextSize
local surfaceGetTextureID   = surface and surface.GetTextureID
local surfaceSetDrawColor   = surface and surface.SetDrawColor
local surfaceSetTextColor   = surface and surface.SetTextColor
local constructSetPhysProp  = construct and construct.SetPhysProp
local constraintWeld        = constraint and constraint.Weld
local constraintNoCollide   = constraint and constraint.NoCollide
local surfaceDrawTexturedRect = surface and surface.DrawTexturedRect
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier

---------------- CASHES SPACE --------------------

local libCache  = {} -- Used to cache stuff in a Pool
local libAction = {} -- Used to attach external function to the lib
local libOpVars = {} -- Used to Store operational Variable Values

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

local function IsEmptyString(anyValue)
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

------------------ LOGS ------------------------

local function FormatNumberMax(nNum,nMax)
  local nNum = tonumber(nNum)
  local nMax = tonumber(nMax)
  if(not (nNum and nMax)) then return "" end
  return stringFormat("%"..stringLen(tostring(mathFloor(nMax))).."d",nNum)
end

function SetLogControl(nLines,sFile)
  SetOpVar("LOG_CURLOGS",0)
  SetOpVar("LOG_LOGFILE",tostring(sFile or ""))
  SetOpVar("LOG_MAXLOGS",mathFloor(tonumber(nLines) or 0))
  if(not fileExists(GetOpVar("DIRPATH_BAS"),"DATA") and
     not IsEmptyString(GetOpVar("LOG_LOGFILE"))) then
    fileCreateDir(GetOpVar("DIRPATH_BAS"))
  end
end

local function Log(anyStuff)
  local nMaxLogs = GetOpVar("LOG_MAXLOGS")
  if(nMaxLogs <= 0) then return end
  local sLogFile = GetOpVar("LOG_LOGFILE")
  local nCurLogs = GetOpVar("LOG_CURLOGS")
  if(sLogFile ~= "") then
    local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_LOG")..sLogFile..".txt"
    fileAppend(fName,FormatNumberMax(nCurLogs,nMaxLogs).." >> "..tostring(anyStuff).."\n")
    nCurLogs = nCurLogs + 1
    if(nCurLogs > nMaxLogs) then
      fileDelete(fName)
      nCurLogs = 0
    end
    SetOpVar("LOG_CURLOGS",nCurLogs)
  else
    print(FormatNumberMax(nCurLogs,nMaxLogs).." >> "..tostring(anyStuff))
    nCurLogs = nCurLogs + 1
    if(nCurLogs > nMaxLogs) then
      nCurLogs = 0
    end
    SetOpVar("LOG_CURLOGS",nCurLogs)
  end
end

function PrintInstance(anyStuff)
  local sModeDB = GetOpVar("MODE_DATABASE")
  if(SERVER) then
    print("SERVER > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..tostring(anyStuff))
  elseif(CLIENT) then
    print("CLIENT > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..tostring(anyStuff))
  else
    print("NOINST > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..tostring(anyStuff))
  end
end

function LogInstance(anyStuff)
  if(GetOpVar("LOG_MAXLOGS") <= 0) then return end
  local anyStuff = tostring(anyStuff)
  local logStats = GetOpVar("LOG_SKIP")
  if(logStats and logStats[1]) then
    local iNdex = 1
    while(logStats[iNdex]) do
      if(stringFind(anyStuff,tostring(logStats[iNdex]))) then return end
      iNdex = iNdex + 1
    end
  end -- Should the current log being skipped
  logStats = GetOpVar("LOG_ONLY")
  if(logStats and logStats[1]) then
    local iNdex = 1
    local logMe = false
    while(logStats[iNdex]) do
      if(stringFind(anyStuff,tostring(logStats[iNdex]))) then
        logMe = true
      end
      iNdex = iNdex + 1
    end
    if(not logMe) then return end
  end -- Only the chosen messages are processed
  local sModeDB  = GetOpVar("MODE_DATABASE")
  if(SERVER) then
    Log("SERVER > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..anyStuff)
  elseif(CLIENT) then
    Log("CLIENT > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..anyStuff)
  else
    Log("NOINST > "..GetOpVar("TOOLNAME_NU").." ["..sModeDB.."] "..anyStuff)
  end
end

function StatusPrint(anyStatus,sError)
  PrintInstance(sError)
  return anyStatus
end

function StatusLog(anyStatus,sError)
  LogInstance(sError)
  return anyStatus
end

function Print(tT,sS)
  if(not IsExistent(tT)) then
    return StatusLog(nil,"Print: {nil, name="..tostring(sS or "\"Data\"").."}") end
  local S = type(sS)
  local T = type(tT)
  local Key = ""
  if    (S == "string") then S = sS
  elseif(S == "number") then S = tostring(sS)
  else                       S = "Data" end
  if(T ~= "table") then
    LogInstance("{"..T.."}["..tostring(sS or "N/A").."] = "..tostring(tT))
    return
  end
  T = tT
  if(next(T) == nil) then
    LogInstance(S.." = {}")
    return
  end
  LogInstance(S)
  for k,v in pairs(T) do
    if(type(k) == "string") then
      Key = S.."[\""..k.."\"]"
    else
      Key = S.."["..tostring(k).."]"
    end
    if(type(v) ~= "table") then
      if(type(v) == "string") then
        LogInstance(Key.." = \""..v.."\"")
      else
        LogInstance(Key.." = "..tostring(v))
      end
    else
      Print(v,Key)
    end
  end
end

----------------- INITAIALIZATION -----------------

function GetIndexes(sType)
  if(not IsString(sType)) then
    return StatusLog(nil,"GetIndexes: Type {"..type(sType).."}<"..tostring(sType).."> not string") end
  if    (sType == "V") then return cvX, cvY, cvZ
  elseif(sType == "A") then return caP, caY, caR
  elseif(sType == "S") then return csA, csB, csC, csD
  else return StatusLog(nil,"GetIndexes: Type <"..sType.."> not found") end
end

function SetIndexes(sType,I1,I2,I3,I4)
  if(not IsString(sType)) then
    return StatusLog(false,"SetIndexes: Type {"..type(sType).."}<"..tostring(sType).."> not string") end
  if    (sType == "V") then cvX, cvY, cvZ      = I1, I2, I3
  elseif(sType == "A") then caP, caY, caR      = I1, I2, I3
  elseif(sType == "S") then csA, csB, csC, csD = I1, I2, I3, I4
  else return StatusLog(false,"SetIndexes: Type <"..sType.."> not found") end
  return StatusLog(true,"SetIndexes["..sType.."]: Success")
end

function InitAssembly(sName,sPurpose)
  SetOpVar("TYPEMT_STRING",getmetatable("TYPEMT_STRING"))
  SetOpVar("TYPEMT_SCREEN",{})
  SetOpVar("TYPEMT_CONTAINER",{})
  if(not IsString(sName)) then
    return StatusPrint(false,"InitAssembly: Name <"..tostring(sName).."> not string") end
  if(not IsString(sPurpose)) then
    return StatusPrint(false,"InitAssembly: Purpose <"..tostring(sPurpose).."> not string") end
  if(IsEmptyString(sName) or tonumber(stringSub(sName,1,1))) then
    return StatusPrint(false,"InitAssembly: Name invalid") end
  if(IsEmptyString(sPurpose) or tonumber(stringSub(sPurpose,1,1))) then
    return StatusPrint(false,"InitAssembly: Purpose invalid") end
  SetOpVar("TIME_INIT",Time())
  SetOpVar("MAX_MASS",50000)
  SetOpVar("MAX_LINEAR",1000)
  SetOpVar("MAX_ROTATION",360)
  SetOpVar("LOG_MAXLOGS",0)
  SetOpVar("LOG_CURLOGS",0)
  SetOpVar("LOG_LOGFILE","")
  SetOpVar("ANG_ZERO",Angle())
  SetOpVar("VEC_ZERO",Vector())
  SetOpVar("OPSYM_DISABLE","#")
  SetOpVar("OPSYM_REVSIGN","@")
  SetOpVar("OPSYM_DIVIDER","_")
  SetOpVar("OPSYM_DIRECTORY","/")
  SetOpVar("OPSYM_SEPARATOR",",")
  SetOpVar("GOLDEN_RATIO",1.61803398875)
  SetOpVar("NAME_INIT",stringLower(sName))
  SetOpVar("NAME_PERP",stringLower(sPurpose))
  SetOpVar("TOOLNAME_NL",stringLower(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")))
  SetOpVar("TOOLNAME_NU",stringUpper(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")))
  SetOpVar("TOOLNAME_PL",GetOpVar("TOOLNAME_NL").."_")
  SetOpVar("TOOLNAME_PU",GetOpVar("TOOLNAME_NU").."_")
  SetOpVar("DIRPATH_BAS",GetOpVar("TOOLNAME_NL")..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_INS","exp"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_DSV","dsv"..GetOpVar("OPSYM_DIRECTORY"))
  SetOpVar("DIRPATH_LOG","")
  SetOpVar("MISS_NOID","N")    -- No ID selected
  SetOpVar("MISS_NOAV","N/A")  -- Not Available
  SetOpVar("MISS_NOMD","X")    -- No model
  SetOpVar("ARRAY_DECODEPOA",{0,0,0,1,1,1,false})
  SetOpVar("TABLE_FREQUENT_MODELS",{})
  SetOpVar("TABLE_BORDERS",{})
  SetOpVar("FILE_MODEL","%.mdl")
  SetOpVar("MODE_DATABASE",GetOpVar("MISS_NOAV"))
  SetOpVar("HASH_USER_PANEL",GetOpVar("TOOLNAME_PU").."USER_PANEL")
  SetOpVar("HASH_QUERY_STORE",GetOpVar("TOOLNAME_PU").."QHASH_QUERY")
  SetOpVar("HASH_PLAYER_KEYDOWN","PLAYER_KEYDOWN")
  SetOpVar("HASH_PROPERTY_NAMES","PROPERTY_NAMES")
  SetOpVar("HASH_PROPERTY_TYPES","PROPERTY_TYPES")
  SetOpVar("NAV_PIECE",{})
  SetOpVar("NAV_PANEL",{})
  SetOpVar("NAV_ADDITION",{})
  SetOpVar("NAV_PROPERTY_NAMES",{})
  SetOpVar("NAV_PROPERTY_TYPES",{})
  SetOpVar("STRUCT_SPAWN",{
    F    = Vector(),
    R    = Vector(),
    U    = Vector(),
    OPos = Vector(),
    OAng = Angle (),
    SPos = Vector(),
    SAng = Angle (),
    RLen = 0,
    --- Holder ---
    HRec = 0,
    HID  = 0,
    HPnt = Vector(), -- P
    HPos = Vector(), -- O
    HAng = Angle (), -- A
    --- Traced ---
    TRec = 0,
    TID  = 0,
    TPnt = Vector(), -- P
    TPos = Vector(), -- O
    TAng = Angle ()  -- A
  })
  return StatusPrint(true,"InitAssembly: Success")
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

function NegAngle(aBase)
  if(not aBase ) then return StatusLog(nil,"NegAngle: Base invalid") end
  aBase[caP] = -(tonumber(aBase[caP]) or 0)
  aBase[caY] = -(tonumber(aBase[caY]) or 0)
  aBase[caR] = -(tonumber(aBase[caR]) or 0)
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

function NegVector(vBase)
  if(not vBase) then return StatusLog(nil,"NegVector: Base invalid") end
  vBase[cvX] = -(tonumber(vBase[cvX]) or 0)
  vBase[cvY] = -(tonumber(vBase[cvY]) or 0)
  vBase[cvZ] = -(tonumber(vBase[cvZ]) or 0)
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

function DecomposeByAngle(vBase,aUnit)
  if(not vBase) then return StatusLog(Vector(),"DecomposeByAngle: Base invalid") end
  if(not aUnit) then return StatusLog(Vector(),"DecomposeByAngle: Unit invalid") end
  local X = vBase:DotProduct(aUnit:Forward())
  local Y = vBase:DotProduct(aUnit:Right())
  local Z = vBase:DotProduct(aUnit:Up())
  SetVectorXYZ(vBase,X,Y,Z)
end

---------- OOP -----------------

function MakeContainer(sInfo,sDefKey)
  local Curs = 0
  local Data = {}
  local sSel, sIns, sDel, sMet = "", "", "", ""
  local Info = tostring(sInfo or "Store Container")
  local Key  = sDefKey or "(!_+*#-$@DEFKEY@$-#*+_!)"
  local self = {}
  function self:GetInfo() return Info end
  function self:GetSize() return Curs end
  function self:GetData() return Data end
  function self:Insert(nsKey,anyValue)
    sIns = nsKey or Key
    sMet = "I"
    if(not IsExistent(Data[sIns])) then
      Curs = Curs + 1
    end
    Data[sIns] = anyValue
  end
  function self:Select(nsKey)
    sSel = nsKey or Key
    return Data[sSel]
  end
  function self:Delete(nsKey,fnDel)
    sDel = nsKey or Key
    sMet = "D"
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

function MakeScreen(sW,sH,eW,eH,conPalette)
  if(SERVER) then return nil end
  local sW, sH = (tonumber(sW) or 0), (tonumber(sH) or 0)
  local eW, eH = (tonumber(eW) or 0), (tonumber(eH) or 0)
  if(eW <= 0 or eH <= 0) then return nil end
  if(type(conPalette) ~= "table") then return nil end
  local White  = Color(255,255,255,255)
  local Palette
  local ColorKey
  local Text = {}
        Text.Font = "Trebuchet18"
        Text.DrawX = 0
        Text.DrawY = 0
        Text.ScrW  = 0
        Text.ScrH  = 0
        Text.LastW = 0
        Text.LastH = 0
  if(getmetatable(conPalette) == GetOpVar("TYPEMT_CONTAINER")) then
    Palette = conPalette
  end
  local Texture = {}
        Texture.Path = "vgui/white"
        Texture.ID   = surfaceGetTextureID(Texture.Path)
  local self = {}
  function self:GetSize() return (eW-sW), (eH-sH) end
  function self:GetCenter(nX,nY)
    local nW, nH = self:GetSize()
    nW = (nW / 2) + (tonumber(nX) or 0)
    nH = (nH / 2) + (tonumber(nY) or 0)
    return nW, nH
  end
  function self:SetColor(keyColor)
    if(not keyColor) then return end
    local keyColor = keyColor or ColorKey; ColorKey = keyColor
    local rgbColor = (Palette and keyColor) and Palette:Select(keyColor) or White
    surfaceSetDrawColor(rgbColor.r, rgbColor.g, rgbColor.b, rgbColor.a)
    surfaceSetTextColor(rgbColor.r, rgbColor.g, rgbColor.b, rgbColor.a)
  end
  function self:SetTexture(sTexture)
    if(not IsString(sTexture)) then return end
    if(IsEmptyString(sTexture)) then return end
    Texture.Path = sTexture
    Texture.ID   = surfaceGetTextureID(Texture.Path)
  end
  function self:GetTexture() return Texture.ID, Texture.Path end
  function self:DrawBackGround(keyColor)
    self:SetColor(keyColor)
    surfaceSetTexture(Texture.ID)
    surfaceDrawTexturedRect(sW,sH,eW-sW,eH-sH)
  end
  function self:DrawRect(nX,nY,nW,nH,keyColor)
    self:SetColor(keyColor)
    surfaceSetTexture(Texture.ID)
    surfaceDrawTexturedRect(nX,nY,nW,nH)
  end
  function self:SetTextEdge(nX,nY)
    Text.DrawX = (tonumber(nX) or 0)
    Text.DrawY = (tonumber(nY) or 0)
    Text.ScrW  = 0
    Text.ScrH  = 0
    Text.LastW = 0
    Text.LastH = 0
  end
  function self:SetFont(sFont)
    if(not IsString(sFont)) then return end
    Text.Font = sFont or "Trebuchet18"
    surfaceSetFont(Text.Font)
  end
  function self:GetTextState(nX,nY,nW,nH)
    return (Text.DrawX + (nX or 0)), (Text.DrawY + (nY or 0)),
           (Text.ScrW  + (nW or 0)), (Text.ScrH  + (nH or 0)),
            Text.LastW, Text.LastH
  end
  function self:DrawText(sText,keyColor)
    surfaceSetTextPos(Text.DrawX,Text.DrawY)
    self:SetColor(keyColor)
    surfaceDrawText(sText)
    Text.LastW, Text.LastH = surfaceGetTextSize(sText)
    Text.DrawY = Text.DrawY + Text.LastH
    if(Text.LastW > Text.ScrW) then
      Text.ScrW = Text.LastW
    end
    Text.ScrH = Text.DrawY
  end
  function self:DrawTextAdd(sText,keyColor)
    surfaceSetTextPos(Text.DrawX + Text.LastW,Text.DrawY - Text.LastH)
    self:SetColor(keyColor)
    surfaceDrawText(sText)
    local LastW, LastH = surfaceGetTextSize(sText)
    Text.LastW = Text.LastW + LastW
    Text.LastH = LastH
    if(Text.LastW > Text.ScrW) then
      Text.ScrW = Text.LastW
    end
    Text.ScrH = Text.DrawY
  end
  function self:Enclose(xyPnt)
    if(xyPnt.x < sW) then return -1 end
    if(xyPnt.x > eW) then return -1 end
    if(xyPnt.y < sH) then return -1 end
    if(xyPnt.y > eH) then return -1 end
    return 1
  end
  function self:DrawLine(xyS,xyE,keyColor,sMeth,tArg)
    self:SetColor(keyColor)
    if(not (xyS and xyE)) then return end
    if(not (xyS.x and xyS.y and xyE.x and xyE.y)) then return end
    if(self:Enclose(xyS) == -1 or self:Enclose(xyE) == -1) then return end
    local sdrwMeth = tostring(sMeth or "API")
    if(sdrwMeth == "API") then
      surfaceDrawLine(xyS.x,xyS.y,xyE.x,xyE.y)
    elseif(sdrwMeth == "LIN") then
      local nIter = tonumber(tArg[1]) or 0
      if(nIter <= 0) then return end
      local nLx, nLy = (xyE.x - xyS.x), (xyE.y - xyS.y)
      local xyD = {x = (nLx / nIter), y = (nLy / nIter)}
      local xyOld, xyNew = {x = xyS.x, y = xyS.y}, {x = 0,y = 0}
      while(nIter > 0) do
        xyNew.x = xyOld.x + xyD.x
        xyNew.y = xyOld.y + xyD.y
        self:DrawLine(xyOld,xyNew,keyColor)
        surfaceDrawCircle(xyNew.x, xyNew.y, 10, Color(255,0,0))
        xyOld.x, xyOld.y = xyNew.x, xyNew.y
        nIter = nIter - 1;
      end
    end
  end
  function self:DrawCircle(xyPos,nRad,keyColor,sMeth,tArg)
    local sdrwMeth = tostring(sMeth or "API")
    local keyColor = keyColor or ColorKey; ColorKey = keyColor
    local rgbColor = (Palette and keyColor) and Palette:Select(keyColor) or White
    if(sdrwMeth == "API") then surfaceDrawCircle(xyPos.x, xyPos.y, nRad, rgbColor)
    elseif(sdrwMeth == "LIN") then
      local nIter = tonumber(tArg[1]) or 0
      if(nIter <= 0) then return end
      local nCurAng = 0
      local nMaxRot = (GetOpVar("MAX_ROTATION") * mathPi / 180)
      local nStpRot = nMaxRot / nIter
      local xyOld, xyNew, xyRad = {x=0,y=0}, {x=0,y=0}, {x=nRad,y=0}
            xyOld.x = xyPos.x + xyRad.x
            xyOld.y = xyPos.y + xyRad.y
      while(nIter > 0) do
        nCurAng = nCurAng + nStpRot
        local nSin, nCos = mathSin(nCurAng), mathCos(nCurAng)
        xyNew.x = xyPos.x + (xyRad.x * nCos - xyRad.y * nSin)
        xyNew.y = xyPos.y + (xyRad.x * nSin + xyRad.y * nCos)
        self:DrawLine(xyOld,xyNew,keyColor)
        xyOld.x, xyOld.y = xyNew.x, xyNew.y
        nIter = nIter - 1;
      end
    end
  end
  setmetatable(self,GetOpVar("TYPEMT_SCREEN"))
  return self
end

function SetAction(sKey,fAct,tDat)
  if(not (sKey and IsString(sKey))) then return false end
  if(not (fAct and type(fAct) == "function")) then return false end
  if(not libAction[sKey]) then
    libAction[sKey] = {}
  end
  libAction[sKey].Act = fAct
  libAction[sKey].Dat = tDat
  return true
end

function GetActionCode(sKey)
  if(not (sKey and IsString(sKey))) then return StatusLog(nil,"GetActionCode: ") end
  if(not (libAction and libAction[sKey])) then return nil end
  return libAction[sKey].Act
end

function GetActionData(sKey)
  if(not (sKey and IsString(sKey))) then return nil end
  if(not (libAction and libAction[sKey])) then return nil end
  return libAction[sKey].Dat
end

function CallAction(sKey,A1,A2,A3,A4)
  if(not (sKey and IsString(sKey))) then return false end
  if(not (libAction and libAction[sKey])) then return false end
  return libAction[sKey].Act(A1,A2,A3,A4,libAction[sKey].Dat)
end

function IsOther(oEnt)
  if(not oEnt)           then return true end
  if(not oEnt:IsValid()) then return true end
  if(oEnt:IsPlayer())    then return true end
  if(oEnt:IsVehicle())   then return true end
  if(oEnt:IsNPC())       then return true end
  if(oEnt:IsRagdoll())   then return true end
  if(oEnt:IsWeapon())    then return true end
  if(oEnt:IsWidget())    then return true end
  return false
end

local function AddLineListView(pnListView,frUsed,ivNdex)
  if(not IsExistent(pnListView)) then
    return StatusLog(nil,"LineAddListView: Missing panel") end
  if(not IsValid(pnListView)) then
    return StatusLog(nil,"LineAddListView: Invalid panel") end
  if(not IsExistent(frUsed)) then
    return StatusLog(nil,"LineAddListView: Missing data") end
  local iNdex = tonumber(ivNdex)
  if(not IsExistent(iNdex)) then
    return StatusLog(nil,"LineAddListView: Index NAN {"..type(ivNdex).."}<"..tostring(ivNdex)..">") end
  local tValue = frUsed[iNdex]
  if(not IsExistent(tValue)) then
    return StatusLog(nil,"LineAddListView: Missing data on index #"..tostring(iNdex)) end
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not IsExistent(defTable)) then
    return StatusLog(nil,"LineAddListView: Missing table definition") end
  local sModel = tValue.Table[defTable[1][1]]
  local sType  = tValue.Table[defTable[2][1]]
  local nAct   = tValue.Table[defTable[4][1]]
  local nUsed  = RoundValue(tValue.Value,0.001)
  local pnRec  = pnListView:AddLine(nUsed,nAct,sType,sModel)
  if(not IsExistent(pnRec)) then
    return StatusLog(nil,"LineAddListView: Failed to create a ListView line for <"..sModel.."> #"..tostring(iNdex)) end
  return pnRec, tValue
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
  else
    return StatusLog(false,"UpdateListView: Missing ListView")
  end
  local sField   = tostring(sField   or "")
  local sPattern = tostring(sPattern or "")
  local iNdex, pnRec, sData = 1, nil, nil
  while(frUsed[iNdex]) do
    if(IsEmptyString(sPattern)) then
      pnRec = AddLineListView(pnListView,frUsed,iNdex)
      if(not IsExistent(pnRec)) then
        return StatusLog(false,"UpdateListView: Failed to add line on #"..tostring(iNdex)) end
    else
      sData = tostring(frUsed[iNdex].Table[sField] or "")
      if(stringFind(sData,sPattern)) then
        pnRec = AddLineListView(pnListView,frUsed,iNdex)
        if(not IsExistent(pnRec)) then
          return StatusLog(false,"UpdateListView: Failed to add line <"
                   ..sData.."> pattern <"..sPattern.."> on <"..sField.."> #"..tostring(iNdex)) end
      end
    end
    iNdex = iNdex + 1
  end
  pnListView:SetVisible(true)
  return StatusLog(true,"UpdateListView: Crated #"..tostring(iNdex-1))
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
  for Model, Record in pairs(tCache) do
    if(IsExistent(Record.Used) and IsExistent(Record.Kept) and Record.Kept > 0) then
      iInd = PushSortValues(frUsed,snCount,tmNow-Record.Used,{
               [defTable[1][1]] = Model,
               [defTable[2][1]] = Record.Type,
               [defTable[3][1]] = Record.Name,
               [defTable[4][1]] = Record.Kept
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

function SnapValue(nvVal, nvSnap)
  if(not nvVal) then return 0 end
  local nVal = tonumber(nvVal)
  if(not IsExistent(nVal)) then
    return StatusLog(0,"SnapValue: Convert value NAN {"..type(nvVal).."}<"..tostring(nvVal)..">") end
  if(not IsExistent(nvSnap)) then return nVal end
  local nSnap = tonumber(nvSnap)
  if(not IsExistent(nSnap)) then
    return StatusLog(0,"SnapValue: Convert snap NAN {"..type(nvSnap).."}<"..tostring(nvSnap)..">") end
  if(nSnap == 0) then return nVal end
  local nvSnp, nvVal = mathAbs(nSnap), mathAbs(nVal)
  local nRst, nRez = (nvVal % nvSnp), 0
  if((nvSnp - nRst) < nRst) then nRez = nvVal + nvSnp - nRst else nRez = nvVal - nRst end
  if(nVal < 0) then return -nRez; end
  return nRez;
end

function GetCenterMC(oEnt)
  -- Set the ENT's Angles first!
  if(not (oEnt and oEnt:IsValid())) then
    return StatusLog(Vector(0,0,0),"GetCenterMC: Entity Invalid") end
  local Phys = oEnt:GetPhysicsObject()
  if(not (Phys and Phys:IsValid())) then
    return StatusLog(Vector(0,0,0),"GetCenterMC: Phys object Invalid") end
  local vRez = Phys:GetMassCenter()
        vRez[cvX] = -vRez[cvX]; vRez[cvY] = -vRez[cvY]; vRez[cvZ] = 0
        vRez:Rotate(oEnt:GetAngles())
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
    if    (nsVal < Border[1]) then return Border[1]
    elseif(nsVal > Border[2]) then return Border[2] end
  end
  return nsVal
end

function IncDecPointID(ivPointID,sDir,rPiece)
  local iPointID = tonumber(ivPointID)
  if(not IsExistent(iPointID)) then
    return StatusLog(1,"IncDecPointID: Point ID NAN {"..type(ivPointID).."}<"..tostring(ivPointID)..">") end
  local stPOA = LocatePOA(rPiece,iPointID)
  if(not IsExistent(stPOA)) then
    return StatusLog(1,"IncDecPointID: Point ID #"..tostring(iPointID).." not located") end
  local sDir, nDir = stringSub(tostring(sDir),1,1), 0
  if    (sDir == "+") then nDir =  1
  elseif(sDir == "-") then nDir = -1
  else return StatusLog(iPointID,"IncDecPointID: Direction <"..sDir.."> mismatch") end
  iPointID = RollValue(iPointID + nDir,1,rPiece.Kept)
  stPOA    = LocatePOA(rPiece,iPointID) -- Skip disabled O ( Origin )
  while(stPOA and stPOA.O[csD]) do
    LogInstance("IncDecPointID: Point ID #"..tostring(iPointID).." disabled")
    iPointID = RollValue(iPointID + nDir,1,rPiece.Kept)
    stPOA    = LocatePOA(rPiece,iPointID) -- Skip disabled O ( Origin )
  end; iPointID = RollValue(iPointID,1,rPiece.Kept)
  if(not IsExistent(LocatePOA(rPiece,iPointID))) then
    return StatusLog(1,"IncDecPointID["..sDir.."]: Offset PnextID #"..tostring(iPointID).." not located") end
  return iPointID
end

function IncDecPnextID(ivPnextID,ivPointID,sDir,rPiece)
  local iPointID, iPnextID = tonumber(ivPointID), tonumber(ivPnextID)
  if(not IsExistent(iPointID)) then
    return StatusLog(1,"IncDecPnextID: PointID NAN {"..type(ivPointID).."}<"..tostring(ivPointID)..">") end
  if(not IsExistent(iPnextID)) then
    return StatusLog(1,"IncDecPnextID: PnextID NAN {"..type(ivPnextID).."}<"..tostring(ivPnextID)..">") end
  if(not IsExistent(LocatePOA(rPiece,iPointID))) then
    return StatusLog(1,"IncDecPointID: Offset PointID #"..tostring(iPointID).." not located") end
  if(not IsExistent(LocatePOA(rPiece,iPnextID))) then
    return StatusLog(1,"IncDecPointID: Offset PnextID #"..tostring(iPnextID).." not located") end
  local sDir, nDir = stringSub(tostring(sDir),1,1), 0
  if    (sDir == "+") then nDir =  1
  elseif(sDir == "-") then nDir = -1
  else return StatusLog(iPnextID,"IncDecPnextID: Direction <"..sDir.."> mismatch") end
  iPnextID = RollValue(iPnextID + nDir,1,rPiece.Kept)
  if(iPnextID == iPointID) then iPnextID = RollValue(iPnextID + nDir,1,rPiece.Kept) end
  if(not IsExistent(LocatePOA(rPiece,iPnextID))) then
    return StatusLog(1,"IncDecPointID["..sDir.."]: Offset PnextID #"..tostring(iPnextID).." not located") end
  return iPnextID
end

function PointOffsetUp(oEnt,ivPointID)
  if(not (oEnt and oEnt:IsValid())) then
    return StatusLog(nil,"PointOffsetUp: Entity Invalid") end
  local sModel = oEnt:GetModel()
  local iPointID = tonumber(ivPointID)
  if(not IsExistent(iPointID)) then
    return StatusLog(nil,"PointOffsetUp: PointID NAN {"
             ..type(ivPointID).."}<"..tostring(ivPointID).."> for <"..sModel..">") end
  local hdRec = CacheQueryPiece(sModel)
  if(not IsExistent(hdRec)) then
    return StatusLog(nil,"PointOffsetUp: Record not found for <"..sModel..">") end
  local hdPnt = LocatePOA(hdRec,iPointID)
  if(not IsExistent(hdPnt)) then
    return StatusLog(nil,"PointOffsetUp: Point #"..tostring(iPointID)
             .." not located on model <"..sModel..">") end
  if(not (hdPnt.O and hdPnt.A)) then
    return StatusLog(nil,"PointOffsetUp: Invalid POA #"..tostring(iPointID).." for <"..sModel..">") end
  local aDiffBB = Angle()
  local vDiffBB = oEnt:OBBMins()
  SetAngle(aDiffBB,hdPnt.A)
  aDiffBB:RotateAroundAxis(aDiffBB:Up(),180)
  SubVector(vDiffBB,hdPnt.O)
  DecomposeByAngle(vDiffBB,aDiffBB)
  return mathAbs(vDiffBB[cvZ])
end

function ModelToName(sModel)
  if(not IsString(sModel)) then
    return StatusLog("","ModelToName: Argument {"..type(sModel).."}<"..tostring(sModel)..">") end
  if(IsEmptyString(sModel)) then return StatusLog("","ModelToName: Empty string") end
  local fCh, bCh, Cnt = "", "", 1
  local sSymDiv = GetOpVar("OPSYM_DIVIDER")
  local sSymDir = GetOpVar("OPSYM_DIRECTORY")
  local sModel  = stringGsub(stringToFileName(sModel),GetOpVar("FILE_MODEL"),"")
  local gModel  = stringSub(sModel,1,-1) -- Create a copy so we can select cut-off parts later on
  local tCut, tSub, tApp = SettingsModelToName("GET")
  if(tCut and tCut[1]) then
    while(tCut[Cnt] and tCut[Cnt+1]) do
      fCh = tonumber(tCut[Cnt])
      bCh = tonumber(tCut[Cnt+1])
      if(not (IsExistent(fCh) and IsExistent(bCh))) then
        return StatusLog("","ModelToName: Cannot cut the model in {"
                 ..tostring(tCut[Cnt])..","..tostring(tCut[Cnt+1]).."} for "..sModel)
      end
      LogInstance("ModelToName[CUT]: {"..tostring(tCut[Cnt])..", "..tostring(tCut[Cnt+1]).."} << "..gModel)
      gModel = stringGsub(gModel,stringSub(sModel,fCh,bCh),"")
      LogInstance("ModelToName[CUT]: {"..tostring(tCut[Cnt])..", "..tostring(tCut[Cnt+1]).."} >> "..gModel)
      Cnt = Cnt + 2
    end
    Cnt = 1
  end
  -- Replace the unneeded parts by finding an in-string gModel
  if(tSub and tSub[1]) then
    while(tSub[Cnt]) do
      fCh = tostring(tSub[Cnt]   or "")
      bCh = tostring(tSub[Cnt+1] or "")
      LogInstance("ModelToName[SUB]: {"..tostring(tSub[Cnt])..", "..tostring(tSub[Cnt+1]).."} << "..gModel)
      gModel = stringGsub(gModel,fCh,bCh)
      LogInstance("ModelToName[SUB]: {"..tostring(tSub[Cnt])..", "..tostring(tSub[Cnt+1]).."} >> "..gModel)
      Cnt = Cnt + 2
    end
    Cnt = 1
  end
  -- Append something if needed
  if(tApp and tApp[1]) then
    LogInstance("ModelToName[APP]: {"..tostring(tApp[Cnt])..", "..tostring(tApp[Cnt+1]).."} << "..gModel)
    gModel = tostring(tApp[1] or "")..gModel..tostring(tApp[2] or "")
    LogInstance("ModelToName[APP]: {"..tostring(tSub[Cnt])..", "..tostring(tSub[Cnt+1]).."} >> "..gModel)
  end
  -- Trigger the capital-space using the divider
  if(stringSub(gModel,1,1) ~= sSymDiv) then gModel = sSymDiv..gModel end
  -- Here in gModel we have: _aaaaa_bbbb_ccccc
  fCh, bCh, sModel = stringFind(gModel,sSymDiv,1), 1, ""
  while(fCh) do
    if(fCh > bCh) then
      sModel = sModel..stringSub(gModel,bCh+2,fCh-1)
    end
    if(not IsEmptyString(sModel)) then
      sModel = sModel.." "
    end
    sModel = sModel..stringUpper(stringSub(gModel,fCh+1,fCh+1))
    bCh = fCh
    fCh = stringFind(gModel,sSymDiv,fCh+1)
  end
  return sModel..stringSub(gModel,bCh+2,-1)
end

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
  return stPOA
end

local function ReloadPOA(nXP,nYY,nZR,nSX,nSY,nSZ,nSD)
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
        arPOA[1] = tonumber(nXP) or 0
        arPOA[2] = tonumber(nYY) or 0
        arPOA[3] = tonumber(nZR) or 0
        arPOA[4] = tonumber(nSX) or 1
        arPOA[5] = tonumber(nSY) or 1
        arPOA[6] = tonumber(nSZ) or 1
        arPOA[7] = (tonumber(nSD) and (nSD ~= 0)) and true or false
  return arPOA
end

local function IsEqualPOA(staPOA,stbPOA)
  if(not IsExistent(staPOA)) then
    return StatusLog(false,"EqualPOA: Missing offset A") end
  if(not IsExistent(stbPOA)) then
    return StatusLog(false,"EqualPOA: Missing offset B") end
  for kKey, vComp in pairs(staPOA) do
    if(kKey ~= csD and stbPOA[kKey] ~= vComp) then return false end
  end
  return true
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
  return stringGsub((stPOA[csD] and symDisa or "")  -- Get rid of the spaces
                 ..((stPOA[csA] == -1) and symRevs or "")..tostring(stPOA[ctA])..symSepa
                 ..((stPOA[csB] == -1) and symRevs or "")..tostring(stPOA[ctB])..symSepa
                 ..((stPOA[csC] == -1) and symRevs or "")..tostring(stPOA[ctC])," ","")
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
  local sCh = ""
  local dInd, iSep = 1, 0
  local S, E, iCnt = 1, 1, 1
  local strLen = stringLen(sStr)
  local symOff = GetOpVar("OPSYM_DISABLE")
  local symRev = GetOpVar("OPSYM_REVSIGN")
  local symSep = GetOpVar("OPSYM_SEPARATOR")
  local arPOA  = GetOpVar("ARRAY_DECODEPOA")
  ReloadPOA()
  if(stringSub(sStr,iCnt,iCnt) == symOff) then
    arPOA[7] = true; iCnt = iCnt + 1; S = S + 1 end
  while(iCnt <= strLen) do
    sCh = stringSub(sStr,iCnt,iCnt)
    if(sCh == symRev) then
      arPOA[3+dInd] = -arPOA[3+dInd]; S = S + 1
    elseif(sCh == symSep) then
      iSep = iSep + 1; E = iCnt - 1
      if(iSep > 2) then break end
      arPOA[dInd] = tonumber(stringSub(sStr,S,E)) or 0
      dInd = dInd + 1; S = iCnt + 1; E = S
    else E = E + 1 end
    iCnt = iCnt + 1
  end
  arPOA[dInd] = tonumber(stringSub(sStr,S,E)) or 0
  return arPOA
end

local function RegisterPOA(stPiece, ivID, sP, sO, sA)
  if(not stPiece) then
    return StatusLog(nil,"RegisterPOA: Cache record invalid") end
  local iID = tonumber(ivID)
  if(not IsExistent(iID)) then
    return StatusLog(nil,"RegisterPOA: OffsetID NAN {"..type(ivID).."}<"..tostring(ivID)..">") end
  local sP = sP or "NULL"
  local sO = sO or "NULL"
  local sA = sA or "NULL"
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
  local tOffs = stPiece.Offs
  if(tOffs[iID]) then
    return StatusLog(nil,"RegisterPOA: Exists ID #"..tostring(iID))
  else
    if((iID > 1) and (not tOffs[iID - 1])) then
      return StatusLog(nil,"RegisterPOA: No sequential ID #"..tostring(iID - 1))
    end
    tOffs[iID]   = {}
    tOffs[iID].P = {}
    tOffs[iID].O = {}
    tOffs[iID].A = {}
    tOffs        = tOffs[iID]
  end
  ---------------- Origin ----------------
  if((sO ~= "NULL") and not IsEmptyString(sO)) then DecodePOA(sO) else ReloadPOA() end
  if(not IsExistent(TransferPOA(tOffs.O,"V"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer origin") end
  ---------------- Point ----------------
  local sD = stringGsub(sP,GetOpVar("OPSYM_DISABLE"),"")
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
    Data[Lo], Data[iMid] = Data[iMid], Data[Lo]
    iMid = Lo
    local vMid = Data[Lo].Val
    local iCnt = Lo + 1
    while(iCnt <= Hi)do
      if(Data[iCnt].Val < vMid) then
        iMid = iMid + 1
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
    local sFirst = stringSub(sBase,1,1)
    if(sFirst ~= GetOpVar("OPSYM_DISABLE") and not IsEmptyString(sBase)) then
      return sBase
    elseif(sFirst == GetOpVar("OPSYM_DISABLE")) then
      return anyDisable
    end
  end
  return anyDefault
end

function DefaultString(sBase, sDefault)
  if(IsString(sBase)) then
    if(not IsEmptyString(sBase)) then return sBase end
  end
  if(IsString(sDefault)) then return sDefault end
  return ""
end

------------- VARIABLE INTERFACES --------------

local function SQLBuildError(anyError)
  if(not IsExistent(anyError)) then
    return GetOpVar("SQL_BUILD_ERR") or "" end
  SetOpVar("SQL_BUILD_ERR", tostring(anyError))
  return nil -- Nothing assembled
end

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
  else
    return StatusLog(false,"SettingsModelToName: Wrong mode name "..sMode)
  end
end

function DefaultType(anyType)
  if(not IsExistent(anyType)) then
    return GetOpVar("DEFAULT_TYPE") or "" end
  SetOpVar("DEFAULT_TYPE",tostring(anyType))
  SettingsModelToName("CLR")
end

function DefaultTable(anyTable)
  if(not IsExistent(anyTable)) then
    return GetOpVar("DEFAULT_TABLE") or "" end
  SetOpVar("DEFAULT_TABLE",anyTable)
  SettingsModelToName("CLR")
end

------------------------- PLAYER -----------------------------------

function ConCommandPly(pPly,sCvar,snValue)
  if(not pPly) then return StatusLog("","ConCommandPly: Player invalid") end
  if(not IsString(sCvar)) then
    return StatusLog("","ConCommandPly: Convar {"..type(sCvar).."}<"..tostring(sCvar).."> not string") end
  return pPly:ConCommand(GetOpVar("TOOLNAME_PL")..sCvar.." "..tostring(snValue).."\n")
end

function PrintNotifyPly(pPly,sText,sNotifType)
  if(not pPly) then
    return StatusLog(false,"PrintNotifyPly: Player invalid") end
  if(SERVER) then
    pPly:SendLua("GAMEMODE:AddNotify(\""..sText.."\", NOTIFY_"..sNotifType..", 6)")
    pPly:SendLua("surface.PlaySound(\"ambient/water/drip"..mathRandom(1, 4)..".wav\")")
  end
  return StatusLog(true,"PrintNotifyPly: Success")
end

function UndoCratePly(anyMessage)
  SetOpVar("LABEL_UNDO",tostring(anyMessage))
  undoCreate(GetOpVar("LABEL_UNDO"))
  return true
end

function UndoAddEntityPly(oEnt)
  if(not (oEnt and oEnt:IsValid())) then
    return StatusLog(false,"UndoAddEntityPly: Entity invalid") end
  undoAddEntity(oEnt)
  return true
end

function UndoFinishPly(pPly,anyMessage)
  if(not pPly) then return StatusLog(false,"UndoFinishPly: Player invalid") end
  pPly:EmitSound("physics/metal/metal_canister_impact_hard"..mathFloor(mathRandom(3))..".wav")
  undoSetCustomUndoText(GetOpVar("LABEL_UNDO")..tostring(anyMessage or ""))
  undoSetPlayer(pPly)
  undoFinish()
  return true
end

function LoadKeyPly(pPly, sKey)
  local keyPly   = GetOpVar("HASH_PLAYER_KEYDOWN")
  local plyCache = libCache[keyPly]
  if(not IsExistent(plyCache)) then
    libCache[keyPly] = {}
    plyCache = libCache[keyPly]
  end
  if(not pPly) then
    return StatusLog(false,"LoadKeyPly: Player not available") end
  local spName   = pPly:GetName()
  local plyPlace = plyCache[spName]
  if(not IsExistent(plyPlace)) then
    plyCache[spName] = {
      ["ALTLFT"]  = false,
      ["ALTRGH"]  = false,
      ["ATTLFT"]  = false,
      ["ATTRGH"]  = false,
      ["FORWARD"] = false,
      ["BACK"]    = false,
      ["MOVELFT"] = false,
      ["MOVERGH"] = false,
      ["RELOAD"]  = false,
      ["USE"]     = false,
      ["DUCK"]    = false,
      ["JUMP"]    = false,
      ["SPEED"]   = false,
      ["SCORE"]   = false,
      ["ZOOM"]    = false,
      ["LEFT"]    = false,
      ["RIGHT"]   = false,
      ["WALK"]    = false
    }
    plyPlace = plyCache[spName]
  end
  if(IsExistent(sKey)) then
    if(not IsString(sKey)) then
      return StatusLog(false,"LoadKeyPly: Key hash {"..type(sKey).."}<"..tostring(sKey).."> not string") end
    if(sKey == "DEBUG") then
      return plyPlace
    end
    LogInstance("LoadKeyPly: NamePK <"..sKey.."> = "..tostring(plyPlace[sKey]))
    return plyPlace[sKey]
  end
  plyPlace["ALTLFT"]  = pPly:KeyDown(IN_ALT1      )
  plyPlace["ALTRGH"]  = pPly:KeyDown(IN_ALT2      )
  plyPlace["ATTLFT"]  = pPly:KeyDown(IN_ATTACK    )
  plyPlace["ATTRGH"]  = pPly:KeyDown(IN_ATTACK2   )
  plyPlace["FORWARD"] = pPly:KeyDown(IN_FORWARD   )
  plyPlace["BACK"]    = pPly:KeyDown(IN_BACK      )
  plyPlace["MOVELFT"] = pPly:KeyDown(IN_MOVELEFT  )
  plyPlace["MOVERGH"] = pPly:KeyDown(IN_MOVERIGHT )
  plyPlace["RELOAD"]  = pPly:KeyDown(IN_RELOAD    )
  plyPlace["USE"]     = pPly:KeyDown(IN_USE       )
  plyPlace["DUCK"]    = pPly:KeyDown(IN_DUCK      )
  plyPlace["JUMP"]    = pPly:KeyDown(IN_JUMP      )
  plyPlace["SPEED"]   = pPly:KeyDown(IN_SPEED     )
  plyPlace["SCORE"]   = pPly:KeyDown(IN_SCORE     )
  plyPlace["ZOOM"]    = pPly:KeyDown(IN_ZOOM      )
  plyPlace["LEFT"]    = pPly:KeyDown(IN_LEFT      )
  plyPlace["RIGHT"]   = pPly:KeyDown(IN_RIGHT     )
  plyPlace["WALK"]    = pPly:KeyDown(IN_WALK      )
  return StatusLog(true,"LoadKeyPly: Player <"..spName.."> keys loaded")
end

-------------------------- BUILDSQL ------------------------------

local function MatchType(defTable,snValue,ivIndex,bQuoted,sQuote,bStopRevise,bStopEmpty)
  if(not defTable) then
    return StatusLog(nil,"MatchType: Missing table definition") end
  local nIndex = tonumber(ivIndex)
  if(not IsExistent(nIndex)) then
    return StatusLog(nil,"MatchType: Field NAN {"..type(ivIndex)"}<"
             ..tostring(ivIndex).."> invalid on table "..defTable.Name) end
  local defField = defTable[nIndex]
  if(not IsExistent(defField)) then
    return StatusLog(nil,"MatchType: Invalid field #"
             ..tostring(nIndex).." on table "..defTable.Name) end
  local snOut
  local tipField = tostring(defField[2])
  local sModeDB  = GetOpVar("MODE_DATABASE")
  if(tipField == "TEXT") then
    snOut = tostring(snValue)
    if(not bStopEmpty and (snOut == "nil" or IsEmptyString(snOut))) then
      if    (sModeDB == "SQL") then snOut = "NULL"
      elseif(sModeDB == "LUA") then snOut = "NULL"
      else return StatusLog(nil,"MatchType: Wrong database mode <"..sModeDB..">") end
    end
    if    (defField[3] == "LOW") then snOut = stringLower(snOut)
    elseif(defField[3] == "CAP") then snOut = stringUpper(snOut) end
    if(not bStopRevise and sModeDB == "SQL" and defField[4] == "QMK") then
      snOut = stringGsub(snOut,"'","''")
    end
    if(bQuoted) then
      local sqChar
      if(sQuote) then
        sqChar = stringSub(tostring(sQuote),1,1)
      else
        if    (sModeDB == "SQL") then sqChar = "'"
        elseif(sModeDB == "LUA") then sqChar = "\"" end
      end
      snOut = sqChar..snOut..sqChar
    end
  elseif(tipField == "REAL" or tipField == "INTEGER") then
    snOut = tonumber(snValue)
    if(not IsExistent(snOut)) then
      return StatusLog(nil,"MatchType: Failed converting {"
               ..type(snValue).."}<"..tostring(snValue).."> to NUMBER for table "
               ..defTable.Name.." field #"..nIndex) end
    if(tipField == "INTEGER") then
      if(defField[3] == "FLR") then
        snOut = mathFloor(snOut)
      elseif(defField[3] == "CEL") then
        snOut = mathCeil(snOut)
      end
    end
  else
    return StatusLog(nil,"MatchType: Invalid field type <"
      ..tipField.."> on table "..defTable.Name) end
  return snOut
end

local function SQLBuildCreate(defTable)
  if(not defTable) then
    return SQLBuildError("SQLBuildCreate: Missing table definition") end
  local indTable = defTable.Index
  if(not defTable[1]) then
    return SQLBuildError("SQLBuildCreate: Missing table definition is empty for "..defTable.Name) end
  if(not (defTable[1][1] and defTable[1][2])) then
    return SQLBuildError("SQLBuildCreate: Missing table "..defTable.Name.." field definitions") end
  local Command, iInd = {}, 1
  Command.Drop   = "DROP TABLE "..defTable.Name..";"
  Command.Delete = "DELETE FROM "..defTable.Name..";"
  Command.Create = "CREATE TABLE "..defTable.Name.." ( "
  while(defTable[iInd]) do
    local v = defTable[iInd]
    if(not v[1]) then
      return SQLBuildError("SQLBuildCreate: Missing Table "..defTable.Name
                          .."'s field #"..tostring(iInd)) end
    if(not v[2]) then
      return SQLBuildError("SQLBuildCreate: Missing Table "..defTable.Name
                                  .."'s field type #"..tostring(iInd)) end
    Command.Create = Command.Create..stringUpper(v[1]).." "..stringUpper(v[2])
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
        return SQLBuildError("SQLBuildCreate: Index creator mismatch on "
          ..defTable.Name.." value "..vI.." is not a table for index ["..tostring(iInd).."]") end
      local FieldsU = ""
      local FieldsC = ""
      Command.Index[iInd] = "CREATE INDEX IND_"..defTable.Name
      iCnt = 1
      while(vI[iCnt]) do
        local vF = vI[iCnt]
        if(type(vF) ~= "number") then
          return SQLBuildError("SQLBuildCreate: Index creator mismatch on "
            ..defTable.Name.." value "..vF.." is not a number for index ["
            ..tostring(iInd).."]["..tostring(iCnt).."]") end
        if(not defTable[vF]) then
          return SQLBuildError("SQLBuildCreate: Index creator mismatch on "
            ..defTable.Name..". The table does not have field index #"
            ..vF..", max is #"..Table.Size) end
        FieldsU = FieldsU.."_" ..stringUpper(defTable[vF][1])
        FieldsC = FieldsC..stringUpper(defTable[vF][1])
        if(vI[iCnt+1]) then FieldsC = FieldsC ..", " end
        iCnt = iCnt + 1
      end
      Command.Index[iInd] = Command.Index[iInd]..FieldsU.." ON "..defTable.Name.." ( "..FieldsC.." );"
      iInd = iInd + 1
    end
  end
  SQLBuildError("")
  return Command
end

local function SQLStoreQuery(defTable,tFields,tWhere,tOrderBy,sQuery)
  if(not GetOpVar("EN_QUERY_STORE")) then return sQuery end
  local Val, Base
  if(not defTable) then
    return StatusLog(nil,"SQLStoreQuery: Missing table definition") end
  local tTimer = defTable.Timer
  if(not (tTimer and ((tonumber(tTimer[2]) or 0) > 0))) then
    return StatusLog(sQuery,"SQLStoreQuery: Skipped. Cache persistent forever") end
  local Field, Where, Order = 1, 1, 1
  local keyStr = GetOpVar("HASH_QUERY_STORE")
  local tCache = libCache[keyStr]
  if(not IsExistent(tCache)) then
    libCache[keyStr] = {}; tCache = libCache[keyStr] end
  local Place = tCache[defTable.Name]
  if(not IsExistent(Place)) then
    tCache[defTable.Name] = {}; Place = tCache[defTable.Name] end
  if(tFields) then
    while(tFields[Field]) do
      Val = defTable[tFields[Field]][1]
      if(not IsExistent(Val)) then
        return StatusLog(nil,"SQLStoreQuery: Missing field key for #"..tostring(Field)) end
      if(Place[Val]) then
        Place = Place[Val]
      elseif(sQuery) then
        Base = Place
        Place[Val] = {}
        Place = Place[Val]
      else
        return nil
      end
      if(not Place) then return nil end
      Field = Field + 1
    end
  else
    Val = "ALL_FIELDS"
    if(Place[Val]) then
      Place = Place[Val]
    elseif(sQuery) then
      Base = Place
      Place[Val] = {}
      Place = Place[Val]
    else
      return nil
    end
  end
  if(tOrderBy) then
    while(tOrderBy[Order]) do
      Val = tOrderBy[Order]
      if(Place[Val]) then
        Base = Place
        Place = Place[Val]
      elseif(sQuery) then
        Base = Place
        Place[Val] = {}
        Place = Place[Val]
      else return StatusLog(nil,"SQLStoreQuery: Missing order field key for #"..tostring(Order)) end
      Order = Order + 1
    end
  end
  if(tWhere) then
    while(tWhere[Where]) do
      Val = defTable[tWhere[Where][1]][1]
      if(not IsExistent(Val)) then
        return StatusLog(nil,"SQLStoreQuery: Missing where field key for #"..tostring(Where)) end
      if(Place[Val]) then
        Base = Place
        Place = Place[Val]
      elseif(sQuery) then
        Base = Place
        Place[Val] = {}
        Place = Place[Val]
      else
        return nil
      end
      Val = tWhere[Where][2]
      if(not IsExistent(Val)) then
        return StatusLog(nil,"SQLStoreQuery: Missing where value key for #"..tostring(Where)) end
      if(Place[Val]) then
        Base = Place
        Place = Place[Val]
      elseif(sQuery) then
        Base = Place
        Place[Val] = {}
        Place = Place[Val]
      end
      Where = Where + 1
    end
  end
  if(sQuery) then Base[Val] = sQuery end
  return Base[Val]
end

local function SQLBuildSelect(defTable,tFields,tWhere,tOrderBy)
  if(not defTable) then
    return SQLBuildError("SQLBuildSelect: Missing table definition") end
  if(not (defTable[1][1] and defTable[1][2])) then
    return SQLBuildError("SQLBuildSelect: Missing table "..defTable.Name.." field definitions") end
  local Command = SQLStoreQuery(defTable,tFields,tWhere,tOrderBy)
  if(IsString(Command)) then
    SQLBuildError("")
    return Command
  else Command = "SELECT " end
  local Cnt = 1
  if(tFields) then
    while(tFields[Cnt]) do
      local v = tonumber(tFields[Cnt])
      if(not IsExistent(v)) then
        return SQLBuildError("SQLBuildSelect: Select index NAN {"
             ..type(tFields[Cnt]).."}<"..tostring(tFields[Cnt])
             .."> type mismatch in "..defTable.Name) end
      if(defTable[v]) then
        if(defTable[v][1]) then
          Command = Command..defTable[v][1]
        else
          return SQLBuildError("SQLBuildSelect: Select no such field name by index #"
            ..v.." in the table "..defTable.Name) end
      end
      if(tFields[Cnt+1]) then
        Command = Command ..", "
      end
      Cnt = Cnt + 1
    end
  else
    Command = Command.."*"
  end
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
      k = tonumber(tWhere[Cnt][1])
      v = tWhere[Cnt][2]
      t = defTable[k][2]
      if(not (k and v and t) ) then
        return SQLBuildError("SQLBuildSelect: Where clause inconsistent on "
          ..defTable.Name.." field index, {"..tostring(k)..","..tostring(v)..","..tostring(t)
          .."} value or type in the table definition") end
      v = MatchType(defTable,v,k,true)
      if(not IsExistent(v)) then
        return SQLBuildError("SQLBuildSelect: Data matching failed on "
          ..defTable.Name.." field index #"..Cnt.." value <"..tostring(v)..">") end
      if(Cnt == 1) then
        Command = Command.." WHERE "..defTable[k][1].." = "..v
      else
        Command = Command.." AND "..defTable[k][1].." = "..v
      end
      Cnt = Cnt + 1
    end
  end
  if(tOrderBy and (type(tOrderBy) == "table")) then
    local Dire = ""
    Command = Command.." ORDER BY "
    Cnt = 1
    while(tOrderBy[Cnt]) do
      local v = tOrderBy[Cnt]
      if(v ~= 0) then
        if(v > 0) then
          Dire = " ASC"
        else
          Dire = " DESC"
          v = -v
        end
      else
        return SQLBuildError("SQLBuildSelect: Order wrong for "
                           ..defTable.Name .." field index #"..Cnt) end
        Command = Command..defTable[v][1]..Dire
        if(tOrderBy[Cnt+1]) then
          Command = Command..", "
        end
      Cnt = Cnt + 1
    end
  end
  SQLBuildError("")
  return SQLStoreQuery(defTable,tFields,tWhere,tOrderBy,Command..";")
end

local function SQLBuildInsert(defTable,tInsert,tValues)
  if(not defTable) then
    return SQLBuildError("SQLBuildInsert: Missing Table definition") end
  if(not tValues) then
    return SQLBuildError("SQLBuildInsert: Missing Table value fields") end
  if(not defTable[1]) then
    return SQLBuildError("SQLBuildInsert: The table and the chosen fields must not be empty") end
  if(not (defTable[1][1] and defTable[1][2])) then
    return SQLBuildError("SQLBuildInsert: Missing table "..defTable.Name.." field definition") end
  local tInsert = tInsert or {}
  if(not tInsert[1]) then
    local iCnt = 1
    while(defTable[iCnt]) do
      tInsert[iCnt] = iCnt
      iCnt = iCnt + 1
    end
  end
  local iCnt = 1
  local qVal = " VALUES ( "
  local qIns = "INSERT INTO "..defTable.Name.." ( "
  local Val, iInd, dFld
  while(tInsert[iCnt]) do
    iInd = tInsert[iCnt]
    dFld = defTable[iInd]
    if(not IsExistent(dFld)) then
      return SQLBuildError("SQLBuildInsert: No such field #"..iInd.." on table "..defTable.Name)
    end
    Val = MatchType(defTable,tValues[iCnt],iInd,true)
    if(not IsExistent(Val)) then
      return SQLBuildError("SQLBuildInsert: Cannot match value <"..tostring(tValues[iCnt]).."> #"..iInd.." on table "..defTable.Name)
    end
    qIns = qIns..dFld[1]
    qVal = qVal..Val
    if(tInsert[iCnt+1]) then
      qIns = qIns ..", "
      qVal = qVal ..", "
    else
      qIns = qIns .." ) "
      qVal = qVal .." );"
    end
    iCnt = iCnt + 1
  end
  SQLBuildError("")
  return qIns..qVal
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
  SetOpVar("DEFTABLE_"..sTable,defTable)
  defTable.Size = #defTable
  defTable.Name = GetOpVar("TOOLNAME_PU")..sTable
  local sModeDB = GetOpVar("MODE_DATABASE")
  local sTable  = stringUpper(sTable)
  local symDis  = GetOpVar("OPSYM_DISABLE")
  local iCnt, defField = 1, nil
  while(defTable[iCnt]) do
    defField    = defTable[iCnt]
    defField[3] = DefaultString(tostring(defField[3] or symDis), symDis)
    defField[4] = DefaultString(tostring(defField[4] or symDis), symDis)
    iCnt = iCnt + 1
  end
  libCache[defTable.Name] = {}
  if(sModeDB == "SQL") then
    defTable.Life = tonumber(defTable.Life) or 0
    local tQ = SQLBuildCreate(defTable)
    if(not IsExistent(tQ)) then return StatusLog(false,"CreateTable: "..SQLBuildError()) end
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
      LogInstance("CreateTable: Table "..sTable.." exists!")
      return true
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
  elseif(sModeDB == "LUA") then sModeDB = "LUA" else -- Just to do something here.
    return StatusLog(false,"CreateTable: Wrong database mode <"..sModeDB..">")
  end
end

function InsertRecord(sTable,tData)
  if(not IsExistent(sTable)) then
    return StatusLog(false,"InsertRecord: Missing table name/values")
  end
  if(type(sTable) == "table") then
    tData  = sTable
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
  if(not tData)      then
    return StatusLog(false,"InsertRecord: Missing data table for "..sTable) end
  if(not tData[1])   then
    return StatusLog(false,"InsertRecord: Missing data table is empty for "..sTable) end

  if(sTable == "PIECES") then
    tData[2] = DisableString(tData[2],DefaultType(),"TYPE")
    tData[3] = DisableString(tData[3],ModelToName(tData[1]),"MODEL")
  elseif(sTable == "PHYSPROPERTIES") then
    tData[1] = DisableString(tData[1],DefaultType(),"TYPE")
  end

  local sModeDB = GetOpVar("MODE_DATABASE")
  if(sModeDB == "SQL") then
    local Q = SQLBuildInsert(defTable,nil,tData)
    if(not IsExistent(Q)) then return StatusLog(false,"InsertRecord: Build error <"..SQLBuildError()..">") end
    local qRez = sqlQuery(Q)
    if(not qRez and IsBool(qRez)) then
       return StatusLog(false,"InsertRecord: Failed to insert a record because of <"
              ..sqlLastError().."> Query ran <"..Q..">") end
    return true
  elseif(sModeDB == "LUA") then
    local snPrimaryKey = MatchType(defTable,tData[1],1)
    if(not IsExistent(snPrimaryKey)) then -- If primary key becomes a number
      return StatusLog(nil,"InsertRecord: Cannot match primary key "
                          ..sTable.." <"..tostring(tData[1]).."> to "
                          ..defTable[1][1].." for "..tostring(snPrimaryKey)) end
    local tCache = libCache[defTable.Name]
    if(not IsExistent(tCache)) then
      return StatusLog(false,"InsertRecord: Cache not allocated for "..defTable.Name) end
    if(sTable == "PIECES") then
      local tLine = tCache[snPrimaryKey]
      if(not tLine) then
        tCache[snPrimaryKey] = {}; tLine = tCache[snPrimaryKey] end
      if(not IsExistent(tLine.Type)) then tLine.Type = tData[2] end
      if(not IsExistent(tLine.Name)) then tLine.Name = tData[3] end
      if(not IsExistent(tLine.Kept)) then tLine.Kept = 0        end
      if(not IsExistent(tLine.Slot)) then tLine.Slot = snPrimaryKey end
      local nOffsID = MatchType(defTable,tData[4],4) -- LineID has to be set properly
      if(not IsExistent(nOffsID)) then
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(tData[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimaryKey))
      end
      local stRezul = RegisterPOA(tLine,nOffsID,tData[5],tData[6],tData[7])
      if(not IsExistent(stRezul)) then
        return StatusLog(nil,"InsertRecord: Cannot process offset #"..tostring(nOffsID).." for "..tostring(snPrimaryKey)) end
      if(nOffsID > tLine.Kept) then tLine.Kept = nOffsID else
        return StatusLog(nil,"InsertRecord: Offset #"..tostring(nOffsID).." sequentiality mismatch") end
    elseif(sTable == "ADDITIONS") then
      local tLine = tCache[snPrimaryKey]
      if(not tLine) then
        tCache[snPrimaryKey] = {}; tLine = tCache[snPrimaryKey] end
      if(not IsExistent(tLine.Kept)) then tLine.Kept = 0 end
      if(not IsExistent(tLine.Slot)) then tLine.Slot = snPrimaryKey end
      local nCnt, sFld, nAddID = 2, "", MatchType(defTable,tData[4],4)
      if(not IsExistent(nAddID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(tData[4]).."> to "
                            ..defTable[4][1].." for "..tostring(snPrimaryKey)) end
      tLine[nAddID] = {}
      while(nCnt <= defTable.Size) do
        sFld = defTable[nCnt][1]
        tLine[nAddID][sFld] = MatchType(defTable,tData[nCnt],nCnt)
        if(not IsExistent(tLine[nAddID][sFld])) then  -- ADDITIONS is full of numbers
          return StatusLog(nil,"InsertRecord: Cannot match "
                    ..sTable.." <"..tostring(tData[nCnt]).."> to "
                    ..defTable[nCnt][1].." for "..tostring(snPrimaryKey)) end
        nCnt = nCnt + 1
      end
      tLine.Kept = nAddID
    elseif(sTable == "PHYSPROPERTIES") then
      local sKeyName = GetOpVar("HASH_PROPERTY_NAMES")
      local sKeyType = GetOpVar("HASH_PROPERTY_TYPES")
      local tTypes   = tCache[sKeyType]
      local tNames   = tCache[sKeyName]
      -- Handle the Type
      if(not tTypes) then
        tCache[sKeyType] = {}
        tTypes = tCache[sKeyType]
        tTypes.Kept = 0
      end
      if(not tNames) then
        tCache[sKeyName] = {}
        tNames = tCache[sKeyName]
      end
      local iNameID = MatchType(defTable,tData[2],2)
      if(not IsExistent(iNameID)) then -- LineID has to be set properly
        return StatusLog(nil,"InsertRecord: Cannot match "
                            ..sTable.." <"..tostring(tData[2]).."> to "
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
      tNames[snPrimaryKey][iNameID] = MatchType(defTable,tData[3],3)
    else
      return StatusLog(false,"InsertRecord: No settings for table "..sTable)
    end
  end
end

--------------- TIMER MEMORY MANAGMENT ----------------------------

local function NavigateTable(oLocation,tKeys)
  if(not IsExistent(oLocation)) then
    return StatusLog(nil,"NavigateTable: Location missing") end
  if(not IsExistent(tKeys)) then
    return StatusLog(nil,"NavigateTable: Key table missing") end
  if(not IsExistent(tKeys[1])) then
    return StatusLog(nil,"NavigateTable: First key missing") end
  local oPlace, kKey, iCnt = oLocation, tKeys[1], 1
  while(tKeys[iCnt]) do
    kKey = tKeys[iCnt]
    if(tKeys[iCnt+1]) then
      oPlace = oPlace[kKey]
      if(not IsExistent(oPlace)) then
        return StatusLog(nil,"NavigateTable: Key #"..tostring(kKey).." irrelevant to location") end
    end
    iCnt = iCnt + 1
  end
  return oPlace, kKey
end

function TimerSetting(sTimerSet) -- Generates a timer settings table and keeps the defaults
  if(not IsExistent(sTimerSet)) then
    return StatusLog(nil,"TimerSetting: Timer set missing for setup") end
  if(not IsString(sTimerSet)) then
    return StatusLog(nil,"TimerSetting: Timer set {"..type(sTimerSet).."}<"..tostring(sTimerSet).."> not string") end
  local tBoom = stringExplode(GetOpVar("OPSYM_REVSIGN"),sTimerSet)
  tBoom[1] =   tostring(tBoom[1]  or "CQT")
  tBoom[2] =  (tonumber(tBoom[2]) or 0)
  tBoom[3] = ((tonumber(tBoom[3]) or 0) ~= 0) and true or false
  tBoom[4] = ((tonumber(tBoom[4]) or 0) ~= 0) and true or false
  return tBoom
end

local function TimerAttach(oLocation,tKeys,defTable,anyMessage)
  if(not defTable) then
    return StatusLog(nil,"TimerAttach: Missing table definition") end
  local Place, Key = NavigateTable(oLocation,tKeys)
  if(not (IsExistent(Place) and IsExistent(Key))) then
    return StatusLog(nil,"TimerAttach: Navigation failed") end
  if(not IsExistent(Place[Key])) then
    return StatusLog(nil,"TimerAttach: Data not found") end
  local sModeDB = GetOpVar("MODE_DATABASE")
  LogInstance("TimerAttach: Called by <"..tostring(anyMessage).."> for Place["..tostring(Key).."]")
  if(sModeDB == "SQL") then
    -- Get the proper line count to avoid doing in every caching function"
    if(IsExistent(Place[Key].Kept)) then Place[Key].Kept = Place[Key].Kept - 1 end
    local nNowTM, tTimer = Time(), defTable.Timer -- See that there is a timer and get "now"
    if(not IsExistent(tTimer)) then
      return StatusLog(Place[Key],"TimerAttach: Missing timer settings") end
    Place[Key].Used = nNowTM -- Make the first selected deletable to avoid phantom records
    local nLifeTM = tTimer[2]
    if(nLifeTM <= 0) then
      return StatusLog(Place[Key],"TimerAttach: Timer attachment ignored") end
    local sModeTM, bKillRC, bCollGB = tTimer[1], tTimer[3], tTimer[4]
    LogInstance("TimerAttach: ["..sModeTM.."] ("..tostring(nLifeTM)..") "..tostring(bKillRC)..", "..tostring(bCollGB))
    if(sModeTM == "CQT") then
      Place[Key].Load = nNowTM
      for k, v in pairs(Place) do
        if(IsExistent(v.Load) and IsExistent(v.Used) and  ((nNowTM - v.Used) > nLifeTM)) then
          LogInstance("TimerAttach: ("..tostring(RoundValue(nNowTM - v.Used,0.01)).." > "..tostring(nLifeTM)..") > Dead")
          if(bKillRC) then
            LogInstance("TimerAttach: Killed <"..tostring(k)..">")
            Place[k] = nil
          end
        end
      end
      if(bCollGB) then
        collectgarbage()
        LogInstance("TimerAttach: Garbage collected")
      end
      return StatusLog(Place[Key],"TimerAttach: Place["..tostring(Key).."].Load = "..tostring(RoundValue(nNowTM,0.01)))
    elseif(sModeTM == "OBJ") then
      local TimerID = stringImplode(GetOpVar("OPSYM_DIVIDER"),tKeys)
      LogInstance("TimerAttach: TimID <"..TimerID..">")
      if(timerExists(TimerID)) then return StatusLog(Place[Key],"TimerAttach: Timer exists") end
      timerCreate(TimerID, nLifeTM, 1, function()
        LogInstance("TimerAttach["..TimerID.."]("..nLifeTM..") > Dead")
        if(bKillRC) then
          LogInstance("TimerAttach: Killed <"..Key..">")
          Place[Key] = nil
        end
        timerStop(TimerID)
        timerDestroy(TimerID)
        if(bCollGB) then
          collectgarbage()
          LogInstance("TimerAttach: Garbage collected")
        end
      end)
      timerStart(TimerID)
      return Place[Key]
    else
      return StatusLog(Place[Key],"TimerAttach: Timer mode not found <"..sModeTM..">")
    end
  elseif(sModeDB == "LUA") then
    return StatusLog(Place[Key],"TimerAttach: Memory manager not available")
  else
    return StatusLog(nil,"TimerAttach: Wrong database mode")
  end
end

local function TimerRestart(oLocation,tKeys,defTable,anyMessage)
  if(not defTable) then
    return StatusLog(nil,"TimerRestart: Missing table definition") end
  local Place, Key = NavigateTable(oLocation,tKeys)
  if(not (IsExistent(Place) and IsExistent(Key))) then
    return StatusLog(nil,"TimerRestart: Navigation failed") end
  if(not IsExistent(Place[Key])) then
    return StatusLog(nil,"TimerRestart: Place not found") end
  local sModeDB = GetOpVar("MODE_DATABASE")
  if(sModeDB == "SQL") then
    local tTimer = defTable.Timer
    if(not IsExistent(tTimer)) then
      return StatusLog(Place[Key],"TimerRestart: Missing timer settings") end
    Place[Key].Used = Time()
    local nLifeTM = tTimer[2]
    if(nLifeTM <= 0) then
      return StatusLog(Place[Key],"TimerRestart: Timer life ignored") end
    local sModeTM = tTimer[1]
    if(sModeTM == "CQT") then
      sModeTM = "CQT" -- Just for something to do here and to be known that this is mode CQT
    elseif(sModeTM == "OBJ") then
      local keyTimerID = stringImplode(GetOpVar("OPSYM_DIVIDER"),tKeys)
      if(not timerExists(keyTimerID)) then
        return StatusLog(nil,"TimerRestart: Timer missing <"..keyTimerID..">") end
      timerStart(keyTimerID)
    else return StatusLog(nil,"TimerRestart: Timer mode not found <"..sModeTM..">") end
  elseif(sModeDB == "LUA") then Place[Key].Used = Time()
  else return StatusLog(nil,"TimerRestart: Wrong database mode") end
  return Place[Key]
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
  end; Box.Ang[caY] = (tonumber(nRot) or 0) * Time()
  return Box
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
      LogInstance("CacheQueryPiece: Model >> Pool <"..stringToFileName(sModel)..">")
      tCache[sModel] = {}; stPiece = tCache[sModel]; stPiece.Kept = 0
      local Q = SQLBuildSelect(defTable,nil,{{1,sModel}},{4})
      if(not IsExistent(Q)) then
        return StatusLog(nil,"CacheQueryPiece: Build error <"..SQLBuildError()..">") end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        return StatusLog(nil,"CacheQueryPiece: SQL exec error <"..sqlLastError()..">") end
      if(not (qData and qData[1])) then
        return StatusLog(nil,"CacheQueryPiece: No data found <"..Q..">") end
      stPiece.Kept = 1 --- Found at least one record
      stPiece.Slot = sModel
      stPiece.Type = qData[1][defTable[2][1]]
      stPiece.Name = qData[1][defTable[3][1]]
      local qRec, qRez
      while(qData[stPiece.Kept]) do
        qRec = qData[stPiece.Kept]
        qRez = RegisterPOA(stPiece,
                           stPiece.Kept,
                           qRec[defTable[5][1]],
                           qRec[defTable[6][1]],
                           qRec[defTable[7][1]])
        if(not IsExistent(qRez)) then
          return StatusLog(nil,"CacheQueryPiece: Cannot process offset #"..tostring(stPiece.Kept).." for <"..sModel..">")
        end
        stPiece.Kept = stPiece.Kept + 1
      end
      return TimerAttach(libCache,caInd,defTable,"CacheQueryPiece")
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
      LogInstance("CacheQueryAdditions: Model >> Pool <"..stringToFileName(sModel)..">")
      tCache[sModel] = {}; stAddition = tCache[sModel]; stAddition.Kept = 0
      local Q = SQLBuildSelect(defTable,{2,3,4,5,6,7,8,9,10,11,12},{{1,sModel}},{4})
      if(not IsExistent(Q)) then
        return StatusLog(nil,"CacheQueryAdditions: Build error <"..SQLBuildError()..">") end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        return StatusLog(nil,"CacheQueryAdditions: SQL exec error <"..sqlLastError()..">") end
      if(not (qData and qData[1])) then
        return StatusLog(nil,"CacheQueryAdditions: No data found <"..Q..">") end
      stAddition.Kept = 1
      stAddition.Slot = sModel
      while(qData[stAddition.Kept]) do
        local qRec = qData[stAddition.Kept]
        stAddition[stAddition.Kept] = {}
        for Field, Val in pairs(qRec) do
          stAddition[stAddition.Kept][Field] = Val
        end
        stAddition.Kept = stAddition.Kept + 1
      end
      return TimerAttach(libCache,caInd,defTable,"CacheQueryAdditions")
    elseif(sModeDB == "LUA") then return StatusLog(nil,"CacheQueryAdditions: Record not located")
    else return StatusLog(nil,"CacheQueryAdditions: Wrong database mode <"..sModeDB..">") end
  end
end

----------------------- PANEL QUERY -------------------------------

--- Used to Populate the CPanel Tree
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
      local Q = SQLBuildSelect(defTable,{1,2,3},{{4,1}},{2,3})
      if(not IsExistent(Q)) then
        return StatusLog(nil,"CacheQueryPanel: Build error: <"..SQLBuildError()..">") end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        return StatusLog(nil,"CacheQueryPanel: SQL exec error <"..sqlLastError()..">") end
      if(not (qData and qData[1])) then
        return StatusLog(nil,"CacheQueryPanel: No data found <"..Q..">") end
      stPanel.Kept = 1
      while(qData[stPanel.Kept]) do
        stPanel[stPanel.Kept] = qData[stPanel.Kept]
        stPanel.Kept = stPanel.Kept + 1
      end
      return TimerAttach(libCache,caInd,defTable,"CacheQueryPanel")
    elseif(sModeDB == "LUA") then
      local tCache = libCache[defTable.Name]
      local tData = {}
      local iNdex = 0
      for sModel, tRecord in pairs(tCache) do
        tData[sModel] = {
          [defTable[1][1]] = sModel,
          [defTable[2][1]] = tRecord.Type,
          [defTable[3][1]] = tRecord.Name
        }
      end
      local tSorted = Sort(tData,nil,{defTable[2][1],defTable[3][1]})
      if(not tSorted) then
        return StatusLog(nil,"CacheQueryPanel: Cannot sort cache data") end
      iNdex = 1
      while(tSorted[iNdex]) do
        stPanel[iNdex] = tData[tSorted[iNdex].Key]
        iNdex = iNdex + 1
      end
      return stPanel
    else return StatusLog(nil,"CacheQueryPanel: Wrong database mode <"..sModeDB..">") end
    LogInstance("CacheQueryPanel: To Pool")
  end
end

--- Used to Populate the CPanel Phys Materials
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
      tCache[keyName] = {}; arNames = tCache[keyName]
    end
    local stName = arNames[sType]
    if(IsExistent(stName) and IsExistent(stName.Kept)) then
      LogInstance("CacheQueryProperty["..sType.."]: Names << Pool")
      if(stName.Kept > 0) then
        return TimerRestart(libCache,caInd,defTable,"CacheQueryProperty") end
      return nil
    else
      if(sModeDB == "SQL") then
        arNames[sType] = {}; stName = arNames[sType]; stName.Kept = 0
        local Q = SQLBuildSelect(defTable,{3},{{1,sType}},{2})
        if(not IsExistent(Q)) then
          return StatusLog(nil,"CacheQueryProperty["..sType.."]: Build error: <"..SQLBuildError()..">") end
        local qData = sqlQuery(Q)
        if(not qData and IsBool(qData)) then
          return StatusLog(nil,"CacheQueryProperty: SQL exec error <"..sqlLastError()..">") end
        if(not (qData and qData[1])) then
          return StatusLog(nil,"CacheQueryProperty["..sType.."]: No data found <"..Q..">") end
        stName.Kept = 1
        stName.Slot = sType
        while(qData[stName.Kept]) do
          stName[stName.Kept] = qData[stName.Kept][defTable[3][1]]
          stName.Kept = stName.Kept + 1
        end
        LogInstance("CacheQueryProperty["..sType.."]: Names >> Pool")
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
        local Q = SQLBuildSelect(defTable,{1},{{2,1}},{1})
        if(not IsExistent(Q)) then
          return StatusLog(nil,"CacheQueryProperty: Build error: <"..SQLBuildError()..">") end
        local qData = sqlQuery(Q)
        if(not qData and IsBool(qData)) then
          return StatusLog(nil,"CacheQueryProperty: SQL exec error <"..sqlLastError()..">") end
        if(not (qData and qData[1])) then
          return StatusLog(nil,"CacheQueryProperty: No data found <"..Q..">") end
        stType.Kept = 1
        while(qData[stType.Kept]) do
          stType[stType.Kept] = qData[stType.Kept][defTable[1][1]]
          stType.Kept = stType.Kept + 1
        end
        LogInstance("CacheQueryProperty: Types >> Pool")
        return TimerAttach(libCache,caInd,defTable,"CacheQueryProperty")
      elseif(sModeDB == "LUA") then return StatusLog(nil,"CacheQueryProperty: Record not located")
      else return StatusLog(nil,"CacheQueryProperty: Wrong database mode <"..sModeDB..">") end
    end
  end
end

---------------------- EXPORT --------------------------------

local function GetFieldsName(defTable,sDelim)
  if(not IsExistent(sDelim)) then return "" end
  local sDelim  = stringSub(tostring(sDelim),1,1)
  local sResult = ""
  if(IsEmptyString(sDelim)) then
    return StatusLog("","GetFieldsName: Invalid delimiter for <"..defTable.Name..">") end
  local iCount  = 1
  local namField
  while(defTable[iCount]) do
    namField = defTable[iCount][1]
    if(not IsString(namField)) then
      return StatusLog("","GetFieldsName: Field #"..iCount
               .." {"..type(namField).."}<"..tostring(namField).."> not string") end
    sResult = sResult..namField
    if(defTable[iCount + 1]) then sResult = sResult..sDelim end
    iCount = iCount + 1
  end
  return sResult
end

--[[
 * Save/Load the DB Using Excel or
 * anything that supports delimiter
 * separated digital tables
 * sPrefix = Something that separates exported table from the rest ( e.g. db_ )
 * sTable  = Definition KEY to export to
 * sDelim  = Delimiter CHAR data separator
 * bCommit = true to insert the read values
]]--
function ImportDSV(sTable,sDelim,bCommit,sPrefix)
  if(not IsString(sTable)) then
    return StatusLog(false,"ImportDSV: Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ImportDSV: Missing table definition for <"..sTable..">") end
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..tostring(sPrefix or GetInstPref())..defTable.Name..".txt"
  local F = fileOpen(fName, "r", "DATA")
  if(not F) then return StatusLog(false,"ImportDSV: fileOpen("..fName..".txt) Failed") end
  local symOff = GetOpVar("OPSYM_DISABLE")
  local tabLen = stringLen(defTable.Name)
  local sLine, sChar, lenLine = "", "X", 0
  while(sChar) do
    sChar = F:Read(1)
    if(not sChar) then return end
    if(sChar == "\n") then
      lenLine = stringLen(sLine)
      if(stringSub(sLine,lenLine,lenLine) == "\r") then
        sLine = stringSub(sLine,1,lenLine-1)
        lenLine = lenLine - 1
      end
      if((stringSub(sLine,1,1) ~= symOff) and (stringSub(sLine,1,tabLen) == defTable.Name)) then
        local Data = stringExplode(sDelim,stringSub(sLine,tabLen+2,lenLine))
        for k,v in pairs(Data) do
          local vLen = stringLen(v)
          if(stringSub(v,1,1) == "\"" and stringSub(v,vLen,vLen) == "\"") then
            Data[k] = stringSub(v,2,vLen-1)
          end
        end
        if(bCommit) then InsertRecord(sTable,Data) end
      end
      sLine = ""
    else sLine = sLine..sChar end
  end
  F:Close()
end

function DeleteExternalDatabase(sTable,sMethod,sPrefix)
  if(not IsString(sTable)) then
    return StatusLog(false,"DeleteExternalDatabase: Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  if(not IsString(sMethod)) then
    return StatusLog(false,"DeleteExternalDatabase: Delete method {"..type(sMethod).."}<"..tostring(sMethod).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"DeleteExternalDatabase: Missing table definition for <"..sTable..">") end
  local fName = GetOpVar("DIRPATH_BAS")
  if(not GetOpVar("DIRPATH_"..sMethod)) then
    return StatusLog(false,"DeleteExternalDatabase: Directory index <"..sMethod.."> missing") end
  fName = fName..GetOpVar("DIRPATH_"..sMethod) 
  fName = fName..tostring(sPrefix or GetInstPref())..defTable.Name..".txt"
  if(not fileExists(fName,"DATA")) then
    return StatusLog(true,"DeleteExternalDatabase: File <"..fName.."> missing") end
  fileDelete(fName)
  return StatusLog(true,"DeleteExternalDatabase: Success")
end

function StoreExternalDatabase(sTable,sDelim,sMethod,sPrefix)
  if(not IsString(sTable)) then
    return StatusLog(false,"StoreExternalDatabase: Table {"..type(sTable).."}<"..tostring(sTable).."> not string") end
  if(not IsString(sMethod)) then
    return StatusLog(false,"StoreExternalDatabase: Export mode {"..type(sMethod).."}<"..tostring(sMethod).."> not string") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"StoreExternalDatabase: Missing table definition for <"..sTable..">") end
  local fName = GetOpVar("DIRPATH_BAS")
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  if(not GetOpVar("DIRPATH_"..sMethod)) then
    return StatusLog(false,"StoreExternalDatabase: Directory index <"..sMethod.."> missing") end
  fName = fName..GetOpVar("DIRPATH_"..sMethod)
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..tostring(sPrefix or GetInstPref())..defTable.Name..".txt"
  local F = fileOpen(fName, "w", "DATA" )
  if(not F) then return StatusLog(false,"StoreExternalDatabase: fileOpen("..fName..") Failed") end
  local sData, sTemp = "", ""
  local sModeDB, symOff = GetOpVar("MODE_DATABASE"), GetOpVar("OPSYM_DISABLE")
  F:Write("# StoreExternalDatabase( "..sMethod.." ): "..osDate().." [ "..sModeDB.." ]".."\n")
  F:Write("# Data settings: "..GetFieldsName(defTable,sDelim).."\n")
  if(sModeDB == "SQL") then
    local Q = ""
    if    (sTable == "PIECES"        ) then Q = SQLBuildSelect(defTable,nil,nil,{2,3,1,4})
    elseif(sTable == "ADDITIONS"     ) then Q = SQLBuildSelect(defTable,nil,nil,{1,4})
    elseif(sTable == "PHYSPROPERTIES") then Q = SQLBuildSelect(defTable,nil,nil,{1,2})
    else                                    Q = SQLBuildSelect(defTable,nil,nil,nil) end
    if(not IsExistent(Q)) then return StatusLog(false,"StoreExternalDatabase: Build error <"..SQLBuildError()..">") end
    F:Write("# Query ran: <"..Q..">\n")
    local qData = sqlQuery(Q)
    if(not qData and IsBool(qData)) then
      return StatusLog(nil,"StoreExternalDatabase: SQL exec error <"..sqlLastError()..">") end
    if(not (qData and qData[1])) then
      return StatusLog(false,"StoreExternalDatabase: No data found <"..Q..">") end
    local iCnt, iInd, qRec = 1, 1, nil
    if    (sMethod == "DSV") then sData = defTable.Name..sDelim
    elseif(sMethod == "INS") then sData = "  asmlib.InsertRecord(\""..sTable.."\", {" end
    while(qData[iCnt]) do
      iInd  = 1
      sTemp = sData
      qRec  = qData[iCnt]
      while(defTable[iInd]) do -- The data is already inserted, so matching will not crash
        sTemp = sTemp..MatchType(defTable,qRec[defTable[iInd][1]],iInd,true,"\"",true)
        if(defTable[iInd + 1]) then sTemp = sTemp..sDelim end
        iInd = iInd + 1
      end
      if    (sMethod == "DSV") then sTemp = sTemp.."\n"
      elseif(sMethod == "INS") then sTemp = sTemp.."})\n" end
      F:Write(sTemp)
      iCnt = iCnt + 1
    end
  elseif(sModeDB == "LUA") then
    local tCache = libCache[defTable.Name]
    if(not IsExistent(tCache)) then
      return StatusLog(false,"StoreExternalDatabase: Table <"..defTable.Name.."> cache not allocated") end
    if(sTable == "PIECES") then
      local tData = {}
      for sModel, tRecord in pairs(tCache) do
        sData = tRecord.Type..tRecord.Name..sModel
        tData[sModel] = {[defTable[1][1]] = sData}
      end
      local tSorted = Sort(tData,nil,{defTable[1][1]})
      if(not tSorted) then
        return StatusLog(false,"StoreExternalDatabase: Cannot sort cache data") end
      local iInd iNdex = 1, 1
      while(tSorted[iNdex]) do
        iInd  = 1
        tData = tCache[tSorted[iNdex].Key]
        if    (sMethod == "DSV") then sData = defTable.Name..sDelim
        elseif(sMethod == "INS") then sData = "  asmlib.InsertRecord(\""..sTable.."\", {" end
        sData = sData..MatchType(defTable,tSorted[iNdex].Key,1,true,"\"")..sDelim..
                       MatchType(defTable,tData.Type,2,true,"\"")..sDelim..
                       MatchType(defTable,((ModelToName(tSorted[iNdex].Key) == tData.Name) and symOff or tData.Name),3,true,"\"")..sDelim
        -- Matching crashes only for numbers
        while(tData.Offs[iInd]) do -- The number is already inserted, so there will be no crash
          sTemp = sData..MatchType(defTable,iInd,4,true,"\"")..sDelim..
                        "\""..(IsEqualPOA(tData.Offs[iInd].P,tData.Offs[iInd].O) and "" or StringPOA(tData.Offs[iInd].P,"V")).."\""..sDelim..
                        "\""..  StringPOA(tData.Offs[iInd].O,"V").."\""..sDelim..
                        "\""..( IsZeroPOA(tData.Offs[iInd].A,"A") and "" or StringPOA(tData.Offs[iInd].A,"A")).."\""
          if    (sMethod == "DSV") then sTemp = sTemp.."\n"
          elseif(sMethod == "INS") then sTemp = sTemp.."})\n" end
          F:Write(sTemp)
          iInd = iInd  + 1
        end
        iNdex = iNdex + 1
      end
    elseif(sTable == "ADDITIONS") then
      local iNdex, tData
      for sModel, tRecord in pairs(tCache) do
        if    (sMethod == "DSV") then sData = defTable.Name..sDelim..sModel..sDelim
        elseif(sMethod == "INS") then sData = "  asmlib.InsertRecord(\""..sTable.."\", {" end
        iNdex = 1
        while(tRecord[iNdex]) do -- Data is already inserted, there will be no crash
          tData = tRecord[iNdex]
          sTemp = sData..MatchType(defTable,tData[defTable[2 ][1]],2 ,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[3 ][1]],3 ,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[4 ][1]],4 ,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[5 ][1]],5 ,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[6 ][1]],6 ,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[7 ][1]],7 ,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[8 ][1]],8 ,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[9 ][1]],9 ,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[10][1]],10,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[11][1]],11,true,"\"")..sDelim..
                         MatchType(defTable,tData[defTable[12][1]],12,true,"\"")
          if    (sMethod == "DSV") then sTemp = sTemp.."\n"
          elseif(sMethod == "INS") then sTemp = sTemp.."})\n" end
          F:Write(sTemp)
          iNdex = iNdex + 1
        end
      end
    elseif(sTable == "PHYSPROPERTIES") then
      local tTypes = tCache[GetOpVar("HASH_PROPERTY_TYPES")]
      local tNames = tCache[GetOpVar("HASH_PROPERTY_NAMES")]
      if(not (tTypes or tNames)) then
        return StatusLog(false,"StoreExternalDatabase: No data found") end
      local tType
      local iInd , iCnt  = 1 , 1
      local sType, sName = "", ""
      while(tTypes[iInd]) do
        sType = tTypes[iInd]
        tType = tNames[sType]
        if(not tType) then return
          StatusLog(false,"StoreExternalDatabase: Missing index #"..iInd.." on type <"..sType..">") end
        if    (sMethod == "DSV") then sData = defTable.Name..sDelim
        elseif(sMethod == "INS") then sData = "  asmlib.InsertRecord(\""..sTable.."\", {" end
        iCnt = 1
        while(tType[iCnt]) do -- The number is already inserted, there will be no crash
          sTemp = sData..MatchType(defTable,sType      ,1,true,"\"")..sDelim..
                         MatchType(defTable,iCnt       ,2,true,"\"")..sDelim..
                         MatchType(defTable,tType[iCnt],3,true,"\"")
          if    (sMethod == "DSV") then sTemp = sTemp.."\n"
          elseif(sMethod == "INS") then sTemp = sTemp.."})\n" end
          F:Write(sTemp)
          iCnt = iCnt + 1
        end
        iInd = iInd + 1
      end
    end
  end
  F:Flush()
  F:Close()
end

----------------------------- SNAPPING ------------------------------

--[[
 * This function calculates the cross product normal angle of
 * a player by a given trace. If the trace is missing it takes player trace
 * It has options for snap to surface and yaw snap
 * oPly          = The player we need the normal angle from
 * oTrace        = A trace structure if nil, it takes oPly's
 * nSnap         = Snap to the trace surface flag
 * nYSnap        = Yaw snap amount
]]--
function GetNormalAngle(oPly, oTrace, nSnap, nYSnap)
  local aAng = Angle()
  if(not oPly) then return aAng end
  local nSnap = tonumber(nSnap) or 0
  if(nSnap and (nSnap ~= 0)) then -- Snap to the surface
    local oTrace = oTrace
    if(not (oTrace and oTrace.Hit)) then
      oTrace = utilTraceLine(utilGetPlayerTrace(oPly))
      if(not (oTrace and oTrace.Hit)) then return aAng end
    end
    local vLeft = -oPly:GetAimVector():Angle():Right()
    aAng:Set(vLeft:Cross(oTrace.HitNormal):AngleEx(oTrace.HitNormal))
  else -- Get only the player yaw, pitch and roll are not needed
    local nYSnap = tonumber(nYSnap) or 0
    if(nYSnap and (nYSnap >= 0) and (nYSnap <= GetOpVar("MAX_ROTATION"))) then
      aAng[caY] = SnapValue(oPly:GetAimVector():Angle()[caY],nYSnap)
    end
  end
  return aAng
end

--[[
 * This function is the backbone of the tool snapping and spawning.
 * Anything related to dealing with the track assembly database
 * Calculates SPos, SAng based on the DB inserts and input parameters
 * ucsPos        = Base UCS Pos
 * ucsAng        = Base UCS Ang
 * shdModel      = Client Model
 * ivhdPointID   = Client Point ID
 * ucsPos(X,Y,Z) = Offset position
 * ucsAng(P,Y,R) = Offset angle
]]--
function GetNormalSpawn(ucsPos,ucsAng,shdModel,ivhdPointID,ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
  local hdRec = CacheQueryPiece(shdModel)
  if(not IsExistent(hdRec)) then
    return StatusLog(nil,"GetNormalSpawn: No record located") end
  local ihdPointID = tonumber(ivhdPointID)
  if(not IsExistent(ihdPointID)) then
    return StatusLog(nil,"GetNormalSpawn: Index NAN {"..type(ivhdPointID).."}<"..tostring(ivhdPointID)..">") end
  local hdPOA = LocatePOA(hdRec,ihdPointID)
  if(not IsExistent(hdPOA)) then
    return StatusLog(nil,"GetNormalSpawn: Holder point ID invalid #"..tostring(ihdPointID)) end
  local stSpawn = GetOpVar("STRUCT_SPAWN"); stSpawn.HRec = hdRec
  if(ucsPos) then SetVector(stSpawn.OPos,ucsPos) end
  if(ucsAng) then SetAngle (stSpawn.OAng,ucsAng) end
  -- Initialize F, R, U Copy the UCS like that to support database POA
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  stSpawn.OAng:RotateAroundAxis(stSpawn.R, (tonumber(ucsAngP) or 0))
  stSpawn.OAng:RotateAroundAxis(stSpawn.U,-(tonumber(ucsAngY) or 0))
  stSpawn.F:Set(stSpawn.OAng:Forward())
  stSpawn.OAng:RotateAroundAxis(stSpawn.F, (tonumber(ucsAngR) or 0))
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
  stSpawn.SPos:Add((hdPOA.O[csA] * stSpawn.HPos[cvX] + (tonumber(ucsPosX) or 0)) * stSpawn.F)
  stSpawn.SPos:Add((hdPOA.O[csB] * stSpawn.HPos[cvY] + (tonumber(ucsPosY) or 0)) * stSpawn.R)
  stSpawn.SPos:Add((hdPOA.O[csC] * stSpawn.HPos[cvZ] + (tonumber(ucsPosZ) or 0)) * stSpawn.U)
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
function GetEntitySpawn(trEnt,trHitPos,shdModel,ivhdPointID,
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
  if(not IsExistent(trRec.Type)) then
    return StatusLog(nil,"GetEntitySpawn: Trace type missing") end
  if(not IsExistent(hdRec.Type)) then
    return StatusLog(nil,"GetEntitySpawn: Holder type missing") end
  -- If the types are different and disabled
  if((not enIgnTyp or enIgnTyp == 0) and trRec.Type ~= hdRec.Type ) then
    return StatusLog(nil,"GetEntitySpawn: Types are different") end
  -- We have the next Piece Offset
  local vTemp = Vector()
  local stSpawn, trPOA = GetOpVar("STRUCT_SPAWN")
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
      SetVector(vTemp,stPOA.P)
      vTemp[cvX] = vTemp[cvX] * stPOA.P[csA]
      vTemp[cvY] = vTemp[cvY] * stPOA.P[csB]
      vTemp[cvZ] = vTemp[cvZ] * stPOA.P[csC]
      vTemp:Rotate(stSpawn.TAng)
      vTemp:Add(stSpawn.TPos)
      vTemp:Sub(trHitPos)
      local trAcDis = vTemp:Length()
      if(trAcDis < stSpawn.RLen) then
        trPOA        = stPOA
        stSpawn.TID  = ID
        stSpawn.RLen = trAcDis
        stSpawn.TPnt:Set(vTemp)
        stSpawn.TPnt:Add(trHitPos)
      end
    end
  end
  if(not IsExistent(trPOA)) then
    return StatusLog(nil,"GetEntitySpawn: Not hitting active point") end
  -- Found the active point ID on trEnt. Initialize origins
  SetVector(stSpawn.OPos,trPOA.O) -- Use {0,0,0} for disabled A (Angle)
  if(trPOA.A[csD]) then SetAnglePYR(stSpawn.OAng) else SetAngle(stSpawn.OAng,trPOA.A) end
  stSpawn.OPos:Rotate(stSpawn.TAng)
  stSpawn.OPos:Add(stSpawn.TPos)
  stSpawn.OAng:Set(trEnt:LocalToWorldAngles(stSpawn.OAng))
  -- Do the flatten flag right now Its important !
  if(enFlatten and enFlatten ~= 0) then
    stSpawn.OAng[caP] = 0; stSpawn.OAng[caR] = 0
  end
  return GetNormalSpawn(nil,nil,shdModel,ihdPointID,ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
end

function AttachAdditions(ePiece)
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"AttachAdditions: Piece invalid") end
  local LocalAng = ePiece:GetAngles()
  local LocalPos = ePiece:GetPos()
  local LocalMod = ePiece:GetModel()
  local stAddition = CacheQueryAdditions(LocalMod)
  if(not IsExistent(stAddition)) then
    return StatusLog(true,"AttachAdditions: Model <"..LocalMod.."> has no additions") end
  LogInstance("AttachAdditions: Called for model <"..LocalMod..">")
  local Cnt = 1
  local defTable = GetOpVar("DEFTABLE_ADDITIONS")
  while(stAddition[Cnt]) do
    local Record = stAddition[Cnt]
    LogInstance("\n\nEnt [ "..Record[defTable[4][1]].." ] INFO : ")
    local Addition = entsCreate(Record[defTable[3][1]])
    if(Addition and Addition:IsValid()) then
      LogInstance("Addition Class: "..Record[defTable[3][1]])
      if(fileExists(Record[defTable[2][1]], "GAME")) then
        Addition:SetModel(Record[defTable[2][1]])
        LogInstance("Addition:SetModel("..Record[defTable[2][1]]..")")
      else return StatusLog(false,"AttachAdditions: No such attachment model "..Record[defTable[2][1]]) end
      local OffPos = Record[defTable[5][1]]
      if(not IsString(OffPos)) then
        return StatusLog(false,"AttachAdditions: Position {"..type(OffPos).."}<"..tostring(OffPos).."> not string") end
      if(OffPos and OffPos ~= "" and OffPos ~= "NULL") then
        local AdditionPos = Vector()
        local arConv = DecodePOA(OffPos)
        arConv[1] = arConv[1] * arConv[4]
        arConv[2] = arConv[2] * arConv[5]
        arConv[3] = arConv[3] * arConv[6]
        AdditionPos:Set(LocalPos)
        AdditionPos:Add(arConv[1] * LocalAng:Forward())
        AdditionPos:Add(arConv[2] * LocalAng:Right())
        AdditionPos:Add(arConv[3] * LocalAng:Up())
        Addition:SetPos(AdditionPos)
        LogInstance("Addition:SetPos(AdditionPos)")
      else
        Addition:SetPos(LocalPos)
        LogInstance("Addition:SetPos(LocalPos)")
      end
      local OffAng = Record[defTable[6][1]]
      if(not IsString(OffAng)) then
        return StatusLog(false,"AttachAdditions: Angle {"..type(OffAng).."}<"..tostring(OffAng).."> not string") end
      if(OffAng and OffAng ~= "" and OffAng ~= "NULL") then
        local AdditionAng = Angle()
        local arConv = DecodePOA(OffAng)
        AdditionAng[caP] = arConv[1] * arConv[4] + LocalAng[caP]
        AdditionAng[caY] = arConv[2] * arConv[5] + LocalAng[caY]
        AdditionAng[caR] = arConv[3] * arConv[6] + LocalAng[caR]
        Addition:SetAngles(AdditionAng)
        LogInstance("Addition:SetAngles(AdditionAng)")
      else
        Addition:SetAngles(LocalAng)
        LogInstance("Addition:SetAngles(LocalAng)")
      end
      local MoveType = (tonumber(Record[defTable[7][1]]) or -1)
      if(MoveType >= 0) then
        Addition:SetMoveType(MoveType)
        LogInstance("Addition:SetMoveType("..MoveType..")")
      end
      local PhysInit = (tonumber(Record[defTable[8][1]]) or -1)
      if(PhysInit >= 0) then
        Addition:PhysicsInit(PhysInit)
        LogInstance("Addition:PhysicsInit("..PhysInit..")")
      end
      if((tonumber(Record[defTable[9][1]]) or -1) >= 0) then
        Addition:DrawShadow(false)
        LogInstance("Addition:DrawShadow(false)")
      end
      Addition:SetParent( ePiece )
      LogInstance("Addition:SetParent(ePiece)")
      Addition:Spawn()
      LogInstance("Addition:Spawn()")
      phAddition = Addition:GetPhysicsObject()
      if(phAddition and phAddition:IsValid()) then
        if((tonumber(Record[defTable[10][1]]) or -1) >= 0) then
          phAddition:EnableMotion(false)
          LogInstance("phAddition:EnableMotion(false)")
        end
        if((tonumber(Record[defTable[11][1]]) or -1) >= 0) then
          phAddition:Sleep()
          LogInstance("phAddition:Sleep()")
        end
      end
      Addition:Activate()
      LogInstance("Addition:Activate()")
      ePiece:DeleteOnRemove(Addition)
      LogInstance("ePiece:DeleteOnRemove(Addition)")
      local Solid = (tonumber(Record[defTable[12][1]]) or -1)
      if(Solid >= 0) then
        Addition:SetSolid(Solid)
        LogInstance("Addition:SetSolid("..Solid..")")
      end
    else
      return StatusLog(false,"Failed to allocate Addition #"..Cnt.." memory:"
          .."\n     Modelbse: "..stAddition[Cnt][defTable[1][1]]
          .."\n     Addition: "..stAddition[Cnt][defTable[2][1]]
          .."\n     ENTclass: "..stAddition[Cnt][defTable[3][1]])
    end
    Cnt = Cnt + 1
  end
  return StatusLog(true,"AttachAdditions: Success")
end

local function GetEntityOrTrace(oEnt)
  if(oEnt and oEnt:IsValid()) then return oEnt end
  local Ply = LocalPlayer()
  if(not IsExistent(Ply)) then
    return StatusLog(nil,"GetEntityOrTrace: Player missing") end
  local Trace = Ply:GetEyeTrace()
  if(not IsExistent(Trace)) then
    return StatusLog(nil,"GetEntityOrTrace: Trace missing") end
  if(not Trace.Hit) then -- Boolean
    return StatusLog(nil,"GetEntityOrTrace: Trace not hit") end
  if(Trace.HitWorld) then -- Boolean
    return StatusLog(nil,"GetEntityOrTrace: Trace hit world") end
  local trEnt = Trace.Entity
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
  end
  sRez = stringSub(sRez,2,-1)
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
  local IDs = stringExplode(GetOpVar("OPSYM_SEPARATOR"),sBgrpIDs)
  while(BGs[iCnt] and IDs[iCnt]) do
    local itrBG = BGs[iCnt]
    local maxID = (ePiece:GetBodygroupCount(itrBG.id) - 1)
    local itrID = mathClamp(mathFloor(tonumber(IDs[iCnt]) or 0),0,maxID)
    LogInstance("ePiece:SetBodygroup("..tostring(itrBG.id)..","..tostring(itrID)..") ["..tostring(maxID).."]")
    ePiece:SetBodygroup(itrBG.id,itrID)
    iCnt = iCnt + 1
  end
  return StatusLog(true,"AttachBodyGroups: Success")
end

function MakePiece(sModel,vPos,aAng,nMass,sBgSkIDs,clColor)
  if(CLIENT) then return StatusLog(nil,"MakePiece: Working on client") end
  local stPiece = CacheQueryPiece(sModel)
  if(not IsExistent(stPiece)) then
    return StatusLog(nil,"MakePiece: Record missing <"..sModel..">") end
  local ePiece = entsCreate("prop_physics")
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(nil,"MakePiece: Entity invalid") end
  ePiece:SetCollisionGroup(COLLISION_GROUP_NONE)
  ePiece:SetSolid(SOLID_VPHYSICS)
  ePiece:SetMoveType(MOVETYPE_VPHYSICS)
  ePiece:SetNotSolid(false)
  ePiece:SetModel(sModel)
  ePiece:SetPos(vPos or GetOpVar("VEC_ZERO"))
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
  phPiece:EnableMotion(false)
  phPiece:SetMass(mathClamp(tonumber(nMass) or 1,1,GetOpVar("MAX_MASS")))
  local BgSk = stringExplode(GetOpVar("OPSYM_DIRECTORY"),(sBgSkIDs or ""))
  ePiece:SetSkin(mathClamp(tonumber(BgSk[2]) or 0,0,ePiece:SkinCount()-1))
  if(not AttachBodyGroups(ePiece,BgSk[1] or "")) then ePiece:Remove()
    return StatusLog(nil,"MakePiece: Failed to attach bodygroups") end
  if(not AttachAdditions(ePiece)) then ePiece:Remove()
    return StatusLog(nil,"MakePiece: Failed to attach additions") end
  return StatusLog(ePiece,"MakePiece: Success "..tostring(ePiece))
end

function ApplyPhysicalAnchor(ePiece,eBase,nWe,nNc)
  if(CLIENT) then return StatusLog(true,"ApplyPhysicalAnchor: Working on client") end
  local nWe = tonumber(nWe) or 0
  local nNc = tonumber(nNc) or 0
  LogInstance("ApplyPhysicalAnchor: {"..nWe..","..nNc.."}")
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"ApplyPhysicalAnchor: Piece entity not valid") end
  if(not (eBase and eBase:IsValid())) then
    return StatusLog(true,"ApplyPhysicalAnchor: Base constraint ignored") end
  if(nWe ~= 0) then -- Weld
    local nWe = constraintWeld(ePiece, eBase, 0, 0, 0, false, false)
    if(nWe and nWe:IsValid()) then
      ePiece:DeleteOnRemove(nWe)
       eBase:DeleteOnRemove(nWe)
    else LogInstance("ApplyPhysicalAnchor: Weld ignored") end
  end
  if(nNc ~= 0) then -- NoCollide
    local nNc = constraintNoCollide(ePiece, eBase, 0, 0)
    if(nNc and nNc:IsValid()) then
      ePiece:DeleteOnRemove(nNc)
       eBase:DeleteOnRemove(nNc)
    else LogInstance("ApplyPhysicalAnchor: NoCollide ignored") end
  end
  return StatusLog(true,"ApplyPhysicalAnchor: Success")
end

function ApplyPhysicalSettings(ePiece,nPi,nFr,nGr,sPh)
  if(CLIENT) then return StatusLog(true,"ApplyPhysicalSettings: Working on client") end
  local nPi = tonumber(nPi) or 0
  local nFr = tonumber(nFr) or 0
  local nGr = tonumber(nGr) or 0
  local sPh = tostring(sPh or "")
  LogInstance("ApplyPhysicalSettings: {"..nPi..","..nFr..","..nGr..","..sPh.."}")
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"ApplyPhysicalSettings: Piece entity not valid") end
  -- Initialize dupe settings using this array
  local dataSettings = {}
  if(nPi ~= 0) then
    ePiece.PhysgunDisabled = true
    ePiece:SetUnFreezable(true)
    ePiece:SetMoveType(MOVETYPE_VPHYSICS)
    dataSettings[1] = 1 -- Enabled
  end
  local pyPiece = ePiece:GetPhysicsObject()
  if(not (pyPiece and pyPiece:IsValid())) then
    return StatusLog(false,"ApplyPhysicalSettings: Piece physical object not valid") end
  if(nFr ~=  0) then pyPiece:EnableMotion(false) else pyPiece:EnableMotion(true) end
  if(nGr ~=  0) then constructSetPhysProp(nil,ePiece,0,pyPiece,{GravityToggle = true })
                else constructSetPhysProp(nil,ePiece,0,pyPiece,{GravityToggle = false}) end
  if(sPh ~= "") then constructSetPhysProp(nil,ePiece,0,pyPiece,{Material = sPh}) end
  if(tableMaxn(dataSettings) > 0) then -- Are there any settings to be saved
    duplicatorStoreEntityModifier(ePiece,GetOpVar("TOOLNAME_PL").."dupe_phys_set",dataSettings) end
  return StatusLog(true,"ApplyPhysicalSettings: Success")
end

function SetBoundPos(ePiece,vPos,oPly,sMode)
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"Piece:SetBoundPos: Entity invalid") end
  if(not vPos) then
    return StatusLog(false,"Piece:SetBoundPos: Position invalid") end
  if(not oPly) then
    return StatusLog(false,"Piece:SetBoundPos: Player invalid") end
  local sMode = tostring(sMode or "LOG")
  if(sMode == "OFF") then
    ePiece:SetPos(vPos)
    return StatusLog(true,"Piece:SetBoundPos("..sMode..") Tuned off")
  end
  if(utilIsInWorld(vPos)) then -- Error mode is "LOG" by default
    ePiece:SetPos(vPos)
  else
    ePiece:Remove()
    if(sMode == "HINT" or sMode == "GENERIC" or sMode == "ERROR") then
      PrintNotifyPly(oPly,"Position out of map bounds!",sMode) end
    return StatusLog(false,"Piece:SetBoundPos("..sMode.."): Position out of map bounds")
  end
  return StatusLog(true,"Piece:SetBoundPos("..sMode.."): Success")
end

function MakeCoVar(sShortName, sValue, tBorder, nFlags, sInfo)
  if(not IsString(sShortName)) then
    return StatusLog(nil,"MakeCvar: CVar name {"..type(sShortName).."}<"..tostring(sShortName).."> not string") end
  if(not IsExistent(sValue)) then
    return StatusLog(nil,"MakeCvar: Wrong default value <"..tostring(sValue)..">") end
  if(not IsString(sInfo)) then
    return StatusLog(nil,"MakeCvar: CVar info {"..type(sInfo).."}<"..tostring(sInfo).."> not string") end
  local sVar = GetOpVar("TOOLNAME_PL")..stringLower(sShortName)
  if(tBorder and (type(tBorder) == "table") and tBorder[1] and tBorder[2]) then
    local Border = GetOpVar("TABLE_BORDERS")
    Border["cvar_"..sVar] = tBorder
  end
  return CreateConVar(sVar, sValue, nFlags, sInfo)
end

function GetCoVar(sShortName, sMode)
  if(not IsString(sShortName)) then
    return StatusLog(nil,"GetCoVar: CVar name {"..type(sShortName).."}<"..tostring(sShortName).."> not string") end
  if(not IsString(sMode)) then
    return StatusLog(nil,"GetCoVar: CVar mode {"..type(sMode).."}<"..tostring(sMode).."> not string") end
  local sVar = GetOpVar("TOOLNAME_PL")..stringLower(sShortName)
  local CVar = GetConVar(sVar)
  if(not IsExistent(CVar)) then
    return StatusLog(nil,"GetCoVar("..sShortName..", "..sMode.."): Missing CVar object") end
  if    (sMode == "INT") then
    return (tonumber(BorderValue(CVar:GetInt(),"cvar_"..sVar)) or 0)
  elseif(sMode == "FLT") then
    return (tonumber(BorderValue(CVar:GetFloat(),"cvar_"..sVar)) or 0)
  elseif(sMode == "STR") then
    return tostring(CVar:GetString() or "")
  elseif(sMode == "BUL") then
    return (CVar:GetBool() or false)
  elseif(sMode == "DEF") then
    return CVar:GetDefault()
  elseif(sMode == "INF") then
    return CVar:GetHelpText()
  elseif(sMode == "NAM") then
    return CVar:GetName()
  end
  return StatusLog(nil,"GetCoVar("..sShortName..", "..sMode.."): Missed mode")
end
