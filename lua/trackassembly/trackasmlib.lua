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
local MOVETYPE_VPHYSICS     = MOVETYPE_VPHYSICS
local RENDERMODE_TRANSALPHA = RENDERMODE_TRANSALPHA

---------------- Localizing CVar flags ----------------
local FCVAR_ARCHIVE       = FCVAR_ARCHIVE
local FCVAR_ARCHIVE_XBOX  = FCVAR_ARCHIVE_XBOX
local FCVAR_NOTIFY        = FCVAR_NOTIFY
local FCVAR_REPLICATED    = FCVAR_REPLICATED
local FCVAR_PRINTABLEONLY = FCVAR_PRINTABLEONLY

---------------- Localizing Libraries ----------------
local Angle          = Angle
local bit            = bit
local collectgarbage = collectgarbage
local constraint     = constraint
local construct      = construct
local Color          = Color
local CreateConVar   = CreateConVar
local duplicator     = duplicator
local ents           = ents
local file           = file
local getmetatable   = getmetatable
local GetConVar      = GetConVar
local setmetatable   = setmetatable
local include        = include
local IsValid        = IsValid
local LocalPlayer    = LocalPlayer
local math           = math
local next           = next
local os             = os
local pairs          = pairs
local print          = print
local require        = require
local sql            = sql
local string         = string
local surface        = surface
local table          = table
local timer          = timer
local tobool         = tobool
local tonumber       = tonumber
local tostring       = tostring
local type           = type
local undo           = undo
local util           = util
local Vector         = Vector

---------------- CASHES SPACE --------------------

local LibCache  = {} -- Used to cache stuff in a Pool
local LibAction = {} -- Used to attach external function to the lib
local LibOpVars = {} -- Used to Store operational Variable Values

module( "trackasmlib" )

---------------------------- AssemblyLib COMMON ----------------------------

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
    cvX = I1
    cvY = I2
    cvZ = I3
  elseif(sType == "A") then
    caP = I1
    caY = I2
    caR = I3
  elseif(sType == "S") then
    csX = I1
    csY = I2
    csZ = I3
    csD = I4
  end
  return nil
end

function GetInstPref()
  if    (CLIENT) then return "cl_"
  elseif(SERVER) then return "sv_" end
  return "na_"
end

function PrintInstance(anyStuff)
  if(SERVER) then
    print("SERVER > "..tostring(anyStuff))
  elseif(CLIENT) then
    print("CLIENT > "..tostring(anyStuff))
  else
    print("NOINST > "..tostring(anyStuff))
  end
end

function StatusPrint(anyStatus,sError)
  PrintInstance(sError)
  return anyStatus
end

function Delay(nAdd)
  if(nAdd > 0) then
    local i = os.clock() + nAdd
    while(os.clock() < i) do end
  end
end

function GetOpVar(sName)
  return LibOpVars[sName]
end

function SetOpVar(sName, anyValue)
  LibOpVars[sName] = anyValue
end

function IsExistent(anyValue)
  if(anyValue ~= nil) then return true end
  return false
end

function IsString(anyValue)
  if(getmetatable(anyValue) == GetOpVar("TYPEMT_STRING")) then return true end
  return false
end

function InitAssembly(sName)
  SetOpVar("TYPEMT_STRING",getmetatable("TYPEMT_STRING"))
  SetOpVar("TYPEMT_SCREEN",{})
  SetOpVar("TYPEMT_CONTAINER",{})
  if(not IsString(sName)) then
    return StatusPrint(false,"trackasmlib.lua: Error initializing. Expecting string argument")
  end
  if(string.len(sName) < 1 and
     tonumber(string.sub(sName,1,1))) then return end
  sName = sName.."assembly"
  SetOpVar("TOOLNAME_NL",string.lower(sName))
  SetOpVar("TOOLNAME_NU",string.upper(sName))
  SetOpVar("TOOLNAME_PL",GetOpVar("TOOLNAME_NL").."_")
  SetOpVar("TOOLNAME_PU",GetOpVar("TOOLNAME_NU").."_")
  SetOpVar("ARRAY_DECODEPOA",{0,0,0,1,1,1,false})
  SetOpVar("TABLE_FREQUENT_MODELS",{})
  SetOpVar("TABLE_BORDERS",{})
  SetOpVar("HASH_USER_PANEL",GetOpVar("TOOLNAME_PU").."USER_PANEL")
  SetOpVar("HASH_QUERY_STORE",GetOpVar("TOOLNAME_PU").."QHASH_QUERY")
  SetOpVar("HASH_PLAYER_KEYDOWN","PLAYER_KEYDOWN")
  SetOpVar("ANG_ZERO",Angle())
  SetOpVar("VEC_ZERO",Vector())
  SetOpVar("OPSYM_DISABLE","#")
  SetOpVar("OPSYM_REVSIGN","@")
  SetOpVar("OPSYM_DIVIDER","_")
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
  return math.sqrt(X+Y+Z)
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
  local Ang = Angle()
  if(not oPly) then return Ang end
  if(nSnap and (nSnap ~= 0)) then -- Snap to the surface
    local Left = -oPly:GetAimVector():Angle():Right()
    local Trace = oTrace
    if(not Trace) then
      Trace = util.TraceLine(util.GetPlayerTrace(oPly))
      if(not (Trace and Trace.Hit)) then return Ang end
    end
    Ang:Set(Left:Cross(Trace.HitNormal):AngleEx(Trace.HitNormal))
  else -- Get the player yaw
    Ang:Set(oPly:GetAimVector():Angle())
    Ang[caP] = 0
    Ang[caR] = 0
    if(nYSnap and (nYSnap >= 0) and (nYSnap <= GetOpVar("MAX_ROTATION"))) then
      Ang[caY] = SnapValue(Ang[caY],nYSnap)
    end
  end
  return Ang
end

function IsThereRecID(oRec, nPointID)
  if(not oRec) then return false end
  if(not oRec.Offs) then return false end
  if(not oRec.Offs[nPointID]) then return false end
  return true
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
  function self:Insert(nsKey,anyValue)
    Ins = nsKey or Key
    Met = "I"
    if(not IsExistent(Data[Ins])) then
      Curs = Curs + 1
    end
    Data[Ins] = anyValue
    collectgarbage()
  end
  function self:Select(nsKey)
    Sel = nsKey or Key
    return Data[Sel]
  end
  function self:Delete(nsKey)
    Del = nsKey or Key
    Met = "D"
    if(IsExistent(Data[Del])) then
      Data[Del] = nil
      Curs = Curs - 1
      collectgarbage()
    end
  end
  function self:GetHistory()
    return tostring(Met).."@"..
           tostring(Sel).."/"..
           tostring(Ins).."/"..
           tostring(Del)
  end
  setmetatable(self,GetOpVar("TYPEMT_CONTAINER"))
  return self
end

function MakeScreen(sW,sH,eW,eH,conPalette,sEst)
  if(SERVER) then return nil end
  local sW = sW or 0
  local sH = sH or 0
  local eW = eW or 0
  local eH = eH or 0
  if(eW <= 0 or eH <= 0) then return nil end
  if(type(conPalette) ~= "table") then return nil end
  local Est = sEst or ""
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
        Texture.ID   = surface.GetTextureID(Texture.Path)
  local self = {}
  function self:GetSize()
    return (eW-sW), (eH-sH)
  end
  function self:GetCenter(nX,nY)
    local w, h = self:GetSize()
    w = (w / 2) + (nX or 0)
    h = (h / 2) + (nY or 0)
    return w, h
  end
  function self:SetColor(sColor)
    if(not sColor) then return end
    if(Palette) then
      local Colour = Palette:Select(sColor)
      if(Colour) then
        surface.SetDrawColor(Colour.r, Colour.g, Colour.b, Colour.a)
        surface.SetTextColor(Colour.r, Colour.g, Colour.b, Colour.a)
        ColorKey = sColor
      end
    else
      surface.SetDrawColor(White.r,White.g,White.b,White.a)
      surface.SetTextColor(White.r,White.g,White.b,White.a)
    end
  end
  function self:SetTexture(sTexture)
    if(not IsString(sTexture)) then return end
    if(sTexture == "") then return end
    Texture.Path = sTexture
    Texture.ID   = surface.GetTextureID(Texture.Path)
  end
  function self:GetTexture()
    return Texture.ID, Texture.Path
  end
  function self:DrawBackGround(sColor)
    self:SetColor(sColor)
    surface.SetTexture(Texture.ID)
    surface.DrawTexturedRect(sW,sH,eW-sW,eH-sH)
  end
  function self:DrawRect(nX,nY,nW,nH,sColor)
    self:SetColor(sColor)
    surface.SetTexture(Texture.ID)
    surface.DrawTexturedRect(nX,nY,nW,nH)
  end
  function self:SetTextEdge(x,y)
    Text.DrawX = tonumber(x) or 0
    Text.DrawY = tonumber(y) or 0
    Text.ScrW  = 0
    Text.ScrH  = 0
    Text.LastW = 0
    Text.LastH = 0
  end
  function self:SetFont(sFont)
    if(not IsString(sFont)) then return end
    Text.Font = sFont or "Trebuchet18"
    surface.SetFont(Text.Font)
  end
  function self:GetTextState(nX,nY,nW,nH)
    return (Text.DrawX + (nX or 0)), (Text.DrawY + (nY or 0)),
           (Text.ScrW + (nW or 0)), (Text.ScrH + (nH or 0)),
            Text.LastW, Text.LastH
  end
  function self:DrawText(sText,sColor)
    surface.SetTextPos(Text.DrawX,Text.DrawY)
    self:SetColor(sColor)
    surface.DrawText(sText)
    Text.LastW, Text.LastH = surface.GetTextSize(sText)
    Text.DrawY = Text.DrawY + Text.LastH
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
          surface.DrawCircle( xyPos.x, xyPos.y, nRad, Colour)
          ColorKey = sColor
          return
        end
      else
        if(IsExistent(ColorKey)) then
          local Colour = Palette:Select(ColorKey)
          surface.DrawCircle( xyPos.x, xyPos.y, nRad, Colour)
          return
        end
      end
      return
    else
      surface.DrawCircle( xyPos.x, xyPos.y, nRad, White)
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
          nI = math.floor(nI)
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
    if(sMeth == "B") then
      local DisX = xyE.x - xyS.x
      local DirX = DisX
            DisX = DisX * DisX
      local DisY = xyE.y - xyS.y
      local DirY = DisY
            DisY = DisY * DisY
      local Dis = math.sqrt(DisX + DisY)
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
            math.floor call afterwards.
          ]]
          Pre = math.abs(math.abs(Pos.x) + math.abs(Pos.y) -
                         math.abs(xyE.x) - math.abs(xyE.y))
          if(Pre < 0.5) then break end
        end
        Mid = nK * Mid
        I = I + 1
      end
    elseif(sMeth == "I") then
      local V = {x = xyE.x-xyS.x, y = xyE.y-xyS.y}
      local N = math.sqrt(V.x*V.x + V.y*V.y)
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
    end
    xyS.x, xyS.y = math.floor(xyS.x), math.floor(xyS.y)
    xyE.x, xyE.y = math.floor(xyE.x), math.floor(xyE.y)
    return I
  end
  function self:DrawLine(xyS,xyE,sColor)
    if(not (xyS and xyE)) then return end
    if(not (xyS.x and xyS.y and xyE.x and xyE.y)) then return end
    self:SetColor(sColor)
    if(Est ~= "") then
      local Iter = self:AdaptLine(xyS,xyE,200,0.75,Est)
      if(Iter > 0) then
        surface.DrawLine(xyS.x,xyS.y,xyE.x,xyE.y)
      end
    else
      local nS = self:Enclose(xyS)
      local nE = self:Enclose(xyE)
      if(nS == -1 or nE == -1) then return end
      surface.DrawLine(xyS.x,xyS.y,xyE.x,xyE.y)
    end
  end
  setmetatable(self,GetOpVar("TYPEMT_SCREEN"))
  return self
end

function SetAction(sKey,fAct,tDat)
  if(not (sKey and IsString(sKey))) then return false end
  if(not (fAct and type(fAct) == "function")) then return false end
  if(not LibAction[sKey]) then
    LibAction[sKey] = {}
  end
  LibAction[sKey].Act = fAct
  LibAction[sKey].Dat = tDat
  return true
end

function GetActionCode(sKey)
  if(not (sKey and IsString(sKey))) then return nil end
  if(not (LibAction and LibAction[sKey])) then return nil end
  return LibAction[sKey].Act
end

function GetActionData(sKey)
  if(not (sKey and IsString(sKey))) then return nil end
  if(not (LibAction and LibAction[sKey])) then return nil end
  return LibAction[sKey].Dat
end

function CallAction(sKey,A1,A2,A3,A4)
  if(not (sKey and IsString(sKey))) then return false end
  if(not (LibAction and LibAction[sKey])) then return false end
  return LibAction[sKey].Act(A1,A2,A3,A4,LibAction[sKey].Dat)
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

local function PushSortValues(tTable,snCnt,nsValue,tData)
  local Cnt = math.floor(tonumber(snCnt) or 0)
  if(not (tTable and (type(tTable) == "table") and (Cnt > 0))) then return 0 end
  local Ind  = 1
  if(not tTable[Ind]) then
    tTable[Ind] = {Value = nsValue, Table = tData }
    return Ind
  else
    while(tTable[Ind] and (tTable[Ind].Value > nsValue)) do
      Ind = Ind + 1
    end
    if(Ind > Cnt) then return Ind end
    while(Ind < Cnt) do
      tTable[Cnt] = tTable[Cnt - 1]
      Cnt = Cnt - 1
    end
    tTable[Ind] = {Value = nsValue, Table = tData}
    return Ind
  end
end

function GetFrequentModels(snCount)
  local Cnt = tonumber(snCount) or 0
  if(Cnt < 1) then return nil end
  local FreqUse  = GetOpVar("TABLE_FREQUENT_MODELS")
  local defTable = GetOpVar("TABLEDEF_PIECES")
  local namTable = defTable.Name
  local Cache    = LibCache[namTable]
  local TimerID  = ""
  local Tim      = 0
  local Ind      = 1
  table.Empty(FreqUse)
  for Model, Record in pairs(Cache) do
    TimerID  = namTable.."_"..Model
    if(timer.Exists(TimerID)) then
      Tim = timer.TimeLeft(TimerID)
      Ind = PushSortValues(FreqUse,Cnt,Tim,{Record.Kept,Record.Type,Model})
      if(Ind < 1) then return nil end
    end
  end
  if(FreqUse and FreqUse[1]) then return FreqUse end
  return nil
end

function RoundValue(exact, frac)
    local q,f = math.modf(exact/frac)
    return frac * (q + (f > 0.5 and 1 or 0))
end

function SnapValue(nVal, nSnap)
  if(not nVal) then return 0 end
  if(not nSnap) then return nVal end
  if(nSnap == 0) then return nVal end
  local Rez
  local Snp = math.abs(nSnap)
  local Val = math.abs(nVal)
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
  local vOff = Vector()
  if(not (oEnt and oEnt:IsValid())) then return vOff end
  local Phys = oEnt:GetPhysicsObject()
  if(Phys and Phys:IsValid()) then
    vOff:Set(Phys:GetMassCenter())
    vOff:Rotate(oEnt:GetAngles())
    vOff:Mul(-1)
  end
  return vOff
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
  if(nVal > nMax) then
    return nMin
  end
  if(nVal < nMin) then
    return nMax
  end
  return nVal
end

function BorderValue(nVal,sName)
  if(not IsString(sName)) then return nVal end
  local Border = GetOpVar("TABLE_BORDERS")
        Border = Border[sName]
  if(IsExistent(Border)) then
    if    (nVal < Border[1]) then return Border[1]
    elseif(nVal > Border[2]) then return Border[2]
    else                          return nVal end
  end
  return nVal
end

function IncDecPointID(nPointID,sDir,rPiece)
  if(not ( nPointID and
           sDir     and
           rPiece )
  ) then
    return 1
  end
  local Pnt = nPointID
  local Dir = 0
  if(sDir == "+") then Dir =  1 end
  if(sDir == "-") then Dir = -1 end
  Pnt = Pnt + Dir
  Pnt = RollValue(Pnt,1,rPiece.Kept)
  if(rPiece.Offs[Pnt].P[csD]) then
    Pnt = Pnt + Dir
  end
  Pnt = RollValue(Pnt,1,rPiece.Kept)
  return Pnt
end

function IncDecNextID(nNextPointID,nPointID,sDir,rPiece)
  if(not ( nNextPointID and
           nPointID     and
           sDir         and
           rPiece )
  ) then
    return 1
  end
  local Pnt = nNextPointID
  local Dir = 0
  if(sDir == "+") then Dir =  1 end
  if(sDir == "-") then Dir = -1 end
  Pnt = Pnt + Dir
  Pnt = RollValue(Pnt,1,rPiece.Kept)
  if(Pnt == nPointID) then
    Pnt = Pnt + Dir
  end
  Pnt = RollValue(Pnt,1,rPiece.Kept)
  return Pnt
end

function GetPointUpGap(oEnt,hdPoint)
  if(not (oEnt and hdPoint)) then return 0 end
  if(not oEnt:IsValid()) then return 0 end
  if(not (hdPoint.O and hdPoint.A )) then return 0 end
  local aDiffBB = Angle()
  local vDiffBB = oEnt:OBBMins()
  SetAngle(aDiffBB,hdPoint.A)
  aDiffBB:RotateAroundAxis(aDiffBB:Up(),180)
  SubVector(vDiffBB,hdPoint.O)
  vDiffBB:Set(DecomposeByAngle(vDiffBB,aDiffBB))
  return math.abs(vDiffBB[cvZ])
end

function ModelToName(sModel)
  if(not IsString(sModel)) then return "" end
  local Len = string.len(sModel)
  if(string.sub(sModel,Len-2,Len) ~= "mdl") then return "" end
  Len = Len - 4
  if(Len <= 0) then return "" end
  local Cnt = Len
  local Fch = ""
  while(Cnt > 0) do
    Fch = string.sub(sModel,Cnt,Cnt)
    if(Fch == '/') then
      break
    end
    Cnt = Cnt - 1
  end
  local Div = GetOpVar("OPSYM_DIVIDER")
  local Sub = Div..string.sub(sModel,Cnt+1,Len)
  local Rez = ""
  local Bch = ""
  Len = string.len(Sub)
  Cnt = 1
  while(Cnt <= Len) do
    Bch = string.sub(Sub,Cnt,Cnt)
    Cha = string.sub(Sub,Cnt+1,Cnt+1)
    if(Bch == Div) then
       Bch = " "
       Cha = string.upper(Cha)
       Rez = Rez..Bch..Cha
       Cnt = Cnt + 1
    else
      Rez = Rez..Bch
    end
    Cnt = Cnt + 1
  end
  return string.sub(Rez,2,Len)
end

local function ReloadPOA(nXP,nYY,nZR,nSX,nSY,nSZ,nSD)
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
        arPOA[1] = tonumber(nXP) or 0
        arPOA[2] = tonumber(nYY) or 0
        arPOA[3] = tonumber(nZR) or 0
        arPOA[4] = tonumber(nSX) or 1
        arPOA[5] = tonumber(nSY) or 1
        arPOA[6] = tonumber(nSZ) or 1
        arPOA[7] = tobool  (nSD) or false
  return arPOA
end

local function TransferPOA(stOffset,sMode)
  if(not IsExistent(stOffset)) then return StatusLog(nil,"TransferPOA(): Destination needed") end
  if(not IsString(sMode)) then return StatusLog(nil,"TransferPOA(): Mode must be string") end
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
  if(sMode == "POS") then
    stOffset[cvX] = arPOA[1]
    stOffset[cvY] = arPOA[2]
    stOffset[cvZ] = arPOA[3]
  elseif(sMode == "ANG") then
    stOffset[caP] = arPOA[1]
    stOffset[caY] = arPOA[2]
    stOffset[caR] = arPOA[3]
  end
  stOffset[csX] = arPOA[4]
  stOffset[csY] = arPOA[5]
  stOffset[csZ] = arPOA[6]
  stOffset[csD] = arPOA[7]
  return arPOA
end

local function DecodePOA(sStr)
  if(not IsString(sStr)) then return StatusLog(nil,"DecodePOA(): Argument must be string") end
  local DatInd = 1
  local ComCnt = 0
  local Len = string.len(sStr)
  local SymOff = GetOpVar("OPSYM_DISABLE")
  local SymRev = GetOpVar("OPSYM_REVSIGN")
  local arPOA = GetOpVar("ARRAY_DECODEPOA")
  local Ch = ""
  local S = 1
  local E = 1
  local Cnt = 1
  ReloadPOA()
  if(string.sub(sStr,Cnt,Cnt) == SymOff) then
    arPOA[7] = true
    Cnt = Cnt + 1
    S   = S   + 1
  end
  while(Cnt <= Len) do
    Ch = string.sub(sStr,Cnt,Cnt)
    if(Ch == SymRev) then
      arPOA[3+DatInd] = -arPOA[3+DatInd]
      S   = S + 1
    elseif(Ch == ",") then
      ComCnt = ComCnt + 1
      E = Cnt - 1
      if(ComCnt > 2) then break end
      arPOA[DatInd] = tonumber(string.sub(sStr,S,E)) or 0
      DatInd = DatInd + 1
      S = Cnt + 1
      E = S
    else
      E = E + 1
    end
    Cnt = Cnt + 1
  end
  arPOA[DatInd] = tonumber(string.sub(sStr,S,E)) or 0
  return arPOA
end

function FormatNumberMax(nNum,nMax)
  return string.format("%"..string.len(tostring(math.floor(nMax))).."d",nNum)
end

function Indent(nCnt,sStr,bFixed)
  if(not (nCnt and sStr)) then return "" end
  local Out = ""
  local Cnt = nCnt
  local Len = string.len(sStr)
  if(bFixed) then return " "..sStr end
  if(Cnt == 0) then return sStr end
  if(Cnt  > 0) then
    while(Cnt > 0) do
      Out = Out.."  "
      Cnt = Cnt - 1
    end
    return Out..sStr
  else
    return string.sub(sStr,1-2*Cnt,Len)
  end
end

local function Qsort(Data,Lo,Hi)
  if(Lo < Hi) then
    local Mid = math.random(Hi-(Lo-1))+Lo-1
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
end

function Sort(tTable,tIndexes)
  local CopyTable = {}
  local Cnt = 1
  local Cct = 1

  for k,v in pairs(tTable) do
    CopyTable[Cct] = {
      Val = "",
      Key = Cct
    }
    Cnt = 1
    while(tIndexes[Cnt]) do
      i = tIndexes[Cnt]
      if(not v[i]) then
        LogInstance("Sort: Failed to process Table["..Cct.."]["..i.."]")
        return nil
      end
      CopyTable[Cct].Val = CopyTable[Cct].Val..tostring(v[i])
      Cnt = Cnt + 1
    end
    Cct = Cct + 1
  end
  Cct = Cct - 1
  Qsort(CopyTable,1,Cct)
  return CopyTable
end

------------------ AssemblyLib LOGS ------------------------

function SetLogControl(nLines,sFile)
  SetOpVar("LOG_LOGFILE",sFile or "")
  SetOpVar("LOG_MAXLOGS",nLines or 0)
  SetOpVar("LOG_CURLOGS",0,"SetLogControl")
  if(not file.Exists(GetOpVar("DIRPATH_BAS"),"DATA") and
    (string.len(GetOpVar("LOG_LOGFILE")) > 0)
  ) then
    file.CreateDir(GetOpVar("DIRPATH_BAS"))
  end
end

function Log(anyStuff)
  local MaxLogs = GetOpVar("LOG_MAXLOGS")
  if(MaxLogs > 0) then
    local LogFile = GetOpVar("LOG_LOGFILE")
    local CurLogs = GetOpVar("LOG_CURLOGS")
    if(LogFile ~= "") then
      local fName = GetOpVar("DIRPATH_BAS")..GetOpVar("DIRPATH_LOG")..LogFile..".txt"
      file.Append(fName,FormatNumberMax(CurLogs,MaxLogs)
                .." >> "..tostring(anyStuff).."\n")
      CurLogs = CurLogs + 1
      if(CurLogs > MaxLogs) then
        file.Delete(fName)
      end
      SetOpVar("LOG_CURLOGS",CurLogs)
    else
      print(GetOpVar("TOOLNAME_NU").." LOG: "..tostring(anyStuff))
    end
  end
end

function LogInstance(anyStuff)
  if(SERVER) then
    Log("SERVER > "..tostring(anyStuff))
  elseif(CLIENT) then
    Log("CLIENT > "..tostring(anyStuff))
  else
    Log("NOINST > "..tostring(anyStuff))
  end
end

function StatusLog(anyStatus,sError)
  LogInstance(sError)
  return anyStatus
end

--------------------- STRING -----------------------
function StringMakeSQL(sStr)
  if(not IsString(sStr)) then
    return StatusLog(nil,"StringMakeSQL: Only strings can be revised")
  end
  local Cnt = 1
  local Out = ""
  local Chr = string.sub(sStr,Cnt,Cnt)
  while(Chr ~= "") do
    Out = Out..Chr
    if(Chr == "'") then
      Out = Out..Chr
    end
    Cnt = Cnt + 1
    Chr = string.sub(sStr,Cnt,Cnt)
  end
  return Out
end

function StringDisable(sBase, anyDisable, anyDefault)
  if(IsString(sBase)) then
    if(string.len(sBase) > 0 and
       string.sub(sBase,1,1) ~= GetOpVar("OPSYM_DISABLE")
    ) then
      return sBase
    elseif(string.sub(sBase,1,1) == GetOpVar("OPSYM_DISABLE")) then
      return anyDisable
    end
  end
  return anyDefault
end

function StringDefault(sBase, sDefault)
  if(IsString(sBase)) then
    if(string.len(sBase) > 0) then return sBase end
  end
  if(IsString(sDefault)) then return sDefault end
  return ""
end

function StringExplode(sStr,sDelim)
  if(not (IsString(sStr) and IsString(sDelim))) then
    return StatusLog(nil,"StringExplode: All parameters should be strings")
  end
  if(string.len(sDelim) <= 0) then
    return StatusLog(nil,"StringExplode: Delimiter has to be a symbol")
  end
  local Len = string.len(sStr)
  local S = 1
  local E = 1
  local V = ""
  local Ind = 1
  local Data = {}
  if(string.sub(sStr,Len,Len) ~= sDelim) then
    sStr = sStr..sDelim
    Len = Len + 1
  end
  while(E <= Len) do
    Ch = string.sub(sStr,E,E)
    if(Ch == sDelim) then
      V = string.sub(sStr,S,E-1)
      S = E + 1
      Data[Ind] = V or ""
      Ind = Ind + 1
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
  local Cnt = 1
  local Implode = ""
  local Delim = string.sub(tostring(sDelim),1,1)
  while(tParts[Cnt]) do
    Implode = Implode..tostring(tParts[Cnt])
    if(tParts[Cnt+1]) then
      Implode = Implode..Delim
    end
    Cnt = Cnt + 1
  end
  return Implode
end

function StringPad(sStr,sPad,nCnt)
  if(not IsString(sStr)) then return StatusLog("","StringPad(): String missing") end
  if(not IsString(sPad)) then return StatusLog(sStr,"StringPad(): Pad missing") end
  local Len = string.len(sStr)
  if(Len == 0) then return StatusLog(sStr,"StringPad(): Pad too short") end
  local Cnt = tonumber(nCnt)
  if(not Cnt) then return StatusLog(sStr,"StringPad(): Count missing") end
  local Dif = (math.abs(Cnt) - Len)
  if(Dif <= 0) then return StatusLog(sStr,"StringPad(): Padding Ignored") end
  local Ch = string.sub(sPad,1,1)
  local Pad = Ch
  Dif = Dif - 1
  while(Dif > 0) do
    Pad = Pad..Ch 
    Dif = Dif - 1
  end
  if(Cnt > 0) then return (sStr..Pad) end
  return (Pad..sStr)
end

----------------- PRINTS ------------------------

function Print(tT,sS)
  if(not IsExistent(tT)) then
    return StatusLog(nil,"Print: No Data: Print( table, string = \"Data\" )!")
  end
  local S = type(sS)
  local T = type(tT)
  local Key  = ""
  if(S == "string") then
    S = sS
  elseif(S == "number") then
    S = tostring(sS)
  else
    S = "Data"
  end
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
  if(not IsExistent(arArr)) then return StatusLog(0,"ArrayPrint(): Array missing") end
  local Cnt  = 1
  local Col  = 0
  local Max  = 0
  local Cols = 0
  local Line = (sName or "Data").." = { \n"
  local Pad  = StringPad(" "," ",string.len(Line)-1)
  local Next
  while(arArr[Cnt]) do
    Col = string.len(tostring(arArr[Cnt]))
    if(Col > Max) then
      Max = Col
    end
    Cnt = Cnt + 1
  end
  Col  = math.Clamp((tonumber(nCol) or 1),1,100)
  Cols = Col-1
  Cnt  = 1
  print("LEN",Max)
  while(arArr[Cnt]) do
    Next = arArr[Cnt + 1]
    if(nCol and Cols == Col-1) then
      Line = Line..Pad
    end
    Line = Line..StringPad(tostring(arArr[Cnt])," ",-Max-1)
    if(Next) then
      Line = Line..","
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

function ArrayCount(arArr)
  if(not IsExistent(arArr)) then return StatusLog(0,"ArrayCount(): Array missing") end
  if(not arArr[1]) then return StatusLog(0,"ArrayCount(): Argument type "..type(arArr)) end
  local Count = 1
  while(arArr[Count]) do Count = Count + 1 end
  return (Count - 1)
end

------------- SQL Handling --------------

function SetDefaultType(sType)
  if(not IsString(sType)) then return end
  SetOpVar("DEFAULT_TYPE",sType)
end

function SetDefaultTable(sTable)
  if(not IsString(sTable)) then return end
  SetOpVar("DEFAULT_TABLE",sTable)
end

function SQLGetBuildErr()
  return GetOpVar("SQL_BUILD_ERR") or ""
end

function SQLSetBuildErr(sError)
  if(not IsString(sError)) then return false end
  SetOpVar("SQL_BUILD_ERR", sError)
  return false
end

--------------------- USAGES --------------------

function Str2BGID(sStr,nLen)
  if(not sStr) then return nil end -- You never know ...
  local Len  = string.len(sStr)
  if(Len <= 0) then return nil end
  local Data = StringExplode(sStr,",")
  local Cnt = 1
  local exLen = nLen or Data.Len
  while(Cnt <= exLen) do
    local v = Data[Cnt]
    if(v == "") then return nil end
    local vV = tonumber(v)
    if(not vV) then return nil end
    if((math.floor(vV) - vV) ~= 0) then return nil end
    Data[Cnt] = vV
    Cnt = Cnt + 1
  end
  if(Data[1])then return Data end
  return nil
end

function ModelToHashLocation(sModel,tTable,anyValue)
  if(not (IsString(sModel) and type(tTable) == "table")) then return end
  local Key = StringExplode(sModel,"/")
  Print(Key,"Key")
  if(not (Key and Key[1])) then return end
  local Ind = 1
  local Len = 0
  local Val = ""
  local Place = tTable
  while(Key[Ind]) do
    Val = Key[Ind]
    Len = string.len(Val)
    if(string.sub(Val,Len-3,Len) == ".mdl") then
      Place[Val] = anyValue
    else
      if(not Place[Val]) then
        Place[Val] = {}
      end
      Place = Place[Val]
    end
    Ind = Ind + 1
  end
end

function GetModelFileName(sModel)
  if(not sModel or
         sModel == "") then return "NULL" end
  local Len = string.len(sModel)
  local Cnt = Len
  local Ch  = string.sub(sModel,Cnt,Cnt)
  while(Ch ~= "/" and Cnt > 0) do
    Cnt = Cnt - 1
    Ch  = string.sub(sModel,Cnt,Cnt)
  end
  return string.sub(sModel,Cnt+1,Len)
end

------------------------- PLAYER -----------------------------------

function PrintNotify(pPly,sText,sNotifType)
  if(not pPly) then return end
  if(SERVER) then
    pPly:SendLua("GAMEMODE:AddNotify(\""..sText.."\", NOTIFY_"..sNotifType..", 6)")
    pPly:SendLua("surface.PlaySound(\"ambient/water/drip"..math.random(1, 4)..".wav\")")
  end
end

function EmitSoundPly(pPly)
  if(not pPly) then return end
  pPly:EmitSound("physics/metal/metal_canister_impact_hard"..math.floor(math.random(3))..".wav")
end

function LoadPlyKey(pPly, sKey)
  local CacheKey = GetOpVar("HASH_PLAYER_KEYDOWN")
  local Cache    = LibCache[CacheKey]
  if(not IsExistent(Cache)) then
    LibCache[CacheKey] = {}
    Cache = LibCache[CacheKey]
  end
  if(not pPly) then return StatusLog(nil,"LoadPlyKey: Player not available") end
  local Name = pPly:GetName()
  LogInstance("LoadPlyKey: Name >"..Name.."<")
  if(not Cache[Name]) then
    Cache[Name]   = {
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
    Cache = Cache[Name]
  end
  if(IsExistent(sKey)) then
    if(not IsString(sKey)) then return StatusLog(nil,"LoadPlyKey: Key hash not correct") end
    if(sKey == "DEBUG") then
      return Cache
    end
    LogInstance("LoadPlyKey: Key >"..sKey.."< = "..tostring(Cache[sKey]))
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
  return StatusLog(nil,"LoadPlyKey: Player >"..Name.."< keys loaded")
end

-------------------------- AssemblyLib BUILDSQL ------------------------------

local function SQLMatchType(defTable,snValue,nIndex)
  if(not defTable) then
    return StatusLog(nil,"SQLMatchType: Missing: Table definition")
  end
  local nIndex = tonumber(nIndex)
  if(not nIndex) then
    return StatusLog(nil,"SQLMatchType: Invalid: Field ID #"..tostring(nIndex).." on table "..defTable.Name)
  end
  local defField = defTable[nIndex]
  if(not defField) then
    return StatusLog(nil,"SQLMatchType: Invalid: Field #"..tostring(nIndex).." on table "..defTable.Name)
  end
  local tipField = tostring(defField[2])
  if(not tipField) then
    return StatusLog(nil,"SQLMatchType: Invalid: Field #"..tostring(nIndex).." type on table "..defTable.Name)
  end
  if(not IsExistent(snValue)) then return "NULL" end
  if(tostring(snValue) == "") then return "NULL" end
  local snOut
  if(tipField == "TEXT") then
    snOut = tostring(snValue)
    if(defField[3] == "LOW") then
      snOut = string.lower(snOut)
    elseif(defField[3] == "CAP") then
      snOut = string.upper(snOut)
    end
    if(defField[4] == "QMK") then
      snOut = StringMakeSQL(snOut)
    end
    snOut = "'"..snOut.."'"
  elseif(tipField == "REAL" or tipField == "INTEGER") then
    snOut = tonumber(snValue)
    if(not snOut) then
      return StatusLog(nil,"SQLMatchType: Failed converting >"
               ..tostring(snValue).."< "..type(snValue)
               .." to NUMBER for table "..defTable.Name.." field #"..nIndex)
    end
    if(tipField == "INTEGER") then
      if(defField[3] == "FLR") then
        snOut = math.floor(snOut)
      elseif(defField[3] == "CEL") then
        snOut = math.ceil(snOut)
      end
    end
    snOut = snOut
  else
    return StatusLog(nil,"SQLMatchType: Invalid: Field type >"..tipField
                                     .."< on table "..defTable.Name)
  end
  return snOut
end

function SQLBuildCreate(defTable)
  if(not defTable) then
    return SQLSetBuildErr("SQLBuildCreate: Missing: Table definition")
  end
  local namTable  = defTable.Name
  local TableIndex = defTable.Index
  if(not defTable[1]) then
    return SQLSetBuildErr("SQLBuildCreate: Missing: Table definition is empty for "..namTable)
  end
  if(not (defTable[1][1] and
          defTable[1][2])
  ) then
    return SQLSetBuildErr("SQLBuildCreate: Missing: Table "..namTable.." field definitions")
  end
  local Ind = 1
  local Command  = {}
  Command.Drop   = "DROP TABLE "..namTable..";"
  Command.Delete = "DELETE FROM "..namTable..";"
  Command.Create = "CREATE TABLE "..namTable.." ( "
  while(defTable[Ind]) do
    local v = defTable[Ind]
    if(not v[1]) then
      return SQLSetBuildErr("SQLBuildCreate: Missing Table "..namTable
                          .."'s field #"..tostring(Ind))
    end
    if(not v[2]) then
      return SQLSetBuildErr("SQLBuildCreate: Missing Table "..namTable
                                  .."'s field type #"..tostring(Ind))
    end
    Command.Create = Command.Create..string.upper(v[1]).." "..string.upper(v[2])
    if(defTable[Ind+1]) then
      Command.Create = Command.Create ..", "
    end
    Ind = Ind + 1
  end
  Command.Create = Command.Create.." );"
  if(TableIndex and
     TableIndex[1] and
     type(TableIndex[1]) == "table" and
     TableIndex[1][1] and
     type(TableIndex[1][1]) == "number"
   ) then
    Command.Index = {}
    Ind = 1
    Cnt = 1
    while(TableIndex[Ind]) do
      local vI = TableIndex[Ind]
      if(type(vI) ~= "table") then
        return SQLSetBuildErr("SQLBuildCreate: Index creator mismatch on "
          ..namTable.." value "..vI.." is not a table for index ["..tostring(Ind).."]")
      end
      local FieldsU = ""
      local FieldsC = ""
      Command.Index[Ind] = "CREATE INDEX IND_"..namTable
      Cnt = 1
      while(vI[Cnt]) do
        local vF = vI[Cnt]
        if(type(vF) ~= "number") then
          return SQLSetBuildErr("SQLBuildCreate: Index creator mismatch on "
            ..namTable.." value "..vF.." is not a number for index ["
            ..tostring(Ind).."]["..tostring(Cnt).."]")
        end
        if(not defTable[vF]) then
          return SQLSetBuildErr("SQLBuildCreate: Index creator mismatch on "
            ..namTable..". The table does not have field index #"
            ..vF..", max is #"..Table.Size)
        end
        FieldsU = FieldsU.."_" ..string.upper(defTable[vF][1])
        FieldsC = FieldsC..string.upper(defTable[vF][1])
        if(vI[Cnt+1]) then
          FieldsC = FieldsC ..", "
        end
        Cnt = Cnt + 1
      end
      Command.Index[Ind] = Command.Index[Ind]..FieldsU.." ON "..namTable.." ( "..FieldsC.." );"
      Ind = Ind + 1
    end
  end
  SetOpVar("SQL_BUILD_ERR", "")
  return Command
end

local function SQLStoreQuery(defTable,tFields,tWhere,tOrderBy,sQuery)
  local Val
  local Base
  if(not defTable) then
    return StatusLog(nil,"SQLStoreQuery: Missing: Table definition")
  end
  local Field = 1
  local Where = 1
  local Order = 1
  local CacheKey = GetOpVar("HASH_QUERY_STORE")
  local Cache    = LibCache[CacheKey]
  local namTable = defTable.Name
  if(not IsExistent(Cache)) then
    LibCache[CacheKey] = {}
    Cache = LibCache[CacheKey]
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
        return StatusLog(nil,"SQLStoreQuery: Missing: Field key for #"..tostring(Field))
      end
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
      else
        return StatusLog(nil,"SQLStoreQuery: Missing: Order field key for #"..tostring(Order))
      end
      Order = Order + 1
    end
  end
  if(tWhere) then
    while(tWhere[Where]) do
      Val = defTable[tWhere[Where][1]][1]
      if(not IsExistent(Val)) then
        return StatusLog(nil,"SQLStoreQuery: Missing: Where field key for #"..tostring(Where))
      end
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
        return StatusLog(nil,"SQLStoreQuery: Missing: Where value key for #"..tostring(Where))
      end
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
  if(sQuery) then
    Base[Val] = sQuery
  end
  return Base[Val]
end

function SQLBuildSelect(defTable,tFields,tWhere,tOrderBy)
  if(not defTable) then
    return SQLSetBuildErr("SQLBuildSelect: Missing: Table definition")
  end
  local namTable = defTable.Name
  if(not (defTable[1][1] and
          defTable[1][2])
  ) then
    return SQLSetBuildErr("SQLBuildSelect: Missing: Table "..namTable.." field definitions")
  end
  local EnStore = GetOpVar("EN_QUERY_STORE") or false
  if(EnStore) then
    local Q = SQLStoreQuery(defTable,tFields,tWhere,tOrderBy)
    if(Q) then
      return Q
    end
  end
  local Cnt = 1
  local Command = "SELECT "
  if(tFields) then
    while(tFields[Cnt]) do
      local v = tonumber(tFields[Cnt])
      if(not v) then
        return SQLSetBuildErr("SQLBuildSelect: Select index #"
          ..tostring(tFields[Cnt])
          .." type mismatch in "..namTable)
      end
      if(defTable[v]) then
        if(defTable[v][1]) then
          Command = Command..defTable[v][1]
        else
          return SQLSetBuildErr("SQLBuildSelect: Select no such field name by index #"
            ..v.." in the table "..namTable)
        end
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
    local k = tonumber(tWhere[Cnt][1])
    local v = tWhere[Cnt][2]
    local t = defTable[k][2]
    if(k and v and t) then
      while(tWhere[Cnt]) do
        k = tonumber(tWhere[Cnt][1])
        v = tWhere[Cnt][2]
        t = defTable[k][2]
        if(not (k and v and t) ) then
          return SQLSetBuildErr("SQLBuildSelect: Where clause inconsistent "
            ..namTable.." field index, ".."value or type in the table definition")
        end
        v = SQLMatchType(defTable,v,Cnt)
        if(not IsExistent(v)) then
          return SQLSetBuildErr("SQLBuildSelect: Data matching failed on "
            ..namTable.." field index #"..Cnt.." value >"..tostring(v).."<")
        end
        if(Cnt == 1) then
          Command = Command.." WHERE "..defTable[k][1].." = "..v
        else
          Command = Command.." AND "..defTable[k][1].." = "..v
        end
        Cnt = Cnt + 1
      end
    else
      if(EnStore) then
        return SQLStoreQuery(defTable,tFields,tWhere,tOrderBy,Command..";")
      else
        return Command..";"
      end
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
        return SQLSetBuildErr("SQLBuildSelect: Order wrong for "..namTable
                              .." field index #"..Cnt)
      end
        Command = Command..defTable[v][1]..Dire
        if(tOrderBy[Cnt+1]) then
          Command = Command..", "
        end
      Cnt = Cnt + 1
    end
  end
  SetOpVar("SQL_BUILD_ERR", "")
  if(EnStore) then
    return SQLStoreQuery(defTable,tFields,tWhere,tOrderBy,Command..";")
  else
    return Command..";"
  end
end

function SQLBuildInsert(defTable,tInsert,tValues)
  if(not (defTable and tValues)) then
    return SQLSetBuildErr("SQLBuildInsert: Missing Table definition or value fields")
  end
  local namTable = defTable.Name
  if(not defTable[1]) then
    return SQLSetBuildErr("SQLBuildInsert: The table and the chosen fields must not be empty")
  end
  if(not (defTable[1][1] and
          defTable[1][2])
  ) then
    return SQLSetBuildErr("SQLBuildInsert: Missing: Table "..namTable.." field definition")
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
    Ind = tInsert[iCnt] or iCnt
    Fld = defTable[Ind]
    Val = SQLMatchType(defTable,tValues[iCnt],Ind)
    if(not IsExistent(Val)) then
      return SQLSetBuildErr("SQLBuildInsert: Cannot match value >"..tostring(tValues[iCnt]).."< #"..Ind.." on table "..namTable)
    end
    qIns = qIns..defTable[Ind][1]
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
  SetOpVar("SQL_BUILD_ERR", "")
  return qIns..qVal
end

function InsertRecord(sTable,tData)
  if(not IsExistent(sTable)) then
    return StatusLog(false,"InsertRecord: Missing: Table name/values")
  end
  if(type(sTable) == "table") then
    tData  = sTable
    sTable = GetOpVar("DEFAULT_TABLE")
    if(not (IsExistent(sTable) and sTable ~= "")) then
      return StatusLog(false,"InsertRecord: Missing: Table default name for "..sTable)
    end
  end
  if(not IsString(sTable)) then
    return StatusLog(false,"InsertRecord: Missing: Table definition name "..tostring(sTable).." ("..type(sTable)..")")
  end
  local defTable = GetOpVar("TABLEDEF_"..sTable)
  if(not defTable) then
    return StatusLog(false,"InsertRecord: Missing: Table definition for "..sTable)
  end
  local namTable = defTable.Name
  if(not defTable.Size) then
    return StatusLog(false,"InsertRecord: Missing: Table definition SIZE for "..sTable)
  end
  if(not defTable[1])  then
    return StatusLog(false,"InsertRecord: Missing: Table definition is empty for "..sTable)
  end
  if(not tData)      then
    return StatusLog(false,"InsertRecord: Missing: Data table for "..sTable)
  end
  if(not tData[1])   then
    return StatusLog(false,"InsertRecord: Missing: Data table is empty for "..sTable)
  end

  if(sTable == "PIECES") then
    tData[2] = StringDisable(tData[2],GetOpVar("DEFAULT_TYPE"),"TYPE")
    tData[3] = StringDisable(tData[3],ModelToName(tData[1]),"MODEL")
  elseif(sTable == "PHYSPROPERTIES") then
    tData[1] = StringDisable(tData[1],GetOpVar("DEFAULT_TYPE"),"TYPE")
  end

  local Q = SQLBuildInsert(defTable,nil,tData)
  if(Q) then
    local qRez = sql.Query(Q)
    if(not qRez and type(qRez) == "boolean") then
       return StatusLog(false,"InsertRecord: Failed to insert a record because of "
              ..tostring(sql.LastError()).." Query ran > "..Q)
    end
    return true
  end
  return StatusLog(false,"InsertRecord: "..SQLGetBuildErr())
end

function CreateTable(sTable,defTable,bDelete,bReload)
  if(not IsString(sTable)) then return StatusLog(false,"CreateTable: Table key is not a string") end
  if(not (type(defTable) == "table")) then return StatusLog(false,"CreateTable: Table definition missing") end
  defTable.Size = ArrayCount(defTable)
  if(defTable.Size <= 0) then return StatusLog(false,"CreateTable: Record definition empty") end
  defTable.Name = GetOpVar("TOOLNAME_PU")..sTable
  defTable.Life = tonumber(defTable.Life) or 0
  SetOpVar("TABLEDEF_"..sTable,defTable)
  local sDisable = GetOpVar("OPSYM_DISABLE")
  local namTable = defTable.Name
  local Cnt, defField = 1, nil
  while(defTable[Cnt]) do
    defField    = defTable[Cnt]
    defField[3] = StringDefault(tostring(defField[3] or sDisable), sDisable)
    defField[4] = StringDefault(tostring(defField[4] or sDisable), sDisable)
    Cnt = Cnt + 1
  end
  Print(defField,"defField")
  local tQ = SQLBuildCreate(defTable)
  if(tQ) then
    if(bDelete and sql.TableExists(namTable)) then
      local qRez = sql.Query(tQ.Delete)
      if(not qRez and type(qRez) == "boolean") then
        LogInstance("CreateTable: Table "..sTable
          .." is not present. Skipping delete !")
      else
        LogInstance("CreateTable: Table "..sTable.." deleted !")
      end
    end
    if(bReload) then
      local qRez = sql.Query(tQ.Drop)
      if(not qRez and type(qRez) == "boolean") then
        LogInstance("CreateTable: Table "..sTable
          .." is not present. Skipping drop !")
      else
        LogInstance("CreateTable: Table "..sTable.." dropped !")
      end
    end
    if(sql.TableExists(namTable)) then
      LogInstance("CreateTable: Table "..sTable.." exists!")
      return true
    else
      local qRez = sql.Query(tQ.Create)
      if(not qRez and type(qRez) == "boolean") then
        return StatusLog(false,"CreateTable: Table "..sTable
          .." failed to create because of "..tostring(sql.LastError()))
      end
      if(sql.TableExists(namTable)) then
        for k, v in pairs(tQ.Index) do
          qRez = sql.Query(v)
          if(not qRez and type(qRez) == "boolean") then
            return StatusLog(false,"CreateTable: Table "..sTable
              .." failed to create index ["..k.."] > "..v .." > because of "
              ..tostring(sql.LastError()))
          end
        end
        LogInstance("CreateTable: Indexed Table "..sTable.." created !")
        return true
      else
        return StatusLog(false,"CreateTable: Table "..sTable
          .." failed to create because of "..tostring(sql.LastError())
          .." Query ran > "..tQ.Create)
      end
    end
  else
    return StatusLog(false,"CreateTable: "..SQLGetBuildErr())
  end
end

--------------------------- AssemblyLib PIECE QUERY -----------------------------

function NavigateTable(oLocation,tKeys)
  if(not (oLocation and tKeys)) then return nil, nil end
  if(not tKeys[1]) then return nil, nil end
  local Cnt = 1
  local Place, Key
  while(tKeys[Cnt]) do
    Key = tKeys[Cnt]
    LogInstance("NavigateTable: Key: <"..Key..">")
    if(Place) then
      if(tKeys[Cnt+1]) then
        LogInstance("NavigateTable: Jump: "..Key)
        Place = Place[Key]
        if(not IsExistent(Place)) then return nil, nil end
      end
    else
      LogInstance("NavigateTable: Start: "..Key)
      Place = oLocation[Key]
      if(not IsExistent(Place)) then return nil, nil end
    end
    Cnt = Cnt + 1
  end
  return Place, Key
end

function AttachKillTimer(oLocation,tKeys,defTable,anyMessage)
  local Place, Key = NavigateTable(oLocation,tKeys)
  if(not (IsExistent(Place) and IsExistent(Key))) then
    return StatusLog(false,"AttachKillTimer: Navigation failed")
  end
  local Duration = 0
  local TimerID = StringImplode(tKeys,"_")
  if(defTable) then
    Duration = tonumber(defTable.Life) or 0
  end
  LogInstance("AttachKillTimer: Place["..tostring(Key).."] Marked !")
  LogInstance("AttachKillTimer: TimID: <"..TimerID..">")
  if(Place[Key] and
     Duration > 0 and
     not timer.Exists(TimerID)
  ) then
    timer.Create(TimerID, Duration, 1, function()
      LogInstance("AttachKillTimer["..TimerID.."]("..Duration.."): "
                     ..tostring(anyMessage).." > Dead")
      Place[Key] = nil
      timer.Stop(TimerID)
      timer.Destroy(TimerID)
      collectgarbage()
    end)
    return timer.Start(TimerID)
  end
  return StatusLog(false,"Timer exists or it is not enabled")
end

function RestartTimer(tKeys)
  local TimerID = StringImplode(tKeys,GetOpVar("OPSYM_DIVIDER"))
  if(not timer.Exists(TimerID)) then return false end
  return timer.Start(TimerID)
end

-- Cashing the selected Piece Result
function CacheQueryPiece(sModel)
  if(not sModel) then return nil end
  if(not IsString(sModel)) then return nil end
  if(sModel == "") then return nil end
  if(not util.IsValidModel(sModel)) then return nil end
  local defTable = GetOpVar("TABLEDEF_PIECES")
  local namTable = defTable.Name
  local Cache    = LibCache[namTable]
  if(not IsExistent(Cache)) then
    LibCache[namTable] = {}
    Cache = LibCache[namTable]
  end
  local stPiece  = Cache[sModel]
  local CacheInd = {namTable,sModel}
  local OpSymOff = GetOpVar("OPSYM_DISABLE")
  if(stPiece and IsExistent(stPiece.Kept)) then
    if(stPiece.Kept > 0) then
      RestartTimer(CacheInd)
      return Cache[sModel]
    end
    return nil
  end
  LogInstance("CacheQueryPiece: Model >> Pool: "..GetModelFileName(sModel))
  Cache[sModel] = {}
  stPiece = Cache[sModel]
  AttachKillTimer(LibCache,CacheInd,defTable,"CacheQueryPiece")
  local Q = SQLBuildSelect(defTable,nil,{{1,sModel}})
  if(Q) then
    local qData = sql.Query(Q)
    if(qData and qData[1]) then
      stPiece.Type = qData[1][defTable[2][1]]
      stPiece.Name = qData[1][defTable[3][1]]
      stPiece.Offs = {}
      stPiece.Kept = 1
      local stCurItem, Item, qRec
      while(qData[stPiece.Kept]) do
        qRec = qData[stPiece.Kept]
        stPiece.Offs[stPiece.Kept] = {}
        stCurItem = stPiece.Offs[stPiece.Kept]
        stCurItem.O = {}
        stCurItem.P = {}
        stCurItem.A = {}
        Item = qRec[defTable[6][1]]
        if((Item ~= "") and (Item ~= "NULL")) then
          DecodePOA(Item)
        else
          ReloadPOA()
        end
        TransferPOA(stCurItem.O,"POS")
        Item = qRec[defTable[5][1]]
        if((Item ~= "") and (Item ~= "NULL")) then
          DecodePOA(Item)
        end -- in the POA array still persists the decoded Origin
        TransferPOA(stCurItem.P,"POS")
        if(string.sub(Item,1,1) == OpSymOff) then
          stCurItem.P[csD] = true
        end
        Item = qRec[defTable[7][1]]
        if((Item ~= "") and (Item ~= "NULL")) then
          DecodePOA(Item)
        else
          ReloadPOA()
        end
        TransferPOA(stCurItem.A,"ANG")
        stPiece.Kept = stPiece.Kept + 1
      end
      stPiece.Kept = stPiece.Kept - 1
      return stPiece
    else
      stPiece.Kept = 0
    end
  end
  return StatusLog(nil,"CacheQueryPiece: "..SQLGetBuildErr())
end

function CacheQueryAdditions(sModel)
  if(not sModel) then return nil end
  if(not IsString(sModel)) then return nil end
  if(sModel == "") then return nil end
  if(not util.IsValidModel(sModel)) then return nil end
  LogInstance("CacheQueryAdditions: "..sModel)
  local defTable = GetOpVar("TABLEDEF_ADDITIONS")
  if(not defTable) then
    return StatusLog(nil,"CacheQueryAdditions: Missing: Table definition")
  end
  local namTable = defTable.Name
  local Cache    = LibCache[namTable]
  if(not IsExistent(Cache)) then
    LibCache[namTable] = {}
    Cache = LibCache[namTable]
  end
  local CacheInd = {namTable,sModel}
  local stAddition = Cache[sModel]
  if(stAddition and IsExistent(stAddition.Kept)) then
    LogInstance("CacheQueryAdditions: Model << Pool: "..GetModelFileName(sModel))
    if(stAddition.Kept > 0) then
      RestartTimer(CacheInd)
      return Cache[sModel]
    end
    return nil
  end
  LogInstance("CacheQueryAdditions: Model >> Pool: "..GetModelFileName(sModel))
  Cache[sModel] = {}
  stAddition = Cache[sModel]
  AttachKillTimer(LibCache,CacheInd,defTable,"CacheQueryAdditions")
  local Q = SQLBuildSelect(defTable,{2,3,4,5,6,7,8,9,10,11},{{1,sModel}},{3})
  if(Q) then
    local qData = sql.Query(Q)
    if(qData and qData[1]) then
      stAddition.Kept = 1
      while(qData[stAddition.Kept]) do
        local qRec = qData[stAddition.Kept]
        stAddition[stAddition.Kept] = {}
        for Field, Val in pairs(qRec) do
          stAddition[stAddition.Kept][Field] = qRec[Field]
        end
        stAddition.Kept = stAddition.Kept + 1
      end
      stAddition.Kept = stAddition.Kept - 1
      return stAddition
    else
      stAddition.Kept = 0
    end
  else
    return StatusLog(nil,"CacheQueryAdditions: "..SQLGetBuildErr())
  end
end

----------------------- AssemblyLib PANEL QUERY -------------------------------

--- Used to Populate the CPanel Tree
function CacheQueryPanel()
  local defTable = GetOpVar("TABLEDEF_PIECES")
  local namTable = defTable.Name
  local CacheKey = GetOpVar("HASH_USER_PANEL")
  local Cache = LibCache[namTable]
  if(not IsExistent(Cache)) then
    LibCache[namTable] = {}
    Cache = LibCache[namTable]
  end
  local Panel = Cache[CacheKey]
  if(IsExistent(Panel)) then
    LogInstance("CacheQueryPanel: From Pool")
    return Panel
  else
    local Q = SQLBuildSelect(defTable,{1,2,3},{{4,1}},{2,3})
    if(Q) then
      local qData = sql.Query(Q)
      if(qData and qData[1]) then
        Cache[CacheKey] = qData
        LogInstance("CacheQueryPanel: To Pool")
        return qData
      end
      return StatusLog(nil,"CacheQueryPanel: No data found >"..Q.."<")
    end
    return StatusLog(nil,"CacheQueryPanel: "..SQLGetBuildErr())
  end
end

--- Used to Populate the CPanel Phys Materials
function CacheQueryProperty(sType)
  local defTable = GetOpVar("TABLEDEF_PHYSPROPERTIES")
  if(not defTable) then
    return StatusLog(nil,"CacheQueryProperty: Table definition missing")
  end
  local namTable = defTable.Name
  local Cache    = LibCache[namTable]
  if(not Cache) then
    LibCache[namTable] = {}
    Cache = LibCache[namTable]
  end
  if(IsString(sType) and (sType ~= "")) then -- Get names per type
    local CacheKey = "NAMES"
    if(not Cache[CacheKey]) then
      Cache[CacheKey] = {}
    end
    Cache = Cache[CacheKey]
    local CacheInd = {namTable,CacheKey,sType}
    if(Cache and IsExistent(Cache[sType])) then
      RestartTimer(CacheInd)
      return Cache[sType]
    else
      AttachKillTimer(LibCache,CacheInd,defTable,"CacheQueryProperty")
      local Q = SQLBuildSelect(defTable,{3},{{1,sType}},{2})
      if(Q) then
        local qData = sql.Query(Q)
        if(qData and qData[1]) then
          local qRec
          local CntNam = 1
          Cache[sType] = {}
          while(qData[CntNam]) do
            qRec = qData[CntNam]
            Cache[sType][CntNam] = {}
            for qKey, qVal in pairs(qRec) do
              Cache[sType][CntNam][qKey] = qVal
            end
            CntNam = CntNam + 1
          end
          return Cache[sType]
        end
        return StatusLog(nil,"CacheQueryProperty: No data found >"..Q.."<")
      else
        return StatusLog(nil,"CacheQueryProperty: "..SQLGetBuildErr())
      end
    end
  else
    local CacheKey = "TYPES"
    if(Cache and IsExistent(Cache[CacheKey])) then -- Get All type names
      return Cache[CacheKey]
    else
      local Q = SQLBuildSelect(defTable,{1},{{2,1}},{1})
      if(Q) then
        local qData = sql.Query(Q)
        if(qData and qData[1]) then
          local qRec
          local CntTyp = 1
          Cache[CacheKey] = {}
          Cache = Cache[CacheKey]
          while(qData[CntTyp]) do
            qRec = qData[CntTyp]
            Cache[CntTyp] = {}
            for qKey, qVal in pairs(qRec) do
              Cache[CntTyp][qKey] = qVal
            end
            CntTyp = CntTyp + 1
          end
          return Cache
        end
        return StatusLog(nil,"CacheQueryProperty: No data found >"..Q.."<")
      else
        return StatusLog(nil,"CacheQueryProperty: "..SQLGetBuildErr())
      end
    end
  end
end

function GetCenterPoint(oRec,sO)
  if(not IsString(sO)) then return Vector(0,0,0) end
  if((sO ~= "P") and (sO ~= "O")) then return Vector(0,0,0) end
  if(not oRec) then return Vector(0,0,0) end
  if(not oRec.Offs) then return Vector(0,0,0) end
  if(not oRec.Offs[1]) then return Vector(0,0,0) end
  local Ind = 1
  local Cent = Vector()
  while(oRec.Offs[Ind]) do
    local Cur = oRec.Offs[Ind][sO]
    AddVectorXYZ(Cent,Cur[cvX],Cur[cvY],Cur[cvZ])
    Ind = Ind + 1
  end
  if(Ind > 1) then
    Cent:Mul(1/(Ind-1))
  end
  return Cent
end

---------------------- AssemblyLib EXPORT --------------------------------

-- Used to generate inserts based on the DB itself
function ExportIntoIns(sTable,sPrefix)
  if(not IsString(sTable)) then
    return StatusLog(false,"ExportIntoIns: Table name should be string but "..type(sTable))
  end
  local defTable = GetOpVar("TABLEDEF_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ExportIntoIns: Missing: Table definition for "..sTable)
  end
  local namTable = defTable.Name
  local Bas = GetOpVar("DIRPATH_BAS")
  local Exp = GetOpVar("DIRPATH_EXP")
  local BasExp = Bas..Exp
  if(not file.Exists(Bas,"DATA")) then
    file.CreateDir(Bas)
  end
  if(not file.Exists(BasExp,"DATA")) then
    file.CreateDir(BasExp)
  end
  local F = file.Open(BasExp..(sPrefix or GetInstPref())..
                      "db2ins_"..namTable..".txt", "w", "DATA" )
  if(not F) then
    return StatusLog(false,"ExportIntoIns: file.Open("..BasExp..
                          (sPrefix or GetInstPref()).."db2ins_"..
                          namTable..".txt) Failed")
  end
  local Q
  if(sTable == "PIECES") then
    Q = SQLBuildSelect(defTable,nil,nil,{2,3,1,4})
  elseif(sTable == "ADDITIONS") then
    Q = SQLBuildSelect(defTable,nil,nil,{1,2,3})
  elseif(sTable == "PHYSPROPERTIES") then
    Q = SQLBuildSelect(defTable,nil,nil,{1,2})
  else
    Q = SQLBuildSelect(defTable,nil,nil,nil)
  end
  if(Q) then
  local qData = sql.Query(Q)
    if(qData and qData[1]) then
      local Cnt = 1
      local Ind = 1
      local qRec
      F:Write("Exported on: "..os.date().."\n")
      F:Write("DB Query Ran: "..Q.."\n")
      F:Write("Return "..#qData.." results !\n")
      F:Write("Function ExportIntoIns: \n\n")
      while(qData[Ind]) do
        F:Write("InsertRecord(\""..sTable.."\", {")
        Cnt  = 1
        qRec = qData[Ind]
        while(Cnt <= defTable.Size) do
          local f = defTable[Cnt][1]
          local v = qRec[f]
          if(defTable[Cnt][2] == "TEXT") then
            v = "\""..v.."\""
          end
          F:Write(tostring(v))
          if(Cnt < defTable.Size) then F:Write(", ") end
          Cnt = Cnt + 1
        end
        F:Write("})\n")
        Ind = Ind + 1
      end
    end
  else
    return StatusLog(false,"ExportIntoIns: "..SQLGetBuildErr())
  end
  F:Flush()
  F:Close()
end

--[[
 * Save/Load the DB Using Excel or
 * anything that supports delimiter
 * separated digital tables
 * sPrefix = Something that separates exported table from the rest ( e.g. db_ )
 * sTable  = Definition KEY to export to
 * sDelim  = Delimiter CHAR data separator
 * bCommit = true to insert the read values
]]
function ImportFromDSV(sTable,sDelim,bCommit,sPrefix)
  if(not IsString(sTable)) then
    return StatusLog(false,"ImportFromDSV: Table name should be string but "..type(sTable))
  end
  local defTable = GetOpVar("TABLEDEF_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ImportFromDSV: Missing: Table definition for "..sTable)
  end
  local namTable = defTable.Name
  local Bas = GetOpVar("DIRPATH_BAS")
  local Dsv = GetOpVar("DIRPATH_DSV")
  local BasDsv = Bas..Dsv
  local F = file.Open(BasDsv..(sPrefix or GetInstPref())
                      ..namTable..".txt", "r", "DATA")
  if(not F) then
    return StatusLog(false,"ImportFromDSV: file.Open("..BasDsv..
                    (sPrefix or GetInstPref())..namTable..".txt) Failed")
  end
  local Line = ""
  local TabLen = string.len(namTable)
  local LinLen = 0
  local ComCnt = 0
  local SymOff = GetOpVar("OPSYM_DISABLE")
  local Ch = "X" -- Just to be something
  while(Ch) do
    Ch = F:Read(1)
    if(not Ch) then return end
    if(Ch == "\n") then
      LinLen = string.len(Line)
      if(string.sub(Line,LinLen,LinLen) == "\r") then
        Line = string.sub(Line,1,LinLen-1)
        LinLen = LinLen - 1
      end
      if(not (string.sub(Line,1,1) == SymOff)) then
        if(string.sub(Line,1,TabLen) == namTable) then
          local Data = StringExplode(string.sub(Line,TabLen+2,LinLen),sDelim)
          for k,v in pairs(Data) do
            local vLen = string.len(v)
            if(string.sub(v,1,1) == "\"" and string.sub(v,vLen,vLen) == "\"") then
              Data[k] = string.sub(v,2,vLen-1)
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

function ExportIntoDSV(sTable,sDelim,sPrefix)
  if(not IsString(sTable)) then
    return StatusLog(false,"ExportIntoDSV: Table name should be string but "..type(sTable))
  end
  local defTable = GetOpVar("TABLEDEF_"..sTable)
  if(not defTable) then
    return StatusLog(false,"ImportFromDSV: Missing: Table definition for "..sTable)
  end
  local namTable = defTable.Name
  local Bas = GetOpVar("DIRPATH_BAS")
  local Dsv = GetOpVar("DIRPATH_DSV")
  local BasDsv = Bas..Dsv
  if(not file.Exists(Bas,"DATA")) then
    file.CreateDir(Bas)
  end
  if(not file.Exists(BasDsv,"DATA")) then
    file.CreateDir(BasDsv)
  end
  local F = file.Open(BasDsv..(sPrefix or GetInstPref())
                      ..namTable..".txt", "w", "DATA" )
  if(not F) then
    return StatusLog(false,"ExportIntoDSV: file.Open("..BasDsv..
                    (sPrefix or GetInstPref())..namTable..".txt) Failed")
  end
  local Q
  if(sTable == "PIECES") then
    Q = SQLBuildSelect(defTable,nil,nil,{2,3,1,4})
  elseif(sTable == "ADDITIONS") then
    Q = SQLBuildSelect(defTable,nil,nil,{1,2,3})
  elseif(sTable == "PHYSPROPERTIES") then
    Q = SQLBuildSelect(defTable,nil,nil,{1,2})
  else
    Q = SQLBuildSelect(defTable,nil,nil,nil)
  end
  LogInstance("ExportIntoDSV: "..Q)
  if(Q) then
    local qData = sql.Query(Q)
    if(qData) then
      F:Write("# Exported on: "..os.date().."\n")
      local Line = "# Table: "..namTable..sDelim
      local Cnt = 1
      while(defTable[Cnt]) do
        Line = Line ..defTable[Cnt][1]
        if(defTable[Cnt+1]) then
          Line = Line..sDelim
        end
        Cnt = Cnt + 1
      end
      F:Write(Line.."\n")
      Cnt = 1
      while(qData[Cnt]) do
        Line = namTable..sDelim
        local qRec = qData[Cnt]
        local Ind  = 1
        while(defTable[Ind]) do
          local f = defTable[Ind][1]
          if(not f) then
            return StatusLog(false,"ExportIntoDSV: Missing field name in table "
              ..sTable.." index #"..Ind)
          end
          local v = tostring(qRec[f]) or ""
          Line = Line..v
          if(defTable[Ind+1]) then
            Line = Line..sDelim
          end
          Ind = Ind + 1
          v = qRec[defTable[Ind]]
        end
        F:Write(Line.."\n")
        Cnt = Cnt + 1
      end
    end
  else
    return StatusLog(false,"ExportIntoDSV: "..SQLGetBuildErr())
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
 * hdPointID     = Client Point ID
 * hdModel       = Client Model
 * ucsPos(X,Y,Z) = Offset position
 * ucsAng(P,Y,R) = Offset angle
]]--
function GetNormalSpawn(ucsPos,ucsAng,hdModel,hdPointID,
                        ucsPosX,ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
  if(not ( ucsPos    and
           ucsAng    and
           hdModel   and
           hdPointID )
  ) then return nil end

  if(not util.IsValidModel(hdModel)) then return nil end

  local hdRec = CacheQueryPiece(hdModel)

  if(not hdRec) then return nil end
  if(not hdRec.Offs) then return nil end
  if(not hdRec.Offs[hdPointID]) then return nil end
  local stPoint = hdRec.Offs[hdPointID]

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
  stSpawn.SPos:Add(stSpawn.F * (ucsPosX or 0))
  stSpawn.SPos:Add(stSpawn.R * (ucsPosY or 0))
  stSpawn.SPos:Add(stSpawn.U * (ucsPosZ or 0))
  stSpawn.OPos:Set(stSpawn.SPos)
  stSpawn.OAng:RotateAroundAxis(stSpawn.R, (ucsAngP or 0))
  stSpawn.OAng:RotateAroundAxis(stSpawn.U,-(ucsAngY or 0))
  stSpawn.F:Set(stSpawn.OAng:Forward())
  stSpawn.OAng:RotateAroundAxis(stSpawn.F, (ucsAngR or 0))
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
 * hdModel       = Node:DoClick() --> Node:Model()
 * hdPointID     = nIncDecID(nHoldPointID,....) per Right click ...
 * nActRadius    = Min radius to get an active point from the client
 * ucsPos(X,Y,Z) = Offset position
 * ucsAng(P,Y,R) = Offset angle
]]--
function GetEntitySpawn(trEnt,trHitPos,hdModel,hdPointID,
                        nActRadius,enFlatten,enIgnTyp,ucsPosX,
                        ucsPosY,ucsPosZ,ucsAngP,ucsAngY,ucsAngR)
  if(not ( trEnt      and
           trHitPos   and
           hdModel    and
           hdPointID  and
           nActRadius )
  ) then return nil end

  if(not trEnt:IsValid()) then return nil end
  if(IsOther(trEnt)) then return nil end

  local trRec = CacheQueryPiece(trEnt:GetModel())
  local hdRec = CacheQueryPiece(hdModel)

  -- Check our client data and if trace has at least one act point
  if(not ( IsThereRecID(trRec,1) and
           IsThereRecID(hdRec,hdPointID))
  ) then return nil end

  -- If there is no Type field exit immediately
  if(not (trRec.Type and hdRec.Type)) then return nil end

  -- Get client's offset ID
  local hdOffs = hdRec.Offs[hdPointID]

  -- If the types are different and disabled
  if( (not enIgnTyp or enIgnTyp == 0) and
       trRec.Type ~= hdRec.Type ) then return nil end

  local trAng = trEnt:GetAngles()
  local trPos = trEnt:GetPos()

  -- We have the next Piece Offset
  local stSpawn = GetOpVar("SPAWN_ENTITY")
        stSpawn.RLen = nActRadius

  local trpOff
  local trAcDis = 0
  local trPntID = 1
  for k,v in pairs(trRec.Offs) do
    --It shuffles, so better chance to find it faster
    if(trPntID > trRec.Kept) then break end
    SetVector(stSpawn.MPos,v.P)
    stSpawn.MPos:Rotate(trAng)
    stSpawn.MPos:Add(trPos)
    stSpawn.MPos:Sub(trHitPos)
    trAcDis = stSpawn.MPos:Length()
    if(trAcDis < stSpawn.RLen) then
      trpOff = v
      stSpawn.OID  = k
      stSpawn.RLen = trAcDis
      stSpawn.PPos:Set(stSpawn.MPos)
      stSpawn.PPos:Add(trHitPos)
    end
    trPntID = trPntID + 1
  end
  -- Found the active point ID on trEnt
  -- Using "trpOff" because we are only reading
  if(not trpOff) then return nil end   --Not aiming into an active point
  --Do origin !
  SetVector(stSpawn.OPos,trpOff.O)
  stSpawn.OPos:Rotate(trAng)
  stSpawn.OPos:Add(trPos)
  --- Do Origin UCS World angle
  SetAngle(stSpawn.OAng,trpOff.A)
  stSpawn.OAng:Set(trEnt:LocalToWorldAngles(stSpawn.OAng))
  -- Do the flatten flag right now Its important !
  if(enFlatten and enFlatten ~= 0) then
    stSpawn.OAng[caP] = 0
    stSpawn.OAng[caR] = 0
  end
  --- Do F,R,U
  stSpawn.R:Set(stSpawn.OAng:Right())
  stSpawn.U:Set(stSpawn.OAng:Up())
  stSpawn.OAng:RotateAroundAxis(stSpawn.R,(ucsAngP or 0))
  stSpawn.OAng:RotateAroundAxis(stSpawn.U,-(ucsAngY or 0))
  stSpawn.F:Set(stSpawn.OAng:Forward())
  stSpawn.OAng:RotateAroundAxis(stSpawn.F,(ucsAngR or 0))
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
  stSpawn.SPos:Add((hdOffs.O[csX] * stSpawn.MPos[cvX] + (ucsPosX or 0)) * stSpawn.F)
  stSpawn.SPos:Add((hdOffs.O[csY] * stSpawn.MPos[cvY] + (ucsPosY or 0)) * stSpawn.R)
  stSpawn.SPos:Add((hdOffs.O[csZ] * stSpawn.MPos[cvZ] + (ucsPosZ or 0)) * stSpawn.U)
  --Do Spawn Angle
  SetAngle(stSpawn.SAng,stSpawn.OAng)
  stSpawn.SAng:RotateAroundAxis(stSpawn.R,stSpawn.MAng[caP] * hdOffs.A[csX])
  stSpawn.SAng:RotateAroundAxis(stSpawn.U,stSpawn.MAng[caY] * hdOffs.A[csY])
  stSpawn.SAng:RotateAroundAxis(stSpawn.F,stSpawn.MAng[caR] * hdOffs.A[csZ])
  return stSpawn
end

function AttachAdditions(ePiece)
  LogInstance("AttachAdditions Invoked:")
  if(ePiece and ePiece:IsValid()) then
    local LocalAng  = ePiece:GetAngles()
    local LocalPos  = ePiece:GetPos()
    local BaseModel = ePiece:GetModel()
    LogInstance("Model: "..BaseModel)
    local qData  = CacheQueryAdditions(BaseModel)
    if(qData) then
      local Record, Addition
      local Cnt = 1
      local defTable = GetOpVar("TABLEDEF_ADDITIONS")
      while(qData[Cnt]) do
        LogInstance("\n\nEnt [ "..Cnt.." ] INFO : ")
        Record   = qData[Cnt]
        Addition = ents.Create(Record[defTable[3][1]])
        if(Addition and Addition:IsValid()) then
          LogInstance("Addition Class: "..Record[defTable[3][1]])
          if(file.Exists(Record[defTable[2][1]], "GAME")) then
            Addition:SetModel(Record[defTable[2][1]])
            LogInstance("Addition:SetModel("..Record[defTable[2][1]]..")")
          else
            LogInstance("AttachAdditions: No such model "..Record[defTable[2][1]]
                  .."for Body Grouping mode !")
            return nil
          end
          local OffPos = Record[defTable[4][1]]
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
            LogInstance("Addition:SetPos( AdditionPos )")
          else
            Addition:SetPos(LocalPos)
            LogInstance("Addition:SetPos( LocalPos )")
          end
          local OffAngle = Record[defTable[5][1]]
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
          local MoveType = (tonumber(Record[defTable[6][1]]) or -1)
          if(MoveType >= 0) then
            Addition:SetMoveType(MoveType)
            LogInstance("Addition:SetMoveType("..MoveType..")")
          end
          local PhysInit = (tonumber(Record[defTable[7][1]]) or -1)
          if(PhysInit >= 0) then
            Addition:PhysicsInit(PhysInit)
            LogInstance("Addition:PhysicsInit("..PhysInit..")")
          end
          if((tonumber(Record[defTable[8][1]]) or -1) >= 0) then
            Addition:DrawShadow(false)
            LogInstance("Addition:DrawShadow( false )")
          end
          Addition:SetParent( ePiece )
          LogInstance("Addition:SetParent( ePiece )")
          Addition:Spawn()
          LogInstance("Addition:Spawn()")
          phAddition = Addition:GetPhysicsObject()
          if(phAddition and phAddition:IsValid()) then
            if((tonumber(Record[defTable[9][1]]) or -1) >= 0) then
              phAddition:EnableMotion(false)
              LogInstance("phAddition:EnableMotion( false )")
            end
            if((tonumber(Record[defTable[10][1]]) or -1) >= 0) then
              phAddition:Sleep()
              LogInstance("phAddition:Sleep()")
            end
          end
          Addition:Activate()
          LogInstance("Addition:Activate()")
          ePiece:DeleteOnRemove(Addition)
          LogInstance("ePiece:DeleteOnRemove(Addition)")
          local Solid = (tonumber(Record[defTable[11][1]]) or -1)
          if(Solid >= 0) then
            Addition:SetSolid(Solid)
            LogInstance("Addition:SetSolid("..Solid..")")
          end
        else
          LogInstance("Failed to allocate Addition #"..Cnt.." memory:"
              .."\n     Modelbse: "..qData[Cnt][defTable[1][1]]
              .."\n     Addition: "..qData[Cnt][defTable[2][1]]
              .."\n     ENTclass: "..qData[Cnt][defTable[3][1]])
          break
        end
        Cnt = Cnt + 1
      end
    end
  end
end

local function GetEntityOrTrace(oEnt)
  local Ent
  if(oEnt and oEnt:IsValid()) then
    Ent = oEnt
  else
    local Ply = LocalPlayer()
    if(not Ply) then return nil end
    local tr  = Ply:GetEyeTrace()
    if(not tr) then return nil end
    if(tr.HitWorld) then return nil end
    Ent = tr.Entity
  end
  return Ent
end

function GetPropSkin(oEnt)
  local skEnt = GetEntityOrTrace(oEnt)
  if(skEnt and skEnt:IsValid()) then
    if(IsOther(skEnt)) then return "" end
    local Skin = skEnt:GetSkin()
    if(not tonumber(Skin)) then return "" end
    return tostring(Skin)
  end
  return ""
end

function GetPropBodyGrp(oEnt)
  local bgEnt = GetEntityOrTrace(oEnt)
  if(bgEnt and bgEnt:IsValid()) then
    LogInstance("GetPropBodyGrp: "..tostring(oEnt))
    if(IsOther(bgEnt)) then return "" end
    local BG = bgEnt:GetBodyGroups()
    if(not (BG and BG[1])) then return "" end
    Print(BG,"GetPropBodyGrp: BG")
    local Rez = ""
    local Cnt = 1
    while(BG[Cnt]) do
      Rez = Rez..","..(bgEnt:GetBodygroup(BG[Cnt].id) or 0)
      Cnt = Cnt + 1
    end
    return string.sub(Rez,2,string.len(Rez))
  end
  return ""
end

function AttachBodyGroups(ePiece,sBgrpIDs)
  LogInstance("AttachBodyGroups: ")
  local NumBG = ePiece:GetNumBodyGroups()
  LogInstance("BG: "..sBgrpIDs)
  LogInstance("NU: "..NumBG)
  local IDs = Str2BGID(sBgrpIDs,NumBG)
  if(not IDs) then return end
  local BG = ePiece:GetBodyGroups()
  Print(IDs,"IDs")
  local Cnt = 1
  while(BG[Cnt]) do
    local CurBG = BG[Cnt]
    local BGCnt = ePiece:GetBodygroupCount(CurBG.id)
    if(IDs[Cnt] > BGCnt or
       IDs[Cnt] < 0) then IDs[Cnt] = 0 end
    LogInstance("ePiece:SetBodygroup("..CurBG.id..","..(IDs[Cnt] or 0)..")")
    ePiece:SetBodygroup(CurBG.id,IDs[Cnt] or 0)
    Cnt = Cnt + 1
  end
end

function MakePiece(sModel,vPos,aAng,nMass,sBgSkIDs,clColor)
  if(CLIENT) then return nil end
  local stPiece = CacheQueryPiece(sModel)
  if(not stPiece) then return nil end
  local ePiece = ents.Create("prop_physics")
  if(ePiece and ePiece:IsValid()) then
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
    if(phPiece and phPiece:IsValid()) then
      local IDs = StringExplode(sBgSkIDs,"/")
      phPiece:SetMass(nMass)
      phPiece:EnableMotion(false)
      ePiece:SetSkin(math.Clamp(tonumber(IDs[2]) or 0,0,ePiece:SkinCount()-1))
      AttachBodyGroups(ePiece,IDs[1] or "")
      AttachAdditions(ePiece)
      ePiece.Duplicate = function(ePiece)
        if(CLIENT) then return nil end
        return MakePiece(ePiece:GetModel(),ePiece:GetPos(),
                         GetOpVar("ANG_ZERO"),phPiece:GetMass(),
                         GetPropBodyGrp(ePiece).."/"..GetPropSkin(ePiece),
                         ePiece:GetColor())
      end
      ePiece.Anchor = function(ePiece,eBase,nWe,nNc,nFr,nWg,nGr,sPh)
        if(CLIENT) then
          return StatusLog(false,"Anchor(): Working on the client is not allowed")
        end
        local We = tonumber(nWe) or 0
        local Nc = tonumber(nNc) or 0
        local Fr = tonumber(nFr) or 0
        local Wg = tonumber(nWg) or 0
        local Gr = tonumber(nGr) or 0
        local Ph = tostring(sPh) or ""
        if(not (ePiece and ePiece:IsValid())) then
          return StatusLog(false,"Piece:Anchor(): Piece entity not valid")
        end
        if(eBase and eBase:IsValid()) then
          if(We ~= 0) then
            local We = constraint.Weld(eBase, ePiece, 0, 0, 0, false, false)
            ePiece:DeleteOnRemove(We)
             eBase:DeleteOnRemove(We)
          end
          if(Nc ~= 0) then
            local Nc = constraint.NoCollide(eBase, ePiece, 0, 0)
            ePiece:DeleteOnRemove(Nc)
             eBase:DeleteOnRemove(Nc)
          end
        else
          LogInstance("Piece:Anchor(): Base entity not valid")
        end
        local pyPiece = ePiece:GetPhysicsObject()
        if(pyPiece and pyPiece:IsValid()) then
          if(Fr == 0) then
            pyPiece:EnableMotion(true)
          end
          if(Wg ~= 0) then
            pyPiece:EnableMotion(false)
            ePiece:SetUnFreezable(true)
            ePiece.PhysgunDisabled = true
            duplicator.StoreEntityModifier(ePiece,GetOpVar("TOOLNAME_PL").."wgnd",{[1] = true})
          end
          if(Gr == 0) then
            construct.SetPhysProp(nil,ePiece,0,pyPiece,{GravityToggle = false})
          end
          if(Ph ~= "") then
            construct.SetPhysProp(nil,ePiece,0,pyPiece,{Material = Ph})
          end
        else
          LogInstance("Piece:Anchor(): Piece physobj not valid")
        end
        return true
      end
      ePiece.SetMapBoundPos = function(ePiece,vPos,oPly,nBndErrMode,anyMessage)
        local Message = tostring(anyMessage)
        if(not vPos) then
          return StatusLog(true,"Piece:SetMapBoundPos(): Position invalid: \n"..Message)
        end
        if(not oPly) then
          return StatusLog(true,"Piece:SetMapBoundPos(): Player invalid: \n"..Message)
        end
        local BndErrMode = (tonumber(nBndErrMode) or 0)
        if(BndErrMode == 0) then
          ePiece:SetPos(vPos)
          return false
        elseif(BndErrMode == 1) then
          if(util.IsInWorld(vPos)) then
            ePiece:SetPos(vPos)
          else
            ePiece:Remove()
            return StatusLog(true,"Piece:SetMapBoundPos("..BndErrMode.."): Position out of map bounds: \n"..anyMessage)
          end
          return false
        elseif(BndErrMode == 2) then
          if(util.IsInWorld(vPos)) then
            ePiece:SetPos(vPos)
          else
            ePiece:Remove()
            PrintNotify(oPly,"Position out of map bounds!","HINT")
            return StatusLog(true,"Piece:SetMapBoundPos("..BndErrMode.."): Position out of map bounds: \n"..anyMessage)
          end
          return false
        elseif(BndErrMode == 3) then
          if(util.IsInWorld(vPos)) then
            ePiece:SetPos(vPos)
          else
            ePiece:Remove()
            PrintNotify(oPly,"Position out of map bounds!","GENERIC")
            return StatusLog(true,"Piece:SetMapBoundPos("..BndErrMode.."): Position out of map bounds: \n"..anyMessage)
          end
          return false
        elseif(BndErrMode == 4) then
          if(util.IsInWorld(vPos)) then
            ePiece:SetPos(vPos)
          else
            ePiece:Remove()
            PrintNotify(oPly,"Position out of map bounds!","ERROR")
            return StatusLog(true,"Piece:SetMapBoundPos("..BndErrMode.."): Position out of map bounds: \n"..anyMessage)
          end
          return false
        end
        return StatusLog(true,"Piece:SetMapBoundPos(): Mode #"..BndErrMode.." not found: \n"..Message)
      end
      return ePiece
    end
    ePiece:Remove()
    return nil
  end
  return nil
end

function MakeCvar(sShortName, sValue, tBorder, sInfo)
  if(not IsString(sShortName)) then return StatusLog(nil,"MakeCvar("..tostring(sShortName).."): Wrong CVar name") end
  if(not IsString(sValue)) then return StatusLog(nil,"MakeCvar("..tostring(sValue).."): Wrong default value") end
  if(not IsString(sInfo)) then return StatusLog(nil,"MakeCvar("..tostring(sInfo).."): Wrong CVar information") end
  local sVar = GetOpVar("TOOLNAME_PL")..string.lower(sShortName)
  if(tBorder and (type(tBorder) == "table") and tBorder[1] and tBorder[2]) then
    local Border = GetOpVar("TABLE_BORDERS")
    Border["cvar_"..sVar] = tBorder
  end
  return CreateConVar(sVar, sValue, bit.bor(FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_PRINTABLEONLY), sInfo)
end

function GetCvar(sShortName, sMode)
  if(not IsString(sShortName)) then return StatusLog(nil,"GetCvar("..tostring(sShortName).."): Wrong CVar name") end
  if(not IsString(sMode)) then return StatusLog(nil,"GetCvar("..tostring(sMode).."): Wrong CVar mode") end
  local sVar = GetOpVar("TOOLNAME_PL")..string.lower(sShortName)
  local CVar = GetConVar(sVar)
  if(not IsExistent(CVar)) then return StatusLog(nil,"GetCvar("..sShortName..", "..sMode.."): Missing CVar object") end
  if    (sMode == "I") then
    return (BorderValue(CVar:GetInt(),"cvar_"..sVar) or 0)
  elseif(sMode == "F") then
    return (BorderValue(CVar:GetFloat(),"cvar_"..sVar) or 0)
  elseif(sMode == "S") then
    return (CVar:GetString() or "")
  elseif(sMode == "B") then
    return (CVar:GetBool() or false)
  elseif(sMode == "DEF") then
    return CVar:GetDefault()
  elseif(sMode == "INF") then
    return CVar:GetHelpText()
  elseif(sMode == "NAM") then
    return CVar:GetName()
  end
  return StatusLog(nil,"GetCvar("..sShortName..", "..sMode.."): Missed mode")
end
