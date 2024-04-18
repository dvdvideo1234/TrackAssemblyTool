--[[ **************************** REGISTER **************************** ]]

E2Lib.RegisterExtension("trackassembly", true,
  "Allows E2 chips to spawn segments for performing custom track layouts",
  "This extension makes some track assembly features visible for the users to operate with the addon database."
)

--[[ **************************** MODULE **************************** ]]

local asmlib = trackasmlib

--[[ **************************** LOCALIZATION **************************** ]]

local Vector    = Vector
local Angle     = Angle
local Color     = Color
local tonumber  = tonumber
local tostring  = tostring
local mathClamp = math and math.Clamp
local cvarsAddChangeCallback = cvars and cvars.AddChangeCallback
local cvarsRemoveChangeCallback = cvars and cvars.RemoveChangeCallback

--[[ **************************** CONFIGURATION **************************** ]]

local anyTrue, anyFalse = 1, 0
local gsBErr = asmlib.GetAsmConvar("bnderrmod","STR")
local enFlag = asmlib.GetAsmConvar("enwiremod","BUL")
local gnMaxMass = asmlib.GetAsmConvar("maxmass","FLT")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsINS = "PIECES:Record({\"%s\", \"%s\", \"%s\", %d, \"%s\", \"%s\", \"%s\", \"%s\"})"
local gsDSV = "TRACKASSEMBLY_PIECES\t\"%s\"\t\"%s\"\t\"%s\"\t%d\t\"%s\"\t\"%s\"\t\"%s\"\t\"%s\""

--[[ **************************** CALLBACKS **************************** ]]

local gsVarName -- This stores current variable name
local gsCbcHash = "_wire" -- This keeps suffix related to the file

gsVarName = asmlib.GetAsmConvar("enwiremod", "NAM")
cvarsRemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvarsAddChangeCallback(gsVarName, function(sV, vO, vN)
  enFlag = ((tonumber(vN) or 0) ~= 0) end, gsVarName..gsCbcHash)

gsVarName = asmlib.GetAsmConvar("bnderrmod", "NAM")
cvarsRemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvarsAddChangeCallback(gsVarName, function(sV, vO, vN)
  gsBErr = tostring(vN) end, gsVarName..gsCbcHash)

gsVarName = asmlib.GetAsmConvar("maxmass", "NAM")
cvarsRemoveChangeCallback(gsVarName, gsVarName..gsCbcHash)
cvarsAddChangeCallback(gsVarName, function(sV, vO, vN)
  local nM = (tonumber(vN) or 0) -- Zero is invalid mass
  gnMaxMass = ((nM > 0) and nM or 1) -- Apply mass clamp
end, gsVarName..gsCbcHash)

--[[ **************************** EXPORT **************************** ]]

local function getDataFormat(sForm, oEnt, ucsEnt, sType, sName, nPnt, sP)
  if(not (oEnt and oEnt:IsValid() and enFlag)) then return "" end
  if(not (ucsEnt and ucsEnt:IsValid())) then return "" end
  local ucsPos, ucsAng, sM = ucsEnt:GetPos(), ucsEnt:GetAngles(), oEnt:GetModel()
  local sO = ""; if(not ucsPos:IsZero()) then local nX, nY, nZ = ucsPos:Unpack()
    sO = tostring(nX)..","..tostring(nY)..","..tostring(nZ) end
  local sA = ""; if(not ucsAng:IsZero()) then local nP, nY, nR = ucsAng:Unpack()
    sA = tostring(nP)..","..tostring(nY)..","..tostring(nR) end
  local sC = (oEnt:GetClass() ~= "prop_physics" and oEnt:GetClass() or "")
  local sN = asmlib.IsBlank(sName) and asmlib.ModelToName(sM) or sName
  return sForm:format(sM, sType, sN, tonumber(nPnt or 0), sP, sO, sA, sC)
end

__e2setcost(50)
e2function string entity:trackasmlibGenActivePointINS(entity ucsEnt, string sType, string sName, number nPoint, string sP)
  return getDataFormat(gsINS, this, ucsEnt, sType, sName, nPoint, sP)
end

__e2setcost(50)
e2function string entity:trackasmlibGenActivePointDSV(entity ucsEnt, string sType, string sName, number nPoint, string sP)
  return getDataFormat(gsDSV, this, ucsEnt, sType, sName, nPoint, sP)
end

--[[ **************************** SNAP **************************** ]]

__e2setcost(100)
e2function array entity:trackasmlibSnapEntity(vector trHitPos  , string hdModel  , number hdPoID  ,
                                              number nActRadius, number enFlatten, number enIgnTyp,
                                              vector ucsOffPos , angle ucsOffAng)
  if(not (this and this:IsValid() and enFlag)) then return {} end
  local nX, nY, nZ = ucsOffPos:Unpack()
  local nP, nY, nR = ucsOffAng:Unpack()
  local stSpawn = asmlib.GetEntitySpawn(self.player, this, trHitPos, hdModel, hdPoID,
                                        nActRadius, (enFlatten ~= 0), (enIgnTyp ~= 0),
                                        nX, nY, nZ, nP, nY, nR)
  if(not stSpawn) then return {} end
  return {Vector(stSpawn.SPos), Angle(stSpawn.SAng)}
end

__e2setcost(80)
e2function array trackasmlibSnapNormal(vector ucsPos, angle  ucsAng   , string hdModel,
                                       number hdPoID, vector ucsOffPos, angle ucsOffAng)
  if(not enFlag) then return {} end
  local nX, nY, nZ = ucsOffPos:Unpack()
  local nP, nY, nR = ucsOffAng:Unpack()
  local stSpawn = asmlib.GetNormalSpawn(self.player, ucsPos, ucsAng, hdModel, hdPoID,
                                        nX, nY, nZ, nP, nY, nR)
  if(not stSpawn) then return {} end
  return {Vector(stSpawn.SPos), Angle(stSpawn.SAng)}
end

--[[ **************************** PIECES **************************** ]]

__e2setcost(30)
e2function number trackasmlibIsPiece(string sModel)
  if(not enFlag) then return anyFalse end
  local stRec = asmlib.CacheQueryPiece(sModel)
  if(stRec) then return anyTrue else return anyFalse end
end

__e2setcost(30)
e2function number entity:trackasmlibIsPiece()
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  local stRec = asmlib.CacheQueryPiece(this:GetModel())
  if(stRec) then return anyTrue else return anyFalse end
end

local function getPieceOffset(sModel, nID, sKey)
  if(not enFlag) then return nil end
  if(not sKey) then return nil end
  local oRec = asmlib.CacheQueryPiece(sModel)
  if(not oRec) then return nil end
  local tPOA = asmlib.LocatePOA(oRec, nID)
  if(not tPOA) then return nil end
  return tPOA[sKey] -- The component
end

__e2setcost(80)
e2function array trackasmlibGetOffset(string sModel, number nID, string sPOA)
  local oPOA = getPieceOffset(sModel, nID, sPOA)
  return (oPOA and oPOA:Array() or {})
end

__e2setcost(80)
e2function array entity:trackasmlibGetOffset(number nID, string sPOA)
  if(not (this and this:IsValid())) then return {} end
  local oPOA = getPieceOffset(this:GetModel(), nID, sPOA)
  return (oPOA and oPOA:Array() or {})
end

__e2setcost(30)
e2function string trackasmlibGetType(string sModel)
  if(not enFlag) then return "" end
  local stRec = asmlib.CacheQueryPiece(sModel)
  if(stRec and stRec.Type) then return stRec.Type else return "" end
end

__e2setcost(30)
e2function string entity:trackasmlibGetType()
  if(not (this and this:IsValid() and enFlag)) then return "" end
  local stRec = asmlib.CacheQueryPiece(this:GetModel())
  if(stRec and stRec.Type) then return stRec.Type else return "" end
end

__e2setcost(30)
e2function string trackasmlibGetName(string sModel)
  if(not enFlag) then return "" end
  local stRec = asmlib.CacheQueryPiece(sModel)
  if(stRec and stRec.Name) then return stRec.Name else return "" end
end

__e2setcost(30)
e2function string entity:trackasmlibGetName()
  if(not (this and this:IsValid() and enFlag)) then return "" end
  local stRec = asmlib.CacheQueryPiece(this:GetModel())
  if(stRec and stRec.Name) then return stRec.Name else return "" end
end

__e2setcost(30)
e2function number trackasmlibGetPointsCount(string sModel)
  if(not enFlag) then return 0 end
  local stRec = asmlib.CacheQueryPiece(sModel)
  if(stRec and stRec.Size) then return stRec.Size else return 0 end
end

__e2setcost(30)
e2function number entity:trackasmlibGetPointsCount()
  if(not (this and this:IsValid() and enFlag)) then return 0 end
  local stRec = asmlib.CacheQueryPiece(this:GetModel())
  if(stRec and stRec.Size) then return stRec.Size else return 0 end
end

--[[ **************************** ADDITIONS **************************** ]]

__e2setcost(30)
e2function number trackasmlibHasAdditions(string sModel)
  if(not enFlag) then return anyFalse end
  local stRec = asmlib.CacheQueryAdditions(sModel)
  if(stRec) then return anyTrue else return anyFalse end
end

__e2setcost(30)
e2function number entity:trackasmlibHasAdditions()
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  local stRec = asmlib.CacheQueryAdditions(this:GetModel())
  if(stRec) then return anyTrue else return anyFalse end
end

__e2setcost(50)
e2function number trackasmlibGetAdditionsCount(string sModel)
  if(not enFlag) then return 0 end
  local stRec = asmlib.CacheQueryAdditions(sModel)
  if(stRec and stRec.Size) then return stRec.Size else return 0 end
end

__e2setcost(50)
e2function number entity:trackasmlibGetAdditionsCount()
  if(not (this and this:IsValid() and enFlag)) then return 0 end
  local stRec = asmlib.CacheQueryAdditions(this:GetModel())
  if(stRec and stRec.Size) then return stRec.Size else return 0 end
end

local function getAdditionsLine(sModel, nID)
  local makTab = asmlib.GetBuilderNick("ADDITIONS"); if(not makTab) then
    asmlib.LogInstance("No table builder"); return {} end
  local defTab = makTab:GetDefinition(); if(not defTab) then
    asmlib.LogInstance("No table definition"); return {} end
  local stRec = asmlib.CacheQueryAdditions(sModel); if(not stRec) then return {} end
  if(not stRec[nID]) then return {} end; stRec = stRec[nID]
  local iRow, arData = 2, {} -- The model is missed by the main SELECT
  while(defTab[iRow]) do  -- Ordered by ID. Get the line per model
    arData[iRow-1] = stRec[defTab[iRow][1]]; iRow = (iRow + 1)
  end; return arData
end

__e2setcost(60)
e2function array trackasmlibGetAdditionsLine(string sModel, number nID)
  if(not enFlag) then return {} end
  return getAdditionsLine(sModel, nID)
end

__e2setcost(60)
e2function array entity:trackasmlibGetAdditionsLine(number nID)
  if(not (this and this:IsValid() and enFlag)) then return {} end
  return getAdditionsLine(this:GetModel(), nID)
end

--[[ **************************** PHYSPROPERTIES **************************** ]]

__e2setcost(15)
e2function array trackasmlibGetProperty(string sType)
  if(not enFlag) then return {} end
  local stType = asmlib.CacheQueryProperty(sType)
  if(not stType) then return {} end
  return stType
end

__e2setcost(15)
e2function array trackasmlibGetProperty()
  if(not enFlag) then return {} end
  local stType = asmlib.CacheQueryProperty()
  if(not stType) then return {} end
  return stType
end

__e2setcost(15)
e2function number trackasmlibGetPropertyCount()
  if(not enFlag) then return 0 end
  local stType = asmlib.CacheQueryProperty()
  if(not stType) then return 0 end
  return (tonumber(stType.Size) or 0)
end

--[[ **************************** CREATOR **************************** ]]

local function newPiece(oPly, oEnt, sModel, vPos, aAng, nMass, sBgpID, nR, nG, nB, nA)
  if(not enFlag) then return nil end
  if(not asmlib.IsPlayer(oPly)) then return nil end
  if(oEnt and not oEnt:IsValid()) then return nil end
  local sMod, sBsID, nA, nMs, oCol = sModel, sBgpID, asmlib.FixColor(nA or 255), nMass, nR
  if(not sMod and oEnt and oEnt:IsValid()) then sMod = oEnt:GetModel() end
  local stRec = asmlib.CacheQueryPiece(sMod); if(not stRec) then return nil end
  if(not nMs and oEnt and oEnt:IsValid()) then local oPhy = oEnt:GetPhysicsObject()
    if(not (oPhy and oPhy:IsValid())) then return nil end; nMs = oPhy:GetMass() end
  if(not sBsID) then local sDir = asmlib.GetOpVar("OPSYM_DIRECTORY")
    if(not (oEnt and oEnt:IsValid())) then sBsID = "0/0" else -- Use bodygroup and skin
      sBsID = asmlib.GetPropBodyGroup(oEnt)..sDir..asmlib.GetPropSkin(oEnt) end
  end -- Color handling. Apply color based on the conditions
  if(asmlib.IsNumber(oCol)) then -- Color specifier is a number
    oCol = asmlib.GetColor(nR,nG,nB,nA) -- Try last 4 arguments as numbers
  elseif(asmlib.IsTable(oCol)) then -- Attempt to extract keys information from the table
    oCol = asmlib.GetColor((oCol[1] or oCol["r"]), -- Numerical indices are with priority to hash
                           (oCol[2] or oCol["g"]), -- Numerical indices are with priority to hash
                           (oCol[3] or oCol["b"]), -- Numerical indices are with priority to hash
                     nA or (oCol[4] or oCol["a"])) -- Use argument alpha with priority
  else oCol = asmlib.GetColor(255,255,255,nA) end -- Use white for default color value
  return asmlib.NewPiece(oPly,stRec.Slot,vPos,aAng,mathClamp(nMs,1,gnMaxMass),sBsID,oCol,gsBErr)
end

__e2setcost(50)
e2function entity trackasmlibNewPiece(string sModel, vector vPos, angle aAng, number nMass, string sBgpID, number nR, number nG, number nB, number nA)
  return newPiece(self.player, nil, sModel, vPos, aAng, nMass, sBgpID, nR, nG, nB, nA)
end

__e2setcost(50)
e2function entity entity:trackasmlibNewPiece(vector vPos, angle aAng, number nMass, string sBgpID, number nR, number nG, number nB, number nA)
  return newPiece(self.player, this, nil, vPos, aAng, nMass, sBgpID, nR, nG, nB, nA)
end

__e2setcost(50)
e2function entity trackasmlibNewPiece(string sModel, vector vPos, angle aAng, number nMass, string sBgpID, vector vColor, number nA)
  return newPiece(self.player, nil, sModel, vPos, aAng, nMass, sBgpID, vColor, nil, nil, nA)
end

__e2setcost(50)
e2function entity entity:trackasmlibNewPiece(vector vPos, angle aAng, number nMass, string sBgpID, vector vColor, number nA)
  return newPiece(self.player, this, nil, vPos, aAng, nMass, sBgpID, vColor, nil, nil, nA)
end

__e2setcost(50)
e2function entity trackasmlibNewPiece(string sModel, vector vPos, angle aAng, number nMass, string sBgpID, vector vColor)
  return newPiece(self.player, nil, sModel, vPos, aAng, nMass, sBgpID, vColor)
end

__e2setcost(50)
e2function entity entity:trackasmlibNewPiece(vector vPos, angle aAng, number nMass, string sBgpID, vector vColor)
  return newPiece(self.player, this, nil, vPos, aAng, nMass, sBgpID, vColor)
end

__e2setcost(50)
e2function entity trackasmlibNewPiece(string sModel, vector vPos, angle aAng, number nMass, string sBgpID)
  return newPiece(self.player, nil, sModel, vPos, aAng, nMass, sBgpID)
end

__e2setcost(50)
e2function entity entity:trackasmlibNewPiece(vector vPos, angle aAng, number nMass, string sBgpID)
  return newPiece(self.player, this, nil, vPos, aAng, nMass, sBgpID)
end

__e2setcost(50)
e2function entity trackasmlibNewPiece(string sModel, vector vPos, angle aAng, number nMass)
  return newPiece(self.player, nil, sModel, vPos, aAng, nMass)
end

__e2setcost(50)
e2function entity entity:trackasmlibNewPiece(vector vPos, angle aAng, number nMass)
  return newPiece(self.player, this, nil, vPos, aAng, nMass)
end

__e2setcost(50)
e2function entity entity:trackasmlibNewPiece(vector vPos, angle aAng)
  return newPiece(self.player, this, nil, vPos, aAng)
end

__e2setcost(15)
e2function number entity:trackasmlibApplyPhysicalAnchor(entity eBase, number nWe, number nNc, number nNw, number nFm)
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  if(not (eBase and eBase:IsValid())) then return anyFalse end
  local stRec = asmlib.CacheQueryPiece(this:GetModel()); if(not stRec) then return anyFalse end
  return asmlib.ApplyPhysicalAnchor(this,eBase,(nWe~=0),(nNc~=0),(nNw~=0),nFm) and anyTrue or anyFalse
end

__e2setcost(15)
e2function number entity:trackasmlibApplyPhysicalSettings(number nPi, number nFr, number nGr, string sPh)
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  local stRec = asmlib.CacheQueryPiece(this:GetModel()); if(not stRec) then return anyFalse end
  return asmlib.ApplyPhysicalSettings(this,(nPi~=0),(nFr~=0),(nGr~=0),sPh) and anyTrue or anyFalse
end

__e2setcost(35)
e2function number entity:trackasmlibAttachAdditions()
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  local stRec = asmlib.CacheQueryAdditions(this:GetModel()); if(not stRec) then return 0 end
  return asmlib.AttachAdditions(this) and anyTrue or anyFalse
end

__e2setcost(20)
e2function number entity:trackasmlibAttachBodyGroups(string sBgpID)
  if(not (this and this:IsValid() and enFlag)) then return 0 end
  local stRec = asmlib.CacheQueryPiece(this:GetModel()); if(not stRec) then return 0 end
  return asmlib.AttachBodyGroups(this, sBgpID) and anyTrue or anyFalse
end

__e2setcost(20)
e2function string entity:trackasmlibGetBodyGroups()
  if(not (this and this:IsValid() and enFlag)) then return "" end
  return asmlib.GetPropBodyGroup(this)
end

__e2setcost(20)
e2function string entity:trackasmlibGetSkin()
  if(not (this and this:IsValid() and enFlag)) then return "" end
  return asmlib.GetPropSkin(this)
end
