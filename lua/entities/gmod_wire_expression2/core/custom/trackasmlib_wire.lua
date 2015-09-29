local asmlib = trackasmlib

--------- Pieces ----------

__e2setcost(100)
e2function entity entity:trackasmlibSpawnEntity(vector trHitPos  , string hdModel  , number hdPointID,
                                          number nActRadius, number enFlatten, number enIgnTyp ,
                                          vector ucsPos    , vector ucsAng)
  if(not IsValid(this)) then return nil end
	if(not PropCore.ValidAction(self, this, "trackassembly_spawn_entity")) then return nil end
  local stSpawn = asmlib.GetEntitySpawn(this,trHitPos,hdModel,hdPointID,
                                        nActRadius,enFlatten,enIgnTyp,
                                        ucsPos[1],ucsPos[2],ucsPos[3],ucsAng[1],ucsAng[2],ucsAng[3])
  if(not stSpawn) then return nil end
	return PropCore.CreateProp(self,hdModel,stSpawn.SPos,stSpawn.SAng,frozen)
end

__e2setcost(80)
e2function entity trackasmlibSpawnNormal(vector ucsPos, angle ucsAng, string hdModel, number hdPointID, ucsOffPos,ucsOffAng)
	if not PropCore.ValidAction(self, nil, "trackassembly_spawn_normal") then return nil end
  local stSpawn = GetNormalSpawn(ucsPos,ucsAng,hdModel,hdPointID,
                        ucsOffPos[1],ucsOffPos[2],ucsOffPos[3],ucsOffAng[1],ucsOffAng[2],ucsOffAng[3])
  if(not stSpawn) then return nil end
	return PropCore.CreateProp(self,hdModel,stSpawn.SPos,stSpawn.SAng,frozen)
end

__e2setcost(30)
e2function number trackasmlibExists(string sModel)
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_exist") then return nil end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord) then return 1 else return 0 end
end

__e2setcost(30)
e2function number entity:trackasmlibExists()
	if not PropCore.ValidAction(self, this, "trackassembly_piece_exist") then return nil end
  local stRecord = asmlib.CacheQueryPiece(string.lower(this:GetModel()))
  if(stRecord) then return 1 else return 0 end
end

__e2setcost(120)
e2function array trackasmlibGetOffset(string sModel, number nOffset, string sPOA)
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_poa") then return nil end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(not stRecord) then return nil end
  if(not stRecord.Offs) then return nil end
  local nOffset = tonumber(nOffset)
  if(not nOffset) then return nil end
  if(not stRecord.Offs[nOffset]) then return nil else stRecord = stRecord.Offs[nOffset] end
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
    return nil
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
	if not PropCore.ValidAction(self, this, "trackassembly_piece_poa") then return nil end
  local stRecord = asmlib.CacheQueryPiece(string.lower(this:GetModel()))
  if(not stRecord) then return nil end
  if(not stRecord.Offs) then return nil end
  local nOffset = tonumber(nOffset)
  if(not nOffset) then return nil end
  if(not stRecord.Offs[nOffset]) then return nil else stRecord = stRecord.Offs[nOffset] end
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
    return nil
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
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_type") then return nil end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord) then return stRecord.Type else return nil end
end

__e2setcost(30)
e2function string entity:trackasmlibGetType()
	if not PropCore.ValidAction(self, this, "trackassembly_piece_type") then return nil end
  local stRecord = asmlib.CacheQueryPiece(string.lower(this:GetModel()))
  if(stRecord) then return stRecord.Type else return nil end
end

__e2setcost(30)
e2function string trackasmlibGetName(string sModel)
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_name") then return nil end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord) then return stRecord.Name else return nil end
end

__e2setcost(30)
e2function string entity:trackasmlibGetName()
	if not PropCore.ValidAction(self, this, "trackassembly_piece_name") then return nil end
  local stRecord = asmlib.CacheQueryPiece(string.lower(this:GetModel()))
  if(stRecord) then return stRecord.Name else return nil end
end

__e2setcost(30)
e2function number trackasmlibGetPointsCount(string sModel)
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_kept") then return nil end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord) then return stRecord.Kept else return nil end
end

__e2setcost(30)
e2function number entity:trackasmlibGetPointsCount()
	if not PropCore.ValidAction(self, this, "trackassembly_piece_kept") then return nil end
  local stRecord = asmlib.CacheQueryPiece(sModel)
  if(stRecord) then return stRecord.Kept else return nil end
end

---------- Additions ------------

__e2setcost(30)
e2function number trackasmlibHasAdditions(string sModel)
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_hasadd") then return nil end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(stRecord) then return 1 else return 0 end
end

__e2setcost(30)
e2function number entity:trackasmlibHasAdditions()
	if not PropCore.ValidAction(self, this, "trackassembly_piece_hasadd") then return nil end
  local stRecord = asmlib.CacheQueryAdditions(string.lower(this:GetModel()))
  if(stRecord) then return 1 else return 0 end
end

__e2setcost(50)
e2function number trackasmlibGetAdditionsCount(string sModel)
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_addcnt") then return nil end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(stRecord) then return stRecord.Kept else return nil end
end

__e2setcost(50)
e2function number entity:trackasmlibGetAdditionsCount()
	if not PropCore.ValidAction(self, this, "trackassembly_piece_addcnt") then return nil end
  local stRecord = asmlib.CacheQueryAdditions(string.lower(this:GetModel()))
  if(stRecord) then return stRecord.Kept else return nil end
end

__e2setcost(60)
e2function array trackasmlibGetAdditionsLine(string sModel, number nLine)
  local nLine = tonumber(nLine)
  if(not nLine) then return nil end
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_addcnt") then return nil end
  local stRecord = asmlib.CacheQueryAdditions(sModel)
  if(not (stRecord and stRecord[nLine])) then return nil else stRecord = stRecord[nLine] end
  local arAddtitionsLine = {}
  local defTable = asmlib.GetOpVar("TABLEDEF_ADDITIONS")
  local cntField = 2
  while(defTable[cntField]) do
    arAddtitionsLine[cntField] = stRecord[defTable[cntField][1]]
    cntField = cntField + 1
  end
  return arAddtitionsLine
end

__e2setcost(60)
e2function array entity:trackasmlibGetAdditionsLine(number nLine)
  local nLine = tonumber(nLine)
  if(not nLine) then return nil end
	if not PropCore.ValidAction(self, this, "trackassembly_piece_addcnt") then return nil end
  local stRecord = asmlib.CacheQueryAdditions(string.lower(this:GetModel()))
  if(not (stRecord and stRecord[nLine])) then return nil else stRecord = stRecord[nLine] end
  local arAddtitionsLine = {}
  local defTable = asmlib.GetOpVar("TABLEDEF_ADDITIONS")
  local cntField = 2
  while(defTable[cntField]) do
    arAddtitionsLine[cntField] = stRecord[defTable[cntField][1]]
    cntField = cntField + 1
  end
  return arAddtitionsLine
end

------------ PhysProperties ------------

__e2setcost(15)
e2function array trackasmlibGetProperty(string sType)
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_proptype") then return nil end
  local stRecord = asmlib.CacheQueryProperty(sType)
  if(not stRecord) then return nil end
	return stRecord
end

__e2setcost(15)
e2function array trackasmlibGetProperty()
	if not PropCore.ValidAction(self, nil, "trackassembly_piece_property") then return nil end
  local stRecord = asmlib.CacheQueryProperty()
  if(not stRecord) then return nil end
	return stRecord
end