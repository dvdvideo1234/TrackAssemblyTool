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
local csX -- Sign of the first component
local csY -- Sign of the second component
local csZ -- Sign of the third component
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
local COLLISION_GROUP_NONE  = COLLISION_GROUP_NONE
local SOLID_VPHYSICS        = SOLID_VPHYSICS
local RENDERMODE_TRANSALPHA = RENDERMODE_TRANSALPHA
local MOVETYPE_VPHYSICS     = MOVETYPE_VPHYSICS

---------------- Localizing CVar flags ----------------
local FCVAR_ARCHIVE       = FCVAR_ARCHIVE
local FCVAR_ARCHIVE_XBOX  = FCVAR_ARCHIVE_XBOX
local FCVAR_NOTIFY        = FCVAR_NOTIFY
local FCVAR_REPLICATED    = FCVAR_REPLICATED
local FCVAR_PRINTABLEONLY = FCVAR_PRINTABLEONLY

---------------- Localizing needed functions ----------------
local next                 = next
local type                 = type
local Angle                = Angle
local Color                = Color
local pairs                = pairs
local print                = print
local tobool               = tobool
local Vector               = Vector
local include              = include
local IsValid              = IsValid
local require              = require
local Time                 = SysTime
local tonumber             = tonumber
local tostring             = tostring
local GetConVar            = GetConVar
local LocalPlayer          = LocalPlayer
local CreateConVar         = CreateConVar
local getmetatable         = getmetatable
local setmetatable         = setmetatable
local collectgarbage       = collectgarbage
local osClock              = os and os.clock
local osDate               = os and os.date
local sqlQuery             = sql and sql.Query
local sqlLastError         = sql and sql.LastError
local sqlTableExists       = sql and sql.TableExists
local utilTraceLine        = util and util.TraceLine
local utilIsInWorld        = util and util.IsInWorld
local utilIsValidModel     = util and util.IsValidModel
local utilGetPlayerTrace   = util and util.GetPlayerTrace
local entsCreate           = ents and ents.Create
local fileOpen             = file and file.Open
local fileExists           = file and file.Exists
local fileAppend           = file and file.Append
local fileDelete           = file and file.Delete
local fileCreateDir        = file and file.CreateDir
local mathAbs              = math and math.abs
local mathCeil             = math and math.ceil
local mathModf             = math and math.modf
local mathSqrt             = math and math.sqrt
local mathFloor            = math and math.floor
local mathClamp            = math and math.Clamp
local mathRandom           = math and math.random
local timerStop            = timer and timer.Stop
local timerStart           = timer and timer.Start
local timerExists          = timer and timer.Exists
local timerCreate          = timer and timer.Create
local timerDestroy         = timer and timer.Destroy
local tableEmpty           = table and table.Empty
local stringLen            = string and string.len
local stringSub            = string and string.sub
local stringFind           = string and string.find
local stringGsub           = string and string.gsub
local stringUpper          = string and string.upper
local stringLower          = string and string.lower
local stringFormat         = string and string.format
local surfaceSetFont       = surface and surface.SetFont
local surfaceDrawLine      = surface and surface.DrawLine
local surfaceDrawText      = surface and surface.DrawText
local surfaceDrawCircle    = surface and surface.DrawCircle
local surfaceSetTexture    = surface and surface.SetTexture
local surfaceSetTextPos    = surface and surface.SetTextPos
local surfaceGetTextSize   = surface and surface.GetTextSize
local surfaceGetTextureID  = surface and surface.GetTextureID
local surfaceSetDrawColor  = surface and surface.SetDrawColor
local surfaceSetTextColor  = surface and surface.SetTextColor
local constructSetPhysProp = construct and construct.SetPhysProp
local constraintWeld       = constraint and constraint.Weld
local constraintNoCollide  = constraint and constraint.NoCollide
local surfaceDrawTexturedRect = surface and surface.DrawTexturedRect
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier

---------------- CASHES SPACE --------------------

local libCache  = {} -- Used to cache stuff in a Pool
local libAction = {} -- Used to attach external function to the lib
local libOpVars = {} -- Used to Store operational Variable Values

module("trackasmlib")

---------------------------- AssemblyLib COMMON ----------------------------

function Delay(nAdd)
  local nAdd = tonumber(nAdd) or 0
  if(nAdd > 0) then
    local tmEnd = osClock() + nAdd
    while(osClock() < tmEnd) do end
  end
end

function GetIndexes(sType)
  if(sType == "V") then
    return cvX, cvY, cvZ
  elseif(sType == "A") then
    return caP, caY, caR
  elseif(sType == "S") then
    return csX, csY, csZ, csD
  end
  return nil
end

function SetIndexes(sType,I1,I2,I3,I4)
  if(sType == "V") then
    cvX, cvY, cvZ = I1, I2, I3
  elseif(sType == "A") then
    caP, caY, caR = I1, I2, I3
  elseif(sType == "S") then
    csX, csY, csZ, csD = I1, I2, I3, I4
  end
  return nil
end

function GetInstPref()
  if    (CLIENT) then return "cl_"
  elseif(SERVER) then return "sv_" end
  return "na_"
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

function StatusPrint(anyStatus,sError)
  PrintInstance(sError)
  return anyStatus
end

function GetOpVar(sName)
  return libOpVars[sName]
end

function SetOpVar(sName, anyValue)
  libOpVars[sName] = anyValue
end

function IsExistent(anyValue)
  if(anyValue ~= nil) then return true end
  return false
end

function IsString(anyValue)
  if(getmetatable(anyValue) == GetOpVar("TYPEMT_STRING")) then return true end
  return false
end

local function IsEmptyString(sString)
  if(not IsString(sString)) then return false end
  return (sS == "")
end

function IsBool(anyArg)
  if    (anyArg == true ) then return true
  elseif(anyArg == false) then return true end
  return false
end

function IsNumber(anyArg)
  return ((tonumber(anyArg) and true) or false)
end

function InitAssembly(sName,sPurpose)
  SetOpVar("TYPEMT_STRING",getmetatable("TYPEMT_STRING"))
  SetOpVar("TYPEMT_SCREEN",{})
  SetOpVar("TYPEMT_CONTAINER",{})
  if(not (IsString(sName) and IsString(sPurpose))) then
    return StatusPrint(false,"InitAssembly: Expecting string argument"
             .." {"..type(sName)..","..type(sPurpose).."}") end
  if(IsEmptyString(sName) or tonumber(stringSub(sName,1,1))) then
    return StatusPrint(false,"InitAssembly: Name invalid") end
  if(IsEmptyString(sPurpose) or tonumber(stringSub(sPurpose,1,1))) then
    return StatusPrint(false,"InitAssembly: Purpose invalid") end
  SetOpVar("TIME_EPOCH",Time())
  SetOpVar("NAME_INIT",stringLower(sName))
  SetOpVar("NAME_PERP",stringLower(sPurpose))
  SetOpVar("TOOLNAME_NL",stringLower(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")))
  SetOpVar("TOOLNAME_NU",stringUpper(GetOpVar("NAME_INIT")..GetOpVar("NAME_PERP")))
  SetOpVar("TOOLNAME_PL",GetOpVar("TOOLNAME_NL").."_")
  SetOpVar("TOOLNAME_PU",GetOpVar("TOOLNAME_NU").."_")
  SetOpVar("MISS_NOID","N")    -- No ID selected
  SetOpVar("MISS_NOAV","N/A")  -- Not Available
  SetOpVar("MISS_NOMD","X")    -- No model
  SetOpVar("ARRAY_DECODEPOA",{0,0,0,1,1,1,false})
  SetOpVar("TABLE_FREQUENT_MODELS",{})
  SetOpVar("TABLE_BORDERS",{})
  SetOpVar("FILE_MODEL",".mdl")
  SetOpVar("MODE_DATABASE",GetOpVar("MISS_NOAV"))
  SetOpVar("HASH_USER_PANEL",GetOpVar("TOOLNAME_PU").."USER_PANEL")
  SetOpVar("HASH_QUERY_STORE",GetOpVar("TOOLNAME_PU").."QHASH_QUERY")
  SetOpVar("HASH_PLAYER_KEYDOWN","PLAYER_KEYDOWN")
  SetOpVar("HASH_PROPERTY_NAMES","PROPERTY_NAMES")
  SetOpVar("HASH_PROPERTY_TYPES","PROPERTY_TYPES")
  SetOpVar("ANG_ZERO",Angle())
  SetOpVar("VEC_ZERO",Vector())
  SetOpVar("OPSYM_DISABLE","#")
  SetOpVar("OPSYM_REVSIGN","@")
  SetOpVar("OPSYM_DIVIDER","_")
  SetOpVar("OPSYM_DIRECTORY","/")
  SetOpVar("OPSYM_SEPARATOR",",")
  SetOpVar("SPAWN_ENTITY",{
    F    = Vector(),
    R    = Vector(),
    U    = Vector(),
    PPos = Vector(),
    OPos = Vector(),
    OAng = Angle (),
    SPos = Vector(),
    SAng = Angle (),
    MPos = Vector(),
    MAng = Angle (),
    RLen = 0,
    HRec = 0,
    TRec = 0,
    OID  = 0
  })
  SetOpVar("SPAWN_NORMAL",{
    F    = Vector(),
    R    = Vector(),
    U    = Vector(),
    PPos = Vector(),
    OPos = Vector(),
    OAng = Angle (),
    SAng = Angle (),
    SPos = Vector(),
    MAng = Angle (),
    MPos = Vector(),
    HRec = 0
  })
  return true
end

------------- ANGLE ---------------
function ToAngle(aBase)
  return Angle((aBase[caP] or 0),
               (aBase[caY] or 0),
               (aBase[caR] or 0))
end

function ExpAngle(aBase)
  return (aBase[caP] or 0),
         (aBase[caY] or 0),
         (aBase[caR] or 0)
end

function AddAngle(aBase, adbAdd)
  aBase[caP] = aBase[caP] + adbAdd[caP]
  aBase[caY] = aBase[caY] + adbAdd[caY]
  aBase[caR] = aBase[caR] + adbAdd[caR]
end

function AddAnglePYR(aBase, nP, nY, nR)
  aBase[caP] = aBase[caP] + (nP or 0)
  aBase[caY] = aBase[caY] + (nY or 0)
  aBase[caR] = aBase[caR] + (nR or 0)
end

function SubAngle(aBase, adbSub)
  aBase[caP] = aBase[caP] - adbSub[caP]
  aBase[caY] = aBase[caY] - adbSub[caY]
  aBase[caR] = aBase[caR] - adbSub[caR]
end

function SubAnglePYR(aBase, nP, nY, nR)
  aBase[caP] = aBase[caP] - (nP or 0)
  aBase[caY] = aBase[caY] - (nY or 0)
  aBase[caR] = aBase[caR] - (nR or 0)
end

function NegAngle(aBase)
  aBase[caP] = -aBase[caP]
  aBase[caY] = -aBase[caY]
  aBase[caR] = -aBase[caR]
end

function SetAngle(aBase, adbSet)
  aBase[caP] = adbSet[caP]
  aBase[caY] = adbSet[caY]
  aBase[caR] = adbSet[caR]
end

function SetAnglePYR(aBase, nP, nY, nR)
  aBase[caP] = (nP or 0)
  aBase[caY] = (nY or 0)
  aBase[caR] = (nR or 0)
end

--- Vector

function ToVector(vBase)
  return Vector((vBase[cvX] or 0),
                (vBase[cvY] or 0),
                (vBase[cvZ] or 0))
end

function ExpVector(vBase)
  return (vBase[cvX] or 0),
         (vBase[cvY] or 0),
         (vBase[cvZ] or 0)
end

function GetLengthVector(vdbBase)
  local X = (vdbBase[cvX] or 0)
        X = X * X
  local Y = (vdbBase[cvY] or 0)
        Y = Y * Y
  local Z = (vdbBase[cvZ] or 0)
        Z = Z * Z
  return mathSqrt(X+Y+Z)
end

function RoundVector(vBase,nRound)
  local X = vBase[cvX] or 0
        X = RoundValue(X,nRound or 0.1)
  local Y = vBase[cvY] or 0
        Y = RoundValue(Y,nRound or 0.1)
  local Z = vBase[cvZ] or 0
        Z = RoundValue(Z,nRound or 0.1)
  vBase[cvX] = X
  vBase[cvY] = Y
  vBase[cvZ] = Z
end

function AddVector(vBase, vdbAdd)
  vBase[cvX] = vBase[cvX] + vdbAdd[cvX]
  vBase[cvY] = vBase[cvY] + vdbAdd[cvY]
  vBase[cvZ] = vBase[cvZ] + vdbAdd[cvZ]
end

function AddVectorXYZ(vBase, nX, nY, nZ)
  vBase[cvX] = vBase[cvX] + (nX or 0)
  vBase[cvY] = vBase[cvY] + (nY or 0)
  vBase[cvZ] = vBase[cvZ] + (nZ or 0)
end

function SubVector(vBase, vdbSub)
  vBase[cvX] = vBase[cvX] - vdbSub[cvX]
  vBase[cvY] = vBase[cvY] - vdbSub[cvY]
  vBase[cvZ] = vBase[cvZ] - vdbSub[cvZ]
end

function SubVectorXYZ(vBase, nX, nY, nZ)
  vBase[cvX] = vBase[cvX] - (nX or 0)
  vBase[cvY] = vBase[cvY] - (nY or 0)
  vBase[cvZ] = vBase[cvZ] - (nZ or 0)
end

function NegVector(vBase)
  vBase[cvX] = -vBase[cvX]
  vBase[cvY] = -vBase[cvY]
  vBase[cvZ] = -vBase[cvZ]
end

function SetVector(vVec, vdbSet)
  vVec[cvX] = vdbSet[cvX]
  vVec[cvY] = vdbSet[cvY]
  vVec[cvZ] = vdbSet[cvZ]
end

function SetVectorXYZ(vVec, nX, nY, nZ)
  vVec[cvX] = (nX or 0)
  vVec[cvY] = (nY or 0)
  vVec[cvZ] = (nZ or 0)
end

function DecomposeByAngle(V,A)
  if(not ( V and A ) ) then
    return Vector()
  end
  return Vector(V:DotProduct(A:Forward()),
                V:DotProduct(A:Right()),
                V:DotProduct(A:Up()))
end

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

function LocateRecID(oRec, nvPointID)
  if(not oRec) then return StatusLog(nil,"LocateRecID: Missing record") end
  if(not oRec.Offs) then return StatusLog(nil,"LocateRecID: Missing offsets") end
  local nPointID = tonumber(nvPointID) or 0
  local stOffset = oRec.Offs[nPointID]
  if(not IsExistent(stOffset)) then
    return StatusLog(nil,"LocateRecID: Missing ID #"..tostring(nPointID).." <"..tostring(nvPointID)..">") end
  return stOffset
end

---------- Library OOP -----------------

function MakeContainer(sInfo,sDefKey)
  local Info = tostring(sInfo or "Store Container")
  local Curs = 0
  local Data = {}
  local Sel  = ""
  local Ins  = ""
  local Del  = ""
  local Met  = ""
  local Key  = sDefKey or "(!_+*#-$@DEFKEY@$-#*+_!)"
  local self = {}
  function self:GetInfo()
    return Info
  end
  function self:GetSize()
    return Curs
  end
  function self:GetData()
    return Data
  end
  function self:Insert(nsKey,anyValue)
    Ins = nsKey or Key
    Met = "I"
    if(not IsExistent(Data[Ins])) then
      Curs = Curs + 1
    end
    Data[Ins] = anyValue
  end
  function self:Select(nsKey)
    Sel = nsKey or Key
    return Data[Sel]
  end
  function self:Delete(nsKey,fnDel)
    Del = nsKey or Key
    Met = "D"
    if(IsExistent(Data[Del])) then
      if(IsExistent(fnDel)) then
        fnDel(Data[Del])
      end
      Data[Del] = nil
      Curs = Curs - 1
    end
  end
  function self:GetHistory()
    return tostring(Met)..GetOpVar("OPSYM_REVSIGN")..
           tostring(Sel)..GetOpVar("OPSYM_DIRECTORY")..
           tostring(Ins)..GetOpVar("OPSYM_DIRECTORY")..
           tostring(Del)
  end
  setmetatable(self,GetOpVar("TYPEMT_CONTAINER"))
  return self
end

function MakeScreen(sW,sH,eW,eH,conPalette,sMeth)
  if(SERVER) then return nil end
  local sW = sW or 0
  local sH = sH or 0
  local eW = eW or 0
  local eH = eH or 0
  if(eW <= 0 or eH <= 0) then return nil end
  if(type(conPalette) ~= "table") then return nil end
  local Method = tostring(sMeth or "")
  local White = Color(255,255,255,255)
  local ColorKey
  local Text = {}
        Text.Font = "Trebuchet18"
        Text.DrawX = 0
        Text.DrawY = 0
        Text.ScrW  = 0
        Text.ScrH  = 0
        Text.LastW = 0
        Text.LastH = 0
  local Palette
  if(getmetatable(conPalette) == GetOpVar("TYPEMT_CONTAINER")) then
    Palette = conPalette
  end
  local Texture = {}
        Texture.Path = "vgui/white"
        Texture.ID   = surfaceGetTextureID(Texture.Path)
  local self = {}
  function self:GetSize()
    return (eW-sW), (eH-sH)
  end
  function self:GetCenter(nX,nY)
    local w, h = self:GetSize()
    w = (w / 2) + (tonumber(nX) or 0)
    h = (h / 2) + (tonumber(nY) or 0)
    return w, h
  end
  function self:SetColor(sColor)
    if(not sColor) then return end
    if(Palette) then
      local Colour = Palette:Select(sColor)
      if(Colour) then
        surfaceSetDrawColor(Colour.r, Colour.g, Colour.b, Colour.a)
        surfaceSetTextColor(Colour.r, Colour.g, Colour.b, Colour.a)
        ColorKey = sColor
      end
    else
      surfaceSetDrawColor(White.r,White.g,White.b,White.a)
      surfaceSetTextColor(White.r,White.g,White.b,White.a)
    end
  end
  function self:SetTexture(sTexture)
    if(not IsString(sTexture)) then return end
    if(sTexture == "") then return end
    Texture.Path = sTexture
    Texture.ID   = surfaceGetTextureID(Texture.Path)
  end
  function self:GetTexture()
    return Texture.ID, Texture.Path
  end
  function self:DrawBackGround(sColor)
    self:SetColor(sColor)
    surfaceSetTexture(Texture.ID)
    surfaceDrawTexturedRect(sW,sH,eW-sW,eH-sH)
  end
  function self:DrawRect(nX,nY,nW,nH,sColor)
    self:SetColor(sColor)
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
  function self:DrawText(sText,sColor)
    surfaceSetTextPos(Text.DrawX,Text.DrawY)
    self:SetColor(sColor)
    surfaceDrawText(sText)
    Text.LastW, Text.LastH = surfaceGetTextSize(sText)
    Text.DrawY = Text.DrawY + Text.LastH
    if(Text.LastW > Text.ScrW) then
      Text.ScrW = Text.LastW
    end
    Text.ScrH = Text.DrawY
  end
  function self:DrawTextAdd(sText,sColor)
    surfaceSetTextPos(Text.DrawX + Text.LastW,Text.DrawY - Text.LastH)
    self:SetColor(sColor)
    surfaceDrawText(sText)
    local LastW, LastH = surfaceGetTextSize(sText)
    Text.LastW = Text.LastW + LastW
    Text.LastH = LastH
    if(Text.LastW > Text.ScrW) then
      Text.ScrW = Text.LastW
    end
    Text.ScrH = Text.DrawY
  end
  function self:DrawCircle(xyPos,nRad,sColor)
    if(Palette) then
      if(sColor) then
        local Colour = Palette:Select(sColor)
        if(Colour) then
          surfaceDrawCircle( xyPos.x, xyPos.y, nRad, Colour)
          ColorKey = sColor
          return
        end
      else
        if(IsExistent(ColorKey)) then
          local Colour = Palette:Select(ColorKey)
          surfaceDrawCircle( xyPos.x, xyPos.y, nRad, Colour)
          return
        end
      end
      return
    else
      surfaceDrawCircle( xyPos.x, xyPos.y, nRad, White)
    end
  end
  function self:Enclose(xyPnt)
    if(xyPnt.x < sW) then return -1 end
    if(xyPnt.x > eW) then return -1 end
    if(xyPnt.y < sH) then return -1 end
    if(xyPnt.y > eH) then return -1 end
    return 1
  end
  function self:AdaptLine(xyS,xyE,nI,nK,sMeth)
    local I = 0
    if(not (xyS and xyE)) then return I end
    if(not (xyS.x and xyS.y and xyE.x and xyE.y)) then return I end
    local nK = nK or 0.75
    local nI = nI or 50
          nI = mathFloor(nI)
    if(sW >= eW) then return I end
    if(sH >= eH) then return I end
    if(nI < 1) then return I end
    if(not (nK > I and nK < 1)) then return I end
    local SigS = self:Enclose(xyS)
    local SigE = self:Enclose(xyE)
    if(SigS == 1 and SigE == 1) then
      return (I+1)
    elseif(SigS == -1 and SigE == -1) then
      return I
    elseif(SigS == -1 and SigE == 1) then
      xyS.x, xyE.x = xyE.x, xyS.x
      xyS.y, xyE.y = xyE.y, xyS.y
    end --- From here below are the methods
    if(sMeth == "BIN") then
      local DisX = xyE.x - xyS.x
      local DirX = DisX
            DisX = DisX * DisX
      local DisY = xyE.y - xyS.y
      local DirY = DisY
            DisY = DisY * DisY
      local Dis = mathSqrt(DisX + DisY)
      if(Dis == 0) then
        return I
      end
            DirX = DirX / Dis
            DirY = DirY / Dis
      local Pos = {x = xyS.x, y = xyS.y}
      local Mid = Dis / 2
      local Pre = 100 -- Obviously big enough
      while(I < nI) do
        Sig = self:Enclose(Pos)
        if(Sig == 1) then
          xyE.x = Pos.x
          xyE.y = Pos.y
        end
        Pos.x = Pos.x + DirX * Sig * Mid
        Pos.y = Pos.y + DirY * Sig * Mid
        if(Sig == -1) then
          --[[
            Estimate the distance and break
            earlier with 0.5 because of the
            mathFloor call afterwards.
          ]]
          Pre = mathAbs(mathAbs(Pos.x) + mathAbs(Pos.y) -
                         mathAbs(xyE.x) - mathAbs(xyE.y))
          if(Pre < 0.5) then break end
        end
        Mid = nK * Mid
        I = I + 1
      end
    elseif(sMeth == "ITR") then
      local V = {x = xyE.x-xyS.x, y = xyE.y-xyS.y}
      local N = mathSqrt(V.x*V.x + V.y*V.y)
      local Z = (N * (1-nK))
      if(Z == 0) then return I end
      local D = {x = V.x/Z , y = V.y/Z}
            V.x = xyS.x
            V.y = xyS.y
      local Sig = self:Enclose(V)
      while(Sig == 1) do
        xyE.x, xyE.y = V.x, V.y
        V.x = V.x + D.x
        V.y = V.y + D.y
        Sig = self:Enclose(V)
        I = I + 1
      end
    else
      return StatusLog(0,"Screen:AdaptLine: Missed method "..tostring(sMeth))
    end
    xyS.x, xyS.y = mathFloor(xyS.x), mathFloor(xyS.y)
    xyE.x, xyE.y = mathFloor(xyE.x), mathFloor(xyE.y)
    return I
  end
  function self:DrawLine(xyS,xyE,sColor)
    if(not (xyS and xyE)) then return end
    if(not (xyS.x and xyS.y and xyE.x and xyE.y)) then return end
    self:SetColor(sColor)
    if(Method == "BIN" or Method == "ITR") then
      local Iter = self:AdaptLine(xyS,xyE,200,0.75,Method)
      if(Iter > 0) then
        surfaceDrawLine(xyS.x,xyS.y,xyE.x,xyE.y)
      end
    elseif(Method == "GHO") then
      local nS = self:Enclose(xyS)
      local nE = self:Enclose(xyE)
      if(nS == -1 or nE == -1) then return end
      surfaceDrawLine(xyS.x,xyS.y,xyE.x,xyE.y)
    else
      LogInstance("Screen:DrawLine: Missed method <"..Method..">")
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
    return StatusLog(false,"LineAddListView: Failed to create a ListView line for <"..sModel.."> #"..tostring(iNdex)) end
  return pnRec, tValue
end

--[[
 * Updates a VGUI pnListView with a search preformed in the already generated
 * frequently used pieces "frUsed" for the pattern "sPattern" given by the user
 * and a filled selected "sField".
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
    if(sPattern == "") then
      pnRec = AddLineListView(pnListView,frUsed,iNdex)
      if(not IsExistent(pnRec)) then
        return StatusLog(false,"UpdateListView: Failed to add line on #"..tostring(iNdex))
      end
    else
      sData = tostring(frUsed[iNdex].Table[sField] or "")
      if(stringFind(sData,sPattern)) then
        pnRec = AddLineListView(pnListView,frUsed,iNdex)
        if(not IsExistent(pnRec)) then
          return StatusLog(false,"UpdateListView: Failed to add pattern <"..sPattern.."> on #"..tostring(iNdex))
        end
      end
    end
    iNdex = iNdex + 1
  end
  pnListView:SetVisible(true)
  return StatusLog(true,"UpdateListView: Crated #"..tostring(iNdex-1))
end

local function PushSortValues(tTable,snCnt,nsValue,tData)
  local Cnt = mathFloor(tonumber(snCnt) or 0)
  if(not (tTable and (type(tTable) == "table") and (Cnt > 0))) then return 0 end
  local Ind  = 1
  if(not tTable[Ind]) then
    tTable[Ind] = {Value = nsValue, Table = tData }
    return Ind
  else
    while(tTable[Ind] and (tTable[Ind].Value < nsValue)) do
      Ind = Ind + 1
    end
    if(Ind > Cnt) then return Ind end
    while(Ind < Cnt) do
      tTable[Cnt] = tTable[Cnt - 1]
      Cnt = Cnt - 1
    end
    tTable[Ind] = { Value = nsValue, Table = tData }
    return Ind
  end
end

function GetFrequentModels(snCount)
  local snCount = tonumber(snCount) or 0
  if(snCount < 1) then
    return StatusLog(nil,"GetFrequentModels: Count not applicable") end
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not IsExistent(defTable)) then
    return StatusLog(nil,"GetFrequentModels: Missing table definition") end
  local Cache = libCache[defTable.Name]
  if(not IsExistent(Cache)) then
    return StatusLog(nil,"GetFrequentModels: Missing table cache space") end
  local iInd, tmNow = 1, Time()
  local frUsed = GetOpVar("TABLE_FREQUENT_MODELS")
  tableEmpty(frUsed)
  for Model, Record in pairs(Cache) do
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
  local Rez
  local Snp = mathAbs(nSnap)
  local Val = mathAbs(nVal)
  local Rst = Val % Snp
  if((Snp-Rst) < Rst) then
    Rez = Val+Snp-Rst
  else
    Rez = Val-Rst
  end
  if(nVal < 0) then
    return -Rez;
  end
  return Rez;
end

function GetMCWorldOffset(oEnt)
  -- Set the ENT's Angles first!
  if(not (oEnt and oEnt:IsValid())) then
    return StatusLog(Vector(0,0,0),"GetMCWorldOffset: Entity Invalid") end
  local Phys = oEnt:GetPhysicsObject()
  if(not (Phys and Phys:IsValid())) then
    return StatusLog(Vector(0,0,0),"GetMCWorldOffset: Phys object Invalid") end
  local aAng = oEnt:GetAngles()
  local vMCL = Phys:GetMassCenter()
  local vRez = Vector()
        vRez:Add(-vMCL[cvX] * aAng:Forward())
        vRez:Add(-vMCL[cvY] * aAng:Right())
  return vRez
end

function IsPhysTrace(Trace)
  if(not Trace) then return false end
  local eEnt = Trace.Entity
  if(     eEnt   and
      not Trace.HitWorld and
          eEnt:IsValid() and
          eEnt:GetPhysicsObject():IsValid()) then
    return true
  end
  return false
end

function RollValue(nVal,nMin,nMax)
  if(nVal > nMax) then return nMin end
  if(nVal < nMin) then return nMax end
  return nVal
end

function BorderValue(nsVal,sName)
  if(not IsString(sName)) then return nsVal end
  if(not (IsString(nsVal) or tonumber(nsVal))) then return StatusLog(nsVal,"BorderValue: Value not comparable") end
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
  if(not IsExistent(LocateRecID(rPiece,iPointID))) then
    return StatusLog(1,"IncDecPointID: Point ID #"..tostring(iPointID).." not located") end
  local sDir, nDir = stringSub(tostring(sDir),1,1), 0
  if    (sDir == "+") then nDir = 1
  elseif(sDir == "-") then nDir = -1
  else return StatusLog(iPointID,"IncDecPointID: Direction <"..sDir.."> mismatch") end
  iPointID = iPointID + nDir
  iPointID = RollValue(iPointID,1,rPiece.Kept)
  if(rPiece.Offs[iPointID].P[csD]) then iPointID = iPointID + nDir end
  return RollValue(iPointID,1,rPiece.Kept)
end

function IncDecPnextID(ivPnextID,ivPointID,sDir,rPiece)
  local iPnextID = tonumber(ivPnextID)
  local iPointID = tonumber(ivPointID)
  if(not IsExistent(iPnextID)) then
    return StatusLog(1,"IncDecPnextID: PnextID NAN {"..type(ivPnextID).."}<"..tostring(ivPnextID)..">") end
  if(not IsExistent(iPointID)) then
    return StatusLog(1,"IncDecPnextID: PointID NAN {"..type(ivPointID).."}<"..tostring(ivPointID)..">") end
  if(not IsExistent(LocateRecID(rPiece,iPnextID))) then
    return StatusLog(1,"IncDecPointID: Offset PnextID #"..tostring(iPnextID).." not located") end
  if(not IsExistent(LocateRecID(rPiece,iPointID))) then
    return StatusLog(1,"IncDecPointID: Offset PointID #"..tostring(iPointID).." not located") end
  local sDir, nDir = stringSub(tostring(sDir),1,1), 0
  if    (sDir == "+") then nDir =  1
  elseif(sDir == "-") then nDir = -1
  else return StatusLog(iPnextID,"IncDecPnextID: Direction <"..sDir.."> mismatch") end
  iPnextID = iPnextID + nDir
  iPnextID = RollValue(iPnextID,1,rPiece.Kept)
  if(iPnextID == iPointID) then iPnextID = iPnextID + nDir end
  return RollValue(iPnextID,1,rPiece.Kept)
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
  local hdPnt = LocateRecID(hdRec,iPointID)
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
  vDiffBB:Set(DecomposeByAngle(vDiffBB,aDiffBB))
  return mathAbs(vDiffBB[cvZ])
end

function ModelToName(sModel)
  if(not IsString(sModel)) then return "" end
  local Cnt = 1   -- If is model remove *.mdl
  local sModel = stringGsub(sModel,GetOpVar("FILE_MODEL"),"")
  local Len = stringLen(sModel)
  if(Len <= 0) then return "" end
  local sSymDiv = GetOpVar("OPSYM_DIVIDER")
  local sSymDir = GetOpVar("OPSYM_DIRECTORY")
  local gModel = ""
        sModel = stringSub(sModel,1,Len)
  -- Locate the model part and exclude the directories
  Cnt = stringLen(sModel)
  local fCh, bCh = "", ""
  while(Cnt > 0) do
    fCh = stringSub(sModel,Cnt,Cnt)
    if(fCh == sSymDir) then
      break
    end
    Cnt = Cnt - 1
  end
  sModel = stringSub(sModel,Cnt+1,Len)
  -- Remove the unneeded parts by indexing sModel
  Cnt = 1
  gModel = sModel
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
      if(not (fCh and bCh)) then
        return StatusLog("","ModelToName: Cannot sub the model in {"..fCh..", "..bCh.."}")
      end
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
  sModel = sSymDiv..gModel
  Len = stringLen(sModel)
  fCh, bCh, gModel = "", "", ""
  while(Cnt <= Len) do
    bCh = stringSub(sModel,Cnt,Cnt)
    fCh = stringSub(sModel,Cnt+1,Cnt+1)
    if(bCh == sSymDiv) then
       bCh = " "
       fCh = stringUpper(fCh)
       gModel = gModel..bCh..fCh
       Cnt = Cnt + 1
    else
      gModel = gModel..bCh
    end
    Cnt = Cnt + 1
  end
  return stringSub(gModel,2,Len)
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

local function IsEqualPOA(stOffsetA,stOffsetB)
  if(not IsExistent(stOffsetA)) then
    return StatusLog(false,"EqualPOA: Missing OffsetA") end
  if(not IsExistent(stOffsetB)) then
    return StatusLog(false,"EqualPOA: Missing OffsetB") end
  for Ind, Comp in pairs(stOffsetA) do
    if(Ind ~= csD and stOffsetB[Ind] ~= Comp) then return false end
  end
  return true
end

local function StringPOA(arPOA,sOffs)
  if(not IsString(sOffs)) then
    return StatusLog(nil,"StringPOA: Mode is not a string but "..type(sOffs)) end
  if(not IsExistent(arPOA)) then
    return StatusLog(nil,"StringPOA: Missing Offsets") end
  local symRevs = GetOpVar("OPSYM_REVSIGN")
  local symDisa = GetOpVar("OPSYM_DISABLE")
  local symSepa = GetOpVar("OPSYM_SEPARATOR")
  local sModeDB = GetOpVar("MODE_DATABASE")
  local Result = ((arPOA[csD] and symDisa) or "")
  if(sOffs == "V") then
    Result = Result..((arPOA[csX] == -1) and symRevs or "")..tostring(arPOA[cvX])..symSepa
                   ..((arPOA[csY] == -1) and symRevs or "")..tostring(arPOA[cvY])..symSepa
                   ..((arPOA[csZ] == -1) and symRevs or "")..tostring(arPOA[cvZ])
  elseif(sOffs == "A") then
    Result = Result..((arPOA[csX] == -1) and symRevs or "")..tostring(arPOA[caP])..symSepa
                   ..((arPOA[csY] == -1) and symRevs or "")..tostring(arPOA[caY])..symSepa
                   ..((arPOA[csZ] == -1) and symRevs or "")..tostring(arPOA[caR])
  else return StatusLog("","StringPOA: Missed offset mode "..sOffs) end
  return stringGsub(Result," ","") -- Get rid of the spaces
end

local function TransferPOA(stOffset,sMode)
  if(not IsExistent(stOffset)) then
    return StatusLog(nil,"TransferPOA: Destination needed") end
  if(not IsString(sMode)) then
    return StatusLog(nil,"TransferPOA: Mode must be string") end
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
  if(sMode == "V") then
    stOffset[cvX] = arPOA[1]
    stOffset[cvY] = arPOA[2]
    stOffset[cvZ] = arPOA[3]
  elseif(sMode == "A") then
    stOffset[caP] = arPOA[1]
    stOffset[caY] = arPOA[2]
    stOffset[caR] = arPOA[3]
  else
    return StatusLog(nil,"TransferPOA: Missed mode "..sMode)
  end
  stOffset[csX] = arPOA[4]
  stOffset[csY] = arPOA[5]
  stOffset[csZ] = arPOA[6]
  stOffset[csD] = arPOA[7]
  return arPOA
end

local function DecodePOA(sStr)
  if(not IsString(sStr)) then
    return StatusLog(nil,"DecodePOA: Argument must be string") end
  local DatInd = 1
  local ComCnt = 0
  local Len    = stringLen(sStr)
  local symOff = GetOpVar("OPSYM_DISABLE")
  local symRev = GetOpVar("OPSYM_REVSIGN")
  local symSep = GetOpVar("OPSYM_SEPARATOR")
  local arPOA  = GetOpVar("ARRAY_DECODEPOA")
  local Ch = ""
  local S = 1
  local E = 1
  local Cnt = 1
  ReloadPOA()
  if(stringSub(sStr,Cnt,Cnt) == symOff) then
    arPOA[7] = true
    Cnt = Cnt + 1
    S   = S   + 1
  end
  while(Cnt <= Len) do
    Ch = stringSub(sStr,Cnt,Cnt)
    if(Ch == symRev) then
      arPOA[3+DatInd] = -arPOA[3+DatInd]
      S   = S + 1
    elseif(Ch == symSep) then
      ComCnt = ComCnt + 1
      E = Cnt - 1
      if(ComCnt > 2) then break end
      arPOA[DatInd] = tonumber(stringSub(sStr,S,E)) or 0
      DatInd = DatInd + 1
      S = Cnt + 1
      E = S
    else
      E = E + 1
    end
    Cnt = Cnt + 1
  end
  arPOA[DatInd] = tonumber(stringSub(sStr,S,E)) or 0
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
    return StatusLog(nil,"RegisterPOA: Point is not a string but "..type(sP)) end
  if(not IsString(sO)) then
    return StatusLog(nil,"RegisterPOA: Origin is not a string but "..type(sO)) end
  if(not IsString(sA)) then
    return StatusLog(nil,"RegisterPOA: Angle is not a string but "..type(sA)) end
  if(not stPiece.Offs) then
    if(iID > 1) then return StatusLog(nil,"RegisterPOA: First ID cannot be "..tostring(iID)) end
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
  if((sO ~= "") and (sO ~= "NULL")) then DecodePOA(sO)
  else ReloadPOA() end
  if(not IsExistent(TransferPOA(tOffs.O,"V"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer origin") end
  if((sP ~= "") and (sP ~= "NULL")) then DecodePOA(sP) end
  if(not IsExistent(TransferPOA(tOffs.P,"V"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer point")
  end -- In the POA array still persists the decoded Origin
  if(stringSub(sP,1,1) == GetOpVar("OPSYM_DISABLE")) then tOffs.P[csD] = true end
  if((sA ~= "") and (sA ~= "NULL")) then DecodePOA(sA)
  else ReloadPOA() end
  if(not IsExistent(TransferPOA(tOffs.A,"A"))) then
    return StatusLog(nil,"RegisterPOA: Cannot transfer angle") end
  return tOffs
end

function FormatNumberMax(nNum,nMax)
  local nNum = tonumber(nNum)
  local nMax = tonumber(nMax)
  if(not (nNum and nMax)) then return "" end
  return stringFormat("%"..stringLen(tostring(mathFloor(nMax))).."d",nNum)
end

local function Qsort(Data,Lo,Hi)
  if(not (Lo and Hi and (Lo > 0) and (Lo < Hi))) then
    return StatusLog(nil,"Qsort: Data dimensions mismatch") end
  local Mid = mathRandom(Hi-(Lo-1))+Lo-1
  Data[Lo], Data[Mid] = Data[Mid], Data[Lo]
  local Vmid = Data[Lo].Val
        Mid  = Lo
  local Cnt  = Lo + 1
  while(Cnt <= Hi)do
    if(Data[Cnt].Val < Vmid) then
      Mid = Mid + 1
      Data[Mid], Data[Cnt] = Data[Cnt], Data[Mid]
    end
    Cnt = Cnt + 1
  end
  Data[Lo], Data[Mid] = Data[Mid], Data[Lo]
  Qsort(Data,Lo,Mid-1)
  Qsort(Data,Mid+1,Hi)
end

local function Ssort(Data,Lo,Hi)
  if(not (Lo and Hi and (Lo > 0) and (Lo < Hi))) then
    return StatusLog(nil,"Ssort: Data dimensions mismatch") end
  local Ind = 1
  local Sel
  while(Data[Ind]) do
    Sel = Ind + 1
    while(Data[Sel]) do
      if(Data[Sel].Val < Data[Ind].Val) then
        Data[Ind], Data[Sel] = Data[Sel], Data[Ind]
      end
      Sel = Sel + 1
    end
    Ind = Ind + 1
  end
end

local function Bsort(Data,Lo,Hi)
  if(not (Lo and Hi and (Lo > 0) and (Lo < Hi))) then
    return StatusLog(nil,"Bsort: Data dimensions mismatch") end
  local Ind, End = 1, false
  while(not End) do
    End = true
    for Ind = Lo, (Hi-1), 1 do
      if(Data[Ind].Val > Data[Ind+1].Val) then
        End = false
        Data[Ind], Data[Ind+1] = Data[Ind+1], Data[Ind]
      end
    end
  end
end

function Sort(tTable,tKeys,tFields,sMethod)
  local Match = {}
  local tKeys = tKeys or {}
  local tFields = tFields or {}
  local Cnt, Ind, Key, Val, Fld = 1, nil, nil, nil, nil
  if(not tKeys[1]) then
    for k,v in pairs(tTable) do
      tKeys[Cnt] = k
      Cnt = Cnt + 1
    end
    Cnt = 1
  end
  while(tKeys[Cnt]) do
    Key = tKeys[Cnt]
    Val = tTable[Key]
    if(not Val) then
      return StatusLog(nil,"Sort: Key <"..Key.."> does not exist in the primary table")
    end
    Match[Cnt] = {}
    Match[Cnt].Key = Key
    if(type(Val) == "table") then
      Match[Cnt].Val = ""
      Ind = 1
      while(tFields[Ind]) do
        Fld = tFields[Ind]
        if(not IsExistent(Val[Fld])) then
          return StatusLog(nil,"Sort: Field <"..Fld.."> not found on the current record")
        end
        Match[Cnt].Val = Match[Cnt].Val..tostring(Val[Fld])
        Ind = Ind + 1
      end
    else
      Match[Cnt].Val = Val
    end
    Cnt = Cnt + 1
  end
  local sMethod = tostring(sMethod or "QIK")
  if(sMethod == "QIK") then
    Qsort(Match,1,Cnt-1)
  elseif(sMethod == "SEL") then
    Ssort(Match,1,Cnt-1)
  elseif(sMethod == "BBL") then
    Bsort(Match,1,Cnt-1)
  else
    return StatusLog(nil,"Sort: Method <"..sMethod.."> not found")
  end
  return Match
end

------------------ AssemblyLib LOGS ------------------------

function SetLogControl(nLines,sFile)
  SetOpVar("LOG_LOGFILE",tostring(sFile) or "")
  SetOpVar("LOG_MAXLOGS",tonumber(nLines) or 0)
  SetOpVar("LOG_CURLOGS",0)
  if(not fileExists(GetOpVar("DIRPATH_BAS"),"DATA") and
     not IsEmptyString(GetOpVar("LOG_LOGFILE"))) then
    fileCreateDir(GetOpVar("DIRPATH_BAS"))
  end
end

function Log(anyStuff)
  local nMaxLogs = GetOpVar("LOG_MAXLOGS")
  if(nMaxLogs > 0) then
    local sLogFile = GetOpVar("LOG_LOGFILE")
    local nCurLogs = GetOpVar("LOG_CURLOGS")
    if(sLogFile ~= "") then
      local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_LOG")..sLogFile..".txt"
      fileAppend(fName,FormatNumberMax(nCurLogs,nMaxLogs)
                .." >> "..tostring(anyStuff).."\n")
      nCurLogs = nCurLogs + 1
      if(nCurLogs > nMaxLogs) then
        fileDelete(fName)
        nCurLogs = 0
      end
      SetOpVar("LOG_CURLOGS",nCurLogs)
    else
      print(GetOpVar("TOOLNAME_NU").." LOG: "..tostring(anyStuff))
    end
  end
end

function LogInstance(anyStuff)
  local anyStuff = tostring(anyStuff)
  local logSkip  = GetOpVar("LOG_SKIP")
  if(logSkip and logSkip[1]) then
    local iNdex = 1
    while(logSkip[iNdex]) do
      if(stringFind(anyStuff,tostring(logSkip[iNdex]))) then return end
      iNdex = iNdex + 1
    end
  end -- Should the current log be skipped
  local logOnly  = GetOpVar("LOG_ONLY")
  if(logOnly and logOnly[1]) then
    local iNdex = 1
    local logMe = false
    while(logOnly[iNdex]) do
      if(stringFind(anyStuff,tostring(logOnly[iNdex]))) then
        logMe = true
      end
      iNdex = iNdex + 1
    end
    if(not logMe) then return end
  end -- Only the chosen messages are processed
  local sModeDB  = GetOpVar("MODE_DATABASE")
  if(SERVER) then
    Log("SERVER > ["..sModeDB.."] "..anyStuff)
  elseif(CLIENT) then
    Log("CLIENT > ["..sModeDB.."] "..anyStuff)
  else
    Log("NOINST > ["..sModeDB.."] "..anyStuff)
  end
end

function StatusLog(anyStatus,sError)
  LogInstance(sError)
  return anyStatus
end

--------------------- STRING -----------------------

function StringDisable(sBase, anyDisable, anyDefault)
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

function StringDefault(sBase, sDefault)
  if(IsString(sBase)) then
    if(not IsEmptyString(sBase)) then return sBase end
  end
  if(IsString(sDefault)) then return sDefault end
  return ""
end

function StringExplode(sStr,sDelim)
  if(not (IsString(sStr) and IsString(sDelim))) then
    return StatusLog(nil,"StringExplode: All parameters should be strings")
  end
  if(IsEmptyString(sDelim)) then
    return StatusLog(nil,"StringExplode: Missing string exploding delimiter")
  end
  local sStr   = sStr
  local sDelim = stringSub(sDelim,1,1)
  if(stringSub(sStr,-1,-1) ~= sDelim) then -- Triggers on the delimiter
    sStr = sStr..sDelim
  end
  local Data = {}
  local lenStr = stringLen(sStr)
  local S, E, I, V = 1, 1, 1, ""
  while(E <= lenStr) do
    local Ch = stringSub(sStr,E,E)
    if(Ch == sDelim) then
      V = stringSub(sStr,S,E-1)
      S = E + 1
      Data[I] = V or ""
      I = I + 1
    end
    E = E + 1
  end
  return Data
end

function StringImplode(tParts,sDelim)
  if(not (tParts and tParts[1])) then return "" end
  if(not IsString(sDelim)) then
    return StatusLog(nil,"StringImplode: The delimiter should be string")
  end
  local iCnt = 1
  local sImplode = ""
  local sDelim = stringSub(tostring(sDelim),1,1)
  while(tParts[iCnt]) do
    sImplode = sImplode..tostring(tParts[iCnt])
    if(tParts[iCnt+1]) then
      sImplode = sImplode..sDelim
    end
    iCnt = iCnt + 1
  end
  return sImplode
end

function StringPad(sStr,sPad,ivCnt)
  if(not IsString(sStr)) then return StatusLog("","StringPad: String missing") end
  if(not IsString(sPad)) then return StatusLog(sStr,"StringPad: Pad missing") end
  local iLen = stringLen(sStr) -- Not used just for error handling
  if(iLen == 0) then return StatusLog(sStr,"StringPad: Pad too short") end
  local iCnt = tonumber(ivCnt)
  if(not IsExistent(iCnt)) then
    return StatusLog(sStr,"StringPad: Count NAN {"
             ..type(ivCnt).."}<"..tostring(ivCnt)..">") end
  local iDif = (mathAbs(iCnt) - iLen)
  if(iDif <= 0) then return StatusLog(sStr,"StringPad: Padding Ignored") end
  local sCh = stringSub(sPad,1,1)
  local sPad = sCh
  iDif = iDif - 1
  while(iDif > 0) do
    sPad = sPad..sCh
    iDif = iDif - 1
  end
  if(iCnt > 0) then return (sStr..sPad) end
  return (sPad..sStr)
end

function String2BGID(sStr)
  if(not IsExistent(sStr)) then
    return StatusLog(nil, "String2BGID: String missing") end
  if(IsEmptyString(sStr)) then
    return StatusLog(nil, "String2BGID: Empty string") end
  local Cnt  = 1
  local Data = StringExplode(sStr,GetOpVar("OPSYM_SEPARATOR"))
  while(Data[Cnt]) do
    local Num = tonumber(Data[Cnt])
    if(not IsExistent(Num)) then
      return StatusLog(nil, "String2BGID: Value NAN {"
               ..type(Data[Cnt]).."}<"..tostring(Data[Cnt])..">") end
    if((mathFloor(Num) - Num) ~= 0) then
      return StatusLog(nil, "String2BGID: Floats are forbidden") end
    Data[Cnt] = Num
    Cnt = Cnt + 1
  end
  if(IsExistent(Data[1]))then return Data end
  return StatusLog(nil, "String2BGID: No data found")
end

-- props/model.mdl --> model.mdl
function StringFileModel(sModel)
  if(not IsString(sModel)) then
    return StatusLog("","StringFileModel: Model must be string") end
  if(IsEmptyString(sModel)) then
    return StatusLog(GetOpVar("MISS_NOAV"),"StringFileModel: Model is empty") end
  local sSymDir = GetOpVar("OPSYM_DIRECTORY")
  local nLen = stringLen(sModel)
  local nCnt = nLen
  local sCh  = stringSub(sModel,nCnt,nCnt)
  while(sCh ~= sSymDir and nCnt > 0) do
    nCnt = nCnt - 1
    sCh  = stringSub(sModel,nCnt,nCnt)
  end
  return stringSub(sModel,nCnt+1,Len)
end

----------------- PRINTS ------------------------

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

function ArrayPrint(arArr,sName,nCol)
  if(not IsExistent(arArr)) then
    return StatusLog(0,"ArrayPrint: Array missing") end
  if(not (type(arArr) == "table")) then
    return StatusLog(0,"ArrayPrint: Array is "..type(arArr)) end
  if(not arArr[1]) then
    return StatusLog(0,"ArrayPrint: Array empty") end
  local Cnt, Next = 1
  local Col, Max, Cols = 0, 0, 0
  local Line = (sName or "Data").." = { \n"
  local Pad  = StringPad(" "," ",stringLen(Line)-1)
  local symSep = GetOpVar("OPSYM_SEPARATOR")
  while(arArr[Cnt]) do
    Col = stringLen(tostring(arArr[Cnt]))
    if(Col > Max) then
      Max = Col
    end
    Cnt = Cnt + 1
  end
  Col  = mathClamp((tonumber(nCol) or 1),1,100)
  Cols = Col-1
  Cnt  = 1
  while(arArr[Cnt]) do
    Next = arArr[Cnt + 1]
    if(nCol and Cols == Col-1) then
      Line = Line..Pad
    end
    Line = Line..StringPad(tostring(arArr[Cnt])," ",-Max-1)
    if(Next) then
      Line = Line..symSep
    end
    if(nCol and Cols == 0) then
      Cols = Col - 1
      if(Next) then
        Line = Line.."\n"
      end
    elseif(nCol and Cols > 0) then
      Cols = Cols - 1
    end
    Cnt = Cnt + 1
  end
  LogInstance(Line.."\n}")
end

local function ArrayCount(arArr)
  if(not IsExistent(arArr)) then
    return StatusLog(nil,"ArrayCount: Array missing") end
  if(not (type(arArr) == "table")) then
    return StatusLog(nil,"ArrayCount: Array is "..type(arArr)) end
  if(not IsExistent(arArr[1])) then
    return StatusLog(0,"ArrayCount: Table is empty or hash based") end
  local Count = 1
  while(arArr[Count]) do Count = Count + 1 end
  return (Count - 1)
end

local function IsArrayOr(arArr,ivEnd)
  if(not IsExistent(arArr)) then
    return StatusLog(nil,"IsArrayOr: Array missing") end
  if(not (type(arArr) == "table")) then
    return StatusLog(nil,"IsArrayOr: Array is "..type(arArr)) end
  local iEnd = tonumber(ivEnd)
  if(not IsExistent(iEnd)) then
    return StatusLog(nil,"IsArrayOr: End NAN {"
             ..type(ivEnd).."}<"..tostring(ivEnd)..">") end
  local iCnt, bFlg = 1, false
  while(iCnt <= iEnd) do
    bFlg = bFlg or (arArr[iCnt] and true or false)
    iCnt = iCnt + 1
  end return bFlg
end

------------- Variable Interfaces --------------

local function SQLBuildError(anyError)
  if(not IsExistent(anyError)) then
    return GetOpVar("SQL_BUILD_ERR") or "" end
  SetOpVar("SQL_BUILD_ERR", tostring(anyError))
  return nil -- Nothing assembled
end

function SettingsModelToName(sMode, gCut, gSub, gApp)
  if(not IsString(sMode)) then
    return StatusLog(false,"SettingsModelToName: Wrong mode type "..type(sMode)) end
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

function PrintNotify(pPly,sText,sNotifType)
  if(not pPly) then return end
  if(SERVER) then
    pPly:SendLua("GAMEMODE:AddNotify(\""..sText.."\", NOTIFY_"..sNotifType..", 6)")
    pPly:SendLua("surface.PlaySound(\"ambient/water/drip"..mathRandom(1, 4)..".wav\")")
  end
end

function EmitSoundPly(pPly)
  if(not pPly) then return end
  pPly:EmitSound("physics/metal/metal_canister_impact_hard"..mathFloor(mathRandom(3))..".wav")
end

function LoadPlyKey(pPly, sKey)
  local keyPly = GetOpVar("HASH_PLAYER_KEYDOWN")
  local Cache  = libCache[keyPly]
  if(not IsExistent(Cache)) then
    libCache[keyPly] = {}
    Cache = libCache[keyPly]
  end
  if(not pPly) then return StatusLog(nil,"LoadPlyKey: Player not available") end
  local spName = pPly:GetName()
  if(not Cache[spName]) then
    Cache[spName]   = {
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
    Cache = Cache[spName]
  end
  if(IsExistent(sKey)) then
    if(not IsString(sKey)) then return StatusLog(nil,"LoadPlyKey: Key hash not correct") end
    if(sKey == "DEBUG") then
      return Cache
    end
    LogInstance("LoadPlyKey: NamePK <"..sKey.."> = "..tostring(Cache[sKey]))
    return Cache[sKey]
  end
  Cache["ALTLFT"]  = pPly:KeyDown(IN_ALT1      )
  Cache["ALTRGH"]  = pPly:KeyDown(IN_ALT2      )
  Cache["ATTLFT"]  = pPly:KeyDown(IN_ATTACK    )
  Cache["ATTRGH"]  = pPly:KeyDown(IN_ATTACK2   )
  Cache["FORWARD"] = pPly:KeyDown(IN_FORWARD   )
  Cache["BACK"]    = pPly:KeyDown(IN_BACK      )
  Cache["MOVELFT"] = pPly:KeyDown(IN_MOVELEFT  )
  Cache["MOVERGH"] = pPly:KeyDown(IN_MOVERIGHT )
  Cache["RELOAD"]  = pPly:KeyDown(IN_RELOAD    )
  Cache["USE"]     = pPly:KeyDown(IN_USE       )
  Cache["DUCK"]    = pPly:KeyDown(IN_DUCK      )
  Cache["JUMP"]    = pPly:KeyDown(IN_JUMP      )
  Cache["SPEED"]   = pPly:KeyDown(IN_SPEED     )
  Cache["SCORE"]   = pPly:KeyDown(IN_SCORE     )
  Cache["ZOOM"]    = pPly:KeyDown(IN_ZOOM      )
  Cache["LEFT"]    = pPly:KeyDown(IN_LEFT      )
  Cache["RIGHT"]   = pPly:KeyDown(IN_RIGHT     )
  Cache["WALK"]    = pPly:KeyDown(IN_WALK      )
  return StatusLog(nil,"LoadPlyKey: Player <"..spName.."> keys loaded")
end

-------------------------- AssemblyLib BUILDSQL ------------------------------

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
    if(not bStopEmpty and (snOut == "nil" or snOut == "")) then
      if(sModeDB == "SQL") then
        snOut = "NULL"
      elseif(sModeDB == "LUA") then
        snOut = "NULL"
      else
        return StatusLog(nil,"MatchType: Wrong database mode <"..sModeDB..">")
      end
    end
    if(defField[3] == "LOW") then
      snOut = stringLower(snOut)
    elseif(defField[3] == "CAP") then
      snOut = stringUpper(snOut)
    end
    if(not bStopRevise and sModeDB == "SQL" and defField[4] == "QMK") then
      snOut = string.gsub(snOut,"'","''")
    end
    if(bQuoted) then
      local sqChar
      if(sQuote) then
        sqChar = stringSub(tostring(sQuote),1,1)
      else
        if(sModeDB == "SQL") then
          sqChar = "'"
        elseif(sModeDB == "LUA") then
          sqChar = "\""
        end
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
  local namTable = defTable.Name
  local indTable = defTable.Index
  if(not defTable[1]) then
    return SQLBuildError("SQLBuildCreate: Missing table definition is empty for "..namTable) end
  if(not (defTable[1][1] and defTable[1][2])) then
    return SQLBuildError("SQLBuildCreate: Missing table "..namTable.." field definitions") end
  local Ind = 1
  local Command  = {}
  Command.Drop   = "DROP TABLE "..namTable..";"
  Command.Delete = "DELETE FROM "..namTable..";"
  Command.Create = "CREATE TABLE "..namTable.." ( "
  while(defTable[Ind]) do
    local v = defTable[Ind]
    if(not v[1]) then
      return SQLBuildError("SQLBuildCreate: Missing Table "..namTable
                          .."'s field #"..tostring(Ind)) end
    if(not v[2]) then
      return SQLBuildError("SQLBuildCreate: Missing Table "..namTable
                                  .."'s field type #"..tostring(Ind)) end
    Command.Create = Command.Create..stringUpper(v[1]).." "..stringUpper(v[2])
    if(defTable[Ind+1]) then Command.Create = Command.Create ..", " end
    Ind = Ind + 1
  end
  Command.Create = Command.Create.." );"
  if(indTable and
     indTable[1] and
     type(indTable[1]) == "table" and
     indTable[1][1] and
     type(indTable[1][1]) == "number"
   ) then
    Command.Index = {}
    Ind = 1
    Cnt = 1
    while(indTable[Ind]) do
      local vI = indTable[Ind]
      if(type(vI) ~= "table") then
        return SQLBuildError("SQLBuildCreate: Index creator mismatch on "
          ..namTable.." value "..vI.." is not a table for index ["..tostring(Ind).."]") end
      local FieldsU = ""
      local FieldsC = ""
      Command.Index[Ind] = "CREATE INDEX IND_"..namTable
      Cnt = 1
      while(vI[Cnt]) do
        local vF = vI[Cnt]
        if(type(vF) ~= "number") then
          return SQLBuildError("SQLBuildCreate: Index creator mismatch on "
            ..namTable.." value "..vF.." is not a number for index ["
            ..tostring(Ind).."]["..tostring(Cnt).."]") end
        if(not defTable[vF]) then
          return SQLBuildError("SQLBuildCreate: Index creator mismatch on "
            ..namTable..". The table does not have field index #"
            ..vF..", max is #"..Table.Size) end
        FieldsU = FieldsU.."_" ..stringUpper(defTable[vF][1])
        FieldsC = FieldsC..stringUpper(defTable[vF][1])
        if(vI[Cnt+1]) then FieldsC = FieldsC ..", " end
        Cnt = Cnt + 1
      end
      Command.Index[Ind] = Command.Index[Ind]..FieldsU.." ON "..namTable.." ( "..FieldsC.." );"
      Ind = Ind + 1
    end
  end
  SQLBuildError("")
  return Command
end

local function SQLStoreQuery(defTable,tFields,tWhere,tOrderBy,sQuery)
  if(not GetOpVar("EN_QUERY_STORE")) then return sQuery end
  local Val
  local Base
  if(not defTable) then
    return StatusLog(nil,"SQLStoreQuery: Missing table definition") end
  local tTimer = defTable.Timer
  if(not (tTimer and ((tonumber(tTimer[2]) or 0) > 0))) then
    return StatusLog(sQuery,"SQLStoreQuery: Skipped. Cache persistent forever") end
  local Field = 1
  local Where = 1
  local Order = 1
  local keyStore = GetOpVar("HASH_QUERY_STORE")
  local Cache    = libCache[keyStore]
  local namTable = defTable.Name
  if(not IsExistent(Cache)) then
    libCache[keyStore] = {}
    Cache = libCache[keyStore]
  end
  local Place = Cache[namTable]
  if(not IsExistent(Place)) then
    Cache[namTable] = {}
    Place = Cache[namTable]
  end
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
  local namTable = defTable.Name
  if(not (defTable[1][1] and defTable[1][2])) then
    return SQLBuildError("SQLBuildSelect: Missing table "..namTable.." field definitions") end
  local Command = SQLStoreQuery(defTable,tFields,tWhere,tOrderBy)
  if(IsString(Command)) then
    SQLBuildError("")
    return Command
  end
  local Cnt = 1
  Command = "SELECT "
  if(tFields) then
    while(tFields[Cnt]) do
      local v = tonumber(tFields[Cnt])
      if(not IsExistent(v)) then
        return SQLBuildError("SQLBuildSelect: Select index NAN {"
             ..type(tFields[Cnt]).."}<"..tostring(tFields[Cnt])
             .."> type mismatch in "..namTable) end
      if(defTable[v]) then
        if(defTable[v][1]) then
          Command = Command..defTable[v][1]
        else
          return SQLBuildError("SQLBuildSelect: Select no such field name by index #"
            ..v.." in the table "..namTable) end
      end
      if(tFields[Cnt+1]) then
        Command = Command ..", "
      end
      Cnt = Cnt + 1
    end
  else
    Command = Command.."*"
  end
  Command = Command .." FROM "..namTable
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
          ..namTable.." field index, {"..tostring(k)..","..tostring(v)..","..tostring(t)
          .."} value or type in the table definition") end
      v = MatchType(defTable,v,k,true)
      if(not IsExistent(v)) then
        return SQLBuildError("SQLBuildSelect: Data matching failed on "
          ..namTable.." field index #"..Cnt.." value <"..tostring(v)..">") end
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
                           ..namTable .." field index #"..Cnt) end
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
  if(not (defTable and tValues)) then
    return SQLBuildError("SQLBuildInsert: Missing Table definition or value fields")
  end
  local namTable = defTable.Name
  if(not defTable[1]) then
    return SQLBuildError("SQLBuildInsert: The table and the chosen fields must not be empty")
  end
  if(not (defTable[1][1] and
          defTable[1][2])
  ) then
    return SQLBuildError("SQLBuildInsert: Missing table "..namTable.." field definition")
  end
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
  local qIns = "INSERT INTO "..namTable.." ( "
  local Val, Ind, Fld
  while(tInsert[iCnt]) do
    Ind = tInsert[iCnt]
    Fld = defTable[Ind]
    if(not IsExistent(Fld)) then
      return SQLBuildError("SQLBuildInsert: No such field #"..Ind.." on table "..namTable)
    end
    Val = MatchType(defTable,tValues[iCnt],Ind,true)
    if(not IsExistent(Val)) then
      return SQLBuildError("SQLBuildInsert: Cannot match value <"..tostring(tValues[iCnt]).."> #"..Ind.." on table "..namTable)
    end
    qIns = qIns..Fld[1]
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
    return StatusLog(false,"CreateTable: Table key is not a string") end
  if(not (type(defTable) == "table")) then
    return StatusLog(false,"CreateTable: Table definition missing for "..sTable) end
  defTable.Size = ArrayCount(defTable)
  if(defTable.Size <= 0) then
    return StatusLog(false,"CreateTable: Record definition empty for "..sTable) end
  local sModeDB = GetOpVar("MODE_DATABASE")
  local sTable  = stringUpper(sTable)
  defTable.Name = GetOpVar("TOOLNAME_PU")..sTable
  SetOpVar("DEFTABLE_"..sTable,defTable)
  local sDisable = GetOpVar("OPSYM_DISABLE")
  local namTable = defTable.Name
  local Cnt, defField = 1, nil
  while(defTable[Cnt]) do
    defField    = defTable[Cnt]
    defField[3] = StringDefault(tostring(defField[3] or sDisable), sDisable)
    defField[4] = StringDefault(tostring(defField[4] or sDisable), sDisable)
    Cnt = Cnt + 1
  end
  libCache[namTable] = {}
  if(sModeDB == "SQL") then
    defTable.Life = tonumber(defTable.Life) or 0
    local tQ = SQLBuildCreate(defTable)
    if(not IsExistent(tQ)) then return StatusLog(false,"CreateTable: "..SQLBuildError()) end
    if(bDelete and sqlTableExists(namTable)) then
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
    if(sqlTableExists(namTable)) then
      LogInstance("CreateTable: Table "..sTable.." exists!")
      return true
    else
      local qRez = sqlQuery(tQ.Create)
      if(not qRez and IsBool(qRez)) then
        return StatusLog(false,"CreateTable: Table "..sTable
          .." failed to create because of "..sqlLastError()) end
      if(sqlTableExists(namTable)) then
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
    return StatusLog(false,"InsertRecord: Missing table definition name "..tostring(sTable).." ("..type(sTable)..")") end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"InsertRecord: Missing table definition for "..sTable) end
  if(not defTable[1])  then
    return StatusLog(false,"InsertRecord: Missing table definition is empty for "..sTable) end
  if(not tData)      then
    return StatusLog(false,"InsertRecord: Missing data table for "..sTable) end
  if(not tData[1])   then
    return StatusLog(false,"InsertRecord: Missing data table is empty for "..sTable) end
  local namTable = defTable.Name

  if(sTable == "PIECES") then
    tData[2] = StringDisable(tData[2],DefaultType(),"TYPE")
    tData[3] = StringDisable(tData[3],ModelToName(tData[1]),"MODEL")
  elseif(sTable == "PHYSPROPERTIES") then
    tData[1] = StringDisable(tData[1],DefaultType(),"TYPE")
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
    local Cache = libCache[namTable]
    if(not IsExistent(Cache)) then
      return StatusLog(false,"InsertRecord: Cache not allocated for "..namTable) end
    if(sTable == "PIECES") then
      local tLine = Cache[snPrimaryKey]
      if(not tLine) then
        Cache[snPrimaryKey] = {}
        tLine = Cache[snPrimaryKey]
      end
      if(not IsExistent(tLine.Type)) then tLine.Type = tData[2] end
      if(not IsExistent(tLine.Name)) then tLine.Name = tData[3] end
      if(not IsExistent(tLine.Kept)) then tLine.Kept = 0        end
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
      local tLine = Cache[snPrimaryKey]
      if(not tLine) then
        Cache[snPrimaryKey] = {}
        tLine = Cache[snPrimaryKey]
      end
      if(not IsExistent(tLine.Kept)) then tLine.Kept = 0 end
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
      local tTypes   = Cache[sKeyType]
      local tNames   = Cache[sKeyName]
      -- Handle the Type
      if(not tTypes) then
        Cache[sKeyType] = {}
        tTypes = Cache[sKeyType]
        tTypes.Kept = 0
      end
      if(not tNames) then
        Cache[sKeyName] = {}
        tNames = Cache[sKeyName]
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
      end -- MatchType crashes only on numbers
      tNames[snPrimaryKey].Kept = iNameID
      tNames[snPrimaryKey][iNameID] = MatchType(defTable,tData[3],3)
    else
      return StatusLog(false,"InsertRecord: No settings for table "..sTable)
    end
  end
end

--------------------------- AssemblyLib PIECE QUERY -----------------------------

local function NavigateTable(oLocation,tKeys)
  if(not IsExistent(oLocation)) then
    return StatusLog(nil,"NavigateTable: Location missing") end
  if(not IsExistent(tKeys)) then
    return StatusLog(nil,"NavigateTable: Key table missing") end
  if(not IsExistent(tKeys[1])) then
    return StatusLog(nil,"NavigateTable: First key missing") end
  local Place, Key, Cnt = oLocation, tKeys[1], 1
  while(tKeys[Cnt]) do
    Key = tKeys[Cnt]
    if(tKeys[Cnt+1]) then
      Place = Place[Key]
      if(not IsExistent(Place)) then
        return StatusLog(nil,"NavigateTable: Key #"..tostring(Key).." irrelevant to location") end
    end
    Cnt = Cnt + 1
  end
  return Place, Key
end

--------------- TIMER MEMORY MANAGMENT ----------------------------

function TimerSetting(sTimerSet) -- Generates a timer settings table and keeps the defaults
  if(not IsExistent(sTimerSet)) then
    return StatusLog(nil,"TimerSetting: Timer set missing for setup") end
  if(not IsString(sTimerSet)) then
    return StatusLog(nil,"TimerSetting: Timer set not a string but "..type(sTimerSet)) end
  local tBoom = StringExplode(sTimerSet,GetOpVar("OPSYM_REVSIGN"))
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
  LogInstance("TimerAttach: Called by <"..anyMessage.."> for Place["..tostring(Key).."]")
  if(sModeDB == "SQL") then
    if(IsExistent(Place[Key].Kept)) then Place[Key].Kept = Place[Key].Kept - 1 end -- Get the proper line count
    local tTimer = defTable.Timer -- If we have a timer, and it does speak, we advise you send your regards..
    if(not IsExistent(tTimer)) then
      return StatusLog(Place[Key],"TimerAttach: Missing timer settings") end
    local nLifeTM = tTimer[2]
    if(nLifeTM <= 0) then
      return StatusLog(Place[Key],"TimerAttach: Timer attachment ignored") end
    local sModeTM = tTimer[1]
    local bKillRC = tTimer[3]
    local bCollGB = tTimer[4]
    LogInstance("TimerAttach: ["..sModeTM.."] ("..tostring(nLifeTM)..") "..tostring(bKillRC)..", "..tostring(bCollGB))
    if(sModeTM == "CQT") then
      Place[Key].Load = Time()
      for k, v in pairs(Place) do
        if(IsExistent(v.Used) and IsExistent(v.Load) and ((v.Used - v.Load) > nLifeTM)) then
          LogInstance("TimerAttach: ("..tostring(v.Used - v.Load).." > "..tostring(nLifeTM)..") > Dead")
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
      return StatusLog(Place[Key],"TimerAttach: Place["..tostring(Key).."].Load = "..tostring(Place[Key].Load))
    elseif(sModeTM == "OBJ") then
      local TimerID = StringImplode(tKeys,"_")
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
      local keyTimerID = StringImplode(tKeys,GetOpVar("OPSYM_DIVIDER"))
      if(not timerExists(keyTimerID)) then
        return StatusLog(nil,"TimerRestart: Timer missing <"..keyTimerID..">") end
      timerStart(keyTimerID)
    else return StatusLog(nil,"TimerRestart: Timer mode not found <"..sModeTM..">") end
  elseif(sModeDB == "LUA") then Place[Key].Used = Time()
  else return StatusLog(nil,"TimerRestart: Wrong database mode") end
  return Place[Key]
end

-- Cashing the selected Piece Result
function CacheQueryPiece(sModel)
  if(not IsExistent(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model does not exist") end
  if(not IsString(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model is not string") end
  if(IsEmptyString(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model empty string") end
  if(not utilIsValidModel(sModel)) then
    return StatusLog(nil,"CacheQueryPiece: Model invalid") end
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not defTable) then
    return StatusLog(nil,"CacheQueryPiece: Table definition missing") end
  local namTable = defTable.Name
  local Cache    = libCache[namTable]
  if(not IsExistent(Cache)) then
    return StatusLog(nil,"CacheQueryPiece: Cache not allocated for <"..namTable..">") end
  local caInd    = {namTable,sModel}
  local stPiece  = Cache[sModel]
  if(IsExistent(stPiece) and IsExistent(stPiece.Kept)) then
    if(stPiece.Kept > 0) then
      return TimerRestart(libCache,caInd,defTable,"CacheQueryPiece")
    end
    return nil
  else
    local sModeDB = GetOpVar("MODE_DATABASE")
    local sModel  = MatchType(defTable,sModel,1,false,"",true,true)
    if(sModeDB == "SQL") then
      LogInstance("CacheQueryPiece: Model >> Pool <"..StringFileModel(sModel)..">")
      Cache[sModel] = {}
      stPiece = Cache[sModel]
      stPiece.Kept = 0
      local Q = SQLBuildSelect(defTable,nil,{{1,sModel}},{4})
      if(not IsExistent(Q)) then
        return StatusLog(nil,"CacheQueryPiece: Build error <"..SQLBuildError()..">") end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        return StatusLog(nil,"CacheQueryPiece: SQL exec error <"..sqlLastError()..">") end
      if(not (qData and qData[1])) then
        return StatusLog(nil,"CacheQueryPiece: No data found <"..Q..">") end
      stPiece.Kept = 1 --- Found at least one record
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
    return StatusLog(nil,"CacheQueryAdditions: Model not string") end
  if(IsEmptyString(sModel)) then
    return StatusLog(nil,"CacheQueryAdditions: Model empty string") end
  if(not utilIsValidModel(sModel)) then 
    return StatusLog(nil,"CacheQueryAdditions: Model invalid") end
  local defTable = GetOpVar("DEFTABLE_ADDITIONS")
  if(not defTable) then
    return StatusLog(nil,"CacheQueryAdditions: Missing table definition") end
  local sModel   = MatchType(defTable,sModel,1,false,"",true,true)
  local namTable = defTable.Name
  local Cache    = libCache[namTable]
  if(not IsExistent(Cache)) then
    return StatusLog(nil,"CacheQueryAdditions: Cache not allocated for <"..namTable..">") end
  local caInd    = {namTable,sModel}
  local stAddition = Cache[sModel]
  if(IsExistent(stAddition) and IsExistent(stAddition.Kept)) then
    if(stAddition.Kept > 0) then
      return TimerRestart(libCache,caInd,defTable,"CacheQueryAdditions") end
    return nil
  else
    local sModeDB = GetOpVar("MODE_DATABASE")
    if(sModeDB == "SQL") then
      LogInstance("CacheQueryAdditions: Model >> Pool <"..StringFileModel(sModel)..">")
      Cache[sModel] = {}
      stAddition = Cache[sModel]
      stAddition.Kept = 0
      local Q = SQLBuildSelect(defTable,{2,3,4,5,6,7,8,9,10,11,12},{{1,sModel}},{4})
      if(not IsExistent(Q)) then
        return StatusLog(nil,"CacheQueryAdditions: Build error <"..SQLBuildError()..">") end
      local qData = sqlQuery(Q)
      if(not qData and IsBool(qData)) then
        return StatusLog(nil,"CacheQueryAdditions: SQL exec error <"..sqlLastError()..">") end
      if(not (qData and qData[1])) then
        return StatusLog(nil,"CacheQueryAdditions: No data found <"..Q..">") end
      stAddition.Kept = 1
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

----------------------- AssemblyLib PANEL QUERY -------------------------------

--- Used to Populate the CPanel Tree
function CacheQueryPanel()
  local defTable = GetOpVar("DEFTABLE_PIECES")
  if(not defTable) then
    return StatusLog(false,"CacheQueryPanel: Missing table definition") end
  local namTable = defTable.Name
  local keyPanel = GetOpVar("HASH_USER_PANEL")
  if(not IsExistent(libCache[namTable])) then
    return StatusLog(nil,"CacheQueryPanel: Cache not allocated for <"..namTable..">") end
  local stPanel = libCache[keyPanel]
  local caInd = {keyPanel}
  if(IsExistent(stPanel) and IsExistent(stPanel.Kept)) then
    LogInstance("CacheQueryPanel: From Pool")
    if(stPanel.Kept > 0) then
      return TimerRestart(libCache,caInd,defTable,"CacheQueryPanel") end
    return nil
  else
    libCache[keyPanel] = {}
    stPanel = libCache[keyPanel]
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
      local Cache = libCache[namTable]
      local tData = {}
      local iNdex = 0
      for sModel, tRecord in pairs(Cache) do
        tData[sModel] = {[defTable[1][1]] = sModel, [defTable[2][1]] = tRecord.Type, [defTable[3][1]] = tRecord.Name}
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
  local namTable = defTable.Name
  local Cache    = libCache[namTable]
  if(not Cache) then
    return StatusLog(nil,"CacheQueryProperty["..tostring(sType).."]: Cache not allocated for <"..namTable..">") end
  local sModeDB = GetOpVar("MODE_DATABASE")
  if(IsString(sType) and (sType ~= "")) then -- Get names per type
    local sType   = MatchType(defTable,sType,1,false,"",true,true)
    local keyName = GetOpVar("HASH_PROPERTY_NAMES")
    local arNames = Cache[keyName]
    local caInd   = {namTable,keyName,sType}
    if(not IsExistent(arNames)) then
      Cache[keyName] = {}
      arNames = Cache[keyName]
    end
    local stName = arNames[sType]
    if(IsExistent(stName) and IsExistent(stName.Kept)) then
      LogInstance("CacheQueryProperty["..sType.."]: From Pool")
      if(stName.Kept > 0) then
        return TimerRestart(libCache,caInd,defTable,"CacheQueryProperty") end
      return nil
    else
      if(sModeDB == "SQL") then
        arNames[sType] = {}
        stName = arNames[sType]
        stName.Kept = 0
        local Q = SQLBuildSelect(defTable,{3},{{1,sType}},{2})
        if(not IsExistent(Q)) then
          return StatusLog(nil,"CacheQueryProperty["..sType.."]: Build error: <"..SQLBuildError()..">") end
        local qData = sqlQuery(Q)
        if(not qData and IsBool(qData)) then
          return StatusLog(nil,"CacheQueryProperty: SQL exec error <"..sqlLastError()..">") end
        if(not (qData and qData[1])) then
          return StatusLog(nil,"CacheQueryProperty["..sType.."]: No data found <"..Q..">") end
        stName.Kept = 1
        while(qData[stName.Kept]) do
          stName[stName.Kept] = qData[stName.Kept][defTable[3][1]]
          stName.Kept = stName.Kept + 1
        end
        return TimerAttach(libCache,caInd,defTable,"CacheQueryProperty")
      elseif(sModeDB == "LUA") then return StatusLog(nil,"CacheQueryProperty["..sType.."]: Record not located")
      else return StatusLog(nil,"CacheQueryProperty["..sType.."]: Wrong database mode <"..sModeDB..">") end
    end
  else
    local keyType = GetOpVar("HASH_PROPERTY_TYPES")
    local stType  = Cache[keyType]
    local caInd   = {namTable,keyType}
    if(IsExistent(stType) and IsExistent(stType.Kept)) then -- Get All type names
      LogInstance("CacheQueryProperty: From Pool")
      if(stType.Kept > 0) then
        return TimerRestart(libCache,caInd,defTable,"CacheQueryProperty") end
      return nil
    else
      if(sModeDB == "SQL") then
        Cache[keyType] = {}
        stType = Cache[keyType]
        stType.Kept = 0
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
        return TimerAttach(libCache,caInd,defTable,"CacheQueryProperty")
      elseif(sModeDB == "LUA") then return StatusLog(nil,"CacheQueryProperty: Record not located")
      else return StatusLog(nil,"CacheQueryProperty: Wrong database mode <"..sModeDB..">") end
    end
  end
end

function GetCenterPoint(oRec,sO)
  if(not IsString(sO)) then
    return StatusLog(nil,"GetCenterPoint: Wrong offset type") end
  if((sO ~= "P") and (sO ~= "O")) then
    return StatusLog(nil,"GetCenterPoint: Wrong offset name") end
  if(not oRec) then
    return StatusLog(nil,"GetCenterPoint: Missing piece record") end
  if(not oRec.Offs) then
    return StatusLog(nil,"GetCenterPoint: No piece offsets") end
  if(not oRec.Offs[1]) then
    return StatusLog(nil,"GetCenterPoint: Missing piece offset") end
  local iInd, rCur = 1
  local vCent = Vector()
  while(oRec.Offs[iInd]) do
    rCur = oRec.Offs[iInd][sO]
    AddVectorXYZ(vCent,rCur[cvX],rCur[cvY],rCur[cvZ])
    iInd = iInd + 1
  end
  if(iInd > 1) then
    vCent:Mul(1/(iInd-1))
  end
  return vCent
end

---------------------- AssemblyLib EXPORT --------------------------------

local function GetFieldsName(defTable,sDelim)
  if(not IsExistent(sDelim)) then return "" end
  local sDelim  = stringSub(tostring(sDelim),1,1)
  local sResult = ""
  if(sDelim == "") then
    return StatusLog("","GetFieldsName: Invalid delimiter for <"..defTable.Name..">") end
  local iCount  = 1
  local namField
  while(defTable[iCount]) do
    namField = defTable[iCount][1]
    if(not IsString(namField)) then
      return StatusLog("","GetFieldsName: Invalid field #"..iCount.." for <"..defTable.Name..">") end
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
function ImportFromDSV(sTable,sDelim,bCommit,sPrefix)
  if(not IsString(sTable)) then
    return StatusLog(false,"ImportFromDSV: Table name should be string but "..type(sTable)) end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ImportFromDSV: Missing table definition for <"..sTable..">") end
  local namTable = defTable.Name
  local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_DSV")
        fName = fName..(sPrefix or GetInstPref())..namTable..".txt"
  local F = fileOpen(fName, "r", "DATA")
  if(not F) then return StatusLog(false,"ImportFromDSV: fileOpen("..fName..".txt) Failed") end
  local Line = ""
  local TabLen = stringLen(namTable)
  local LinLen = 0
  local ComCnt = 0
  local SymOff = GetOpVar("OPSYM_DISABLE")
  local Ch = "X" -- Just to be something
  while(Ch) do
    Ch = F:Read(1)
    if(not Ch) then return end
    if(Ch == "\n") then
      LinLen = stringLen(Line)
      if(stringSub(Line,LinLen,LinLen) == "\r") then
        Line = stringSub(Line,1,LinLen-1)
        LinLen = LinLen - 1
      end
      if(not (stringSub(Line,1,1) == SymOff)) then
        if(stringSub(Line,1,TabLen) == namTable) then
          local Data = StringExplode(stringSub(Line,TabLen+2,LinLen),sDelim)
          for k,v in pairs(Data) do
            local vLen = stringLen(v)
            if(stringSub(v,1,1) == "\"" and stringSub(v,vLen,vLen) == "\"") then
              Data[k] = stringSub(v,2,vLen-1)
            end
          end
          if(bCommit) then
            InsertRecord(sTable,Data)
          end
        end
      end
      Line = ""
    else
      Line = Line..Ch
    end
  end
  F:Close()
end

function ExportIntoFile(sTable,sDelim,sMethod,sPrefix)
  if(not IsString(sTable)) then
    return StatusLog(false,"ExportIntoFile: Table name should be string but "..type(sTable)) end
  if(not IsString(sMethod)) then
    return StatusLog(false,"ExportIntoFile: Export mode should be string but "..type(sTable)) end
  local defTable = GetOpVar("DEFTABLE_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ExportIntoFile: Missing table definition for <"..sTable..">") end
  local fName = GetOpVar("DIRPATH_BAS")
  local namTable = defTable.Name
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  if    (sMethod == "DSV") then fName = fName..GetOpVar("DIRPATH_DSV")
  elseif(sMethod == "INS") then fName = fName..GetOpVar("DIRPATH_EXP")
  else return StatusLog(false,"Missed export method: <"..sMethod..">") end
  if(not fileExists(fName,"DATA")) then fileCreateDir(fName) end
  fName = fName..(sPrefix or GetInstPref())..namTable..".txt"
  local F = fileOpen(fName, "w", "DATA" )
  if(not F) then return StatusLog(false,"ExportIntoFile: fileOpen("..fName..") Failed") end
  local sData = ""
  local sTemp = ""
  local sModeDB = GetOpVar("MODE_DATABASE")
  F:Write("# ExportIntoFile( "..sMethod.." ): "..osDate().." [ "..sModeDB.." ]".."\n")
  F:Write("# Data settings: "..GetFieldsName(defTable,sDelim).."\n")
  if(sModeDB == "SQL") then
    local Q = ""
    if    (sTable == "PIECES"        ) then Q = SQLBuildSelect(defTable,nil,nil,{2,3,1,4})
    elseif(sTable == "ADDITIONS"     ) then Q = SQLBuildSelect(defTable,nil,nil,{1,4})
    elseif(sTable == "PHYSPROPERTIES") then Q = SQLBuildSelect(defTable,nil,nil,{1,2})
    else                                    Q = SQLBuildSelect(defTable,nil,nil,nil) end
    if(not IsExistent(Q)) then return StatusLog(false,"ExportIntoFile: Build error <"..SQLBuildError()..">") end
    F:Write("# Query ran: <"..Q..">\n")
    local qData = sqlQuery(Q)
    if(not qData and IsBool(qData)) then
      return StatusLog(nil,"ExportIntoFile: SQL exec error <"..sqlLastError()..">") end
    if(not (qData and qData[1])) then
      return StatusLog(false,"ExportIntoFile: No data found <"..Q..">") end
    local iCnt, iInd, qRec = 1, 1, nil
    if    (sMethod == "DSV") then sData = namTable..sDelim
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
      if(sMethod == "DSV") then
        sTemp = sTemp.."\n"
      elseif(sMethod == "INS") then
        sTemp = sTemp.."})\n"
      end
      F:Write(sTemp)
      iCnt = iCnt + 1
    end
  elseif(sModeDB == "LUA") then
    local Cache = libCache[namTable]
    if(not IsExistent(Cache)) then
      return StatusLog(false,"ExportIntoFile: Table <"..namTable.."> cache not allocated") end
    if(sTable == "PIECES") then
      local tData = {}
      local iInd iNdex = 1,1
      for sModel, tRecord in pairs(Cache) do
        sData = tRecord.Type..tRecord.Name..sModel
        tData[sModel] = {[defTable[1][1]] = sData}
      end
      local tSorted = Sort(tData,nil,{defTable[1][1]})
      if(not tSorted) then
        return StatusLog(false,"ExportIntoFile: Cannot sort cache data") end
      iNdex = 1
      while(tSorted[iNdex]) do
        iInd = 1
        tData = Cache[tSorted[iNdex].Key]
        if    (sMethod == "DSV") then sData = namTable..sDelim
        elseif(sMethod == "INS") then sData = "  asmlib.InsertRecord(\""..sTable.."\", {" end
        sData = sData..MatchType(defTable,tSorted[iNdex].Key,1,true,"\"")..sDelim..
                       MatchType(defTable,tData.Type,2,true,"\"")..sDelim..
                       MatchType(defTable,tData.Name,3,true,"\"")..sDelim
        -- Matching crashes only for numbers
        while(tData.Offs[iInd]) do -- The number is already inserted, so there will be no crash
          sTemp = sData..MatchType(defTable,iInd,4,true,"\"")..sDelim..
                        "\""..StringPOA(tData.Offs[iInd].P,"V").."\""..sDelim..
                        "\""..StringPOA(tData.Offs[iInd].O,"V").."\""..sDelim..
                        "\""..StringPOA(tData.Offs[iInd].A,"A").."\""
          if    (sMethod == "DSV") then sTemp = sTemp.."\n"
          elseif(sMethod == "INS") then sTemp = sTemp.."})\n" end
          F:Write(sTemp)
          iInd = iInd  + 1
        end
        iNdex = iNdex + 1
      end
    elseif(sTable == "ADDITIONS") then
      local iNdex, tData
      for sModel, tRecord in pairs(Cache) do
        if    (sMethod == "DSV") then sData = namTable..sDelim..sModel..sDelim
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
      local tTypes = Cache[GetOpVar("HASH_PROPERTY_TYPES")]
      local tNames = Cache[GetOpVar("HASH_PROPERTY_NAMES")]
      if(not (tTypes or tNames)) then
        return StatusLog(false,"ExportIntoFile: No data found") end
      local iInd, iCnt = 1, 1
      local sType, sName = "", ""
      local tType
      while(tTypes[iInd]) do
        sType = tTypes[iInd]
        tType = tNames[sType]
        if(not tType) then return
          StatusLog(false,"ExportIntoFile: Missing index #"..iInd.." on type <"..sType..">") end
        if    (sMethod == "DSV") then sData = namTable..sDelim
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

----------------------------- AssemblyLib SNAPPING ------------------------------

--[[
 * This function is the backbone of the tool for Trace.HitWorld
 * Calculates SPos, SAng based on the DB inserts and input parameters
 * ucsPos        = Base UCS Pos
 * ucsAng        = Base UCS Ang
 * ivhdPointID   = Client Point ID
 * shdModel      = Client Model
 * ucsPos(X,Y,Z) = Offset position
 * ucsAng(P,Y,R) = Offset angle
]]--
function GetNormalSpawn(ucsPos,ucsAng,shdModel,ivhdPointID,
                        ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
  if(not (ucsPos and ucsAng and shdModel and ivhdPointID)) then
    return StatusLog(nil,"GetNormalSpawn: Mismatched input parameters") end
  local ihdPointID = tonumber(ivhdPointID)
  if(not IsExistent(ihdPointID)) then
    return StatusLog(nil,"GetNormalSpawn: Holder point ID NAN {"..type(ivhdPointID).."}<"..tostring(ivhdPointID)..">") end
  local hdRec = CacheQueryPiece(shdModel)
  if(not IsExistent(hdRec)) then
    return StatusLog(nil,"GetNormalSpawn: No record located") end
  local stPoint = LocateRecID(hdRec,ihdPointID)
  if(not IsExistent(stPoint)) then
    return StatusLog(nil,"GetNormalSpawn: Holder point ID invalid #"..tostring(ihdPointID)) end
  local stSpawn = GetOpVar("SPAWN_NORMAL")
  stSpawn.HRec = hdRec
  SetAngle(stSpawn.MAng,stPoint.A)
  SetVector(stSpawn.MPos,stPoint.O)
  -- Orient the UCS
  stSpawn.OAng:Set(ucsAng)
  stSpawn.F:Set(stSpawn.OAng:Forward())
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  --- Offset NOW !
  stSpawn.SPos:Set(ucsPos)
  stSpawn.SPos:Add(stSpawn.F * (tonumber(ucsPosX) or 0))
  stSpawn.SPos:Add(stSpawn.R * (tonumber(ucsPosY) or 0))
  stSpawn.SPos:Add(stSpawn.U * (tonumber(ucsPosZ) or 0))
  stSpawn.OPos:Set(stSpawn.SPos)
  stSpawn.OAng:RotateAroundAxis(stSpawn.R, (tonumber(ucsAngP) or 0))
  stSpawn.OAng:RotateAroundAxis(stSpawn.U,-(tonumber(ucsAngY) or 0))
  stSpawn.F:Set(stSpawn.OAng:Forward())
  stSpawn.OAng:RotateAroundAxis(stSpawn.F, (tonumber(ucsAngR) or 0))
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  -- Init Model Offsets
  stSpawn.MAng:RotateAroundAxis(stSpawn.MAng:Up(),180)
  stSpawn.MPos:Mul(-1)
  stSpawn.MPos:Set(DecomposeByAngle(stSpawn.MPos,stSpawn.MAng))
  -- Make Spawn Pos
  stSpawn.SPos:Add(stSpawn.F * (stSpawn.MPos[cvX] * stPoint.O[csX]))
  stSpawn.SPos:Add(stSpawn.R * (stSpawn.MPos[cvY] * stPoint.O[csY]))
  stSpawn.SPos:Add(stSpawn.U * (stSpawn.MPos[cvZ] * stPoint.O[csZ]))
  -- Make Spawn Ang
  stSpawn.SAng:Set(stSpawn.OAng)
  stSpawn.SAng:RotateAroundAxis(-stSpawn.R,stSpawn.MAng[caP] * stPoint.A[csX])
  stSpawn.SAng:RotateAroundAxis(-stSpawn.U,stSpawn.MAng[caY] * stPoint.A[csY])
  stSpawn.SAng:RotateAroundAxis(-stSpawn.F,stSpawn.MAng[caR] * stPoint.A[csZ])
  SetVector(stSpawn.PPos,stPoint.P)
  stSpawn.PPos:Rotate(stSpawn.SAng)
  stSpawn.PPos:Add(stSpawn.SPos)
  return stSpawn
end

--[[
 * This function is the backbone of the tool for Trace.Entity
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
  if(not IsExistent(hdRec)) then
    return StatusLog(nil,"GetEntitySpawn: Trace model missing <"..trEnt:GetModel()..">") end
  if(not IsExistent(LocateRecID(trRec,1))) then
    return StatusLog(nil,"GetEntitySpawn: Trace has no points") end
  local hdRec  = CacheQueryPiece(shdModel)
  if(not IsExistent(hdRec)) then
    return StatusLog(nil,"GetEntitySpawn: Holder model missing <"..tostring(shdModel)..">") end
  local hdOffs = LocateRecID(hdRec,ihdPointID)
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
  local trAng = trEnt:GetAngles()
  local trPos = trEnt:GetPos()
  -- We have the next Piece Offset
  local stSpawn, trOffs = GetOpVar("SPAWN_ENTITY")
        stSpawn.RLen = nActRadius
        stSpawn.OID  = 0
  for ID = 1, trRec.Kept do
    -- Indexing is actually with 70% faster using this method than pairs
    local vOff = LocateRecID(trRec,ID)
    if(not IsExistent(vOff)) then
      return StatusLog(nil,"GetEntitySpawn: Trace point count mismatch on #"..tostring(ID)) end
    SetVector(stSpawn.MPos,vOff.P)
    stSpawn.MPos:Rotate(trAng)
    stSpawn.MPos:Add(trPos)
    stSpawn.MPos:Sub(trHitPos)
    local trAcDis = stSpawn.MPos:Length()
    if(trAcDis < stSpawn.RLen) then
      trOffs       = vOff
      stSpawn.OID  = ID
      stSpawn.RLen = trAcDis
      stSpawn.PPos:Set(stSpawn.MPos)
      stSpawn.PPos:Add(trHitPos)
    end
  end
  -- Found the active point ID on trEnt
  if(not IsExistent(trOffs)) then
    return StatusLog(nil,"GetEntitySpawn: Not hitting active point") end
  --Do origin !
  SetVector(stSpawn.OPos,trOffs.O)
  stSpawn.OPos:Rotate(trAng)
  stSpawn.OPos:Add(trPos)
  --- Do Origin UCS World angle
  SetAngle(stSpawn.OAng,trOffs.A)
  stSpawn.OAng:Set(trEnt:LocalToWorldAngles(stSpawn.OAng))
  -- Do the flatten flag right now Its important !
  if(enFlatten and enFlatten ~= 0) then
    stSpawn.OAng[caP] = 0
    stSpawn.OAng[caR] = 0
  end
  --- Do F,R,U
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  stSpawn.OAng:RotateAroundAxis(stSpawn.R, (tonumber(ucsAngP) or 0))
  stSpawn.OAng:RotateAroundAxis(stSpawn.U,-(tonumber(ucsAngY) or 0))
  stSpawn.F:Set(stSpawn.OAng:Forward())
  stSpawn.OAng:RotateAroundAxis(stSpawn.F, (tonumber(ucsAngR) or 0))
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  --- F R U Ready, Save our records
  stSpawn.HRec = hdRec
  stSpawn.TRec = trRec
  --Get Hold model stuff
  SetAngle(stSpawn.MAng,hdOffs.A)
  stSpawn.MAng:RotateAroundAxis(stSpawn.MAng:Up(),180)
  SetVector(stSpawn.MPos,hdOffs.O)
  NegVector(stSpawn.MPos)
  stSpawn.MPos:Set(DecomposeByAngle(stSpawn.MPos,stSpawn.MAng))
  NegAngle(stSpawn.MAng)
  --Do Spawn Pos
  stSpawn.SPos:Set(stSpawn.OPos)
  stSpawn.SPos:Add((hdOffs.O[csX] * stSpawn.MPos[cvX] + (tonumber(ucsPosX) or 0)) * stSpawn.F)
  stSpawn.SPos:Add((hdOffs.O[csY] * stSpawn.MPos[cvY] + (tonumber(ucsPosY) or 0)) * stSpawn.R)
  stSpawn.SPos:Add((hdOffs.O[csZ] * stSpawn.MPos[cvZ] + (tonumber(ucsPosZ) or 0)) * stSpawn.U)
  --Do Spawn Angle
  SetAngle(stSpawn.SAng,stSpawn.OAng)
  stSpawn.SAng:RotateAroundAxis(stSpawn.R,stSpawn.MAng[caP] * hdOffs.A[csX])
  stSpawn.SAng:RotateAroundAxis(stSpawn.U,stSpawn.MAng[caY] * hdOffs.A[csY])
  stSpawn.SAng:RotateAroundAxis(stSpawn.F,stSpawn.MAng[caR] * hdOffs.A[csZ])
  return stSpawn
end

function AttachAdditions(ePiece)
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"AttachAdditions: Piece invalid") end
  local LocalAng = ePiece:GetAngles()
  local LocalPos = ePiece:GetPos()
  local LocalMod = ePiece:GetModel()
  local qData = CacheQueryAdditions(LocalMod)
  if(not IsExistent(qData)) then
    return StatusLog(true,"AttachAdditions: Model <"..LocalMod.."> has no additions") end
  LogInstance("AttachAdditions: Called for model <"..LocalMod..">")
  local Record, Addition
  local Cnt = 1
  local defTable = GetOpVar("DEFTABLE_ADDITIONS")
  while(qData[Cnt]) do
    Record   = qData[Cnt]
    LogInstance("\n\nEnt [ "..Record[defTable[4][1]].." ] INFO : ")
    Addition = entsCreate(Record[defTable[3][1]])
    if(Addition and Addition:IsValid()) then
      LogInstance("Addition Class: "..Record[defTable[3][1]])
      if(fileExists(Record[defTable[2][1]], "GAME")) then
        Addition:SetModel(Record[defTable[2][1]])
        LogInstance("Addition:SetModel("..Record[defTable[2][1]]..")")
      else return StatusLog(false,"AttachAdditions: No such attachment model "..Record[defTable[2][1]]) end
      local OffPos = Record[defTable[5][1]]
      if(not IsString(OffPos)) then
        return StatusLog(false,"AttachAdditions: Position is not a string but "..type(OffPos)) end
      if(OffPos       and
         OffPos ~= "" and
         OffPos ~= "NULL"
      ) then
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
      local OffAngle = Record[defTable[6][1]]
      if(not IsString(OffAngle)) then
        return StatusLog(false,"AttachAdditions: Angle is not a string but "..type(OffAngle)) end
      if(OffAngle       and
         OffAngle ~= "" and
         OffAngle ~= "NULL"
      ) then
        local AdditionAng = Angle()
        local arConv = DecodePOA(OffAngle)
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
          .."\n     Modelbse: "..qData[Cnt][defTable[1][1]]
          .."\n     Addition: "..qData[Cnt][defTable[2][1]]
          .."\n     ENTclass: "..qData[Cnt][defTable[3][1]])
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
  if(not (Trace.Entity and Trace.Entity:IsValid())) then
    return StatusLog(nil,"GetEntityOrTrace: Trace entity invalid") end
  return Trace.Entity
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

function GetPropBodyGrp(oEnt)
  local bgEnt = GetEntityOrTrace(oEnt)
  if(not IsExistent(bgEnt)) then
    return StatusLog("","GetPropBodyGrp: Failed to gather entity") end
  if(IsOther(bgEnt)) then
    return StatusLog("","GetPropBodyGrp: Entity other type") end
  local BGs = bgEnt:GetBodyGroups()
  if(not (BGs and BGs[1])) then
    return StatusLog("","GetPropBodyGrp: Bodygroup table empty") end
  local Rez, Cnt = "", 1
  local symSep = GetOpVar("OPSYM_SEPARATOR")
  while(BGs[Cnt]) do
    Rez = Rez..symSep..tostring(bgEnt:GetBodygroup(BGs[Cnt].id) or 0)
    Cnt = Cnt + 1
  end
  Rez = stringSub(Rez,2,-1)
  Print(BGs,"GetPropBodyGrp: BGs")
  return StatusLog(Rez,"GetPropBodyGrp: Success <"..Rez..">")
end

function AttachBodyGroups(ePiece,sBgrpIDs)
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"AttachBodyGroups: Base entity invalid") end
  local sBgrpIDs = sBgrpIDs or ""
  if(not (sBgrpIDs and IsString(sBgrpIDs))) then
    return StatusLog(false,"AttachBodyGroups: Expecting string argument") end
  LogInstance("AttachBodyGroups: BGS <"..sBgrpIDs..">")
  local IDs = String2BGID(sBgrpIDs)
  if(not IsExistent(IDs)) then -- Nil or table
    return StatusLog(false,"AttachBodyGroups: Bodygroup ID not matched") end
  local Cnt = 1
  local BGs = ePiece:GetBodyGroups()
  local symSep = GetOpVar("OPSYM_SEPARATOR")
  while(BGs[Cnt] and IDs[Cnt]) do
    local BG = BGs[Cnt]
    local ID = IDs[Cnt]
    local cntBG = ePiece:GetBodygroupCount(BG.id)
    if(ID < 0 or ID > cntBG) then ID = 0 end
    LogInstance("ePiece:SetBodygroup("..BG.id..symSep..ID..") ["..cntBG.."]")
    ePiece:SetBodygroup(BG.id,ID)
    Cnt = Cnt + 1
  end
  return StatusLog(true,"AttachBodyGroups: Success")
end

function MakePiece(sModel,vPos,aAng,nMass,sBgSkIDs,clColor)
  if(CLIENT) then return StatusLog(nil,"MakePiece: Working on client") end
  local stPiece = CacheQueryPiece(sModel)
  if(not IsExistent(stPiece)) then
    return StatusLog(nil,"MakePiece: Relation mismatch <"..sModel..">") end
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
  if(not (phPiece and phPiece:IsValid())) then
    ePiece:Remove()
    return StatusLog(nil,"MakePiece: Entity phys object invalid")
  end
  phPiece:EnableMotion(false)
  phPiece:SetMass(mathClamp(tonumber(nMass) or 1,1,GetOpVar("MAX_MASS")))
  local BgSk = StringExplode((sBgSkIDs or ""),GetOpVar("OPSYM_DIRECTORY"))
  ePiece:SetSkin(mathClamp(tonumber(BgSk[2]) or 0,0,ePiece:SkinCount()-1))
  AttachBodyGroups(ePiece,BgSk[1] or "")
  AttachAdditions(ePiece)
  return ePiece
end

function ApplyPhysicalAnchor(ePiece,eBase,nWe,nNc)
  if(CLIENT) then return StatusLog(false,"ApplyPhysicalAnchor: Working on client") end
  local nWe = tonumber(nWe) or 0
  local nNc = tonumber(nNc) or 0
  LogInstance("ApplyPhysicalAnchor: {"..nWe..","..nNc.."}")
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"ApplyPhysicalAnchor: Piece entity not valid") end
  if(not (eBase and eBase:IsValid())) then
    return StatusLog(false,"ApplyPhysicalAnchor: Base entity not valid") end
  if(nWe ~= 0) then -- Weld
    local nWe = constraintWeld(ePiece, eBase, 0, 0, 0, false, false)
    ePiece:DeleteOnRemove(nWe)
     eBase:DeleteOnRemove(nWe)
  end
  if(nNc ~= 0) then -- NoCollide
    local nNc = constraintNoCollide(ePiece, eBase, 0, 0)
    ePiece:DeleteOnRemove(nNc)
     eBase:DeleteOnRemove(nNc)
  end
  return StatusLog(true,"ApplyPhysicalAnchor: Success")
end

function ApplyPhysicalSettings(ePiece,nPi,nFr,nGr,sPh)
  if(CLIENT) then return StatusLog(false,"ApplyPhysicalSettings: Working on client") end
  local nPi = tonumber(nPi) or 0
  local nFr = tonumber(nFr) or 0
  local nGr = tonumber(nGr) or 0
  local sPh = tostring(sPh or "")
  LogInstance("ApplyPhysicalSettings: {"..nPi..","..nFr..","..nGr..","..sPh.."}")
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"ApplyPhysicalSettings: Piece entity not valid") end
  -- Initialize dupe settings using this array
  local dataSettings = {0}
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
  if(IsArrayOr(dataSettings,1)) then -- Are there any settings to be saved
    duplicatorStoreEntityModifier(ePiece,GetOpVar("TOOLNAME_PL").."dupe_phys_set",dataSettings) end
  return StatusLog(true,"ApplyPhysicalSettings: Success")
end

function SetBoundPos(ePiece,vPos,oPly,sMode,anyMessage)
  local anyMessage = tostring(anyMessage)
  if(not (ePiece and ePiece:IsValid())) then
    return StatusLog(false,"Piece:SetBoundPos: Entity invalid "..anyMessage) end
  if(not vPos) then
    return StatusLog(false,"Piece:SetBoundPos: Position invalid "..anyMessage) end
  if(not oPly) then
    return StatusLog(false,"Piece:SetBoundPos: Player invalid "..anyMessage) end
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
      PrintNotify(oPly,"Position out of map bounds!",sMode) end
    return StatusLog(false,"Piece:SetBoundPos("..sMode.."): Position out of map bounds "..anyMessage)
  end
  return StatusLog(true,"Piece:SetBoundPos("..sMode.."): Success")
end

function MakeCoVar(sShortName, sValue, tBorder, nFlags, sInfo)
  if(not IsString(sShortName)) then
    return StatusLog(nil,"MakeCvar("..tostring(sShortName).."): Wrong CVar name") end
  if(not IsExistent(sValue)) then
    return StatusLog(nil,"MakeCvar("..tostring(sValue).."): Wrong default value") end
  if(not IsString(sInfo)) then
    return StatusLog(nil,"MakeCvar("..tostring(sInfo).."): Wrong CVar information") end
  local sVar = GetOpVar("TOOLNAME_PL")..stringLower(sShortName)
  if(tBorder and (type(tBorder) == "table") and tBorder[1] and tBorder[2]) then
    local Border = GetOpVar("TABLE_BORDERS")
    Border["cvar_"..sVar] = tBorder
  end
  return CreateConVar(sVar, sValue, nFlags, sInfo)
end

function GetCoVar(sShortName, sMode)
  if(not IsString(sShortName)) then
    return StatusLog(nil,"GetCoVar("..tostring(sShortName).."): Wrong CVar name") end
  if(not IsString(sMode)) then
    return StatusLog(nil,"GetCoVar("..tostring(sMode).."): Wrong CVar mode") end
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
