---------------- Localizing Libraries ---------------
local type                             = type
local pcall                            = pcall
local pairs                            = pairs
local print                            = print
local Angle                            = Angle
local Color                            = Color
local Vector                           = Vector
local IsValid                          = IsValid
local EntityID                         = Entity
local tostring                         = tostring
local tonumber                         = tonumber
local istable                          = istable
local GetConVar                        = GetConVar
local LocalPlayer                      = LocalPlayer
local SetClipboardText                 = SetClipboardText
local osDate                           = os and os.date
local guiOpenURL                       = gui and gui.OpenURL
local netSend                          = net and net.Send
local netStart                         = net and net.Start
local netReceive                       = net and net.Receive
local netWriteUInt                     = net and net.WriteUInt
local netWriteBool                     = net and net.WriteBool
local netWriteAngle                    = net and net.WriteAngle
local netWriteEntity                   = net and net.WriteEntity
local netWriteVector                   = net and net.WriteVector
local vguiCreate                       = vgui and vgui.Create
local stringUpper                      = string and string.upper
local mathAbs                          = math and math.abs
local mathMin                          = math and math.min
local mathMax                          = math and math.max
local mathSqrt                         = math and math.sqrt
local mathClamp                        = math and math.Clamp
local mathAtan2                        = math and math.atan2
local mathRound                        = math and math.Round
local gameGetWorld                     = game and game.GetWorld
local tableInsert                      = table and table.insert
local tableRemove                      = table and table.remove
local tableEmpty                       = table and table.Empty
local tableGetKeys                     = table and table.GetKeys
local tableConcat                      = table and table.concat
local hookAdd                          = hook and hook.Add
local inputIsKeyDown                   = input and input.IsKeyDown
local cleanupRegister                  = cleanup and cleanup.Register
local stringGetFileName                = string and string.GetFileFromFilename
local surfaceScreenWidth               = surface and surface.ScreenWidth
local surfaceScreenHeight              = surface and surface.ScreenHeight
local languageAdd                      = language and language.Add
local languageGetPhrase                = language and language.GetPhrase
local concommandAdd                    = concommand and concommand.Add
local cvarsAddChangeCallback           = cvars and cvars.AddChangeCallback
local cvarsRemoveChangeCallback        = cvars and cvars.RemoveChangeCallback
local duplicatorRegisterEntityModifier = duplicator and duplicator.RegisterEntityModifier

----------------- TOOL Global Parameters ----------------
--- Because VEC[1] is actually faster than VEC.X
--- Store a pointer to our module
local asmlib = trackasmlib; if(not asmlib) then -- Module present
  ErrorNoHalt("TOOL: Track assembly tool module fail!\n"); return end

if(not asmlib.IsInit()) then -- Make sure the module is initialized
  ErrorNoHalt("TOOL: Track assembly tool not initialized!\n"); return end

--- Global References
local gtLogs      = {"TOOL"}
local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gsDataRoot  = asmlib.GetOpVar("DIRPATH_BAS")
local gsDataSet   = asmlib.GetOpVar("DIRPATH_SET")
local gnMaxRot    = asmlib.GetOpVar("MAX_ROTATION")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")
local gsModeDataB = asmlib.GetOpVar("MODE_DATABASE")
local gsLimitName = asmlib.GetOpVar("CVAR_LIMITNAME")
local gsUndoPrefN = asmlib.GetOpVar("NAME_INIT"):gsub("^%l", stringUpper)..": "
local gsNoID      = asmlib.GetOpVar("MISS_NOID") -- No such ID
local gsNoAV      = asmlib.GetOpVar("MISS_NOAV") -- Not available
local gsNoMD      = asmlib.GetOpVar("MISS_NOMD") -- No model
local gsNoBS      = asmlib.GetOpVar("MISS_NOBS") -- No Body-group skin
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVISION")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gsNoAnchor  = gsNoID..gsSymRev..gsNoMD
local gnRatio     = asmlib.GetOpVar("GOLDEN_RATIO")
local conPalette  = asmlib.GetContainer("COLORS_LIST")
local conWorkMode = asmlib.GetContainer("WORK_MODE")
local conElements = asmlib.GetContainer("LIST_VGUI")
local varLanguage = GetConVar("gmod_language")

if(not asmlib.ProcessDSV()) then -- Default tab delimiter
  local sDSV = gsDataRoot..gsDataSet..gsLibName.."_dsv.txt"
  asmlib.LogInstance("Processing DSV fail <"..sDSV..">")
end

cleanupRegister(gsLimitName)

TOOL.ClientConVar = {
  [ "weld"       ] = 1,
  [ "mass"       ] = 25000,
  [ "model"      ] = "models/props_phx/trains/tracks/track_1x.mdl",
  [ "nextx"      ] = 0,
  [ "nexty"      ] = 0,
  [ "nextz"      ] = 0,
  [ "freeze"     ] = 1,
  [ "anchor"     ] = gsNoAnchor,
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
  [ "flipoverid" ] = ""
}

if(CLIENT) then
  languageAdd("tool."..gsToolNameL..".category", "Construction")

  -- https://wiki.facepunch.com/gmod/Tool_Information_Display
  TOOL.Information = asmlib.GetToolInformation()

  concommandAdd(gsToolPrefL.."openframe", asmlib.GetActionCode("OPEN_FRAME"))
  concommandAdd(gsToolPrefL.."openextdb", asmlib.GetActionCode("OPEN_EXTERNDB"))

  netReceive(gsLibName.."SendDeleteGhosts"  , asmlib.GetActionCode("CLEAR_GHOSTS"))
  netReceive(gsLibName.."SendIntersectClear", asmlib.GetActionCode("CLEAR_RELATION"))
  netReceive(gsLibName.."SendIntersectRelate", asmlib.GetActionCode("CREATE_RELATION"))
  netReceive(gsLibName.."SendCreateCurveNode", asmlib.GetActionCode("CREATE_CURVE_NODE"))
  netReceive(gsLibName.."SendUpdateCurveNode", asmlib.GetActionCode("UPDATE_CURVE_NODE"))
  netReceive(gsLibName.."SendDeleteCurveNode", asmlib.GetActionCode("DELETE_CURVE_NODE"))
  netReceive(gsLibName.."SendDeleteAllCurveNode", asmlib.GetActionCode("DELETE_ALL_CURVE_NODE"))

  hookAdd("Think", gsToolPrefL.."update_ghosts", asmlib.GetActionCode("DRAW_GHOSTS"))
  hookAdd("PreDrawHalos", gsToolPrefL.."update_contextval", asmlib.GetActionCode("UPDATE_CONTEXTVAL"))
  hookAdd("PostDrawHUD", gsToolPrefL.."radial_menu_draw", asmlib.GetActionCode("DRAW_RADMENU"))
  hookAdd("PostDrawHUD", gsToolPrefL.."physgun_drop_draw", asmlib.GetActionCode("DRAW_PHYSGUN"))
  hookAdd("PlayerBindPress", gsToolPrefL.."player_bind_press", asmlib.GetActionCode("BIND_PRESS"))
  hookAdd("OnContextMenuOpen", gsToolPrefL.."ctxmenu_open", asmlib.GetActionCode("CTXMENU_OPEN"))
  hookAdd("OnContextMenuClose", gsToolPrefL.."ctxmenu_close", asmlib.GetActionCode("CTXMENU_CLOSE"))

  concommandAdd(gsToolPrefL.."resetvars",
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
  local varEn   = asmlib.GetAsmConvar("enmultask", "OBJ")
  local gbMen, svName = varEn:GetBool(), varEn:GetName()
  cvarsRemoveChangeCallback(svName, svName..vsHash)
  cvarsAddChangeCallback(svName, function(sV, vO, vN)
    gbMen = ((tonumber(vN) or 0) ~= 0) end, svName..vsHash)
  hookAdd("Think", gsToolPrefL.."think_task", function() poQueue:Work():Next(gbMen) end)
  hookAdd("PlayerDisconnected", gsToolPrefL.."player_quit", asmlib.GetActionCode("PLAYER_QUIT"))
  hookAdd("PhysgunDrop", gsToolPrefL.."physgun_drop_snap", asmlib.GetActionCode("PHYSGUN_DROP"))
  duplicatorRegisterEntityModifier(gsToolPrefL.."dupe_phys_set",asmlib.GetActionCode("DUPE_PHYS_SETTINGS"))
end

TOOL.Name       = languageGetPhrase and languageGetPhrase("tool."..gsToolNameL..".name")
TOOL.Category   = languageGetPhrase and languageGetPhrase("tool."..gsToolNameL..".category")
TOOL.Command    = nil -- Command on click (nil for default)
TOOL.ConfigName = nil -- Configure file name (nil for default)

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

function TOOL:ApplyAngularFirst()
  return (self:GetClientNumber("appangfst", 0) ~= 0)
end

function TOOL:GetRadialMenu()
  return (self:GetClientNumber("enradmenu", 0) ~= 0)
end

function TOOL:GetRadialSegm()
  return mathClamp(self:GetClientNumber("sgradmenu", 1), 1, 16)
end

function TOOL:GetRadialAngle()
  return mathClamp(self:GetClientNumber("rtradmenu", 0), -gnMaxRot, gnMaxRot)
end

function TOOL:ApplyLinearFirst()
  return (self:GetClientNumber("applinfst", 0) ~= 0)
end

function TOOL:GetContextMenuAll()
  return asmlib.GetAsmConvar("enctxmall", "BUL")
end

function TOOL:GetModel()
  return tostring(self:GetClientInfo("model") or "")
end

function TOOL:GetStackCount()
  return mathClamp(self:GetClientNumber("stackcnt", 0), 0, asmlib.GetAsmConvar("maxstcnt", "INT"))
end

function TOOL:GetSpawnRate()
  return asmlib.GetAsmConvar("spawnrate", "INT")
end

function TOOL:GetMass()
  return mathClamp(self:GetClientNumber("mass", 0), 0, asmlib.GetAsmConvar("maxmass","FLT"))
end

function TOOL:GetSizeUCS()
  return mathClamp(self:GetClientNumber("sizeucs", 0), 0, asmlib.GetAsmConvar("maxlinear","FLT"))
end

function TOOL:GetDeveloperMode()
  return asmlib.GetAsmConvar("devmode", "BUL")
end

function TOOL:GetPosOffsets()
  local nMaxLin = asmlib.GetAsmConvar("maxlinear","FLT")
  return mathClamp(self:GetClientNumber("nextx", 0), -nMaxLin, nMaxLin),
         mathClamp(self:GetClientNumber("nexty", 0), -nMaxLin, nMaxLin),
         mathClamp(self:GetClientNumber("nextz", 0), -nMaxLin, nMaxLin)
end

function TOOL:GetAngOffsets()
  return mathClamp(self:GetClientNumber("nextpic", 0), -gnMaxRot, gnMaxRot),
         mathClamp(self:GetClientNumber("nextyaw", 0), -gnMaxRot, gnMaxRot),
         mathClamp(self:GetClientNumber("nextrol", 0), -gnMaxRot, gnMaxRot)
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
  return mathClamp(self:GetClientNumber("ghostcnt", 0), 0, asmlib.GetAsmConvar("maxghcnt", "INT"))
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

function TOOL:GetLogFile()
  return asmlib.GetAsmConvar("logfile", "BUL")
end

function TOOL:GetAdviser()
  return (self:GetClientNumber("adviser", 0) ~= 0)
end

function TOOL:GetPointID()
  return self:GetClientNumber("pointid", 1), self:GetClientNumber("pnextid", 2)
end

function TOOL:GetActiveRadius()
  return mathClamp(self:GetClientNumber("activrad", 0), 0, asmlib.GetAsmConvar("maxactrad", "FLT"))
end

function TOOL:GetAngSnap()
  return mathClamp(self:GetClientNumber("angsnap", 0), 0, gnMaxRot)
end

function TOOL:GetForceLimit()
  return mathClamp(self:GetClientNumber("forcelim", 0), 0, asmlib.GetAsmConvar("maxforce" ,"FLT"))
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
  return (mathClamp(self:GetClientNumber("maxstatts", 0), 0, 10))
end

function TOOL:GetGhostFade()
  return (mathClamp(self:GetClientNumber("ghostblnd", 0), 0, 1))
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
  asmlib.LogInstance("("..nDir..","..tostring(bNxt)..") Success",gtLogs)
  return pointid, pnextid
end

function TOOL:IntersectClear(bMute)
  local user = self:GetOwner()
  local stRay = asmlib.IntersectRayRead(user, "relate")
  if(stRay) then asmlib.IntersectRayClear(user, "relate")
    if(SERVER) then local ryEnt, sRel = stRay.Ent
      netStart(gsLibName.."SendIntersectClear"); netWriteEntity(user); netSend(user)
      if(ryEnt and ryEnt:IsValid()) then
        asmlib.UpdateColor(ryEnt, "intersect", "ry", false)
        sRel = ryEnt:EntIndex()..gsSymRev..stringGetFileName(ryEnt:GetModel()) end
      if(not bMute) then sRel = (sRel and (": "..tostring(sRel)) or "")
        asmlib.LogInstance("Relation cleared <"..sRel..">",gtLogs)
        asmlib.Notify(user,"Intersect relation clear"..sRel.." !","CLEANUP")
      end -- Make sure to delete the relation on both client and server
    end
  end; return true
end

function TOOL:IntersectRelate(oPly, oEnt, vHit)
  self:IntersectClear(true) -- Clear intersect related player on new relation
  local stRay = asmlib.IntersectRayCreate(oPly, oEnt, vHit, "relate")
  if(not stRay) then -- Create/update the ray in question
    asmlib.LogInstance("Update fail",gtLogs); return false end
  if(SERVER) then -- Only the server is allowed to define relation ray
    netStart(gsLibName.."SendIntersectRelate")
    netWriteEntity(oEnt); netWriteVector(vHit); netWriteEntity(oPly); netSend(oPly)
    local sRel = oEnt:EntIndex()..gsSymRev..stringGetFileName(oEnt:GetModel())
    asmlib.Notify(oPly,"Intersect relation set: "..sRel.." !","UNDO")
    asmlib.UpdateColor(oEnt, "intersect", "ry", true)
  end return true
end

function TOOL:IntersectSnap(trEnt, vHit, stSpawn, bMute)
  local pointid, pnextid = self:GetPointID()
  local user, model = self:GetOwner(), self:GetModel()
  if(not asmlib.IntersectRayCreate(user, trEnt, vHit, "origin")) then
    asmlib.LogInstance("Failed updating ray",gtLogs); return nil end
  local xx, x1, x2, stRay1, stRay2 = asmlib.IntersectRayHash(user, "origin", "relate")
  if(not xx) then if(bMute) then return nil
    else asmlib.Notify(user, "Define intersection relation !", "GENERIC")
      asmlib.LogInstance("Active ray mismatch",gtLogs); return nil end
  end
  local mx, o1, o2 = asmlib.IntersectRayModel(model, pointid, pnextid)
  if(not mx) then if(bMute) then return nil
    else asmlib.Notify(user, "Model intersection mismatch !", "ERROR")
      asmlib.LogInstance("Model ray mismatch",gtLogs); return nil end
  end
  local aOrg, vx, vy, vz = stSpawn.OAng, stSpawn.PNxt:Unpack()
  if(self:ApplyAngularFirst()) then aOrg = stRay1.Diw end
  mx:Rotate(stSpawn.SAng); mx:Mul(-1) -- Translate entity local intersection to world
  stSpawn.SPos:Set(mx); stSpawn.SPos:Add(xx); -- Update spawn position with the ray intersection
  local cx, cy, cz = aOrg:Forward(), aOrg:Right(), aOrg:Up()
  if(self:ApplyLinearFirst()) then
    local dx = Vector(); dx:Set(o1); dx:Rotate(stSpawn.SAng)
          dx:Add(stSpawn.SPos); dx:Sub(stRay1.Orw)
    local dy = Vector(); dy:Set(o2); dy:Rotate(stSpawn.SAng)
          dy:Add(stSpawn.SPos); dy:Sub(stRay2.Orw)
    local dz = 0.5 * (stRay2.Orw - stRay1.Orw)
    local lx = mathAbs(dx:Dot(aOrg:Forward()))
    local ly = mathAbs(dy:Dot(aOrg:Right()))
    local lz = mathAbs(dz:Dot(aOrg:Up()))
    vx, vy, vz = mathClamp(vx, -lx, lx), mathClamp(vy, -ly, ly), mathClamp(vz, -lz, lz)
  end; cx:Mul(vx); cy:Mul(vy); cz:Mul(vz)
  stSpawn.SPos:Add(cx); stSpawn.SPos:Add(cy); stSpawn.SPos:Add(cz)
  return xx, x1, x2, stRay1, stRay2
end

function TOOL:ClearAnchor(bMute)
  local user = self:GetOwner()
  local siAnc, svEnt = self:GetAnchor()
  if(CLIENT) then return false end; self:ClearObjects()
  asmlib.SetAsmConvar(user,"anchor",gsNoAnchor)
  if(svEnt and svEnt:IsValid() and not svEnt:IsWorld()) then
    asmlib.UpdateColor(svEnt, "anchor", "an", false) end
  if(not bMute) then -- Notify the user when anchor is cleared
    asmlib.Notify(user,"Anchor: Cleaned "..siAnc.." !","CLEANUP") end
  asmlib.LogInstance("Cleared "..asmlib.GetReport(bMute),gtLogs); return true
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
    local trEnt = gameGetWorld()
    local phEnt = trEnt:GetPhysicsObject()
    local sAnchor = "0"..gsSymRev.."worldspawn.mdl"
    self:SetObject(1,trEnt,stTrace.HitPos,phEnt,stTrace.PhysicsBone,stTrace.HitNormal)
    asmlib.SetAsmConvar(user,"anchor",sAnchor)
    asmlib.Notify(user,"Anchor: Set "..sAnchor.." !","UNDO")
    asmlib.LogInstance("(WORLD) Set "..asmlib.GetReport(sAnchor),gtLogs)
  else
    local trEnt = stTrace.Entity; if(not (trEnt and trEnt:IsValid())) then
      asmlib.LogInstance("Trace no entity",gtLogs); return false end
    local phEnt = trEnt:GetPhysicsObject(); if(not (phEnt and phEnt:IsValid())) then
      asmlib.LogInstance("Trace no physics",gtLogs); return false end
    local sAnchor = trEnt:EntIndex()..gsSymRev..stringGetFileName(trEnt:GetModel())
    asmlib.UpdateColor(trEnt, "anchor", "an", true)
    self:SetObject(1,trEnt,stTrace.HitPos,phEnt,stTrace.PhysicsBone,stTrace.HitNormal)
    asmlib.SetAsmConvar(user,"anchor",sAnchor)
    asmlib.Notify(user,"Anchor: Set "..sAnchor.." !","UNDO")
    asmlib.LogInstance("(PROP) Set "..asmlib.GetReport(sAnchor),gtLogs)
  end; return true
end

function TOOL:GetAnchor()
  local svEnt = self:GetEnt(1)
  local siAnc = (self:GetClientInfo("anchor") or gsNoAnchor)
  if(svEnt) then
    if(not svEnt:IsWorld() and
       not svEnt:IsValid()) then svEnt = nil end
  else svEnt = nil end
  return siAnc, svEnt
end

function TOOL:GetWorkingMode()
  local nWork = self:GetClientNumber("workmode", 0)
  local cWork = mathClamp(nWork or 0, 1, conWorkMode:GetSize())
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
    return mathMin(ghostcnt, mathMax(stackcnt, 1))
  elseif(workmode == 2) then -- Intersection. Force lower bound here
    return mathMin(ghostcnt, 1) -- Force lower bound one otherwise ghosts
  elseif(workmode == 3 or workmode == 5) then -- Track curving interpolation
    return (stackcnt > 0 and mathMin(stackcnt, ghostcnt) or ghostcnt)
  elseif(workmode == 4) then local tArr = self:GetFlipOver() -- Read flip array
    return mathMin(ghostcnt, (tArr and #tArr or 1)) -- Disable via ghosts count
  end; return 0
end

function TOOL:GetStatus(stTr,vMsg,hdEnt)
  local iMaxlog = asmlib.GetOpVar("LOG_MAXLOGS")
  if(iMaxlog <= 0) then return "Status N/A" end
  local user, sDelim  = self:GetOwner(), "\n"
  local iCurLog = asmlib.GetOpVar("LOG_CURLOGS")
  local bFleLog = asmlib.IsFlag("en_logging_file")
  local sSpace  = (" "):rep(6 + tostring(iMaxlog):len())
  local workmode, workname = self:GetWorkingMode()
  local siAnc  , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local nextx  , nexty   , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw , nextrol = self:GetAngOffsets()
  local hdModel, trModel , trRec   = self:GetModel()
  local hdRec = asmlib.CacheQueryPiece(hdModel)
  if(stTr and stTr.Entity and stTr.Entity:IsValid()) then
    trModel = stTr.Entity:GetModel()
    trRec   = asmlib.CacheQueryPiece(trModel)
  end
  local sDu = ""
        sDu = sDu..tostring(vMsg)..sDelim
        sDu = sDu..sSpace.."Dumping logs state:"..sDelim
        sDu = sDu..sSpace.."  LogFile:        <"..tostring(bFleLog)..">"..sDelim
        sDu = sDu..sSpace.."  LogsMax:        <"..tostring(iMaxlog)..">"..sDelim
        sDu = sDu..sSpace.."  LogsCur:        <"..tostring(iCurLog)..">"..sDelim
        sDu = sDu..sSpace.."  MaxProps:       <"..tostring(GetConVar("sbox_maxprops"):GetInt())..">"..sDelim
        sDu = sDu..sSpace.."  MaxTrack:       <"..tostring(GetConVar("sbox_max"..gsLimitName):GetInt())..">"..sDelim
        sDu = sDu..sSpace.."Dumping player keys:"..sDelim
        sDu = sDu..sSpace.."  Player:         "..tostring(user):gsub("Player%s","")..sDelim
        sDu = sDu..sSpace.."  IN.USE:         <"..tostring(user:KeyDown(IN_USE))..">"..sDelim
        sDu = sDu..sSpace.."  IN.DUCK:        <"..tostring(user:KeyDown(IN_DUCK))..">"..sDelim
        sDu = sDu..sSpace.."  IN.SPEED:       <"..tostring(user:KeyDown(IN_SPEED))..">"..sDelim
        sDu = sDu..sSpace.."  IN.RELOAD:      <"..tostring(user:KeyDown(IN_RELOAD))..">"..sDelim
        sDu = sDu..sSpace.."  IN.SCORE:       <"..tostring(user:KeyDown(IN_SCORE))..">"..sDelim
        sDu = sDu..sSpace.."Dumping trace data state:"..sDelim
        sDu = sDu..sSpace.."  Trace:          <"..tostring(stTr)..">"..sDelim
        sDu = sDu..sSpace.."  TR.Hit:         <"..tostring(stTr and stTr.Hit or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  TR.HitW:        <"..tostring(stTr and stTr.HitWorld or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  TR.ENT:         <"..tostring(stTr and stTr.Entity or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  TR.Model:       <"..tostring(trModel or gsNoAV)..">["..tostring(trRec and trRec.Size or gsNoID).."]"..sDelim
        sDu = sDu..sSpace.."  TR.File:        <"..tostring(trModel and stringGetFileName(trModel) or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."Dumping console variables state:"..sDelim
        sDu = sDu..sSpace.."  HD.Workmode:    ["..tostring(workmode or gsNoAV).."]<"..tostring(workname or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  HD.Entity:      {"..tostring(hdEnt or gsNoAV).."}"..sDelim
        sDu = sDu..sSpace.."  HD.Model:       <"..tostring(hdModel or gsNoAV)..">["..tostring(hdRec and hdRec.Size or gsNoID).."]"..sDelim
        sDu = sDu..sSpace.."  HD.File:        <"..tostring(hdModel and stringGetFileName(hdModel) or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  HD.ModDataBase: <"..gsModeDataB..","..tostring(asmlib.GetAsmConvar("modedb" ,"STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.Anchor:      {"..tostring(anEnt or gsNoAV).."}<"..tostring(siAnc)..">"..sDelim
        sDu = sDu..sSpace.."  HD.PointID:     ["..tostring(pointid).."] >> ["..tostring(pnextid).."]"..sDelim
        sDu = sDu..sSpace.."  HD.AngOffsets:  ["..tostring(nextx)..","..tostring(nexty)..","..tostring(nextz).."]"..sDelim
        sDu = sDu..sSpace.."  HD.PosOffsets:  ["..tostring(nextpic)..","..tostring(nextyaw)..","..tostring(nextrol).."]"..sDelim
        sDu = sDu..sSpace.."  HD.Weld:        <"..tostring(self:GetWeld())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Mass:        <"..tostring(self:GetMass())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Freeze:      <"..tostring(self:GetFreeze())..">"..sDelim
        sDu = sDu..sSpace.."  HD.YawSnap:     <"..tostring(self:GetAngSnap())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Gravity:     <"..tostring(self:GetGravity())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Adviser:     <"..tostring(self:GetAdviser())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ForceLimit:  <"..tostring(self:GetForceLimit())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Elevation:   <"..tostring(self:GetElevation())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ExportDB:    <"..tostring(self:GetExportDB())..">"..sDelim
        sDu = sDu..sSpace.."  HD.NoCollide:   <"..tostring(self:GetNoCollide())..">"..sDelim
        sDu = sDu..sSpace.."  HD.NoCollideW:  <"..tostring(self:GetNocollideWorld())..">"..sDelim
        sDu = sDu..sSpace.."  HD.UpSpAnchor:  <"..tostring(self:GetUpSpawnAnchor())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SpawnFlat:   <"..tostring(self:GetSpawnFlat())..">"..sDelim
        sDu = sDu..sSpace.."  HD.IgnoreType:  <"..tostring(self:GetIgnoreType())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SurfSnap:    <"..tostring(self:GetSurfaceSnap())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SpawnCen:    <"..tostring(self:GetSpawnCenter())..">"..sDelim
        sDu = sDu..sSpace.."  HD.AppAngular:  <"..tostring(self:ApplyAngularFirst())..">"..sDelim
        sDu = sDu..sSpace.."  HD.AppLinear:   <"..tostring(self:ApplyLinearFirst())..">"..sDelim
        sDu = sDu..sSpace.."  HD.EnCxMenuAll: <"..tostring(self:GetContextMenuAll())..">"..sDelim
        sDu = sDu..sSpace.."  HD.PntAssist:   <"..tostring(self:GetPointAssist())..">"..sDelim
        sDu = sDu..sSpace.."  HD.StackCnt:    <"..tostring(self:GetStackCount())..">"..sDelim
        sDu = sDu..sSpace.."  HD.GhostsCnt:   <"..tostring(self:GetGhostsCount())..">"..sDelim
        sDu = sDu..sSpace.."  HD.PhysMeter:   <"..tostring(self:GetPhysMeterial())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ActRadius:   <"..tostring(self:GetActiveRadius())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SkinBG:      <"..tostring(self:GetBodyGroupSkin())..">"..sDelim
        sDu = sDu..sSpace.."  HD.StackAtempt: <"..tostring(self:GetStackAttempts())..">"..sDelim
        sDu = sDu..sSpace.."  HD.IgnorePG:    <"..tostring(self:GetIgnorePhysgun())..">"..sDelim
        sDu = sDu..sSpace.."  HD.TimerMode:   <"..tostring(asmlib.GetAsmConvar("timermode","STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.EnableEWire: <"..tostring(asmlib.GetAsmConvar("enwiremod","BUL"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.EnableMTask: <"..tostring(asmlib.GetAsmConvar("enmultask","BUL"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.DevelopMode: <"..tostring(asmlib.GetAsmConvar("devmode"  ,"BUL"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxMass:     <"..tostring(asmlib.GetAsmConvar("maxmass"  ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxLinear:   <"..tostring(asmlib.GetAsmConvar("maxlinear","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxForce:    <"..tostring(asmlib.GetAsmConvar("maxforce" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxARadius:  <"..tostring(asmlib.GetAsmConvar("maxactrad","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxStackCnt: <"..tostring(asmlib.GetAsmConvar("maxstcnt" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.BoundErrMod: <"..tostring(asmlib.GetAsmConvar("bnderrmod","STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxFrequent: <"..tostring(asmlib.GetAsmConvar("maxfruse" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxTrMargin: <"..tostring(asmlib.GetAsmConvar("maxtrmarg","FLT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxSpMargin: <"..tostring(asmlib.GetAsmConvar("maxspmarg","FLT"))..">"..sDelim
  if(hdEnt and hdEnt:IsValid()) then hdEnt:Remove() end
  return sDu
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
      local eID = EntityID(tF[iD])
      local bID = (not asmlib.IsOther(eID))
      local bMR = eID:GetNWBool(gsToolPrefL.."flipover")
      if(bID and bMR) then tF[iD] = eID else tF[iD] = nil
        if(SERVER and not bMute) then
          local sR, sE = asmlib.GetReport(iD, eID, bID, bMR), tostring(tF[iD])
          asmlib.LogInstance("Flip over mismatch ID "..sR, gtLogs)
          asmlib.Notify(user, "Flip over mismatch ID ["..sE.."] !", "GENERIC")
        end
      end
    end
  end
  -- Convert to number as other methods use the number data
  return tF, nF -- Return the table and elements count
end

function TOOL:SetFlipOver(trEnt)
  if(CLIENT) then return nil end
  if(asmlib.IsOther(trEnt)) then return nil end
  local trMod, user = trEnt:GetModel(), self:GetOwner()
  local trRec = asmlib.CacheQueryPiece(trMod)
  if(not asmlib.IsHere(trRec)) then
    asmlib.Notify(user,"Flip over <"..trMod.."> not piece !","ERROR")
    asmlib.LogInstance("Flip over <"..trMod.."> not piece",gtLogs)
    return nil -- Just disable overall flipping for the other models
  end
  local sYm = asmlib.GetOpVar("OPSYM_SEPARATOR")
  local iID, bBr = trEnt:EntIndex(), false
  local tF, nF = self:GetFlipOver()
  if(nF <= 0) then tF = {} -- Create table
  else -- Remove entity from the convar
    for iD = 1, nF do nID = tF[iD]
      if(nID == iID) then bBr = true
        local eID = EntityID(nID)
        asmlib.UpdateColor(eID, "flipover", "fo", false)
        tableRemove(tF, iD); break
      end
    end
  end
  if(not bBr) then tableInsert(tF, tostring(iID))
    asmlib.UpdateColor(trEnt, "flipover", "fo", true)
  end
  asmlib.SetAsmConvar(user, "flipoverid", tableConcat(tF, sYm))
end

function TOOL:ClearFlipOver(bMute)
  local user = self:GetOwner()
  local tF, nF = self:GetFlipOver()
  for iD = 1, nF do local eID = EntityID(tF[iD])
    asmlib.UpdateColor(eID, "flipover", "fo", false)
  end; asmlib.SetAsmConvar(user, "flipoverid", "")
  if(not bMute) then
    asmlib.LogInstance("Flip over cleared", gtLogs)
    asmlib.Notify(user,"Flip over cleared !","CLEANUP")
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
    asmlib.LogInstance(self:GetStatus(stTrace,"Model <"..sModel.."> not piece"),gtLogs); return false end
  local user = self:GetOwner()
  local pointid, pnextid = self:GetPointID()
        pointid, pnextid = asmlib.SnapReview(pointid, pnextid, trRec.Size)
  asmlib.Notify(user,"Model: "..stringGetFileName(sModel).." selected !","UNDO")
  asmlib.SetAsmConvar(user,"pointid", pointid)
  asmlib.SetAsmConvar(user,"pnextid", pnextid)
  asmlib.SetAsmConvar(user, "model" , sModel)
  asmlib.LogInstance("Success <"..sModel..">",gtLogs); return true
end

--[[
 * Uses heuristics to provide the best suitable location the
 * curve note closest location can be updated with. Three cases:
 * 1. Both neighbors are active points. Intersect their active rays
 * 2. Only one node is an active point. Project on its active ray
 * 3. None of the neighbors are active points. Project on line bisector
 * iD    > Curve node index to be updated
 * vPnt  > The new location to update the node with
 * bMute > Mute mode. Used to disable server status messages
 * Returns multiple values:
 * 1. Curve node calculated heuristics location vector
 * 2. The amount of neighbor nodes that are active rays
]]--
function TOOL:GetCurveNodeActive(iD, vPnt, bMute)
  local user = self:GetOwner()
  local tC  = asmlib.GetCacheCurve(user)
  if(iD <= 1) then -- Cannot chose first ID to intersect
    if(not bMute) then asmlib.Notify(user,"Node point uses prev !","ERROR") end
    return nil -- The chosen node ID does not meet requirements
  end
  if(iD >= tC.Size) then -- Cannot chose last ID to intersect
    if(not bMute) then asmlib.Notify(user,"Node point uses next !","ERROR") end
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
      if(not bMute) then asmlib.Notify(user,"Node projection prev !","HINT") end
      local mr, nr, xr = asmlib.ProjectRay(tS[1], tS[2]:Forward(), vPnt); return xr, 1
    elseif(tE[3]) then -- Next is an active point
      if(not bMute) then asmlib.Notify(user,"Node projection next !","HINT") end
      local mr, nr, xr = asmlib.ProjectRay(tE[1], tE[2]:Forward(), vPnt); return xr, 1
    else -- None of the previous and next nodes are active points
      if(not bMute) then asmlib.Notify(user,"Node project bisector !","HINT") end
      local vS, vE = tC.Node[iS], tC.Node[iE] -- Read start and finish nodes
      local vD = Vector(vE); vD:Sub(vS) -- Direction from start to finish
      local vO = Vector(vD); vO:Mul(0.5); vO:Add(vS) -- Bisector origin
      local mr, nr, xr = asmlib.ProjectRay(vS, vD, vPnt) -- Projection point
            vD:Set(vPnt); vD:Sub(xr) -- Bisector direction vector
      local ms, ns, xs = asmlib.ProjectRay(vO, vD, vPnt); return xs, 0
    end
  end
end

function TOOL:CurveClear(bAll, bMute)
  local user = self:GetOwner()
  local tC  = asmlib.GetCacheCurve(user)
  if(tC.Size and tC.Size > 0) then
    if(bAll) then -- Clear all the nodes
      if(not bMute) then
        asmlib.Notify(user, "Nodes cleared ["..tC.Size.."] !", "CLEANUP")
        netStart(gsLibName.."SendDeleteAllCurveNode")
        netWriteEntity(user); netSend(user)
        user:SetNWBool(gsToolPrefL.."engcurve", false)
      end
      tableEmpty(tC.Snap); tC.SSize = 0
      tableEmpty(tC.Node)
      tableEmpty(tC.Norm)
      tableEmpty(tC.Rays)
      tableEmpty(tC.Base); tC.Size = 0
      tableEmpty(tC.CNode)
      tableEmpty(tC.CNorm); tC.CSize = 0
    else -- Clear the last specific node from the array
      if(not bMute) then
        asmlib.Notify(user, "Node removed ["..tC.Size.."] !", "CLEANUP")
        netStart(gsLibName.."SendDeleteCurveNode");
        netWriteEntity(user); netSend(user)
        user:SetNWBool(gsToolPrefL.."engcurve", true)
      end
      tableRemove(tC.Node)
      tableRemove(tC.Norm)
      tableRemove(tC.Rays)
      tableEmpty(tC.Snap); tC.SSize = 0
      tableRemove(tC.Base); tC.Size = (tC.Size - 1)
    end
  end; return tC -- Returns the updated curve nodes table
end

function TOOL:GetCurveTransform(stTrace, bPnt)
  if(not stTrace) then
    asmlib.LogInstance("Trace missing", gtLogs); return nil end
  if(not stTrace.Hit) then
    asmlib.LogInstance("Trace not hit", gtLogs); return nil end
  local user     = self:GetOwner()
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
    end -- Use the track piece active end to create relative curve node
  else -- Offset the curve node when it is not driven by an active point
    tData.Org:Add(vNrm * elevpnt) -- Apply model active point elevation
  end -- Apply the positional and angular offsets to the return value
  tData.Org:Add(tData.Ang:Up()      * nextz)
  tData.Org:Add(tData.Ang:Right()   * nexty)
  tData.Org:Add(tData.Ang:Forward() * nextx)
  tData.Ang:RotateAroundAxis(tData.Ang:Up()     ,-nextyaw)
  tData.Ang:RotateAroundAxis(tData.Ang:Right()  , nextpic)
  tData.Ang:RotateAroundAxis(tData.Ang:Forward(), nextrol)
  return tData
end

function TOOL:CurveInsert(stTrace, bPnt, bMute)
  local user, model = self:GetOwner(), self:GetModel()
  local tData = self:GetCurveTransform(stTrace, bPnt); if(not tData) then
    asmlib.LogInstance("Transform missing", gtLogs); return nil end
  local tC = asmlib.GetCacheCurve(user); if(not tC) then
    asmlib.LogInstance("Curve missing", gtLogs); return nil end
  tC.Size = (tC.Size + 1) -- Increment stack size. Adding stuff
  tableInsert(tC.Node, Vector(tData.Org))
  tableInsert(tC.Norm, tData.Ang:Up())
  tableInsert(tC.Base, Vector(tData.Hit))
  tableInsert(tC.Rays, {Vector(tData.Org), Angle(tData.Ang), (tData.POA ~= nil)})
  if(not bMute) then
    asmlib.Notify(user, "Node inserted ["..tC.Size.."] !", "CLEANUP")
    netStart(gsLibName.."SendCreateCurveNode")
      netWriteEntity(user)
      netWriteVector(tC.Node[tC.Size])
      netWriteVector(tC.Norm[tC.Size])
      netWriteVector(tC.Base[tC.Size])
      netWriteVector(tC.Rays[tC.Size][1])
      netWriteAngle (tC.Rays[tC.Size][2])
      netWriteBool  (tC.Rays[tC.Size][3])
    netSend(user)
    user:SetNWBool(gsToolPrefL.."engcurve", true)
  end
  return tC -- Returns the updated curve nodes table
end

function TOOL:CurveUpdate(stTrace, bPnt, bMute)
  local user  = self:GetOwner()
  local tData = self:GetCurveTransform(stTrace, bPnt); if(not tData) then
    asmlib.LogInstance("Transform missing", gtLogs); return nil end
  local tC = asmlib.GetCacheCurve(user); if(not tC) then
    asmlib.LogInstance("Curve missing", gtLogs); return nil end
  if(not (tC.Size and tC.Size > 0)) then
    asmlib.Notify(user,"Populate nodes first !","ERROR")
    asmlib.LogInstance("Nodes missing", gtLogs); return nil
  end
  local mD, mL = asmlib.GetNearest(tData.Hit, tC.Base)
  tC.Node[mD]:Set(tData.Org)
  tC.Norm[mD]:Set(tData.Ang:Up())
  tC.Base[mD]:Set(tData.Hit)
  tC.Rays[mD][1]:Set(tData.Org)
  tC.Rays[mD][2]:Set(tData.Ang)
  tC.Rays[mD][3] = (tData.POA ~= nil)
  -- Adjust node according to intersection
  if(bPnt and not tData.POA) then
    local xx = self:GetCurveNodeActive(mD, tData.Org)
    if(xx) then
      tC.Node[mD]:Set(xx)
      tC.Norm[mD]:Set(tC.Norm[mD - 1])
      tC.Norm[mD]:Add(tC.Norm[mD + 1])
      tC.Norm[mD]:Normalize()
    end
  end
  if(not bMute) then
    asmlib.Notify(user, "Node ["..mD.."] updated !", "CLEANUP")
    netStart(gsLibName.."SendUpdateCurveNode")
      netWriteEntity(user)
      netWriteVector(tC.Node[mD])
      netWriteVector(tC.Norm[mD])
      netWriteVector(tC.Base[mD])
      netWriteVector(tC.Rays[mD][1])
      netWriteAngle (tC.Rays[mD][2])
      netWriteBool  (tC.Rays[mD][3])
      netWriteUInt(mD, 16)
    netSend(user)
    user:SetNWBool(gsToolPrefL.."engcurve", true)
  end; return tC -- Returns the updated curve nodes table
end

--[[
 * Validates curve client parameters and
 * initializes the curve structure for the holder model
]]
function TOOL:CurveCheck()
  local user = self:GetOwner()
  local model = self:GetModel()
  local fnmodel = stringGetFileName(model)
  local pointid, pnextid = self:GetPointID()
  local nEps = asmlib.GetOpVar("EPSILON_ZERO")
  -- Check the model in the database
  local hdRec = asmlib.CacheQueryPiece(model); if(not asmlib.IsHere(hdRec)) then
    asmlib.LogInstance("Holder model not piece: "..fnmodel, gtLogs); return nil end
  -- Disable for stack having less than two vertices
  local tC = asmlib.GetCacheCurve(user); if(tC.Size and tC.Size < 2) then
    asmlib.Notify(user,"Two vertices needed !","ERROR")
    asmlib.LogInstance("Two vertices needed: "..fnmodel, gtLogs); return nil
  end
  -- Disable for single active end track segments
  if(hdRec.Size <= 1) then
    asmlib.Notify(user,"Segmented track needed !","ERROR")
    asmlib.LogInstance("Segmented track needed: "..fnmodel, gtLogs); return nil end
  -- Disable for missing start track segments
  local sPOA = asmlib.LocatePOA(hdRec, pointid); if(not sPOA) then
    asmlib.Notify(user,"Start segment missing !","ERROR")
    asmlib.LogInstance("Start segment missing: "..fnmodel, gtLogs); return nil
  end
  -- Disable for missing end track segments
  local ePOA = asmlib.LocatePOA(hdRec, pnextid); if(not ePOA) then
    asmlib.Notify(user,"End segment missing !","ERROR")
    asmlib.LogInstance("End segment missing: "..fnmodel, gtLogs); return nil
  end
  -- Read the active point and check piece shape
  local sO, sA = tC.Info.Pos[1], tC.Info.Ang[1]
        sO:SetUnpacked(sPOA.O:Get())
        sA:SetUnpacked(sPOA.A:Get())
  -- Read the next point to check the piece shape
  local eO, eA = tC.Info.Pos[2], tC.Info.Ang[2]
        eO:SetUnpacked(ePOA.O:Get())
        eA:SetUnpacked(ePOA.A:Get())
  -- Disable for active points with zero distance
  local nD = eO:DistToSqr(sO); if(nD <= nEps) then
    asmlib.Notify(user,"Segment tiny "..fnmodel.." !","ERROR")
    asmlib.LogInstance("Segment tiny: "..fnmodel, gtLogs); return nil
  end
  -- Disable for non-straight track segments
  if(sA:Forward():Cross(eA:Forward()):LengthSqr() >= nEps) then
    asmlib.Notify(user,"Segment curved "..fnmodel.." !","ERROR")
    asmlib.LogInstance("Segment curved: "..fnmodel, gtLogs); return nil
  end
  -- Disable for 180 curve track segments
  if(sA:Forward():Dot(eA:Forward()) >= nEps) then
    asmlib.Notify(user,"Segment overturn "..fnmodel.." !","ERROR")
    asmlib.LogInstance("Segment overturn: "..fnmodel, gtLogs); return nil
  end
  -- Disable for ramp track segments
  if(sA:Forward():Dot((sO - eO):GetNormalized()) < (1 - nEps)) then
    asmlib.Notify(user,"Segment gradient "..fnmodel.." !","ERROR")
    asmlib.LogInstance("Segment gradient: "..fnmodel, gtLogs); return nil
  end
  return tC, mathSqrt(nD) -- Returns the updated curve nodes table
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
  local fnmodel    = stringGetFileName(model)
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
      asmlib.LogInstance(self:GetStatus(stTrace,"(Spawn) Cannot obtain spawn data"),gtLogs); return false end
    vPos:Set(stSpawn.SPos); aAng:Set(stSpawn.SAng)
  end
  -- Update the anchor entity automatically when enabled
  if(upspanchor) then -- Read the auto-update flag
    if(anEnt ~= trEnt) then -- When the anchor needs to be changed
      if(not self:SetAnchor(stTrace)) then -- Update anchor with current trace
        asmlib.LogInstance(self:GetStatus(stTrace,"(Spawn) Anchor fail"),gtLogs); return false
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
      asmlib.LogInstance(self:GetStatus(stTrace,"(Spawn) Failed to apply physical settings",ePiece),gtLogs); return false end
    if(not asmlib.ApplyPhysicalAnchor(ePiece,anEnt,weld,nocollide,nocollidew,forcelim)) then
      asmlib.LogInstance(self:GetStatus(stTrace,"(Spawn) Failed to apply physical anchor",ePiece),gtLogs); return false end
    asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( Spawn )")
    asmlib.UndoAddEntity(ePiece)
    asmlib.UndoFinish(oPly)
    asmlib.LogInstance("(Spawn) Success",gtLogs); return true
  end
  asmlib.LogInstance(self:GetStatus(stTrace,"(Spawn) Failed to create"),gtLogs); return false
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
  local applinfst  = self:ApplyLinearFirst()
  local bnderrmod  = self:GetBoundErrorMode()
  local appangfst  = self:ApplyAngularFirst()
  local nocollidew = self:GetNocollideWorld()
  local fnmodel    = stringGetFileName(model)
  local siAnc  , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local workmode, workname = self:GetWorkingMode()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()

  if(workmode == 3 or workmode == 5) then
    if(poQueue:IsBusy(user)) then asmlib.Notify(user,"Server busy !","ERROR"); return true end
    local hdRec = asmlib.CacheQueryPiece(model); if(not asmlib.IsHere(hdRec)) then
      asmlib.LogInstance(self:GetStatus(stTrace,"(Hold) Holder model not piece"),gtLogs); return false end
    local tC, nD = self:CurveCheck(); if(not asmlib.IsHere(tC)) then
      asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) Validation fail"), gtLogs); return nil end
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
      wname = workname:lower():gsub("^%l", stringUpper),
      imake = 0,
      spawn = {},
      srate = spawnrate
    }, function(oPly, oArg)
      for iD = oArg.stard, tC.SSize do tS = tC.Snap[iD]
        for iK = oArg.stark, tS.Size do local tV, ePiece = tS[iK], nil
          oArg.spawn = asmlib.GetNormalSpawn(oPly, tV[1], tV[2], model, pointid,
                         nextx, nexty, nextz, nextpic, nextyaw, nextrol, oArg.spawn)
          if(not oArg.spawn) then -- Make sure it persists to set it afterwards
            asmlib.LogInstance(self:GetStatus(stTrace,"("..oArg.wname..") "..sItr..": Cannot obtain spawn data"),gtLogs); return false end
          if(crvturnlm > 0 or crvleanlm > 0) then local nF, nU = asmlib.GetTurningFactor(oPly, tS, iK)
            if(nF and nF < crvturnlm) then
              oArg.mundo = asmlib.GetReport(iD, asmlib.GetNearest(tV[1], tC.Node), ("%4.3f"):format(nF))
              asmlib.Notify(oPly, oArg.wname.." excessive turn at "..oArg.mundo.." !", "ERROR")
              asmlib.LogInstance(self:GetStatus(stTrace,"("..oArg.wname..") "..oArg.mundo..": Turn excessive"), gtLogs); return false
            end
            if(nU and nU < crvleanlm) then
              oArg.mundo = asmlib.GetReport(iD, asmlib.GetNearest(tV[1], tC.Node),("%4.3f"):format(nU))
              asmlib.Notify(oPly, oArg.wname.." excessive lean at "..oArg.mundo.." !", "ERROR")
              asmlib.LogInstance(self:GetStatus(stTrace,"("..oArg.wname..") "..oArg.mundo..": Lean excessive"), gtLogs); return false
            end
          end
          while(oArg.itrys < maxstatts and not ePiece) do oArg.itrys = (oArg.itrys + 1)
            ePiece = asmlib.NewPiece(oPly,model,oArg.spawn.SPos,oArg.spawn.SAng,mass,bgskids,conPalette:Select("w"),bnderrmod) end
          if(stackcnt > 0) then if(oArg.istck < stackcnt) then oArg.istck = (oArg.istck + 1) else ePiece:Remove(); ePiece = nil end end
          oArg.imake = (oArg.imake + (ePiece and 1 or 0)); sItr = fInt:format(oArg.imake)
          oPly:SetNWFloat(gsToolPrefL.."progress", (oArg.imake / tC.SKept) * 100)
          if(ePiece) then -- We still have enough memory to preform the stacking
            if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
              asmlib.LogInstance(self:GetStatus(stTrace,"("..oArg.wname..") "..sItr..": Apply physical settings fail"),gtLogs); return false end
            if(not asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or oArg.entpo),weld,nil,nil,forcelim)) then
              asmlib.LogInstance(self:GetStatus(stTrace,"("..oArg.wname..") "..sItr..": Apply weld fail"),gtLogs); return false end
            if(not asmlib.ApplyPhysicalAnchor(ePiece,oArg.entpo,nil,nocollide,nocollidew,forcelim)) then
              asmlib.LogInstance(self:GetStatus(stTrace,"("..oArg.wname..") "..sItr..": Apply no-collide fail"),gtLogs); return false end
            oArg.itrys, oArg.srate, oArg.entpo = 0, (oArg.srate - 1), ePiece -- When the routine item is still busy
            tableInsert(oArg.eundo, ePiece) -- Add the entity to the undo list created at the end
            if(oArg.srate <= 0) then oArg.srate = spawnrate -- Renew the spawn rate
              if(iK == tS.Size) then -- When current snap end is reached
                oArg.stard, oArg.stark = (oArg.stard + 1), 1 -- Index the next snap
              else -- When there is more stuff to snap continue snapping the current
                oArg.stark = (oArg.stark + 1) -- Move the snap cursor to the next snap
              end -- Write the logs that snap rate per tick has been reached
              asmlib.LogInstance("("..oArg.wname..") "..sItr..":  Next "..asmlib.GetReport(oArg.stard, oArg.stark), gtLogs)
              return true -- The server is still busy with the task
            end
          else oArg.mundo = sItr -- We still have enough memory to preform the stacking
            if(stackcnt > 0) then -- Output different log message when stack count is used for curve segments limit
              asmlib.LogInstance(self:GetStatus(stTrace,"("..oArg.wname..") "..sItr..": Segment limit reached"), gtLogs); return false
            else asmlib.LogInstance(self:GetStatus(stTrace,"("..oArg.wname..") "..sItr..": Stack attempts fail"), gtLogs); return false end
          end
        end
      end
      oPly:SetNWFloat(gsToolPrefL.."progress", 100)
      asmlib.LogInstance("("..oArg.wname..") Success",gtLogs); return false
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
      asmlib.LogInstance("("..oArg.wname..") Success", gtLogs)
    end); return true
  elseif(workmode == 4 and self:IsFlipOver()) then
    if(poQueue:IsBusy(user)) then asmlib.Notify(user,"Server busy !","ERROR"); return true end
    local wOver, wNorm = self:GetFlipOverOrigin(stTrace, user:KeyDown(IN_SPEED))
    local tE, nE = self:GetFlipOver(true)
    local tC, nC = asmlib.GetConstraintOver(tE)
    if(not tE or nE <= 0) then
      asmlib.Notify(user, "No tracks selected !", "ERROR")
      asmlib.LogInstance(self:GetStatus(stTrace,"(Over) No tracks selected",trEnt),gtLogs); return false
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
          local spPos, spAng = asmlib.GetTransformOBB(eID, oArg.wover, oArg.wnorm, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
          while(oArg.itrys < maxstatts and not ePiece) do oArg.itrys = (oArg.itrys + 1)
            ePiece = asmlib.NewPiece(oPly,oArg.mundo,spPos,spAng,mass,bgskids,conPalette:Select("w"),bnderrmod) end
          if(ePiece) then
            asmlib.RegConstraintOver(oArg.tcons, oArg.munid, ePiece)
            oArg.itrys, oArg.srate = 0, (oArg.srate - 1) -- When the routine item is still busy
            tableInsert(oArg.eundo, ePiece) -- Add the entity to the undo list created at the end
            if(oArg.srate <= 0) then -- Renew the spawn rate and prepare for next spawn
              oArg.start, oArg.srate = (iD + 1), spawnrate
              asmlib.LogInstance("(Over) Next "..asmlib.GetReport(oArg.stard, oArg.stark), gtLogs)
              return true -- The server is still busy with the task
            end
          else
            asmlib.Notify(user, "Spawn data invalid "..asmlib.GetReport(iD, oArg.mundo).." !", "ERROR")
            asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Spawn data invalid",trEnt),gtLogs); return false
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
            asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Failed to apply physical settings",tB.Ent),gtLogs); return false end
        else asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Physical settings invalid",tB.Ent),gtLogs); return false end
        for key, val in pairs(tL) do
          if(not asmlib.IsOther(val.Ent)) then
            if(not asmlib.ApplyPhysicalAnchor(tB.Ent,(anEnt or val.Ent),weld,nocollide,nocollidew,forcelim)) then
              asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Failed to apply physical anchor",val.Ent),gtLogs); return false end
          else asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Physical anchor invalid",val.Ent),gtLogs); return false end
        end
      end
    end); return true
  end

  local hdRec = asmlib.CacheQueryPiece(model); if(not asmlib.IsHere(hdRec)) then
    asmlib.LogInstance(self:GetStatus(stTrace,"(Hold) Holder model not piece"),gtLogs); return false end

  if(stTrace.HitWorld) then return self:NormalSpawn(stTrace, user) end -- Switch the tool mode ( Spawn )

  if(not (trEnt and trEnt:IsValid())) then
    asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Trace entity invalid"),gtLogs); return false end
  if(asmlib.IsOther(trEnt)) then
    asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Trace other object"),gtLogs); return false end
  if(not asmlib.IsPhysTrace(stTrace)) then
    asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Trace not physical object"),gtLogs); return false end

  local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  if(not asmlib.IsHere(trRec)) then return self:NormalSpawn(stTrace, user) end

  local stSpawn = asmlib.GetEntitySpawn(user,trEnt,stTrace.HitPos,model,pointid,
                           actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)

  if(not stSpawn) then -- Not aiming into an active point update settings/properties
    if(user:KeyDown(IN_USE)) then -- Physical
      if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Physical) Failed to apply physical settings",trEnt),gtLogs); return false end
      if(not asmlib.ApplyPhysicalAnchor(trEnt,anEnt,weld,nocollide,nocollidew,forcelim)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Physical) Failed to apply physical anchor",trEnt),gtLogs); return false end
      trEnt:GetPhysicsObject():SetMass(mass)
      asmlib.LogInstance("(Physical) Success",gtLogs)
    elseif(user:KeyDown(IN_SPEED)) then -- Fast single flip over the anchor relative to a piece OBB
      if(not (anEnt and anEnt:IsValid())) then return false end
      if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Failed to apply physical settings",trEnt),gtLogs); return false end
      local spPos, spAng = asmlib.GetTransformOBB(anEnt, trEnt:LocalToWorld(trEnt:OBBCenter()),
                             stTrace.HitNormal, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
      local ePiece = asmlib.NewPiece(user,anEnt:GetModel(),spPos,spAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
      if(ePiece) then
        if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
          asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Apply physical settings fail"),gtLogs); return false end
        asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( Over )")
        asmlib.UndoAddEntity(ePiece)
        asmlib.UndoFinish(user)
        asmlib.LogInstance("(Over) Success",gtLogs); return true
      end
    else -- Visual
      local IDs = gsSymDir:Explode(bgskids)
      if(not asmlib.AttachBodyGroups(trEnt,IDs[1] or "")) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Bodygroup/Skin) Failed",trEnt),gtLogs); return false end
      trEnt:SetSkin(mathClamp(tonumber(IDs[2]) or 0,0,trEnt:SkinCount()-1))
      asmlib.LogInstance("(Bodygroup/Skin) Success",gtLogs)
    end; return true
  end

  if((workmode == 1) and (stackcnt > 0) and user:KeyDown(IN_SPEED) and (tonumber(hdRec.Size) or 0) > 1) then
    if(poQueue:IsBusy(user)) then asmlib.Notify(user, "Server busy !","ERROR"); return true end
    if(pointid == pnextid) then asmlib.LogInstance(self:GetStatus(stTrace,"Point ID overlap"), gtLogs); return false end
    local fInt, hdOffs = asmlib.GetOpVar("FORM_INTEGER"), asmlib.LocatePOA(stSpawn.HRec, pnextid)
    if(not hdOffs) then -- Make sure the next point is present so we have something to stack on
      asmlib.Notify(user,"Missing next point ID !","ERROR")
      asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) Missing next point ID"), gtLogs); return false
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
            asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": Apply physical settings fail"),gtLogs); return false end
          if(not asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or oArg.entpo),weld,nil,nil,forcelim)) then
            asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": Apply weld fail"),gtLogs); return false end
          if(not asmlib.ApplyPhysicalAnchor(ePiece,oArg.entpo,nil,nocollide,nocollidew,forcelim)) then
            asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": Apply no-collide fail"),gtLogs); return false end
          oArg.vtemp:SetUnpacked(hdOffs.P:Get())
          oArg.vtemp:Rotate(oArg.spang); oArg.vtemp:Add(oArg.sppos)
          if(appangfst) then nextpic, nextyaw, nextrol, appangfst = 0, 0, 0, false end
          if(applinfst) then nextx  , nexty  , nextz  , applinfst = 0, 0, 0, false end
          asmlib.GetEntitySpawn(oPly, ePiece, oArg.vtemp, model, pointid,
            actrad, spnflat, igntype, nextx, nexty, nextz, nextpic, nextyaw, nextrol, oArg.spawn)
          if(not oArg.spawn) then -- Something happened spawn is not available and task must be removed
            asmlib.Notify(oPly,"Cannot obtain spawn data !", "ERROR")
            asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": Cannot obtain spawn data"),gtLogs); return false
          end -- Spawn data is valid for the current iteration iNdex
          oArg.sppos:Set(oArg.spawn.SPos); oArg.spang:Set(oArg.spawn.SAng)
          oArg.itrys, oArg.srate, oArg.entpo = 0, (oArg.srate - 1), ePiece
          -- Add the entity to the undo list created at the end
          tableInsert(oArg.eundo, ePiece)
          -- Check whenever the routine item is still busy
          if(oArg.srate <= 0) then
            oArg.start, oArg.srate = (iD + 1), spawnrate
            asmlib.LogInstance("(Stack) Next ["..oArg.start.."]",gtLogs);
            return true -- The server is still busy with the task
          end
        else -- Something happened piece cannot be created and task must be removed
          asmlib.Notify(oPly,"Stack attempts extinct !", "ERROR")
          asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": Stack attempts extinct"),gtLogs); return false
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
        asmlib.LogInstance("(Ray) Skip intersection sequence. Snapping",gtLogs) end
    end
    local ePiece = asmlib.NewPiece(user,model,stSpawn.SPos,stSpawn.SAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
    if(ePiece) then
      if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Snap) Apply physical settings fail"),gtLogs); return false end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or trEnt),weld,nil,nil,forcelim)) then -- Weld all created to the anchor/previous
        asmlib.LogInstance(self:GetStatus(stTrace,"(Snap) Apply weld fail"),gtLogs); return false end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,trEnt,nil,nocollide,nocollidew,forcelim)) then       -- NoCollide all to previous
        asmlib.LogInstance(self:GetStatus(stTrace,"(Snap) Apply no-collide fail"),gtLogs); return false end
      asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( Snap )")
      asmlib.UndoAddEntity(ePiece)
      asmlib.UndoFinish(user)
      asmlib.LogInstance("(Snap) Success",gtLogs); return true
    end
    asmlib.LogInstance(self:GetStatus(stTrace,"(Snap) Create piece fail"),gtLogs); return false
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
    local bPnt, tC = user:KeyDown(IN_USE)
    if(user:KeyDown(IN_SPEED)) then
      tC = self:CurveUpdate(stTrace, bPnt)
    else -- Inserting curve cannot be intersected
      tC = self:CurveInsert(stTrace, bPnt)
    end; return (tC and true or false)
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
        asmlib.LogInstance(self:GetStatus(stTrace,"(Select,"..tostring(enpntmscr)..") Model not piece"),gtLogs); return false end
      asmlib.LogInstance("(Select,"..tostring(enpntmscr)..") Success",gtLogs); return true
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
  if(stTrace.HitWorld) then
    if(user:IsAdmin()) then
      if(self:GetDeveloperMode()) then
        asmlib.SetLogControl(self:GetLogLines(),self:GetLogFile()) end
      if(self:GetExportDB()) then
        if(user:KeyDown(IN_USE)) then
          asmlib.SetAsmConvar(user,"openextdb")
          asmlib.LogInstance("(World) Success open expdb",gtLogs)
        else
          asmlib.ExportDSV("PIECES")
          asmlib.ExportDSV("ADDITIONS")
          asmlib.ExportDSV("PHYSPROPERTIES")
          asmlib.LogInstance("(World) Exporting DB",gtLogs)
        end
        asmlib.SetAsmConvar(user, "exportdb", 0)
      end
    end
    if(user:KeyDown(IN_SPEED)) then
      if(workmode == 1) then
        if(upspanchor) then
          if(not self:SetAnchor(stTrace)) then
            asmlib.LogInstance(self:GetStatus(stTrace,"(World) Anchor fail"),gtLogs); return false
          end; asmlib.LogInstance("(World) Anchor set",gtLogs)
        else self:ClearAnchor(false)
          asmlib.LogInstance("(World) Anchor clear",gtLogs)
        end; return true
      elseif(workmode == 2) then self:IntersectClear(false)
        asmlib.LogInstance("(World) Relate clear",gtLogs); return true
      elseif(workmode == 3 or workmode == 5) then self:CurveClear(true)
        asmlib.LogInstance("(World) Nodes cleared",gtLogs); return true
      elseif(workmode == 4 and bfover) then self:ClearFlipOver()
        asmlib.LogInstance("(World) Flip over cleared",gtLogs); return true
      end
    else
      if(workmode == 3 or workmode == 5) then self:CurveClear(false)
        asmlib.LogInstance("(World) Node removed",gtLogs); return true
      elseif(workmode == 4 and bfover) then self:ClearFlipOver()
        asmlib.LogInstance("(World) Flip over cleared",gtLogs); return true
      end
    end; asmlib.LogInstance("(World) Success",gtLogs)
  elseif(trEnt and trEnt:IsValid()) then
    if(not asmlib.IsPhysTrace(stTrace)) then return false end
    if(asmlib.IsOther(trEnt)) then
      asmlib.LogInstance("(Prop) Trace other object",gtLogs); return false end
    if(user:KeyDown(IN_SPEED)) then
      if(workmode == 1) then -- General anchor
        if(not self:SetAnchor(stTrace)) then
          asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Anchor fail"),gtLogs); return false end
        asmlib.LogInstance("(Prop) Anchor set",gtLogs); return true
      elseif(workmode == 2) then -- Intersect relation
        if(not self:IntersectRelate(user, trEnt, stTrace.HitPos)) then
          asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Relation fail"),gtLogs); return false end
        asmlib.LogInstance("(Prop) Relation set",gtLogs); return true
      elseif(workmode == 3 or workmode == 5) then self:CurveClear(true)
        asmlib.LogInstance("(Prop) Nodes cleared",gtLogs); return true
      elseif(workmode == 4 and bfover) then self:ClearFlipOver()
        asmlib.LogInstance("(Prop) Flip over cleared",gtLogs); return true
      end
    else
      if(workmode == 3 or workmode == 5) then self:CurveClear(false)
        asmlib.LogInstance("(Prop) Node removed",gtLogs); return true
      elseif(workmode == 4 and bfover) then self:ClearFlipOver()
        asmlib.LogInstance("(Prop) Flip over cleared",gtLogs); return true
      end
    end
    local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
    if(asmlib.IsHere(trRec) and (asmlib.GetOwner(trEnt) == user or user:IsAdmin())) then
      asmlib.InSpawnMargin(user, trRec); trEnt:Remove()
      asmlib.LogInstance("(Prop) Remove piece",gtLogs); return true
    end; asmlib.LogInstance("(Prop) Success",gtLogs)
  end; return false
end

function TOOL:Holster()
  if(CLIENT) then return end
  netStart(gsLibName.."SendDeleteGhosts")
  netSend(self:GetOwner())
end

function TOOL:UpdateGhostFlipOver(stTrace, sPos, sAng)
  local atGho  = asmlib.GetOpVar("ARRAY_GHOST")
  local tE, nE = self:GetFlipOver(true, true)
  if(tE and self:IsFlipOver()) then
    local nextx  , nexty  , nextz   = self:GetPosOffsets()
    local nextpic, nextyaw, nextrol = self:GetAngOffsets()
    for iD = 1, nE do
      local bPK = inputIsKeyDown(KEY_LSHIFT)
      local eID, gID = tE[iD], atGho[iD]
      if(not asmlib.IsOther(eID) and gID and gID:IsValid()) then
        local wOver, wNorm = self:GetFlipOverOrigin(stTrace, bPK)
        local spPos, spAng = asmlib.GetTransformOBB(eID, wOver, wNorm,
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
  local tCrv, nD = self:CurveCheck()
  if(tCrv and tCrv.Size and tCrv.Size > 1) then
    local model = self:GetModel()
    local stackcnt = self:GetStackCount()
    local pointid, pnextid = self:GetPointID()
    local tGho, iGho = asmlib.GetOpVar("ARRAY_GHOST"), 0
    local nextx, nexty, nextz = self:GetPosOffsets()
    local nextpic, nextyaw, nextrol = self:GetAngOffsets()
    local bCrv = user:GetNWBool(gsToolPrefL.."engcurve", false)
    if(bCrv) then
      local workmode  = self:GetWorkingMode()
      local curvefact = self:GetCurveFactor()
      local curvsmple = self:GetCurveSamples()
      asmlib.LogInstance("Calculate", gtLogs)
      user:SetNWBool(gsToolPrefL.."engcurve", false)
      if(workmode == 3) then
        asmlib.CalculateRomCurve(user, curvsmple, curvefact)
      elseif(workmode == 5) then
        asmlib.CalculateBezierCurve(user, curvsmple)
      end
      for iD = 1, (tCrv.CSize - 1) do
        asmlib.UpdateCurveSnap(user, iD, nD)
      end
    end
    for iD = 1, tCrv.SSize do local tS = tCrv.Snap[iD]
      for iK = 1, tS.Size do iGho = (iGho + 1)
        local tV, eGho = tS[iK], tGho[iGho]
        local stSpawn = asmlib.GetNormalSpawn(user, tV[1], tV[2], model, pointid,
                                  nextx, nexty, nextz, nextpic, nextyaw, nextrol)
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
  local ghostblnd = self:GetGhostFade()
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
    local applinfst = self:ApplyLinearFirst()
    local appangfst = self:ApplyAngularFirst()
    local stSpawn   = asmlib.GetEntitySpawn(oPly,trEnt,stTrace.HitPos,model,pointid,
                        actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(stSpawn) then
      if(workmode == 1) then
        if(stackcnt > 0 and inputIsKeyDown(KEY_LSHIFT) and (tonumber(stSpawn.HRec.Size) or 0) > 1) then
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
    asmlib.LogInstance("Player invalid <"..tostring(oPly)..">",gtLogs); return end
  if(oEnt and oEnt:IsValid()) then
    local pointid, pnextid = self:GetPointID()
    local spawncn, elevpnt = self:GetSpawnCenter(), 0
    if(not spawncn) then -- Distance for the piece spawned on the ground
      elevpnt = (asmlib.GetPointElevation(oEnt, pointid) or 0); end
    asmlib.LogInstance("("..tostring(spawncn)..") <"..tostring(elevpnt)..">",gtLogs)
    asmlib.SetAsmConvar(oPly, "elevpnt", elevpnt)
  end
end

function TOOL:Think()
  if(not asmlib.IsInit()) then return end
  local workmode = self:GetWorkingMode()
  if(SERVER) then return end
  local model = self:GetModel()
  if(not asmlib.IsModel(model)) then return end
  local bO = asmlib.IsFlag("old_close_frame", asmlib.IsFlag("new_close_frame"))
  local bN = asmlib.IsFlag("new_close_frame", inputIsKeyDown(KEY_E))
  if(not bO and bN and inputIsKeyDown(KEY_LALT)) then
    local oD = conElements:Pull() -- Retrieve a panel from the stack
    if(istable(oD)) then oD = oD[1] -- Extract panel from table
      if(IsValid(oD)) then oD:SetVisible(false) end -- Make it invisible
    else -- The temporary reference is not table then close it
      if(IsValid(oD)) then oD:Close() end -- A `close` call, get it :D
    end -- Shortcut for closing the routine pieces
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
  oScreen:SetTextStart(0, 260)
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
  local bPnt = inputIsKeyDown(KEY_E)
  local bRp  = inputIsKeyDown(KEY_LSHIFT)
  local tData = self:GetCurveTransform(stTrace, bPnt)
  if(not tData) then asmlib.LogInstance("Transform missing", gtLogs); return end
  local tC, nS = asmlib.GetCacheCurve(oPly), self:GetSizeUCS()
  if(not tC) then asmlib.LogInstance("Curve missing", gtLogs); return end
  local nrB, nrS, mD, mL = 3, 1.5
  local xyO, xyH = tData.Org:ToScreen(), tData.Hit:ToScreen()
  local xyZ = (tData.Org + nS * tData.Ang:Up()):ToScreen()
  local xyX = (tData.Org + nS * tData.Ang:Forward()):ToScreen()
  oScreen:DrawLine(xyO, xyX, "r", "SURF")
  oScreen:DrawCircle(xyH, asmlib.GetViewRadius(oPly, tData.Hit, nrS), "y", "SURF", {35})
  if(tData.POA) then self:DrawSnapAssist(oScreen, oPly, stTrace, 10) -- Draw assist
  else oScreen:DrawLine(xyH, xyO, "y") end -- When active point is used for node
  oScreen:DrawCircle(xyO, asmlib.GetViewRadius(oPly, tData.Org, nrB), "g")
  oScreen:DrawLine(xyO, xyZ, "b")
  if(tC.Size and tC.Size > 0) then
    for iD = 1, tC.Size do
      local rN = (iD == 1 and nrB or nrS)
      local vB, vD, vN = tC.Base[iD], tC.Node[iD], tC.Norm[iD]
      local nB = asmlib.GetViewRadius(oPly, vB, 2)
      local nD = asmlib.GetViewRadius(oPly, vD, rN)
      local xyB, xyD = vB:ToScreen(), vD:ToScreen()
      local xyN = (vD + nS * vN):ToScreen()
      oScreen:DrawLine(xyB, xyD, "y")
      oScreen:DrawCircle(xyB, nB)
      oScreen:DrawCircle(xyD, nD)
      oScreen:DrawLine(xyN, xyD, "b")
      oScreen:DrawCircle(xyD, nD / 2, "r")
      if(tC.Node[iD - 1]) then
        local xyP = tC.Node[iD - 1]:ToScreen()
        oScreen:DrawLine(xyP, xyD, "g", sM)
      end
      if(bRp) then -- Get current length
        local nL = vB:DistToSqr(tData.Hit)
        if(mL and mD) then -- Length is allocated
          if(nL <= mL) then mD, mL = iD, nL end
        else mD, mL = iD, nL end
      end
    end
  end
  if(tC.Size and tC.Size > 0) then
    if(bRp and mD) then
      local xyN = tC.Node[mD]:ToScreen()
      oScreen:DrawLine(xyO, xyN, "r")
      if(bPnt and not tData.POA) then
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
  local bAct, xH = inputIsKeyDown(KEY_LSHIFT), stTrace.HitPos:ToScreen()
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
      local spPos, spAng = asmlib.GetTransformOBB(eID, wOv, wNr,
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
    hudMonitor:SetTextStart(ncX, ncY):DrawText(fP:format(nPrg), "k", "SURF", {"Trebuchet24", true})
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
  local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
  local hudMonitor = asmlib.GetScreen(0,0,scrW,scrH,conPalette,"GAME")
  if(not hudMonitor) then asmlib.LogInstance("Invalid screen",gtLogs); return end
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
      hudMonitor:SetTextStart(0, sY / 2)
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
  if(not scrTool) then asmlib.LogInstance("Invalid screen",gtLogs); return end
  local xyT, xyB = scrTool:GetCorners()
  scrTool:DrawRect(xyT,xyB,"k","SURF",{"vgui/white"})
  scrTool:SetTextStart(xyT.x, xyT.y)
  local user = LocalPlayer()
  local stTrace = asmlib.GetCacheTrace(user)
  local siAnc, anEnt = self:GetAnchor()
  local tInfo = gsSymRev:Explode(siAnc)
  if(not (stTrace and stTrace.Hit)) then
    scrTool:DrawText("Trace status: Invalid","r","SURF",{"Trebuchet24"})
    scrTool:DrawTextRe("  ["..(tInfo[1] or gsNoID).."]","an"); return
  end
  scrTool:DrawText("Trace status: Valid","g","SURF",{"Trebuchet24"})
  scrTool:DrawTextRe("  ["..(tInfo[1] or gsNoID).."]","an")
  local model = self:GetModel()
  local hdRec = asmlib.CacheQueryPiece(model)
  if(not asmlib.IsHere(hdRec)) then
    scrTool:DrawText("Holds Model: Invalid","r")
    scrTool:DrawTextRe("  ["..gsModeDataB.."]","db")
    return
  end
  scrTool:DrawText("Holds Model: Valid","g")
  scrTool:DrawTextRe("  ["..gsModeDataB.."]","db")
  local trEnt    = stTrace.Entity
  local actrad   = self:GetActiveRadius()
  local pointid, pnextid = self:GetPointID()
  local workmode, workname = self:GetWorkingMode()
  local trMaxCN, trModel, trOID, trRLen
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
      trRLen = mathRound(stSpawn.RLen,2)
    end
    if(asmlib.IsHere(trRec)) then
      trMaxCN = trRec.Size
      trModel = stringGetFileName(trModel)
    else trModel = "["..gsNoMD.."]"..stringGetFileName(trModel) end
  end
  model  = stringGetFileName(model)
  actrad = mathRound(actrad,2)
  maxrad = asmlib.GetAsmConvar("maxactrad", "FLT")
  scrTool:DrawText("TM: " ..(trModel    or gsNoAV),"y")
  scrTool:DrawText("HM: " ..(model      or gsNoAV),"m")
  scrTool:DrawText("ID: ["..(trMaxCN    or gsNoID)
                  .."] "  ..(trOID      or gsNoID)
                  .." >> "..(pointid    or gsNoID)
                  .. " (" ..(pnextid    or gsNoID)
                  ..") [" ..(hdRec.Size or gsNoID).."]","g")
  scrTool:DrawText("MaxCL: "..actrad.." < ["..maxrad.."]","c")
  local txW, txH = scrTool:GetTextStScreen()
  local txsX, txsY = scrTool:GetTextStLast()
  scrTool:DrawText("Work: ["..workmode.."] "..workname, "wm")
  scrTool:DrawText("CurAR: "..(trRLen or gsNoAV),"y")
  local nRad = mathClamp(h - txH  - txsY / 1.2,0,h) / 2
  local cPos = mathClamp(h - nRad - txsY / 2.5,0,h)
  local xyPs = asmlib.NewXY(cPos, cPos)
  scrTool:DrawCircle(xyPs, mathClamp(actrad/maxrad,0,1)*nRad, "c","SURF")
  scrTool:DrawCircle(xyPs, nRad, "m")
  scrTool:DrawText("Date: "..asmlib.GetDate(),"w")
  scrTool:DrawText("Time: "..asmlib.GetTime())
  if(trRLen) then scrTool:DrawCircle(xyPs, nRad * mathClamp(trRLen/maxrad,0,1),"y") end
end

-- Enter `spawnmenu_reload` in the console to reload the panel
function TOOL.BuildCPanel(CPanel)
  asmlib.SetAsmConvar(nil, "flipoverid") -- Reset flip-over mode on pickup
  CPanel:ClearControls(); CPanel:DockPadding(5, 0, 5, 10)
  local drmSkin, sLog = CPanel:GetSkin(), "*TOOL.BuildCPanel"
  local devmode = asmlib.GetAsmConvar("devmode", "BUL")
  local nMaxLin = asmlib.GetAsmConvar("maxlinear","FLT")
  local iMaxDec = asmlib.GetAsmConvar("maxmenupr","INT")
  local sCall, pItem, sName, aData = "_cpan" -- pItem is the current panel created
          CPanel:SetName(languageGetPhrase("tool."..gsToolNameL..".name"))
  pItem = CPanel:Help   (languageGetPhrase("tool."..gsToolNameL..".desc"))

  local pComboPresets = vguiCreate("ControlPresets", CPanel)
        pComboPresets:SetPreset(gsToolNameL)
        pComboPresets:AddOption("Default", asmlib.GetOpVar("STORE_CONVARS"))
        for key, val in pairs(tableGetKeys(asmlib.GetOpVar("STORE_CONVARS"))) do
          pComboPresets:AddConVar(val) end
  CPanel:AddItem(pComboPresets)

  local cqPanel = asmlib.CacheQueryPanel(devmode); if(not cqPanel) then
    asmlib.LogInstance("Panel population empty",sLog); return end
  local makTab = asmlib.GetBuilderNick("PIECES"); if(not asmlib.IsHere(makTab)) then
    asmlib.LogInstance("Missing builder table",sLog); return end
  local defTable = makTab:GetDefinition()
  local catTypes = asmlib.GetOpVar("TABLE_CATEGORIES")
  local pTree    = vguiCreate("DTree", CPanel); if(not pTree) then
    asmlib.LogInstance("Database tree empty",sLog); return end
  pTree:Dock(TOP) -- Initialize to fill left and right bounds
  pTree:SetTall(400) -- Make it quite large
  pTree:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".model"))
  pTree:SetIndentSize(0) -- All track types are closed
  pTree:UpdateColours(drmSkin) -- Apply current skin
  CPanel:AddItem(pTree) -- Register it to the panel
  local iCnt, iTyp, pTypes, pCateg, pNode = 1, 1, {}, {}
  while(cqPanel[iCnt]) do
    local vRec, bNow = cqPanel[iCnt], true
    local sMod = vRec[makTab:GetColumnName(1)]
    local sTyp = vRec[makTab:GetColumnName(2)]
    local sNam = vRec[makTab:GetColumnName(3)]
    if(asmlib.IsModel(sMod)) then
      if(not (asmlib.IsBlank(sTyp) or pTypes[sTyp])) then
        local pRoot = pTree:AddNode(sTyp) -- No type folder made already
              pRoot:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".type"))
              pRoot.Icon:SetImage(asmlib.ToIcon(defTable.Name))
              pRoot.DoClick = function(pnSelf)
                if(inputIsKeyDown(KEY_LSHIFT)) then
                  pnSelf:ExpandRecurse(true)
                else pnSelf:SetExpanded(true) end
              end
              pRoot.DoRightClick = function()
                local sID = asmlib.WorkshopID(sTyp)
                if(sID and sID:len() > 0 and inputIsKeyDown(KEY_LSHIFT)) then
                  guiOpenURL(asmlib.GetOpVar("FORM_URLADDON"):format(sID))
                else SetClipboardText(pRoot:GetText()) end
              end
              pRoot:UpdateColours(drmSkin)
        pTypes[sTyp] = pRoot
      end -- Reset the primary tree node pointer
      if(pTypes[sTyp]) then pItem = pTypes[sTyp] else pItem = pTree end
      -- Register the category if definition functional is given
      if(catTypes[sTyp]) then -- There is a category definition
        local bSuc, ptCat, psNam = pcall(catTypes[sTyp].Cmp, sMod)
        if(bSuc) then -- When the call is successful in protected mode
          if(psNam and not asmlib.IsBlank(psNam)) then
            sNam = asmlib.GetBeautifyName(psNam)
          end -- Custom name override when the addon requests
          local pCurr = pCateg[sTyp]
          if(not asmlib.IsHere(pCurr)) then
            pCateg[sTyp] = {}; pCurr = pCateg[sTyp] end
          if(asmlib.IsBlank(ptCat)) then ptCat = nil end
          if(asmlib.IsHere(ptCat)) then
            if(not istable(ptCat)) then ptCat = {ptCat} end
            if(ptCat[1]) then local iD = 1
              while(ptCat[iD]) do local sCat = tostring(ptCat[iD]):lower():Trim()
                if(asmlib.IsBlank(sCat)) then sCat = "other" end
                sCat = asmlib.GetBeautifyName(sCat) -- Beautify the category
                if(pCurr[sCat]) then -- Jump next if already created
                  pCurr, pItem = asmlib.GetDirectory(pCurr, sCat)
                else
                  pCurr, pItem = asmlib.SetDirectory(pItem, pCurr, sCat)
                end; iD = iD + 1 -- Create the last needed node regarding pItem
              end
            end -- When the category has at least one element
          else -- Store the creation information of the ones without category for later
            tableInsert(pCateg[sTyp], {sNam, sMod}); bNow = false
          end -- Is there is any category apply it. When available process it now
        end
      end -- Register the node associated with the track piece when is intended for later
      if(bNow) then asmlib.SetDirectoryNode(pItem, sNam, sMod) end
      -- SnapReview is ignored because a query must be executed for points count
    else asmlib.LogInstance("Ignoring item "..asmlib.GetReport(sTyp, sNam, sMod),sLog) end
    iCnt = iCnt + 1
  end
  -- Attach the hanging items to the type root
  for typ, val in pairs(pCateg) do
    for iD = 1, #val do
      local pan = pTypes[typ]
      local nam, mod = unpack(val[iD])
      asmlib.SetDirectoryNode(pan, nam, mod)
      asmlib.LogInstance("Rooting item "..asmlib.GetReport(typ, nam, mod),sLog)
    end
  end -- Process all the items without category defined
  asmlib.LogInstance("Found items #"..tostring(iCnt - 1), sLog)

  -- http://wiki.garrysmod.com/page/Category:DComboBox
  local sName = asmlib.GetAsmConvar("workmode", "NAM")
  local aData = asmlib.GetAsmConvar("workmode", "INT")
  local pComboToolMode = CPanel:ComboBox(languageGetPhrase("tool."..gsToolNameL..".workmode_con"), sName)
        pComboToolMode:SetSortItems(false)
        pComboToolMode:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".workmode"))
        pComboToolMode:UpdateColours(drmSkin)
        pComboToolMode:Dock(TOP) -- Setting tallness gets ignored otherwise
        pComboToolMode:SetTall(22)
        pComboToolMode.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
        for iD = 1, conWorkMode:GetSize() do
          local sW = tostring(conWorkMode:Select(iD) or gsNoAV):lower()
          local sI = asmlib.ToIcon("workmode_"..sW)
          local sT = languageGetPhrase("tool."..gsToolNameL..".workmode."..iD)
          pComboToolMode:AddChoice(sT, iD, (iD == aData), sI)
        end

  local sName = asmlib.GetAsmConvar("physmater", "NAM")
  local pComboPhysType = CPanel:ComboBox(languageGetPhrase("tool."..gsToolNameL..".phytype_con"))
        pComboPhysType:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".phytype"))
        pComboPhysType:SetValue(languageGetPhrase("tool."..gsToolNameL..".phytype_def"))
        pComboPhysType.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
        pComboPhysType:Dock(TOP) -- Setting tallness gets ignored otherwise
        pComboPhysType:SetTall(22)
        pComboPhysType:UpdateColours(drmSkin)

  local pComboPhysName = CPanel:ComboBox(languageGetPhrase("tool."..gsToolNameL..".phyname_con"), sName)
        pComboPhysName:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".phyname"))
        pComboPhysName:SetValue(asmlib.GetEmpty(asmlib.GetAsmConvar("physmater","STR"), nil,
                                languageGetPhrase("tool."..gsToolNameL..".phyname_def")))
        pComboPhysName.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
        pComboPhysName:Dock(TOP) -- Setting tallness gets ignored otherwise
        pComboPhysName:SetTall(22)
        pComboPhysName:UpdateColours(drmSkin)

  local cqProperty = asmlib.CacheQueryProperty(); if(not cqProperty) then
    asmlib.LogInstance("Property population empty",sLog); return end

  while(cqProperty[iTyp]) do
    local sT, sI = cqProperty[iTyp], asmlib.ToIcon("property_type")
    pComboPhysType:AddChoice(sT, sT, false, sI); iTyp = iTyp + 1
  end

  pComboPhysType.OnSelect = function(pnSelf, nInd, sVal, anyData)
    local cqNames = asmlib.CacheQueryProperty(sVal)
    if(cqNames) then local iNam = 1; pComboPhysName:Clear()
      pComboPhysName:SetValue(languageGetPhrase("tool."..gsToolNameL..".phyname_def"))
      while(cqNames[iNam]) do
        local sN, sI = cqNames[iNam], asmlib.ToIcon("property_name")
        pComboPhysName:AddChoice(sN, sN, false, sI); iNam = iNam + 1
      end
    else asmlib.LogInstance("Property type <"..sVal.."> names mismatch",sLog) end
  end

  cvarsRemoveChangeCallback(sName, sName..sCall)
  cvarsAddChangeCallback(sName, function(sV, vO, vN)
    pComboPhysName:SetValue(vN) end, sName..sCall);
  asmlib.LogTable(cqProperty, "Property", sLog)

  -- http://wiki.garrysmod.com/page/Category:DTextEntry
  local sName = asmlib.GetAsmConvar("bgskids", "NAM")
  local pText = CPanel:TextEntry(languageGetPhrase("tool."..gsToolNameL..".bgskids_con"), sName)
        pText:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".bgskids"))
        pText:SetText(asmlib.GetEmpty(asmlib.GetAsmConvar("bgskids", "STR"), nil,
                      languageGetPhrase("tool."..gsToolNameL..".bgskids_def")))
        pText:SetEnabled(false); pText:SetTall(22)

  local sName = asmlib.GetAsmConvar("bgskids", "NAM")
  cvarsRemoveChangeCallback(sName, sName..sCall)
  cvarsAddChangeCallback(sName, function(sV, vO, vN)
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
    CPanel:SetName(languageGetPhrase("tool."..gsToolNameL..".utilities_user"))
    CPanel:ControlHelp(languageGetPhrase("tool."..gsToolNameL..".client_var"))
    asmlib.SetNumSlider(CPanel, "sizeucs"  , iMaxDec)
    asmlib.SetNumSlider(CPanel, "incsnplin", 0)
    asmlib.SetNumSlider(CPanel, "incsnpang", 0)
    asmlib.SetNumSlider(CPanel, "ghostblnd", iMaxDec)
    asmlib.SetNumSlider(CPanel, "crvturnlm", iMaxDec)
    asmlib.SetNumSlider(CPanel, "crvleanlm", iMaxDec)
    asmlib.SetNumSlider(CPanel, "sgradmenu", 0)
    asmlib.SetNumSlider(CPanel, "rtradmenu", iMaxDec)
    asmlib.SetCheckBox(CPanel, "enradmenu")
    asmlib.SetCheckBox(CPanel, "enpntmscr")
    asmlib.LogInstance("Registered as "..asmlib.GetReport(CPanel.Name), sLog)
  end

  asmlib.DoAction("TWEAK_PANEL", "Utilities", "User", setupUserSettings)

  -- Enter `spawnmenu_reload` in the console to reload the panel
  local function setupAdminSettings(CPanel)
    local sLog = "*TOOL.AdminSettings"
    local drmSkin, pItem = CPanel:GetSkin()
    local iMaxDec = asmlib.GetAsmConvar("maxmenupr","INT")
    CPanel:ClearControls(); CPanel:DockPadding(5, 0, 5, 10)
    CPanel:SetName(languageGetPhrase("tool."..gsToolNameL..".utilities_admin"))
    CPanel:ControlHelp(languageGetPhrase("tool."..gsToolNameL..".nonrep_var"))
    asmlib.SetCheckBox(CPanel, "logfile")
    asmlib.SetNumSlider(CPanel, "logsmax", 0)
    asmlib.SetCheckBox(CPanel, "devmode")
    asmlib.SetCheckBox(CPanel, "exportdb")
    asmlib.SetNumSlider(CPanel, "maxtrmarg", iMaxDec)
    asmlib.SetNumSlider(CPanel, "maxspmarg", iMaxDec)
    asmlib.SetNumSlider(CPanel, "maxmenupr", 0)
    CPanel:ControlHelp(languageGetPhrase("tool."..gsToolNameL..".relica_var"))
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
    pItem = vguiCreate("DCategoryList", CPanel); if(not IsValid(pItem)) then
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
      local sMem = languageGetPhrase("tool."..gsToolNameL..".timermode_mem")
      local pMem = pItem:Add(sMem.." "..pDef.Nick)
            pMem:SetTooltip(sMem.." "..pDef.Nick)
      local pMode = vguiCreate("DComboBox", pItem); if(not IsValid(pMode)) then
        asmlib.LogInstance("Timer mode invalid", sLog); return end
      pMode:Dock(TOP); pMode:SetTall(25)
      pMode:UpdateColours(drmSkin)
      pMode:SetSortItems(false)
      pMode:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".timermode_md"))
      pMode.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
      for iK = 1, #tMod do local sK = tMod[iK]
        local bSel = (tostring(tSet[1]) == sK)
        local sIco = asmlib.ToIcon("timermode_"..sK:lower())
        local sKey = ("tool."..gsToolNameL..".timermode_"..sK:lower())
        pMode:AddChoice(languageGetPhrase(sKey), sK, bSel, sIco)
      end
      local pLife = vguiCreate("DNumSlider", pItem); if(not IsValid(pLife)) then
        asmlib.LogInstance("Record life invalid", sLog); return end
      pLife:Dock(TOP); pLife:SetTall(25)
      pLife:SetMin(0); pLife:SetMax(3600)
      pLife:SetDecimals(iMaxDec)
      pLife:SetValue(tonumber(tSet[2]) or 0)
      pLife:SetDefaultValue(tonumber(tSet[2]) or 0)
      pLife:SizeToContents()
      pLife:SetText(languageGetPhrase("tool."..gsToolNameL..".timermode_lf_con"))
      pLife:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".timermode_lf"))
      local pCler = vguiCreate("DCheckBoxLabel", pItem); if(not IsValid(pCler)) then
        asmlib.LogInstance("Force clear invalid", sLog); return end
      pCler:Dock(TOP); pCler:SetTall(25)
      pCler:SetValue((tonumber(tSet[3]) or 0) ~= 0)
      pCler:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".timermode_rd"))
      pCler:SetText(languageGetPhrase("tool."..gsToolNameL..".timermode_rd_con"))
      local pColl = vguiCreate("DCheckBoxLabel", pItem); if(not IsValid(pColl)) then
        asmlib.LogInstance("Collect invalid", sLog); return end
      pColl:SetValue((tonumber(tSet[4]) or 0) ~= 0)
      pColl:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".timermode_ct"))
      pColl:SetText(languageGetPhrase("tool."..gsToolNameL..".timermode_ct_con"))
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
        tTim[iD] = tableConcat(tS, sRev)
      end
      asmlib.SetAsmConvar(nil, "timermode", tableConcat(tTim, gsSymDir))
    end
    pItem.DoRightClick = function(pnSelf)
      if(inputIsKeyDown(KEY_LSHIFT)) then
        asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"),
                             asmlib.GetAsmConvar("logfile","BUL"))
      else
        local fW = asmlib.GetOpVar("FORM_GITWIKI")
        guiOpenURL(fW:format("Memory-manager-configuration"))
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
        asmlib.SetAsmConvar(user, "logfile"  , asmlib.GetAsmConvar("logfile"  , "DEF"))
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
        asmlib.SetAsmConvar(user, "curvefact", asmlib.GetAsmConvar("curvefact", "DEF"))
        asmlib.SetAsmConvar(user, "curvsmple", asmlib.GetAsmConvar("curvsmple", "DEF"))
        asmlib.SetAsmConvar(user, "spawnrate", asmlib.GetAsmConvar("spawnrate", "DEF"))
        asmlib.SetAsmConvar(user, "bnderrmod", asmlib.GetAsmConvar("bnderrmod", "DEF"))
        asmlib.SetAsmConvar(user, "maxfruse" , asmlib.GetAsmConvar("maxfruse" , "DEF"))
        asmlib.SetAsmConvar(user, "dtmessage", asmlib.GetAsmConvar("dtmessage", "DEF"))
        asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"),
                             asmlib.GetAsmConvar("logfile","BUL"))
        asmlib.LogInstance("Factory reset complete", sLog)
      end
    end
    pItem:Dock(TOP); pItem:SetTall(30)
    asmlib.LogInstance("Registered as "..asmlib.GetReport(CPanel.Name), sLog)
  end

  asmlib.DoAction("TWEAK_PANEL", "Utilities", "Admin", setupAdminSettings)
end
