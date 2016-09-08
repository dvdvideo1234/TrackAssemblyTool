------ INCLUDE LIBRARY ------
if(CLIENT) then return end

if(SERVER) then
  AddCSLuaFile("trackassembly/trackasmlib.lua")
end
include("trackassembly/trackasmlib.lua")

------ LOCALIZNG FUNCTIONS ---
local Angle                = Angle
local Vector               = Vector
local tonumber             = tonumber
local tostring             = tostring
local hookAdd              = hook and hook.Add
local mathClamp            = math and math.Clamp
local utilTraceLine        = util and util.TraceLine

------ MODULE POINTER -------
local asmlib = trackasmlib

------ GLOBAL VARIABLES ------
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gnMaxOffRot = asmlib.GetOpVar("MAX_ROTATION")

local function trackPhysgunSnap(pPly, trEnt)
  if(not asmlib.GetAsmVar("engunsnap", "BUL")) then
    return asmlib.StatusLog(nil,"trackPhysgunSnap: Extension disabled") end
  if(not asmlib.IsPlayer(pPly)) then
    return asmlib.StatusLog(nil,"trackPhysgunSnap: Player invalid") end
  if(not (trEnt and trEnt:IsValid())) then
    return asmlib.StatusLog(nil,"trackPhysgunSnap: Trace entity invalid") end
  local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  if(not trRec) then
    return asmlib.StatusLog(nil,"trackPhysgunSnap: Trace not piece") end
  local trPos, trAng = trEnt:GetPos(), trEnt:GetAngles()
  local nMaxOffLin   = asmlib.GetAsmVar("maxlinear","FLT")
  local bnderrmod    = asmlib.GetAsmVar("bnderrmod" ,"STR")
  local activrad     = mathClamp(pPly:GetInfoNum(gsToolPrefL.."activrad", 0),1,asmlib.GetAsmVar("maxactrad", "FLT"))
  local spnflat      = (pPly:GetInfoNum(gsToolPrefL.."spnflat", 0) ~= 0)
  local igntype      = (pPly:GetInfoNum(gsToolPrefL.."igntype", 0) ~= 0)
  local nextx        = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextx"  , 0),-nMaxOffLin , nMaxOffLin)
  local nexty        = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nexty"  , 0),-nMaxOffLin , nMaxOffLin)
  local nextz        = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextz"  , 0),-nMaxOffLin , nMaxOffLin)
  local nextpic      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextpic", 0),-gnMaxOffRot,gnMaxOffRot)
  local nextyaw      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextyaw", 0),-gnMaxOffRot,gnMaxOffRot)
  local nextrol      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextrol", 0),-gnMaxOffRot,gnMaxOffRot)
  local ignphysgn    = (pPly:GetInfoNum(gsToolPrefL.."ignphysgn", 0))
  local freeze       = (pPly:GetInfoNum(gsToolPrefL.."freeze"   , 0))
  local gravity      = (pPly:GetInfoNum(gsToolPrefL.."gravity"  , 0))
  local physmater    = (pPly:GetInfo   (gsToolPrefL.."physmater", "metal"))
  local weld         = (pPly:GetInfoNum(gsToolPrefL.."weld"     , 0))
  local nocollide    = (pPly:GetInfoNum(gsToolPrefL.."nocollide", 0))
  local forcelim     = mathClamp(pPly:GetInfoNum(gsToolPrefL.."forcelim" , 0),0,asmlib.GetAsmVar("maxforce" ,"FLT"))
  local oPos, oAng   = Vector(), Angle()
  for trID = 1, trRec.Kept, 1 do
    local trPOA = asmlib.LocatePOA(trRec,trID)
    if(not trPOA) then
      return asmlib.StatusLog(nil,"trackPhysgunSnap: Failed locating "..trID.." of "..trRec.Kept) end
    asmlib.SetVector(oPos, trPOA.O)
    asmlib.SetAngle (oAng, trPOA.A)
    oPos:Rotate(trAng); oPos:Add(trPos)
    oAng:Set(trEnt:LocalToWorldAngles(oAng))
    local oEnd = oAng:Forward(); oEnd:Mul(activrad)
    local oTr = utilTraceLine({
      start  = oPos,
      endpos = oEnd,
      mask   = MASK_SOLID,
      filter = function(oPiece)
        if(oPiece and oPiece:IsValid() and oPiece:GetClass() == "prop_physics") then return true end
      end
    })
    if(oTr and oTr.Hit) then -- When hits the distance will be less than the active radius
      local oEnt    = oTr.Entity
      local stSpawn = asmlib.GetEntitySpawn(oEnt,oTr.HitPos,trRec.Slot,trID,
                        activrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(stSpawn) then
        if(not SetPosBound(trEnt,stSpawn.SPos or GetOpVar("VEC_ZERO"),pPly,bnderrmod)) then
          return StatusLog(nil,"trackPhysgunSnap: "..pPly:Nick().." snapped <"..sModel.."> outside bounds") end
        trEnt:SetAngles(stSpawn.SAng)
        if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
          return asmlib.StatusLog(nil,"trackPhysgunSnap: Failed to apply physical settings") end
        if(not asmlib.ApplyPhysicalAnchor(trEnt,oEnt,weld,nocollide,forcelim)) then
          return asmlib.StatusLog(nil,"trackPhysgunSnap: Failed to apply physical anchor")) end

        break -- The first one to be traced will be snapped on physgun mouse release
      end
    end
  end
end

hookAdd("PhysgunDrop", gsToolPrefL.."physgun_drop_snap", function(pPly, trEnt)
  local r, e = pcall(trackPhysgunSnap, pPly, trEnt)
  if(not r) then asmlib.PrintInstance("PHYSGUN_DROP: "..e) end
end)





