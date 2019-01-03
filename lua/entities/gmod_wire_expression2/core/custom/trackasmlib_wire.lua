----- Localizing the asmlib module
local asmlib      = trackasmlib

----- Localizing needed functions
local Vector      = Vector
local Angle       = Angle
local Color       = Color
local tonumber    = tonumber
local tostring    = tostring
local mathClamp   = math and math.Clamp

----- Get extension enabled flag
local anyTrue, anyFalse  = 1, 0
local cvX, cvY, cvZ = asmlib.GetIndexes("V")
local caP, caY, caR = asmlib.GetIndexes("A")
local wvX, wvY, wvZ = asmlib.GetIndexes("WV")
local waP, waY, waR = asmlib.GetIndexes("WA")
local gsBErr = asmlib.GetAsmVar("bnderrmod","STR")
local enFlag = asmlib.GetAsmVar("enwiremod","BUL")
local gnMaxMass = asmlib.GetAsmVar("maxmass","FLT")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")

----- Refresh callbacks global variables
cvars.AddChangeCallback(gsToolPrefL.."bnderrmod", function()
  gsBErr = asmlib.GetAsmVar("bnderrmod","STR")
end)

cvars.AddChangeCallback(gsToolPrefL.."enwiremod", function()
  enFlag = asmlib.GetAsmVar("enwiremod","BUL")
end)

cvars.AddChangeCallback(gsToolPrefL.."maxmass", function()
  gnMaxMass = asmlib.GetAsmVar("maxmass","FLT")
end)

--------- EXPORT ---------

__e2setcost(50)
e2function string entity:trackasmlibGenActivePointINS(entity ucsEnt, string sType, string sName, number nPoint, string sP)
  if(not (this and this:IsValid() and enFlag)) then return "" end
  if(not (ucsEnt and ucsEnt:IsValid())) then return "" end
  local ucsPos, ucsAng = ucsEnt:GetPos(), ucsEnt:GetAngles()
  local sO = tostring(ucsPos[cvX])..","..tostring(ucsPos[cvY])..","..tostring(ucsPos[cvZ])
  local sA = tostring(ucsAng[caP])..","..tostring(ucsAng[caY])..","..tostring(ucsAng[caR])
  local sC = (this:GetClass() ~= "prop_physics" and this:GetClass() or "")
  return "asmlib.InsertRecord({\""..this:GetModel().."\", \""..sType..
         "\", \""..sName.."\", "..tostring(nPoint or 0)..", \""..sP..
         "\", \""..sO.."\", \""..sA.."\", \""..sC.."\"})"
end

__e2setcost(50)
e2function string entity:trackasmlibGenActivePointDSV(entity ucsEnt, string sType, string sName, number nPoint, string sP, string sDelim)
  if(not (this and this:IsValid() and enFlag)) then return "" end
  if(not (ucsEnt and ucsEnt:IsValid())) then return "" end
  local sDelim = sDelim:sub(1,1); if(asmlib.IsBlank(sDelim)) then return "" end
  local ucsPos, ucsAng = ucsEnt:GetPos(), ucsEnt:GetAngles()
  local sO = tostring(ucsPos[cvX])..","..tostring(ucsPos[cvY])..","..tostring(ucsPos[cvZ])
  local sC = (this:GetClass() ~= "prop_physics" and this:GetClass() or "")
  local sA = tostring(ucsAng[caP])..","..tostring(ucsAng[caY])..","..tostring(ucsAng[caR])
  return "TRACKASSEMBLY_PIECES"..sDelim.."\""..this:GetModel().."\""..sDelim.."\""..
         sType.."\""..sDelim.."\""..sName.."\""..sDelim..tostring(nPoint or 0)..
         sDelim.."\""..sP.."\""..sDelim.."\""..sO.."\""..sDelim.."\""..sA.."\""..sDelim.."\""..sC.."\""
end

--------- SNAP ----------

__e2setcost(100)
e2function array entity:trackasmlibSnapEntity(vector trHitPos  , string hdModel  , number hdPoID  ,
                                              number nActRadius, number enFlatten, number enIgnTyp,
                                              vector ucsOffPos , angle ucsOffAng)
  if(not (this and this:IsValid() and enFlag)) then return {} end
  local stSpawn = asmlib.GetEntitySpawn(self.player,this, asmlib.ToVector(trHitPos, wvX, wvY, wvZ),
                                        hdModel,hdPoID,nActRadius,(enFlatten ~= 0),(enIgnTyp ~= 0),
                                        ucsOffPos[wvX],ucsOffPos[wvY],ucsOffPos[wvZ],
                                        ucsOffAng[waP],ucsOffAng[waY],ucsOffAng[waR])
  if(not stSpawn) then return {} end
  local sPos = {stSpawn.SPos[cvX], stSpawn.SPos[cvY], stSpawn.SPos[cvZ]}
  local sAng = {stSpawn.SAng[caP], stSpawn.SAng[caY], stSpawn.SAng[caR]}
  return {sPos, sAng}
end

__e2setcost(80)
e2function array trackasmlibSnapNormal(vector ucsPos   , angle ucsAng    , string hdModel,
                                       number hdPoID, vector ucsOffPos, angle ucsOffAng)
  if(not enFlag) then return {} end
  local stSpawn = asmlib.GetNormalSpawn(self.player,
                                        asmlib.ToVector(ucsPos, wvX, wvY, wvZ),
                                        asmlib.ToAngle(ucsAng, waP, waY, waR),
                                        ucsAng,hdModel,hdPoID,
                                        ucsOffPos[wvX],ucsOffPos[wvY],ucsOffPos[wvZ],
                                        ucsOffAng[waP],ucsOffAng[waY],ucsOffAng[waR])
  if(not stSpawn) then return {} end
  local sPos = {stSpawn.SPos[cvX], stSpawn.SPos[cvY], stSpawn.SPos[cvZ]}
  local sAng = {stSpawn.SAng[caP], stSpawn.SAng[caY], stSpawn.SAng[caR]}
  return {sPos, sAng}
end

--------- PIECES ----------

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

local function getPieceOffset(sModel, nID, sPOA)
  local stPOA = asmlib.LocatePOA(asmlib.CacheQueryPiece(sModel),nID)
  if(not stPOA) then return {} end
  local sPOA, arOut, C1, C2, C3 = tostring(sPOA):upper():sub(1,1), {}
  if    (sPOA == "P") then C1, C2, C3 = cvX, cvY, cvZ
  elseif(sPOA == "O") then C1, C2, C3 = cvX, cvY, cvZ
  elseif(sPOA == "A") then C1, C2, C3 = caP, caY, caR else return arOut end
  arOut[1], arOut[2], arOut[3] = stPOA[sPOA][C1] , stPOA[sPOA][C2] , stPOA[sPOA][C3]
  return arOut
end

__e2setcost(80)
e2function array trackasmlibGetOffset(string sModel, number nID, string sPOA)
  if(not enFlag) then return {} end
  return getPieceOffset(sModel, nID, sPOA)
end

__e2setcost(80)
e2function array entity:trackasmlibGetOffset(number nID, string sPOA)
  if(not (this and this:IsValid() and enFlag)) then return {} end
  return getPieceOffset(this:GetModel(), nID, sPOA)
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

---------- Additions ------------
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
  local makTab = asmlib.GetBuilderName("ADDITIONS"); if(not makTab) then
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

------------ PhysProperties ------------
__e2setcost(15)
e2function array trackasmlibGetProperty(string sType)
  if(not enFlag) then return {} end
  local stRec = asmlib.CacheQueryProperty(sType)
  if(not stRec) then return {} end
  return stRec
end

__e2setcost(15)
e2function array trackasmlibGetProperty()
  if(not enFlag) then return {} end
  local stRec = asmlib.CacheQueryProperty()
  if(not stRec) then return {} end
  return stRec
end

----------- PIECE CREATOR --------------

local function makePiece(oPly, oEnt, sModel, vPos, aAng, nMass, sBgpID, nR, nG, nB, nA)
  if(not enFlag) then return nil end
  if(oEnt and not oEnt:IsValid()) then return nil end
  if(not asmlib.IsPlayer(oPly)) then return nil end
  local sMod, sBsID, nA, nMs, oCol = sModel, sBgpID, (tonumber(nA) or 255), nMass, nR
  if(not sMod and oEnt and oEnt:IsValid()) then sMod = oEnt:GetModel() end
  local stRec = asmlib.CacheQueryPiece(sMod); if(not stRec) then return nil end
  if(not sBsID) then 
    if(not oEnt) then sBsID = "0/0"
    elseif(oEnt and oEnt:IsValid()) then
      sBsID = asmlib.GetPropBodyGroup(oEnt)..asmlib.GetOpVar("OPSYM_DIRECTORY")..asmlib.GetPropSkin(oEnt)
    end
  end -- Color handling. Apply color based on the conditions
  if(asmlib.IsNumber(oCol)) then -- Color as RGB palette
    oCol = asmlib.GetColor(tonumber(nR) or 255,tonumber(nG) or 255,tonumber(nB) or 255,nA)
  elseif(asmlib.IsTable(oCol)) then oCol = asmlib.ToColor(oCol,wvX,wvY,wvZ,255)
  else oCol = asmlib.GetColor(255,255,255,nA) end
  if(not nMs and oEnt and oEnt:IsValid()) then local oPhy = this:GetPhysicsObject()
    if(not (oPhy and oPhy:IsValid())) then return nil end; nMs = oPhy:GetMass() end
  return asmlib.MakePiece(oPly,stRec.Slot,asmlib.ToVector(vPos,wvX,wvY,wvZ),
    asmlib.ToAngle(aAng,waP,waY,waR),mathClamp(nMs,1,gnMaxMass),sBsID,oCol,gsBErr)
end

__e2setcost(50)
e2function entity trackasmlibMakePiece(string sModel, vector vPos, angle aAng, number nMass, string sBgpID, number nR, number nG, number nB, number nA)
  return makePiece(self.player, nil, sModel, vPos, aAng, nMass, sBgpID, nR, nG, nB, nA)
end

__e2setcost(50)
e2function entity entity:trackasmlibMakePiece(vector vPos, angle aAng, number nMass, string sBgpID, number nR, number nG, number nB, number nA)
  return makePiece(self.player, this, nil, vPos, aAng, nMass, sBgpID, nR, nG, nB, nA)
end

__e2setcost(50)
e2function entity trackasmlibMakePiece(string sModel, vector vPos, angle aAng, number nMass, string sBgpID, vector vColor)
  return makePiece(self.player, nil, sModel, vPos, aAng, nMass, sBgpID, vColor)
end

__e2setcost(50)
e2function entity entity:trackasmlibMakePiece(vector vPos, angle aAng, number nMass, string sBgpID, vector vColor)
  return makePiece(self.player, this, nil, vPos, aAng, nMass, sBgpID, vColor)
end

__e2setcost(50)
e2function entity trackasmlibMakePiece(string sModel, vector vPos, angle aAng, number nMass, string sBgpID)
  return makePiece(self.player, nil, sModel, vPos, aAng, nMass, sBgpID)
end

__e2setcost(50)
e2function entity entity:trackasmlibMakePiece(vector vPos, angle aAng, number nMass, string sBgpID)
  return makePiece(self.player, this, nil, vPos, aAng, nMass, sBgpID)
end

__e2setcost(50)
e2function entity trackasmlibMakePiece(string sModel, vector vPos, angle aAng, number nMass)
  return makePiece(self.player, nil, sModel, vPos, aAng, nMass)
end

__e2setcost(50)
e2function entity entity:trackasmlibMakePiece(vector vPos, angle aAng, number nMass)
  return makePiece(self.player, this, nil, vPos, aAng, nMass)
end

__e2setcost(50)
e2function entity entity:trackasmlibMakePiece(vector vPos, angle aAng)
  return makePiece(self.player, this, nil, vPos, aAng)
end

__e2setcost(15)
e2function entity entity:trackasmlibApplyPhysicalAnchor(entity eBase, number nWe, number nNc)
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  if(not (eBase and eBase:IsValid())) then return anyFalse end
  local stRec = asmlib.CacheQueryPiece(this:GetModel()); if(not stRec) then return anyFalse end
  return asmlib.ApplyPhysicalAnchor(this,eBase,(nWe~=0),(nNc~=0)) and anyTrue or anyFalse
end

__e2setcost(15)
e2function entity entity:trackasmlibApplyPhysicalSettings(number nPi, number nFr, number nGr, string sPh)
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
