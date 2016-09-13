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
local RunConsoleCommand     = RunConsoleCommand
local osDate                = os and os.date
local vguiCreate            = vgui and vgui.Create
local utilTraceLine         = util and util.TraceLine
local utilIsValidModel      = util and util.IsValidModel
local utilGetPlayerTrace    = util and util.GetPlayerTrace
local mathAbs               = math and math.abs
local mathSqrt              = math and math.sqrt
local mathClamp             = math and math.Clamp
local fileExists            = file and file.Exists
local hookAdd               = hook and hook.Add
local tableGetKeys          = table and table.GetKeys
local inputIsKeyDown        = input and input.IsKeyDown
local stringLen             = string and string.len
local stringRep             = string and string.rep
local stringSub             = string and string.sub
local stringGsub            = string and string.gsub
local stringUpper           = string and string.upper
local stringLower           = string and string.lower
local stringExplode         = string and string.Explode
local stringToFileName      = string and string.GetFileFromFilename
local cleanupRegister       = cleanup and cleanup.Register
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
local gnMaxOffRot = asmlib.GetOpVar("MAX_ROTATION")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")
local gsToolPrefU = asmlib.GetOpVar("TOOLNAME_PU")
local gsToolNameU = asmlib.GetOpVar("TOOLNAME_NU")
local gsModeDataB = asmlib.GetOpVar("MODE_DATABASE")
local gsLimitName = asmlib.GetOpVar("CVAR_LIMITNAME")
local gsUndoPrefN = asmlib.GetOpVar("NAME_INIT"):gsub("^%l", stringUpper)..": "
local gsNoID      = asmlib.GetOpVar("MISS_NOID") -- No such ID
local gsNoAV      = asmlib.GetOpVar("MISS_NOAV") -- Not available
local gsNoMD      = asmlib.GetOpVar("MISS_NOMD") -- No model
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVSIGN")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gsNoAnchor  = gsNoID..gsSymRev..gsNoMD
local gsVersion   = asmlib.GetOpVar("TOOL_VERSION")
local gnRatio     = asmlib.GetOpVar("GOLDEN_RATIO")
local gsQueryStr  = asmlib.GetOpVar("EN_QUERY_STORE")
local conPalette  = asmlib.GetOpVar("CONTAINER_PALETTE")

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
  [ "ydegsnp"   ] = "45",
  [ "pointid"   ] = "1",
  [ "pnextid"   ] = "2",
  [ "nextpic"   ] = "0",
  [ "nextyaw"   ] = "0",
  [ "nextrol"   ] = "0",
  [ "mcspawn"   ] = "0",
  [ "bgskids"   ] = "",
  [ "gravity"   ] = "1",
  [ "adviser"   ] = "1",
  [ "activrad"  ] = "50",
  [ "pntasist"  ] = "1",
  [ "surfsnap"  ] = "0",
  [ "exportdb"  ] = "0",
  [ "offsetup"  ] = "0",
  [ "forcelim"  ] = "0",
  [ "ignphysgn" ] = "0",
  [ "ghosthold" ] = "1",
  [ "maxstatts" ] = "3",
  [ "nocollide" ] = "1",
  [ "physmater" ] = "metal",
  [ "enpntmscr" ] = "1",
  [ "engunsnap" ] = "0"
}

if(CLIENT) then
  TOOL.Information = {
    { name = "info",  stage = 1   },
    { name = "left"         },
    { name = "right"        },
    { name = "right_use",   icon2 = "gui/e.png" },
    { name = "reload"       }
  }
  asmlib.InitLocalify(asmlib.GetAsmVar("localify", "STR"))
  languageAdd("tool."..gsToolNameL..".category"  , "Construction")
  languageAdd("tool."..gsToolNameL..".name"      , "Track Assembly")
  concommandAdd(gsToolPrefL.."openframe", asmlib.GetActionCode("OPEN_FRAME"))
  concommandAdd(gsToolPrefL.."resetvars", asmlib.GetActionCode("RESET_VARIABLES"))
  hookAdd("PlayerBindPress", gsToolPrefL.."player_bind_press", asmlib.GetActionCode("BIND_PRESS"))
  hookAdd("PostDrawHUD"    , gsToolPrefL.."physgun_drop_draw", asmlib.GetActionCode("PHYSGUN_DRAW"))
end

if(SERVER) then
  hookAdd("PhysgunDrop", gsToolPrefL.."physgun_drop_snap", asmlib.GetActionCode("PHYSGUN_DROP"))
  duplicatorRegisterEntityModifier(gsToolPrefL.."dupe_phys_set",asmlib.GetActionCode("DUPE_PHYS_SETTINGS"))
end

TOOL.Category   = languageGetPhrase and languageGetPhrase("tool."..gsToolNameL..".category")
TOOL.Name       = languageGetPhrase and languageGetPhrase("tool."..gsToolNameL..".name")
TOOL.Command    = nil -- Command on click (nil for default)
TOOL.ConfigName = nil -- Configure file name (nil for default)

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

function TOOL:GetOffsetUp()
  return (self:GetClientNumber("offsetup") or 0)
end

function TOOL:GetPointAssist()
  return ((self:GetClientNumber("pntasist") or 0) ~= 0)
end

function TOOL:GetFreeze()
  return (self:GetClientNumber("freeze") or 0)
end

function TOOL:GetIgnoreType()
  return ((self:GetClientNumber("igntype") or 0) ~= 0)
end

function TOOL:GetBodyGroupSkin()
  return self:GetClientInfo("bgskids") or ""
end

function TOOL:GetGravity()
  return (self:GetClientNumber("gravity") or 0)
end

function TOOL:GetGhostHolder()
  return ((self:GetClientNumber("ghosthold") or 0) ~= 0)
end

function TOOL:GetNoCollide()
  return (self:GetClientNumber("nocollide") or 0)
end

function TOOL:GetSpawnFlat()
  return ((self:GetClientNumber("spnflat") or 0) ~= 0)
end

function TOOL:GetExportDB()
  return (self:GetClientNumber("exportdb") or 0)
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
  return mathClamp(self:GetClientNumber("activrad") or 1,1,asmlib.GetAsmVar("maxactrad", "FLT"))
end

function TOOL:GetYawSnap()
  return mathClamp(self:GetClientNumber("ydegsnp"),0,gnMaxOffRot)
end

function TOOL:GetForceLimit()
  return mathClamp(self:GetClientNumber("forcelim"),0,asmlib.GetAsmVar("maxforce" ,"FLT"))
end

function TOOL:GetWeld()
  return (self:GetClientNumber("weld") or 0)
end

function TOOL:GetIgnorePhysgun()
  return (self:GetClientNumber("ignphysgn") or 0)
end

function TOOL:GetSpawnMC()
  return ((self:GetClientNumber("mcspawn") or 0) ~= 0)
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
  return (self:GetClientNumber("surfsnap") or 0)
end

function TOOL:GetScrollMouse()
  return asmlib.GetAsmVar("enpntmscr","BUL")
end

function TOOL:SwitchPoint(nDir,bIsNext)
  local Dir = (tonumber(nDir) or 0)
  local Rec = asmlib.CacheQueryPiece(self:GetModel())
  local pointid, pnextid = self:GetPointID()
  local pointbu = pointid -- Create backup
  if(bIsNext) then pnextid = asmlib.IncDecPnextID(pnextid,pointid,Dir,Rec)
  else             pointid = asmlib.IncDecPointID(pointid,Dir,Rec) end
  if(pointid == pnextid) then pnextid = pointbu end
  RunConsoleCommand(gsToolPrefL.."pnextid",pnextid)
  RunConsoleCommand(gsToolPrefL.."pointid",pointid)
  asmlib.LogInstance("TOOL:SwitchPoint("..tostring(Dir)..","..tostring(bIsNext).."): Success")
  return pointid, pnextid
end

function TOOL:SetAnchor(stTrace)
  self:ClearAnchor()
  if(not stTrace) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Trace invalid") end
  if(not stTrace.Hit) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Trace not hit") end
  local trEnt = stTrace.Entity
  if(not (trEnt and trEnt:IsValid())) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Trace no entity") end
  local phEnt = trEnt:GetPhysicsObject()
  if(not (phEnt and phEnt:IsValid())) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Trace no physics") end
  local plPly = self:GetOwner()
  if(not (plPly and plPly:IsValid())) then return asmlib.StatusLog(false,"TOOL:SetAnchor(): Player invalid") end
  local sAnchor = trEnt:EntIndex()..gsSymRev..stringToFileName(trEnt:GetModel())
  trEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
  trEnt:SetColor(conPalette:Select("an"))
  self:SetObject(1,trEnt,stTrace.HitPos,phEnt,stTrace.PhysicsBone,stTrace.HitNormal)
  asmlib.ConCommandPly(plPly,"anchor",sAnchor)
  asmlib.PrintNotifyPly(plPly,"Anchor: Set "..sAnchor.." !","UNDO")
  return asmlib.StatusLog(true,"TOOL:SetAnchor("..sAnchor..")")
end

function TOOL:ClearAnchor()
  local svEnt = self:GetEnt(1)
  local plPly = self:GetOwner()
  if(svEnt and svEnt:IsValid()) then
    svEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
    svEnt:SetColor(conPalette:Select("w"))
  end
  self:ClearObjects()
  asmlib.PrintNotifyPly(plPly,"Anchor: Cleaned !","CLEANUP")
  asmlib.ConCommandPly(plPly,"anchor",gsNoAnchor)
  return asmlib.StatusLog(true,"TOOL:ClearAnchor(): Anchor cleared")
end

function TOOL:GetAnchor()
  local svEnt = self:GetEnt(1)
  if(not (svEnt and svEnt:IsValid())) then svEnt = nil end
  return (self:GetClientInfo("anchor") or gsNoAnchor), svEnt
end

function TOOL:GetStatus(stTrace,anyMessage,hdEnt)
  local iMaxlog = asmlib.GetOpVar("LOG_MAXLOGS")
  if(not (iMaxlog > 0)) then return "Status N/A" end
  local ply, sDelim  = self:GetOwner(), "\n"
  local iCurLog = asmlib.GetOpVar("LOG_CURLOGS")
  local sFleLog = asmlib.GetOpVar("LOG_LOGFILE")
  local sSpace  = stringRep(" ",6 + stringLen(tostring(iMaxlog)))
  local plyKeys = asmlib.ReadKeyPly(ply)
  local aninfo , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  local hdModel, trModel, trRec   = self:GetModel()
  local hdRec   = asmlib.CacheQueryPiece(hdModel)
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
        sDu = sDu..sSpace.."  Player:         "..stringGsub(tostring(ply),"Player%s","")..sDelim
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
        sDu = sDu..sSpace.."  TR.File:        <"..stringToFileName(tostring(trModel or gsNoAV))..">"..sDelim
        sDu = sDu..sSpace.."Dumping console variables state:"..sDelim
        sDu = sDu..sSpace.."  HD.Entity:      {"..tostring(hdEnt or gsNoAV).."}"..sDelim
        sDu = sDu..sSpace.."  HD.Model:       <"..tostring(hdModel or gsNoAV)..">["..tostring(hdRec and hdRec.Kept or gsNoID).."]"..sDelim
        sDu = sDu..sSpace.."  HD.File:        <"..stringToFileName(tostring(hdModel or gsNoAV))..">"..sDelim
        sDu = sDu..sSpace.."  HD.Weld:        <"..tostring(self:GetWeld())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Mass:        <"..tostring(self:GetMass())..">"..sDelim
        sDu = sDu..sSpace.."  HD.StackCNT:    <"..tostring(self:GetCount())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Freeze:      <"..tostring(self:GetFreeze())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SpawnMC:     <"..tostring(self:GetSpawnMC())..">"..sDelim
        sDu = sDu..sSpace.."  HD.YawSnap:     <"..tostring(self:GetYawSnap())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Gravity:     <"..tostring(self:GetGravity())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Adviser:     <"..tostring(self:GetAdviser())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ForceLimit:  <"..tostring(self:GetForceLimit())..">"..sDelim
        sDu = sDu..sSpace.."  HD.OffsetUp:    <"..tostring(self:GetOffsetUp())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ExportDB:    <"..tostring(self:GetExportDB())..">"..sDelim
        sDu = sDu..sSpace.."  HD.NoCollide:   <"..tostring(self:GetNoCollide())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SpawnFlat:   <"..tostring(self:GetSpawnFlat())..">"..sDelim
        sDu = sDu..sSpace.."  HD.IgnoreType:  <"..tostring(self:GetIgnoreType())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SurfSnap:    <"..tostring(self:GetSurfaceSnap())..">"..sDelim
        sDu = sDu..sSpace.."  HD.PntAssist:   <"..tostring(self:GetPointAssist())..">"..sDelim
        sDu = sDu..sSpace.."  HD.GhostHold:   <"..tostring(self:GetGhostHolder())..">"..sDelim
        sDu = sDu..sSpace.."  HD.PhysMeter:   <"..tostring(self:GetPhysMeterial())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ActRadius:   <"..tostring(self:GetActiveRadius())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SkinBG:      <"..tostring(self:GetBodyGroupSkin())..">"..sDelim
        sDu = sDu..sSpace.."  HD.StackAtempt: <"..tostring(self:GetStackAttempts())..">"..sDelim
        sDu = sDu..sSpace.."  HD.IgnorePG:    <"..tostring(self:GetIgnorePhysgun())..">"..sDelim
        sDu = sDu..sSpace.."  HD.ModDataBase: <"..gsModeDataB..","..tostring(asmlib.GetAsmVar("modedb" ,"STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.EnableStore: <"..tostring(gsQueryStr)..","..tostring(asmlib.GetAsmVar("enqstore","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.TimerMode:   <"..tostring(asmlib.GetAsmVar("timermode","STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.EnableWire:  <"..tostring(asmlib.GetAsmVar("enwiremod","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.DevelopMode: <"..tostring(asmlib.GetAsmVar("devmode"  ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxMass:     <"..tostring(asmlib.GetAsmVar("maxmass"  ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxLinear:   <"..tostring(asmlib.GetAsmVar("maxlinear","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxForce:    <"..tostring(asmlib.GetAsmVar("maxforce" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxARadius:  <"..tostring(asmlib.GetAsmVar("maxactrad","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxStackCnt: <"..tostring(asmlib.GetAsmVar("maxstcnt" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.BoundErrMod: <"..tostring(asmlib.GetAsmVar("bnderrmod","STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxFrequent: <"..tostring(asmlib.GetAsmVar("maxfruse" ,"INT"))..">"..sDelim
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
  asmlib.PrintNotifyPly(ply,"Model: "..stringToFileName(sModel).." selected !","UNDO")
  asmlib.ConCommandPly (ply,"model"  ,sModel)
  asmlib.ConCommandPly (ply,"pointid",1)
  asmlib.ConCommandPly (ply,"pnextid",2)
  return asmlib.StatusLog(true,"TOOL:SelectModel: Success <"..sModel.."> selected")
end

function TOOL:LeftClick(stTrace)
  if(CLIENT) then
    return asmlib.StatusLog(true,"TOOL:LeftClick(): Working on client") end
  if(not stTrace) then
    return asmlib.StatusLog(false,"TOOL:LeftClick(): Trace missing") end
  if(not stTrace.Hit) then
    return asmlib.StatusLog(false,"TOOL:LeftClick(): Trace not hit") end
  local trEnt      = stTrace.Entity
  local weld       = self:GetWeld()
  local mass       = self:GetMass()
  local model      = self:GetModel()
  local count      = self:GetCount()
  local ply        = self:GetOwner()
  local freeze     = self:GetFreeze()
  local mcspawn    = self:GetSpawnMC()
  local ydegsnp    = self:GetYawSnap()
  local gravity    = self:GetGravity()
  local offsetup   = self:GetOffsetUp()
  local nocollide  = self:GetNoCollide()
  local spnflat    = self:GetSpawnFlat()
  local igntype    = self:GetIgnoreType()
  local forcelim   = self:GetForceLimit()
  local surfsnap   = self:GetSurfaceSnap()
  local physmater  = self:GetPhysMeterial()
  local actrad     = self:GetActiveRadius()
  local bgskids    = self:GetBodyGroupSkin()
  local maxstatts  = self:GetStackAttempts()
  local ignphysgn  = self:GetIgnorePhysgun()
  local bnderrmod  = self:GetBoundErrorMode()
  local fnmodel    = stringToFileName(model)
  local aninfo , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  asmlib.ReadKeyPly(ply)
  if(stTrace.HitWorld) then -- Switch the tool mode ( Spawn )
    local vPos = Vector()
    local aAng = asmlib.GetNormalAngle(ply,stTrace,surfsnap,ydegsnp)
    if(mcspawn) then  -- Spawn on mass centre
      aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
      aAng:RotateAroundAxis(aAng:Right()  , nextpic)
      aAng:RotateAroundAxis(aAng:Forward(), nextrol)
      vPos:Set(stTrace.HitPos)
    else
      local stSpawn = asmlib.GetNormalSpawn(stTrace.HitPos + offsetup * stTrace.HitNormal,aAng,model,
                        pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(not stSpawn) then -- Make sure it persists to set it afterwards
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(World): Cannot obtain spawn data")) end
      vPos:Set(stSpawn.SPos); aAng:Set(stSpawn.SAng)
    end
    local ePiece = asmlib.MakePiece(ply,model,vPos,aAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
    if(ePiece) then
      if(mcspawn) then -- Adjust the position when created correctly
        asmlib.SetVectorXYZ(vPos,nextx,nexty,nextz)
        vPos:Add(asmlib.GetCenterMC(ePiece)); vPos:Rotate(aAng);
        vPos:Add(ePiece:GetPos()); ePiece:SetPos(vPos)
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

  local hdRec = asmlib.CacheQueryPiece(model)

  if(not hdRec) then return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Prop): Holder model not piece")) end

  local stSpawn = asmlib.GetEntitySpawn(trEnt,stTrace.HitPos,model,pointid,
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
      local IDs = stringExplode(gsSymDir,bgskids)
      if(not asmlib.AttachBodyGroups(trEnt,IDs[1] or "")) then
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Bodygroup/Skin): Failed")) end
      trEnt:SetSkin(mathClamp(tonumber(IDs[2]) or 0,0,trEnt:SkinCount()-1))
      return asmlib.StatusLog(true,"TOOL:LeftClick(Bodygroup/Skin): Success")
    end
  end

  if(asmlib.CheckButtonPly(ply,IN_SPEED) and (tonumber(hdRec.Kept) or 0) > 1) then -- IN_SPEED: Switch the tool mode ( Stacking )
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
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Stack)"..sIterat..": Apply physical settings failed")) end
        if(not asmlib.ApplyPhysicalAnchor(ePieceN,(anEnt or ePieceO),weld,nil,forcelim)) then
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Stack)"..sIterat..": Apply weld failed")) end
        if(not asmlib.ApplyPhysicalAnchor(ePieceN,ePieceO,nil,nocollide,forcelim)) then
          return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Stack)"..sIterat..": Apply no-collide failed")) end
        asmlib.SetVector(vTemp,hdOffs.P)
        vTemp:Rotate(stSpawn.SAng)
        vTemp:Add(ePieceN:GetPos())
        asmlib.UndoAddEntityPly(ePieceN)
        stSpawn = asmlib.GetEntitySpawn(ePieceN,vTemp,model,pointid,
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
        return asmlib.StatusLog(true,self:GetStatus(stTrace,"TOOL:LeftClick(Stack)"..sIterat..": All stack attempts failed"))
      end -- We still have enough memory to preform the stacking
    end
    asmlib.UndoFinishPly(ply)
    return asmlib.StatusLog(true,"TOOL:LeftClick(Stack): Success stacking")
  else -- Switch the tool mode ( Snapping )
    local ePiece = asmlib.MakePiece(ply,model,stSpawn.SPos,stSpawn.SAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
    if(ePiece) then
      if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Snap): Apply physical settings failed")) end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or trEnt),weld,nil,forcelim)) then -- Weld all created to the anchor/previous
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Snap): Apply weld failed")) end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,trEnt,nil,nocollide,forcelim)) then       -- NoCollide all to previous
        return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Snap): Apply no-collide failed")) end
      asmlib.UndoCratePly(gsUndoPrefN..fnmodel.." ( Snap prop )")
      asmlib.UndoAddEntityPly(ePiece)
      asmlib.UndoFinishPly(ply)
      return asmlib.StatusLog(true,"TOOL:LeftClick(Snap): Success")
    end
    return asmlib.StatusLog(false,self:GetStatus(stTrace,"TOOL:LeftClick(Snap): Crating piece failed"))
  end
end

--[[
 * If tells what will happen if the RightClick of the mouse is pressed
 * Changes the active point chosen by the holder
]]--
function TOOL:RightClick(stTrace)
  if(CLIENT) then return asmlib.StatusLog(true,"TOOL:RightClick(): Working on client") end
  if(not stTrace) then return asmlib.StatusLog(false,"TOOL:RightClick(): Trace missing") end
  local trEnt     = stTrace.Entity
  local ply       = self:GetOwner()
  local enpntmscr = self:GetScrollMouse()
  asmlib.ReadKeyPly(ply)
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
  if(CLIENT) then return asmlib.StatusLog(true,"TOOL:Reload(): Working on client") end
  if(not stTrace) then return asmlib.StatusLog(false,"TOOL:Reload(): Invalid trace") end
  local ply = self:GetOwner()
  local trEnt = stTrace.Entity
  asmlib.ReadKeyPly(ply)
  if(stTrace.HitWorld) then
    if(self:GetDeveloperMode()) then asmlib.SetLogControl(self:GetLogLines(),self:GetLogFile()) end
    if(asmlib.CheckButtonPly(ply,IN_SPEED)) then self:ClearAnchor() end
    if(self:GetExportDB() ~= 0) then
      asmlib.LogInstance("TOOL:Reload(World): Exporting DB")
      asmlib.StoreExternalDatabase("PIECES",",","INS")
      asmlib.StoreExternalDatabase("ADDITIONS",",","INS")
      asmlib.StoreExternalDatabase("PHYSPROPERTIES",",","INS")
      asmlib.StoreExternalDatabase("PIECES","\t","DSV")
      asmlib.StoreExternalDatabase("ADDITIONS","\t","DSV")
      asmlib.StoreExternalDatabase("PHYSPROPERTIES","\t","DSV")
    end
    return asmlib.StatusLog(true,"TOOL:Reload(World): Success")
  elseif(trEnt and trEnt:IsValid()) then
    if(not asmlib.IsPhysTrace(stTrace)) then return false end
    if(asmlib.IsOther(trEnt)) then
      return asmlib.StatusLog(false,"TOOL:Reload(Prop): Trace other object") end
    if(asmlib.CheckButtonPly(ply,IN_SPEED)) then
      self:SetAnchor(stTrace)
      return asmlib.StatusLog(true,"TOOL:Reload(Prop): Anchor set")
    end
    local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
    if(asmlib.IsExistent(trRec)) then
      trEnt:Remove()
      return asmlib.StatusLog(true,"TOOL:Reload(Prop): Removed a piece")
    end
  end
  return false
end

function TOOL:Holster()
  self:ReleaseGhostEntity() -- Remove the ghost prop to save memory
  if(self.GhostEntity and self.GhostEntity:IsValid()) then self.GhostEntity:Remove() end
end

function TOOL:DrawHUD()
  if(SERVER) then return end
  local hudMonitor = asmlib.GetOpVar("MONITOR_GAME")
  if(not hudMonitor) then
    hudMonitor = asmlib.MakeScreen(0,0,
                  surface.ScreenWidth(),
                  surface.ScreenHeight(),conPalette)
    if(not hudMonitor) then
      return asmlib.StatusLog(nil,"DrawHUD: Invalid screen") end
    asmlib.SetOpVar("MONITOR_GAME", hudMonitor)
    asmlib.LogInstance("DrawHUD: Create screen")
  end
  hudMonitor:SetColor()
  if(not self:GetAdviser()) then return end
  local ply = LocalPlayer()
  local stTrace = ply:GetEyeTrace()
  if(not stTrace) then return end
  local ratioc = (gnRatio - 1) * 100
  local ratiom = (gnRatio * 1000)
  local plyd   = (stTrace.HitPos - ply:GetPos()):Length()
  local trEnt  = stTrace.Entity
  local model  = self:GetModel()
  local pointid, pnextid = self:GetPointID()
  local nextx, nexty, nextz = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  if(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return end
    local actrad  = self:GetActiveRadius()
    local igntype = self:GetIgnoreType()
    local spnflat = self:GetSpawnFlat()
    local stSpawn = asmlib.GetEntitySpawn(trEnt,stTrace.HitPos,model,pointid,
                      actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(not stSpawn) then
      if(not self:GetPointAssist()) then return end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
      if(not trRec) then return end
      local ID, O, R = 1, Vector(), (actrad * ply:GetRight())
      while(ID <= trRec.Kept) do
        local stPOA = asmlib.LocatePOA(trRec,ID)
        if(not stPOA) then
          return asmlib.StatusLog(nil,"DrawHUD: Cannot assist point #"..tostring(ID)) end
        asmlib.SetVector(O,stPOA.O)
        O:Rotate(trEnt:GetAngles())
        O:Add(trEnt:GetPos())
        local Op = O:ToScreen()
        O:Add(R); ID = ID + 1
        local Rp = O:ToScreen()
        local mX = (Rp.x - Op.x); mX = mX * mX
        local mY = (Rp.y - Op.y); mY = mY * mY
        local mR = mathSqrt(mX + mY)
        hudMonitor:DrawCircle(Op, mR,"y","SEGM",{100})
      end; return
    end
    stSpawn.F:Mul(30); stSpawn.F:Add(stSpawn.OPos)
    stSpawn.R:Mul(30); stSpawn.R:Add(stSpawn.OPos)
    stSpawn.U:Mul(30); stSpawn.U:Add(stSpawn.OPos)
    local RadScale = mathClamp((ratiom / plyd) * (stSpawn.RLen / actrad),1,ratioc)
    local Os = stSpawn.OPos:ToScreen()
    local Ss = stSpawn.SPos:ToScreen()
    local Xs = stSpawn.F:ToScreen()
    local Ys = stSpawn.R:ToScreen()
    local Zs = stSpawn.U:ToScreen()
    local Pp = stSpawn.TPnt:ToScreen()
    local Tp = stTrace.HitPos:ToScreen()
    -- Draw Elements
    hudMonitor:DrawLine(Os,Xs,"r","SURF")
    hudMonitor:DrawLine(Os,Pp)
    hudMonitor:DrawCircle(Pp, RadScale / 2,"r","SURF")
    hudMonitor:DrawLine(Os,Ys,"g")
    hudMonitor:DrawLine(Os,Zs,"b")
    hudMonitor:DrawCircle(Os, RadScale,"y")
    hudMonitor:DrawLine(Os,Tp)
    hudMonitor:DrawCircle(Tp, RadScale / 2)
    hudMonitor:DrawLine(Os,Ss,"m")
    hudMonitor:DrawCircle(Ss, RadScale,"c")
    if(asmlib.LocatePOA(stSpawn.HRec,pnextid) and stSpawn.HRec.Kept > 1) then
      local vNext = Vector()
            asmlib.SetVector(vNext,stSpawn.HRec.Offs[pnextid].O)
            vNext:Rotate(stSpawn.SAng)
            vNext:Add(stSpawn.SPos)
      local Np = vNext:ToScreen()
      -- Draw Next Point
      hudMonitor:DrawLine(Os,Np,"g")
      hudMonitor:DrawCircle(Np, RadScale / 2, "g")
    end
    if(not self:GetDeveloperMode()) then return end
    local x,y = hudMonitor:GetCenter(10,10)
    hudMonitor:SetTextEdge(x,y)
    hudMonitor:DrawText("Act Rad: "..tostring(stSpawn.RLen),"k","SURF",{"Trebuchet18"})
    hudMonitor:DrawText("Org POS: "..tostring(stSpawn.OPos))
    hudMonitor:DrawText("Org ANG: "..tostring(stSpawn.OAng))
    hudMonitor:DrawText("Mod POS: "..tostring(stSpawn.HPos))
    hudMonitor:DrawText("Mod ANG: "..tostring(stSpawn.HAng))
    hudMonitor:DrawText("Spn POS: "..tostring(stSpawn.SPos))
    hudMonitor:DrawText("Spn ANG: "..tostring(stSpawn.SAng))
  elseif(stTrace.HitWorld) then
    local offsetup = self:GetOffsetUp()
    local ydegsnp  = self:GetYawSnap()
    local surfsnap = self:GetSurfaceSnap()
    local RadScale = mathClamp(ratiom / plyd,1,ratioc)
    local aAng = asmlib.GetNormalAngle(ply,stTrace,surfsnap,ydegsnp)
    if(self:GetSpawnMC()) then -- Relative to MC
      local vPos = Vector()
            vPos:Set(stTrace.HitPos + offsetup * stTrace.HitNormal)
            vPos:Add(nextx * aAng:Forward())
            vPos:Add(nexty * aAng:Right())
            vPos:Add(nextz * aAng:Up())
      aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
      aAng:RotateAroundAxis(aAng:Right()  , nextpic)
      aAng:RotateAroundAxis(aAng:Forward(), nextrol)
      local F = aAng:Forward(); F:Mul(30); F:Add(vPos)
      local R = aAng:Right()  ; R:Mul(30); R:Add(vPos)
      local U = aAng:Up()     ; U:Mul(30); U:Add(vPos)
      local Os = vPos:ToScreen()
      local Xs = F:ToScreen()
      local Ys = R:ToScreen()
      local Zs = U:ToScreen()
      local Tp = stTrace.HitPos:ToScreen()
      hudMonitor:DrawLine(Os,Xs,"r","SURF")
      hudMonitor:DrawLine(Os,Ys,"g")
      hudMonitor:DrawLine(Os,Zs,"b")
      hudMonitor:DrawLine(Os,Tp,"y")
      hudMonitor:DrawCircle(Tp, RadScale / 2,"y","SURF")
      hudMonitor:DrawCircle(Os, RadScale)
      if(not self:GetDeveloperMode()) then return end
      local x,y = hudMonitor:GetCenter(10,10)
      hudMonitor:SetTextEdge(x,y)
      hudMonitor:DrawText("Org POS: "..tostring(vPos),"k","SURF",{"Trebuchet18"})
      hudMonitor:DrawText("Org ANG: "..tostring(aAng))
    else -- Relative to the active Point
      if(not (pointid > 0 and pnextid > 0)) then return end
      local stSpawn  = asmlib.GetNormalSpawn(stTrace.HitPos + offsetup * stTrace.HitNormal,aAng,model,
                         pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(not stSpawn) then return end
      stSpawn.F:Mul(30); stSpawn.F:Add(stSpawn.OPos)
      stSpawn.R:Mul(30); stSpawn.R:Add(stSpawn.OPos)
      stSpawn.U:Mul(30); stSpawn.U:Add(stSpawn.OPos)
      local Os = stSpawn.OPos:ToScreen()
      local Ss = stSpawn.SPos:ToScreen()
      local Xs = stSpawn.F:ToScreen()
      local Ys = stSpawn.R:ToScreen()
      local Zs = stSpawn.U:ToScreen()
      local Pp = stSpawn.HPnt:ToScreen()
      local Tp = stTrace.HitPos:ToScreen()
      -- Draw Elements
      hudMonitor:DrawLine(Os,Xs,"r","SURF")
      hudMonitor:DrawLine(Os,Pp)
      hudMonitor:DrawCircle(Pp, RadScale / 2,"r","SURF")
      hudMonitor:DrawLine(Os,Ys,"g")
      hudMonitor:DrawLine(Os,Zs,"b")
      hudMonitor:DrawLine(Os,Ss,"m")
      hudMonitor:DrawCircle(Ss, RadScale, "c")
      hudMonitor:DrawCircle(Os, RadScale, "y")
      hudMonitor:DrawLine(Os,Tp)
      hudMonitor:DrawCircle(Tp, RadScale / 2)
      if(stSpawn.HRec.Kept > 1 and stSpawn.HRec.Offs[pnextid]) then
        local vNext = Vector()
              asmlib.SetVector(vNext,stSpawn.HRec.Offs[pnextid].O)
              vNext:Rotate(stSpawn.SAng)
              vNext:Add(stSpawn.SPos)
        local Np = vNext:ToScreen()
        -- Draw Next Point
        hudMonitor:DrawLine(Os,Np,"g")
        hudMonitor:DrawCircle(Np,RadScale / 2)
      end
      if(not self:GetDeveloperMode()) then return end
      local x,y = hudMonitor:GetCenter(10,10)
      hudMonitor:SetTextEdge(x,y)
      hudMonitor:DrawText("Org POS: "..tostring(stSpawn.OPos),"k","SURF",{"Trebuchet18"})
      hudMonitor:DrawText("Org ANG: "..tostring(stSpawn.OAng))
      hudMonitor:DrawText("Mod POS: "..tostring(stSpawn.HPos))
      hudMonitor:DrawText("Mod ANG: "..tostring(stSpawn.HAng))
      hudMonitor:DrawText("Spn POS: "..tostring(stSpawn.SPos))
      hudMonitor:DrawText("Spn ANG: "..tostring(stSpawn.SAng))
    end
  end
end

function TOOL:DrawToolScreen(w, h)
  if(SERVER) then return end
  local scrTool = asmlib.GetOpVar("MONITOR_TOOL")
  if(not scrTool) then
    scrTool = asmlib.MakeScreen(0,0,w,h,conPalette)
    if(not scrTool) then
      return asmlib.StatusLog("DrawToolScreen: Invalid screen") end
    asmlib.SetOpVar("MONITOR_TOOL", scrTool)
    asmlib.LogInstance("DrawToolScreen: Create screen")
  end
  scrTool:SetColor()
  scrTool:DrawRect({x=0,y=0},{x=w,y=h},"k","SURF",{"vgui/white"})
  scrTool:SetTextEdge(0,0)
  local stTrace = LocalPlayer():GetEyeTrace()
  local anInfo, anEnt = self:GetAnchor()
  local tInfo = stringExplode(gsSymRev,anInfo)
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
  local trEnt   = stTrace.Entity
  local actrad  = self:GetActiveRadius()
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
    local stSpawn = asmlib.GetEntitySpawn(trEnt,stTrace.HitPos,model,pointid,
                      actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(stSpawn) then
      trOID  = stSpawn.TID
      trRLen = asmlib.RoundValue(stSpawn.RLen,0.01)
    end
    if(trRec) then
      trMaxCN = trRec.Kept
      trModel = stringToFileName(trModel)
    else trModel = "["..gsNoMD.."]"..stringToFileName(trModel) end
  end
  model  = stringToFileName(model)
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
  scrTool:DrawCircle(xyPos, mathClamp(actrad/maxrad,0,1)*nRad, "c","SURF")
  scrTool:DrawCircle(xyPos, nRad, "m")
  scrTool:DrawText(osDate(),"w")
  if(trRLen) then
    scrTool:DrawCircle(xyPos, nRad * mathClamp(trRLen/maxrad,0,1),"y") end
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
  if(not Panel) then return asmlib.StatusPrint(nil,"TOOL:BuildCPanel(cPanel): Panel population empty") end
  local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")
  local catTypes = asmlib.GetOpVar("TABLE_CATEGORIES")
  local pTree    = vguiCreate("DTree")
        pTree:SetPos(2, CurY)
        pTree:SetSize(2, 400)
        pTree:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".model_con"))
        pTree:SetIndentSize(0)
  local iCnt, pFolders, pCategory, pNode = 1, {}, {}
  while(Panel[iCnt]) do
    local Rec = Panel[iCnt]
    local Mod = Rec[defTable[1][1]]
    local Typ = Rec[defTable[2][1]]
    local Nam = Rec[defTable[3][1]]
    if(fileExists(Mod, "GAME")) then
      if(Typ ~= "" and not pFolders[Typ]) then
        pItem = pTree:AddNode(Typ) -- No type folder made already
        pItem:SetName(Typ)
        pItem.Icon:SetImage("icon16/database_connect.png")
        pItem.InternalDoClick = function() end
        pItem.DoClick = function() return false end
        pItem.Label.UpdateColours = function(pSelf)
          return pSelf:SetTextStyleColor(conPalette:Select("tx")) end
        pFolders[Typ] = pItem
      end -- Reset the primary tree node pointer
      if(pFolders[Typ]) then pItem = pFolders[Typ] else pItem = pTree end
      -- Register the subtype if definition functional is given
      if(catTypes[Typ]) then -- There is a subtype definition
        if(not pCategory[Typ]) then pCategory[Typ] = {} end
        local nmCat = catTypes[Typ](Mod)
        local pnCat = pCategory[Typ][nmCat]
        if(not pnCat) then
          if(not asmlib.IsEmptyString(nmCat)) then -- No subtype folder made already
            pItem = pItem:AddNode(nmCat) -- The item pointer will refer to the new directory
            pItem:SetName(nmCat)
            pItem.Icon:SetImage("icon16/folder.png")
            pItem.InternalDoClick = function() end
            pItem.DoClick = function() return false end
            pItem.Label.UpdateColours = function(pSelf)
              return pSelf:SetTextStyleColor(conPalette:Select("tx")) end
            pCategory[Typ][nmCat] = pItem
          end
        else pItem = pnCat end
      end
      -- Register the node asociated with the track piece
      pNode = pItem:AddNode(Nam)
      pNode:SetName(Nam)
      pNode:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".model"))
      pNode.Icon:SetImage("icon16/brick.png")
      pNode.DoClick = function(pSelf)
        RunConsoleCommand(gsToolPrefL.."model"  , Mod)
        RunConsoleCommand(gsToolPrefL.."pointid", 1)
        RunConsoleCommand(gsToolPrefL.."pnextid", 2)
      end
    else asmlib.PrintInstance("Piece <"..Mod.."> from extension <"..Typ.."> not available .. SKIPPING !") end
    iCnt = iCnt + 1
  end
  CPanel:AddItem(pTree)
  CurY = CurY + pTree:GetTall() + 2
  asmlib.LogInstance("Found #"..tostring(iCnt-1).." piece items.")

  -- http://wiki.garrysmod.com/page/Category:DComboBox
  local pComboPhysType = vguiCreate("DComboBox")
        pComboPhysType:SetPos(2, CurY)
        pComboPhysType:SetTall(18)
        pComboPhysType:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".phytype"))
        pComboPhysType:SetValue(languageGetPhrase("tool."..gsToolNameL..".phytype_def"))
        CurY = CurY + pComboPhysType:GetTall() + 2
  local pComboPhysName = vguiCreate("DComboBox")
        pComboPhysName:SetPos(2, CurY)
        pComboPhysName:SetTall(18)
        pComboPhysName:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".phyname"))
        pComboPhysName:SetValue(asmlib.DefaultString(asmlib.GetAsmVar("physmater","STR"),languageGetPhrase("tool."..gsToolNameL..".phyname_def")))
        CurY = CurY + pComboPhysName:GetTall() + 2
  local Property = asmlib.CacheQueryProperty()
  if(not Property) then return asmlib.StatusPrint(nil,"TOOL:BuildCPanel(cPanel): Property population empty") end
  asmlib.Print(Property,"Property")
  local CntTyp = 1
  while(Property[CntTyp]) do
    pComboPhysType:AddChoice(Property[CntTyp])
    pComboPhysType.OnSelect = function(pnSelf, nInd, sVal, anyData)
      local qNames = asmlib.CacheQueryProperty(sVal)
      if(qNames) then
        pComboPhysName:Clear()
        pComboPhysName:SetValue(languageGetPhrase("tool."..gsToolNameL..".phyname_def"))
        local CntNam = 1
        while(qNames[CntNam]) do
          pComboPhysName:AddChoice(qNames[CntNam])
          pComboPhysName.OnSelect = function(pnSelf, nInd, sVal, anyData)
            RunConsoleCommand(gsToolPrefL.."physmater", sVal)
          end
          CntNam = CntNam + 1
        end
      else asmlib.PrintInstance("Property type <"..sVal.."> has no names available") end
    end
    CntTyp = CntTyp + 1
  end
  CPanel:AddItem(pComboPhysType)
  CPanel:AddItem(pComboPhysName)
  asmlib.LogInstance("Found #"..(CntTyp-1).." material types.")

  -- http://wiki.garrysmod.com/page/Category:DTextEntry
  local pText = vguiCreate("DTextEntry")
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
        end
        CurY = CurY + pText:GetTall() + 2
  CPanel:AddItem(pText)

  local nMaxOffLin = asmlib.GetAsmVar("maxlinear","FLT")
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".mass_con"), gsToolPrefL.."mass", 1, asmlib.GetAsmVar("maxmass"  ,"FLT")  , 0)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".mass"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".activrad_con"), gsToolPrefL.."activrad", 1, asmlib.GetAsmVar("maxactrad", "FLT"), 3)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".activrad"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".count_con"), gsToolPrefL.."count"    , 1, asmlib.GetAsmVar("maxstcnt" , "INT"), 0)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".count"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".ydegsnp_con"), gsToolPrefL.."ydegsnp", 1, gnMaxOffRot, 3)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".ydegsnp"))
  pItem = CPanel:Button   (languageGetPhrase ("tool."..gsToolNameL..".resetvars_con"), gsToolPrefL.."resetvars")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".resetvars"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextpic_con"), gsToolPrefL.."nextpic" , -gnMaxOffRot, gnMaxOffRot, 3)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextpic"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextyaw_con"), gsToolPrefL.."nextyaw" , -gnMaxOffRot, gnMaxOffRot, 3)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextyaw"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextrol_con"), gsToolPrefL.."nextrol" , -gnMaxOffRot, gnMaxOffRot, 3)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextrol"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextx_con"), gsToolPrefL.."nextx", -nMaxOffLin, nMaxOffLin, 3)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextx"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nexty_con"), gsToolPrefL.."nexty", -nMaxOffLin, nMaxOffLin, 3)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nexty"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".nextz_con"), gsToolPrefL.."nextz", -nMaxOffLin, nMaxOffLin, 3)
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextz"))
  pItem = CPanel:NumSlider(languageGetPhrase ("tool."..gsToolNameL..".forcelim_con"), gsToolPrefL.."forcelim", 0, asmlib.GetAsmVar("maxforce" ,"FLT"), 3)
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
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".mcspawn_con"), gsToolPrefL.."mcspawn")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".mcspawn"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".surfsnap_con"), gsToolPrefL.."surfsnap")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".surfsnap"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".adviser_con"), gsToolPrefL.."adviser")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".adviser"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".pntasist_con"), gsToolPrefL.."pntasist")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pntasist"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".ghosthold_con"), gsToolPrefL.."ghosthold")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".ghosthold"))
  pItem = CPanel:CheckBox (languageGetPhrase ("tool."..gsToolNameL..".engunsnap_con"), gsToolPrefL.."engunsnap")
           pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".engunsnap"))
end

function TOOL:UpdateGhost(oEnt, oPly)
  if(not (oEnt and oEnt:IsValid())) then return end
  oEnt:SetNoDraw(true)
  oEnt:DrawShadow(false)
  oEnt:SetColor(conPalette:Select("gh"))
  local stTrace = utilTraceLine(utilGetPlayerTrace(oPly))
  if(not stTrace) then return end
  local trEnt = stTrace.Entity
  if(stTrace.HitWorld) then
    local model    = self:GetModel()
    local ydegsnp  = self:GetYawSnap()
    local surfsnap = self:GetSurfaceSnap()
    local pointid, pnextid = self:GetPointID()
    local nextx, nexty, nextz = self:GetPosOffsets()
    local nextpic, nextyaw, nextrol = self:GetAngOffsets()
    local aAng  = asmlib.GetNormalAngle(oPly,stTrace,surfsnap,ydegsnp)
    if(self:GetSpawnMC()) then
      oEnt:SetAngles(aAng)
      local vOBB = oEnt:OBBMins()
      local vCen = asmlib.GetCenterMC(oEnt)
            vCen[cvX] = vCen[cvX] + nextx
            vCen[cvY] = vCen[cvY] + nexty
            vCen[cvZ] = vCen[cvZ] + nextz  -vOBB[cvZ]
      asmlib.ConCommandPly(oPly,"offsetup",-vOBB[cvZ])
      aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
      aAng:RotateAroundAxis(aAng:Right()  , nextpic)
      aAng:RotateAroundAxis(aAng:Forward(), nextrol)
      vCen:Rotate(aAng); vCen:Add(stTrace.HitPos)
      oEnt:SetPos(vCen); oEnt:SetAngles(aAng); oEnt:SetNoDraw(false)
    else
      local pointUp = (asmlib.PointOffsetUp(oEnt,pointid) or 0)
      local stSpawn =  asmlib.GetNormalSpawn(stTrace.HitPos + pointUp * stTrace.HitNormal,aAng,model,
                         pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(stSpawn) then
        asmlib.ConCommandPly(oPly,"offsetup",pointUp)
        oEnt:SetAngles(stSpawn.SAng)
        oEnt:SetPos(stSpawn.SPos)
        oEnt:SetNoDraw(false)
      end
    end
  elseif(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return end
    local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
    if(trRec) then
      local model   = self:GetModel()
      local spnflat = self:GetSpawnFlat()
      local igntype = self:GetIgnoreType()
      local actrad  = self:GetActiveRadius()
      local pointid, pnextid = self:GetPointID()
      local nextx, nexty, nextz = self:GetPosOffsets()
      local nextpic, nextyaw, nextrol = self:GetAngOffsets()
      local stSpawn = asmlib.GetEntitySpawn(trEnt,stTrace.HitPos,model,pointid,
                        actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(stSpawn) then
        oEnt:SetPos(stSpawn.SPos)
        oEnt:SetAngles(stSpawn.SAng)
        oEnt:SetNoDraw(false)
      end
    end
  end
end

function TOOL:Think()
  local model = self:GetModel() -- Ghost irrelevant
  if(utilIsValidModel(model)) then
    if(self:GetGhostHolder()) then
      if (not (self.GhostEntity and
               self.GhostEntity:IsValid() and
               self.GhostEntity:GetModel() == model)) then
        self:MakeGhostEntity(model,VEC_ZERO,ANG_ZERO)
      end -- In client single player the grost is skipped
      self:UpdateGhost(self.GhostEntity, self:GetOwner())
    else
      self:ReleaseGhostEntity()
      if(self.GhostEntity and self.GhostEntity:IsValid()) then
        self.GhostEntity:Remove()
      end
    end
    if(CLIENT and inputIsKeyDown(KEY_LALT)) then
      if(inputIsKeyDown(KEY_E)) then -- Close the routine panel shorcut
        local pnFrame = asmlib.GetOpVar("PANEL_FREQUENT_MODELS")
        if(pnFrame and IsValid(pnFrame)) then
          pnFrame.OnClose()
        end
      end
    end
  end
end
