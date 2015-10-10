----- Localizing the asmlib module
local asmlib   = trackasmlib
----- Get extention enabled flag
local Color    = Color
local enflag   = (asmlib.GetCvar("enwiremod","INT") ~= 0) and true or false
local defPiece = asmlib.GetOpVar("DEFTABLE_PIECES")
local defAddit = asmlib.GetOpVar("DEFTABLE_ADDITIONS")
local defPhysp = asmlib.GetOpVar("DEFTABLE_PHYSPROPERTIES")
--------- Pieces ----------

__e2setcost(100)
e2function array entity:trackasmlibSnapEntity(vector trHitPos  , string hdModel  , number hdPointID,
                                                number nActRadius, number enFlatten, number enIgnTyp ,
                                                vector ucsOffPos , vector ucsOffAng)
  if(not (this and this:IsValid() and enflag)) then return {} end
  local stSpawn = asmlib.GetEntitySpawn(this,trHitPos,hdModel,hdPointID,
                                        nActRadius,enFlatten,enIgnTyp,
                                        ucsPos[1],ucsPos[2],ucsPos[3],
                                        ucsAng[1],ucsAng[2],ucsAng[3])
  if(not stSpawn) then return {} end
  return {stSpawn.SPos, stSpawn.SAng}
end

__e2setcost(80)
e2function array trackasmlibSnapNormal(vector ucsPos   , angle ucsAng    , string hdModel,
                                       number hdPointID, vector ucsOffPos, vector ucsOffAng)
  if(not enflag) then return {} end
  local stSpawn = asmlib.GetNormalSpawn(ucsPos,ucsAng,hdModel,hdPointID,
                                        ucsOffPos[1],ucsOffPos[2],ucsOffPos[3],
                                        ucsOffAng[1],ucsOffAng[2],ucsOffAng[3])
  if(not stSpawn) then return {} end
  return {stSpawn.SPos, stSpawn.SAng}
end

__e2setcost(30)
e2function number trackasmlibIsPiece(string sModel)
  if(not enflag) then return 0 end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(stRecord) then return 1 else return 0 end
end

__e2setcost(30)
e2function number entity:trackasmlibIsPiece()
  if(not (this and this:IsValid() and enflag)) then return 0 end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(stRecord) then return 1 else return 0 end
end

__e2setcost(120)
e2function array trackasmlibGetOffset(string sModel, number nOffset, string sPOA)
  if(not enflag) then return {} end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(not stRecord) then return {} end
  if(not stRecord.Offs) then return {} end
  local nOffset = tonumber(nOffset)
  if(not nOffset) then return {} end
  if(not stRecord.Offs[nOffset]) then return {} else stRecord = stRecord.Offs[nOffset] end
  local sPOA = string.sub(string.upper(tostring(sPOA)),1,1)
  local arResult = {}
  local C1, C2, C3, C4
  if(sPOA == "P") then
    C1, C2, C3 = asmlib.GetIndexes("V")
  elseif(sPOA == "O") then
    C1, C2, C3 = asmlib.GetIndexes("V")
  elseif(sPOA == "A") then
    C1, C2, C3 = asmlib.GetIndexes("A")
  else
    return {}
  end  
  arResult[1] = stRecord[sPOA][C1]
  arResult[2] = stRecord[sPOA][C2]
  arResult[3] = stRecord[sPOA][C3]
  C1, C2, C3, C4 = asmlib.GetIndexes("S")
  arResult[4] = stRecord[sPOA][C1]
  arResult[5] = stRecord[sPOA][C2]
  arResult[6] = stRecord[sPOA][C3]
  arResult[7] = stRecord[sPOA][C4] and 1 or 0
  return arResult
end

__e2setcost(120)
e2function array entity:trackasmlibGetOffset(number nOffset, string sPOA)
  if(not (this and this:IsValid() and enflag)) then return {} end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(not stRecord) then return {} end
  if(not stRecord.Offs) then return {} end
  local nOffset = tonumber(nOffset)
  if(not nOffset) then return {} end
  if(not stRecord.Offs[nOffset]) then return {} else stRecord = stRecord.Offs[nOffset] end
  local sPOA = string.sub(string.upper(tostring(sPOA)),1,1)
  local arResult = {}
  local C1, C2, C3, C4
  if(sPOA == "P") then
    C1, C2, C3 = asmlib.GetIndexes("V")
  elseif(sPOA == "O") then
    C1, C2, C3 = asmlib.GetIndexes("V")
  elseif(sPOA == "A") then
    C1, C2, C3 = asmlib.GetIndexes("A")
  else
    return {}
  end  
  arResult[1] = stRecord[sPOA][C1]
  arResult[2] = stRecord[sPOA][C2]
  arResult[3] = stRecord[sPOA][C3]
  C1, C2, C3, C4 = asmlib.GetIndexes("S")
  arResult[4] = stRecord[sPOA][C1]
  arResult[5] = stRecord[sPOA][C2]
  arResult[6] = stRecord[sPOA][C3]
  arResult[7] = stRecord[sPOA][C4] and 1 or 0
  return arResult
end

__e2setcost(30)
e2function string trackasmlibGetType(string sModel)
  if(not enflag) then return "" end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord) then return stRecord.Type else return "" end
end

__e2setcost(30)
e2function string entity:trackasmlibGetType()
  if(not (this and this:IsValid() and enflag)) then return "" end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(stRecord) then return stRecord.Type else return "" end
end

__e2setcost(30)
e2function string trackasmlibGetName(string sModel)
  if(not enflag) then return "" end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord) then return stRecord.Name else return "" end
end

__e2setcost(30)
e2function string entity:trackasmlibGetName()
  if(not (this and this:IsValid() and enflag)) then return "" end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(stRecord) then return stRecord.Name else return "" end
end

__e2setcost(30)
e2function number trackasmlibGetPointsCount(string sModel)
  if(not enflag) then return 0 end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord) then return stRecord.Kept else return 0 end
end

__e2setcost(30)
e2function number entity:trackasmlibGetPointsCount()
  if(not (this and this:IsValid() and enflag)) then return 0 end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(stRecord) then return stRecord.Kept else return 0 end
end

---------- Additions ------------

__e2setcost(30)
e2function number trackasmlibHasAdditions(string sModel)
  if(not enflag) then return 0 end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(stRecord) then return 1 else return 0 end
end

__e2setcost(30)
e2function number entity:trackasmlibHasAdditions()
  if(not (this and this:IsValid() and enflag)) then return 0 end
  local stRecord = asmlib.CacheQueryAdditions(this:GetModel())
  if(stRecord) then return 1 else return 0 end
end

__e2setcost(50)
e2function number trackasmlibGetAdditionsCount(string sModel)
  if(not enflag) then return 0 end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(stRecord) then return stRecord.Kept else return 0 end
end

__e2setcost(50)
e2function number entity:trackasmlibGetAdditionsCount()
  if(not (this and this:IsValid() and enflag)) then return 0 end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(stRecord) then return stRecord.Kept else return 0 end
end

__e2setcost(60)
e2function array trackasmlibGetAdditionsLine(string sModel, number nLine)
  if(not enflag) then return {} end
  if(not defAddit) then
    return asmlib.StatusLog({},"entity:trackasmlibGetAdditionLine(number): No table definition")
  end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(not stRecord) then return {} end
  if(not stRecord[nLine]) then return {} end
  stRecord = stRecord[nLine]
  local cntField = 2
  local arAdditionsLine = {}
  while(defAddit[cntField]) do
    arAdditionsLine[cntField-1] = stRecord[defAddit[cntField][1]]
    cntField = cntField + 1
  end
  return arAdditionsLine
end

__e2setcost(60)
e2function array entity:trackasmlibGetAdditionsLine(number nLine)
  if(not (this and this:IsValid() and enflag)) then return {} end
  if(not defAddit) then
    return asmlib.StatusLog({},"entity:trackasmlibGetAdditionLine(number): No table definition")
  end
  local stRecord = asmlib.CacheQueryAdditions(this:GetModel())
  if(not stRecord) then return {} end
  if(not stRecord[nLine]) then return {} end
  stRecord = stRecord[nLine]
  local arAdditionsLine = {}
  local cntField = 2
  while(defAddit[cntField]) do
    arAdditionsLine[cntField-1] = stRecord[defAddit[cntField][1]]
    cntField = cntField + 1
  end
  return arAdditionsLine
end

------------ PhysProperties ------------

__e2setcost(15)
e2function array trackasmlibGetProperty(string sType)
  if(not enflag) then return {} end
  local stRecord = asmlib.CacheQueryProperty(sType)
  if(not stRecord) then return {} end
  return stRecord
end

__e2setcost(15)
e2function array trackasmlibGetProperty()
  if(not enflag) then return {} end
  local stRecord = asmlib.CacheQueryProperty()
  if(not stRecord) then return {} end
  return stRecord
end

----------- Piece creator --------------

__e2setcost(50)
e2function entity trackasmlibMakePiece(string sModel, vector vPos, angle aAng, number nMass, string sBgpID, number nR, number nG, number nB, number nA)
  if(not enflag) then return nil end
  return asmlib.MakePiece(sModel,Vector(vPos[1],vPos[2],vPos[3]),
                                 Angle (aAng[1],aAng[2],aAng[3]),
                                 nMass or 50000,sBgpID or "",
                                 Color(nR or 255, nG or 255, nB or 255, nA or 255))
end

__e2setcost(50)
e2function entity entity:trackasmlibDuplicatePiece(vector vPos, angle aAng)
  if(not (this and this:IsValid() and enflag)) then return nil end
  local stRecord = asmlib.CacheQueryAdditions(this:GetModel())
  if(not stRecord) then return nil end
  local sBgpID  = asmlib.GetPropBodyGrp(this)..
                  asmlib.GetOpVar("OPSYM_DIRECTORY")..
                  asmlib.GetPropSkin(this)
  return asmlib.MakePiece(sModel,Vector(vPos[1],vPos[2],vPos[3]),
                                 Angle (aAng[1],aAng[2],aAng[3]),
                                 this:GetMass(),sBgpID,this:GetColor())
end

__e2setcost(15)
e2function entity entity:trackasmlibAnchorPiece(entity eBase, number nWe, number nNc, number nFr, number nWg, number nGr, number sPh)
  if(not (this and this:IsValid() and enflag)) then return 0 end
  local stRecord = asmlib.CacheQueryAdditions(this:GetModel())
  if(not stRecord) then return 0 end
  return asmlib.AnchorPiece(this,eBase,nWe,nNc,nFr,nWg,nGr,sPh) and 1 or 0
end

__e2setcost(35)
e2function number entity:trackasmlibAttachAdditions()
  if(not (this and this:IsValid() and enflag)) then return 0 end
  local stRecord = asmlib.CacheQueryAdditions(this:GetModel())
  if(not stRecord) then return 0 end
  return asmlib.AttachAdditions(this) and 1 or 0
end

__e2setcost(20)
e2function number entity:trackasmlibAttachBodyGroups(string sBgpID)
  if(not (this and this:IsValid() and enflag)) then return 0 end
  local stRecord = asmlib.CacheQueryPiece(this:GetModel())
  if(not stRecord) then return 0 end
  return asmlib.AttachBodyGroups(this, sBgpID) and 1 or 0
end