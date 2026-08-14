--- Store a pointer to our module
local asmlib = trackasmlib; if(not asmlib) then -- Module present
  ErrorNoHaltWithStack("TOOL: Track assembly tool module fail!\n"); return end

if(not asmlib.IsInit()) then -- Make sure the module is initialized
  ErrorNoHaltWithStack("TOOL: Track assembly tool not initialized!\n"); return end

--- Global References
local gtLogs      = {"TOOL"}
local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gnMaxRot    = asmlib.GetOpVar("MAX_ROTATION")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")
local gsModeDataB = asmlib.GetOpVar("MODE_DATABASE")
local gsLimitName = asmlib.GetOpVar("CVAR_LIMITNAME")
local gsUndoPrefN = asmlib.GetOpVar("UNDO_PERFIX")
local gsNoID      = asmlib.GetOpVar("MISS_NOID") -- No such ID
local gsNoAV      = asmlib.GetOpVar("MISS_NOAV") -- Not available
local gsNoMD      = asmlib.GetOpVar("MISS_NOMD") -- No model
local gsNoBS      = asmlib.GetOpVar("MISS_NOBS") -- No Body-group skin
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVISION")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gnRatio     = asmlib.GetOpVar("GOLDEN_RATIO")
local conPalette  = asmlib.GetContainer("COLORS_LIST")
local conWorkMode = asmlib.GetContainer("WORK_MODE")
local conElements = asmlib.GetContainer("LIST_VGUI")
local varLanguage = GetConVar("gmod_language")

if(not asmlib.ProcessDSV()) then -- Default tab delimiter
  local sS = asmlib.GetOpVar("DIRPATH_SET")
  local sD = GetLibraryPath(sS, gsLibName, "_dsv")
  asmlib.LogInstance("List settings error "..asmlib.GetReport(sD))
end

cleanup.Register(gsLimitName)

TOOL.ClientConVar = {
  [ "weld"       ] = 1,
  [ "mass"       ] = 25000,
  [ "model"      ] = "models/props_phx/trains/tracks/track_1x.mdl",
  [ "nextx"      ] = 0,
  [ "nexty"      ] = 0,
  [ "nextz"      ] = 0,
  [ "freeze"     ] = 1,
  [ "anchor"     ] = asmlib.GetIdentity(),
  [ "igntype"    ] = 0,
  [ "spnflat"    ] = 0,
  [ "angsnap"    ] = 15,
  [ "sizeucs"    ] = 20,
  [ "pointid"    ] = 1,
  [ "pnextid"    ] = 2,
  [ "nextpic"    ] = 0,
  [ "nextyaw"    ] = 0,
  [ "nextrol"    ] = 0,
  [ "spawncn"    ] = 0,
  [ "bgskids"    ] = gsNoBS,
  [ "gravity"    ] = 1,
  [ "adviser"    ] = 1,
  [ "elevpnt"    ] = 0,
  [ "activrad"   ] = 50,
  [ "pntasist"   ] = 1,
  [ "surfsnap"   ] = 0,
  [ "exportdb"   ] = 0,
  [ "forcelim"   ] = 0,
  [ "ignphysgn"  ] = 0,
  [ "ghostcnt"   ] = 1,
  [ "ghostblnd"  ] = 0.8,
  [ "stackcnt"   ] = 5,
  [ "maxstatts"  ] = 3,
  [ "nocollide"  ] = 1,
  [ "nocollidew" ] = 0,
  [ "physmater"  ] = "metal",
  [ "enpntmscr"  ] = 1,
  [ "engunsnap"  ] = 0,
  [ "workmode"   ] = 0,
  [ "appangfst"  ] = 0,
  [ "applinfst"  ] = 0,
  [ "enradmenu"  ] = 0,
  [ "sgradmenu"  ] = 1,
  [ "rtradmenu"  ] = 18,
  [ "incsnpang"  ] = 5,
  [ "incsnplin"  ] = 5,
  [ "upspanchor" ] = 0,
  [ "crvturnlm"  ] = 0.95,
  [ "crvleanlm"  ] = 0.95,
  [ "crvsuprev"  ] = 0,
  [ "flipoverid" ] = ""
}

if(CLIENT) then
  language.Add("tool."..gsToolNameL..".category", "Construction")

  -- https://wiki.facepunch.com/gmod/Tool_Information_Display
  TOOL.Information = asmlib.GetToolInformation()

  concommand.Remove(gsToolPrefL.."openframe")
  concommand.Add(gsToolPrefL.."openframe", asmlib.GetActionCode("OPEN_FRAME"))

  net.Receive(gsLibName.."SendDeleteGhosts"   , asmlib.GetActionCode("CLEAR_GHOSTS"))
  net.Receive(gsLibName.."SendIntersectClear" , asmlib.GetActionCode("CLEAR_RELATION"))
  net.Receive(gsLibName.."SendIntersectRelate", asmlib.GetActionCode("CREATE_RELATION"))
  net.Receive(gsLibName.."SendInsertCurveNode",
    function(nLen) local tU = {}
      oU    = net.ReadEntity() -- Player who applied the curve change     ( User )
      tU[1] = net.ReadVector() -- Current node location in the stack      ( Node )
      tU[2] = net.ReadNormal() -- Current node normal vector in the stack ( Norm )
      tU[3] = net.ReadVector() -- Current node base location in the stack ( Base )
      tU[4] = net.ReadVector() -- Player trace location curve data        ( RayO )
      tU[5] = net.ReadAngle()  -- Player trace angle curve data           ( RayA )
      tU[6] = net.ReadBool()   -- Player trace hits POA location or not   ( RayL )
      tU[7] = net.ReadUInt(16) -- The index to change at when requested   (  ID  )
      tU[8] = net.ReadUInt(16) -- The super-elevation index normal vector (  IN  )
      tU[9] = net.ReadNormal() -- The super-elevation vector applied      ( Lean )
      local bS, sR = asmlib.DoAction("INSERT_CURVE_NODE", oU, tU); if(not bS) then
        asmlib.LogInstance("Insert curve error "..asmlib.GetReport(oU, tU[7], sR)) end
    end)

  net.Receive(gsLibName.."SendUpdateCurveNode",
    function(nLen) local tU = {}
      oU    = net.ReadEntity() -- Player who applied the curve change     ( User )
      tU[1] = net.ReadVector() -- Current node location in the stack      ( Node )
      tU[2] = net.ReadNormal() -- Current node normal vector in the stack ( Norm )
      tU[3] = net.ReadVector() -- Current node base location in the stack ( Base )
      tU[4] = net.ReadVector() -- Player trace location curve data        ( RayO )
      tU[5] = net.ReadAngle()  -- Player trace angle curve data           ( RayA )
      tU[6] = net.ReadBool()   -- Player trace hits POA location or not   ( RayL )
      tU[7] = net.ReadUInt(16) -- The index to change at when requested   (  ID  )
      local bS, sR = asmlib.DoAction("UPDATE_CURVE_NODE", oU, tU); if(not bS) then
        asmlib.LogInstance("Update curve error "..asmlib.GetReport(oU, tU[7], sR)) end
    end)

  net.Receive(gsLibName.."SendRemoveCurveNode",
    function(nLen)
      local oU, iC = net.ReadEntity(), net.ReadUInt(16)
      local bS, sR = asmlib.DoAction("REMOVE_CURVE_NODE", oU, iC); if(not bS) then
        asmlib.LogInstance("Remove curve error "..asmlib.GetReport(oU, iC, sR)) end
    end)

  net.Receive(gsLibName.."SendClearCurveNode" ,
    function(nLen) local oU = net.ReadEntity()
      local bS, sR = asmlib.DoAction("CLEAR_CURVE_NODE", oU); if(not bS) then
        asmlib.LogInstance("Clear curve error "..asmlib.GetReport(oU, sR)) end
    end)

  hook.Add("Think", gsToolPrefL.."update_ghosts", asmlib.GetActionCode("DRAW_GHOSTS"))
  hook.Add("PreDrawHalos", gsToolPrefL.."update_contextval", asmlib.GetActionCode("UPDATE_CONTEXTVAL"))
  hook.Add("PostDrawHUD", gsToolPrefL.."radial_menu_draw", asmlib.GetActionCode("DRAW_RADMENU"))
  hook.Add("PostDrawHUD", gsToolPrefL.."physgun_drop_draw", asmlib.GetActionCode("DRAW_PHYSGUN"))
  hook.Add("PlayerBindPress", gsToolPrefL.."player_bind_press", asmlib.GetActionCode("BIND_PRESS"))
  hook.Add("OnContextMenuOpen", gsToolPrefL.."ctxmenu_open", asmlib.GetActionCode("CTXMENU_OPEN"))
  hook.Add("OnContextMenuClose", gsToolPrefL.."ctxmenu_close", asmlib.GetActionCode("CTXMENU_CLOSE"))

  concommand.Remove(gsToolPrefL.."resetvars")
  concommand.Add(gsToolPrefL.."resetvars",
    function(oPly, oCom, oArgs)
      asmlib.SetAsmConvar(oPly,"nextx"  , 0)
      asmlib.SetAsmConvar(oPly,"nexty"  , 0)
      asmlib.SetAsmConvar(oPly,"nextz"  , 0)
      asmlib.SetAsmConvar(oPly,"nextpic", 0)
      asmlib.SetAsmConvar(oPly,"nextyaw", 0)
      asmlib.SetAsmConvar(oPly,"nextrol", 0)
    end)

  -- Store references and stuff related to the tool file
  asmlib.SetOpVar("STORE_TOOLOBJ", TOOL)
  asmlib.SetOpVar("STORE_CONVARS", TOOL:BuildConVarList())
end

if(SERVER) then
  local poQueue = asmlib.GetQueue("THINK")
  local vsHash  = "_"..poQueue:GetKey():lower()
  local cvTask  = asmlib.GetAsmConvar("enmultask", "OBJ")
  local gbMen, svName = cvTask:GetBool(), cvTask:GetName()

  cvars.RemoveChangeCallback(svName, svName..vsHash)
  cvars.AddChangeCallback(svName, function(sV, vO, vN)
    gbMen = ((tonumber(vN) or 0) ~= 0)
  end, svName..vsHash)

  hook.Remove("Think", gsToolPrefL.."worker"..vsHash)
  hook.Add("Think", gsToolPrefL.."worker"..vsHash, function() poQueue:Work():Next(gbMen) end)
  hook.Remove("PlayerDisconnected", gsToolPrefL.."player_quit")
  hook.Add("PlayerDisconnected", gsToolPrefL.."player_quit", asmlib.GetActionCode("PLAYER_QUIT"))
  hook.Remove("PhysgunDrop", gsToolPrefL.."physgun_drop_snap")
  hook.Add("PhysgunDrop", gsToolPrefL.."physgun_drop_snap", asmlib.GetActionCode("PHYSGUN_DROP"))

  duplicator.RegisterEntityModifier(gsToolPrefL.."dupe_phys_set",asmlib.GetActionCode("DUPE_PHYS_SETTINGS"))

  concommand.Remove(gsToolPrefL.."refreshdsv")
  concommand.Add(gsToolPrefL.."refreshdsv",
    function(oPly, oCom, oArgs) -- The command is intended for running in the server developer console
      local sID = "*REFRESH_ITEM_LIST"
      if(game.SinglePlayer()) then -- During single player the database is refreshed via context menu
        asmlib.LogInstance("Refresh routine single player", sID); return end -- Command does nothing in single
      local sP = tostring(oArgs[1] or ""); if(oPly ~= NULL) then -- Player will be when executed in the console
        asmlib.LogInstance("Refresh routine skip "..asmlib.GetReport(sP, oPly), sID); return end -- Exit routine
      local bS, sR = asmlib.DoAction(sID:sub(2, -1), sP); if(not bS) then
        asmlib.LogInstance("Refresh execute "..asmlib.GetReport(sP, sR), sID); return end
    end)

  net.Receive(gsLibName.."SendRefreshDSV",
    function(nLen, oPly) -- This is intended for refreshing the DSV in case the routine is run in SP on the CL
      local sID, sP = "*REFRESH_ITEM_LIST", net.ReadString() -- Read the DSV prefix and refresh SV as well
      if(not game.SinglePlayer()) then -- During single player the database is refreshed via context menu
        asmlib.LogInstance("Refresh routine multi player", sID); return end -- Command does nothing in single
      local bS, vO = asmlib.DoAction(sID:sub(2, -1), sP); if(not bS) then
        asmlib.LogInstance("Refresh execute: "..asmlib.GetReport(sP,sR), sID); return end
    end)
end

TOOL.Name       = language and language.GetPhrase("tool."..gsToolNameL..".name")
TOOL.Category   = language and language.GetPhrase("tool."..gsToolNameL..".category")
TOOL.Command    = nil -- Command on click (nil for default)
TOOL.ConfigName = nil -- Configure file name (nil for default)

function TOOL:GetSuperElevation()
  return math.Clamp(self:GetClientNumber("crvsuprev", 0), -2, 2)
end

function TOOL:GetCurveFactor()
  return asmlib.GetAsmConvar("curvefact", "FLT")
end

function TOOL:GetBoundErrorMode()
  return asmlib.GetAsmConvar("bnderrmod", "STR")
end

function TOOL:GetEnPhysgunSnap()
  return (self:GetClientNumber("engunsnap", 0) ~= 0)
end

function TOOL:GetCurveSamples()
  return asmlib.GetAsmConvar("curvsmple", "INT")
end

function TOOL:GetRadialMenu()
  return (self:GetClientNumber("enradmenu", 0) ~= 0)
end

function TOOL:GetRadialSegm()
  return math.Clamp(self:GetClientNumber("sgradmenu", 1), 1, 16)
end

function TOOL:GetRadialAngle()
  return math.Clamp(self:GetClientNumber("rtradmenu", 0), -gnMaxRot, gnMaxRot)
end

function TOOL:GetIsLinearFirst()
  return (self:GetClientNumber("applinfst", 0) ~= 0)
end

function TOOL:GetIsAngularFirst()
  return (self:GetClientNumber("appangfst", 0) ~= 0)
end

function TOOL:GetContextMenuAll()
  return asmlib.GetAsmConvar("enctxmall", "BUL")
end

function TOOL:GetModel()
  return tostring(self:GetClientInfo("model") or "")
end

function TOOL:GetStackCount()
  local nMax = asmlib.GetAsmConvar("maxstcnt", "INT")
  return math.Clamp(self:GetClientNumber("stackcnt", 0), 0, nMax)
end

function TOOL:GetSpawnRate()
  return asmlib.GetAsmConvar("spawnrate", "INT")
end

function TOOL:GetMass()
  local nMax = asmlib.GetAsmConvar("maxmass","FLT")
  return math.Clamp(self:GetClientNumber("mass", 0), 0, nMax)
end

function TOOL:GetSizeUCS()
  local nMax = asmlib.GetAsmConvar("maxlinear","FLT")
  return math.Clamp(self:GetClientNumber("sizeucs", 0), 0, nMax)
end

function TOOL:GetDeveloperMode()
  return asmlib.GetAsmConvar("devmode", "BUL")
end

function TOOL:GetPosOffsets()
  local nMax = asmlib.GetAsmConvar("maxlinear","FLT")
  return math.Clamp(self:GetClientNumber("nextx", 0), -nMax, nMax),
         math.Clamp(self:GetClientNumber("nexty", 0), -nMax, nMax),
         math.Clamp(self:GetClientNumber("nextz", 0), -nMax, nMax)
end

function TOOL:GetAngOffsets()
  return math.Clamp(self:GetClientNumber("nextpic", 0), -gnMaxRot, gnMaxRot),
         math.Clamp(self:GetClientNumber("nextyaw", 0), -gnMaxRot, gnMaxRot),
         math.Clamp(self:GetClientNumber("nextrol", 0), -gnMaxRot, gnMaxRot)
end

function TOOL:GetElevation()
  return self:GetClientNumber("elevpnt", 0)
end

function TOOL:GetCurvatureTurn()
  return self:GetClientNumber("crvturnlm", 0)
end

function TOOL:GetCurvatureLean()
  return self:GetClientNumber("crvleanlm", 0)
end

function TOOL:GetPointAssist()
  return (self:GetClientNumber("pntasist", 0) ~= 0)
end

function TOOL:GetFreeze()
  return (self:GetClientNumber("freeze", 0) ~= 0)
end

function TOOL:GetIgnoreType()
  return (self:GetClientNumber("igntype", 0) ~= 0)
end

function TOOL:GetBodyGroupSkin()
  return tostring(self:GetClientInfo("bgskids") or gsNoBS)
end

function TOOL:GetGravity()
  return (self:GetClientNumber("gravity", 0) ~= 0)
end

function TOOL:GetGhostsCount()
  local nMax = asmlib.GetAsmConvar("maxghcnt", "INT")
  return math.Clamp(self:GetClientNumber("ghostcnt", 0), 0, nMax)
end

function TOOL:GetUpSpawnAnchor()
  return (self:GetClientNumber("upspanchor", 0) ~= 0)
end

function TOOL:GetNoCollide()
  return (self:GetClientNumber("nocollide", 0) ~= 0)
end

function TOOL:GetSpawnFlat()
  return (self:GetClientNumber("spnflat", 0) ~= 0)
end

function TOOL:GetExportDB()
  return (self:GetClientNumber("exportdb", 0) ~= 0)
end

function TOOL:GetLogLines()
  return (asmlib.GetAsmConvar("logsmax", "INT") or 0)
end

function TOOL:GetLogBurst()
  return (asmlib.GetAsmConvar("logsbrs", "INT") or 0)
end

function TOOL:GetAdviser()
  return (self:GetClientNumber("adviser", 0) ~= 0)
end

function TOOL:GetPointID()
  return self:GetClientNumber("pointid", 1), self:GetClientNumber("pnextid", 2)
end

function TOOL:GetActiveRadius()
  local nMax = asmlib.GetAsmConvar("maxactrad", "FLT")
  return math.Clamp(self:GetClientNumber("activrad", 0), 0, nMax)
end

function TOOL:GetAngSnap()
  return math.Clamp(self:GetClientNumber("angsnap", 0), 0, gnMaxRot)
end

function TOOL:GetForceLimit()
  local nMax = asmlib.GetAsmConvar("maxforce" ,"FLT")
  return math.Clamp(self:GetClientNumber("forcelim", 0), 0, nMax)
end

function TOOL:GetWeld()
  return (self:GetClientNumber("weld", 0) ~= 0)
end

function TOOL:GetIgnorePhysgun()
  return (self:GetClientNumber("ignphysgn", 0) ~= 0)
end

function TOOL:GetSpawnCenter()
  return (self:GetClientNumber("spawncn", 0) ~= 0)
end

function TOOL:GetStackAttempts()
  return (math.Clamp(self:GetClientNumber("maxstatts", 0), 0, 10))
end

function TOOL:GetGhostBlend()
  return (math.Clamp(self:GetClientNumber("ghostblnd", 0), 0, 1))
end

function TOOL:GetPhysMeterial()
  return tostring(self:GetClientInfo("physmater") or "metal")
end

function TOOL:GetFlipOverID()
  return tostring(self:GetClientInfo("flipoverid") or "")
end

function TOOL:GetSurfaceSnap()
  return (self:GetClientNumber("surfsnap", 0) ~= 0)
end

function TOOL:GetScrollMouse()
  return (self:GetClientNumber("enpntmscr", 0) ~= 0)
end

function TOOL:GetNocollideWorld()
  return (self:GetClientNumber("nocollidew", 0) ~= 0)
end

function TOOL:SwitchPoint(vDir, bNxt)
  local oRec = asmlib.CacheQueryPiece(self:GetModel()); if(not asmlib.IsHere(oRec)) then
    asmlib.LogInstance("Invalid record",gtLogs); return 1, 2 end
  local nDir, user = (tonumber(vDir) or 0), self:GetOwner() -- Normalize switch direction
  local pointid, pnextid = self:GetPointID()
  if(bNxt) then pnextid = asmlib.SwitchID(pnextid,nDir,oRec)
  else          pointid = asmlib.SwitchID(pointid,nDir,oRec) end
  if(pnextid == pointid) then pnextid = asmlib.SwitchID(pnextid,nDir,oRec) end
  asmlib.SetAsmConvar(user, "pnextid", pnextid)
  asmlib.SetAsmConvar(user, "pointid", pointid)
  asmlib.LogInstance("Success "..asmlib.GetReport(nDir, bNxt),gtLogs)
  return pointid, pnextid
end

function TOOL:IntersectClear(bMute)
  local user = self:GetOwner()
  local stRay = asmlib.IntersectRayRead(user, "relate")
  if(stRay) then asmlib.IntersectRayClear(user, "relate")
    if(SERVER) then local ryEnt = stRay.Ent
      net.Start(gsLibName.."SendIntersectClear"); net.WriteEntity(user); net.Send(user)
      local sRe = asmlib.GetIdentity(ryEnt) -- If the entity is not valid show legend is unavailable
      if(ryEnt and ryEnt:IsValid()) then asmlib.UpdateColor(ryEnt, "intersect", "ry", false) end
      if(not bMute) then
        asmlib.LogInstance("Relation cleared "..sRe, gtLogs)
        asmlib.Notify(user, "CLEANUP", "Intersect relation clear: %s !", sRe)
      end -- Make sure to delete the relation on both client and server
    end
  end; return true
end

function TOOL:IntersectRelate(oEnt, vHit)
  local user = self:GetOwner(); self:IntersectClear(true)
  local stRay = asmlib.IntersectRayCreate(user, oEnt, vHit, "relate")
  if(not stRay) then -- Create/update the ray in question
    asmlib.LogInstance("Update fail",gtLogs); return false end
  if(SERVER) then -- Only the server is allowed to define relation ray
    net.Start(gsLibName.."SendIntersectRelate")
    net.WriteEntity(oEnt); net.WriteVector(vHit); net.WriteEntity(user); net.Send(user)
    local sRe = asmlib.GetIdentity(oEnt) -- If the entity is not valid show legend is unavailable
    if(oEnt and oEnt:IsValid()) then asmlib.UpdateColor(oEnt, "intersect", "ry", true) end
    asmlib.Notify(user, "UNDO", "Intersect relation set: %s !", sRe)
  end return true
end

function TOOL:IntersectSnap(trEnt, vHit, stSpawn, bMute)
  local pointid, pnextid = self:GetPointID()
  local user, model = self:GetOwner(), self:GetModel()
  if(not asmlib.IntersectRayCreate(user, trEnt, vHit, "origin")) then
    asmlib.LogInstance("Failed updating ray",gtLogs); return nil end
  local xx, x1, x2, stRay1, stRay2 = asmlib.IntersectRayHash(user, "origin", "relate")
  if(not xx) then if(bMute) then return nil
    else asmlib.Notify(user, "GENERIC", "Define intersection relation !")
      asmlib.LogInstance("Active ray mismatch",gtLogs); return nil end
  end
  local mx, o1, o2 = asmlib.IntersectRayModel(model, pointid, pnextid)
  if(not mx) then if(bMute) then return nil
    else asmlib.Notify(user, "ERROR", "Model intersection mismatch !")
      asmlib.LogInstance("Model ray mismatch",gtLogs); return nil end
  end
  local aOrg, vx, vy, vz = stSpawn.OAng, stSpawn.PNxt:Unpack()
  if(self:GetIsAngularFirst()) then aOrg = stRay1.Diw end
  mx:Rotate(stSpawn.SAng); mx:Mul(-1) -- Translate entity local intersection to world
  stSpawn.SPos:Set(mx); stSpawn.SPos:Add(xx); -- Update spawn position with the ray intersection
  local cx, cy, cz = aOrg:Forward(), aOrg:Right(), aOrg:Up()
  if(self:GetIsLinearFirst()) then
    local dx = Vector(); dx:Set(o1); dx:Rotate(stSpawn.SAng)
          dx:Add(stSpawn.SPos); dx:Sub(stRay1.Orw)
    local dy = Vector(); dy:Set(o2); dy:Rotate(stSpawn.SAng)
          dy:Add(stSpawn.SPos); dy:Sub(stRay2.Orw)
    local dz = 0.5 * (stRay2.Orw - stRay1.Orw)
    local lx = math.abs(dx:Dot(aOrg:Forward()))
    local ly = math.abs(dy:Dot(aOrg:Right()))
    local lz = math.abs(dz:Dot(aOrg:Up()))
    vx, vy, vz = math.Clamp(vx, -lx, lx), math.Clamp(vy, -ly, ly), math.Clamp(vz, -lz, lz)
  end; cx:Mul(vx); cy:Mul(vy); cz:Mul(vz)
  stSpawn.SPos:Add(cx); stSpawn.SPos:Add(cy); stSpawn.SPos:Add(cz)
  return xx, x1, x2, stRay1, stRay2
end

function TOOL:ClearAnchor(bMute)
  local user = self:GetOwner()
  local siAnc, svEnt = self:GetAnchor()
  if(CLIENT) then return false end; self:ClearObjects()
  asmlib.SetAsmConvar(user,"anchor", asmlib.GetIdentity())
  if(svEnt and svEnt:IsValid() and not svEnt:IsWorld()) then
    asmlib.UpdateColor(svEnt, "anchor", "an", false) end
  if(not bMute) then -- Notify the user when anchor is cleared
    asmlib.Notify(user, "CLEANUP", "Clear anchor %s !", siAnc) end
  asmlib.LogInstance("Clear "..asmlib.GetReport(bMute),gtLogs); return true
end

function TOOL:SetAnchor(stTrace)
  self:ClearAnchor(true)
  if(not stTrace) then
    asmlib.LogInstance("Trace invalid",gtLogs); return false end
  if(not stTrace.Hit) then
    asmlib.LogInstance("Trace not hit",gtLogs); return false end
  local user = self:GetOwner(); if(not (user and user:IsValid())) then
    asmlib.LogInstance("Player invalid",gtLogs); return false end
  if(stTrace.HitWorld) then
    local trEnt = game.GetWorld()
    local phEnt = trEnt:GetPhysicsObject()
    local sAnchor = asmlib.GetIdentity("0", "worldspawn.mdl")
    self:SetObject(1,trEnt,stTrace.HitPos,phEnt,stTrace.PhysicsBone,stTrace.HitNormal)
    asmlib.SetAsmConvar(user,"anchor",sAnchor)
    asmlib.Notify(user, "UNDO", "Apply anchor %s !", sAnchor)
    asmlib.LogInstance("(WORLD) Apply "..asmlib.GetReport(sAnchor),gtLogs)
  else
    local trEnt = stTrace.Entity; if(not (trEnt and trEnt:IsValid())) then
      asmlib.LogInstance("Trace no entity",gtLogs); return false end
    local phEnt = trEnt:GetPhysicsObject(); if(not (phEnt and phEnt:IsValid())) then
      asmlib.LogInstance("Trace no physics",gtLogs); return false end
    local sAnchor = asmlib.GetIdentity(trEnt)
    asmlib.UpdateColor(trEnt, "anchor", "an", true)
    self:SetObject(1,trEnt,stTrace.HitPos,phEnt,stTrace.PhysicsBone,stTrace.HitNormal)
    asmlib.SetAsmConvar(user,"anchor",sAnchor)
    asmlib.Notify(user, "UNDO", "Apply anchor %s !", sAnchor)
    asmlib.LogInstance("(PROP) Apply "..asmlib.GetReport(sAnchor),gtLogs)
  end; return true
end

function TOOL:GetAnchor()
  local svEnt = self:GetEnt(1)
  local siAnc = (self:GetClientInfo("anchor") or asmlib.GetIdentity())
  if(svEnt) then
    if(not svEnt:IsWorld() and
       not svEnt:IsValid()) then svEnt = nil end
  else svEnt = nil end
  return siAnc, svEnt
end

function TOOL:GetWorkingMode()
  local nWork = self:GetClientNumber("workmode", 0)
  local cWork = math.Clamp(nWork or 0, 1, conWorkMode:GetSize())
  local sWork = tostring(conWorkMode:Select(cWork) or gsNoAV):sub(1,6)
  if(SERVER) then -- Change the operation mode for tool information
    if(self:GetOperation() ~= cWork) then -- Only when different
      self:SetOperation(cWork); self:SetStage(0) end
  end; return cWork, sWork
end

-- Sends the proper ghost stack depth to DRAW_GHOSTS [0;N]
function TOOL:GetGhostsDepth()
  local workmode = self:GetWorkingMode() -- Switches the scenario
  local ghostcnt = self:GetGhostsCount() -- The base control value
  local stackcnt = self:GetStackCount()
  if(workmode == 1) then -- Defined by the stack count otherwise 1
    return math.min(ghostcnt, math.max(stackcnt, 1))
  elseif(workmode == 2) then -- Intersection. Force lower bound here
    return math.min(ghostcnt, 1) -- Force lower bound one otherwise ghosts
  elseif(workmode == 3 or workmode == 5) then -- Track curving interpolation
    return (stackcnt > 0 and math.min(stackcnt, ghostcnt) or ghostcnt)
  elseif(workmode == 4) then local tArr = self:GetFlipOver() -- Read flip array
    return math.min(ghostcnt, (tArr and #tArr or 1)) -- Disable via ghosts count
  end; return 0
end

function TOOL:LogStatus(stTr,vMsg,hdEnt)
  local tLoc = asmlib.GetOpVar("LOG_CONFIG")
  if(tLoc.Max <= 0) then return "Status N/A" end
  local user = self:GetOwner()
  local siAnc  , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local workmode, workname = self:GetWorkingMode()
  local nextx  , nexty   , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw , nextrol = self:GetAngOffsets()
  local hdModel, trModel , trRec   = self:GetModel()
  local hdRec = asmlib.CacheQueryPiece(hdModel)
  if(stTr and stTr.Entity and stTr.Entity:IsValid()) then
    trModel = stTr.Entity:GetModel()
    trRec   = asmlib.CacheQueryPiece(trModel)
  end
  asmlib.LogInstance(vMsg, gtLogs)
  asmlib.LogInstance("  Dumping logs state:", gtLogs)
  asmlib.LogInstance("    LogsMax:         "..asmlib.GetReport(tLoc.Max), gtLogs)
  asmlib.LogInstance("    LogsBrs:         "..asmlib.GetReport(tLoc.Brs), gtLogs)
  asmlib.LogInstance("    LogsCur:         "..asmlib.GetReport(tLoc.Cur), gtLogs)
  asmlib.LogInstance("    MaxProps:        "..asmlib.GetReport(GetConVar("sbox_maxprops"):GetInt()), gtLogs)
  asmlib.LogInstance("    MaxTrack:        "..asmlib.GetReport(GetConVar("sbox_max"..gsLimitName):GetInt()), gtLogs)
  asmlib.LogInstance("  Dumping player keys:", gtLogs)
  asmlib.LogInstance("    Player:          "..asmlib.GetReport(user), gtLogs)
  asmlib.LogInstance("    IN.USE:          "..asmlib.GetReport(user:KeyDown(IN_USE)), gtLogs)
  asmlib.LogInstance("    IN.DUCK:         "..asmlib.GetReport(user:KeyDown(IN_DUCK)), gtLogs)
  asmlib.LogInstance("    IN.SPEED:        "..asmlib.GetReport(user:KeyDown(IN_SPEED)), gtLogs)
  asmlib.LogInstance("    IN.RELOAD:       "..asmlib.GetReport(user:KeyDown(IN_RELOAD)), gtLogs)
  asmlib.LogInstance("    IN.SCORE:        "..asmlib.GetReport(user:KeyDown(IN_SCORE)), gtLogs)
  asmlib.LogInstance("  Dumping trace data state:", gtLogs)
  asmlib.LogInstance("    Trace:           "..asmlib.GetReport(stTr), gtLogs)
  asmlib.LogInstance("    TR.Hit:          "..asmlib.GetReport(stTr and stTr.Hit or gsNoAV), gtLogs)
  asmlib.LogInstance("    TR.HitW:         "..asmlib.GetReport(stTr and stTr.HitWorld or gsNoAV), gtLogs)
  asmlib.LogInstance("    TR.ENT:          "..asmlib.GetReport(stTr and stTr.Entity or gsNoAV), gtLogs)
  asmlib.LogInstance("    TR.Model:        "..asmlib.GetReport((trModel or gsNoAV), (trRec and trRec.Size or gsNoID)), gtLogs)
  asmlib.LogInstance("    TR.File:         "..asmlib.GetReport(trModel and string.GetFileFromFilename(trModel) or gsNoAV), gtLogs)
  asmlib.LogInstance("  Dumping console variables state:", gtLogs)
  asmlib.LogInstance("    HD.Workmode:     "..asmlib.GetReport((workmode or gsNoAV), (workname or gsNoAV)), gtLogs)
  asmlib.LogInstance("    HD.Entity:       "..asmlib.GetReport(hdEnt or gsNoAV), gtLogs)
  asmlib.LogInstance("    HD.Model:        "..asmlib.GetReport((hdModel or gsNoAV), (hdRec and hdRec.Size or gsNoID)), gtLogs)
  asmlib.LogInstance("    HD.File:         "..asmlib.GetReport(hdModel and string.GetFileFromFilename(hdModel) or gsNoAV), gtLogs)
  asmlib.LogInstance("    HD.ModDataBase:  "..asmlib.GetReport(gsModeDataB, asmlib.GetAsmConvar("modedb" ,"STR")), gtLogs)
  asmlib.LogInstance("    HD.Anchor:       "..asmlib.GetReport((anEnt or gsNoAV), siAnc), gtLogs)
  asmlib.LogInstance("    HD.PointID:      "..asmlib.GetReport(pointid, pnextid), gtLogs)
  asmlib.LogInstance("    HD.AngOffsets:   "..asmlib.GetReport(nextx, nexty, nextz), gtLogs)
  asmlib.LogInstance("    HD.PosOffsets:   "..asmlib.GetReport(nextpic, nextyaw, nextrol), gtLogs)
  asmlib.LogInstance("    HD.Weld:         "..asmlib.GetReport(self:GetWeld()), gtLogs)
  asmlib.LogInstance("    HD.Mass:         "..asmlib.GetReport(self:GetMass()), gtLogs)
  asmlib.LogInstance("    HD.Freeze:       "..asmlib.GetReport(self:GetFreeze()), gtLogs)
  asmlib.LogInstance("    HD.YawSnap:      "..asmlib.GetReport(self:GetAngSnap()), gtLogs)
  asmlib.LogInstance("    HD.Gravity:      "..asmlib.GetReport(self:GetGravity()), gtLogs)
  asmlib.LogInstance("    HD.Adviser:      "..asmlib.GetReport(self:GetAdviser()), gtLogs)
  asmlib.LogInstance("    HD.ForceLimit:   "..asmlib.GetReport(self:GetForceLimit()), gtLogs)
  asmlib.LogInstance("    HD.Elevation:    "..asmlib.GetReport(self:GetElevation()), gtLogs)
  asmlib.LogInstance("    HD.ExportDB:     "..asmlib.GetReport(self:GetExportDB()), gtLogs)
  asmlib.LogInstance("    HD.NoCollide:    "..asmlib.GetReport(self:GetNoCollide()), gtLogs)
  asmlib.LogInstance("    HD.NoCollideW:   "..asmlib.GetReport(self:GetNocollideWorld()), gtLogs)
  asmlib.LogInstance("    HD.UpSpAnchor:   "..asmlib.GetReport(self:GetUpSpawnAnchor()), gtLogs)
  asmlib.LogInstance("    HD.SpawnFlat:    "..asmlib.GetReport(self:GetSpawnFlat()), gtLogs)
  asmlib.LogInstance("    HD.IgnoreType:   "..asmlib.GetReport(self:GetIgnoreType()), gtLogs)
  asmlib.LogInstance("    HD.SurfSnap:     "..asmlib.GetReport(self:GetSurfaceSnap()), gtLogs)
  asmlib.LogInstance("    HD.SpawnCen:     "..asmlib.GetReport(self:GetSpawnCenter()), gtLogs)
  asmlib.LogInstance("    HD.AppAngular:   "..asmlib.GetReport(self:GetIsAngularFirst()), gtLogs)
  asmlib.LogInstance("    HD.AppLinear:    "..asmlib.GetReport(self:GetIsLinearFirst()), gtLogs)
  asmlib.LogInstance("    HD.EnCxMenuAll:  "..asmlib.GetReport(self:GetContextMenuAll()), gtLogs)
  asmlib.LogInstance("    HD.PntAssist:    "..asmlib.GetReport(self:GetPointAssist()), gtLogs)
  asmlib.LogInstance("    HD.StackCnt:     "..asmlib.GetReport(self:GetStackCount()), gtLogs)
  asmlib.LogInstance("    HD.GhostsCnt:    "..asmlib.GetReport(self:GetGhostsCount()), gtLogs)
  asmlib.LogInstance("    HD.PhysMeter:    "..asmlib.GetReport(self:GetPhysMeterial()), gtLogs)
  asmlib.LogInstance("    HD.ActRadius:    "..asmlib.GetReport(self:GetActiveRadius()), gtLogs)
  asmlib.LogInstance("    HD.SkinBG:       "..asmlib.GetReport(self:GetBodyGroupSkin()), gtLogs)
  asmlib.LogInstance("    HD.StackAtempt:  "..asmlib.GetReport(self:GetStackAttempts()), gtLogs)
  asmlib.LogInstance("    HD.IgnorePG:     "..asmlib.GetReport(self:GetIgnorePhysgun()), gtLogs)
  asmlib.LogInstance("    HD.TimerMode:    "..asmlib.GetReport(asmlib.GetAsmConvar("timermode","STR")), gtLogs)
  asmlib.LogInstance("    HD.EnableEWire:  "..asmlib.GetReport(asmlib.GetAsmConvar("enwiremod","BUL")), gtLogs)
  asmlib.LogInstance("    HD.EnableMTask:  "..asmlib.GetReport(asmlib.GetAsmConvar("enmultask","BUL")), gtLogs)
  asmlib.LogInstance("    HD.DevelopMode:  "..asmlib.GetReport(asmlib.GetAsmConvar("devmode"  ,"BUL")), gtLogs)
  asmlib.LogInstance("    HD.MaxMass:      "..asmlib.GetReport(asmlib.GetAsmConvar("maxmass"  ,"INT")), gtLogs)
  asmlib.LogInstance("    HD.MaxLinear:    "..asmlib.GetReport(asmlib.GetAsmConvar("maxlinear","INT")), gtLogs)
  asmlib.LogInstance("    HD.MaxForce:     "..asmlib.GetReport(asmlib.GetAsmConvar("maxforce" ,"INT")), gtLogs)
  asmlib.LogInstance("    HD.MaxARadius:   "..asmlib.GetReport(asmlib.GetAsmConvar("maxactrad","INT")), gtLogs)
  asmlib.LogInstance("    HD.MaxStackCnt:  "..asmlib.GetReport(asmlib.GetAsmConvar("maxstcnt" ,"INT")), gtLogs)
  asmlib.LogInstance("    HD.BoundErrMod:  "..asmlib.GetReport(asmlib.GetAsmConvar("bnderrmod","STR")), gtLogs)
  asmlib.LogInstance("    HD.MaxFrequent:  "..asmlib.GetReport(asmlib.GetAsmConvar("maxfruse" ,"INT")), gtLogs)
  asmlib.LogInstance("    HD.MaxTrMargin:  "..asmlib.GetReport(asmlib.GetAsmConvar("maxtrmarg","FLT")), gtLogs)
  asmlib.LogInstance("    HD.MaxSpMargin:  "..asmlib.GetReport(asmlib.GetAsmConvar("maxspmarg","FLT")), gtLogs)
  if(hdEnt and hdEnt:IsValid()) then hdEnt:Remove() end
end

-- Returns true if there are entity ID stored
function TOOL:IsFlipOver()
  return (self:GetFlipOverID():len() > 0)
end

-- Returns an array or entity ID numbers
function TOOL:GetFlipOver(bEnt, bMute)
  local user = self:GetOwner()
  local sID, nF = self:GetFlipOverID(), 0
  if(sID:len() <= 0) then return nil, nF end
  local sYm = asmlib.GetOpVar("OPSYM_SEPARATOR")
  local tF = sYm:Explode(sID); nF = #tF
  for iD = 1, nF do
    tF[iD] = (tonumber(tF[iD]) or 0)
    if(bEnt) then
      local eID = Entity(tF[iD])
      if(eID and eID:IsValid()) then
        local bID = (not asmlib.IsOther(eID))
        local bMR = eID:GetNWBool(gsToolPrefL.."flipover")
        if(bID and bMR) then tF[iD] = eID else tF[iD] = nil
          if(SERVER and not bMute) then
            asmlib.LogInstance("Flip over mismatch ID "..asmlib.GetReport(iD, eID, bID, bMR), gtLogs)
            asmlib.Notify(user, "GENERIC", "Flip over mismatch entity %s at ID %s !", tF[iD], iD)
          end
        end
      end
    end
  end -- Convert to number as other methods use the number data
  return tF, nF -- Return the table and elements count
end

function TOOL:SetFlipOver(trEnt, bBrs)
  if(CLIENT) then return nil end
  if(asmlib.IsOther(trEnt)) then return nil end
  local user  = self:GetOwner()
  local trCss = trEnt:GetClass()
  local trMoc = trEnt:GetModel()
  if(not asmlib.IsHere(trMoc)) then return nil end
  local trRec = asmlib.CacheQueryPiece(trMoc)
  if(not asmlib.IsHere(trRec)) then
    asmlib.Notify(user, "ERROR", "Flip over %s not a piece %s !", trCss, trMoc)
    asmlib.LogInstance("Flip over not piece "..asmlib.GetReport(trCss,trMoc),gtLogs)
    return nil -- Just disable overall flipping for the other models
  end
  if(bBrs) then return trEnt else
    local sYm = asmlib.GetOpVar("OPSYM_SEPARATOR")
    local iID, bBr = trEnt:EntIndex(), false
    local tF, nF = self:GetFlipOver()
    if(nF <= 0) then tF = {} -- Create table
    else -- Remove entity from the convar
      for iD = 1, nF do nID = tF[iD]
        if(nID == iID) then bBr = true
          local eID = Entity(nID)
          asmlib.UpdateColor(eID, "flipover", "fo", false)
          table.remove(tF, iD); break
        end
      end
    end
    if(not bBr) then table.insert(tF, tostring(iID))
      asmlib.UpdateColor(trEnt, "flipover", "fo", true)
    end
    asmlib.SetAsmConvar(user, "flipoverid", table.concat(tF, sYm))
  end
end

function TOOL:ClearFlipOver(bMute)
  local user = self:GetOwner()
  local tF, nF = self:GetFlipOver()
  for iD = 1, nF do local eID = Entity(tF[iD])
    asmlib.UpdateColor(eID, "flipover", "fo", false)
  end; asmlib.SetAsmConvar(user, "flipoverid", "")
  if(not bMute) then
    asmlib.LogInstance("Flip over cleared", gtLogs)
    asmlib.Notify(user, "CLEANUP", "Flip over cleared !")
  end -- Make sure to delete the relation on both client and server
end

function TOOL:GetFlipOverOrigin(stTrace, bPnt)
  local trEnt, trHit = stTrace.Entity, stTrace.HitNormal
  local wOver, wNorm = Vector(), Vector()
  if(not (trEnt and trEnt:IsValid())) then
    wOver:Set(stTrace.HitPos); wNorm:Set(trHit)
    return wOver, wNorm
  end
  wOver:Set(trEnt:LocalToWorld(trEnt:OBBCenter())); wNorm:Set(trHit)
  if(bPnt) then
    local wOrig, wAucs = Vector(), Angle()
    local model, trMod = self:GetModel(), trEnt:GetModel()
    local trID, trMin, trPOA, trRec = asmlib.GetEntityHitID(trEnt, stTrace.HitPos, true)
    if(model == trMod and trRec and (tonumber(trRec.Size) or 0) > 1) then
      local pointid, pnextid = self:GetPointID()
      local vXX, vO1, vO2 = asmlib.IntersectRayModel(trMod, pointid, pnextid)
      if(vXX) then
        wOrig:SetUnpacked(trPOA.O:Get())
        wOrig:Set(trEnt:LocalToWorld(wOrig))
        wOver:Set(trEnt:LocalToWorld(vXX))
        vO1:Set(trEnt:LocalToWorld(vO1))
        vO2:Set(trEnt:LocalToWorld(vO2))
        wAucs:SetUnpacked(trPOA.A:Get())
        wAucs:Set(trEnt:LocalToWorldAngles(wAucs))
        wNorm:Set(wAucs:Up())
        return wOver, wNorm, wOrig, vO1, vO2
      end
    else
      if(trPOA) then
        wOrig:SetUnpacked(trPOA.O:Get())
        wOrig:Set(trEnt:LocalToWorld(wOrig))
        wAucs:SetUnpacked(trPOA.A:Get())
        wAucs:Set(trEnt:LocalToWorldAngles(wAucs))
        wNorm:Set(wAucs:Up())
        return wOver, wNorm, wOrig
      end
    end
  end
  return wOver, wNorm
end

function TOOL:SelectModel(sModel)
  local trRec = asmlib.CacheQueryPiece(sModel); if(not asmlib.IsHere(trRec)) then
    self:LogStatus(stTrace,"Model not piece "..asmlib.GetReport(sModel)); return false end
  local user, namo = self:GetOwner(), string.GetFileFromFilename(sModel)
  local pointid, pnextid = self:GetPointID()
        pointid, pnextid = asmlib.SnapReview(pointid, pnextid, trRec.Size)
  asmlib.SetAsmConvar(user,"pointid", pointid)
  asmlib.SetAsmConvar(user,"pnextid", pnextid)
  asmlib.SetAsmConvar(user, "model" , sModel)
  asmlib.Notify(user, "UNDO", "Model selected: %s !", namo)
  asmlib.LogInstance("Success "..asmlib.GetReport(namo,sModel),gtLogs); return true
end

--[[
 * Uses heuristics to provide the best suitable location the
 * curve note closest location can be updated with. Three cases:
 * iD    > Curve node index to be updated
 * vPnt  > The new location to update the node with
 * bMute > Mute mode. Used to disable server status messages
 * Returns multiple values:
 * V > Curve node calculated heuristics location vector
 * N > The amount of neighbor nodes that are active rays
 *     (2) Both neighbors are active points. Intersect their active rays
 *     (1) Only one node is an active point. Project on its active ray
 *     (0) None of the neighbors are active points. Project on line bisector
]]--
function TOOL:GetCurveNodeActive(iD, vPnt, bMute)
  local user = self:GetOwner()
  local tC  = asmlib.GetCacheCurve(user)
  if(iD <= 1) then -- Cannot chose first ID to intersect
    if(not bMute) then asmlib.Notify(user, "ERROR", "Node point uses prev !") end
    return nil -- The chosen node ID does not meet requirements
  end
  if(iD >= tC.Size) then -- Cannot chose last ID to intersect
    if(not bMute) then asmlib.Notify(user, "ERROR", "Node point uses next !") end
    return nil -- The chosen node ID does not meet requirements
  end
  local iS, iE = (iD - 1), (iD + 1) -- Previous and next node indexes
  local tS, tE = tC.Rays[iS], tC.Rays[iE] -- Previous and next node rays
  if(tS[3] and tE[3]) then
    local sD, eD = tS[2]:Forward(), tE[2]:Forward()
    local f1, f2, x1, x2, xx = asmlib.IntersectRayPair(tS[1], sD, tE[1], eD)
    return xx, 2 -- Both are active pints and return ray intersection
  else
    if(tS[3]) then -- Previous is an active point
      if(not bMute) then asmlib.Notify(user, "HINT", "Node projection prev !") end
      local mr, nr, xr = asmlib.ProjectRay(tS[1], tS[2]:Forward(), vPnt); return xr, 1
    elseif(tE[3]) then -- Next is an active point
      if(not bMute) then asmlib.Notify(user, "HINT", "Node projection next !") end
      local mr, nr, xr = asmlib.ProjectRay(tE[1], tE[2]:Forward(), vPnt); return xr, 1
    else -- None of the previous and next nodes are active points
      if(not bMute) then asmlib.Notify(user, "HINT", "Node project bisector !") end
      local vS, vE = tC.Node[iS], tC.Node[iE] -- Read start and finish nodes
      local vD = Vector(vE); vD:Sub(vS) -- Direction from start to finish
      local vO = Vector(vD); vO:Mul(0.5); vO:Add(vS) -- Bisector origin
      local mr, nr, xr = asmlib.ProjectRay(vS, vD, vPnt) -- Projection point
            vD:Set(vPnt); vD:Sub(xr) -- Bisector direction vector
      local ms, ns, xs = asmlib.ProjectRay(vO, vD, vPnt); return xs, 0
    end
  end
end

--[[
 * Generates curve transform data structure
 * It is used to create data for the curve nodes
 * stTrace > Trace structure being used for generation
 * bPnt    > Whenever the generation is from active point
]]
function TOOL:GetCurveTransform(stTrace, bPnt)
  if(not stTrace) then
    asmlib.LogInstance("Trace missing", gtLogs); return nil end
  if(not stTrace.Hit) then
    asmlib.LogInstance("Trace not hit", gtLogs); return nil end
  local user, nT = self:GetOwner(), 0
  local angsnap  = self:GetAngSnap()
  local elevpnt  = self:GetElevation()
  local surfsnap = self:GetSurfaceSnap()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  local eEnt, vNrm, tData = stTrace.Entity, stTrace.HitNormal, {}
  tData.Org = Vector() -- Curve node interpolation origin
  tData.Ang = Angle()  -- Curve node interpolation angle
  tData.Orw = Vector() -- Point POA origin converted to world
  tData.Anw = Angle()  -- Point POA angle converted to world
  tData.Hit = Vector() -- Usually the trace hit position
  tData.Ang:Set(asmlib.GetNormalAngle(user, stTrace, surfsnap, angsnap))
  tData.Hit:Set(stTrace.HitPos); tData.Org:Add(tData.Hit)
  if(bPnt and eEnt and eEnt:IsValid()) then
    local oID, oMin, oPOA, oRec = asmlib.GetEntityHitID(eEnt, tData.Hit, true)
    if(oID and oMin and oPOA and oRec) then
      tData.Org:SetUnpacked(oPOA.O:Get())
      tData.Org:Rotate(eEnt:GetAngles()); tData.Org:Add(eEnt:GetPos())
      tData.Ang:SetUnpacked(oPOA.A:Get())
      tData.Ang:Set(eEnt:LocalToWorldAngles(tData.Ang))
      tData.Orw:Set(tData.Org); tData.Anw:Set(tData.Ang) -- Transform of POA
      tData.ID  = oID;  tData.Min = oMin -- Point ID and minimum distance
      tData.POA = oPOA; tData.Rec = oRec -- POA and cache record
      local trRz, trDt = asmlib.GetTraceEntityPoint(eEnt, oID, 30000, asmlib.GetOpVar("VEC_DW"))
      if(trRz and trRz.Hit) then
        nT = (trDt.length * trRz.Fraction - elevpnt)
        asmlib.SetAsmConvar(user, "nextz", nT)
      end
    end -- Use the track piece active end to create relative curve node
  else -- Offset the curve node when it is not driven by an active point
    tData.Org:Add(vNrm * elevpnt) -- Apply model active point elevation
  end -- Apply the positional and angular offsets to the return value
  tData.Org:Add(tData.Ang:Up()      * (nextz - nT))
  tData.Org:Add(tData.Ang:Right()   * nexty)
  tData.Org:Add(tData.Ang:Forward() * nextx)
  tData.Ang:RotateAroundAxis(tData.Ang:Up()     ,-nextyaw)
  tData.Ang:RotateAroundAxis(tData.Ang:Right()  , nextpic)
  tData.Ang:RotateAroundAxis(tData.Ang:Forward(), nextrol)
  return tData
end

--[[
 * Used to apply super-elevation on the previous node
 * according to the location of the next node placed
 * Must be run BEFORE inserting the new node placed
 * tC    > Curve data stricture with the normal modified
 * tData > Reference to the node being inserted
]]
function TOOL:ApplySuperElevation(tC, tData, iD)
  if(not tData) then -- The node being managed
    asmlib.LogInstance("Data missing", gtLogs); return 0 end
  if(not tC) then -- The curve containing all nodes
    asmlib.LogInstance("Curve missing", gtLogs); return 0 end
  local spnflat = self:GetSpawnFlat()
  local crvsuprev = self:GetSuperElevation()
  if(not (crvsuprev ~= 0 and not spnflat)) then
    asmlib.LogInstance("Auto roll disabled", gtLogs); return 0 end
  local nS = asmlib.GetOpVar("FULL_SLOPEDG")
  local iN = math.floor(math.max(tonumber(iD) or 0, 0))
  if(iN > 0) then
    local tO, tN, tR = tC.Node, tC.Norm, tC.Rays
    local vL, vP = tO[iN + 1], tO[iN - 1]
    if(not (vL and vP)) then
      asmlib.LogInstance("Not internal point "..asmlib.GetReport(iN), gtLogs); return 0 end
    local vD = Vector(vL); vD:Sub(tData.Org); vD:Normalize()
    local vF = Vector(vL); vF:Sub(vP); vF:Normalize()
    local aN = vF:AngleEx(tR[iN][2]:Up())
    local nP = (crvsuprev * nS) * vD:Dot(aN:Right()); aN:RotateAroundAxis(vF, nP)
    local vN = aN:Up(); tN[iN]:Set(vN); return iN, vN
  else
    if(not (tC.Size and tC.Size >= 2)) then
      asmlib.LogInstance("Two vertices needed "..asmlib.GetReport(tC.Size), gtLogs); return 0 end
    local tO, tN, tR, iN = tC.Node, tC.Norm, tC.Rays, tC.Size
    local vL, vP = tO[iN], tO[iN - 1]
    local vD = Vector(tData.Org); vD:Sub(vL); vD:Normalize()
    local vF = Vector(tData.Org); vF:Sub(vP); vF:Normalize()
    local aN = vF:AngleEx(tR[iN][2]:Up())
    local nP = (crvsuprev * nS) * vD:Dot(aN:Right()); aN:RotateAroundAxis(vF, nP)
    local vN = aN:Up(); tN[iN]:Set(vN); return iN, vN
  end
end

function TOOL:CheckCurveNode(vPos, iID)
  local user = self:GetOwner()
  local tC = asmlib.GetCacheCurve(user); if(not tC) then
    asmlib.LogInstance("Curve missing", gtLogs); return nil end
  local iID = math.floor(math.max(tonumber(iID) or 0, 0))
  local nM, sN = asmlib.GetOpVar("CURVE_NODEMR"), user:Nick()
  local iPr, iNx = (iID - 1), (iID + 1)
  local vPr, vNx = tC.Node[iPr], tC.Node[iNx]
  if(vPr and vPr:DistToSqr(vPos) < nM) then
    asmlib.Notify(user, "ERROR", "Former node %s too close %s !", sN, iPr)
    asmlib.LogInstance("Former close ", asmlib.GetReport(sN, iPr), gtLogs); return nil
  end
  if(vNx and vNx:DistToSqr(vPos) < nM) then
    asmlib.Notify(user, "ERROR", "Coming node %s too close %s !", sN, iNx)
    asmlib.LogInstance("Coming close "..asmlib.GetReport(sN, iNx), gtLogs); return nil
  end; return tC
end

--[[
 * Updates a curve node on the server and sends a message to update the client
 * stTrace > The trace structure to register as a curve node
 * bPnt    > Enable to try extracting the origin from a piece POA
 * iD      > Node index to remove. Defaults to the last node on the stack
 * bMute   > Enable this flag to mute (skip sending) the net* messages
]]
function TOOL:CurveInsert(stTrace, bPnt, iD, bMute)
  local user, tU = self:GetOwner(), {}
  local iD = math.floor(math.max(tonumber(iD) or 0, 0))
  local tData = self:GetCurveTransform(stTrace, bPnt); if(not tData) then
    asmlib.LogInstance("Transform missing", gtLogs); return nil end
  local tC = asmlib.GetCacheCurve(user); if(not tC) then
    asmlib.LogInstance("Curve missing", gtLogs); return nil end
  local tC = self:CheckCurveNode(tData.Org, tC.Size + 1); if(not tC) then
    asmlib.LogInstance("Curve node too close", gtLogs); return nil end
  local iN, vN = self:ApplySuperElevation(tC, tData, iD)
  local iC = ((iD > 0 and iD <= tC.Size) and iD or 0)
  if(iC > 0) then local iM, iP, tN = (iC - 1), (iC + 1), tC.Node
    -- We have to insert at the middle of the stack and node is selected
    local vDO = Vector(tData.Org); vDO:Sub(tN[iC]) -- Calculate origin
    local vDP; if(tN[iP]) then vDP = Vector(tN[iP]); vDP:Sub(tN[iC]) end
    local vDM; if(tN[iM]) then vDM = Vector(tN[iM]); vDM:Sub(tN[iC]) end
    if(vDM and vDP) then -- Insert in the middle. Use the next point not to twist the curve
      if(vDO:Dot(vDP) > 0) then iC = iP else iC = iC end
    elseif(vDP and not vDM) then -- The insert is at the beginning (stack bottom)
      if(vDO:Dot(vDP) > 0) then iC = iC + 1 else iC = 1 end
    elseif(vDM and not vDP) then -- The insert is at the end (stack top)
      if(vDO:Dot(vDM) > 0) then iC = tC.Size else iC = 0 end
    else -- In case we need to insert and only one node is available
      iC = 0 -- The node is alpha and omega at once
    end -- Node selection insert has been processed. Transfer to client
  else iC = 0 end -- Client insertion ID is not provided
  tU[1]  = tData.Org -- Current node location in the stack      ( Node )
  tU[2]  = tData.Ang:Up() -- Current stack node normal vector   ( Norm )
  tU[3]  = tData.Hit -- Current node base location in the stack ( Base )
  tU[4]  = tData.Org -- Player trace location curve data        ( RayO )
  tU[5]  = tData.Ang -- Player trace angle curve data           ( RayA )
  tU[6]  = (tData.POA ~= nil) -- Player hits POA location       ( RayL )
  tU[7]  = iC        -- The index to change at when requested   (  ID  )
  tU[8]  = iN        -- The super-elevation index normal vector (  IL  )
  tU[9]  = vN        -- The super-elevation vector applied      ( Lean )
  local bS, sR = asmlib.DoAction("INSERT_CURVE_NODE", user, tU, bMute); if(not bS) then
    asmlib.LogInstance("Insert curve error "..asmlib.GetReport(user, sR), gtLogs) end
  return tC -- Returns the updated curve nodes table
end

--[[
 * Removes a node from the server and sends a message to update the client
 * iD    > Node index to remove. Defaults to the last node on the stack
 *         It will remove the last node on (nil, N, N+K) provided
 * bMute > Enable this flag to mute (skip sending) the net* messages
]]
function TOOL:CurveRemove(iD, bMute)
  local user = self:GetOwner()
  local tC = asmlib.GetCacheCurve(user); if(not tC) then
    asmlib.LogInstance("Curve missing", gtLogs); return nil end
  if(tC.Size <= 0) then -- There are no nodes on the stack
    asmlib.LogInstance("Curve empty", gtLogs); return nil end
  local iD = math.floor(math.max(tonumber(iD) or 0, 0)) -- User pick
  local iC = ((iD > 0 and iD < tC.Size) and iD or 0) -- Remove at the end
  local bS, sR = asmlib.DoAction("REMOVE_CURVE_NODE", user, iC, bMute); if(not bS) then
    asmlib.LogInstance("Remove curve error "..asmlib.GetReport(user, iC, sR), gtLogs) end
  return tC -- Updated curve nodes table
end

--[[
 * Updates a curve node on the server and sends a message to update the client
 * stTrace > The trace structure to register as a curve node
 * bPnt    > Enable to try extracting the origin from a piece POA
 * bMute   > Enable this flag to mute (skip sending) the net* messages
]]
function TOOL:CurveUpdate(stTrace, bPnt, bMute)
  local user, tU  = self:GetOwner(), {}
  local tData = self:GetCurveTransform(stTrace, bPnt); if(not tData) then
    asmlib.LogInstance("Transform missing", gtLogs); return nil end
  local tC = asmlib.GetCacheCurve(user); if(not tC) then
    asmlib.LogInstance("Curve missing", gtLogs); return nil end
  if(not (tC.Size and tC.Size > 0)) then
    asmlib.Notify(user, "ERROR", "Populate nodes first !")
    asmlib.LogInstance("Nodes missing", gtLogs); return nil
  end
  local nrA = self:GetActiveRadius()
  local mD, mL = asmlib.GetNearest(tData.Hit, tC.Base)
  local bTr = (mD and mD > 0 and mL < nrA^2)
  if(bTr) then
    if(not bPnt) then
      local tN, vF = tC.Node, nil
      local elevpnt  = self:GetElevation()
      local vB, tR = tC.Base[mD], tC.Rays[mD]
      local vN, vD = tC.Norm[mD], tC.Node[mD]
      local vO = Vector(); vO:Set(vD); vO:Sub(vB)
      local nextx, nexty, nextz = vO:Unpack()
      asmlib.SetAsmConvar(oPly,"nextx", nextx)
      asmlib.SetAsmConvar(oPly,"nexty", nextx)
      asmlib.SetAsmConvar(oPly,"nextz", nextz - elevpnt)
      if(not (tN[mD-1] and tN[mD+1])) then vF = tR[2]:Forward() else
        vF = Vector(tN[mD+1]); vF:Sub(tN[mD-1]); vF:Normalize() end
      local aO = vF:AngleEx(vN)
      local nextpic, nextyaw, nextrol = aO:Unpack()
      asmlib.SetAsmConvar(oPly,"nextpic", nextpic)
      asmlib.SetAsmConvar(oPly,"nextyaw", nextyaw)
      asmlib.SetAsmConvar(oPly,"nextrol", nextrol)
      return tC
    end
  end
  local tC = self:CheckCurveNode(tData.Org, mD); if(not tC) then
    asmlib.LogInstance("Curve node too close", gtLogs); return nil end
  tC.Node[mD]:Set(tData.Org)
  tC.Norm[mD]:Set(tData.Ang:Up())
  tC.Base[mD]:Set(tData.Hit)
  tC.Rays[mD][1]:Set(tData.Org)
  tC.Rays[mD][2]:Set(tData.Ang)
  tC.Rays[mD][3] = (tData.POA ~= nil)
  -- Adjust node according to intersection
  if(bPnt and not tData.POA and not bTr) then
    local xx = self:GetCurveNodeActive(mD, tData.Org)
    if(xx) then
      tC.Node[mD]:Set(xx)
      tC.Norm[mD]:Set(tC.Norm[mD - 1])
      tC.Norm[mD]:Add(tC.Norm[mD + 1])
      tC.Norm[mD]:Normalize()
    end
  end
  if(not bTr) then -- Try to apply the new super-elevation
    local iN, vN = self:ApplySuperElevation(tC, tData, mD)
    if(iN > 0) then tC.Norm[mD]:Set(vN) end
  end
  tU[1] = tC.Node[mD]    -- Current node location in the stack      ( Node )
  tU[2] = tC.Norm[mD]    -- Current stack node normal vector        ( Norm )
  tU[3] = tC.Base[mD]    -- Current node base location in the stack ( Base )
  tU[4] = tC.Rays[mD][1] -- Player trace location curve data        ( RayO )
  tU[5] = tC.Rays[mD][2] -- Player trace angle curve data           ( RayA )
  tU[6] = tC.Rays[mD][3] -- Player hits POA location                ( RayL )
  tU[7] = mD             -- The index to change at when requested   (  ID  )
  local bS, sR = asmlib.DoAction("UPDATE_CURVE_NODE", user, tU, bMute); if(not bS) then
    asmlib.LogInstance("Remove curve error "..asmlib.GetReport(user, sR), gtLogs) end
  return tC -- Returns the updated curve nodes table
end

--[[
 * Clears all the curve nodes on the server and sends to the client to do the same
 * bMute > Enable this flag to mute (skip sending) the net* messages
]]
function TOOL:CurveClear(bMute)
  local user, sID = self:GetOwner()
  local tC = asmlib.GetCacheCurve(user); if(not tC) then
    asmlib.LogInstance("Curve missing", gtLogs); return nil end
  -- Show how many nodes are deleted then delete them
  local bS, sR = asmlib.DoAction("CLEAR_CURVE_NODE", user, bMute); if(not bS) then
    asmlib.LogInstance("Clear curve error "..asmlib.GetReport(user, sR), gtLogs); return nil end
  return tC -- Returns the updated curve nodes table
end

--[[
 * Validates curve client parameters and
 * initializes the curve structure for the holder model
]]
function TOOL:CurveCheck(bMute)
  local user = self:GetOwner()
  local model = self:GetModel()
  local fnmodel = string.GetFileFromFilename(model)
  local pointid, pnextid = self:GetPointID()
  local nEps = asmlib.GetOpVar("EPSILON_ZERO")
  -- Check the model in the database
  local hdRec = asmlib.CacheQueryPiece(model)
  if(not asmlib.IsHere(hdRec)) then
    if(not bMute) then
      asmlib.Notify(user, "ERROR", "Holder model not piece: %s !", fnmodel)
      asmlib.LogInstance("Holder model not piece: "..fnmodel, gtLogs)
    end; return nil
  end -- Disable for stack having less than two vertices
  local tC = asmlib.GetCacheCurve(user)
  if(tC.Size and tC.Size < 2) then
    if(not bMute) then
      asmlib.Notify(user, "ERROR", "Two vertices are needed !")
      asmlib.LogInstance("Two vertices are needed: "..fnmodel, gtLogs)
    end; return nil
  end -- Disable for single active end track segments
  if(hdRec.Size <= 1) then
    if(not bMute) then
      asmlib.Notify(user, "ERROR", "Segmented track needed: %s !", fnmodel)
      asmlib.LogInstance("Segmented track needed: "..fnmodel, gtLogs)
    end; return nil
  end -- Disable for missing start track segments
  local sPOA = asmlib.LocatePOA(hdRec, pointid)
  if(not sPOA) then
    if(not bMute) then
      asmlib.Notify(user, "ERROR", "Segment start missing: %s !", fnmodel)
      asmlib.LogInstance("Segment start missing: "..fnmodel, gtLogs)
    end; return nil
  end -- Disable for missing end track segments
  local ePOA = asmlib.LocatePOA(hdRec, pnextid)
  if(not ePOA) then
    if(not bMute) then
      asmlib.Notify(user, "ERROR", "Segment end missing: %s !", fnmodel)
      asmlib.LogInstance("Segment end missing: "..fnmodel, gtLogs)
    end; return nil
  end -- Read the active point and check piece shape
  local sO, sA = tC.Info.Pos[1], tC.Info.Ang[1]
        sO:SetUnpacked(sPOA.O:Get())
        sA:SetUnpacked(sPOA.A:Get())
  -- Read the next point to check the piece shape
  local eO, eA = tC.Info.Pos[2], tC.Info.Ang[2]
        eO:SetUnpacked(ePOA.O:Get())
        eA:SetUnpacked(ePOA.A:Get())
  -- Disable for active points with zero distance
  local nD = eO:DistToSqr(sO)
  if(nD <= nEps) then
    if(not bMute) then
      asmlib.Notify(user, "ERROR", "Segment is too tiny: %s !", fnmodel)
      asmlib.LogInstance("Segment is too tiny: "..fnmodel, gtLogs)
    end; return nil
  end -- Disable for non-straight track segments
  if(sA:Forward():Cross(eA:Forward()):LengthSqr() >= nEps) then
    if(not bMute) then
      asmlib.Notify(user, "ERROR", "Segment is curvy: %s !", fnmodel)
      asmlib.LogInstance("Segment is curvy: "..fnmodel, gtLogs)
    end; return nil
  end -- Disable for 180 curve track segments
  if(sA:Forward():Dot(eA:Forward()) >= nEps) then
    if(not bMute) then
      asmlib.Notify(user, "ERROR", "Segment is overturn: %s !", fnmodel)
      asmlib.LogInstance("Segment is overturn: "..fnmodel, gtLogs)
    end; return nil
  end -- Disable for ramp track segments
  if(sA:Forward():Dot((sO - eO):GetNormalized()) < (1 - nEps)) then
    if(not bMute) then
      asmlib.Notify(user, "ERROR", "Segment is a ramp: %s !", fnmodel)
      asmlib.LogInstance("Segment is a ramp: "..fnmodel, gtLogs)
    end; return nil
  end; return tC, math.sqrt(nD) -- Returns the updated curve nodes table
end

function TOOL:NormalSpawn(stTrace, oPly)
  local trEnt      = stTrace.Entity
  local mass       = self:GetMass()
  local model      = self:GetModel()
  local surfsnap   = self:GetSurfaceSnap()
  local spawncn    = self:GetSpawnCenter()
  local ignphysgn  = self:GetIgnorePhysgun()
  local bgskids    = self:GetBodyGroupSkin()
  local bnderrmod  = self:GetBoundErrorMode()
  local physmater  = self:GetPhysMeterial()
  local freeze     = self:GetFreeze()
  local angsnap    = self:GetAngSnap()
  local gravity    = self:GetGravity()
  local nocollide  = self:GetNoCollide()
  local nocollidew = self:GetNocollideWorld()
  local weld       = self:GetWeld()
  local forcelim   = self:GetForceLimit()
  local elevpnt    = self:GetElevation()
  local upspanchor = self:GetUpSpawnAnchor()
  local fnmodel    = string.GetFileFromFilename(model)
  local siAnc  , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  local vPos = Vector(stTrace.HitNormal); vPos:Mul(elevpnt); vPos:Add(stTrace.HitPos)
  local aAng = asmlib.GetNormalAngle(oPly,stTrace,surfsnap,angsnap)
  if(spawncn) then  -- Spawn on mass center
    aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
    aAng:RotateAroundAxis(aAng:Right()  , nextpic)
    aAng:RotateAroundAxis(aAng:Forward(), nextrol)
  else
    local stSpawn = asmlib.GetNormalSpawn(oPly,vPos,aAng,model,
                      pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(not stSpawn) then -- Make sure it persists to set it afterwards
      self:LogStatus(stTrace,"(Spawn) Cannot obtain spawn data"); return false end
    vPos:Set(stSpawn.SPos); aAng:Set(stSpawn.SAng)
  end
  -- Update the anchor entity automatically when enabled
  if(upspanchor) then -- Read the auto-update flag
    if(anEnt ~= trEnt) then -- When the anchor needs to be changed
      if(not self:SetAnchor(stTrace)) then -- Update anchor with current trace
        self:LogStatus(stTrace,"(Spawn) Anchor fail"); return false
      end; siAnc, anEnt = self:GetAnchor() -- Export anchor to locals
    end -- This needs to be triggered only when the user is not meshing

    if(anEnt) then -- Check if there is an anchor available
      if(not anEnt:IsWorld()) then -- Check all other cases that are not world
        if(not (anEnt and anEnt:IsValid()) and
               (trEnt and trEnt:IsValid())) then anEnt = trEnt end
      end -- When anchor is not the world and it is invalid use the trace
    else -- When the anchor is missing we just use the trace entity
      if(trEnt and trEnt:IsValid()) then anEnt = trEnt end -- Switch-a-roo
    end -- If there is something wrong with the anchor entity use the trace
  end -- When the flag is not enabled must not automatically update anchor
  local ePiece = asmlib.NewPiece(oPly,model,vPos,aAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
  if(ePiece) then
    if(spawncn) then -- Adjust the position when created correctly
      asmlib.SetCenter(ePiece, vPos, aAng, nextx, -nexty, nextz)
    end
    if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
      self:LogStatus(stTrace,"(Spawn) Failed to apply physical settings",ePiece); return false end
    if(not asmlib.ApplyPhysicalAnchor(ePiece,anEnt,weld,nocollide,nocollidew,forcelim)) then
      self:LogStatus(stTrace,"(Spawn) Failed to apply physical anchor",ePiece); return false end
    asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( Spawn )")
    asmlib.UndoAddEntity(ePiece)
    asmlib.UndoFinish(oPly)
    asmlib.LogInstance("(Spawn) Success",gtLogs); return true
  end
  self:LogStatus(stTrace,"(Spawn) Failed to create"); return false
end

function TOOL:LeftClick(stTrace)
  if(CLIENT) then -- Do not do stuff when CLIENT attempts something
    asmlib.LogInstance("Working on client",gtLogs); return true end
  if(not asmlib.IsInit()) then -- Do not do stuff when library is not initialized
    asmlib.LogInstance("Library error",gtLogs); return false end
  if(not stTrace) then -- Do not do stuff when there is no trace
    asmlib.LogInstance("Trace missing",gtLogs); return false end
  if(not stTrace.Hit) then -- Do not do stuff when there is nothing hit
    asmlib.LogInstance("Trace not hit",gtLogs); return false end
  local poQueue    = asmlib.GetQueue("THINK")
  local user       = self:GetOwner()
  local trEnt      = stTrace.Entity
  local weld       = self:GetWeld()
  local mass       = self:GetMass()
  local model      = self:GetModel()
  local freeze     = self:GetFreeze()
  local angsnap    = self:GetAngSnap()
  local gravity    = self:GetGravity()
  local spawnrate  = self:GetSpawnRate()
  local elevpnt    = self:GetElevation()
  local nocollide  = self:GetNoCollide()
  local spnflat    = self:GetSpawnFlat()
  local stackcnt   = self:GetStackCount()
  local igntype    = self:GetIgnoreType()
  local forcelim   = self:GetForceLimit()
  local spawncn    = self:GetSpawnCenter()
  local surfsnap   = self:GetSurfaceSnap()
  local physmater  = self:GetPhysMeterial()
  local actrad     = self:GetActiveRadius()
  local bgskids    = self:GetBodyGroupSkin()
  local maxstatts  = self:GetStackAttempts()
  local ignphysgn  = self:GetIgnorePhysgun()
  local applinfst  = self:GetIsLinearFirst()
  local bnderrmod  = self:GetBoundErrorMode()
  local appangfst  = self:GetIsAngularFirst()
  local nocollidew = self:GetNocollideWorld()
  local fnmodel    = string.GetFileFromFilename(model)
  local siAnc  , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local workmode, workname = self:GetWorkingMode()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()

  if(workmode == 3 or workmode == 5) then
    if(poQueue:IsBusy(user)) then asmlib.Notify(user, "ERROR", "Server busy !"); return true end
    local hdRec = asmlib.CacheQueryPiece(model); if(not asmlib.IsHere(hdRec)) then
      self:LogStatus(stTrace,"(Hold) Holder model not piece"); return false end
    local tC, nD = self:CurveCheck(); if(not asmlib.IsHere(tC)) then
      self:LogStatus(stTrace,"(Curve) Validation fail"); return nil end
    local fInt = asmlib.GetOpVar("FORM_INTEGER")
    local curvefact, curvsmple = self:GetCurveFactor()  , self:GetCurveSamples()
    local crvturnlm, crvleanlm = self:GetCurvatureTurn(), self:GetCurvatureLean()
    if(workmode == 3) then
      asmlib.CalculateRomCurve(user, curvsmple, curvefact)
    elseif(workmode == 5) then
      asmlib.CalculateBezierCurve(user, curvsmple)
    end
    for iD = 1, (tC.CSize - 1) do asmlib.UpdateCurveSnap(user, iD, nD) end
    poQueue:Attach(user, {
      stard = 1,
      stark = 1,
      itrys = 0,
      istck = 0,
      wname = workname:lower():gsub("^%l", string.upper),
      imake = 0,
      spawn = {},
      srate = spawnrate
    }, function(oPly, oArg)
      for iD = oArg.stard, tC.SSize do tS = tC.Snap[iD]
        for iK = oArg.stark, tS.Size do local tV, ePiece = tS[iK], nil
          oArg.spawn = asmlib.GetNormalSpawn(oPly, tV[1], tV[2], model, pointid, 0, 0, 0, 0, 0, 0, oArg.spawn)
          if(not oArg.spawn) then -- Make sure it persists to set it afterwards
            self:LogStatus(stTrace, "Cannot obtain spawn data "..asmlib.GetReport(oArg.wname, sItr)); return false end
          if(crvturnlm > 0 or crvleanlm > 0) then local nF, nU = asmlib.GetTurningFactor(oPly, tS, iK)
            if(nF and nF < crvturnlm) then
              oArg.mundo = asmlib.GetReport(iD, asmlib.GetNearest(tV[1], tC.Node), ("%4.3f"):format(nF))
              asmlib.Notify(oPly, "ERROR", "%s: excessive turn at %s !", oArg.wname, oArg.mundo)
              self:LogStatus(stTrace,"Turn excessive "..asmlib.GetReport(oArg.wname, oArg.mundo)); return false
            end
            if(nU and nU < crvleanlm) then
              oArg.mundo = asmlib.GetReport(iD, asmlib.GetNearest(tV[1], tC.Node),("%4.3f"):format(nU))
              asmlib.Notify(oPly, "ERROR", "%s: excessive lean at %s !", oArg.wname, oArg.mundo)
              self:LogStatus(stTrace,"Lean excessive "..asmlib.GetReport(oArg.wname, oArg.mundo)); return false
            end
          end
          while(oArg.itrys < maxstatts and not ePiece) do oArg.itrys = (oArg.itrys + 1)
            ePiece = asmlib.NewPiece(oPly,model,oArg.spawn.SPos,oArg.spawn.SAng,mass,bgskids,conPalette:Select("w"),bnderrmod) end
          if(stackcnt > 0) then if(oArg.istck < stackcnt) then oArg.istck = (oArg.istck + 1) else ePiece:Remove(); ePiece = nil end end
          oArg.imake = (oArg.imake + (ePiece and 1 or 0)); sItr = fInt:format(oArg.imake)
          oPly:SetNWFloat(gsToolPrefL.."progress", (oArg.imake / tC.SKept) * 100)
          if(ePiece) then -- We still have enough memory to preform the stacking
            if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
              self:LogStatus(stTrace,"Apply physical settings fail "..asmlib.GetReport(oArg.wname, sItr)); return false end
            if(not asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or oArg.entpo),weld,nil,nil,forcelim)) then
              self:LogStatus(stTrace,"Apply weld fail "..asmlib.GetReport(oArg.wname, sItr)); return false end
            if(not asmlib.ApplyPhysicalAnchor(ePiece,oArg.entpo,nil,nocollide,nocollidew,forcelim)) then
              self:LogStatus(stTrace,"Apply no-collide fail "..asmlib.GetReport(oArg.wname, sItr)); return false end
            oArg.itrys, oArg.srate, oArg.entpo = 0, (oArg.srate - 1), ePiece -- When the routine item is still busy
            table.insert(oArg.eundo, ePiece) -- Add the entity to the undo list created at the end
            if(oArg.srate <= 0) then oArg.srate = spawnrate -- Renew the spawn rate
              if(iK == tS.Size) then -- When current snap end is reached
                oArg.stard, oArg.stark = (oArg.stard + 1), 1 -- Index the next snap
              else -- When there is more stuff to snap continue snapping the current
                oArg.stark = (oArg.stark + 1) -- Move the snap cursor to the next snap
              end -- Write the logs that snap rate per tick has been reached
              asmlib.LogInstance("Next "..asmlib.GetReport(oArg.wname, sItr, oArg.stard, oArg.stark), gtLogs)
              return true -- The server is still busy with the task
            end
          else oArg.mundo = sItr -- We still have enough memory to preform the stacking
            if(stackcnt > 0) then -- Output different log message when stack count is used for curve segments limit
              self:LogStatus(stTrace,"Segment limit reached "..asmlib.GetReport(oArg.wname, sItr)); return false
            else self:LogStatus(stTrace,"Stack attempts fail "..asmlib.GetReport(oArg.wname, sItr)); return false end
          end
        end
      end
      oPly:SetNWFloat(gsToolPrefL.."progress", 100)
      asmlib.LogInstance("Success "..asmlib.GetReport(oArg.wname, user),gtLogs); return false
    end, workname)
    poQueue:OnActive(user, function(oPly, oArg)
      oArg.eundo, oArg.mundo = {}, ""
      oPly:SetNWFloat(gsToolPrefL.."progress", 0)
    end)
    poQueue:OnFinish(user, function(oPly, oArg)
      local nU, sM = #oArg.eundo, gsUndoPrefN..fnmodel
      if(stackcnt > 0) then
        asmlib.UndoCrate(sM.." ( "..oArg.wname.." #"..stackcnt.." )")
      else asmlib.UndoCrate(sM.." ( "..oArg.wname.." )") end
      for iD = 1, nU do asmlib.UndoAddEntity(oArg.eundo[iD]) end
      if(nU < tC.SKept) then
        asmlib.UndoFinish(oPly, fInt:format(nU))
      else asmlib.UndoFinish(oPly) end
      oPly:SetNWFloat(gsToolPrefL.."progress", 0)
      asmlib.LogInstance("Success "..asmlib.GetReport(oArg.wname, user), gtLogs)
    end); return true
  elseif(workmode == 4 and self:IsFlipOver()) then
    if(poQueue:IsBusy(user)) then asmlib.Notify(user, "ERROR", "Server busy !"); return true end
    local wOver, wNorm = self:GetFlipOverOrigin(stTrace, user:KeyDown(IN_SPEED))
    local tE, nE = self:GetFlipOver(true)
    local tC, nC = asmlib.GetConstraintOver(tE)
    if(not tE or nE <= 0) then
      asmlib.Notify(user, "ERROR", "No tracks selected !")
      self:LogStatus(stTrace,"(Over) No tracks selected",trEnt); return false
    end
    poQueue:Attach(user, {
      start = 1,
      itrys = 0,
      tents = tE,
      ients = nE,
      tcons = tC,
      icons = nC,
      srate = spawnrate,
      wover = Vector(wOver),
      wnorm = Vector(wNorm)
    }, function(oPly, oArg)
      for iD = oArg.start, oArg.ients do
        oPly:SetNWFloat(gsToolPrefL.."progress", 100 * (iD / oArg.ients))
        local eID, ePiece = oArg.tents[iD], nil
        if(not asmlib.IsOther(eID)) then
          oArg.mundo, oArg.munid = eID:GetModel(), eID:EntIndex()
          local spPos, spAng = asmlib.GetTransformOver(eID, oArg.wover, oArg.wnorm, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
          while(oArg.itrys < maxstatts and not ePiece) do oArg.itrys = (oArg.itrys + 1)
            ePiece = asmlib.NewPiece(oPly,oArg.mundo,spPos,spAng,mass,bgskids,conPalette:Select("w"),bnderrmod) end
          if(ePiece) then
            asmlib.RegConstraintOver(oArg.tcons, oArg.munid, ePiece)
            oArg.itrys, oArg.srate = 0, (oArg.srate - 1) -- When the routine item is still busy
            table.insert(oArg.eundo, ePiece) -- Add the entity to the undo list created at the end
            if(oArg.srate <= 0) then -- Renew the spawn rate and prepare for next spawn
              oArg.start, oArg.srate = (iD + 1), spawnrate
              asmlib.LogInstance("(Over) Next "..asmlib.GetReport(oArg.stard, oArg.stark), gtLogs)
              return true -- The server is still busy with the task
            end
          else
            asmlib.Notify(user, "ERROR", "Spawn piece [%s] invalid: %s !", iD, oArg.mundo)
            self:LogStatus(stTrace,"(Over) Spawn data invalid",trEnt); return false
          end
        end
      end
      oPly:SetNWFloat(gsToolPrefL.."progress", 100)
      asmlib.LogInstance("(Over) Success",gtLogs); return false
    end)
    poQueue:OnActive(user, function(oPly, oArg)
      oArg.eundo, oArg.mundo, oArg.munid  = {}, "", 0
      oPly:SetNWFloat(gsToolPrefL.."progress", 0)
    end)
    poQueue:OnFinish(user, function(oPly, oArg)
      local nU = #oArg.eundo
      asmlib.UndoCrate(gsUndoPrefN..asmlib.GetReport(oArg.ients, fnmodel).." ( Over )")
      for iD = 1, nU do asmlib.UndoAddEntity(oArg.eundo[iD]) end
      asmlib.UndoFinish(oPly)
      oPly:SetNWFloat(gsToolPrefL.."progress", 0)
      -- Process the mirrored constraints. Replace entities and create constraints
      oArg.tcons, oArg.icons = asmlib.SetConstraintOver(oArg.tcons)
      for iD = 1, oArg.icons do
        local tB, tL = oArg.tcons[iD].Base, oArg.tcons[iD].Link
        if(not asmlib.IsOther(tB.Ent) and tB.Ovr) then
          if(not asmlib.ApplyPhysicalSettings(tB.Ent,ignphysgn,freeze,gravity,physmater)) then
            self:LogStatus(stTrace,"(Over) Failed to apply physical settings",tB.Ent); return false end
        else self:LogStatus(stTrace,"(Over) Physical settings invalid",tB.Ent); return false end
        for key, val in pairs(tL) do
          if(not asmlib.IsOther(val.Ent)) then
            if(not asmlib.ApplyPhysicalAnchor(tB.Ent,(anEnt or val.Ent),weld,nocollide,nocollidew,forcelim)) then
              self:LogStatus(stTrace,"(Over) Failed to apply physical anchor",val.Ent); return false end
          else self:LogStatus(stTrace,"(Over) Physical anchor invalid",val.Ent); return false end
        end
      end
    end); return true
  end

  local hdRec = asmlib.CacheQueryPiece(model); if(not asmlib.IsHere(hdRec)) then
    self:LogStatus(stTrace,"(Hold) Holder model not piece"); return false end

  if(stTrace.HitWorld) then return self:NormalSpawn(stTrace, user) end -- Switch the tool mode ( Spawn )

  if(not (trEnt and trEnt:IsValid())) then
    self:LogStatus(stTrace,"(Prop) Trace entity invalid"); return false end
  if(asmlib.IsOther(trEnt)) then
    self:LogStatus(stTrace,"(Prop) Trace other object"); return false end
  if(not asmlib.IsPhysTrace(stTrace)) then
    self:LogStatus(stTrace,"(Prop) Trace not physical object"); return false end

  local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  if(not asmlib.IsHere(trRec)) then return self:NormalSpawn(stTrace, user) end

  local stSpawn = asmlib.GetEntitySpawn(user,trEnt,stTrace.HitPos,model,pointid,
                           actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)

  if(not stSpawn) then -- Not aiming into an active point update settings/properties
    if(user:KeyDown(IN_USE)) then -- Physical
      if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
        self:LogStatus(stTrace,"(Physical) Failed to apply physical settings",trEnt); return false end
      if(not asmlib.ApplyPhysicalAnchor(trEnt,anEnt,weld,nocollide,nocollidew,forcelim)) then
        self:LogStatus(stTrace,"(Physical) Failed to apply physical anchor",trEnt); return false end
      trEnt:GetPhysicsObject():SetMass(mass)
      asmlib.LogInstance("(Physical) Success",gtLogs)
    elseif(user:KeyDown(IN_SPEED)) then -- Fast single flip over the anchor relative to a piece OBB
      if(not (anEnt and anEnt:IsValid())) then return false end
      if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
        self:LogStatus(stTrace,"(Over) Failed to apply physical settings",trEnt); return false end
      local spPos, spAng = asmlib.GetTransformOver(anEnt, trEnt:LocalToWorld(trEnt:OBBCenter()),
                             stTrace.HitNormal, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
      local ePiece = asmlib.NewPiece(user,anEnt:GetModel(),spPos,spAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
      if(ePiece) then
        if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
          self:LogStatus(stTrace,"(Over) Apply physical settings fail"); return false end
        asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( Over )")
        asmlib.UndoAddEntity(ePiece)
        asmlib.UndoFinish(user)
        asmlib.LogInstance("(Over) Success",gtLogs); return true
      end
    else -- Visual
      local IDs = gsSymDir:Explode(bgskids)
      if(not asmlib.ApplyBodyGroups(trEnt,IDs[1] or "")) then
        self:LogStatus(stTrace,"(Bodygroup/Skin) Failed",trEnt); return false end
      trEnt:SetSkin(math.Clamp(tonumber(IDs[2]) or 0,0,trEnt:SkinCount()-1))
      asmlib.LogInstance("(Bodygroup/Skin) Success",gtLogs)
    end; return true
  end

  if((workmode == 1) and (stackcnt > 0) and user:KeyDown(IN_SPEED) and (tonumber(hdRec.Size) or 0) > 1) then
    if(poQueue:IsBusy(user)) then asmlib.Notify(user, "ERROR", "Server busy !"); return true end
    if(pointid == pnextid) then self:LogStatus(stTrace,"Point ID overlap"); return false end
    local fInt, hdOffs = asmlib.GetOpVar("FORM_INTEGER"), asmlib.LocatePOA(stSpawn.HRec, pnextid)
    if(not hdOffs) then -- Make sure the next point is present so we have something to stack on
      asmlib.Notify(user, "ERROR", "Missing next point ID !")
      self:LogStatus(stTrace,"(Stack) Missing next point ID"); return false
    end -- Validated existent next point ID
    poQueue:Attach(user, {
      start = 1,
      itrys = 0,
      spawn = {},
      entpo = trEnt,
      vtemp = Vector(),
      srate = spawnrate,
      sppos = Vector(stSpawn.SPos),
      spang = Angle (stSpawn.SAng)
    }, function(oPly, oArg)
      for iD = oArg.start, stackcnt do
        oPly:SetNWFloat(gsToolPrefL.."progress", 100 * (iD / stackcnt))
        local sItr, ePiece = asmlib.GetOpVar("FORM_INTEGER"):format(iD), nil
        while(oArg.itrys < maxstatts and not ePiece) do oArg.itrys = (oArg.itrys + 1)
          ePiece = asmlib.NewPiece(oPly,model,oArg.sppos,oArg.spang,mass,bgskids,conPalette:Select("w"),bnderrmod) end
        if(ePiece) then -- Set position is valid and store reference to the track piece
          if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
            self:LogStatus(stTrace,"(Stack) Apply physical settings fail "..asmlib.GetReport(sItr, user)); return false end
          if(not asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or oArg.entpo),weld,nil,nil,forcelim)) then
            self:LogStatus(stTrace,"(Stack) Apply weld fail "..asmlib.GetReport(sItr, user)); return false end
          if(not asmlib.ApplyPhysicalAnchor(ePiece,oArg.entpo,nil,nocollide,nocollidew,forcelim)) then
            self:LogStatus(stTrace,"(Stack) Apply no-collide fail "..asmlib.GetReport(sItr, user)); return false end
          oArg.vtemp:SetUnpacked(hdOffs.P:Get())
          oArg.vtemp:Rotate(oArg.spang); oArg.vtemp:Add(oArg.sppos)
          if(appangfst) then nextpic, nextyaw, nextrol, appangfst = 0, 0, 0, false end
          if(applinfst) then nextx  , nexty  , nextz  , applinfst = 0, 0, 0, false end
          asmlib.GetEntitySpawn(oPly, ePiece, oArg.vtemp, model, pointid,
            actrad, spnflat, igntype, nextx, nexty, nextz, nextpic, nextyaw, nextrol, oArg.spawn)
          if(not oArg.spawn) then -- Something happened spawn is not available and task must be removed
            asmlib.Notify(oPly, "ERROR", "Cannot obtain spawn data !")
            self:LogStatus(stTrace,"(Stack) Cannot obtain spawn data "..asmlib.GetReport(sItr, user)); return false
          end -- Spawn data is valid for the current iteration iNdex
          oArg.sppos:Set(oArg.spawn.SPos); oArg.spang:Set(oArg.spawn.SAng)
          oArg.itrys, oArg.srate, oArg.entpo = 0, (oArg.srate - 1), ePiece
          -- Add the entity to the undo list created at the end
          table.insert(oArg.eundo, ePiece)
          -- Check whenever the routine item is still busy
          if(oArg.srate <= 0) then
            oArg.start, oArg.srate = (iD + 1), spawnrate
            asmlib.LogInstance("(Stack) Next "..asmlib.GetReport(oArg.start, user),gtLogs);
            return true -- The server is still busy with the task
          end
        else -- Something happened piece cannot be created and task must be removed
          asmlib.Notify(oPly, "ERROR", "Stack attempts depleted !")
          self:LogStatus(stTrace,"(Stack) Stack attempts depleted "..asmlib.GetReport(sItr, user)); return false
        end -- We still have enough memory to preform the stacking
      end -- Update the progress and successfully tell the task we are not busy anymore
      oPly:SetNWFloat(gsToolPrefL.."progress", 100); return false
    end, workname)
    poQueue:OnActive(user, function(oPly, oArg)
      oPly:SetNWFloat(gsToolPrefL.."progress", 0); oArg.eundo = {}
    end)
    poQueue:OnFinish(user, function(oPly, oArg)
      local nU, sM = #oArg.eundo, gsUndoPrefN..fnmodel
      asmlib.UndoCrate(sM.." ( Stack #"..stackcnt.." )")
      for iD = 1, nU do asmlib.UndoAddEntity(oArg.eundo[iD]) end
      if(nU < stackcnt) then
        asmlib.UndoFinish(oPly, fInt:format(nU))
      else asmlib.UndoFinish(oPly) end
      oPly:SetNWFloat(gsToolPrefL.."progress", 0)
      asmlib.LogInstance("(Stack) Success", gtLogs)
    end); return true
  else -- Switch the tool mode ( Snapping )
    if(workmode == 2) then -- Make a ray intersection spawn update
      if(not self:IntersectSnap(trEnt, stTrace.HitPos, stSpawn)) then
        asmlib.LogInstance("(Ray) Skip intersection sequence. Snapping", gtLogs) end
    end
    local ePiece = asmlib.NewPiece(user,model,stSpawn.SPos,stSpawn.SAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
    if(ePiece) then
      if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
        self:LogStatus(stTrace,"(Snap) Apply physical settings fail"); return false end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or trEnt),weld,nil,nil,forcelim)) then -- Weld all created to the anchor/previous
        self:LogStatus(stTrace,"(Snap) Apply weld fail"); return false end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,trEnt,nil,nocollide,nocollidew,forcelim)) then       -- NoCollide all to previous
        self:LogStatus(stTrace,"(Snap) Apply no-collide fail"); return false end
      asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( Snap )")
      asmlib.UndoAddEntity(ePiece)
      asmlib.UndoFinish(user)
      asmlib.LogInstance("(Snap) Success",gtLogs); return true
    end
    self:LogStatus(stTrace,"(Snap) Create piece fail"); return false
  end
end

--[[
 * If tells what will happen if the RightClick of the mouse is pressed
 * Changes the active point chosen by the holder or copy the model
]]--
function TOOL:RightClick(stTrace)
  if(CLIENT) then
    asmlib.LogInstance("Working on client",gtLogs); return true end
  if(not asmlib.IsInit()) then
    asmlib.LogInstance("Library fail",gtLogs); return false end
  if(not stTrace) then
    asmlib.LogInstance("Trace missing",gtLogs); return false end
  local trEnt     = stTrace.Entity
  local user      = self:GetOwner()
  local workmode  = self:GetWorkingMode()
  local enpntmscr = self:GetScrollMouse()
  if(workmode == 3 or workmode == 5) then
    local bPnt = user:KeyDown(IN_USE)
    if(user:KeyDown(IN_SPEED)) then
      return (self:CurveUpdate(stTrace, bPnt) ~= nil)
    elseif(user:KeyDown(IN_DUCK)) then
      local tC = asmlib.GetCacheCurve(user); if(not tC) then
        asmlib.LogInstance("Curve missing", gtLogs); return false end
      local mD, mL = asmlib.GetNearest(stTrace.HitPos, tC.Base)
      return (self:CurveInsert(stTrace, bPnt, mD) ~= nil)
    else
      return (self:CurveInsert(stTrace, bPnt) ~= nil)
    end; return false
  elseif(workmode == 4 and not user:KeyDown(IN_SPEED)) then
    self:SetFlipOver(trEnt); return true
  end
  if(stTrace.HitWorld) then
    if(enpntmscr or (user:KeyDown(IN_USE) and not enpntmscr)) then
      asmlib.SetAsmConvar(user,"openframe",asmlib.GetAsmConvar("maxfruse" ,"INT"))
      asmlib.LogInstance("(World) Success open frame",gtLogs); return true
    end
  elseif(trEnt and trEnt:IsValid()) then
    if(enpntmscr or (user:KeyDown(IN_USE) and not enpntmscr)) then
      if(not self:SelectModel(trEnt:GetModel())) then
        self:LogStatus(stTrace,"Model not piece "..asmlib.GetReport(enpntmscr,user)); return false end
      asmlib.LogInstance("Success "..asmlib.GetReport(enpntmscr,user),gtLogs); return true
    end
  end
  if(not enpntmscr) then
    local nDir = (user:KeyDown(IN_SPEED) and -1 or 1)
    self:SwitchPoint(nDir,user:KeyDown(IN_DUCK))
    asmlib.LogInstance("(Point) Success",gtLogs); return true
  end
end

function TOOL:Reload(stTrace)
  if(CLIENT) then
    asmlib.LogInstance("Working on client",gtLogs); return true end
  if(not stTrace) then
    asmlib.LogInstance("Invalid trace",gtLogs); return false end
  local trEnt      = stTrace.Entity
  local user       = self:GetOwner()
  local workmode   = self:GetWorkingMode()
  local bfover     = self:IsFlipOver()
  local upspanchor = self:GetUpSpawnAnchor()
  if(stTrace.HitWorld and user:IsAdmin()) then
    if(self:GetDeveloperMode()) then
      asmlib.SetLogControl(self:GetLogLines(), self:GetLogBurst())
    end -- Setup log controls in developer mode
  end
  -- Working mode specific actions
  if(workmode == 1) then
    if(user:KeyDown(IN_SPEED)) then
      if(trEnt and trEnt:IsValid()) then
        asmlib.LogInstance("(Prop) Anchor set",gtLogs)
        return self:SetAnchor(stTrace)
      else -- Pointing the world
        if(upspanchor) then -- Spawn anchor
          asmlib.LogInstance("(World) Anchor set",gtLogs)
          return self:SetAnchor(stTrace)
        else -- Clear anchor when disabled
          asmlib.LogInstance("(World) Anchor clear",gtLogs)
          return self:ClearAnchor()
        end -- Anchor processed for hit world
      end
    end
  elseif(workmode == 2) then
    if(user:KeyDown(IN_SPEED)) then
      if(trEnt and trEnt:IsValid()) then
        return self:IntersectRelate(trEnt, stTrace.HitPos)
      else
        return self:IntersectClear()
      end
    end
  elseif(workmode == 3 or workmode == 5) then
    if(user:KeyDown(IN_SPEED)) then
      self:CurveClear(); return true
    elseif(user:KeyDown(IN_DUCK)) then
      local tC = asmlib.GetCacheCurve(user); if(not tC) then
        asmlib.LogInstance("Curve missing", gtLogs); return false end
      local mD, mL = asmlib.GetNearest(stTrace.HitPos, tC.Base)
      self:CurveRemove(mD); return true
    else
      self:CurveRemove(); return true
    end
  elseif(workmode == 4 and bfover) then
    self:ClearFlipOver(); return true
  end
  -- Grab the trace track model for remove
  if(trEnt and trEnt:IsValid()) then
    if(not asmlib.IsPhysTrace(stTrace)) then return false end
    if(asmlib.IsOther(trEnt)) then
      asmlib.LogInstance("Trace other object",gtLogs); return false end
    local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
    if(asmlib.IsHere(trRec) and (asmlib.GetOwner(trEnt) == user or user:IsAdmin())) then
      asmlib.InSpawnMargin(user, trRec); trEnt:Remove()
      asmlib.LogInstance("Remove piece",gtLogs); return true
    end; asmlib.LogInstance("Success",gtLogs)
  end; return false
end

function TOOL:ReleaseGhostEntity()
  if(CLIENT) then
    asmlib.ClearGhosts()
  else
    local user = self:GetOwner()
    if(not asmlib.IsPlayer(user)) then return end
    net.Start(gsLibName.."SendDeleteGhosts")
    net.Send(user)
  end
end

function TOOL:Holster()
  self:ReleaseGhostEntity()
end

function TOOL:UpdateGhostFlipOver(stTrace, sPos, sAng)
  local atGho  = asmlib.GetOpVar("ARRAY_GHOST")
  local tE, nE = self:GetFlipOver(true, true)
  if(tE and self:IsFlipOver()) then
    local nextx  , nexty  , nextz   = self:GetPosOffsets()
    local nextpic, nextyaw, nextrol = self:GetAngOffsets()
    for iD = 1, nE do
      local bPK = input.IsKeyDown(KEY_LSHIFT)
      local eID, gID = tE[iD], atGho[iD]
      if(not asmlib.IsOther(eID) and gID and gID:IsValid()) then
        local wOver, wNorm = self:GetFlipOverOrigin(stTrace, bPK)
        local spPos, spAng = asmlib.GetTransformOver(eID, wOver, wNorm,
                               nextx, nexty, nextz, nextpic, nextyaw, nextrol)
        gID:SetPos(spPos); gID:SetAngles(spAng)
        gID:SetModel(eID:GetModel()); gID:SetNoDraw(false)
      end
    end
  else
    if(sPos and sAng) then local gID = atGho[1]
      gID:SetPos(sPos); gID:SetAngles(sAng); gID:SetNoDraw(false) end
  end
end

function TOOL:UpdateGhostCurve()
  local user = self:GetOwner()
  local tCrv, nD = self:CurveCheck(true)
  if(tCrv and tCrv.Size and tCrv.Size > 1) then
    local model = self:GetModel()
    local stackcnt = self:GetStackCount()
    local pointid, pnextid = self:GetPointID()
    local tGho, iGho = asmlib.GetOpVar("ARRAY_GHOST"), 0
    local bCrv = user:GetNWBool(gsToolPrefL.."engcurve", false)
    if(bCrv) then
      local workmode  = self:GetWorkingMode()
      local curvefact = self:GetCurveFactor()
      local curvsmple = self:GetCurveSamples()
      user:SetNWBool(gsToolPrefL.."engcurve", false)
      if(workmode == 3) then
        asmlib.CalculateRomCurve(user, curvsmple, curvefact)
      elseif(workmode == 5) then
        asmlib.CalculateBezierCurve(user, curvsmple)
      end
      for iD = 1, (tCrv.CSize - 1) do
        asmlib.UpdateCurveSnap(user, iD, nD)
      end
      asmlib.Notify(nil, "UNDO", "Curve snap %s segments !", tCrv.SKept)
    end
    for iD = 1, tCrv.SSize do local tS = tCrv.Snap[iD]
      for iK = 1, tS.Size do iGho = (iGho + 1)
        local tV, eGho = tS[iK], tGho[iGho]
        local stSpawn = asmlib.GetNormalSpawn(user, tV[1], tV[2], model, pointid, 0, 0, 0, 0, 0, 0)
        if(eGho and eGho:IsValid()) then eGho:SetNoDraw(true)
          if(stackcnt > 0) then if(iGho > stackcnt) then eGho:SetNoDraw(true) else
            if(stSpawn) then eGho:SetPos(stSpawn.SPos); eGho:SetAngles(stSpawn.SAng); eGho:SetNoDraw(false) end end
          else
            if(stSpawn) then eGho:SetPos(stSpawn.SPos); eGho:SetAngles(stSpawn.SAng); eGho:SetNoDraw(false) end
          end
        end
      end
    end
  end
end

function TOOL:UpdateGhostSpawn(stTrace, oPly)
  local atGho = asmlib.GetOpVar("ARRAY_GHOST")
  local model, ePiece = self:GetModel(), atGho[1]
  local pointid, pnextid = self:GetPointID()
  local nextx, nexty, nextz = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  local angsnap  = self:GetAngSnap()
  local elevpnt  = self:GetElevation()
  local surfsnap = self:GetSurfaceSnap()
  local vPos = Vector(stTrace.HitNormal); vPos:Mul(elevpnt); vPos:Add(stTrace.HitPos)
  local aAng = asmlib.GetNormalAngle(oPly, stTrace, surfsnap, angsnap)
  if(self:GetSpawnCenter()) then
    aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
    aAng:RotateAroundAxis(aAng:Right()  , nextpic)
    aAng:RotateAroundAxis(aAng:Forward(), nextrol)
    asmlib.SetCenter(ePiece, vPos, aAng, nextx, -nexty, nextz)
    ePiece:SetNoDraw(false)
  else
    local stSpawn = asmlib.GetNormalSpawn(oPly,vPos,aAng,model,pointid,
                      nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(stSpawn) then
      ePiece:SetPos(stSpawn.SPos)
      ePiece:SetAngles(stSpawn.SAng)
      ePiece:SetNoDraw(false)
    end; return stSpawn
  end
end

function TOOL:UpdateGhost(oPly)
  local ghostblnd = self:GetGhostBlend()
  if(not asmlib.FadeGhosts(true, ghostblnd)) then return end
  if(self:GetGhostsCount() <= 0) then return end
  local stTrace = asmlib.GetCacheTrace(oPly)
  if(not stTrace) then return end
  if(not asmlib.HasGhosts()) then return end
  local workmode = self:GetWorkingMode()
  if(workmode == 3 or workmode == 5) then self:UpdateGhostCurve() return end
  local atGho, trRec = asmlib.GetOpVar("ARRAY_GHOST")
  local trEnt, model = stTrace.Entity, self:GetModel()
  local pointid, pnextid = self:GetPointID()
  local nextx, nexty, nextz = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  if(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return end
    trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  end
  if(trRec) then
    local ePiece    = atGho[1]
    if(not (ePiece and ePiece:IsValid())) then return end
    local spnflat   = self:GetSpawnFlat()
    local igntype   = self:GetIgnoreType()
    local stackcnt  = self:GetStackCount()
    local actrad    = self:GetActiveRadius()
    local applinfst = self:GetIsLinearFirst()
    local appangfst = self:GetIsAngularFirst()
    local stSpawn   = asmlib.GetEntitySpawn(oPly,trEnt,stTrace.HitPos,model,pointid,
                        actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(stSpawn) then
      if(workmode == 1) then
        if(stackcnt > 0 and input.IsKeyDown(KEY_LSHIFT) and (tonumber(stSpawn.HRec.Size) or 0) > 1) then
          local vTemp, hdOffs = Vector(), asmlib.LocatePOA(stSpawn.HRec, pnextid)
          if(not hdOffs) then return end -- Validated existent next point ID
          for iNdex = 1, atGho.Size do ePiece = atGho[iNdex]
            if(not (ePiece and ePiece:IsValid())) then return end
            ePiece:SetPos(stSpawn.SPos); ePiece:SetAngles(stSpawn.SAng)
            ePiece:SetNoDraw(false); vTemp:SetUnpacked(hdOffs.P:Get())
            vTemp:Rotate(stSpawn.SAng); vTemp:Add(ePiece:GetPos())
            if(appangfst) then nextpic,nextyaw,nextrol, appangfst = 0,0,0,false end
            if(applinfst) then nextx  ,nexty  ,nextz  , applinfst = 0,0,0,false end
            stSpawn = asmlib.GetEntitySpawn(oPly,ePiece,vTemp,model,pointid,
              actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
            if(not stSpawn) then return end
          end
        else
          ePiece:SetPos(stSpawn.SPos); ePiece:SetAngles(stSpawn.SAng); ePiece:SetNoDraw(false)
        end
      elseif(workmode == 4) then
        self:UpdateGhostFlipOver(stTrace, stSpawn.SPos, stSpawn.SAng)
      elseif(workmode == 2) then
        self:IntersectSnap(trEnt, stTrace.HitPos, stSpawn, true)
        ePiece:SetPos(stSpawn.SPos); ePiece:SetAngles(stSpawn.SAng); ePiece:SetNoDraw(false)
      end
    else
      if(workmode == 4) then
        self:UpdateGhostFlipOver(stTrace) end
    end
  else
    local stSpawn = self:UpdateGhostSpawn(stTrace, oPly)
    if(stSpawn) then
      if(workmode == 4) then
        self:UpdateGhostFlipOver(stTrace, stSpawn.SPos, stSpawn.SAng)
      end
    end
  end
end

function TOOL:ElevateGhost(oEnt, oPly)
  if(not (oPly and oPly:IsValid() and oPly:IsPlayer())) then
    asmlib.LogInstance("Player invalid "..asmlib.GetReport(oPly), gtLogs); return end
  if(not (oEnt and oEnt:IsValid())) then return end
  local pointid, pnextid = self:GetPointID()
  local spawncn, elevpnt = self:GetSpawnCenter(), 0
  if(not spawncn) then -- Distance for the piece spawned on the ground
    elevpnt = (asmlib.GetPointElevation(oEnt, pointid) or 0); end
  asmlib.LogInstance("Elevate piece "..asmlib.GetReport(spawncn, elevpnt), gtLogs)
  asmlib.SetAsmConvar(oPly, "elevpnt", elevpnt)
end

function TOOL:Think()
  if(not asmlib.IsInit()) then return end
  local workmode = self:GetWorkingMode()
  if(SERVER) then return end
  local model = self:GetModel()
  if(not asmlib.IsModel(model)) then return end
  local bO = asmlib.IsFlag("old_close_frame", asmlib.IsFlag("new_close_frame"))
  local bN = asmlib.IsFlag("new_close_frame", input.IsKeyDown(KEY_E))
  if(not bO and bN and input.IsKeyDown(KEY_LALT)) then
    local tP = conElements:Pull() -- Retrieve a panel from the stack
    if(istable(tP)) then local oP, sF = tP[1], tP[2] -- Extract panel
      if(IsValid(oP) and isfunction(oP[sF])) then -- Validate the control entry
        local bS, oE = pcall(oP[sF], oP, unpack(tP, 3)) -- A `close` call, get it :D
        if(not bS) then ErrorNoHaltWithStack("TOOL: Track assembly close error: "..oE.."!\n") end
      end -- Shortcut for closing the routine pieces, Make it invisible
    end -- The temporary reference is not table then skip it
  end -- Front trigger for closing panels
end

--[[
 * This function draws value snapshot of the spawn structure in the screen
 * oScreen > Screen to draw the text on
 * sCol    > Text draw color
 * sMeth   > Text draw method
 * tArgs   > Text draw arguments
]]--
function TOOL:DrawTextSpawn(oScreen, sCol, sMeth, tArgs)
  local user, iD = LocalPlayer(), 1
  local stS = asmlib.GetCacheSpawn(user)
  local arK = asmlib.GetOpVar("STRUCT_SPAWN")
  local fky = asmlib.GetOpVar("FORM_DRWSPKY")
  local w,h = oScreen:GetSize()
  oScreen:SetTextOrigin(0, 260)
  oScreen:DrawText(tostring(arK.Name), sCol, sMeth, tArgs)
  while(arK[iD]) do local def, iK = arK[iD], 1
    oScreen:DrawText("---- "..tostring(def.Name).." ----")
    while(def[iK]) do local row = def[iK]
      if(asmlib.IsHere(row[1])) then
        local key = tostring(row[1] or "")
        local typ = tostring(row[2] or "")
        local inf = tostring(row[3] or "")
        local foo = arK.Draw[typ]
        if(foo) then
          local bs, sr = pcall(foo, oScreen, key, typ, inf, arK, stS)
          if(not bs) then asmlib.LogInstance(sr, gtLogs); return end
        else
          local fmt = asmlib.GetOpVar("FORM_DRAWDBG")
          local val = tostring(stS[key] or "")
          oScreen:DrawText(fmt:format(fky:format(key), typ, val, inf))
        end
      end; iK = iK + 1
    end; iD = iD + 1
  end
end

function TOOL:DrawRelateIntersection(oScreen, oPly)
  local stRay = asmlib.IntersectRayRead(oPly, "relate")
  if(not stRay) then return end
  local rOrg, rDir = stRay.Orw, stRay.Diw
  local Rp, nLn = rOrg:ToScreen(), self:GetSizeUCS()
  local Rf = (rOrg + nLn * rDir:Forward()):ToScreen()
  local Ru = (rOrg + nLn * 0.5 * rDir:Up()):ToScreen()
  local nR = asmlib.GetViewRadius(oPly, rOrg)
  oScreen:DrawLine(Rp, Rf, "r", "SURF")
  oScreen:DrawLine(Rp, Ru, "b")
  oScreen:DrawCircle(Rp, nR, "y", "SEGM", {35})
  return Rp, Rf, Ru
end

function TOOL:DrawRelateAssist(oScreen, oPly, stTrace)
  if(not self:GetPointAssist()) then return end
  local trEnt, trHit = stTrace.Entity, stTrace.HitPos
  local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  if(not asmlib.IsHere(trRec)) then return end
  local nRad, nLn = asmlib.GetCacheRadius(oPly, trHit), self:GetSizeUCS()
  local vTmp, aTmp, trPOA, rM = Vector(), Angle()
  local trPos, trAng = trEnt:GetPos(), trEnt:GetAngles()
  for ID = 1, trRec.Size do
    local stPOA = asmlib.LocatePOA(trRec,ID); if(not stPOA) then
      asmlib.LogInstance("Cannot locate #"..tostring(ID),gtLogs); return end
    vTmp:SetUnpacked(stPOA.O:Get())
    vTmp:Rotate(trAng); vTmp:Add(trPos)
    local nR, nM = asmlib.GetViewRadius(oPly, vTmp), vTmp:DistToSqr(trHit)
    oScreen:DrawCircle(vTmp:ToScreen(), nR, "y", "SEGM", {35})
    if(not rM or (nM < rM)) then rM, trPOA = nM, stPOA end
  end
  vTmp:SetUnpacked(trPOA.O:Get())
  vTmp:Rotate(trAng); vTmp:Add(trPos)
  aTmp:SetUnpacked(trPOA.A:Get())
  aTmp:Set(trEnt:LocalToWorldAngles(aTmp))
  local Hp, Op = trHit:ToScreen(), vTmp:ToScreen()
  local vF, vU = aTmp:Forward(), aTmp:Up()
  vF:Mul(nLn); vU:Mul(0.5 * nLn); vF:Add(vTmp); vU:Add(vTmp)
  local xF, xU = vF:ToScreen(), vU:ToScreen()
  oScreen:DrawCircle(Hp, nRad, "y", "SURF")
  oScreen:DrawLine(Hp, Op, "g", "SURF")
  oScreen:DrawLine(xF, Op, "r")
  oScreen:DrawLine(xU, Op, "b")
end

function TOOL:DrawSnapAssist(oScreen, oPly, stTrace, nRad, bNoO)
  if(not self:GetPointAssist()) then return end
  local actrad = (tonumber(nRad) or self:GetActiveRadius())
  local trRec  = asmlib.CacheQueryPiece(stTrace.Entity:GetModel())
  if(not asmlib.IsHere(trRec)) then return end
  local nRad = asmlib.GetCacheRadius(oPly, stTrace.HitPos)
  for ID = 1, trRec.Size do
    local stPOA = asmlib.LocatePOA(trRec,ID); if(not stPOA) then
      asmlib.LogInstance("Cannot locate #"..tostring(ID),gtLogs); return end
    oScreen:DrawPOA(oPly, stTrace.Entity, stPOA, ID, actrad, bNoO)
  end
end

function TOOL:DrawModelIntersection(oScreen, oPly, stSpawn)
  local model = self:GetModel()
  local pointid, pnextid = self:GetPointID()
  local xx, vO1, vO2 = asmlib.IntersectRayModel(model, pointid, pnextid)
  if(xx) then local sPos, sAng = stSpawn.SPos, stSpawn.SAng
    xx:Rotate(sAng); xx:Add(sPos)
    vO1:Rotate(sAng); vO1:Add(sPos)
    vO2:Rotate(sAng); vO2:Add(sPos)
    local xX = xx:ToScreen()
    local Os, Ss = stSpawn.OPos:ToScreen(), sPos:ToScreen()
    local O1, O2 = vO1:ToScreen(), vO2:ToScreen()
    oScreen:DrawLine(Os,Ss,"m", "SURF")
    oScreen:DrawCircle(Ss, asmlib.GetViewRadius(oPly, sPos), "c", "SURF")
    oScreen:DrawCircle(xX, asmlib.GetViewRadius(oPly, xx, 2), "b")
    oScreen:DrawLine(xX,O1,"ry")
    oScreen:DrawLine(xX,O2)
    oScreen:DrawCircle(O1, asmlib.GetViewRadius(oPly, vO1, 0.5), "r")
    oScreen:DrawCircle(O2, asmlib.GetViewRadius(oPly, vO2, 0.5), "g")
    return xX, O1, O2
  end
end

function TOOL:DrawPillarIntersection(oScreen, vX, vX1, vX2)
  local user, XX = self:GetOwner(), vX:ToScreen()
  local X1, X2 = vX1:ToScreen(), vX2:ToScreen()
  oScreen:DrawLine(X1, X2, "ry", "SURF")
  oScreen:DrawCircle(X1, asmlib.GetViewRadius(user, vX1),"r", "SURF")
  oScreen:DrawCircle(X2, asmlib.GetViewRadius(user, vX2),"g")
  oScreen:DrawCircle(XX, asmlib.GetViewRadius(user, vX),"b")
  return XX, X1, X2
end

function TOOL:DrawCurveNode(oScreen, oPly, stTrace)
  local bPnt = input.IsKeyDown(KEY_E)
  local tData = self:GetCurveTransform(stTrace, bPnt)
  if(not tData) then asmlib.LogInstance("Transform missing", gtLogs); return end
  local tC, nS = asmlib.GetCacheCurve(oPly), self:GetSizeUCS()
  if(not tC) then asmlib.LogInstance("Curve missing", gtLogs); return end
  local bSh, bCt = input.IsKeyDown(KEY_LSHIFT), input.IsKeyDown(KEY_LCONTROL)
  local nrB, nrS, nrA, mD, mL = 1.5, 1.5, self:GetActiveRadius()
  local xyO, xyH = tData.Org:ToScreen(), tData.Hit:ToScreen()
  local xyZ = (tData.Org + nS * tData.Ang:Up()):ToScreen()
  local xyX = (tData.Org + nS * tData.Ang:Forward()):ToScreen()
  oScreen:DrawLine(xyO, xyX, "r", "SURF")
  oScreen:DrawCircle(xyH, asmlib.GetViewRadius(oPly, tData.Hit, nrS), "y", "SURF", {35})
  if(tData.POA) then self:DrawSnapAssist(oScreen, oPly, stTrace, 10) -- Draw assist
  else oScreen:DrawLine(xyH, xyO, "y") end -- When active point is used for node
  oScreen:DrawCircle(xyO, asmlib.GetViewRadius(oPly, tData.Org, nrB), "g")
  oScreen:DrawLine(xyO, xyZ, "b")
  if(bSh or bCt) then mD, mL = asmlib.GetNearest(tData.Hit, tC.Base) end
  if(tC.Size and tC.Size > 0) then
    for iD = 1, tC.Size do
      local rN = (iD == 1 and nrB or nrS)
      local vB, tR = tC.Base[iD], tC.Rays[iD]
      local vD, vN = tC.Node[iD], tC.Norm[iD]
      local nB = asmlib.GetViewRadius(oPly, vB, 2)
      local nD = asmlib.GetViewRadius(oPly, vD, rN)
      local xyB, xyD = vB:ToScreen(), vD:ToScreen()
      local xyN = (vD + nS * vN):ToScreen()
      local xyF = (vD + nS * tR[2]:Forward()):ToScreen()
      oScreen:DrawLine(xyB, xyD, "y")
      oScreen:DrawCircle(xyB, nB)
      oScreen:DrawCircle(xyD, nD)
      oScreen:DrawLine(xyF, xyD, "r")
      if(bCt) then -- TODO: Draw next id after trace id
        oScreen:SetTextOrigin(xyD.x + 15, xyD.y - 15)
        oScreen:DrawText(tostring(iD), "y", "SURF",{"DebugSpawnTA"})
      end
      oScreen:DrawLine(xyN, xyD, "b")
      oScreen:DrawCircle(xyD, nD / 2, "r")
      if(tC.Node[iD - 1]) then
        local xyP = tC.Node[iD - 1]:ToScreen()
        oScreen:DrawLine(xyP, xyD, "g", sM)
      end
    end
  end
  if(tC.Size and tC.Size > 0) then
    if((bSh or bCt) and mD) then
      local xyN = tC.Node[mD]:ToScreen()
      oScreen:DrawLine(xyO, xyN, "r")
      if(mL < nrA^2) then
        local nP, vR = 10, oPly:GetRight()
        if(bPnt) then
          local vU = oPly:GetUp(); vU:Mul(-nP); vU:Add(tData.Org)
          oScreen:DrawLine(xyO, (vU + nP * vR):ToScreen(), "m")
          oScreen:DrawLine(xyO, (vU - nP * vR):ToScreen(), "m")
        else
          local vU = oPly:GetUp(); vU:Mul(nP); vU:Add(tData.Org)
          oScreen:DrawLine(xyO, (vU + nP * vR):ToScreen(), "m")
          oScreen:DrawLine(xyO, (vU - nP * vR):ToScreen(), "m")
        end
      elseif(bPnt and not tData.POA) then
        local xx, sx = self:GetCurveNodeActive(mD, tData.Org, true)
        if(xx) then
          local xyX = xx:ToScreen(); oScreen:DrawLine(xyX, xyO, "ry")
          if(sx == 0) then
            oScreen:DrawCircle(xyX, asmlib.GetViewRadius(oPly, xx), "r")
          elseif(sx == 1) then
            oScreen:DrawCircle(xyX, asmlib.GetViewRadius(oPly, xx), "g")
          elseif(sx == 2) then
            oScreen:DrawCircle(xyX, asmlib.GetViewRadius(oPly, xx), "b")
          end
        end
      end
    else
      local xyN = tC.Node[tC.Size]:ToScreen()
      oScreen:DrawLine(xyN, xyO, "y")
    end
  end
  if(tData.POA) then local trEnt = stTrace.Entity
    tData.Org:SetUnpacked(tData.POA.P:Get())
    tData.Org:Rotate(trEnt:GetAngles()); tData.Org:Add(trEnt:GetPos())
    oScreen:DrawLine(xyH, tData.Org:ToScreen(), "g")
  end
end

function TOOL:DrawNextPoint(oScreen, oPly, stSpawn)
  local pointid, pnextid = self:GetPointID()
  local oRec, vN = stSpawn.HRec, Vector()
  local stPOA = asmlib.LocatePOA(oRec, pnextid)
  if(stPOA and oRec.Size > 1) then
    vN:SetUnpacked(stPOA.O:Get())
    vN:Rotate(stSpawn.SAng); vN:Add(stSpawn.SPos)
    local Np, Op = vN:ToScreen(), stSpawn.OPos:ToScreen()
    oScreen:DrawLine(Op, Np, "g")
    oScreen:DrawCircle(Np, asmlib.GetViewRadius(oPly, vN, 0.5), "g")
  end
end

function TOOL:DrawFlipAssist(hudMonitor, oPly, stTrace)
  if(not self:GetPointAssist()) then return end
  local model, trEnt = self:GetModel(), stTrace.Entity
  local actrad, vT = self:GetActiveRadius(), Vector()
  local bAct, xH = input.IsKeyDown(KEY_LSHIFT), stTrace.HitPos:ToScreen()
  local wOv, wNr, wOr, wO1, wO2  = self:GetFlipOverOrigin(stTrace, bAct)
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  vT:Set(wNr); vT:Mul(actrad); vT:Add(wOv)
  local oO, oN = wOv:ToScreen(), vT:ToScreen()
  hudMonitor:DrawLine(oO, oN, "y", "SURF")
  hudMonitor:DrawCircle(oN, asmlib.GetViewRadius(oPly, vT, 0.5), "r")
  hudMonitor:DrawLine(oO, xH, "g")
  hudMonitor:DrawCircle(xH, asmlib.GetViewRadius(oPly, stTrace.HitPos, 0.5))
  local tE, nE = self:GetFlipOver(true, true)
  for iD = 1, nE do local eID = tE[iD]
    if(not asmlib.IsOther(eID)) then
      local vePos = eID:GetPos()
      local spPos, spAng = asmlib.GetTransformOver(eID, wOv, wNr,
                             nextx, nexty, nextz, nextpic, nextyaw, nextrol)
      local Os = vePos:ToScreen()
      local Oe = spPos:ToScreen()
      hudMonitor:DrawLine(oO, Os, "y", "SEGM", {20})
      hudMonitor:DrawLine(oO, Oe, "y")
      hudMonitor:DrawCircle(Os, asmlib.GetViewRadius(oPly, vePos), "c", "SURF")
      hudMonitor:DrawCircle(Oe, asmlib.GetViewRadius(oPly, spPos), "m")
    end
  end
  if(bAct and not stTrace.HitWorld and wOr) then
    local Op = wOr:ToScreen()
    hudMonitor:DrawLine(xH, Op, "r")
    if(model == trEnt:GetModel() and wO1 and wO2) then
      local Op1 = wO1:ToScreen()
      local Op2 = wO2:ToScreen()
      hudMonitor:DrawLine(oO, Op1, "ry")
      hudMonitor:DrawLine(oO, Op2)
      hudMonitor:DrawCircle(Op1, asmlib.GetViewRadius(oPly, wO1), "r")
      hudMonitor:DrawCircle(Op2, asmlib.GetViewRadius(oPly, wO2))
      hudMonitor:DrawCircle(oO, asmlib.GetViewRadius(oPly, wOv, 1.5), "b")
    else
      hudMonitor:DrawCircle(Op, asmlib.GetViewRadius(oPly, wOr), "r")
      hudMonitor:DrawCircle(oO, asmlib.GetViewRadius(oPly, wOv, 1.5))
    end
  else
    hudMonitor:DrawCircle(oO, asmlib.GetViewRadius(oPly, wOv, 1.5), "r")
  end
end

function TOOL:DrawProgress(hudMonitor, oPly)
  local sKey = (gsToolPrefL.."progress")
  local nPrg = oPly:GetNWFloat(sKey, 0)
  if(nPrg > 0) then
    local fP = asmlib.GetOpVar("FORM_PROGRESS")
    local nR = asmlib.GetOpVar("GOLDEN_RATIO")
    local xyP, nD  = asmlib.NewXY(),  2
    local xyO, xyW = hudMonitor:GetCorners()
    local nW , nH  = (xyW.x - xyO.x), (xyW.y - xyO.y)
    local xyS = asmlib.NewXY((nR - 1) * (1 / 4) * nW, 36)
    xyP.x, xyP.y = ((nW / 2) - xyS.x / 2), (nH - (nH / 4) - xyS.y / 2)
    hudMonitor:DrawRect(xyP, xyS,"pb","SURF",{"vgui/white", nil, 6})
    xyS.x, xyS.y = ((nPrg / 100) * (xyS.x - 2 * nD)), (xyS.y - 2 * nD)
    xyP.x, xyP.y = ((nW / 2) - (xyS.x / 2)), (xyP.y + nD)
    hudMonitor:DrawRect(xyP, xyS,"pf","SURF",{"vgui/white", nil, 4})
    local ncX, ncY = (xyP.x + xyS.x / 2), (xyP.y + xyS.y / 2)
    hudMonitor:SetTextOrigin(ncX, ncY):DrawText(fP:format(nPrg), "k", "SURF", {"Trebuchet24", true})
  end
end

function TOOL:DrawSnapRegular(hudMonitor, oPly, stSpawn, vHit)
  local sizeucs = self:GetSizeUCS()
  local actrad = self:GetActiveRadius()
  local nRad = asmlib.GetCacheRadius(oPly, vHit)
  local Ss, Tp = stSpawn.SPos:ToScreen(), vHit:ToScreen()
  local Ob = hudMonitor:DrawUCS(oPly, stSpawn.BPos, stSpawn.BAng, "SURF", {sizeucs})
  local Os = hudMonitor:DrawUCS(oPly, stSpawn.OPos, stSpawn.OAng)
  hudMonitor:DrawLine(Ob,Tp,"y")
  hudMonitor:DrawCircle(Tp,(nRad * (stSpawn.RLen / actrad)) / 2)
  hudMonitor:DrawLine(Ob,Os)
  hudMonitor:DrawLine(Ob,Pp,"r")
  hudMonitor:DrawCircle(Os, asmlib.GetViewRadius(oPly, stSpawn.OPos, 0.5),"r")
  hudMonitor:DrawLine(Os,Ss,"m")
  hudMonitor:DrawCircle(Ss, asmlib.GetViewRadius(oPly, stSpawn.SPos),"c")
end

function TOOL:DrawHUD()
  if(SERVER) then return end
  if(not asmlib.IsInit()) then return end
  local scrW, scrH = surface.ScreenWidth(), surface.ScreenHeight()
  local hudMonitor = asmlib.GetScreen(0,0,scrW,scrH,conPalette,"GAME")
  if(not hudMonitor) then return end
  if(not self:GetAdviser()) then return end
  local user = LocalPlayer()
  local stTrace = asmlib.GetCacheTrace(user)
  if(not (stTrace and stTrace.Hit)) then return end
  self:DrawProgress(hudMonitor, user)
  local workmode, model = self:GetWorkingMode(), self:GetModel()
  if(workmode == 3 or workmode == 5) then
    self:DrawCurveNode(hudMonitor, user, stTrace)
    if(not self:GetDeveloperMode()) then return end
    self:DrawTextSpawn(hudMonitor, "k","SURF",{"DebugSpawnTA"}); return
  end
  local trEnt, trHit, trRec = stTrace.Entity, stTrace.HitPos
  local pointid, pnextid = self:GetPointID()
  local nextx, nexty, nextz = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  if(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return end
    trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  end
  if(trRec) then
    local spnflat = self:GetSpawnFlat()
    local igntype = self:GetIgnoreType()
    local actrad  = self:GetActiveRadius()
    local trPos, trAng = trEnt:GetPos(), trEnt:GetAngles()
    local stSpawn = asmlib.GetEntitySpawn(user,trEnt,trHit,model,pointid,
                      actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(not stSpawn) then
      if(workmode == 1) then
        self:DrawSnapAssist(hudMonitor, user, stTrace)
      elseif(workmode == 2) then
        self:DrawRelateAssist(hudMonitor, user, stTrace)
      elseif(workmode == 4) then
        self:DrawFlipAssist(hudMonitor, user, stTrace)
      end; return -- The return is very very important ... Must stop on invalid spawn
    else -- Patch the drawing for certain working modes
      if(workmode == 1) then
        self:DrawNextPoint(hudMonitor, user, stSpawn)
        self:DrawSnapRegular(hudMonitor, user, stSpawn, trHit)
      elseif(workmode == 2) then -- Draw point intersection
        local Os = stSpawn.OPos:ToScreen()
        local Ss = stSpawn.SPos:ToScreen()
        if(asmlib.IntersectRayRead(user, "relate")) then
          local vX, vX1, vX2 = self:IntersectSnap(trEnt, trHit, stSpawn, true)
          local Rp, Re = self:DrawRelateIntersection(hudMonitor, user)
          if(Rp and vX) then
            local xX , O1 , O2  = self:DrawModelIntersection(hudMonitor, user, stSpawn)
            local pXx, pX1, pX2 = self:DrawPillarIntersection(hudMonitor, vX ,vX1, vX2)
            hudMonitor:DrawLine(Rp,xX,"ry")
            hudMonitor:DrawLine(Os,xX)
            hudMonitor:DrawLine(Rp,O2,"g")
            hudMonitor:DrawLine(Os,O1,"r")
            hudMonitor:DrawLine(xX,pXx,"b")
          end
        else
          self:DrawNextPoint(hudMonitor, user, stSpawn)
          self:DrawRelateAssist(hudMonitor, user, stTrace)
          self:DrawSnapAssist(hudMonitor, user, stTrace, nil, true)
          hudMonitor:DrawLine(Os,Ss,"m")
          hudMonitor:DrawCircle(Ss, asmlib.GetViewRadius(user, stSpawn.SPos),"c")
        end
      elseif(workmode == 4) then
        self:DrawSnapRegular(hudMonitor, user, stSpawn, trHit)
        if(self:IsFlipOver()) then
          self:DrawFlipAssist(hudMonitor, user, stTrace) end
      end
      if(not self:GetDeveloperMode()) then return end
      self:DrawTextSpawn(hudMonitor, "k","SURF",{"DebugSpawnTA"})
    end
  else
    if(workmode == 4 and self:IsFlipOver()) then
      self:DrawFlipAssist(hudMonitor, user, stTrace); return end
    local angsnap  = self:GetAngSnap()
    local elevpnt  = self:GetElevation()
    local surfsnap = self:GetSurfaceSnap()
    local workmode = self:GetWorkingMode()
    local aAng = asmlib.GetNormalAngle(user,stTrace,surfsnap,angsnap)
    if(self:GetSpawnCenter()) then -- Relative to MC
      local sizeucs = self:GetSizeUCS()
            aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
            aAng:RotateAroundAxis(aAng:Right()  , nextpic)
            aAng:RotateAroundAxis(aAng:Forward(), nextrol)
      local vPos = Vector()
            vPos:Set(trHit + elevpnt * stTrace.HitNormal)
            vPos:Add(nextx * aAng:Forward())
            vPos:Add(nexty * aAng:Right())
            vPos:Add(nextz * aAng:Up())
      hudMonitor:DrawUCS(user, vPos, aAng, "SURF", {sizeucs})
      if(workmode == 2) then -- Draw point intersection
        self:DrawRelateIntersection(hudMonitor, user) end
      if(not self:GetDeveloperMode()) then return end
      local sX, sY = hudMonitor:GetSize()
      hudMonitor:SetTextOrigin(0, sY / 2)
      hudMonitor:DrawText("  POS: "..tostring(vPos),"k","SURF",{"DebugSpawnTA"})
      hudMonitor:DrawText("  ANG: "..tostring(aAng))
    else -- Relative to the active Point
      if(not (pointid > 0 and pnextid > 0)) then return end
      local stSpawn = asmlib.GetNormalSpawn(user,trHit + elevpnt * stTrace.HitNormal,
                         aAng,model,pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(not stSpawn) then return end
      if(workmode == 1) then
        self:DrawNextPoint(hudMonitor, user, stSpawn)
      elseif(workmode == 2) then -- Draw point intersection
        self:DrawRelateIntersection(hudMonitor, user)
        self:DrawModelIntersection(hudMonitor, user, stSpawn)
      end
      self:DrawSnapRegular(hudMonitor, user, stSpawn, trHit)
      if(not self:GetDeveloperMode()) then return end
      self:DrawTextSpawn(hudMonitor, "k","SURF",{"DebugSpawnTA"})
    end
  end
end

function TOOL:DrawToolScreen(w, h)
  if(SERVER) then return end
  if(not asmlib.IsInit()) then return end
  local scrTool = asmlib.GetScreen(0,0,w,h,conPalette,"TOOL")
  if(not scrTool) then return end -- Screen not yet created
  local xyT, xyB = scrTool:GetCorners()
  scrTool:DrawRect(xyT,xyB,"k","SURF",{"vgui/white"})
  scrTool:SetTextOrigin(xyT.x, xyT.y)
  local user = LocalPlayer()
  local stTrace = asmlib.GetCacheTrace(user)
  local siAnc, anEnt = self:GetAnchor()
  local tInfo = gsSymRev:Explode(siAnc)
  if(not (stTrace and stTrace.Hit)) then
    scrTool:DrawText("Trace status: Invalid","r","SURF",{"Trebuchet24"})
    scrTool:DrawTextMore(asmlib.GetConcat("  [", (tInfo[1] or gsNoID), "]"), "an"); return
  end
  scrTool:DrawText("Trace status: Valid","g","SURF",{"Trebuchet24"})
  scrTool:DrawTextMore(asmlib.GetConcat("  [", (tInfo[1] or gsNoID), "]"), "an")
  local model = self:GetModel()
  local hdRec = asmlib.CacheQueryPiece(model)
  if(not asmlib.IsHere(hdRec)) then
    scrTool:DrawText("Holds Model: Invalid","r")
    scrTool:DrawTextMore(asmlib.GetConcat("  [", gsModeDataB, "]"), "db")
    return
  end
  scrTool:DrawText("Holds Model: Valid","g")
  scrTool:DrawTextMore(asmlib.GetConcat("  [", gsModeDataB, "]"), "db")
  local trEnt    = stTrace.Entity
  local actrad   = self:GetActiveRadius()
  local pointid, pnextid = self:GetPointID()
  local workmode, workname = self:GetWorkingMode()
  local trMID, trModel, trOID, trRLen
  if(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return end
          trModel = trEnt:GetModel()
    local spnflat = self:GetSpawnFlat()
    local igntype = self:GetIgnoreType()
    local trRec   = asmlib.CacheQueryPiece(trModel)
    local nextx, nexty, nextz = self:GetPosOffsets()
    local nextpic, nextyaw, nextrol = self:GetAngOffsets()
    local stSpawn = asmlib.GetEntitySpawn(user,trEnt,stTrace.HitPos,model,pointid,
                      actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(stSpawn) then
      trOID  = stSpawn.TID
      trRLen = math.Round(stSpawn.RLen,2)
    end
    if(asmlib.IsHere(trRec)) then
      trMID = trRec.Size
      trModel = string.GetFileFromFilename(trModel)
    else trModel = asmlib.GetConcat("[", gsNoMD, "]", string.GetFileFromFilename(trModel)) end
  end
  model  = string.GetFileFromFilename(model)
  actrad = math.Round(actrad,2)
  maxrad = asmlib.GetAsmConvar("maxactrad", "FLT")
  scrTool:DrawText("TM: " ..(trModel or gsNoAV),"y")
  scrTool:DrawText("HM: " ..(model   or gsNoAV),"m")
  scrTool:DrawText(asmlib.GetConcat(
    "ID: [", (trMID      or gsNoID), "] " ,(trOID   or gsNoID),
    " >> " , (pointid    or gsNoID), " (" ,(pnextid or gsNoID),
    ") ["  , (hdRec.Size or gsNoID), "]"),"g")
  scrTool:DrawText(asmlib.GetConcat("MaxCL: ", actrad, " < [", maxrad, "]"),"c")
  local txW, txH = scrTool:GetTextScreen()
  local txsX, txsY = scrTool:GetTextLast()
  scrTool:DrawText(asmlib.GetConcat("Work: [", workmode, "] ", workname), "wm")
  scrTool:DrawText("CurAR: "..(trRLen or gsNoAV),"y")
  local nRad = math.Clamp(h - txH  - txsY / 1.2,0,h) / 2
  local cPos = math.Clamp(h - nRad - txsY / 2.5,0,h)
  local xyPs = asmlib.NewXY(cPos, cPos)
  scrTool:DrawCircle(xyPs, math.Clamp(actrad/maxrad,0,1)*nRad, "c","SURF")
  scrTool:DrawCircle(xyPs, nRad, "m")
  scrTool:DrawText("Date: "..asmlib.GetDate(),"w")
  scrTool:DrawText("Time: "..asmlib.GetTime())
  if(trRLen) then scrTool:DrawCircle(xyPs, nRad * math.Clamp(trRLen/maxrad,0,1),"y") end
end

-- Enter `spawnmenu_reload` in the console to reload the panel
function TOOL.BuildCPanel(CPanel)
  asmlib.SetAsmConvar(nil, "flipoverid") -- Reset flip-over mode on pickup
  CPanel:ClearControls(); CPanel:DockPadding(5, 0, 5, 10)
  local drmSkin, sLog = CPanel:GetSkin(), "*TOOL.BuildCPanel"
  local nMaxLin = asmlib.GetAsmConvar("maxlinear","FLT")
  local iMaxDec = asmlib.GetAsmConvar("maxmenupr","INT")
  local sCall, pItem, sName, aData = "_cpan" -- pItem is the current panel created
          CPanel:SetName(language.GetPhrase("tool."..gsToolNameL..".name"))
  pItem = CPanel:Help   (language.GetPhrase("tool."..gsToolNameL..".desc"))

  local pComboPresets = vgui.Create("ControlPresets", CPanel)
        pComboPresets:SetPreset(gsToolNameL)
        pComboPresets:AddOption("Default", asmlib.GetOpVar("STORE_CONVARS"))
        for key, val in pairs(table.GetKeys(asmlib.GetOpVar("STORE_CONVARS"))) do
          pComboPresets:AddConVar(val) end
  CPanel:AddItem(pComboPresets)

  local qPanel = asmlib.CacheQueryTree(); if(not qPanel) then
    asmlib.LogInstance("Panel population empty",sLog); return end
  local makTab = asmlib.GetBuilderNick("PIECES"); if(not asmlib.IsHere(makTab)) then
    asmlib.LogInstance("Missing builder table",sLog); return end
  local pTree  = vgui.Create("DTree", CPanel); if(not pTree) then
    asmlib.LogInstance("Database tree empty",sLog); return end
  pTree:Dock(TOP) -- Initialize to fill left and right bounds
  pTree:SetTall(400) -- Make it quite large
  pTree:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".model"))
  pTree:SetIndentSize(0) -- All track types are closed
  pTree:UpdateColours(drmSkin) -- Apply current skin
  CPanel:AddItem(pTree) -- Register it to the panel
  local defTable = makTab:GetDefinition()
  local tType, tRoot = {}, {Size = 0}
  for iC = 1, qPanel.Size do
    local vRec, bNow = qPanel[iC], true
    local sMod, sTyp, sNam = vRec.M, vRec.T, vRec.N
    if(asmlib.IsModel(sMod)) then
      if(not (asmlib.IsBlank(sTyp) or tType[sTyp])) then
        local pRoot = pTree:AddNode(sTyp) -- No type folder made already
              pRoot:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".type"))
              pRoot.Icon:SetImage(asmlib.ToIcon(defTable.Name))
              pRoot.DoClick = function() asmlib.SetNodeExpand(pRoot) end
              pRoot.Expander.DoClick = function() asmlib.SetNodeExpand(pRoot) end
              pRoot.DoRightClick = function() asmlib.OpenNodeMenu(pRoot) end
              pRoot:UpdateColours(drmSkin)
        tType[sTyp] = {Base = pRoot, Node = {}}
      end -- Reset the primary tree node pointer
      if(tType[sTyp]) then pItem = tType[sTyp].Base else pItem = pTree end
      -- Register the node associated with the track piece when is intended for later
      if(vRec.C and vRec.C.Size > 0) then -- When category for the track type is available
        local tNode = tType[sTyp].Node -- Index the contend for the track type
        for iD = 1, vRec.C.Size do -- Generate the path to the track piece
          local sCat = vRec.C[iD] -- Read the category name
          local tCat = tNode[sCat] -- Index the internal sub-category
          if(tCat) then -- Jump next if already created
            pItem = tCat.Base -- Assume that the category is allocated
            tNode = tCat.Node -- Jump to the next set of base nodes
          else -- Create a new sub-category for the incoming content
            tNode[sCat] = {}; tCat = tNode[sCat] -- Create node info
            pItem = asmlib.SetNodeDirectory(pItem, sCat) -- Create category
            tCat.Base = pItem; tCat.Node = {} -- Allocate node info
            tNode = tCat.Node -- Jump to the allocated set of base nodes
          end -- Create the last needed node regarding pItem
        end -- When the category has at least one element
      else -- Panel cannot categorize the entry add it to the list
        tRoot.Size = tRoot.Size + 1 -- Increment count to avoid calling #
        table.insert(tRoot, iC); bNow = false -- Attach row ID to rooted items
      end -- When needs to be processed now just attach it to the tree
      if(bNow) then asmlib.SetNodeContent(pItem, sNam, sMod) end
      -- SnapReview is ignored because a query must be executed for points count
    else asmlib.LogInstance("Ignoring item "..asmlib.GetReport(sTyp, sNam, sMod),sLog) end
  end
  -- Attach the hanging items to the type root
  for iR = 1, tRoot.Size do
    local iRox = tRoot[iR]
    local vRec = qPanel[iRox]
    local sMod, sTyp, sNam = vRec.M, vRec.T, vRec.N
    asmlib.SetNodeContent(tType[sTyp].Base, sNam, sMod)
    asmlib.LogInstance("Rooting item "..asmlib.GetReport(sTyp, sNam, sMod), sLog)
  end -- Process all the items without category defined
  asmlib.LogInstance("Found items #"..qPanel.Size, sLog)

  -- http://wiki.garrysmod.com/page/Category:DComboBox
  local sName = asmlib.GetAsmConvar("workmode", "NAM")
  local aData = asmlib.GetAsmConvar("workmode", "INT")
  local pComboToolMode = CPanel:ComboBox(language.GetPhrase("tool."..gsToolNameL..".workmode_con"), sName)
        pComboToolMode:SetSortItems(false)
        pComboToolMode:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".workmode"))
        pComboToolMode:UpdateColours(drmSkin)
        pComboToolMode:Dock(TOP) -- Setting tallness gets ignored otherwise
        pComboToolMode:SetTall(22)
        pComboToolMode.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
        for iD = 1, conWorkMode:GetSize() do
          local sW = tostring(conWorkMode:Select(iD) or gsNoAV):lower()
          local sI = asmlib.ToIcon("workmode_"..sW)
          local sT = language.GetPhrase("tool."..gsToolNameL..".workmode."..iD)
          pComboToolMode:AddChoice(sT, iD, (iD == aData), sI)
        end

  local sName = asmlib.GetAsmConvar("physmater", "NAM")
  local pComboPhysType = CPanel:ComboBox(language.GetPhrase("tool."..gsToolNameL..".phytype_con"))
        pComboPhysType:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".phytype"))
        pComboPhysType:SetValue(language.GetPhrase("tool."..gsToolNameL..".phytype_def"))
        pComboPhysType.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
        pComboPhysType:Dock(TOP) -- Setting tallness gets ignored otherwise
        pComboPhysType:SetTall(22)
        pComboPhysType:UpdateColours(drmSkin)

  local pComboPhysName = CPanel:ComboBox(language.GetPhrase("tool."..gsToolNameL..".phyname_con"), sName)
        pComboPhysName:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".phyname"))
        pComboPhysName:SetValue(asmlib.GetEmpty(asmlib.GetAsmConvar("physmater","STR"), nil,
                                language.GetPhrase("tool."..gsToolNameL..".phyname_def")))
        pComboPhysName.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
        pComboPhysName:Dock(TOP) -- Setting tallness gets ignored otherwise
        pComboPhysName:SetTall(22)
        pComboPhysName:UpdateColours(drmSkin)

  local qProperty = asmlib.CacheQueryProperty(); if(not qProperty) then
    asmlib.LogInstance("Property population empty",sLog); return end

  for iP = 1, qProperty.Size do
    local sT, sI = qProperty[iP], asmlib.ToIcon("property_type")
    pComboPhysType:AddChoice(sT, sT, false, sI)
  end

  pComboPhysType.OnSelect = function(pnSelf, nInd, sVal, anyData)
    local qNames = asmlib.CacheQueryProperty(sVal)
    if(qNames) then pComboPhysName:Clear()
      pComboPhysName:SetValue(language.GetPhrase("tool."..gsToolNameL..".phyname_def"))
      for iNam = 1, qNames.Size do
        local sN, sI = qNames[iNam], asmlib.ToIcon("property_name")
        pComboPhysName:AddChoice(sN, sN, false, sI)
      end
    else asmlib.LogInstance("Property type mismatch "..asmlib.GetReport(nInd, sVal), sLog) end
  end

  cvars.RemoveChangeCallback(sName, sName..sCall)
  cvars.AddChangeCallback(sName, function(sV, vO, vN)
    pComboPhysName:SetValue(vN) end, sName..sCall);
  asmlib.LogTable(qProperty, "Property", sLog)

  -- http://wiki.garrysmod.com/page/Category:DTextEntry
  local sName = asmlib.GetAsmConvar("bgskids", "NAM")
  local pText = CPanel:TextEntry(language.GetPhrase("tool."..gsToolNameL..".bgskids_con"), sName)
        pText:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".bgskids"))
        pText:SetText(asmlib.GetEmpty(asmlib.GetAsmConvar("bgskids", "STR"), nil,
                      language.GetPhrase("tool."..gsToolNameL..".bgskids_def")))
        pText:SetEnabled(false); pText:SetTall(22)

  local sName = asmlib.GetAsmConvar("bgskids", "NAM")
  cvars.RemoveChangeCallback(sName, sName..sCall)
  cvars.AddChangeCallback(sName, function(sV, vO, vN)
    pText:SetText(vN); pText:SetValue(vN) end, sName..sCall);
  asmlib.SetNumSlider(CPanel, "mass"    , iMaxDec, 0, asmlib.GetAsmConvar("maxmass"  , "FLT"))
  asmlib.SetNumSlider(CPanel, "activrad", iMaxDec, 0, asmlib.GetAsmConvar("maxactrad", "FLT"))
  asmlib.SetNumSlider(CPanel, "stackcnt", 0      , 0, asmlib.GetAsmConvar("maxstcnt" , "INT"))
  asmlib.SetNumSlider(CPanel, "ghostcnt", 0      , 0, asmlib.GetAsmConvar("maxghcnt" , "INT"))
  asmlib.SetNumSlider(CPanel, "angsnap" , iMaxDec)
  asmlib.SetButton(CPanel, "resetvars")
  local tBAng = { -- Button interactive slider ( angle offsets )
    {N="<>" }, {N="+/-"}, {N="@M"  }, {N="@D"  },
    {N="@45"}, {N="@90"}, {N="@135"}, {N="@180"}
  } -- Use the same initialization table for multiple BIS
  local tBpos = { -- Button interactive slider ( position offsets )
    {N="<>" }, {N="+/-"}, {N="@M"  }, {N="@D"  },
    {N="@25"}, {N="@50"}, {N="@75" }, {N="@100"}
  } -- Use the same initialization table for multiple BIS
  asmlib.SetButtonSlider(CPanel, "nextpic", -gnMaxRot, gnMaxRot, iMaxDec, tBAng)
  asmlib.SetButtonSlider(CPanel, "nextyaw", -gnMaxRot, gnMaxRot, iMaxDec, tBAng)
  asmlib.SetButtonSlider(CPanel, "nextrol", -gnMaxRot, gnMaxRot, iMaxDec, tBAng)
  asmlib.SetButtonSlider(CPanel, "nextx"  , -nMaxLin , nMaxLin , iMaxDec, tBpos)
  asmlib.SetButtonSlider(CPanel, "nexty"  , -nMaxLin , nMaxLin , iMaxDec, tBpos)
  asmlib.SetButtonSlider(CPanel, "nextz"  , -nMaxLin , nMaxLin , iMaxDec, tBpos)
  asmlib.SetNumSlider(CPanel, "forcelim", iMaxDec, 0, asmlib.GetAsmConvar("maxforce" ,"FLT"))
  asmlib.SetCheckBox(CPanel, "weld")
  asmlib.SetCheckBox(CPanel, "nocollide")
  asmlib.SetCheckBox(CPanel, "nocollidew")
  asmlib.SetCheckBox(CPanel, "freeze")
  asmlib.SetCheckBox(CPanel, "ignphysgn")
  asmlib.SetCheckBox(CPanel, "gravity")
  asmlib.SetCheckBox(CPanel, "igntype")
  asmlib.SetCheckBox(CPanel, "spnflat")
  asmlib.SetCheckBox(CPanel, "spawncn")
  asmlib.SetCheckBox(CPanel, "surfsnap")
  asmlib.SetCheckBox(CPanel, "appangfst")
  asmlib.SetCheckBox(CPanel, "applinfst")
  asmlib.SetCheckBox(CPanel, "adviser")
  asmlib.SetCheckBox(CPanel, "pntasist")
  asmlib.SetCheckBox(CPanel, "engunsnap")
  asmlib.SetCheckBox(CPanel, "upspanchor")
  asmlib.LogInstance("Registered as "..asmlib.GetReport(CPanel.Name), sLog)
end

if(CLIENT) then
  -- Enter `spawnmenu_reload` in the console to reload the panel
  local function setupUserSettings(CPanel)
    local sLog = "*TOOL.UserSettings"
    local iMaxDec = asmlib.GetAsmConvar("maxmenupr","INT")
    CPanel:ClearControls(); CPanel:DockPadding(5, 0, 5, 10)
    CPanel:SetName(language.GetPhrase("tool."..gsToolNameL..".utilities_user"))
    CPanel:Help(language.GetPhrase("tool."..gsToolNameL..".client_var"))
    asmlib.SetNumSlider(CPanel, "sizeucs"  , iMaxDec)
    asmlib.SetNumSlider(CPanel, "incsnplin", 0)
    asmlib.SetNumSlider(CPanel, "incsnpang", 0)
    asmlib.SetNumSlider(CPanel, "ghostblnd", iMaxDec)
    asmlib.SetNumSlider(CPanel, "crvturnlm", iMaxDec)
    asmlib.SetNumSlider(CPanel, "crvleanlm", iMaxDec)
    asmlib.SetNumSlider(CPanel, "crvsuprev", iMaxDec)
    asmlib.SetNumSlider(CPanel, "sgradmenu", 0)
    asmlib.SetNumSlider(CPanel, "rtradmenu", iMaxDec)
    asmlib.SetCheckBox(CPanel, "enradmenu")
    asmlib.SetCheckBox(CPanel, "enpntmscr")
    asmlib.SetCheckBox(CPanel, "ioreadall")
    asmlib.LogInstance("Registered as "..asmlib.GetReport(CPanel.Name), sLog)
  end

  local bS, vOut = asmlib.DoAction("TWEAK_PANEL", "Utilities", "User", setupUserSettings)
  if(not bS) then asmlib.LogInstance("User create: "..vOut, sLog) end

  -- Enter `spawnmenu_reload` in the console to reload the panel
  local function setupAdminSettings(CPanel)
    local sLog = "*TOOL.AdminSettings"
    local drmSkin, pItem = CPanel:GetSkin()
    local iMaxDec = asmlib.GetAsmConvar("maxmenupr","INT")
    CPanel:ClearControls(); CPanel:DockPadding(5, 0, 5, 10)
    CPanel:SetName(language.GetPhrase("tool."..gsToolNameL..".utilities_admin"))
    CPanel:Help(language.GetPhrase("tool."..gsToolNameL..".nonrep_var"))
    asmlib.SetNumSlider(CPanel, "logsmax", 0)
    asmlib.SetNumSlider(CPanel, "logsbrs", 0)
    asmlib.SetCheckBox(CPanel, "devmode")
    asmlib.SetCheckBox(CPanel, "exportdb")
    asmlib.SetNumSlider(CPanel, "maxtrmarg", iMaxDec)
    asmlib.SetNumSlider(CPanel, "maxspmarg", iMaxDec)
    asmlib.SetNumSlider(CPanel, "maxmenupr", 0)
    CPanel:ControlHelp(language.GetPhrase("tool."..gsToolNameL..".relica_var"))
    asmlib.SetNumSlider(CPanel, "spawnrate", 0)
    asmlib.SetNumSlider(CPanel, "maxmass"  , iMaxDec)
    asmlib.SetNumSlider(CPanel, "maxlinear", iMaxDec)
    asmlib.SetNumSlider(CPanel, "maxforce" , iMaxDec)
    asmlib.SetNumSlider(CPanel, "maxactrad", iMaxDec)
    asmlib.SetNumSlider(CPanel, "maxstcnt" , 0)
    asmlib.SetNumSlider(CPanel, "maxghcnt" , 0)
    asmlib.SetNumSlider(CPanel, "maxstatts", 0)
    asmlib.SetNumSlider(CPanel, "maxfruse" , 0)
    asmlib.SetNumSlider(CPanel, "dtmessage", iMaxDec)
    asmlib.SetCheckBox(CPanel, "enwiremod")
    asmlib.SetCheckBox(CPanel, "enmultask")
    asmlib.SetCheckBox(CPanel, "enctxmenu")
    asmlib.SetCheckBox(CPanel, "enctxmall")
    asmlib.SetCheckBox(CPanel, "endsvlock")
    asmlib.SetNumSlider(CPanel, "curvefact", iMaxDec)
    asmlib.SetNumSlider(CPanel, "curvsmple", 0)
    asmlib.SetNumSlider(CPanel, "*sbox_max"..gsLimitName, 0)
    asmlib.SetComboBoxList(CPanel, "modedb")
    asmlib.SetComboBoxList(CPanel, "bnderrmod")
    pItem = vgui.Create("DCategoryList", CPanel); if(not IsValid(pItem)) then
      asmlib.LogInstance("Category list invalid", sLog); return end
    CPanel:AddItem(pItem)
    pItem:Dock(TOP); pItem:SetTall(340)
    local sRev = asmlib.GetOpVar("OPSYM_REVISION")
    local tMod, tPan = asmlib.GetOpVar("ARRAY_MODETM"), {}
    local tVar = gsSymDir:Explode(asmlib.GetAsmConvar("timermode","STR"))
    local iD, mkTab = 1, asmlib.GetBuilderID(1)
    while(mkTab) do tPan[iD] = {}
      local vPan, pDef = tPan[iD], mkTab:GetDefinition()
      local tSet = sRev:Explode(tostring(tVar[iD] or ""))
      local sMem = language.GetPhrase("tool."..gsToolNameL..".timermode_mem")
      local pMem = pItem:Add(sMem.." "..pDef.Nick)
            pMem:SetTooltip(sMem.." "..pDef.Nick)
      local pMode = vgui.Create("DComboBox", pItem); if(not IsValid(pMode)) then
        asmlib.LogInstance("Timer mode invalid", sLog); return end
      pMode:Dock(TOP); pMode:SetTall(25)
      pMode:UpdateColours(drmSkin)
      pMode:SetSortItems(false)
      pMode:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".timermode_md"))
      pMode.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
      for iK = 1, #tMod do local sK = tMod[iK]
        local bSel = (tostring(tSet[1]) == sK)
        local sIco = asmlib.ToIcon("timermode_"..sK:lower())
        local sKey = ("tool."..gsToolNameL..".timermode_"..sK:lower())
        pMode:AddChoice(language.GetPhrase(sKey), sK, bSel, sIco)
      end
      local pLife = vgui.Create("DNumSlider", pItem); if(not IsValid(pLife)) then
        asmlib.LogInstance("Record life invalid", sLog); return end
      pLife:Dock(TOP); pLife:SetTall(25)
      pLife:SetMin(0); pLife:SetMax(3600)
      pLife:SetDecimals(iMaxDec)
      pLife:SetValue(tonumber(tSet[2]) or 0)
      pLife:SetDefaultValue(tonumber(tSet[2]) or 0)
      pLife:SizeToContents()
      pLife:SetText(language.GetPhrase("tool."..gsToolNameL..".timermode_lf_con"))
      pLife:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".timermode_lf"))
      local pCler = vgui.Create("DCheckBoxLabel", pItem); if(not IsValid(pCler)) then
        asmlib.LogInstance("Force clear invalid", sLog); return end
      pCler:Dock(TOP); pCler:SetTall(25)
      pCler:SetValue((tonumber(tSet[3]) or 0) ~= 0)
      pCler:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".timermode_rd"))
      pCler:SetText(language.GetPhrase("tool."..gsToolNameL..".timermode_rd_con"))
      local pColl = vgui.Create("DCheckBoxLabel", pItem); if(not IsValid(pColl)) then
        asmlib.LogInstance("Collect invalid", sLog); return end
      pColl:SetValue((tonumber(tSet[4]) or 0) ~= 0)
      pColl:SetTooltip(language.GetPhrase("tool."..gsToolNameL..".timermode_ct"))
      pColl:SetText(language.GetPhrase("tool."..gsToolNameL..".timermode_ct_con"))
      pColl:Dock(TOP); pColl:SetTall(25)
      iD = (iD + 1); mkTab = asmlib.GetBuilderID(iD)
      vPan["MODE"], vPan["LIFE"] = pMode, pLife
      vPan["CLER"], vPan["COLL"] = pCler, pColl
    end
    pItem:UpdateColours(drmSkin)
    pItem:InvalidateLayout(true)
    -- Setup memory configuration export button
    pItem = asmlib.SetButton(CPanel, "timermode_ap")
    pItem.DoClick = function(pnSelf)
      local tTim, sRev = {}, asmlib.GetOpVar("OPSYM_REVISION")
      for iD = 1, #tPan do local vP, tS = tPan[iD], {}
        local pM, pL = vP["MODE"], vP["LIFE"]
        local pC, bG = vP["CLER"], vP["COLL"]
        tS[1] = tostring(pM:GetOptionData(pM:GetSelectedID()) or "")
        tS[2] = tostring(tonumber(pL:GetValue() or 0))
        tS[3] = tostring(pC:GetChecked() and 1 or 0)
        tS[4] = tostring(bG:GetChecked() and 1 or 0)
        tTim[iD] = table.concat(tS, sRev)
      end
      local sTim = table.concat(tTim, gsSymDir)
      asmlib.LogInstance("Memory manager "..asmlib.GetReport(sTim))
      asmlib.SetAsmConvar(nil, "timermode", sTim)
    end
    pItem.DoRightClick = function(pnSelf)
      if(input.IsKeyDown(KEY_LSHIFT)) then
        asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"), asmlib.GetAsmConvar("logsbrs","INT"))
      else
        local fW = asmlib.GetOpVar("FORM_GITWIKI")
        gui.OpenURL(fW:format("Memory-manager-configuration"))
      end
    end
    pItem:Dock(TOP); pItem:SetTall(30)
    -- Setup factory reset variables button
    pItem = asmlib.SetButton(CPanel, "factory_reset")
    pItem.DoClick = function(pnSelf)
      local user = LocalPlayer(); if(not (user and user:IsValid() and user:IsAdmin())) then
        asmlib.LogInstance("Factory reset invalid: "..asmlib.GetReport(user), sLog) return end
      if(asmlib.GetAsmConvar("devmode" ,"BUL")) then
        asmlib.SetAsmConvar(user, "*sbox_max"..gsLimitName,
        asmlib.GetAsmConvar("*sbox_max"..gsLimitName, "DEF"))
        for key, val in pairs(asmlib.GetOpVar("STORE_CONVARS")) do
          asmlib.SetAsmConvar(user, "*"..key, val) end
        asmlib.SetAsmConvar(user, "logsmax"  , asmlib.GetAsmConvar("logsmax"  , "DEF"))
        asmlib.SetAsmConvar(user, "logsbrs"  , asmlib.GetAsmConvar("logsbrs"  , "DEF"))
        asmlib.SetAsmConvar(user, "modedb"   , asmlib.GetAsmConvar("modedb"   , "DEF"))
        asmlib.SetAsmConvar(user, "devmode"  , asmlib.GetAsmConvar("devmode"  , "DEF"))
        asmlib.SetAsmConvar(user, "maxtrmarg", asmlib.GetAsmConvar("maxtrmarg", "DEF"))
        asmlib.SetAsmConvar(user, "maxspmarg", asmlib.GetAsmConvar("maxspmarg", "DEF"))
        asmlib.SetAsmConvar(user, "maxmenupr", asmlib.GetAsmConvar("maxmenupr", "DEF"))
        asmlib.SetAsmConvar(user, "timermode", asmlib.GetAsmConvar("timermode", "DEF"))
        asmlib.SetAsmConvar(user, "maxmass"  , asmlib.GetAsmConvar("maxmass"  , "DEF"))
        asmlib.SetAsmConvar(user, "maxlinear", asmlib.GetAsmConvar("maxlinear", "DEF"))
        asmlib.SetAsmConvar(user, "maxforce" , asmlib.GetAsmConvar("maxforce" , "DEF"))
        asmlib.SetAsmConvar(user, "maxactrad", asmlib.GetAsmConvar("maxactrad", "DEF"))
        asmlib.SetAsmConvar(user, "maxstcnt" , asmlib.GetAsmConvar("maxstcnt" , "DEF"))
        asmlib.SetAsmConvar(user, "enwiremod", asmlib.GetAsmConvar("enwiremod", "DEF"))
        asmlib.SetAsmConvar(user, "enmultask", asmlib.GetAsmConvar("enmultask", "DEF"))
        asmlib.SetAsmConvar(user, "enctxmenu", asmlib.GetAsmConvar("enctxmenu", "DEF"))
        asmlib.SetAsmConvar(user, "enctxmall", asmlib.GetAsmConvar("enctxmall", "DEF"))
        asmlib.SetAsmConvar(user, "endsvlock", asmlib.GetAsmConvar("endsvlock", "DEF"))
        asmlib.SetAsmConvar(user, "ioreadall", asmlib.GetAsmConvar("ioreadall", "DEF"))
        asmlib.SetAsmConvar(user, "curvefact", asmlib.GetAsmConvar("curvefact", "DEF"))
        asmlib.SetAsmConvar(user, "curvsmple", asmlib.GetAsmConvar("curvsmple", "DEF"))
        asmlib.SetAsmConvar(user, "crvsuprev", asmlib.GetAsmConvar("crvsuprev", "DEF"))
        asmlib.SetAsmConvar(user, "spawnrate", asmlib.GetAsmConvar("spawnrate", "DEF"))
        asmlib.SetAsmConvar(user, "bnderrmod", asmlib.GetAsmConvar("bnderrmod", "DEF"))
        asmlib.SetAsmConvar(user, "maxfruse" , asmlib.GetAsmConvar("maxfruse" , "DEF"))
        asmlib.SetAsmConvar(user, "dtmessage", asmlib.GetAsmConvar("dtmessage", "DEF"))
        asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"), asmlib.GetAsmConvar("logsbrs","INT"))
        asmlib.LogInstance("Factory reset complete", sLog)
      end
    end
    pItem.DoRightClick = function(pnSelf)
      local fW = asmlib.GetOpVar("FORM_GITWIKI")
      gui.OpenURL(fW:format("Factory-reset"))
    end
    pItem:Dock(TOP); pItem:SetTall(30)
    asmlib.LogInstance("Registered as "..asmlib.GetReport(CPanel.Name), sLog)
  end

  local bS, vOut = asmlib.DoAction("TWEAK_PANEL", "Utilities", "Admin", setupAdminSettings)
  if(not bS) then asmlib.LogInstance("Admin create: "..vOut, sLog) end
end
