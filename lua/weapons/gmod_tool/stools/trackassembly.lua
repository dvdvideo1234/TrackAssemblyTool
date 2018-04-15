---------------- Localizing Libraries ---------------
local type                  = type
local pairs                 = pairs
local print                 = print
local Angle                 = Angle
local Color                 = Color
local Vector                = Vector
local IsValid               = IsValid
local tostring              = tostring
local tonumber              = tonumber
local GetConVar             = GetConVar
local LocalPlayer           = LocalPlayer
local SetClipboardText      = SetClipboardText
local RunConsoleCommand     = RunConsoleCommand
local osDate                = os and os.date
local netSend               = net and net.Send
local netStart              = net and net.Start
local netReceive            = net and net.Receive
local netWriteEntity        = net and net.WriteEntity
local netWriteVector        = net and net.WriteVector
local vguiCreate            = vgui and vgui.Create
local utilIsValidModel      = util and util.IsValidModel
local mathAbs               = math and math.abs
local mathSqrt              = math and math.sqrt
local mathClamp             = math and math.Clamp
local fileExists            = file and file.Exists
local hookAdd               = hook and hook.Add
local tableGetKeys          = table and table.GetKeys
local inputIsKeyDown        = input and input.IsKeyDown
local cleanupRegister       = cleanup and cleanup.Register
local surfaceScreenWidth    = surface and surface.ScreenWidth
local surfaceScreenHeight   = surface and surface.ScreenHeight
local languageAdd           = language and language.Add
local languageGetPhrase     = language and language.GetPhrase
local concommandAdd         = concommand and concommand.Add
local duplicatorRegisterEntityModifier = duplicator and duplicator.RegisterEntityModifier

----------------- TOOL Global Parameters ----------------
--- Because Vec[1] is actually faster than Vec.X
--- Store a pointer to our module
local asmlib = trackasmlib

--- Vector Component indexes ---
local cvX, cvY, cvZ = asmlib.GetIndexes("V")

--- Angle Component indexes ---
local caP, caY, caR = asmlib.GetIndexes("A")

--- ZERO Objects
local VEC_ZERO = asmlib.GetOpVar("VEC_ZERO")
local ANG_ZERO = asmlib.GetOpVar("ANG_ZERO")

--- Global References
local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gtWorkMode  = asmlib.GetOpVar("MODE_WORKING")
local gsDataRoot  = asmlib.GetOpVar("DIRPATH_BAS")
local gnMaxOffRot = asmlib.GetOpVar("MAX_ROTATION")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")
local gsToolPrefU = asmlib.GetOpVar("TOOLNAME_PU")
local gsToolNameU = asmlib.GetOpVar("TOOLNAME_NU")
local gsModeDataB = asmlib.GetOpVar("MODE_DATABASE")
local gsLimitName = asmlib.GetOpVar("CVAR_LIMITNAME")
local gsUndoPrefN = asmlib.GetOpVar("NAME_INIT"):gsub("^%l", string.upper)..": "
local gsNoID      = asmlib.GetOpVar("MISS_NOID") -- No such ID
local gsNoAV      = asmlib.GetOpVar("MISS_NOAV") -- Not available
local gsNoMD      = asmlib.GetOpVar("MISS_NOMD") -- No model
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVSIGN")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gsNoAnchor  = gsNoID..gsSymRev..gsNoMD
local gnRatio     = asmlib.GetOpVar("GOLDEN_RATIO")
local conPalette  = asmlib.GetOpVar("CONTAINER_PALETTE")
local varLanguage = GetConVar("gmod_language")

if(not asmlib.ProcessDSV()) then -- Default tab delimiter
  asmlib.LogInstance("Processing data list fail <"..gsDataRoot.."trackasmlib_dsv.txt>")
end

cleanupRegister(gsLimitName)

TOOL.ClientConVar = {
  [ "weld"      ] = "1",
  [ "mass"      ] = "25000",
  [ "model"     ] = "models/props_phx/trains/tracks/track_1x.mdl",
  [ "nextx"     ] = "0",
  [ "nexty"     ] = "0",
  [ "nextz"     ] = "0",
  [ "count"     ] = "5",
  [ "freeze"    ] = "1",
  [ "anchor"    ] = gsNoAnchor,
  [ "igntype"   ] = "0",
  [ "spnflat"   ] = "0",
  [ "angsnap"   ] = "45",
  [ "pointid"   ] = "1",
  [ "pnextid"   ] = "2",
  [ "nextpic"   ] = "0",
  [ "nextyaw"   ] = "0",
  [ "nextrol"   ] = "0",
  [ "spawncn"   ] = "0",
  [ "bgskids"   ] = "",
  [ "gravity"   ] = "1",
  [ "adviser"   ] = "1",
  [ "elevpnt"   ] = "0",
  [ "activrad"  ] = "50",
  [ "pntasist"  ] = "1",
  [ "surfsnap"  ] = "0",
  [ "exportdb"  ] = "0",
  [ "forcelim"  ] = "0",
  [ "ignphysgn" ] = "0",
  [ "ghosthold" ] = "1",
  [ "maxstatts" ] = "3",
  [ "nocollide" ] = "1",
  [ "physmater" ] = "metal",
  [ "enpntmscr" ] = "1",
  [ "engunsnap" ] = "0",
  [ "workmode"  ] = "0",
  [ "appangfst" ] = "0",
  [ "applinfst" ] = "0"
}

if(CLIENT) then
  TOOL.Information = {
    { name = "info",  stage = 1   },
    { name = "left"         },
    { name = "right"        },
    { name = "right_use",   icon2 = "gui/e.png" },
    { name = "reload"       }
  }
  asmlib.InitLocalify(varLanguage:GetString())
  languageAdd("tool."..gsToolNameL..".category", "Construction")
  concommandAdd(gsToolPrefL.."openframe", asmlib.GetActionCode("OPEN_FRAME"))
  concommandAdd(gsToolPrefL.."resetvars", asmlib.GetActionCode("RESET_VARIABLES"))
  netReceive(gsLibName.."SendIntersectClear", asmlib.GetActionCode("CLEAR_RELATION"))
  netReceive(gsLibName.."SendIntersectRelate", asmlib.GetActionCode("CREATE_RELATION"))
  hookAdd("PlayerBindPress", gsToolPrefL.."player_bind_press", asmlib.GetActionCode("BIND_PRESS"))
  hookAdd("PostDrawHUD"    , gsToolPrefL.."physgun_drop_draw", asmlib.GetActionCode("PHYSGUN_DRAW"))
end

if(SERVER) then
  hookAdd("PlayerDisconnected", gsToolPrefL.."player_quit", asmlib.GetActionCode("PLAYER_QUIT"))
  hookAdd("PhysgunDrop", gsToolPrefL.."physgun_drop_snap", asmlib.GetActionCode("PHYSGUN_DROP"))
  duplicatorRegisterEntityModifier(gsToolPrefL.."dupe_phys_set",asmlib.GetActionCode("DUPE_PHYS_SETTINGS"))
end

TOOL.Category   = languageGetPhrase and languageGetPhrase("tool."..gsToolNameL..".category")
TOOL.Name       = languageGetPhrase and languageGetPhrase("tool."..gsToolNameL..".name")
TOOL.Command    = nil -- Command on click (nil for default)
TOOL.ConfigName = nil -- Configure file name (nil for default)

function TOOL:ApplyAngularFirst()
  return ((self:GetClientNumber("appangfst") or 0) ~= 0)
end

function TOOL:ApplyLinearFirst()
  return ((self:GetClientNumber("applinfst") or 0) ~= 0)
end

function TOOL:GetModel()
  return (self:GetClientInfo("model") or "")
end

function TOOL:GetCount()
  return mathClamp(self:GetClientNumber("count"),1,asmlib.GetAsmVar("maxstcnt", "INT"))
end

function TOOL:GetMass()
  return mathClamp(self:GetClientNumber("mass"),1,asmlib.GetAsmVar("maxmass"  ,"FLT"))
end

function TOOL:GetDeveloperMode()
  return asmlib.GetAsmVar("devmode" ,"BUL")
end

function TOOL:GetPosOffsets()
  local nMaxOffLin = asmlib.GetAsmVar("maxlinear","FLT")
  return (mathClamp(self:GetClientNumber("nextx") or 0,-nMaxOffLin,nMaxOffLin)),
         (mathClamp(self:GetClientNumber("nexty") or 0,-nMaxOffLin,nMaxOffLin)),
         (mathClamp(self:GetClientNumber("nextz") or 0,-nMaxOffLin,nMaxOffLin))
end

function TOOL:GetAngOffsets()
  return (mathClamp(self:GetClientNumber("nextpic") or 0,-gnMaxOffRot,gnMaxOffRot)),
         (mathClamp(self:GetClientNumber("nextyaw") or 0,-gnMaxOffRot,gnMaxOffRot)),
         (mathClamp(self:GetClientNumber("nextrol") or 0,-gnMaxOffRot,gnMaxOffRot))
end

function TOOL:GetElevation()
  return (self:GetClientNumber("elevpnt") or 0)
end

function TOOL:GetPointAssist()
  return ((self:GetClientNumber("pntasist") or 0) ~= 0)
end

function TOOL:GetFreeze()
  return ((self:GetClientNumber("freeze") or 0) ~= 0)
end

function TOOL:GetIgnoreType()
  return ((self:GetClientNumber("igntype") or 0) ~= 0)
end

function TOOL:GetBodyGroupSkin()
  return self:GetClientInfo("bgskids") or ""
end

function TOOL:GetGravity()
  return ((self:GetClientNumber("gravity") or 0) ~= 0)
end

function TOOL:GetGhostHolder()
  return ((self:GetClientNumber("ghosthold") or 0) ~= 0)
end

function TOOL:GetNoCollide()
  return ((self:GetClientNumber("nocollide") or 0) ~= 0)
end

function TOOL:GetSpawnFlat()
  return ((self:GetClientNumber("spnflat") or 0) ~= 0)
end

function TOOL:GetExportDB()
  return ((self:GetClientNumber("exportdb") or 0) ~= 0)
end

function TOOL:GetLogLines()
  return (asmlib.GetAsmVar("logsmax","INT") or 0)
end

function TOOL:GetLogFile()
  return (asmlib.GetAsmVar("logfile","STR") or "")
end

function TOOL:GetAdviser()
  return ((self:GetClientNumber("adviser") or 0) ~= 0)
end

function TOOL:GetPointID()
  return (self:GetClientNumber("pointid") or 1),
         (self:GetClientNumber("pnextid") or 2)
end

function TOOL:GetActiveRadius()
  return mathClamp(self:GetClientNumber("activrad") or 0,0,asmlib.GetAsmVar("maxactrad", "FLT"))
end

function TOOL:GetAngSnap()
  return mathClamp(self:GetClientNumber("angsnap"),0,gnMaxOffRot)
end

function TOOL:GetForceLimit()
  return mathClamp(self:GetClientNumber("forcelim"),0,asmlib.GetAsmVar("maxforce" ,"FLT"))
end

function TOOL:GetWeld()
  return ((self:GetClientNumber("weld") or 0) ~= 0)
end

function TOOL:GetIgnorePhysgun()
  return ((self:GetClientNumber("ignphysgn") or 0) ~= 0)
end

function TOOL:GetSpawnCenter()
  return ((self:GetClientNumber("spawncn") or 0) ~= 0)
end

function TOOL:GetStackAttempts()
  return (mathClamp(self:GetClientNumber("maxstatts"),1,5))
end

function TOOL:GetPhysMeterial()
  return (self:GetClientInfo("physmater") or "metal")
end

function TOOL:GetBoundErrorMode()
  return asmlib.GetAsmVar("bnderrmod" ,"STR")
end

function TOOL:GetSurfaceSnap()
  return ((self:GetClientNumber("surfsnap") or 0) ~= 0)
end

function TOOL:GetScrollMouse()
  return asmlib.GetAsmVar("enpntmscr","BUL")
end

function TOOL:SwitchPoint(nDir, bIsNext)
  local Dir = (tonumber(nDir) or 0)
  local Rec = asmlib.CacheQueryPiece(self:GetModel())
  local pointid, pnextid = self:GetPointID()
  local pointbu = pointid -- Create backup
  if(bIsNext) then pnextid = asmlib.IncDecPnextID(pnextid,pointid,Dir,Rec)
  else             pointid = asmlib.IncDecPointID(pointid,Dir,Rec) end
  if(pointid == pnextid) then pnextid = pointbu end
  RunConsoleCommand(gsToolPrefL.."pnextid", pnextid)
  RunConsoleCommand(gsToolPrefL.."pointid", pointid)
  asmlib.LogInstance("TOOL:SwitchPoint("..tostring(Dir)..","..tostring(bIsNext).."): Success")
  return pointid, pnextid
end

function TOOL:IntersectClear(bMute)
  local oPly = self:GetOwner()
  local stRay = asmlib.IntersectRayRead(oPly, "ray_relate")
  if(stRay) then
    asmlib.IntersectRayClear(oPly, "ray_relate")
    if(SERVER) then local ryEnt, sRel = stRay.Ent
      netStart(gsLibName.."SendIntersectClear"); netWriteEntity(oPly); netSend(oPly)
      if(ryEnt and ryEnt:IsValid()) then ryEnt:SetColor(conPalette:Select("w"))
        sRel = ryEnt:EntIndex()..gsSymRev..ryEnt:GetModel():GetFileFromFilename() end
      if(not bMute) then sRel = (sRel and (": "..tostring(sRel)) or "")
        asmlib.LogInstance("TOOL:IntersectClear: Relation cleared"..sRel)
        asmlib.PrintNotifyPly(oPly,"Intersect relation clear"..sRel.." !","CLEANUP")
      end -- Make sure to delete the relation on both client and server
    end
  end; return true
end

function TOOL:IntersectRelate(oPly, oEnt, vHit)
  self:IntersectClear(true) -- Clear intersect related player on new relation
  local stRay = asmlib.IntersectRayCreate(oPly, oEnt, vHit, "ray_relate")
  if(not stRay) then -- Create/update the ray in question
    return asmlib.StatusLog(false,"TOOL:IntersectRelate(): Update fail") end
  if(SERVER) then -- Only the server is allowed to define relation ray
    netStart(gsLibName.."SendIntersectRelate")
    netWriteEntity(oEnt); netWriteVector(vHit); netWriteEntity(oPly); netSend(oPly)
    local sRel = oEnt:EntIndex()..gsSymRev..oEnt:GetModel():GetFileFromFilename()
    asmlib.PrintNotifyPly(oPly,"Intersect relation set: "..sRel.." !","UNDO")
    stRay.Ent:SetColor(conPalette:Select("ry"))
  end return true
end

function TOOL:IntersectSnap(trEnt, vHit, stSpawn, bMute)
  local pointid, pnextid = self:GetPointID()
  local ply, model = self:GetOwner(), self:GetModel()
  if(not asmlib.IntersectRayCreate(ply, trEnt, vHit, "ray_origin")) then
    return asmlib.StatusLog(nil,"TOOL:LeftClick(): Failed updating ray") end
  local xx, x1, x2, stRay1, stRay2 = asmlib.IntersectRayHash(ply, "ray_origin", "ray_relate")
  if(not xx) then
    if(bMute) then return nil
    else asmlib.PrintNotifyPly(ply, "Define intersection relation !", "GENERIC")
      return asmlib.StatusLog(nil, "TOOL:IntersectSnap(): Active ray mismatch")
    end
  end
  local mx, o1, o2 = asmlib.IntersectRayModel(model, pointid, pnextid)
  if(not mx) then
    if(bMute) then return nil
    else return asmlib.StatusLog(nil, "TOOL:IntersectSnap(): Model ray mismatch") end
  end
  local aOrg, vx, vy, vz = stSpawn.OAng, stSpawn.PNxt[cvX], stSpawn.PNxt[cvY], stSpawn.PNxt[cvZ]
  if(self:ApplyAngularFirst()) then aOrg = stRay1.Diw end
  mx:Rotate(stSpawn.SAng); mx:Mul(-1) -- Translate newly created entity local intersection to world
  stSpawn.SPos:Set(mx); stSpawn.SPos:Add(xx); -- Update spawn position with the ray intersection
  local cx, cy, cz = aOrg:Forward(), aOrg:Right(), aOrg:Up()
  if(self:ApplyLinearFirst()) then
    local dx = Vector(); dx:Set(o1); dx:Rotate(stSpawn.SAng); dx:Add(stSpawn.SPos); dx:Sub(stRay1.Orw)
    local dy = Vector(); dy:Set(o2); dy:Rotate(stSpawn.SAng); dy:Add(stSpawn.SPos); dy:Sub(stRay2.Orw)
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
  local svEnt, plPly = self:GetEnt(1), self:GetOwner()
  if(CLIENT) then return end; self:ClearObjects()
  asmlib.ConCommandPly(plPly,"anchor",gsNoAnchor)
  if(svEnt and svEnt:IsValid()) then
    svEnt:SetColor(conPalette:Select("w"))
    svEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
    if(not bMute) then
      local sAnchor = svEnt:EntIndex()..gsSymRev..svEnt:GetModel():GetFileFromFilename()
      asmlib.PrintNotifyPly(plPly,"Anchor: Cleaned "..sAnchor.." !","CLEANUP") end
  end; return asmlib.StatusLog(true,"TOOL:ClearAnchor("..tostring(bMute).."): Anchor cleared")
end

function TOOL:SetAnchor(stTrace)
  self:ClearAnchor(true)
  if(not stTrace) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Trace invalid") end
  if(not stTrace.Hit) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Trace not hit") end
  local trEnt = stTrace.Entity
  if(not (trEnt and trEnt:IsValid())) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Trace no entity") end
  local phEnt = trEnt:GetPhysicsObject()
  if(not (phEnt and phEnt:IsValid())) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Trace no physics") end
  local plPly = self:GetOwner()
  if(not (plPly and plPly:IsValid())) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Player invalid") end
  local sAnchor = trEnt:EntIndex()..gsSymRev..trEnt:GetModel():GetFileFromFilename()
  trEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
  trEnt:SetColor(conPalette:Select("an"))
  self:SetObject(1,trEnt,stTrace.HitPos,phEnt,stTrace.PhysicsBone,stTrace.HitNormal)
  asmlib.ConCommandPly(plPly,"anchor",sAnchor)
  asmlib.PrintNotifyPly(plPly,"Anchor: Set "..sAnchor.." !","UNDO")
  return asmlib.StatusLog(true,"TOOL:SetAnchor("..sAnchor..")")
end

function TOOL:GetAnchor()
  local svEnt = self:GetEnt(1)
  if(not (svEnt and svEnt:IsValid())) then svEnt = nil end
  return (self:GetClientInfo("anchor") or gsNoAnchor), svEnt
end

function TOOL:GetWorkingMode() -- Put cases in new mode resets here
  local workmode = mathClamp(self:GetClientNumber("workmode") or 0, 1, #gtWorkMode)
  -- Perform various actions to stabilize data across working modes
  if    (workmode == 1) then self:IntersectClear(true) -- Reset ray list in snap mode
  elseif(workmode == 2) then --[[ Nothing to reset in intersect mode ]] end
  return workmode, tostring(gtWorkMode[workmode] or gsNoAV) -- Reset settings server-side where available and return the value
end

function TOOL:GetStatus(stTrace,anyMessage,hdEnt)
  local iMaxlog = asmlib.GetOpVar("LOG_MAXLOGS")
  if(not (iMaxlog > 0)) then return "Status N/A" end
  local ply, sDelim  = self:GetOwner(), "\n"
  local iCurLog = asmlib.GetOpVar("LOG_CURLOGS")
  local sFleLog = asmlib.GetOpVar("LOG_LOGFILE")
  local sSpace  = (" "):rep(6 + tostring(iMaxlog):len())
  local workmode, workname = self:GetWorkingMode()
  local aninfo , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local nextx  , nexty   , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw , nextrol = self:GetAngOffsets()
  local hdModel, trModel , trRec   = self:GetModel()
  local hdRec = asmlib.CacheQueryPiece(hdModel)
  if(stTrace and stTrace.Entity and stTrace.Entity:IsValid()) then
    trModel = stTrace.Entity:GetModel()
    trRec   = asmlib.CacheQueryPiece(trModel)
  end
  local sDu = ""
        sDu = sDu..tostring(anyMessage)..sDelim
        sDu = sDu..sSpace.."Dumping logs state:"..sDelim
        sDu = sDu..sSpace.."  LogsMax:        <"..tostring(iMaxlog)..">"..sDelim
        sDu = sDu..sSpace.."  LogsCur:        <"..tostring(iCurLog)..">"..sDelim
        sDu = sDu..sSpace.."  LogFile:        <"..tostring(sFleLog)..">"..sDelim
        sDu = sDu..sSpace.."  MaxProps:       <"..tostring(GetConVar("sbox_maxprops"):GetInt())..">"..sDelim
        sDu = sDu..sSpace.."  MaxTrack:       <"..tostring(GetConVar("sbox_max"..gsLimitName):GetInt())..">"..sDelim
        sDu = sDu..sSpace.."Dumping player keys:"..sDelim
        sDu = sDu..sSpace.."  Player:         "..tostring(ply):gsub("Player%s","")..sDelim
        sDu = sDu..sSpace.."  IN.USE:         <"..tostring(asmlib.CheckButtonPly(ply,IN_USE))..">"..sDelim
        sDu = sDu..sSpace.."  IN.DUCK:        <"..tostring(asmlib.CheckButtonPly(ply,IN_DUCK))..">"..sDelim
        sDu = sDu..sSpace.."  IN.SPEED:       <"..tostring(asmlib.CheckButtonPly(ply,IN_SPEED))..">"..sDelim
        sDu = sDu..sSpace.."  IN.RELOAD:      <"..tostring(asmlib.CheckButtonPly(ply,IN_RELOAD))..">"..sDelim
        sDu = sDu..sSpace.."  IN.SCORE:       <"..tostring(asmlib.CheckButtonPly(ply,IN_SCORE))..">"..sDelim
        sDu = sDu..sSpace.."Dumping trace data state:"..sDelim
        sDu = sDu..sSpace.."  Trace:          <"..tostring(stTrace)..">"..sDelim
        sDu = sDu..sSpace.."  TR.Hit:         <"..tostring(stTrace and stTrace.Hit or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  TR.HitW:        <"..tostring(stTrace and stTrace.HitWorld or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  TR.ENT:         <"..tostring(stTrace and stTrace.Entity or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  TR.Model:       <"..tostring(trModel or gsNoAV)..">["..tostring(trRec and trRec.Kept or gsNoID).."]"..sDelim
        sDu = sDu..sSpace.."  TR.File:        <"..(trModel and tostring(trModel):GetFileFromFilename() or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."Dumping console variables state:"..sDelim
        sDu = sDu..sSpace.."  HD.Entity:      {"..tostring(hdEnt or gsNoAV).."}"..sDelim
        sDu = sDu..sSpace.."  HD.Model:       <"..tostring(hdModel or gsNoAV)..">["..tostring(hdRec and hdRec.Kept or gsNoID).."]"..sDelim
        sDu = sDu..sSpace.."  HD.File:        <"..tostring(hdModel or gsNoAV):GetFileFromFilename()..">"..sDelim
        sDu = sDu..sSpace.."  HD.Weld:        <"..tostring(self:GetWeld())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Mass:        <"..tostring(self:GetMass())..">"..sDelim
        sDu = sDu..sSpace.."  HD.StackCNT:    <"..tostring(self:GetCount())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Freeze:      <"..tostring(self:GetFreeze())..">"..sDelim
        sDu = sDu..sSpace.."  HD.YawSnap:     <"..tostring(self:GetAngSnap())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Gravity:     <"..tostring(self:GetGravity())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Adviser:     <"..tostring(self:GetAdviser())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ForceLimit:  <"..tostring(self:GetForceLimit())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Elevation:   <"..tostring(self:GetElevation())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ExportDB:    <"..tostring(self:GetExportDB())..">"..sDelim
        sDu = sDu..sSpace.."  HD.NoCollide:   <"..tostring(self:GetNoCollide())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SpawnFlat:   <"..tostring(self:GetSpawnFlat())..">"..sDelim
        sDu = sDu..sSpace.."  HD.IgnoreType:  <"..tostring(self:GetIgnoreType())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SurfSnap:    <"..tostring(self:GetSurfaceSnap())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SpawnCen:    <"..tostring(self:GetSpawnCenter())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Workmode:    ["..tostring(workmode or gsNoAV).."]<"..tostring(workname or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  HD.AppAngular:  <"..tostring(self:ApplyAngularFirst())..">"..sDelim
        sDu = sDu..sSpace.."  HD.AppLinear:   <"..tostring(self:ApplyLinearFirst())..">"..sDelim
        sDu = sDu..sSpace.."  HD.PntAssist:   <"..tostring(self:GetPointAssist())..">"..sDelim
        sDu = sDu..sSpace.."  HD.GhostHold:   <"..tostring(self:GetGhostHolder())..">"..sDelim
        sDu = sDu..sSpace.."  HD.PhysMeter:   <"..tostring(self:GetPhysMeterial())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ActRadius:   <"..tostring(self:GetActiveRadius())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SkinBG:      <"..tostring(self:GetBodyGroupSkin())..">"..sDelim
        sDu = sDu..sSpace.."  HD.StackAtempt: <"..tostring(self:GetStackAttempts())..">"..sDelim
        sDu = sDu..sSpace.."  HD.IgnorePG:    <"..tostring(self:GetIgnorePhysgun())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ModDataBase: <"..gsModeDataB..","..tostring(asmlib.GetAsmVar("modedb" ,"STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.TimerMode:   <"..tostring(asmlib.GetAsmVar("timermode","STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.EnableWire:  <"..tostring(asmlib.GetAsmVar("enwiremod","BUL"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.DevelopMode: <"..tostring(asmlib.GetAsmVar("devmode"  ,"BUL"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxMass:     <"..tostring(asmlib.GetAsmVar("maxmass"  ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxLinear:   <"..tostring(asmlib.GetAsmVar("maxlinear","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxForce:    <"..tostring(asmlib.GetAsmVar("maxforce" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxARadius:  <"..tostring(asmlib.GetAsmVar("maxactrad","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxStackCnt: <"..tostring(asmlib.GetAsmVar("maxstcnt" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.BoundErrMod: <"..tostring(asmlib.GetAsmVar("bnderrmod","STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxFrequent: <"..tostring(asmlib.GetAsmVar("maxfruse" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxTrMargin: <"..tostring(asmlib.GetAsmVar("maxtrmarg","FLT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.Anchor:      {"..tostring(anEnt or gsNoAV).."}<"..tostring(aninfo)..">"..sDelim
        sDu = sDu..sSpace.."  HD.PointID:     ["..tostring(pointid).."] >> ["..tostring(pnextid).."]"..sDelim
        sDu = sDu..sSpace.."  HD.AngOffsets:  ["..tostring(nextx)..","..tostring(nexty)..","..tostring(nextz).."]"..sDelim
        sDu = sDu..sSpace.."  HD.PosOffsets:  ["..tostring(nextpic)..","..tostring(nextyaw)..","..tostring(nextrol).."]"..sDelim
  if(hdEnt and hdEnt:IsValid()) then hdEnt:Remove() end
  return sDu
end

function TOOL:SelectModel(sModel)
  local trRec = asmlib.CacheQueryPiece(sModel)
  if(not trRec) then
    return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:SelectModel: Model <"..sModel.."> not piece")) end
  local ply = self:GetOwner()
  local pointid, pnextid = self:GetPointID()
        pointid, pnextid = asmlib.SnapReview(pointid, pnextid, trRec.Kept)
  asmlib.PrintNotifyPly(ply,"Model: "..sModel:GetFileFromFilename().." selected !","UNDO")
  asmlib.ConCommandPly (ply,"pointid", pointid)
  asmlib.ConCommandPly (ply,"pnextid", pnextid)
  asmlib.ConCommandPly (ply, "model" , sModel)
  return asmlib.StatusLog(true,"TOOL:SelectModel: Success <"..sModel..">")
end

function TOOL:LeftClick(stTrace)
  if(CLIENT) then
    return asmlib.StatusLog(true,"TOOL:LeftClick(): Working on client") end
  if(not stTrace) then
    return asmlib.StatusLog(false,"TOOL:LeftClick(): Trace missing") end
  if(not stTrace.Hit) then
    return asmlib.StatusLog(false,"TOOL:LeftClick(): Trace not hit") end
  local trEnt     = stTrace.Entity
  local weld      = self:GetWeld()
  local mass      = self:GetMass()
  local model     = self:GetModel()
  local count     = self:GetCount()
  local ply       = self:GetOwner()
  local freeze    = self:GetFreeze()
  local angsnap   = self:GetAngSnap()
  local gravity   = self:GetGravity()
  local elevpnt   = self:GetElevation()
  local nocollide = self:GetNoCollide()
  local spnflat   = self:GetSpawnFlat()
  local igntype   = self:GetIgnoreType()
  local forcelim  = self:GetForceLimit()
  local spawncn   = self:GetSpawnCenter()
  local surfsnap  = self:GetSurfaceSnap()
  local workmode  = self:GetWorkingMode()
  local physmater = self:GetPhysMeterial()
  local actrad    = self:GetActiveRadius()
  local bgskids   = self:GetBodyGroupSkin()
  local maxstatts = self:GetStackAttempts()
  local ignphysgn = self:GetIgnorePhysgun()
  local bnderrmod = self:GetBoundErrorMode()
  local appangfst = self:ApplyAngularFirst()
  local applinfst = self:ApplyLinearFirst()
  local fnmodel   = model:GetFileFromFilename()
  local aninfo , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  if(stTrace.HitWorld) then -- Switch the tool mode ( Spawn )
    local vPos = Vector(); vPos:Set(stTrace.HitPos)
    local aAng = asmlib.GetNormalAngle(ply,stTrace,surfsnap,angsnap)
    if(spawncn) then  -- Spawn on mass centre
      aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
      aAng:RotateAroundAxis(aAng:Right()  , nextpic)
      aAng:RotateAroundAxis(aAng:Forward(), nextrol)
    else
      local stSpawn = asmlib.GetNormalSpawn(ply,stTrace.HitPos + elevpnt * stTrace.HitNormal,aAng,model,
                        pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(not stSpawn) then -- Make sure it persists to set it afterwards
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(World): Cannot obtain spawn data")) end
      vPos:Set(stSpawn.SPos); aAng:Set(stSpawn.SAng)
    end
    local ePiece = asmlib.MakePiece(ply,model,vPos,aAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
    if(ePiece) then
      if(spawncn) then -- Adjust the position when created correctly
        local vOBB = ePiece:OBBMins()
        local vCen = asmlib.GetCenter(ePiece)
                     asmlib.AddVectorXYZ(vCen, nextx, -nexty, nextz-vOBB[cvZ])
        vCen:Rotate(aAng); vPos:Add(vCen); ePiece:SetPos(vPos)
      end
      if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(World): Failed to apply physical settings",ePiece)) end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,anEnt,weld,nocollide,forcelim)) then
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(World): Failed to apply physical anchor",ePiece)) end
      asmlib.UndoCratePly(gsUndoPrefN..fnmodel.." ( World spawn )")
      asmlib.UndoAddEntityPly(ePiece)
      asmlib.UndoFinishPly(ply)
      return asmlib.StatusLog(true,"TOOL:LeftClick(World): Success")
    end
    return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(World): Failed to create"))
  end

  if(not (trEnt and trEnt:IsValid())) then
    return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Prop): Trace entity invalid")) end
  if(asmlib.IsOther(trEnt)) then
    return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Prop): Trace other object")) end
  if(not asmlib.IsPhysTrace(stTrace)) then
    return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Prop): Trace not physical object")) end

  local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  if(not trRec) then return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Prop): Trace model not piece")) end

  local hdRec = asmlib.CacheQueryPiece(model)
  if(not hdRec) then return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Prop): Holder model not piece")) end

  local stSpawn = asmlib.GetEntitySpawn(ply,trEnt,stTrace.HitPos,model,pointid,
                           actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
  if(not stSpawn) then -- Not aiming into an active point update settings/properties
    if(asmlib.CheckButtonPly(ply,IN_USE)) then -- Physical
      if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Physical): Failed to apply physical settings",ePiece)) end
      if(not asmlib.ApplyPhysicalAnchor(trEnt,anEnt,weld,nocollide,forcelim)) then
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Physical): Failed to apply physical anchor",ePiece)) end
      trEnt:GetPhysicsObject():SetMass(mass)
      return asmlib.StatusLog(true,"TOOL:LeftClick(Physical): Success")
    else -- Visual
      local IDs = gsSymDir:Explode(bgskids)
      if(not asmlib.AttachBodyGroups(trEnt,IDs[1] or "")) then
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Bodygroup/Skin): Failed")) end
      trEnt:SetSkin(mathClamp(tonumber(IDs[2]) or 0,0,trEnt:SkinCount()-1))
      return asmlib.StatusLog(true,"TOOL:LeftClick(Bodygroup/Skin): Success")
    end
  end

  if(workmode == 1 and asmlib.CheckButtonPly(ply,IN_SPEED) and (tonumber(hdRec.Kept) or 0) > 1) then -- IN_SPEED: Switch the tool mode ( Stacking )
    if(count <= 0) then return asmlib.StatusLog(false,self:GetStatus(stTrace,"Stack count not properly picked")) end
    if(pointid == pnextid) then return asmlib.StatusLog(false,self:GetStatus(stTrace,"Point ID overlap")) end
    local ePieceO, ePieceN = trEnt
    local iNdex, iTrys = 1, maxstatts
    local vTemp, trPos = Vector(), trEnt:GetPos()
    local hdOffs = asmlib.LocatePOA(stSpawn.HRec,pnextid)
    if(not hdOffs) then -- Make sure it is present
      asmlib.PrintNotifyPly(ply,"Cannot find next PointID !","ERROR")
      return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Stack): Missing next point ID"))
    end -- Validated existent next point ID
    asmlib.UndoCratePly(gsUndoPrefN..fnmodel.." ( Stack #"..tostring(count).." )")
    while(iNdex <= count) do
      local sIterat = "["..tostring(iNdex).."]"
      ePieceN = asmlib.MakePiece(ply,model,stSpawn.SPos,stSpawn.SAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
      if(ePieceN) then -- Set position is valid
        if(not asmlib.ApplyPhysicalSettings(ePieceN,ignphysgn,freeze,gravity,physmater)) then
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Stack)"..sIterat..": Apply physical settings fail")) end
        if(not asmlib.ApplyPhysicalAnchor(ePieceN,(anEnt or ePieceO),weld,nil,forcelim)) then
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Stack)"..sIterat..": Apply weld fail")) end
        if(not asmlib.ApplyPhysicalAnchor(ePieceN,ePieceO,nil,nocollide,forcelim)) then
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Stack)"..sIterat..": Apply no-collide fail")) end
        asmlib.SetVector(vTemp,hdOffs.P)
        vTemp:Rotate(stSpawn.SAng)
        vTemp:Add(ePieceN:GetPos())
        asmlib.UndoAddEntityPly(ePieceN)
        if(appangfst) then nextpic,nextyaw,nextrol, appangfst = 0,0,0,false end
        if(applinfst) then nextx  ,nexty  ,nextz  , applinfst = 0,0,0,false end
        stSpawn = asmlib.GetEntitySpawn(ply,ePieceN,vTemp,model,pointid,
                    actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
        if(not stSpawn) then -- Look both ways in a one way street :D
          asmlib.PrintNotifyPly(ply,"Cannot obtain spawn data!","ERROR")
          asmlib.UndoFinishPly(ply,sIterat)
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Stack)"..sIterat..": Stacking has invalid user data"))
        end -- Spawn data is valid for the current iteration iNdex
        ePieceO, iNdex, iTrys = ePieceN, (iNdex + 1), maxstatts
      else iTrys = iTrys - 1 end
      if(iTrys <= 0) then
        asmlib.UndoFinishPly(ply,sIterat) --  Make it shoot but throw the error
        return asmlib.StatusLog(true,self:GetStatus(stTrace,"TOOL:LeftClick(Stack)"..sIterat..": All stack attempts fail"))
      end -- We still have enough memory to preform the stacking
    end
    asmlib.UndoFinishPly(ply)
    return asmlib.StatusLog(true,"TOOL:LeftClick(Stack): Success")
  else -- Switch the tool mode ( Snapping )
    if(workmode == 2) then -- Make a ray intersection spawn update
      if(not self:IntersectSnap(trEnt, stTrace.HitPos, stSpawn)) then
        asmlib.LogInstance("TOOL:LeftClick(Ray): Skip intersection sequence. Snapping") end
    end
    local ePiece = asmlib.MakePiece(ply,model,stSpawn.SPos,stSpawn.SAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
    if(ePiece) then
      if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Snap): Apply physical settings fail")) end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or trEnt),weld,nil,forcelim)) then -- Weld all created to the anchor/previous
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Snap): Apply weld fail")) end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,trEnt,nil,nocollide,forcelim)) then       -- NoCollide all to previous
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Snap): Apply no-collide fail")) end
      asmlib.UndoCratePly(gsUndoPrefN..fnmodel.." ( Snap prop )")
      asmlib.UndoAddEntityPly(ePiece)
      asmlib.UndoFinishPly(ply)
      return asmlib.StatusLog(true,"TOOL:LeftClick(Snap): Success")
    end
    return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Snap): Crating piece fail"))
  end
end

--[[
 * If tells what will happen if the RightClick of the mouse is pressed
 * Changes the active point chosen by the holder or copy the model
]]--
function TOOL:RightClick(stTrace)
  if(CLIENT) then return asmlib.StatusLog(true,"TOOL:RightClick(): Working on client") end
  if(not stTrace) then return asmlib.StatusLog(false,"TOOL:RightClick(): Trace missing") end
  local trEnt     = stTrace.Entity
  local ply       = self:GetOwner()
  local workmode  = self:GetWorkingMode()
  local enpntmscr = self:GetScrollMouse()
  if(stTrace.HitWorld) then
    if(asmlib.CheckButtonPly(ply,IN_USE)) then
      asmlib.ConCommandPly(ply,"openframe",asmlib.GetAsmVar("maxfruse" ,"INT"))
      return asmlib.StatusLog(true,"TOOL:RightClick(World): Success open frame")
    end
  elseif(trEnt and trEnt:IsValid()) then
    if(enpntmscr) then
      if(not self:SelectModel(trEnt:GetModel())) then
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:RightClick(Select,"..tostring(enpntmscr).."): Model not piece")) end
      return asmlib.StatusLog(true,"TOOL:RightClick(Select,"..tostring(enpntmscr).."): Success")
    else
      if(asmlib.CheckButtonPly(ply,IN_USE)) then
        if(not self:SelectModel(trEnt:GetModel())) then
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:RightClick(Select,"..tostring(enpntmscr).."): Model not piece")) end
        return asmlib.StatusLog(true,"TOOL:RightClick(Select,"..tostring(enpntmscr).."): Success")
      end
    end
  end
  if(not enpntmscr) then
    local Dir = (asmlib.CheckButtonPly(ply,IN_SPEED) and -1) or 1
    self:SwitchPoint(Dir,asmlib.CheckButtonPly(ply,IN_DUCK))
    return asmlib.StatusLog(true,"TOOL:RightClick(Point): Success")
  end
end

function TOOL:Reload(stTrace)
  if(CLIENT) then
    return asmlib.StatusLog(true,"TOOL:Reload(): Working on client") end
  if(not stTrace) then
    return asmlib.StatusLog(false,"TOOL:Reload(): Invalid trace") end
  local ply      = self:GetOwner()
  local trEnt    = stTrace.Entity
  local workmode = self:GetWorkingMode()
  if(stTrace.HitWorld) then
    if(self:GetDeveloperMode()) then
      asmlib.SetLogControl(self:GetLogLines(),self:GetLogFile()) end
    if(self:GetExportDB()) then
      asmlib.LogInstance("TOOL:Reload(World): Exporting DB")
      asmlib.ExportDSV("PIECES")
      asmlib.ExportDSV("ADDITIONS")
      asmlib.ExportDSV("PHYSPROPERTIES")
      asmlib.ConCommandPly(ply, "exportdb", 0)
    end
    if(asmlib.CheckButtonPly(ply,IN_SPEED)) then
      if(workmode == 1) then self:ClearAnchor(false)
        asmlib.LogInstance("TOOL:Reload(Anchor): Clear")
      elseif(workmode == 2) then self:IntersectClear(false)
        asmlib.LogInstance("TOOL:Reload(Relate): Clear")
      end
    end; return asmlib.StatusLog(true,"TOOL:Reload(World): Success")
  elseif(trEnt and trEnt:IsValid()) then
    if(not asmlib.IsPhysTrace(stTrace)) then return false end
    if(asmlib.IsOther(trEnt)) then
      return asmlib.StatusLog(false,"TOOL:Reload(Prop): Trace other object") end
    if(asmlib.CheckButtonPly(ply,IN_SPEED)) then
      if(workmode == 1) then -- General anchor
        if(not self:SetAnchor(stTrace)) then
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:Reload(Prop): Anchor set fail")) end
        return asmlib.StatusLog(true,"TOOL:Reload(Prop): Anchor set")
      elseif(workmode == 2) then -- Intersect relation
        if(not self:IntersectRelate(ply, trEnt, stTrace.HitPos)) then
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:Reload(Prop): Relation set fail")) end
        return asmlib.StatusLog(true,"TOOL:Reload(Prop): Relation set")
      end
    end
    local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
    if(asmlib.IsExistent(trRec)) then trEnt:Remove()
      return asmlib.StatusLog(true,"TOOL:Reload(Prop): Removed a piece")
    end
  end
  return false
end

function TOOL:Holster()
  local gho = self.GhostEntity
  self:ReleaseGhostEntity() -- Remove the ghost prop to save memory
  if(gho and gho:IsValid()) then gho:Remove() end
end

function TOOL:UpdateGhost(ePiece, oPly)
  if(not (ePiece and ePiece:IsValid())) then return end
  ePiece:SetNoDraw(true)
  ePiece:DrawShadow(false)
  ePiece:SetColor(conPalette:Select("gh"))
  local stTrace = asmlib.CacheTracePly(oPly)
  if(not stTrace) then return end
  local trEnt = stTrace.Entity
  local model = self:GetModel()
  local workmode = self:GetWorkingMode()
  local pointid, pnextid = self:GetPointID()
  local nextx, nexty, nextz = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  if(stTrace.HitWorld) then
    local angsnap  = self:GetAngSnap()
    local surfsnap = self:GetSurfaceSnap()
    local aAng = asmlib.GetNormalAngle(oPly,stTrace,surfsnap,angsnap)
    if(self:GetSpawnCenter()) then
      aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
      aAng:RotateAroundAxis(aAng:Right()  , nextpic)
      aAng:RotateAroundAxis(aAng:Forward(), nextrol)
      local vOBB, vPos = ePiece:OBBMins(), Vector(); vPos:Set(stTrace.HitPos)
      local vCen = asmlib.GetCenter(ePiece)
                   asmlib.AddVectorXYZ(vCen, nextx, -nexty, nextz-vOBB[cvZ])
      vCen:Rotate(aAng); vPos:Add(vCen)
      ePiece:SetPos(vPos); ePiece:SetAngles(aAng); ePiece:SetNoDraw(false)
    else
      local stSpawn = asmlib.GetNormalSpawn(oPly,stTrace.HitPos + self:GetElevation() * stTrace.HitNormal,
                        aAng,model,pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(stSpawn) then
        ePiece:SetAngles(stSpawn.SAng); ePiece:SetPos(stSpawn.SPos); ePiece:SetNoDraw(false)
      end
    end
  elseif(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return end
    local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
    if(trRec) then
      local spnflat  = self:GetSpawnFlat()
      local igntype  = self:GetIgnoreType()
      local actrad   = self:GetActiveRadius()
      local stSpawn = asmlib.GetEntitySpawn(oPly,trEnt,stTrace.HitPos,model,pointid,
                        actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(stSpawn) then
        if(workmode == 2) then
          self:IntersectSnap(trEnt, stTrace.HitPos, stSpawn, true) end
        ePiece:SetPos(stSpawn.SPos); ePiece:SetAngles(stSpawn.SAng); ePiece:SetNoDraw(false)
      end
    end
  end
end

function TOOL:ElevateGhost(oEnt, oPly)
  if(not (oPly and oPly:IsValid() and oPly:IsPlayer())) then
    return asmlib.StatusLog(nil, "TOOL:ElevateGhost: Player invalid <"..tostring(oPly)..">") end
  local spawncn, elevpnt = self:GetSpawnCenter()
  if(oEnt and oEnt:IsValid()) then
    if(spawncn) then -- Distance for the piece spawned on the ground
      local vobdbox = oEnt:OBBMins(); elevpnt = -vobdbox[cvZ]
    else -- Refresh the variable when model changes to unload the network
      local pointid, pnextid = self:GetPointID()
            elevpnt = (asmlib.GetPointElevation(oEnt, pointid) or 0)
    end; asmlib.ConCommandPly(oPly, "elevpnt", elevpnt)
    asmlib.LogInstance("TOOL:ElevateGhost("..tostring(spawncn).."): <"..tostring(elevpnt)..">")
  end
end

function TOOL:Think()
  local model = self:GetModel()
  local wormo = self:GetWorkingMode() -- Synchronize the data between the working modes
  if(utilIsValidModel(model)) then -- Chech model validation
    local ply = self:GetOwner()
    local gho = self.GhostEntity
    if(self:GetGhostHolder()) then
      if(not (gho and gho:IsValid() and gho:GetModel() == model)) then
        self:MakeGhostEntity(model,VEC_ZERO,ANG_ZERO)
        self:ElevateGhost(self.GhostEntity, ply)   -- E-le-va-tion ! Yes U2
      end; self:UpdateGhost(self.GhostEntity, ply) -- In client single player the grost is skipped
    else self:ReleaseGhostEntity() end -- Delete the ghost entity when ghosting is disabled
    if(CLIENT and inputIsKeyDown(KEY_LALT) and inputIsKeyDown(KEY_E)) then
      local pnFrame = asmlib.GetOpVar("PANEL_FREQUENT_MODELS")
      if(pnFrame and IsValid(pnFrame)) then pnFrame.OnClose() end -- That was a /close call/ :D
    end -- Shortcut for closing the routine pieces
  end
end

--[[
 * This function draws value snapshot of the spawn structure in the screen
 * oScreen > Screen to draw the text on
 * sCol    > Text draw color
 * sMeth   > Text draw method
 * tArgs   > Text draw arguments
]]--
function TOOL:DrawTextSpawn(oScreen, sCol, sMeth, tArgs)
  local ply = LocalPlayer()
  local stS = asmlib.CacheSpawnPly(ply)
  local arK = asmlib.GetOpVar("STRUCT_SPAWN")
  local w,h = oScreen:GetSize()
  oScreen:SetTextEdge(w - 500,0)
  oScreen:DrawText("Spawn debug information",sCol,sMeth,tArgs)
  for ID = 1, #arK, 1 do local def = arK[ID]
    local key, typ, inf = def[1], def[2], tostring(def[3] or "")
    local cnv = ((not asmlib.IsEmptyString(inf)) and (" > "..inf) or "")
    if(not asmlib.IsExistent(typ)) then oScreen:DrawText(tostring(key))
    else local typ, val = tostring(typ or ""), tostring(stS[key] or "")
      oScreen:DrawText("<"..key.."> "..typ..": "..val..cnv) end
  end
end

function TOOL:DrawRelateIntersection(oScreen, oPly, nRad)
  local stRay = asmlib.IntersectRayRead(oPly, "ray_relate")
  if(not stRay) then return end
  local rOrg, rDir = stRay.Orw, stRay.Diw
  local Rp, nLn = rOrg:ToScreen(), self:GetActiveRadius()
  local Rf = (rOrg + nLn * rDir:Forward()):ToScreen()
  local Ru = (rOrg + nLn * 0.5 * rDir:Up()):ToScreen()
  local rF = (oScreen:GetDistance(Rp, Rf) or 0)
  local rU = 2 * (oScreen:GetDistance(Rp, Ru) or 0)
  local nR = ((rF > rU) and rF or rU)
  oScreen:DrawLine(Rp, Rf, "r")
  oScreen:DrawLine(Rp, Ru, "b")
  oScreen:DrawCircle(Rp, nR / 6, "y")
  return Rp, Rf, Ru
end

function TOOL:DrawRelateAssist(oScreen, trHit, trEnt, plyd, rm, rc)
  local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  if(not trRec) then return end
  local nRad = mathClamp(rm / plyd, 1, rc)
  local vTmp, trLen, trPOA =  Vector(), 0, nil
  local trPos, trAng = trEnt:GetPos(), trEnt:GetAngles()
  for ID = 1, trRec.Kept do
    local stPOA = asmlib.LocatePOA(trRec,ID); if(not stPOA) then
      return asmlib.StatusLog(nil,"TOOL:DrawRelateAssist: Cannot locate #"..tostring(ID)) end
    asmlib.SetVector(vTmp,stPOA.O); vTmp:Rotate(trAng); vTmp:Add(trPos)
    oScreen:DrawCircle(vTmp:ToScreen(), 4 * nRad, "y"); vTmp:Sub(trHit)
    if(not trPOA or (vTmp:Length() < trLen)) then trLen, trPOA = vTmp:Length(), stPOA end
  end; asmlib.SetVector(vTmp,trPOA.O); vTmp:Rotate(trAng); vTmp:Add(trPos)
  local Hp, Op = trHit:ToScreen(), vTmp:ToScreen()
  oScreen:DrawLine(Hp, Op, "y")
  oScreen:DrawCircle(Hp, nRad)
end

function TOOL:DrawSnapAssist(oScreen, nActRad, trEnt, oPly)
  local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  if(not trRec) then return end
  local trPos, trAng = trEnt:GetPos(), trEnt:GetAngles()
  local O, R = Vector(), (nActRad * oPly:GetRight())
  for ID = 1, trRec.Kept do
    local stPOA = asmlib.LocatePOA(trRec,ID); if(not stPOA) then
      return asmlib.StatusLog(nil,"TOOL:DrawSnapAssist: Cannot locate #"..tostring(ID)) end
    asmlib.SetVector(O,stPOA.O); O:Rotate(trAng); O:Add(trPos)
    local Op = O:ToScreen(); O:Add(R)
    local Rp = O:ToScreen()
    local mX = (Rp.x - Op.x); mX = mX * mX
    local mY = (Rp.y - Op.y); mY = mY * mY
    local mR = mathSqrt(mX + mY)
    oScreen:DrawCircle(Op, mR,"y","SEGM",{100})
  end
end

function TOOL:DrawModelIntersection(oScreen, oPly, stSpawn, nRad)
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
    oScreen:DrawLine(Os,Ss,"m")
    oScreen:DrawCircle(Ss, nRad,"c")
    oScreen:DrawCircle(xX, 3 * nRad, "b")
    oScreen:DrawLine(xX,O1,"ry")
    oScreen:DrawLine(xX,O2)
    oScreen:DrawCircle(O1, nRad / 2, "r")
    oScreen:DrawCircle(O2, nRad / 2, "g")
    return xX, O1, O2
  end; return nil
end

function TOOL:DrawUCS(oScreen, vHit, vOrg, aOrg, nRad)
  local Os, Tp, UCS = vOrg:ToScreen(), vHit:ToScreen(), 30
  local Xs = (vOrg + UCS * aOrg:Forward()):ToScreen()
  local Zs = (vOrg + UCS * aOrg:Up()):ToScreen()
  local Ys = (vOrg + UCS * aOrg:Right()):ToScreen()
  oScreen:DrawLine(Os,Xs,"r","SURF")
  oScreen:DrawCircle(Os,nRad,"y","SURF")
  oScreen:DrawLine(Os,Ys,"g")
  oScreen:DrawLine(Os,Zs,"b")
  oScreen:DrawLine(Os,Tp,"y")
  oScreen:DrawCircle(Tp, nRad / 2)
  return Os, Tp
end

function TOOL:DrawPillarIntersection(oScreen, vX, vX1, vX2, nRad)
  local XX, nR = vX:ToScreen(), (1.5 * nRad)
  local X1, X2 = vX1:ToScreen(), vX2:ToScreen()
  oScreen:DrawLine(X1,X2,"ry","SURF")
  oScreen:DrawCircle(X1, nR,"r","SURF")
  oScreen:DrawCircle(X2, nR,"g")
  oScreen:DrawCircle(XX, nR,"b")
  return XX, X1, X2
end

function TOOL:DrawHUD()
  if(SERVER) then return end
  local hudMonitor = asmlib.GetOpVar("MONITOR_GAME")
  if(not hudMonitor) then
    local scrW = surfaceScreenWidth()
    local scrH = surfaceScreenHeight()
    hudMonitor = asmlib.MakeScreen(0,0,scrW,scrH,conPalette)
    if(not hudMonitor) then
      return asmlib.StatusLog(nil,"TOOL:DrawHUD: Invalid screen") end
    asmlib.SetOpVar("MONITOR_GAME", hudMonitor)
    asmlib.LogInstance("TOOL:DrawHUD: Create screen")
  end; hudMonitor:SetColor()
  if(not self:GetAdviser()) then return end
  local oPly = LocalPlayer()
  local stTrace = asmlib.CacheTracePly(oPly)
  if(not stTrace) then return end
  local trEnt, trHit = stTrace.Entity, stTrace.HitPos
  local nrad, plyd, ratiom, ratioc = asmlib.CacheRadiusPly(oPly, trHit, 1)
  local workmode, model = self:GetWorkingMode(), self:GetModel()
  local pointid, pnextid = self:GetPointID()
  local nextx, nexty, nextz = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  if(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return end
    local spnflat = self:GetSpawnFlat()
    local igntype = self:GetIgnoreType()
    local actrad  = self:GetActiveRadius()
    local trPos, trAng = trEnt:GetPos(), trEnt:GetAngles()
    local stSpawn = asmlib.GetEntitySpawn(oPly,trEnt,trHit,model,pointid,
                      actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(not stSpawn) then
      if(not self:GetPointAssist()) then return end
      if(workmode == 1) then
        self:DrawSnapAssist(hudMonitor, actrad, trEnt, oPly)
      elseif(workmode == 2) then
        self:DrawRelateAssist(hudMonitor, trHit, trEnt, plyd, ratiom, ratioc)
      end; return -- The return is very very important ... Must stop on invalid spawn
    end -- Draw the assistants related to the different working modes
    local nRad = nrad * (stSpawn.RLen / actrad)
    local Os, Tp = self:DrawUCS(hudMonitor, trHit, stSpawn.OPos, stSpawn.OAng, nRad)
    local Pp = stSpawn.TPnt:ToScreen()
    hudMonitor:DrawLine(Os,Pp,"r")
    hudMonitor:DrawCircle(Pp, nRad / 2)
    if(workmode == 1) then
      local nxPOA = asmlib.LocatePOA(stSpawn.HRec,pnextid)
      if(nxPOA and stSpawn.HRec.Kept > 1) then
        local vNext = Vector(); asmlib.SetVector(vNext,nxPOA.O)
              vNext:Rotate(stSpawn.SAng); vNext:Add(stSpawn.SPos)
        local Np = vNext:ToScreen() -- Draw Next Point
        hudMonitor:DrawLine(Os,Np,"g")
        hudMonitor:DrawCircle(Np, nRad / 2, "g")
      end
    elseif(workmode == 2) then -- Draw point intersection
      local vX, vX1, vX2 = self:IntersectSnap(trEnt, trHit, stSpawn, true)
      local Rp, Re = self:DrawRelateIntersection(hudMonitor, oPly, nRad)
      if(Rp and vX) then
        local xX , O1 , O2  = self:DrawModelIntersection(hudMonitor, oPly, stSpawn, nRad)
        local pXx, pX1, pX2 = self:DrawPillarIntersection(hudMonitor, vX ,vX1, vX2, nRad)
        hudMonitor:DrawLine(Rp,xX,"ry")
        hudMonitor:DrawLine(Os,xX)
        hudMonitor:DrawLine(Rp,O2,"g")
        hudMonitor:DrawLine(Os,O1,"r")
        hudMonitor:DrawLine(xX,pXx,"b")
      end
    end
    local Ss = stSpawn.SPos:ToScreen()
    hudMonitor:DrawLine(Os,Ss,"m")
    hudMonitor:DrawCircle(Ss, nRad,"c")
    if(not self:GetDeveloperMode()) then return end
    self:DrawTextSpawn(hudMonitor, "k","SURF",{"Trebuchet18"})
  elseif(stTrace.HitWorld) then local nRad = nrad
    local angsnap  = self:GetAngSnap()
    local elevpnt  = self:GetElevation()
    local surfsnap = self:GetSurfaceSnap()
    local workmode = self:GetWorkingMode()
    local aAng = asmlib.GetNormalAngle(oPly,stTrace,surfsnap,angsnap)
    if(self:GetSpawnCenter()) then -- Relative to MC
            aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
            aAng:RotateAroundAxis(aAng:Right()  , nextpic)
            aAng:RotateAroundAxis(aAng:Forward(), nextrol)
      local vPos = Vector()
            vPos:Set(trHit + elevpnt * stTrace.HitNormal)
            vPos:Add(nextx * aAng:Forward())
            vPos:Add(nexty * aAng:Right())
            vPos:Add(nextz * aAng:Up())
      local Os, Tp = self:DrawUCS(hudMonitor, trHit, vPos, aAng, nRad)
      if(workmode == 2) then -- Draw point intersection
        self:DrawRelateIntersection(hudMonitor, oPly, nRad) end
      if(not self:GetDeveloperMode()) then return end
      local x,y = hudMonitor:GetCenter(10,10)
      hudMonitor:SetTextEdge(x,y)
      hudMonitor:DrawText("Org POS: "..tostring(vPos),"k","SURF",{"Trebuchet18"})
      hudMonitor:DrawText("Org ANG: "..tostring(aAng))
    else -- Relative to the active Point
      if(not (pointid > 0 and pnextid > 0)) then return end
      local stSpawn  = asmlib.GetNormalSpawn(oPly,trHit + elevpnt * stTrace.HitNormal,
                         aAng,model,pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(not stSpawn) then return end
      local Os, Tp = self:DrawUCS(hudMonitor, trHit, stSpawn.OPos, stSpawn.OAng, nRad)
      if(workmode == 1) then
        local nxPOA = asmlib.LocatePOA(stSpawn.HRec, pnextid)
        if(nxPOA and stSpawn.HRec.Kept > 1) then
          local vNext = Vector() -- Draw next point when available
                asmlib.SetVector(vNext,nxPOA.O)
                vNext:Rotate(stSpawn.SAng)
                vNext:Add(stSpawn.SPos)
          local Np = vNext:ToScreen()
          hudMonitor:DrawLine(Os,Np,"g")
          hudMonitor:DrawCircle(Np,nRad / 2)
        end
      elseif(workmode == 2) then -- Draw point intersection
        self:DrawRelateIntersection(hudMonitor, oPly, nRad)
        self:DrawModelIntersection(hudMonitor, oPly, stSpawn, nRad)
      end
      local Ss = stSpawn.SPos:ToScreen()
      hudMonitor:DrawLine(Os,Ss,"m")
      hudMonitor:DrawCircle(Ss, nRad,"c")
      if(not self:GetDeveloperMode()) then return end
      self:DrawTextSpawn(hudMonitor, "k","SURF",{"Trebuchet18"})
    end
  end
end

function TOOL:DrawToolScreen(w, h)
  if(SERVER) then return end
  local scrTool = asmlib.GetOpVar("MONITOR_TOOL")
  if(not scrTool) then
    scrTool = asmlib.MakeScreen(0,0,w,h,conPalette)
    if(not scrTool) then
      return asmlib.StatusLog(nil,"TOOL:DrawToolScreen: Invalid screen") end
    asmlib.SetOpVar("MONITOR_TOOL", scrTool)
    asmlib.LogInstance("TOOL:DrawToolScreen: Create screen")
  end; scrTool:SetColor()
  scrTool:DrawRect({x=0,y=0},{x=w,y=h},"k","SURF",{"vgui/white"})
  scrTool:SetTextEdge(0,0)
  local oPly = LocalPlayer()
  local stTrace = asmlib.CacheTracePly(oPly)
  local anInfo, anEnt = self:GetAnchor()
  local tInfo = gsSymRev:Explode(anInfo)
  if(not (stTrace and stTrace.Hit)) then
    scrTool:DrawText("Trace status: Invalid","r","SURF",{"Trebuchet24"})
    scrTool:DrawTextAdd("  ["..(tInfo[1] or gsNoID).."]","an")
    return
  end
  scrTool:DrawText("Trace status: Valid","g","SURF",{"Trebuchet24"})
  scrTool:DrawTextAdd("  ["..(tInfo[1] or gsNoID).."]","an")
  local model = self:GetModel()
  local hdRec = asmlib.CacheQueryPiece(model)
  if(not hdRec) then
    scrTool:DrawText("Holds Model: Invalid","r")
    scrTool:DrawTextAdd("  ["..gsModeDataB.."]","db")
    return
  end
  scrTool:DrawText("Holds Model: Valid","g")
  scrTool:DrawTextAdd("  ["..gsModeDataB.."]","db")
  local workmode = self:GetWorkingMode()
  local trEnt    = stTrace.Entity
  local actrad   = self:GetActiveRadius()
  local pointid, pnextid = self:GetPointID()
  local trMaxCN, trModel, trOID, trRLen
  if(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return end
          trModel = trEnt:GetModel()
    local spnflat = self:GetSpawnFlat()
    local igntype = self:GetIgnoreType()
    local trRec   = asmlib.CacheQueryPiece(trModel)
    local nextx, nexty, nextz = self:GetPosOffsets()
    local nextpic, nextyaw, nextrol = self:GetAngOffsets()
    local stSpawn = asmlib.GetEntitySpawn(oPly,trEnt,stTrace.HitPos,model,pointid,
                      actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(stSpawn) then
      trOID  = stSpawn.TID
      trRLen = asmlib.RoundValue(stSpawn.RLen,0.01)
    end
    if(trRec) then
      trMaxCN = trRec.Kept
      trModel = trModel:GetFileFromFilename()
    else trModel = "["..gsNoMD.."]"..trModel:GetFileFromFilename() end
  end
  model  = model:GetFileFromFilename()
  actrad = asmlib.RoundValue(actrad,0.01)
  maxrad = asmlib.GetAsmVar("maxactrad", "FLT")
  scrTool:DrawText("TM: " ..(trModel    or gsNoAV),"y")
  scrTool:DrawText("HM: " ..(model      or gsNoAV),"m")
  scrTool:DrawText("ID: ["..(trMaxCN    or gsNoID)
                  .."] "  ..(trOID      or gsNoID)
                  .." >> "..(pointid    or gsNoID)
                  .. " (" ..(pnextid    or gsNoID)
                  ..") [" ..(hdRec.Kept or gsNoID).."]","g")
  scrTool:DrawText("CurAR: "..(trRLen or gsNoAV),"y")
  scrTool:DrawText("MaxCL: "..actrad.." < ["..maxrad.."]","c")
  local txX, txY, txW, txH, txsX, txsY = scrTool:GetTextState()
  local nRad = mathClamp(h - txH  - (txsY / 2),0,h) / 2
  local cPos = mathClamp(h - nRad - (txsY / 3),0,h)
  local xyPos = {x = cPos, y = cPos}
  local workmode, workname = self:GetWorkingMode()
  scrTool:DrawCircle(xyPos, mathClamp(actrad/maxrad,0,1)*nRad, "c","SURF")
  scrTool:DrawCircle(xyPos, nRad, "m")
  scrTool:DrawText("Date: "..osDate(asmlib.GetOpVar("DATE_FORMAT")),"w")
  scrTool:DrawText("Time: "..osDate(asmlib.GetOpVar("TIME_FORMAT")))
  if(trRLen) then scrTool:DrawCircle(xyPos, nRad * mathClamp(trRLen/maxrad,0,1),"y") end
  scrTool:DrawText("Work: ["..workmode.."] "..workname, "wm")
end

local ConVarList = TOOL:BuildConVarList()
function TOOL.BuildCPanel(CPanel)
  local CurY, pItem = 0 -- pItem is the current panel created
          CPanel:SetName(languageGetPhrase("tool."..gsToolNameL..".name"))
  pItem = CPanel:Help   (languageGetPhrase("tool."..gsToolNameL..".desc")); CurY = CurY + pItem:GetTall() + 2

  pItem = CPanel:AddControl( "ComboBox",{
              MenuButton = 1,
              Folder     = gsToolNameL,
              Options    = {["#Default"] = ConVarList},
              CVars      = tableGetKeys(ConVarList)}); CurY = CurY + pItem:GetTall() + 2

  local Panel = asmlib.CacheQueryPanel()
  if(not Panel) then return asmlib.StatusPrint(nil,"TOOL:BuildCPanel: Panel population empty") end
  local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")
  local catTypes = asmlib.GetOpVar("TABLE_CATEGORIES")
  local pTree    = vguiCreate("DTree", CPanel)
        pTree:SetPos(2, CurY)
        pTree:SetSize(2, 400)
        pTree:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".model_con"))
        pTree:SetIndentSize(0)
  local iCnt, pFolders, pCateg, pNode = 1, {}, {}
  while(Panel[iCnt]) do
    local Rec = Panel[iCnt]
    local Mod = Rec[defTable[1][1]]
    local Typ = Rec[defTable[2][1]]
    local Nam = Rec[defTable[3][1]]
    if(fileExists(Mod, "GAME")) then
      if(not (asmlib.IsEmptyString(Typ) or pFolders[Typ])) then
        local pRoot = pTree:AddNode(Typ) -- No type folder made already
              pRoot.Icon:SetImage("icon16/database_connect.png")
              pRoot.InternalDoClick = function() end
              pRoot.DoClick         = function() return false end
              pRoot.DoRightClick    = function() SetClipboardText(pRoot:GetText()) end
              pRoot.Label.UpdateColours = function(pSelf)
                return pSelf:SetTextStyleColor(conPalette:Select("tx")) end
        pFolders[Typ] = pRoot
      end -- Reset the primary tree node pointer
      if(pFolders[Typ]) then pItem = pFolders[Typ] else pItem = pTree end
      -- Register the category if definition functional is given
      if(catTypes[Typ]) then -- There is a category definition
        if(not pCateg[Typ]) then pCateg[Typ] = {} end
        local bSuc, ptCat, psNam = pcall(catTypes[Typ].Cmp, Mod)
        -- If the call is successful in protected mode and a folder table is present
        if(bSuc) then
          local pCurr = pCateg[Typ]
          if(asmlib.IsEmptyString(ptCat)) then ptCat = nil end
          if(ptCat and type(ptCat) ~= "table") then ptCat = {ptCat} end
          if(ptCat and ptCat[1]) then
            local iCnt = 1; while(ptCat[iCnt]) do
              local sCat = tostring(ptCat[iCnt])
              if(asmlib.IsEmptyString(sCat)) then sCat = "Other" end
              if(pCurr[sCat]) then -- Jump next if already created
                pCurr, pItem = asmlib.GetDirectoryObj(pCurr, sCat)
              else -- Create the last needed node regarding pItem
                pCurr, pItem = asmlib.SetDirectoryObj(pItem, pCurr, sCat,"icon16/folder.png",conPalette:Select("tx"))
              end; iCnt = iCnt + 1;
            end
          end; if(psNam and not asmlib.IsEmptyString(psNam)) then Nam = tostring(psNam) end
        end -- Custom name to override via category
      end
      -- Register the node asociated with the track piece
      pNode = pItem:AddNode(Nam)
      pNode.DoRightClick = function() SetClipboardText(Mod) end
      pNode:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".model"))
      pNode.Icon:SetImage("icon16/brick.png")
      pNode.DoClick = function(pSelf)
        RunConsoleCommand(gsToolPrefL.. "model" , Mod)
        RunConsoleCommand(gsToolPrefL.."pointid", 1)
        RunConsoleCommand(gsToolPrefL.."pnextid", 2)
      end -- SnapReview is ignored because a query must be executed for points count
    else asmlib.LogInstance("TOOL:BuildCPanel: Extension <"..Typ.."> missing <"..Mod.."> .. SKIPPING !") end
    iCnt = iCnt + 1
  end
  CPanel:AddItem(pTree)
  CurY = CurY + pTree:GetTall() + 2
  asmlib.LogInstance("Found #"..tostring(iCnt-1).." piece items.")

  -- http://wiki.garrysmod.com/page/Category:DComboBox
  local pComboToolMode = vguiCreate("DComboBox", CPanel)
        pComboToolMode:SetPos(2, CurY)
        pComboToolMode:SetSortItems(false)
        pComboToolMode:SetTall(18); RunConsoleCommand(gsToolPrefL.."workmode", 1)
        pComboToolMode:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".workmode"))
        pComboToolMode:AddChoice(languageGetPhrase("tool."..gsToolNameL..".workmode_1"), 1 ,true)
        pComboToolMode:AddChoice(languageGetPhrase("tool."..gsToolNameL..".workmode_2"), 2)
        pComboToolMode.OnSelect = function(pnSelf, nInd, sVal, anyData)
          RunConsoleCommand(gsToolPrefL.."workmode", anyData) end
        CurY = CurY + pComboToolMode:GetTall() + 2

  local pComboPhysType = vguiCreate("DComboBox", CPanel)
        pComboPhysType:SetPos(2, CurY)
        pComboPhysType:SetTall(18)
        pComboPhysType:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".phytype"))
        pComboPhysType:SetValue(languageGetPhrase("tool."..gsToolNameL..".phytype_def"))
        CurY = CurY + pComboPhysType:GetTall() + 2
  local pComboPhysName = vguiCreate("DComboBox", CPanel)
        pComboPhysName:SetPos(2, CurY)
        pComboPhysName:SetTall(18)
        pComboPhysName:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".phyname"))
        pComboPhysName:SetValue(asmlib.DefaultString(asmlib.GetAsmVar("physmater","STR"),languageGetPhrase("tool."..gsToolNameL..".phyname_def")))
        CurY = CurY + pComboPhysName:GetTall() + 2
  local Property = asmlib.CacheQueryProperty()
  if(not Property) then return asmlib.StatusPrint(nil,"TOOL:BuildCPanel: Property population empty") end
  local iTyp = 1
  while(Property[iTyp]) do
    pComboPhysType:AddChoice(Property[iTyp])
    pComboPhysType.OnSelect = function(pnSelf, nInd, sVal, anyData)
      local qNames = asmlib.CacheQueryProperty(sVal)
      if(qNames) then
        pComboPhysName:Clear()
        pComboPhysName:SetValue(languageGetPhrase("tool."..gsToolNameL..".phyname_def"))
        local iNam = 1
        while(qNames[iNam]) do
          pComboPhysName:AddChoice(qNames[iNam])
          pComboPhysName.OnSelect = function(pnSelf, nInd, sVal, anyData)
            RunConsoleCommand(gsToolPrefL.."physmater", sVal)
          end; iNam = iNam + 1
        end
      else asmlib.LogInstance("TOOL:BuildCPanel: Property type <"..sVal.."> names unavailable") end
    end; iTyp = iTyp + 1
  end
  CPanel:AddItem(pComboToolMode)
  CPanel:AddItem(pComboPhysType)
  CPanel:AddItem(pComboPhysName); asmlib.Print(Property,"TOOL:BuildCPanel: Property")

  -- http://wiki.garrysmod.com/page/Category:DTextEntry
  local pText = vguiCreate("DTextEntry", CPanel)
        pText:SetPos(2, CurY)
        pText:SetTall(18)
        pText:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".bgskids"))
        pText:SetText(asmlib.DefaultString(asmlib.GetAsmVar("bgskids", "STR"),languageGetPhrase("tool."..gsToolNameL..".bgskids_def")))
        pText.OnKeyCodeTyped = function(pnSelf, nKeyEnum)
          if(nKeyEnum == KEY_TAB) then
            local sTX = asmlib.GetPropBodyGroup()..gsSymDir..asmlib.GetPropSkin()
            pnSelf:SetText(sTX)
            pnSelf:SetValue(sTX)
          elseif(nKeyEnum == KEY_ENTER) then
            local sTX = pnSelf:GetValue() or ""
            RunConsoleCommand(gsToolPrefL.."bgskids",sTX)
          end
        end; CurY = CurY + pText:GetTall() + 2
  CPanel:AddItem(pText)

  local nMaxOffLin = asmlib.GetAsmVar("maxlinear","FLT")
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".mass_con"), gsToolPrefL.."mass", 1, asmlib.GetAsmVar("maxmass"  ,"FLT")  , 0)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".mass"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".activrad_con"), gsToolPrefL.."activrad", 0, asmlib.GetAsmVar("maxactrad", "FLT"), 7)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".activrad"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".count_con"), gsToolPrefL.."count"    , 1, asmlib.GetAsmVar("maxstcnt" , "INT"), 0)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".count"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".angsnap_con"), gsToolPrefL.."angsnap", 0, gnMaxOffRot, 7)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".angsnap"))
  pItem = CPanel:Button   (languageGetPhrase ("tool."..gsToolNameL..".resetvars_con"), gsToolPrefL.."resetvars")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".resetvars"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextpic_con"), gsToolPrefL.."nextpic" , -gnMaxOffRot, gnMaxOffRot, 7)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextpic"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextyaw_con"), gsToolPrefL.."nextyaw" , -gnMaxOffRot, gnMaxOffRot, 7)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextyaw"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextrol_con"), gsToolPrefL.."nextrol" , -gnMaxOffRot, gnMaxOffRot, 7)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextrol"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextx_con"), gsToolPrefL.."nextx", -nMaxOffLin, nMaxOffLin, 7)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextx"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nexty_con"), gsToolPrefL.."nexty", -nMaxOffLin, nMaxOffLin, 7)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nexty"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextz_con"), gsToolPrefL.."nextz", -nMaxOffLin, nMaxOffLin, 7)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextz"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".forcelim_con"), gsToolPrefL.."forcelim", 0, asmlib.GetAsmVar("maxforce" ,"FLT"), 7)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".forcelim"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".weld_con"), gsToolPrefL.."weld")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".weld"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".nocollide_con"), gsToolPrefL.."nocollide")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nocollide"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".freeze_con"), gsToolPrefL.."freeze")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".freeze"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".ignphysgn_con"), gsToolPrefL.."ignphysgn")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".ignphysgn"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".gravity_con"), gsToolPrefL.."gravity")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".gravity"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".igntype_con"), gsToolPrefL.."igntype")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".igntype"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".spnflat_con"), gsToolPrefL.."spnflat")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".spnflat"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".spawncn_con"), gsToolPrefL.."spawncn")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".spawncn"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".surfsnap_con"), gsToolPrefL.."surfsnap")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".surfsnap"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".appangfst_con"), gsToolPrefL.."appangfst")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".appangfst"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".applinfst_con"), gsToolPrefL.."applinfst")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".applinfst"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".adviser_con"), gsToolPrefL.."adviser")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".adviser"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".pntasist_con"), gsToolPrefL.."pntasist")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pntasist"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".ghosthold_con"), gsToolPrefL.."ghosthold")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".ghosthold"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".engunsnap_con"), gsToolPrefL.."engunsnap")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".engunsnap"))
end
