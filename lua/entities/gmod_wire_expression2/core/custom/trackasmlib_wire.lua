----- Localizing the asmlib module
local asmlib      = trackasmlib
----- Localizing needed functions
local Vector      = Vector
local Angle       = Angle
local Color       = Color
local tonumber    = tonumber
local tostring    = tostring
local mathClamp   = math and math.Clamp
local stringSub   = string and string.sub
local stringUpper = string and string.upper
local stringLen   = string and string.len

----- Get extension enabled flag
local maxColor = 255
local anyTrue, anyFalse = 1, 0
local maxMass  = asmlib.GetOpVar("MAX_MASS")
local enFlag   = asmlib.GetAsmVar("enwiremod","BUL")
local bndErr   = asmlib.GetAsmVar("bnderrmod","STR")

--------- Pieces ----------
__e2setcost(50)
e2function string entity:trackasmlibGenActivePointINS(entity ucsEnt, string sType, string sName, number nPoint, string sP)
  if(not (this and this:IsValid() and enFlag)) then return "" end
  if(not (ucsEnt and ucsEnt:IsValid())) then return "" end
  local C1, C2, C3 = asmlib.GetIndexes("V")
  local ucsPos = ucsEnt:GetPos()
  local sO = tostring(ucsPos[C1])..","..tostring(ucsPos[C2])..","..tostring(ucsPos[C3])
        C1, C2, C3 = asmlib.GetIndexes("A")
  local ucsAng = ucsEnt:GetAngles()
  local sA = tostring(ucsAng[C1])..", "..tostring(ucsAng[C2])..", "..tostring(ucsAng[C3])
  return "asmlib.InsertRecord({\""..this:GetModel().."\", \""..sType..
         "\", \""..sName.."\", "..tostring(nPoint or 0)..", \""..sP..
         "\", \""..sO.."\", \""..sA.."\"})"
end

__e2setcost(50)
e2function string entity:trackasmlibGenActivePointDSV(entity ucsEnt, string sType, string sName, number nPoint, string sP, string sDelim)
  if(not (this and this:IsValid() and enFlag)) then return "" end
  if(not (ucsEnt and ucsEnt:IsValid())) then return "" end
  local sDelim = stringSub(sDelim,1,1)
  if(not (stringLen(sDelim) > 0)) then return "" end
  local C1, C2, C3 = asmlib.GetIndexes("V")
  local ucsPos = ucsEnt:GetPos()
  local sO = tostring(ucsPos[C1])..","..tostring(ucsPos[C2])..","..tostring(ucsPos[C3])
        C1, C2, C3 = asmlib.GetIndexes("A")
  local ucsAng = ucsEnt:GetAngles()
  local sA = tostring(ucsAng[C1])..","..tostring(ucsAng[C2])..","..tostring(ucsAng[C3])
  return "TRACKASSEMBLY_PIECES"..sDelim.."\""..this:GetModel().."\""..sDelim.."\""..
         sType.."\""..sDelim.."\""..sName.."\""..sDelim..tostring(nPoint or 0)..
         sDelim.."\""..sP.."\""..sDelim.."\""..sO.."\""..sDelim.."\""..sA.."\""
end

__e2setcost(100)
e2function array entity:trackasmlibSnapEntity(vector trHitPos  , string hdModel  , number hdPointID,
                                              number nActRadius, number enFlatten, number enIgnTyp ,
                                              vector ucsOffPos , vector ucsOffAng)
  if(not (this and this:IsValid() and enFlag)) then return {} end
  local stSpawn = asmlib.GetEntitySpawn(this,trHitPos,hdModel,hdPointID,
                                        nActRadius,(enFlatten ~= 0),(enIgnTyp ~= 0),
                                        ucsPos[1],ucsPos[2],ucsPos[3],ucsAng[1],ucsAng[2],ucsAng[3])
  if(not stSpawn) then return {} end
  return {stSpawn.SPos, stSpawn.SAng}
end

__e2setcost(80)
e2function array trackasmlibSnapNormal(vector ucsPos   , angle ucsAng    , string hdModel,
                                       number hdPointID, vector ucsOffPos, vector ucsOffAng)
  if(not enFlag) then return {} end
  local stSpawn = asmlib.GetNormalSpawn(ucsPos,ucsAng,hdModel,hdPointID,
                                        ucsOffPos[1],ucsOffPos[2],ucsOffPos[3],
                                        ucsOffAng[1],ucsOffAng[2],ucsOffAng[3])
  if(not stSpawn) then return {} end
  return {stSpawn.SPos, stSpawn.SAng}
end

__e2setcost(30)
e2function number trackasmlibIsPiece(string sModel)
  if(not enFlag) then return anyFalse end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord) then return anyTrue else return anyFalse end
end

__e2setcost(30)
e2function number entity:trackasmlibIsPiece()
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(stRecord) then return anyTrue else return anyFalse end
end

__e2setcost(120)
e2function array trackasmlibGetOffset(string sModel, number nOffset, string sPOA)
  if(not enFlag) then return {} end
  local stPOA = asmlib.LocatePOA(asmlib.CacheQueryPiece(sModel),nOffset)
  if(not stPOA) then return {} end
  local sPOA = stringSub(stringUpper(tostring(sPOA)),1,1)
  local arResult = {}
  local C1, C2, C3, C4
  if    (sPOA == "P") then C1, C2, C3 = asmlib.GetIndexes("V")
  elseif(sPOA == "O") then C1, C2, C3 = asmlib.GetIndexes("V")
  elseif(sPOA == "A") then C1, C2, C3 = asmlib.GetIndexes("A")
  else return arResult end
  arResult[1] = stPOA[sPOA][C1]
  arResult[1] = stPOA[sPOA][C1]
  arResult[2] = stPOA[sPOA][C2]
  arResult[3] = stPOA[sPOA][C3]
  C1, C2, C3, C4 = asmlib.GetIndexes("S")
  arResult[4] = stPOA[sPOA][C1]
  arResult[5] = stPOA[sPOA][C2]
  arResult[6] = stPOA[sPOA][C3]
  arResult[7] = stPOA[sPOA][C4] and 1 or 0
  return arResult
end

__e2setcost(120)
e2function array entity:trackasmlibGetOffset(number nOffset, string sPOA)
  if(not (this and this:IsValid() and enFlag)) then return {} end
  local stPOA = asmlib.LocatePOA(asmlib.CacheQueryPiece(this:GetModel()),nOffset)
  if(not stPOA) then return {} end
  local sPOA = stringSub(stringUpper(tostring(sPOA)),1,1)
  local arResult = {}
  local C1, C2, C3, C4
  if    (sPOA == "P") then C1, C2, C3 = asmlib.GetIndexes("V")
  elseif(sPOA == "O") then C1, C2, C3 = asmlib.GetIndexes("V")
  elseif(sPOA == "A") then C1, C2, C3 = asmlib.GetIndexes("A")
  else return arResult end
  arResult[1] = stPOA[sPOA][C1]
  arResult[2] = stPOA[sPOA][C2]
  arResult[3] = stPOA[sPOA][C3]
  C1, C2, C3, C4 = asmlib.GetIndexes("S")
  arResult[4] = stPOA[sPOA][C1]
  arResult[5] = stPOA[sPOA][C2]
  arResult[6] = stPOA[sPOA][C3]
  arResult[7] = stPOA[sPOA][C4] and 1 or 0
  return arResult
end

__e2setcost(30)
e2function string trackasmlibGetType(string sModel)
  if(not enFlag) then return "" end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord and stRecord.Type) then return stRecord.Type else return "" end
end

__e2setcost(30)
e2function string entity:trackasmlibGetType()
  if(not (this and this:IsValid() and enFlag)) then return "" end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(stRecord and stRecord.Type) then return stRecord.Type else return "" end
end

__e2setcost(30)
e2function string trackasmlibGetName(string sModel)
  if(not enFlag) then return "" end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord and stRecord.Name) then return stRecord.Name else return "" end
end

__e2setcost(30)
e2function string entity:trackasmlibGetName()
  if(not (this and this:IsValid() and enFlag)) then return "" end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(stRecord and stRecord.Name) then return stRecord.Name else return "" end
end

__e2setcost(30)
e2function number trackasmlibGetPointsCount(string sModel)
  if(not enFlag) then return 0 end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord and stRecord.Kept) then return stRecord.Kept else return 0 end
end

__e2setcost(30)
e2function number entity:trackasmlibGetPointsCount()
  if(not (this and this:IsValid() and enFlag)) then return 0 end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(stRecord and stRecord.Kept) then return stRecord.Kept else return 0 end
end

---------- Additions ------------
__e2setcost(30)
e2function number trackasmlibHasAdditions(string sModel)
  if(not enFlag) then return anyFalse end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(stRecord) then return anyTrue else return anyFalse end
end

__e2setcost(30)
e2function number entity:trackasmlibHasAdditions()
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  local stRecord = asmlib.CacheQueryAdditions(this:GetModel())
  if(stRecord) then return anyTrue else return anyFalse end
end

__e2setcost(50)
e2function number trackasmlibGetAdditionsCount(string sModel)
  if(not enFlag) then return 0 end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(stRecord and stRecord.Kept) then return stRecord.Kept else return 0 end
end

__e2setcost(50)
e2function number entity:trackasmlibGetAdditionsCount()
  if(not (this and this:IsValid() and enFlag)) then return 0 end
  local stRecord = asmlib.CacheQueryAdditions(this:GetModel())
  if(stRecord and stRecord.Kept) then return stRecord.Kept else return 0 end
end

__e2setcost(60)
e2function array trackasmlibGetAdditionsLine(string sModel, number nLine)
  if(not enFlag) then return {} end
  local defAddit = asmlib.GetOpVar("DEFTABLE_ADDITIONS")
  if(not defAddit) then
    return asmlib.StatusLog({},"entity:trackasmlibGetAdditionLine(number): No table definition")
  end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(not stRecord) then return {} end
  if(not stRecord[nLine]) then return {} end
  stRecord = stRecord[nLine] -- Ordered by ID. Get the line per model
  local cntField = 2         -- The model is missed by the main SELECT
  local arAdditionsLine = {}
  while(defAddit[cntField]) do
    arAdditionsLine[cntField-1] = stRecord[defAddit[cntField][1]]
    cntField = cntField + 1
  end
  return arAdditionsLine
end

__e2setcost(60)
e2function array entity:trackasmlibGetAdditionsLine(number nLine)
  if(not (this and this:IsValid() and enFlag)) then return {} end
  local defAddit = asmlib.GetOpVar("DEFTABLE_ADDITIONS")
  if(not defAddit) then
    return asmlib.StatusLog({},"entity:trackasmlibGetAdditionLine(number): No table definition")
  end
  local stRecord = asmlib.CacheQueryAdditions(this:GetModel())
  if(not stRecord) then return {} end
  if(not stRecord[nLine]) then return {} end
  stRecord = stRecord[nLine] -- Ordered by ID. Get the line per model
  local cntField = 2         -- The model is missed by the main SELECT
  local arAdditionsLine = {}
  while(defAddit[cntField]) do
    arAdditionsLine[cntField-1] = stRecord[defAddit[cntField][1]]
    cntField = cntField + 1
  end
  return arAdditionsLine
end

------------ PhysProperties ------------
__e2setcost(15)
e2function array trackasmlibGetProperty(string sType)
  if(not enFlag) then return {} end
  local stRecord = asmlib.CacheQueryProperty(sType)
  if(not stRecord) then return {} end
  return stRecord
end

__e2setcost(15)
e2function array trackasmlibGetProperty()
  if(not enFlag) then return {} end
  local stRecord = asmlib.CacheQueryProperty()
  if(not stRecord) then return {} end
  return stRecord
end

----------- Piece creator --------------
__e2setcost(50)
e2function entity trackasmlibMakePiece(string sModel, vector vPos, angle aAng, number nMass, string sBgpID, number nR, number nG, number nB, number nA)
  if(not enFlag) then return nil end
  if(not asmlib.IsPlayer(self.player)) then return nil end
  return asmlib.MakePiece(self.player,sModel,Vector(vPos[1],vPos[2],vPos[3]),Angle(aAng[1],aAng[2],aAng[3]),
           mathClamp(nMass,1,maxMass),sBgpID,Color(mathClamp(nR,0,maxColor),mathClamp(nG,0,maxColor),
                                                   mathClamp(nB,0,maxColor),mathClamp(nA,0,maxColor)),bndErr)
end

__e2setcost(50)
e2function entity entity:trackasmlibMakePiece(vector vPos, angle aAng)
  if(not (this and this:IsValid() and enFlag)) then return nil end
  if(not asmlib.IsPlayer(self.player)) then return nil end
  local phthis = this:GetPhysicsObject()
  if(not (phthis and phthis:IsValid())) then return nil end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(not stRecord) then return nil end
  local sBgpID  = asmlib.GetPropBodyGroup(this)..
                  asmlib.GetOpVar("OPSYM_DIRECTORY")..asmlib.GetPropSkin(this)
  return asmlib.MakePiece(self.player,this:GetModel(),Vector(vPos[1],vPos[2],vPos[3]),
                Angle (aAng[1],aAng[2],aAng[3]),phthis:GetMass(),sBgpID,this:GetColor(),bndErr)
end

__e2setcost(15)
e2function entity entity:trackasmlibApplyPhysicalAnchor(entity eBase, number nWe, number nNc)
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  if(not (eBase and eBase:IsValid())) then return anyFalse end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(not stRecord) then return anyFalse end
  return asmlib.ApplyPhysicalAnchor(this,eBase,nWe,nNc) and anyTrue or anyFalse
end

__e2setcost(15)
e2function entity entity:trackasmlibApplyPhysicalSettings(number nPi, number nFr, number nGr, string sPh)
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(not stRecord) then return anyFalse end
  return asmlib.ApplyPhysicalSettings(this,nPi,nFr,nGr,sPh) and anyTrue or anyFalse
end

__e2setcost(35)
e2function number entity:trackasmlibAttachAdditions()
  if(not (this and this:IsValid() and enFlag)) then return anyFalse end
  local stRecord = asmlib.CacheQueryAdditions(this:GetModel())
  if(not stRecord) then return 0 end
  return asmlib.AttachAdditions(this) and anyTrue or anyFalse
end

__e2setcost(20)
e2function number entity:trackasmlibAttachBodyGroups(string sBgpID)
  if(not (this and this:IsValid() and enFlag)) then return 0 end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(not stRecord) then return 0 end
  return asmlib.AttachBodyGroups(this, sBgpID) and anyTrue or anyFalse
end
