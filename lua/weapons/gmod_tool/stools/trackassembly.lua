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
local LocalPlayer           = LocalPlayer
local RunConsoleCommand     = RunConsoleCommand
local RestoreCursorPosition = RestoreCursorPosition
local osDate                = os and os.date
local gameSinglePlayer      = game and game.SinglePlayer
local undoCreate            = undo and undo.Create
local undoFinish            = undo and undo.Finish
local undoAddEntity         = undo and undo.AddEntity
local undoSetPlayer         = undo and undo.SetPlayer
local undoSetCustomUndoText = undo and undo.SetCustomUndoText
local utilTraceLine         = util and util.TraceLine
local utilIsValidModel      = util and util.IsValidModel
local utilPrecacheModel     = util and util.PrecacheModel
local utilIsValidRagdoll    = util and util.IsValidRagdoll
local utilGetPlayerTrace    = util and util.GetPlayerTrace
local mathClamp             = math and math.Clamp
local entsCreate            = ents and ents.Create
local entsCreateClientProp  = ents and ents.CreateClientProp
local fileExists            = file and file.Exists
local stringSub             = string and string.sub
local stringUpper           = string and string.upper
local stringLower           = string and string.lower
local cleanupRegister       = cleanup and cleanup.Register
local languageAdd           = language and language.Add
local languageGetPhrase     = language and language.GetPhrase
local concommandAdd         = concommand and concommand.Add
local duplicatorRegisterEntityModifier = duplicator and duplicator.RegisterEntityModifier

----------------- TOOL Global Parameters ----------------
--- Store a pointer to our module
local asmlib = trackasmlib
--- Because Vec[1] is actually faster than Vec.X
--- Vector Component indexes ---
local cvX, cvY, cvZ = asmlib.GetIndexes("V")
--- Angle Component indexes ---
local caP, caY, caR = asmlib.GetIndexes("A")

--- ZERO Objects
local VEC_ZERO = asmlib.GetOpVar("VEC_ZERO")
local ANG_ZERO = asmlib.GetOpVar("ANG_ZERO")

--- Global References
local goToolScr
local goMonitor
local gnMaxMass   = asmlib.GetOpVar("MAX_MASS")
local gnMaxOffLin = asmlib.GetOpVar("MAX_LINEAR")
local gnMaxOffRot = asmlib.GetOpVar("MAX_ROTATION")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")
local gsToolPrefU = asmlib.GetOpVar("TOOLNAME_PU")
local gsToolNameU = asmlib.GetOpVar("TOOLNAME_NU")
local gsModeDataB = asmlib.GetOpVar("MODE_DATABASE")
local gsNameInitF = asmlib.GetOpVar("NAME_INIT")
      gsNameInitF = stringUpper(stringSub(gsNameInitF,1,1))..stringSub(gsNameInitF,2,-1)
local gsNamePerpF = asmlib.GetOpVar("NAME_PERP")
      gsNamePerpF = stringUpper(stringSub(gsNamePerpF,1,1))..stringSub(gsNamePerpF,2,-1)    
local gsUndoPrefN = gsNameInitF..": "
local gsNoID      = asmlib.GetOpVar("MISS_NOID")
local gsNoAV      = asmlib.GetOpVar("MISS_NOAV")
local gsNoMD      = asmlib.GetOpVar("MISS_NOMD") -- No model
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVSIGN")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gsNoAnchor  = gsNoID..gsSymRev..gsNoMD

--- Render Base Colours
local conPalette = asmlib.MakeContainer("Colours")
      conPalette:Insert("r" ,Color(255, 0 , 0 ,255))
      conPalette:Insert("g" ,Color( 0 ,255, 0 ,255))
      conPalette:Insert("b" ,Color( 0 , 0 ,255,255))
      conPalette:Insert("c" ,Color( 0 ,255,255,255))
      conPalette:Insert("m" ,Color(255, 0 ,255,255))
      conPalette:Insert("y" ,Color(255,255, 0 ,255))
      conPalette:Insert("w" ,Color(255,255,255,255))
      conPalette:Insert("k" ,Color( 0 , 0 , 0 ,255))
      conPalette:Insert("gh",Color(255,255,255,240)) -- self.GhostEntity
      conPalette:Insert("tx",Color(80 ,80 ,80 ,255)) -- Panel mode names
      conPalette:Insert("an",Color(180,255,150,255)) -- Selected anchor
      conPalette:Insert("db",Color(220,164,52 ,255)) -- Database mode

if(CLIENT) then
  languageAdd("tool."..gsToolNameL..".name"     , gsNameInitF.." "..gsNamePerpF)
  languageAdd("tool."..gsToolNameL..".desc"     , "Assembles a track for vehicles to run on")
  languageAdd("tool."..gsToolNameL..".0"        , "Left Click to continue the track, Right to change active position, Reload to remove a piece")
  languageAdd("tool."..gsToolNameL..".mass"     , "How heavy the piece spawned will be")
  languageAdd("tool."..gsToolNameL..".activrad" , "Minimum distance needed to select an active point")
  languageAdd("tool."..gsToolNameL..".count"    , "Maximum number of pieces to create while stacking")
  languageAdd("tool."..gsToolNameL..".ydegsnp"  , "Snap the first piece spawned at this much degrees")
  languageAdd("tool."..gsToolNameL..".resetoffs", "Click to reset the additional offsets")
  languageAdd("tool."..gsToolNameL..".nextpic"  , "Additional origin angular pitch offset")
  languageAdd("tool."..gsToolNameL..".nextyaw"  , "Additional origin angular yaw offset")
  languageAdd("tool."..gsToolNameL..".nextrol"  , "Additional origin angular roll offset")
  languageAdd("tool."..gsToolNameL..".nextx"    , "Additional origin linear X offset")
  languageAdd("tool."..gsToolNameL..".nexty"    , "Additional origin linear Y offset")
  languageAdd("tool."..gsToolNameL..".nextz"    , "Additional origin linear Z offset")
  languageAdd("tool."..gsToolNameL..".gravity"  , "Controls the gravity on the piece spawned")
  languageAdd("tool."..gsToolNameL..".weld"     , "Creates welds between pieces or pieces/anchor")
  languageAdd("tool."..gsToolNameL..".ignphysgn", "Ignores physics gun grab on the piece spawned/snapped/stacked")
  languageAdd("tool."..gsToolNameL..".nocollide", "Puts a no-collide between pieces or pieces/anchor")
  languageAdd("tool."..gsToolNameL..".freeze"   , "Makes the piece spawn in a frozen state")
  languageAdd("tool."..gsToolNameL..".igntype"  , "Makes the tool ignore the different piece types on snapping/stacking")
  languageAdd("tool."..gsToolNameL..".spnflat"  , "The next piece will be spawned/snapped/stacked horizontally")
  languageAdd("tool."..gsToolNameL..".mcspawn"  , "Spawns the piece at the mass-centre, else spawns relative to the active point chosen")
  languageAdd("tool."..gsToolNameL..".surfsnap" , "Snaps the piece to the surface the player is pointing at")
  languageAdd("tool."..gsToolNameL..".autoffsz" , "Automatically offsets the piece to lay it above the ground")
  languageAdd("tool."..gsToolNameL..".adviser"  , "Controls rendering the tool position/angle adviser")
  languageAdd("tool."..gsToolNameL..".ghosthold", "Controls rendering the tool ghosted holder piece")
  languageAdd("cleanup."..gsToolNameL     , "Undone assembly")
  languageAdd("cleaned."..gsToolNameL.."s", "Cleaned up all Pieces")
  concommandAdd(gsToolPrefL.."resetoffs", asmlib.GetActionCode("RESET_OFFSETS"))
  concommandAdd(gsToolPrefL.."openframe", asmlib.GetActionCode("OPEN_FRAME"))
end

if(SERVER) then
  cleanupRegister(gsToolNameU.."s")
  duplicatorRegisterEntityModifier(gsToolPrefL.."dupe_key_phys",asmlib.GetActionCode("IGNORE_PHYSGUN"))
end

TOOL.Category   = "Construction" -- Name of the category
TOOL.Name       = languageGetPhrase and languageGetPhrase("tool."..gsToolNameL..".name") -- Name to display
TOOL.Command    = nil -- Command on click (nil for default)
TOOL.ConfigName = nil -- Config file name (nil for default)

TOOL.ClientConVar = {
  [ "weld"      ] = "1",
  [ "mass"      ] = "25000",
  [ "model"     ] = "models/props_phx/trains/tracks/track_1x.mdl",
  [ "nextx"     ] = "0",
  [ "nexty"     ] = "0",
  [ "nextz"     ] = "0",
  [ "count"     ] = "5",
  [ "freeze"    ] = "0",
  [ "anchor"    ] = gsNoAnchor,
  [ "igntype"   ] = "0",
  [ "spnflat"   ] = "0",
  [ "ydegsnp"   ] = "0",
  [ "pointid"   ] = "1",
  [ "pnextid"   ] = "2",
  [ "nextpic"   ] = "0",
  [ "nextyaw"   ] = "0",
  [ "nextrol"   ] = "0",
  [ "addinfo"   ] = "0",
  [ "logsmax"   ] = "10000",
  [ "logfile"   ] = "trackasmlib_log",
  [ "mcspawn"   ] = "0",
  [ "bgskids"   ] = "",
  [ "gravity"   ] = "1",
  [ "adviser"   ] = "1",
  [ "activrad"  ] = "30",
  [ "surfsnap"  ] = "0",
  [ "autoffsz"  ] = "1",
  [ "exportdb"  ] = "0",
  [ "ignphysgn" ] = "0",
  [ "ghosthold" ] = "1",
  [ "maxstatts" ] = "3",
  [ "nocollide" ] = "0",
  [ "physmater" ] = "metal"
}

function TOOL:GetModel()
  return (self:GetClientInfo("model") or "")
end

function TOOL:GetCount()
  return mathClamp(self:GetClientNumber("count"),1,asmlib.GetCoVar("maxstcnt", "INT"))
end

function TOOL:GetMass()
  return mathClamp(self:GetClientNumber("mass"),1,gnMaxMass)
end

function TOOL:GetAdditionalInfo()
  return (self:GetClientNumber("addinfo") or 0)
end

function TOOL:GetPosOffsets()
  return (mathClamp(self:GetClientNumber("nextx") or 0,-gnMaxOffLin,gnMaxOffLin)),
         (mathClamp(self:GetClientNumber("nexty") or 0,-gnMaxOffLin,gnMaxOffLin)),
         (mathClamp(self:GetClientNumber("nextz") or 0,-gnMaxOffLin,gnMaxOffLin))
end

function TOOL:GetAngOffsets()
  return (mathClamp(self:GetClientNumber("nextpic") or 0,-gnMaxOffRot,gnMaxOffRot)),
         (mathClamp(self:GetClientNumber("nextyaw") or 0,-gnMaxOffRot,gnMaxOffRot)),
         (mathClamp(self:GetClientNumber("nextrol") or 0,-gnMaxOffRot,gnMaxOffRot))
end

function TOOL:GetFreeze()
  return (self:GetClientNumber("freeze") or 0)
end

function TOOL:GetIgnoreType()
  return (self:GetClientNumber("igntype") or 0)
end

function TOOL:GetBodyGroupSkin()
  return self:GetClientInfo("bgskids") or ""
end

function TOOL:GetGravity()
  return (self:GetClientNumber("gravity") or 0)
end

function TOOL:GetGhostHolder()
  return (self:GetClientNumber("ghosthold") or 0)
end

function TOOL:GetNoCollide()
  return (self:GetClientNumber("nocollide") or 0)
end

function TOOL:GetSpawnFlat()
  return (self:GetClientNumber("spnflat") or 0)
end

function TOOL:GetExportDB()
  return (self:GetClientNumber("exportdb") or 0)
end

function TOOL:GetLogLines()
  return (self:GetClientNumber("logsmax") or 0)
end

function TOOL:GetLogFile()
  return (self:GetClientInfo("logfile") or "")
end

function TOOL:GetAdviser()
  return (self:GetClientNumber("adviser") or 0)
end

function TOOL:GetPointID()
  return (self:GetClientNumber("pointid") or 1),
         (self:GetClientNumber("pnextid") or 2)
end

function TOOL:GetActiveRadius()
  return mathClamp(self:GetClientNumber("activrad") or 1,1,asmlib.GetCoVar("maxactrad", "FLT"))
end

function TOOL:GetYawSnap()
  return mathClamp(self:GetClientNumber("ydegsnp"),0,gnMaxOffRot)
end

function TOOL:GetWeld()
  return (self:GetClientNumber("weld") or 0)
end

function TOOL:GetIgnorePhysgun()
  return (self:GetClientNumber("ignphysgn") or 0)
end

function TOOL:GetSpawnMC()
  return self:GetClientNumber("mcspawn") or 0
end

function TOOL:GetAutoOffsetUp()
  return (self:GetClientNumber("autoffsz") or 0)
end

function TOOL:GetStackAttempts()
  return (mathClamp(self:GetClientNumber("maxstaatts"),1,5))
end

function TOOL:GetPhysMeterial()
  return (self:GetClientInfo("physmater") or "metal")
end

function TOOL:GetBoundErrorMode()
  return asmlib.GetCoVar("bnderrmod" ,"STR")
end

function TOOL:GetSurfaceSnap()
  return (self:GetClientNumber("surfsnap") or 0)
end

function TOOL:ClearAnchor()
  local svEnt = self:GetEnt(1)
  local plPly = self:GetOwner()
  if(svEnt and svEnt:IsValid()) then
    svEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
    svEnt:SetColor(conPalette:Select("w"))
  end
  self:ClearObjects()
  asmlib.PrintNotify(plPly,"Anchor: Cleaned !","CLEANUP")
  plPly:ConCommand(gsToolPrefL.."anchor "..gsNoAnchor.."\n")
  return asmlib.StatusLog(true,"TOOL:ClearAnchor(): Anchor cleared")
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
  local sAnchor = trEnt:EntIndex()..gsSymRev..asmlib.GetModelFileName(trEnt:GetModel())
  trEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
  trEnt:SetColor(conPalette:Select("an"))
  self:SetObject(1,trEnt,stTrace.HitPos,phEnt,stTrace.PhysicsBone,stTrace.HitNormal)
  plPly:ConCommand(gsToolPrefL.."anchor "..sAnchor.."\n")
  asmlib.PrintNotify(plPly,"Anchor: Set "..sAnchor.." !","UNDO")
  return asmlib.StatusLog(true,"TOOL:SetAnchor("..sAnchor..")")
end

function TOOL:GetAnchor()
  local svEnt = self:GetEnt(1)
  if(not (svEnt and svEnt:IsValid())) then svEnt = nil end
  return (self:GetClientInfo("anchor") or gsNoAnchor), svEnt
end

function TOOL:LeftClick(Trace)
  if(CLIENT) then return true end
  if(not Trace) then return false end
  if(not Trace.Hit) then return false end
  local trEnt      = Trace.Entity
  local weld       = self:GetWeld()
  local mass       = self:GetMass()
  local model      = self:GetModel()
  local count      = self:GetCount()
  local ply        = self:GetOwner()
  local freeze     = self:GetFreeze()
  local mcspawn    = self:GetSpawnMC()
  local ydegsnp    = self:GetYawSnap()
  local gravity    = self:GetGravity()
  local nocollide  = self:GetNoCollide()
  local spnflat    = self:GetSpawnFlat()
  local igntype    = self:GetIgnoreType()
  local surfsnap   = self:GetSurfaceSnap()
  local physmater  = self:GetPhysMeterial()
  local autoffsz   = self:GetAutoOffsetUp()
  local actrad     = self:GetActiveRadius()
  local bgskids    = self:GetBodyGroupSkin()
  local staatts    = self:GetStackAttempts()
  local ignphysgn  = self:GetIgnorePhysgun()
  local bnderrmod  = self:GetBoundErrorMode()
  local fnmodel    = asmlib.GetModelFileName(model)
  local aninfo , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  asmlib.LoadPlyKey(ply)
  if(Trace.HitWorld) then -- Spawn it on the map ...
    local ePiece = asmlib.MakePiece(model,Trace.HitPos,ANG_ZERO,mass,bgskids,conPalette:Select("w"))
    if(ePiece) then
      local aAng = asmlib.GetNormalAngle(ply,Trace,surfsnap,ydegsnp)
      if(mcspawn ~= 0) then
        asmlib.DisplaceAngleDir(aAng,"URF",{-nextyaw,-nextpic,nextrol})
        ePiece:SetAngles(aAng)
        local vPos = asmlib.GetMCWorldOffset(ePiece)
        local vOBB = ePiece:OBBMins()
              vPos:Add(Trace.HitPos)
              vPos:Add(-vOBB[cvZ] * Trace.HitNormal)
        asmlib.DisplacePositionAng(vPos,aAng,"FRU",{nextx,nexty,nextz})
        if(not asmlib.SetBoundPos(ePiece,vPos,ply,bnderrmod,"Additional Error INFO"
          .."\n   Event  : Spawning when Trace.HitWorld"
          .."\n   MCspawn: "..mcspawn
          .."\n   Player : "..ply:GetName()
          .."\n   hdModel: "..fnmodel)) then return false end
      else -- Spawn on Active point
        local stSpawn = asmlib.GetNormalSpawn(Trace.HitPos,aAng,model,
                          pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
        if(not stSpawn) then return false end
        asmlib.AutoOffsetUp(stSpawn.SPos,ePiece,pointid,Trace.HitNormal,autoffsz)
        if(not asmlib.SetBoundPos(ePiece,stSpawn.SPos,ply,bnderrmod,"Additional Error INFO"
          .."\n   Event  : Spawning when Trace.HitWorld"
          .."\n   MCspawn: "..mcspawn
          .."\n   Player : "..ply:GetName()
          .."\n   hdModel: "..fnmodel)) then return false end
        ePiece:SetAngles(stSpawn.SAng)
      end
      undoCreate(gsUndoPrefN..fnmodel.." ( World spawn )")
      asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)
      asmlib.ApplyPhysicalAnchor(ePiece,anEnt,weld,nocollide)
      asmlib.EmitSoundPly(ply)
      undoAddEntity(ePiece)
      undoSetPlayer(ply)
      undoSetCustomUndoText(gsUndoPrefN..fnmodel.." ( World spawn )")
      undoFinish()
      return true
    end
    return false
  end
  -- Hit Prop
  if(not (trEnt and trEnt:IsValid())) then return false end
  if(not utilIsValidModel(model)) then return false end
  if(not asmlib.IsPhysTrace(Trace)) then return false end
  if(asmlib.IsOther(trEnt)) then return false end

  local trModel = trEnt:GetModel()

  -- No need stacking relative to non-persistent props or using them...
  local trRec = asmlib.CacheQueryPiece(trModel)
  local hdRec = asmlib.CacheQueryPiece(model)

  if(not trRec) then return false end -- Trace must exist in the database

  if(asmlib.LoadPlyKey(ply,"DUCK")) then
    -- IN_DUCK: Use the VALID Trace.Entity as a piece
    asmlib.PrintNotify(ply,"Model: "..asmlib.GetModelFileName(trModel).." selected !","GENERIC")
    ply:ConCommand(gsToolPrefL.."model " ..trModel.."\n")
    ply:ConCommand(gsToolPrefL.."pointid 1\n")
    ply:ConCommand(gsToolPrefL.."pnextid 2\n")
    return true
  end

  if(not hdRec) then return false end -- Holder model must exist in the database

  local stSpawn = asmlib.GetEntitySpawn(trEnt,Trace.HitPos,model,pointid,
                           actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
  if(not stSpawn) then -- Not aiming into an active point
    local IDs = asmlib.StringExplode(bgskids,gsSymDir)
    asmlib.Print(IDs,"BodygrpSkin")
    asmlib.AttachBodyGroups(trEnt,IDs[1] or "")
    trEnt:SetSkin(mathClamp(tonumber(IDs[2]) or 0,0,trEnt:SkinCount()-1))
    return true
  end

  if(asmlib.LoadPlyKey(ply,"SPEED")) then -- IN_SPEED: Switch the tool mode ( Stacking )
    if(count <= 0) then return asmlib.StatusLog(false,"Stack count #"..count.." not properly picked") end
    if(pointid == pnextid) then return asmlib.StatusLog(false,"Point ID #"..pointid.." overlap") end
    local iNdex  , nTrys   = count, staatts
    local vTemp  , vLook   = Vector(), Vector()
    local ePieceO, ePieceN = trEnt, nil
    undoCreate(gsUndoPrefN..fnmodel.." ( Stack #"..tostring(iNdex).." )")
    while(iNdex > 0) do
      ePieceN = asmlib.DuplicatePiece(ePieceO)
      if(ePieceN) then
        if(not asmlib.SetBoundPos(ePieceN,stSpawn.SPos,ply,bnderrmod,"Additional Error INFO"
          .."\n   Event  : Stacking piece position out of map bounds"
          .."\n   Iterats: "..tostring(count-iNdex)
          .."\n   StackTr: "..tostring( nTrys ).." ?= "..tostring(staatts)
          .."\n   pointID: "..tostring(pointid).." >> "..tostring(pnextid)
          .."\n   Player : "..ply:GetName()
          .."\n   trModel: "..asmlib.GetModelFileName(trModel)
          .."\n   hdModel: "..fnmodel)) then
          undoSetPlayer(ply)
          undoSetCustomUndoText(gsUndoPrefN..fnmodel.." ( Stack #"..tostring(count-iNdex).." )")
          undoFinish()
          return true
        end -- Set position is valid
        ePieceN:SetAngles(stSpawn.SAng)
        asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)
        asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or ePieceO),weld,nil)
        asmlib.ApplyPhysicalAnchor(ePiece,ePieceO,nil,nocollide)
        if(iNdex == count) then
          if(not asmlib.IsThereRecID(stSpawn.HRec,pnextid)) then
            ePieceN:Remove()
            asmlib.PrintNotify(ply,"Cannot find PointID data !","ERROR")
            return asmlib.StatusLog(false,"Additional Error INFO"
            .."\n   Event  : Stacking non-existent PointID on client prop"
            .."\n   Iterats: "..tostring(count-iNdex)
            .."\n   StackTr: "..tostring( nTrys ).." ?= "..tostring(staatts)
            .."\n   pointID: "..tostring(pointid).." >> "..tostring(pnextid)
            .."\n   Player : "..ply:GetName()
            .."\n   trModel: "..asmlib.GetModelFileName(trModel)
            .."\n   hdModel: "..fnmodel)
          end
          asmlib.SetVector(vLook,stSpawn.HRec.Offs[pnextid].P)
        end -- The next point is valid
        vTemp:Set(vLook)
        vTemp:Rotate(stSpawn.SAng)
        vTemp:Add(ePieceN:GetPos())
        undoAddEntity(ePieceN)
        stSpawn = asmlib.GetEntitySpawn(ePieceN,vTemp,model,pointid,
                    actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
        if(not stSpawn) then
          asmlib.PrintNotify(ply,"Cannot obtain spawn data!","ERROR")
          asmlib.EmitSoundPly(ply)
          undoSetPlayer(ply)
          undoSetCustomUndoText(gsUndoPrefN..fnmodel.." ( Stack #"..tostring(count-iNdex).." )")
          undoFinish()
          return asmlib.StatusLog(true,"Additional Error INFO"
          .."\n   Event  : Stacking has invalid user data"
          .."\n   Iterats: "..tostring(count-iNdex)
          .."\n   StackTr: "..tostring( nTrys ).." ?= "..tostring(staatts)
          .."\n   pointID: "..tostring(pointid).." >> "..tostring(pnextid)
          .."\n   Player : "..ply:GetName()
          .."\n   trModel: "..asmlib.GetModelFileName(trModel)
          .."\n   hdModel: "..fnmodel)
        end -- Spawn data is valid for the current iteration iNdex
        ePieceO = ePieceN
        iNdex = iNdex - 1
        nTrys = staatts
      else
        nTrys = nTrys - 1
      end
      if(nTrys <= 0) then
        asmlib.PrintNotify(ply,"Spawn attempts ran off!","ERROR")
        asmlib.EmitSoundPly(ply)
        undoSetPlayer(ply)
        undoSetCustomUndoText(gsUndoPrefN..fnmodel.." ( Stack #"..tostring(count-iNdex).." )")
        undoFinish()
        return asmlib.StatusLog(true,"Additional Error INFO"
        .."\n   Event  : Stacking failed to allocate memory for a piece"
        .."\n   Iterats: "..tostring(count-iNdex)
        .."\n   StackTr: "..tostring( nTrys ).." ?= "..tostring(staatts)
        .."\n   pointID: "..tostring(pointid).." >> "..tostring(pnextid)
        .."\n   Player : "..ply:GetName()
        .."\n   trModel: "..asmlib.GetModelFileName(trModel)
        .."\n   hdModel: "..fnmodel)
      end -- We still have enough memory to preform the stacking
      if(hdRec.Kept == 1) then break end -- If holder's model has only one point, we cannot stack
    end
    asmlib.EmitSoundPly(ply)
    undoSetPlayer(ply)
    undoSetCustomUndoText(gsUndoPrefN..fnmodel.." ( Stack #"..tostring(count-iNdex).." )")
    undoFinish()
    return true
  else
    local ePiece = asmlib.MakePiece(model,Trace.HitPos,ANG_ZERO,mass,bgskids,conPalette:Select("w"))
    if(ePiece) then
      if(not asmlib.SetBoundPos(ePiece,stSpawn.SPos,ply,bnderrmod,"Additional Error INFO"
        .."\n   Event  : Spawn one piece relative to another"
        .."\n   Player : "..ply:GetName()
        .."\n   trModel: "..asmlib.GetModelFileName(trModel)
        .."\n   hdModel: "..fnmodel)) then return false end
      ePiece:SetAngles(stSpawn.SAng)
      undoCreate(gsUndoPrefN..fnmodel.." ( Snap prop )")
      asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)
      asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or trEnt),weld,nil) -- Weld all created to the anchor/previous
      asmlib.ApplyPhysicalAnchor(ePiece,trEnt,nil,nocollide)       -- NoCollide all to previous
      asmlib.EmitSoundPly(ply)
      undoAddEntity(ePiece)
      undoSetPlayer(ply)
      undoSetCustomUndoText(gsUndoPrefN..fnmodel.." ( Snap prop )")
      undoFinish()
      return true
    end
    return false
  end
end

function TOOL:RightClick(Trace)
  -- Change the active point
  if(CLIENT) then return true end
  local model   = self:GetModel()
  if(not utilIsValidModel(model)) then return false end
  local hdRec = asmlib.CacheQueryPiece(model)
  if(not hdRec) then return false end
  local pointid, pnextid = self:GetPointID()
  local ply = self:GetOwner()
  local pointbu = pointid
  asmlib.LoadPlyKey(ply)
  if(Trace.HitWorld and asmlib.LoadPlyKey(ply,"USE")) then
    ply:ConCommand(gsToolPrefL.."openframe "..asmlib.GetCoVar("maxfruse" ,"INT").."\n")
    return true
  end
  if(asmlib.LoadPlyKey(ply,"DUCK")) then -- Crouch ( Ctrl )
    if(asmlib.LoadPlyKey(ply,"SPEED")) then -- Run ( Left Shift )
      pnextid = asmlib.IncDecPnextID(pnextid,pointid,"-",hdRec)
    else
      pnextid = asmlib.IncDecPnextID(pnextid,pointid,"+",hdRec)
    end
  else -- Not Crouch ( Ctrl )
    if(asmlib.LoadPlyKey(ply,"SPEED")) then -- Run ( Left Shift )
      pointid = asmlib.IncDecPointID(pointid,"-",hdRec)
    else
      pointid = asmlib.IncDecPointID(pointid,"+",hdRec)
    end
  end
  if(pointid == pnextid) then
    pnextid = pointbu
  end
  ply:ConCommand(gsToolPrefL.."pnextid "..pnextid.."\n")
  ply:ConCommand(gsToolPrefL.."pointid "..pointid.."\n")
end

function TOOL:Reload(Trace)
  if(CLIENT) then return true end
  if(not Trace) then return false end
  local ply = self:GetOwner()
  local trEnt = Trace.Entity
  asmlib.LoadPlyKey(ply)
  if(Trace.HitWorld) then
    self:ClearAnchor()
    asmlib.SetLogControl(self:GetLogLines(),self:GetLogFile())
    if((self:GetExportDB() ~= 0) and asmlib.LoadPlyKey(ply,"SPEED")) then
      asmlib.LogInstance("TOOL:Reload(Trace): Exporting DB")
      asmlib.ExportIntoFile("PIECES",",","INS")
      asmlib.ExportIntoFile("ADDITIONS",",","INS")
      asmlib.ExportIntoFile("PHYSPROPERTIES",",","INS")
      asmlib.ExportIntoFile("PIECES","\t","DSV")
      asmlib.ExportIntoFile("ADDITIONS","\t","DSV")
      asmlib.ExportIntoFile("PHYSPROPERTIES","\t","DSV")
    end
    return asmlib.StatusLog(true,"TOOL:Reload(Trace):HitWorld exit success")
  elseif(trEnt and trEnt:IsValid()) then
    if(not asmlib.IsPhysTrace(Trace)) then return false end
    if(asmlib.IsOther(trEnt)) then return false end
    if(asmlib.LoadPlyKey(ply,"SPEED")) then
      self:SetAnchor(Trace)
      return asmlib.StatusLog(true,"TOOL:Reload(Trace): Anchor set")
    end
    local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
    if(asmlib.IsExistent(trRec)) then
      trEnt:Remove()
      return asmlib.StatusLog(true,"TOOL:Reload(Trace): Removed a piece")
    end
  end
  return false
end

function TOOL:Holster()
  self:ReleaseGhostEntity()
  if(self.GhostEntity and self.GhostEntity:IsValid()) then
    self.GhostEntity:Remove()
  end
end

function TOOL:DrawHUD()
  if(SERVER) then return end
  if(not goMonitor) then
    goMonitor = asmlib.MakeScreen(0,0,
                  surface.ScreenWidth(),
                  surface.ScreenHeight(),conPalette,"GHO")
    if(not goMonitor) then
      return asmlib.StatusPrint(nil,"DrawHUD: Invalid screen")
    end
    goMonitor:SetFont("Trebuchet24")
  end
  local adv = self:GetAdviser()
  if(adv == 0) then return end
  local ply = LocalPlayer()
  local Trace = ply:GetEyeTrace()
  if(not Trace) then return end
  local plyd  = (Trace.HitPos - ply:GetPos()):Length()
  local trEnt = Trace.Entity
  local model = self:GetModel()
  local pointid, pnextid = self:GetPointID()
  local nextx, nexty, nextz = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  if(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return end
    local actrad  = self:GetActiveRadius()
    local igntype = self:GetIgnoreType()
    local spnflat = self:GetSpawnFlat()
    local stSpawn = asmlib.GetEntitySpawn(trEnt,Trace.HitPos,model,pointid,
                      actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
    if(not stSpawn) then return end
    local addinfo = self:GetAdditionalInfo()
    stSpawn.F:Mul(30)
    stSpawn.F:Add(stSpawn.OPos)
    stSpawn.R:Mul(30)
    stSpawn.R:Add(stSpawn.OPos)
    stSpawn.U:Mul(30)
    stSpawn.U:Add(stSpawn.OPos)
    local RadScale = mathClamp(75 * stSpawn.RLen / plyd,1,100)
    local Os = stSpawn.OPos:ToScreen()
    local Ss = stSpawn.SPos:ToScreen()
    local Xs = stSpawn.F:ToScreen()
    local Ys = stSpawn.R:ToScreen()
    local Zs = stSpawn.U:ToScreen()
    local Pp = stSpawn.PPos:ToScreen()
    local Tp = Trace.HitPos:ToScreen()
    if(stSpawn.HRec.Offs[pnextid] and stSpawn.HRec.Kept > 1) then
      local vNext = Vector()
            asmlib.SetVector(vNext,stSpawn.HRec.Offs[pnextid].O)
            vNext:Rotate(stSpawn.SAng)
            vNext:Add(stSpawn.SPos)
      local Np = vNext:ToScreen()
      -- Draw Next Point
      goMonitor:DrawLine(Os,Np,"g")
      goMonitor:DrawCircle(Np, RadScale / 2, "g")
    end
    -- Draw Elements
    goMonitor:DrawLine(Os,Xs,"r")
    goMonitor:DrawLine(Os,Pp)
    goMonitor:DrawCircle(Pp, RadScale / 2)
    goMonitor:DrawLine(Os,Ys,"g")
    goMonitor:DrawLine(Os,Zs,"b")
    goMonitor:DrawCircle(Os, RadScale,"y")
    goMonitor:DrawLine(Os,Tp)
    goMonitor:DrawCircle(Tp, RadScale / 2)
    goMonitor:DrawLine(Os,Ss,"m")
    goMonitor:DrawCircle(Ss, RadScale,"c")
    if(addinfo == 0) then return end
    local x,y = goMonitor:GetCenter(10,10)
    goMonitor:SetTextEdge(x,y)
    goMonitor:DrawText("Act Rad: "..tostring(stSpawn.RLen),"k")
    goMonitor:DrawText("Org POS: "..tostring(stSpawn.OPos))
    goMonitor:DrawText("Org ANG: "..tostring(stSpawn.OAng))
    goMonitor:DrawText("Mod POS: "..tostring(stSpawn.MPos))
    goMonitor:DrawText("Mod ANG: "..tostring(stSpawn.MAng))
    goMonitor:DrawText("Spn POS: "..tostring(stSpawn.SPos))
    goMonitor:DrawText("Spn ANG: "..tostring(stSpawn.SAng))
  elseif(Trace.HitWorld) then
    local mcspawn  = self:GetSpawnMC()
    local ydegsnp  = self:GetYawSnap()
    local addinfo  = self:GetAdditionalInfo()
    local surfsnap = self:GetSurfaceSnap()
    local RadScale = mathClamp(1500 / plyd,1,100)
    local aAng = asmlib.GetNormalAngle(ply,Trace,surfsnap,ydegsnp)
    if(mcspawn ~= 0) then -- Relative to MC
      asmlib.DisplaceAngleDir(aAng,"URF",{-nextyaw,-nextpic,nextrol})
      local vPos = Vector()
            vPos:Set(Trace.HitPos)
      local F = aAng:Forward()
            F:Mul(30)
            F:Add(vPos)
      local R = aAng:Right()
            R:Mul(30)
            R:Add(vPos)
      local U = aAng:Up()
            U:Mul(30)
            U:Add(vPos)
      local Os = vPos:ToScreen()
      local Xs = F:ToScreen()
      local Ys = R:ToScreen()
      local Zs = U:ToScreen()
      local Tp = Trace.HitPos:ToScreen()
      goMonitor:DrawLine(Os,Xs,"r")
      goMonitor:DrawLine(Os,Ys,"g")
      goMonitor:DrawLine(Os,Zs,"b")
      goMonitor:DrawLine(Os,Tp,"y")
      goMonitor:DrawCircle(Tp, RadScale / 2)
      goMonitor:DrawCircle(Os, RadScale, "m")
      if(addinfo == 0) then return end
      local x,y = goMonitor:GetCenter(10,10)
      goMonitor:SetTextEdge(x,y)
      goMonitor:DrawText("Org POS: "..tostring(vPos),"k")
      goMonitor:DrawText("Org ANG: "..tostring(aAng))
    else -- Relative to the active Point
      if(not (pointid > 0 and pnextid > 0)) then return end
      local stSpawn = asmlib.GetNormalSpawn(Trace.HitPos,aAng,model,
                        pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(not stSpawn) then return end
      stSpawn.F:Mul(30)
      stSpawn.F:Add(stSpawn.OPos)
      stSpawn.R:Mul(30)
      stSpawn.R:Add(stSpawn.OPos)
      stSpawn.U:Mul(30)
      stSpawn.U:Add(stSpawn.OPos)
      local Os = stSpawn.OPos:ToScreen()
      local Ss = stSpawn.SPos:ToScreen()
      local Xs = stSpawn.F:ToScreen()
      local Ys = stSpawn.R:ToScreen()
      local Zs = stSpawn.U:ToScreen()
      local Pp = stSpawn.PPos:ToScreen()
      local Tp = Trace.HitPos:ToScreen()
      if(stSpawn.HRec.Kept > 1 and stSpawn.HRec.Offs[pnextid]) then
        local vNext = Vector()
              asmlib.SetVector(vNext,stSpawn.HRec.Offs[pnextid].O)
              vNext:Rotate(stSpawn.SAng)
              vNext:Add(stSpawn.SPos)
        local Np = vNext:ToScreen()
        -- Draw Next Point
        goMonitor:DrawLine(Os,Np,"y")
        goMonitor:DrawCircle(Np,RadScale / 2,"g")
      end
      -- Draw Elements
      goMonitor:DrawLine(Os,Xs,"r")
      goMonitor:DrawLine(Os,Pp)
      goMonitor:DrawCircle(Pp, RadScale / 2)
      goMonitor:DrawLine(Os,Ys,"g")
      goMonitor:DrawLine(Os,Zs,"b")
      goMonitor:DrawLine(Os,Ss,"m")
      goMonitor:DrawCircle(Ss, RadScale, "c")
      goMonitor:DrawCircle(Os, RadScale, "y")
      goMonitor:DrawLine(Os,Tp)
      goMonitor:DrawCircle(Tp, RadScale / 2)
      if(addinfo == 0) then return end
      local x,y = goMonitor:GetCenter(10,10)
      goMonitor:SetTextEdge(x,y)
      goMonitor:DrawText("Org POS: "..tostring(stSpawn.OPos),"k")
      goMonitor:DrawText("Org ANG: "..tostring(stSpawn.OAng))
      goMonitor:DrawText("Mod POS: "..tostring(stSpawn.MPos))
      goMonitor:DrawText("Mod ANG: "..tostring(stSpawn.MAng))
      goMonitor:DrawText("Spn POS: "..tostring(stSpawn.SPos))
      goMonitor:DrawText("Spn ANG: "..tostring(stSpawn.SAng))
    end
  end
end

function TOOL:DrawToolScreen(w, h)
  if(SERVER) then return end
  if(not goToolScr) then
    goToolScr = asmlib.MakeScreen(0,0,w,h,conPalette,"GHO")
    if(not goToolScr) then
      return asmlib.StatusPrint(nil,"DrawToolScreen: Invalid screen")
    end
  end
  goToolScr:DrawBackGround("k")
  goToolScr:SetFont("Trebuchet24")
  goToolScr:SetTextEdge(0,0)
  local stTrace = LocalPlayer():GetEyeTrace()
  local anInfo, anEnt = self:GetAnchor()
  local tInfo = asmlib.StringExplode(anInfo,gsSymRev)
  if(not (stTrace and stTrace.Hit)) then
    goToolScr:DrawText("Trace status: Invalid","r")
    goToolScr:DrawTextAdd("  ["..(tInfo[1] or gsNoID).."]","an")
    return
  end
  goToolScr:DrawText("Trace status: Valid","g")
  goToolScr:DrawTextAdd("  ["..(tInfo[1] or gsNoID).."]","an")
  local model = self:GetModel()
  local hdRec = asmlib.CacheQueryPiece(model)
  if(not hdRec) then
    goToolScr:DrawText("Holds Model: Invalid","r")
    goToolScr:DrawTextAdd("  ["..gsModeDataB.."]","db")
    return
  end
  goToolScr:DrawText("Holds Model: Valid","g")
  goToolScr:DrawTextAdd("  ["..gsModeDataB.."]","db")
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
      trOID  = stSpawn.OID
      trRLen = asmlib.RoundValue(stSpawn.RLen,0.01)
    end
    if(trRec) then
      trMaxCN = trRec.Kept
      trModel = asmlib.GetModelFileName(trModel)
    else
      trModel = "["..gsNoMD.."]"..asmlib.GetModelFileName(trModel)
    end
  end
  model  = asmlib.GetModelFileName(model)
  actrad = asmlib.RoundValue(actrad,0.01)
  maxrad = asmlib.GetCoVar("maxactrad", "FLT")
  goToolScr:DrawText("TM: " ..(trModel    or gsNoAV),"y")
  goToolScr:DrawText("HM: " ..(model      or gsNoAV),"m")
  goToolScr:DrawText("ID: ["..(trMaxCN    or gsNoID)
                    .."] "  ..(trOID      or gsNoID)
                    .." >> "..(pointid    or gsNoID)
                    .. " (" ..(pnextid    or gsNoID)
                    ..") [" ..(hdRec.Kept or gsNoID).."]","g")
  goToolScr:DrawText("CurAR: "..(trRLen or gsNoAV),"y")
  goToolScr:DrawText("MaxCL: "..actrad.." < ["..maxrad.."]","c")
  local txX, txY, txW, txH, txsX, txsY = goToolScr:GetTextState()
  local nRad = mathClamp(h - txH  - (txsY / 2),0,h) / 2
  local cPos = mathClamp(h - nRad - (txsY / 3),0,h)
  local xyPos = {x = cPos, y = cPos}
  if(trRLen) then
    goToolScr:DrawCircle(xyPos, nRad * mathClamp(trRLen/maxrad,0,1),"y")
  end
  local sTime = tostring(osDate())
  goToolScr:DrawCircle(xyPos, mathClamp(actrad/maxrad,0,1)*nRad, "c")
  goToolScr:DrawCircle(xyPos, nRad, "m")
  goToolScr:DrawText(stringSub(sTime,1,8),"w")
  goToolScr:DrawText(stringSub(sTime,10,17))
end

function TOOL.BuildCPanel(CPanel)
  Header = CPanel:AddControl( "Header", {Text        = languageGetPhrase("tool."..gsToolNameL..".name"),
                                         Description = languageGetPhrase("tool."..gsToolNameL..".desc")})
  local CurY = Header:GetTall() + 2

  local Combo         = {}
  Combo["Label"]      = "#Presets"
  Combo["MenuButton"] = "1"
  Combo["Folder"]     = gsToolNameL
  Combo["CVars"]      = {}
  Combo["CVars"][0 ]  = gsToolPrefL.."weld"
  Combo["CVars"][1 ]  = gsToolPrefL.."ignphysgn"
  Combo["CVars"][2 ]  = gsToolPrefL.."mass"
  Combo["CVars"][3 ]  = gsToolPrefL.."model"
  Combo["CVars"][4 ]  = gsToolPrefL.."nextx"
  Combo["CVars"][5 ]  = gsToolPrefL.."nexty"
  Combo["CVars"][6 ]  = gsToolPrefL.."nextz"
  Combo["CVars"][7 ]  = gsToolPrefL.."count"
  Combo["CVars"][8 ]  = gsToolPrefL.."freeze"
  Combo["CVars"][9 ]  = gsToolPrefL.."adviser"
  Combo["CVars"][10]  = gsToolPrefL.."igntype"
  Combo["CVars"][11]  = gsToolPrefL.."spnflat"
  Combo["CVars"][12]  = gsToolPrefL.."pointid"
  Combo["CVars"][13]  = gsToolPrefL.."pnextid"
  Combo["CVars"][14]  = gsToolPrefL.."nextpic"
  Combo["CVars"][15]  = gsToolPrefL.."nextyaw"
  Combo["CVars"][16]  = gsToolPrefL.."nextrol"
  Combo["CVars"][17]  = gsToolPrefL.."ghosthold"
  Combo["CVars"][18]  = gsToolPrefL.."ydegsnp"
  Combo["CVars"][19]  = gsToolPrefL.."mcspawn"
  Combo["CVars"][20]  = gsToolPrefL.."activrad"
  Combo["CVars"][21]  = gsToolPrefL.."nocollide"
  Combo["CVars"][22]  = gsToolPrefL.."gravity"
  Combo["CVars"][23]  = gsToolPrefL.."physmater"
  
  CPanel:AddControl("ComboBox",Combo)
  CurY = CurY + 25
  local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")
  local Panel = asmlib.CacheQueryPanel()
  if(not Panel) then return asmlib.StatusPrint(nil,"TOOL:BuildCPanel(cPanel): Panel population empty") end
  local pTree = vgui.Create("DTree")
        pTree:SetPos(2, CurY)
        pTree:SetSize(2, 250)
        pTree:SetTooltip("Select a piece to start/continue your track with by expanding a type and clicking on a node")
        pTree:SetIndentSize(0)
  local pFolders = {}
  local pNode, pItem
  local Cnt = 1
  while(Panel[Cnt]) do
    local Rec = Panel[Cnt]
    local Mod = Rec[defTable[1][1]]
    local Typ = Rec[defTable[2][1]]
    local Nam = Rec[defTable[3][1]]
    if(fileExists(Mod, "GAME")) then
      if(Typ ~= "" and not pFolders[Typ]) then
        -- No Folder, Make one xD
        pItem = pTree:AddNode(Typ)
        pItem:SetName(Typ)
        pItem.Icon:SetImage("icon16/disconnect.png")
        pItem.InternalDoClick = function() end
        pItem.DoClick = function() return false end
        pItem.Label.UpdateColours = function(pSelf)
          return pSelf:SetTextStyleColor(conPalette:Select("tx"))
        end
        pFolders[Typ] = pItem
      end
      if(pFolders[Typ]) then
        pItem = pFolders[Typ]
      else
        pItem = pTree
      end
      pNode = pItem:AddNode(Nam)
      pNode:SetName(Nam)
      pNode.Icon:SetImage("icon16/control_play_blue.png")
      pNode.DoClick = function(pSelf)
        RunConsoleCommand(gsToolPrefL.."model"  , Mod)
        RunConsoleCommand(gsToolPrefL.."pointid", 1)
        RunConsoleCommand(gsToolPrefL.."pnextid", 2)
      end
    else
      asmlib.PrintInstance("Model <"..Mod.."> is not available in your system .. SKIPPING !")
    end
    Cnt = Cnt + 1
  end
  CPanel:AddItem(pTree)
  CurY = CurY + pTree:GetTall() + 2
  asmlib.LogInstance("Found #"..tostring(Cnt-1).." piece items.")

  -- http://wiki.garrysmod.com/page/Category:DComboBox
  local pComboPhysType = vgui.Create("DComboBox")
        pComboPhysType:SetPos(2, CurY)
        pComboPhysType:SetTall(18)
        pComboPhysType:SetTooltip("Select physical properties type of the ones listed here")
        pComboPhysType:SetValue("<Select Surface Material TYPE>")
        CurY = CurY + pComboPhysType:GetTall() + 2
  local pComboPhysName = vgui.Create("DComboBox")
        pComboPhysName:SetPos(2, CurY)
        pComboPhysName:SetTall(18)
        pComboPhysName:SetTooltip("Select physical properties name to use when creating the track as this will affect the surface friction")
        pComboPhysName:SetValue(asmlib.StringDefault(asmlib.GetCoVar("physmater","STR"),"<Select Surface Material NAME>"))
        CurY = CurY + pComboPhysName:GetTall() + 2
  local Property = asmlib.CacheQueryProperty()
  if(not Property) then return asmlib.StatusPrint(nil,"TOOL:BuildCPanel(cPanel): Property population empty") end
  asmlib.Print(Property,"Property")
  local CntTyp = 1
  local qNames, Type
  while(Property[CntTyp]) do
    Type = Property[CntTyp]
    pComboPhysType:AddChoice(Type)
    pComboPhysType.OnSelect = function(pnSelf, nInd, sVal, anyData)
      qNames = asmlib.CacheQueryProperty(sVal)
      if(qNames) then
        pComboPhysName:Clear()
        pComboPhysName:SetValue("<Select Surface Material NAME>")
        local CntNam = 1
        while(qNames[CntNam]) do
          local Nam = qNames[CntNam]
          pComboPhysName:AddChoice(Nam)
          pComboPhysName.OnSelect = function(pnSelf, nInd, sVal, anyData)
            RunConsoleCommand(gsToolPrefL.."physmater", sVal)
          end
          CntNam = CntNam + 1
        end
      else
        asmlib.PrintInstance("Property type <"..sVal.."> has no names available")
      end
    end
    CntTyp = CntTyp + 1
  end
  CPanel:AddItem(pComboPhysType)
  CPanel:AddItem(pComboPhysName)
  asmlib.LogInstance("Found #"..(CntTyp-1).." material types.")

  -- http://wiki.garrysmod.com/page/Category:DTextEntry
  local pText = vgui.Create("DTextEntry")
        pText:SetPos(2, CurY)
        pText:SetTall(18)
        pText:SetTooltip("Selection code of comma delimited Bodygroup/Skin IDs > ENTER to accept, TAB to auto-fill from trace")
        pText:SetText(asmlib.StringDefault(asmlib.GetCoVar("bgskids", "STR"),"Write selection code here. For example 1,0,0,2,1/3"))
        pText.OnKeyCodeTyped = function(pnSelf, nKeyEnum)
          if(nKeyEnum == KEY_TAB) then
            local sTX = asmlib.GetPropBodyGrp()..gsSymDir..asmlib.GetPropSkin()
            pnSelf:SetText(sTX)
            pnSelf:SetValue(sTX)
          elseif(nKeyEnum == KEY_ENTER) then
            local sTX = pnSelf:GetValue() or ""
            RunConsoleCommand(gsToolPrefL.."bgskids",sTX)
          end
        end
        CurY = CurY + pText:GetTall() + 2
  CPanel:AddItem(pText)

  pItem = CPanel:AddControl("Slider", {
            Label   = "Piece mass:",
            Type    = "Integer",
            Min     = 1,
            Max     = gnMaxMass,
            Command = gsToolPrefL.."mass"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".mass"))

  pItem = CPanel:AddControl("Slider", {
            Label   = "Active radius:",
            Type    = "Float",
            Min     = 1,
            Max     = asmlib.GetCoVar("maxactrad", "FLT"),
            Command = gsToolPrefL.."activrad"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".activrad"))

  pItem = CPanel:AddControl("Slider", {
            Label   = "Pieces count:",
            Type    = "Integer",
            Min     = 1,
            Max     = asmlib.GetCoVar("maxstcnt", "INT"),
            Command = gsToolPrefL.."count"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".count"))

  pItem = CPanel:AddControl("Slider", {
            Label   = "Yaw snap amount:",
            Type    = "Float",
            Min     = 0,
            Max     = gnMaxOffRot,
            Command = gsToolPrefL.."ydegsnp"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".ydegsnp"))

  pItem = CPanel:AddControl("Button", {
            Label   = "V Reset Offset Values V",
            Command = gsToolPrefL.."resetoffs",
            Text    = "Reset All Offsets" })
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".resetoffs"))

  pItem = CPanel:AddControl("Slider", {
            Label   = "Origin pitch:",
            Type    = "Float",
            Min     = -gnMaxOffRot,
            Max     =  gnMaxOffRot,
            Command = gsToolPrefL.."nextpic"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextpic"))

  pItem = CPanel:AddControl("Slider", {
            Label   = "Origin yaw:",
            Type    = "Float",
            Min     = -gnMaxOffRot,
            Max     =  gnMaxOffRot,
            Command = gsToolPrefL.."nextyaw"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextyaw"))

  pItem = CPanel:AddControl("Slider", {
            Label   = "Origin roll:",
            Type    = "Float",
            Min     = -gnMaxOffRot,
            Max     =  gnMaxOffRot,
            Command = gsToolPrefL.."nextrol"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextrol"))

  pItem = CPanel:AddControl("Slider", {
            Label   = "Offset X:",
            Type    = "Float",
            Min     = -gnMaxOffLin,
            Max     =  gnMaxOffLin,
            Command = gsToolPrefL.."nextx"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextx"))
  pItem:SetSlideY(1)
  
  pItem = CPanel:AddControl("Slider", {
            Label   = "Offset Y:",
            Type    = "Float",
            Min     = -gnMaxOffLin,
            Max     =  gnMaxOffLin,
            Command = gsToolPrefL.."nexty"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nexty"))
  pItem:SetSlideY(1)
  
  pItem = CPanel:AddControl("Slider", {
            Label   = "Offset Z:",
            Type    = "Float",
            Min     = -gnMaxOffLin,
            Max     =  gnMaxOffLin,
            Command = gsToolPrefL.."nextz"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nextz"))
  pItem:SetSlideY(1)
  
  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Weld",
            Command = gsToolPrefL.."weld"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".weld"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "NoCollide",
            Command = gsToolPrefL.."nocollide"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".nocollide"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Freeze on spawn",
            Command = gsToolPrefL.."freeze"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".freeze"))
            
  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Ignore physics gun grab",
            Command = gsToolPrefL.."ignphysgn"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".ignphysgn"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Apply piece gravity",
            Command = gsToolPrefL.."gravity"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".gravity"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Ignore track type",
            Command = gsToolPrefL.."igntype"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".igntype"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Spawn horizontal",
            Command = gsToolPrefL.."spnflat"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".spnflat"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Origin from mass-centre",
            Command = gsToolPrefL.."mcspawn"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".mcspawn"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Snap to trace surface",
            Command = gsToolPrefL.."surfsnap"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".surfsnap"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Auto-offset UP",
            Command = gsToolPrefL.."autoffsz"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".autoffsz"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Draw advisor",
            Command = gsToolPrefL.."adviser"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".adviser"))

  pItem = CPanel:AddControl("Checkbox", {
            Label   = "Draw holder ghost",
            Command = gsToolPrefL.."ghosthold"})
  pItem:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".ghosthold"))
end

function TOOL:MakeGhostEntity(sModel)
  -- Check for invalid model
  if(not utilIsValidModel(sModel)) then return end
  utilPrecacheModel(sModel)
  -- We do ghosting serverside in single player
  -- It's done clientside in multiplayer
  if(SERVER and not gameSinglePlayer()) then return end
  if(CLIENT and     gameSinglePlayer()) then return end
  -- Release the old ghost entity
  self:ReleaseGhostEntity()
  if(CLIENT) then
    self.GhostEntity = entsCreateClientProp(sModel)
  else
    if(utilIsValidRagdoll(sModel)) then
      self.GhostEntity = entsCreate("prop_dynamic")
    else
      self.GhostEntity = entsCreate("prop_physics")
    end
  end
  -- If there are too many entities we might not spawn..
  if(not self.GhostEntity:IsValid()) then
    self.GhostEntity = nil
    return
  end
  self.GhostEntity:SetModel(sModel)
  self.GhostEntity:SetPos(VEC_ZERO)
  self.GhostEntity:SetAngles(ANG_ZERO)
  self.GhostEntity:Spawn()
  self.GhostEntity:SetSolid(SOLID_VPHYSICS);
  self.GhostEntity:SetMoveType(MOVETYPE_NONE)
  self.GhostEntity:SetNotSolid(true);
  self.GhostEntity:SetRenderMode(RENDERMODE_TRANSALPHA)
  self.GhostEntity:SetColor(conPalette:Select("gh"))
end

function TOOL:UpdateGhost(oEnt, oPly)
  if(not (oEnt and oEnt:IsValid())) then return end
  oEnt:SetNoDraw(true)
  local Trace = utilTraceLine(utilGetPlayerTrace(oPly))
  if(not Trace) then return end
  local trEnt = Trace.Entity
  if(Trace.HitWorld) then
    local model   = self:GetModel()
    local mcspawn = self:GetSpawnMC()
    local ydegsnp = self:GetYawSnap()
    local surfsnap = self:GetSurfaceSnap()
    local autoffsz = self:GetAutoOffsetUp()
    local pointid, pnextid = self:GetPointID()
    local nextx, nexty, nextz = self:GetPosOffsets()
    local nextpic, nextyaw, nextrol = self:GetAngOffsets()
    local aAng = asmlib.GetNormalAngle(oPly,Trace,surfsnap,ydegsnp)
    if(mcspawn ~= 0) then
      asmlib.DisplaceAngleDir(aAng,"URF",{-nextyaw,-nextpic,nextrol})
      oEnt:SetAngles(aAng)
      local vPos = asmlib.GetMCWorldOffset(oEnt)
      local vOBB = oEnt:OBBMins()
            vPos:Add(Trace.HitPos)
            vPos:Add(-vOBB[cvZ] * Trace.HitNormal)
      asmlib.DisplacePositionAng(vPos,aAng,"FRU",{nextx,nexty,nextz})
      oEnt:SetPos(vPos)
      oEnt:SetNoDraw(false)
    else
      local stSpawn = asmlib.GetNormalSpawn(Trace.HitPos,aAng,model,
                        pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(stSpawn) then
        asmlib.AutoOffsetUp(stSpawn.SPos,oEnt,pointid,Trace.HitNormal,autoffsz)
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
      local stSpawn = asmlib.GetEntitySpawn(trEnt,Trace.HitPos,model,pointid,
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
  local model = self:GetModel()
  if(self:GetGhostHolder() ~= 0 and utilIsValidModel(model)) then
    if (not self.GhostEntity or
        not self.GhostEntity:IsValid() or
            self.GhostEntity:GetModel() ~= model
    ) then -- If none ...
      self:MakeGhostEntity(model)
    end
    self:UpdateGhost(self.GhostEntity, self:GetOwner())
  else
    self:ReleaseGhostEntity()
    if(self.GhostEntity and self.GhostEntity:IsValid()) then
      self.GhostEntity:Remove()
    end
  end
end
