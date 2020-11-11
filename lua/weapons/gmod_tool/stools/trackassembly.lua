---------------- Localizing Libraries ---------------
local type                             = type
local pcall                            = pcall
local pairs                            = pairs
local print                            = print
local Angle                            = Angle
local Color                            = Color
local Vector                           = Vector
local IsValid                          = IsValid
local tostring                         = tostring
local tonumber                         = tonumber
local GetConVar                        = GetConVar
local LocalPlayer                      = LocalPlayer
local SetClipboardText                 = SetClipboardText
local osDate                           = os and os.date
local guiOpenURL                       = gui and gui.OpenURL
local netSend                          = net and net.Send
local netStart                         = net and net.Start
local netReceive                       = net and net.Receive
local netWriteEntity                   = net and net.WriteEntity
local netWriteVector                   = net and net.WriteVector
local netWriteUInt                     = net and net.WriteUInt
local vguiCreate                       = vgui and vgui.Create
local utilIsValidModel                 = util and util.IsValidModel
local stringUpper                      = string and string.upper
local mathAbs                          = math and math.abs
local mathMin                          = math and math.min
local mathMax                          = math and math.max
local mathSqrt                         = math and math.sqrt
local mathClamp                        = math and math.Clamp
local mathAtan2                        = math and math.atan2
local mathRound                        = math and math.Round
local fileExists                       = file and file.Exists
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
local goThQueue   = (SERVER and asmlib.MakeQueue("THINK") or nil)
local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gsDataRoot  = asmlib.GetOpVar("DIRPATH_BAS")
local gnMaxRot    = asmlib.GetOpVar("MAX_ROTATION")
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
local gsNoBS      = asmlib.GetOpVar("MISS_NOBS") -- No Bodygroup skin
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVISION")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gsNoAnchor  = gsNoID..gsSymRev..gsNoMD
local gnRatio     = asmlib.GetOpVar("GOLDEN_RATIO")
local conPalette  = asmlib.MakeContainer("COLORS_LIST")
local conWorkMode = asmlib.MakeContainer("WORK_MODE")
local conElements = asmlib.MakeContainer("LIST_VGUI")
local gtArgsLogs  = {"TOOL"}

if(not asmlib.ProcessDSV()) then -- Default tab delimiter
  asmlib.LogInstance("Processing DSV fail <"..gsDataRoot.."trackasmlib_dsv.txt>")
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
  [ "incsnpang"  ] = 5,
  [ "incsnplin"  ] = 5,
  [ "crvturnlm"  ] = 0,
  [ "crvleanlm"  ] = 0,
  [ "flipoverid" ] = ""
}

if(CLIENT) then
  TOOL.Information = {
    { name = "info",  stage = 1   },
    { name = "left"      },
    { name = "right"     },
    { name = "right_use",icon2 = "gui/e.png" },
    { name = "reload"    }
  }
  languageAdd("tool."..gsToolNameL..".category", "Construction")
  concommandAdd(gsToolPrefL.."openframe", asmlib.GetActionCode("OPEN_FRAME"))
  concommandAdd(gsToolPrefL.."openextdb", asmlib.GetActionCode("OPEN_EXTERNDB"))
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
    function(oPly, oCom, oArgs) gtArgsLogs[1] = "*RESET_VARIABLES"
      local devmode = asmlib.GetAsmConvar("devmode", "BUL")
      asmlib.LogInstance("{"..tostring(devmode).."@"..tostring(command).."}",gtArgsLogs)
      if(inputIsKeyDown(KEY_LSHIFT)) then
        if(not devmode) then
          asmlib.LogInstance("Developer mode disabled",gtArgsLogs); return nil end
        asmlib.SetAsmConvar(oPly, "*sbox_max"..gsLimitName, 1500)
        for key, val in pairs(asmlib.GetOpVar("STORE_CONVARS")) do
          asmlib.SetAsmConvar(oPly, "*"..key, val) end
        asmlib.SetAsmConvar(oPly, "logsmax"  , 0)
        asmlib.SetAsmConvar(oPly, "logfile"  , 0)
        asmlib.SetAsmConvar(oPly, "modedb"   , "LUA")
        asmlib.SetAsmConvar(oPly, "devmode"  , 0)
        asmlib.SetAsmConvar(oPly, "maxtrmarg", 0.02)
        asmlib.SetAsmConvar(oPly, "maxmenupr", 5)
        asmlib.SetAsmConvar(oPly, "timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1")
        asmlib.SetAsmConvar(oPly, "maxmass"  , 50000)
        asmlib.SetAsmConvar(oPly, "maxlinear", 5000)
        asmlib.SetAsmConvar(oPly, "maxforce" , 100000)
        asmlib.SetAsmConvar(oPly, "maxactrad", 200)
        asmlib.SetAsmConvar(oPly, "maxstcnt" , 200)
        asmlib.SetAsmConvar(oPly, "enwiremod", 1)
        asmlib.SetAsmConvar(oPly, "enctxmenu", 1)
        asmlib.SetAsmConvar(oPly, "enctxmall", 0)
        asmlib.SetAsmConvar(oPly, "endsvlock", 0)
        asmlib.SetAsmConvar(oPly, "curvefact", 0.5)
        asmlib.SetAsmConvar(oPly, "curvsmple", 50)
        asmlib.SetAsmConvar(oPly, "spawnrate", 5)
        asmlib.SetAsmConvar(oPly, "bnderrmod", "LOG")
        asmlib.SetAsmConvar(oPly, "maxfruse" , 50)
        asmlib.LogInstance("Variables reset complete",gtArgsLogs)
      else
        asmlib.SetAsmConvar(oPly,"nextx"  , 0)
        asmlib.SetAsmConvar(oPly,"nexty"  , 0)
        asmlib.SetAsmConvar(oPly,"nextz"  , 0)
        asmlib.SetAsmConvar(oPly,"nextpic", 0)
        asmlib.SetAsmConvar(oPly,"nextyaw", 0)
        asmlib.SetAsmConvar(oPly,"nextrol", 0)
        if(devmode) then
          asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"),
                               asmlib.GetAsmConvar("logfile","BUL"))
        end
      end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end)

  -- Store referencies and stuff realted to the tool file
  asmlib.SetOpVar("STORE_TOOLOBJ", TOOL)
  asmlib.SetOpVar("STORE_CONVARS", TOOL:BuildConVarList())
end

if(SERVER) then
  hookAdd("Think", gsToolPrefL.."think_task", function() goThQueue:Execute():Remove() end)
  hookAdd("PlayerDisconnected", gsToolPrefL.."player_quit", asmlib.GetActionCode("PLAYER_QUIT"))
  hookAdd("PhysgunDrop", gsToolPrefL.."physgun_drop_snap", asmlib.GetActionCode("PHYSGUN_DROP"))
  duplicatorRegisterEntityModifier(gsToolPrefL.."dupe_phys_set",asmlib.GetActionCode("DUPE_PHYS_SETTINGS"))
end

TOOL.Category   = languageGetPhrase and languageGetPhrase("tool."..gsToolNameL..".category")
TOOL.Name       = languageGetPhrase and languageGetPhrase("tool."..gsToolNameL..".name")
TOOL.Command    = nil -- Command on click (nil for default)
TOOL.ConfigName = nil -- Configure file name (nil for default)

function TOOL:GetCurveFactor()
  return asmlib.GetAsmConvar("curvefact", "FLT")
end

function TOOL:GetEnPhysgunSnap()
  return ((self:GetClientNumber("engunsnap") or 0) ~= 0)
end

function TOOL:GetCurveSamples()
  return asmlib.GetAsmConvar("curvsmple", "INT")
end

function TOOL:ApplyAngularFirst()
  return ((self:GetClientNumber("appangfst") or 0) ~= 0)
end

function TOOL:GetRadialMenu()
  return ((self:GetClientNumber("enradmenu") or 0) ~= 0)
end

function TOOL:ApplyLinearFirst()
  return ((self:GetClientNumber("applinfst") or 0) ~= 0)
end

function TOOL:GetContextMenuAll()
  return asmlib.GetAsmConvar("enctxmall", "BUL")
end

function TOOL:GetModel()
  return tostring(self:GetClientInfo("model") or "")
end

function TOOL:GetStackCount()
  return mathClamp(self:GetClientNumber("stackcnt"),0,asmlib.GetAsmConvar("maxstcnt", "INT"))
end

function TOOL:GetSpawnRate()
  return asmlib.GetAsmConvar("spawnrate", "INT")
end

function TOOL:GetMass()
  return mathClamp(self:GetClientNumber("mass"),1,asmlib.GetAsmConvar("maxmass","FLT"))
end

function TOOL:GetSizeUCS()
  return mathClamp(self:GetClientNumber("sizeucs"),0,asmlib.GetAsmConvar("maxlinear","FLT"))
end

function TOOL:GetDeveloperMode()
  return asmlib.GetAsmConvar("devmode", "BUL")
end

function TOOL:GetPosOffsets()
  local nMaxLin = asmlib.GetAsmConvar("maxlinear","FLT")
  return (mathClamp(self:GetClientNumber("nextx") or 0,-nMaxLin,nMaxLin)),
         (mathClamp(self:GetClientNumber("nexty") or 0,-nMaxLin,nMaxLin)),
         (mathClamp(self:GetClientNumber("nextz") or 0,-nMaxLin,nMaxLin))
end

function TOOL:GetAngOffsets()
  return (mathClamp(self:GetClientNumber("nextpic") or 0,-gnMaxRot,gnMaxRot)),
         (mathClamp(self:GetClientNumber("nextyaw") or 0,-gnMaxRot,gnMaxRot)),
         (mathClamp(self:GetClientNumber("nextrol") or 0,-gnMaxRot,gnMaxRot))
end

function TOOL:GetElevation()
  return (self:GetClientNumber("elevpnt") or 0)
end

function TOOL:GetCurvatureTurn()
  return (self:GetClientNumber("crvturnlm") or 0)
end

function TOOL:GetCurvatureLean()
  return (self:GetClientNumber("crvleanlm") or 0)
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
  return tostring(self:GetClientInfo("bgskids") or gsNoBS)
end

function TOOL:GetGravity()
  return ((self:GetClientNumber("gravity") or 0) ~= 0)
end

function TOOL:GetGhostsCount()
  return mathClamp(self:GetClientNumber("ghostcnt"),0,asmlib.GetAsmConvar("maxstcnt", "INT"))
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
  return (asmlib.GetAsmConvar("logsmax", "INT") or 0)
end

function TOOL:GetLogFile()
  return asmlib.GetAsmConvar("logfile", "BUL")
end

function TOOL:GetAdviser()
  return ((self:GetClientNumber("adviser") or 0) ~= 0)
end

function TOOL:GetPointID()
  return (self:GetClientNumber("pointid") or 1), (self:GetClientNumber("pnextid") or 2)
end

function TOOL:GetActiveRadius()
  return mathClamp(self:GetClientNumber("activrad") or 0,0,asmlib.GetAsmConvar("maxactrad", "FLT"))
end

function TOOL:GetAngSnap()
  return mathClamp(self:GetClientNumber("angsnap"),0,gnMaxRot)
end

function TOOL:GetForceLimit()
  return mathClamp(self:GetClientNumber("forcelim"),0,asmlib.GetAsmConvar("maxforce" ,"FLT"))
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
  return (mathClamp(self:GetClientNumber("maxstatts"),0,10))
end

function TOOL:GetPhysMeterial()
  return tostring(self:GetClientInfo("physmater") or "metal")
end

function TOOL:GetFlipOverID()
  return tostring(self:GetClientInfo("flipoverid") or "")
end

function TOOL:GetBoundErrorMode()
  return asmlib.GetAsmConvar("bnderrmod", "STR")
end

function TOOL:GetSurfaceSnap()
  return ((self:GetClientNumber("surfsnap") or 0) ~= 0)
end

function TOOL:GetScrollMouse()
  return asmlib.GetAsmConvar("enpntmscr", "BUL")
end

function TOOL:GetNocollideWorld()
  return asmlib.GetAsmConvar("nocollidew", "BUL")
end

function TOOL:UpdateColorEnt(oEnt, sVar, sCol, bSet)
  if(asmlib.IsOther(oEnt)) then return nil end
  if(asmlib.IsHere(bSet)) then
    if(bSet) then
      oEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
      oEnt:SetColor(conPalette:Select(sCol))
      oEnt:SetNWBool(gsToolPrefL..sVar, true)
    else
      oEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
      oEnt:SetColor(conPalette:Select("w"))
      oEnt:SetNWBool(gsToolPrefL..sVar, false)
    end
  else
    local bSet = oEnt:GetNWBool(sVar, false)
    if(bSet) then
      self:UpdateColorEnt(oEnt, sVar, sCol, bSet) end
  end
end

function TOOL:SwitchPoint(vDir, bNxt)
  local oRec = asmlib.CacheQueryPiece(self:GetModel()); if(not asmlib.IsHere(oRec)) then
    asmlib.LogInstance("Invalid record",gtArgsLogs); return 1, 2 end
  local nDir = (tonumber(vDir) or 0) -- Normalize switch direction
  local pointid, pnextid = self:GetPointID()
  if(bNxt) then pnextid = asmlib.SwitchID(pnextid,nDir,oRec)
  else          pointid = asmlib.SwitchID(pointid,nDir,oRec) end
  if(pnextid == pointid) then pnextid = asmlib.SwitchID(pnextid,nDir,oRec) end
  asmlib.SetAsmConvar(nil,"pnextid", pnextid)
  asmlib.SetAsmConvar(nil,"pointid", pointid)
  asmlib.LogInstance("("..nDir..","..tostring(bNxt)..") Success",gtArgsLogs)
  return pointid, pnextid
end

function TOOL:IntersectClear(bMute)
  local oPly = self:GetOwner()
  local stRay = asmlib.IntersectRayRead(oPly, "relate")
  if(stRay) then asmlib.IntersectRayClear(oPly, "relate")
    if(SERVER) then local ryEnt, sRel = stRay.Ent
      netStart(gsLibName.."SendIntersectClear"); netWriteEntity(oPly); netSend(oPly)
      if(ryEnt and ryEnt:IsValid()) then
        self:UpdateColorEnt(ryEnt, "intersect", "ry", false)
        sRel = ryEnt:EntIndex()..gsSymRev..stringGetFileName(ryEnt:GetModel()) end
      if(not bMute) then sRel = (sRel and (": "..tostring(sRel)) or "")
        asmlib.LogInstance("Relation cleared <"..sRel..">",gtArgsLogs)
        asmlib.Notify(oPly,"Intersect relation clear"..sRel.." !","CLEANUP")
      end -- Make sure to delete the relation on both client and server
    end
  end; return true
end

function TOOL:IntersectRelate(oPly, oEnt, vHit)
  self:IntersectClear(true) -- Clear intersect related player on new relation
  local stRay = asmlib.IntersectRayCreate(oPly, oEnt, vHit, "relate")
  if(not stRay) then -- Create/update the ray in question
    asmlib.LogInstance("Update fail",gtArgsLogs); return false end
  if(SERVER) then -- Only the server is allowed to define relation ray
    netStart(gsLibName.."SendIntersectRelate")
    netWriteEntity(oEnt); netWriteVector(vHit); netWriteEntity(oPly); netSend(oPly)
    local sRel = oEnt:EntIndex()..gsSymRev..stringGetFileName(oEnt:GetModel())
    asmlib.Notify(oPly,"Intersect relation set: "..sRel.." !","UNDO")
    self:UpdateColorEnt(oEnt, "intersect", "ry", true)
  end return true
end

function TOOL:IntersectSnap(trEnt, vHit, stSpawn, bMute)
  local pointid, pnextid = self:GetPointID()
  local ply, model = self:GetOwner(), self:GetModel()
  if(not asmlib.IntersectRayCreate(ply, trEnt, vHit, "origin")) then
    asmlib.LogInstance("Failed updating ray",gtArgsLogs); return nil end
  local xx, x1, x2, stRay1, stRay2 = asmlib.IntersectRayHash(ply, "origin", "relate")
  if(not xx) then if(bMute) then return nil
    else asmlib.Notify(ply, "Define intersection relation !", "GENERIC")
      asmlib.LogInstance("Active ray mismatch",gtArgsLogs); return nil end
  end
  local mx, o1, o2 = asmlib.IntersectRayModel(model, pointid, pnextid)
  if(not mx) then if(bMute) then return nil
    else asmlib.Notify(ply, "Model intersection mismatch !", "ERROR")
      asmlib.LogInstance("Model ray mismatch",gtArgsLogs); return nil end
  end
  local aOrg, vx, vy, vz = stSpawn.OAng, asmlib.ExpVector(stSpawn.PNxt)
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
  local svEnt, plPly = self:GetEnt(1), self:GetOwner()
  if(CLIENT) then return end; self:ClearObjects()
  asmlib.SetAsmConvar(plPly,"anchor",gsNoAnchor)
  if(svEnt and svEnt:IsValid()) then
    self:UpdateColorEnt(svEnt, "anchor", "an", false)
    if(not bMute) then
      local sAnchor = svEnt:EntIndex()..gsSymRev..stringGetFileName(svEnt:GetModel())
      asmlib.Notify(plPly,"Anchor: Cleaned "..sAnchor.." !","CLEANUP")
    end
  end; asmlib.LogInstance("("..tostring(bMute)..") Anchor cleared",gtArgsLogs); return true
end

function TOOL:SetAnchor(stTrace)
  self:ClearAnchor(true)
  if(not stTrace) then asmlib.LogInstance("Trace invalid",gtArgsLogs); return false end
  if(not stTrace.Hit) then asmlib.LogInstance("Trace not hit",gtArgsLogs); return false end
  local trEnt = stTrace.Entity
  if(not (trEnt and trEnt:IsValid())) then asmlib.LogInstance("Trace no entity",gtArgsLogs); return false end
  local phEnt = trEnt:GetPhysicsObject()
  if(not (phEnt and phEnt:IsValid())) then asmlib.LogInstance("Trace no physics",gtArgsLogs); return false end
  local plPly = self:GetOwner()
  if(not (plPly and plPly:IsValid())) then asmlib.LogInstance("Player invalid",gtArgsLogs); return false end
  local sAnchor = trEnt:EntIndex()..gsSymRev..stringGetFileName(trEnt:GetModel())
  self:UpdateColorEnt(trEnt, "anchor", "an", true)
  self:SetObject(1,trEnt,stTrace.HitPos,phEnt,stTrace.PhysicsBone,stTrace.HitNormal)
  asmlib.SetAsmConvar(plPly,"anchor",sAnchor)
  asmlib.Notify(plPly,"Anchor: Set "..sAnchor.." !","UNDO")
  asmlib.LogInstance("("..sAnchor..")",gtArgsLogs); return true
end

function TOOL:GetAnchor()
  local svEnt = self:GetEnt(1)
  if(not (svEnt and svEnt:IsValid())) then svEnt = nil end
  return (self:GetClientInfo("anchor") or gsNoAnchor), svEnt
end

function TOOL:GetWorkingMode()
  local nWork = self:GetClientNumber("workmode", 0)
  local cWork = mathClamp(nWork or 0, 1, conWorkMode:GetSize())
  local sWork = tostring(conWorkMode:Select(cWork) or gsNoAV):sub(1,6)
  return cWork, sWork
end

-- Sends the proper ghost stack depth to DRAW_GHOSTS [0;N]
function TOOL:GetGhostsDepth()
  local workmode = self:GetWorkingMode() -- Switches the scenario
  local ghostcnt = self:GetGhostsCount() -- The base control value
  local stackcnt = self:GetStackCount()
  if(workmode == 1) then -- Defined by the stack count otherwise 1
    return mathMin(ghostcnt, mathMax(stackcnt, 1))
  elseif(workmode == 2) then -- Put second value 1 here
    return mathMin(ghostcnt, 1) -- to be able to disable it
  elseif(workmode == 3) then -- Track interpolation curvaing
    local nC = mathMin(mathMax(stackcnt, 1), ghostcnt)
    return (stackcnt > 0 and nC or ghostcnt)
  elseif(workmode == 4) then -- Put second value 1 here
    local tArr = self:GetFlipOverArray() -- to be used in no array
    local nLen = (tArr and #tArr or 1) -- flip-over mode snapping
    return mathMin(ghostcnt, nLen) -- Use ghosts count to disable it
  end; return 0
end

function TOOL:GetStatus(stTr,vMsg,hdEnt)
  local iMaxlog = asmlib.GetOpVar("LOG_MAXLOGS")
  if(iMaxlog <= 0) then return "Status N/A" end
  local ply, sDelim  = self:GetOwner(), "\n"
  local iCurLog = asmlib.GetOpVar("LOG_CURLOGS")
  local bFleLog = asmlib.IsFlag("en_logging_file")
  local sSpace  = (" "):rep(6 + tostring(iMaxlog):len())
  local workmode, workname = self:GetWorkingMode()
  local aninfo , anEnt   = self:GetAnchor()
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
        sDu = sDu..sSpace.."  Player:         "..tostring(ply):gsub("Player%s","")..sDelim
        sDu = sDu..sSpace.."  IN.USE:         <"..tostring(ply:KeyDown(IN_USE))..">"..sDelim
        sDu = sDu..sSpace.."  IN.DUCK:        <"..tostring(ply:KeyDown(IN_DUCK))..">"..sDelim
        sDu = sDu..sSpace.."  IN.SPEED:       <"..tostring(ply:KeyDown(IN_SPEED))..">"..sDelim
        sDu = sDu..sSpace.."  IN.RELOAD:      <"..tostring(ply:KeyDown(IN_RELOAD))..">"..sDelim
        sDu = sDu..sSpace.."  IN.SCORE:       <"..tostring(ply:KeyDown(IN_SCORE))..">"..sDelim
        sDu = sDu..sSpace.."Dumping trace data state:"..sDelim
        sDu = sDu..sSpace.."  Trace:          <"..tostring(stTr)..">"..sDelim
        sDu = sDu..sSpace.."  TR.Hit:         <"..tostring(stTr and stTr.Hit or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  TR.HitW:        <"..tostring(stTr and stTr.HitWorld or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  TR.ENT:         <"..tostring(stTr and stTr.Entity or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."  TR.Model:       <"..tostring(trModel or gsNoAV)..">["..tostring(trRec and trRec.Size or gsNoID).."]"..sDelim
        sDu = sDu..sSpace.."  TR.File:        <"..tostring(trModel and stringGetFileName(trModel) or gsNoAV)..">"..sDelim
        sDu = sDu..sSpace.."Dumping console variables state:"..sDelim
        sDu = sDu..sSpace.."  HD.Entity:      {"..tostring(hdEnt or gsNoAV).."}"..sDelim
        sDu = sDu..sSpace.."  HD.Model:       <"..tostring(hdModel or gsNoAV)..">["..tostring(hdRec and hdRec.Size or gsNoID).."]"..sDelim
        sDu = sDu..sSpace.."  HD.File:        <"..tostring(hdModel and stringGetFileName(hdModel) or gsNoAV)..">"..sDelim
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
        sDu = sDu..sSpace.."  HD.SpawnFlat:   <"..tostring(self:GetSpawnFlat())..">"..sDelim
        sDu = sDu..sSpace.."  HD.IgnoreType:  <"..tostring(self:GetIgnoreType())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SurfSnap:    <"..tostring(self:GetSurfaceSnap())..">"..sDelim
        sDu = sDu..sSpace.."  HD.SpawnCen:    <"..tostring(self:GetSpawnCenter())..">"..sDelim
        sDu = sDu..sSpace.."  HD.Workmode:    ["..tostring(workmode or gsNoAV).."]<"..tostring(workname or gsNoAV)..">"..sDelim
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
        sDu = sDu..sSpace.."  HD.ModDataBase: <"..gsModeDataB..","..tostring(asmlib.GetAsmConvar("modedb" ,"STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.TimerMode:   <"..tostring(asmlib.GetAsmConvar("timermode","STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.EnableWire:  <"..tostring(asmlib.GetAsmConvar("enwiremod","BUL"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.DevelopMode: <"..tostring(asmlib.GetAsmConvar("devmode"  ,"BUL"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxMass:     <"..tostring(asmlib.GetAsmConvar("maxmass"  ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxLinear:   <"..tostring(asmlib.GetAsmConvar("maxlinear","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxForce:    <"..tostring(asmlib.GetAsmConvar("maxforce" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxARadius:  <"..tostring(asmlib.GetAsmConvar("maxactrad","INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxStackCnt: <"..tostring(asmlib.GetAsmConvar("maxstcnt" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.BoundErrMod: <"..tostring(asmlib.GetAsmConvar("bnderrmod","STR"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxFrequent: <"..tostring(asmlib.GetAsmConvar("maxfruse" ,"INT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.MaxTrMargin: <"..tostring(asmlib.GetAsmConvar("maxtrmarg","FLT"))..">"..sDelim
        sDu = sDu..sSpace.."  HD.Anchor:      {"..tostring(anEnt or gsNoAV).."}<"..tostring(aninfo)..">"..sDelim
        sDu = sDu..sSpace.."  HD.PointID:     ["..tostring(pointid).."] >> ["..tostring(pnextid).."]"..sDelim
        sDu = sDu..sSpace.."  HD.AngOffsets:  ["..tostring(nextx)..","..tostring(nexty)..","..tostring(nextz).."]"..sDelim
        sDu = sDu..sSpace.."  HD.PosOffsets:  ["..tostring(nextpic)..","..tostring(nextyaw)..","..tostring(nextrol).."]"..sDelim
  if(hdEnt and hdEnt:IsValid()) then hdEnt:Remove() end
  return sDu
end

-- Returns an array or entity ID numbers
function TOOL:GetFlipOverArray()
  local sID, nF = self:GetFlipOverID(), 0
  if(sID:len() <= 0) then return nil, nF end
  local sYm = asmlib.GetOpVar("OPSYM_SEPARATOR")
  local tF = sYm:Explode(sID); nF = #tF
  for iD = 1, nF do tF[iD] = (tonumber(tF[iD]) or 0) end
  -- Convert to number as other methods use the number data
  return tF, nF -- Return the table and elements count
end

-- Returns true if there are entity ID stored
function TOOL:GetFlipOverFlag()
  return (self:GetFlipOverID():len() > 0)
end

function TOOL:SetFlipOver(trEnt)
  if(CLIENT) then return nil end
  if(asmlib.IsOther(trEnt)) then return nil end
  local trMod, oPly = trEnt:GetModel(), self:GetOwner()
  local trRec = asmlib.CacheQueryPiece(trMod)
  if(not asmlib.IsHere(trRec)) then
    asmlib.Notify(oPly,"Flip over <"..trMod.."> not piece !","ERROR")
    asmlib.LogInstance("Flip over <"..trMod.."> not piece",gtArgsLogs)
    return nil -- Just disable overall flipping for the otther models
  end
  local sYm = asmlib.GetOpVar("OPSYM_SEPARATOR")
  local iID, bBr = trEnt:EntIndex(), false
  local tF, nF = self:GetFlipOverArray()
  if(nF <= 0) then tF = {} -- Create table
  else -- Remove entity from the convar
    for iD = 1, nF do nID = tF[iD]
      if(nID == iID) then bBr = true
        local eID = Entity(nID)
        if(not asmlib.IsOther(eID)) then
          self:UpdateColorEnt(eID, "flipover", "fo", false)
        end; tableRemove(tF, iD); break
      end
    end
  end
  if(not bBr) then tableInsert(tF, tostring(iID))
    self:UpdateColorEnt(trEnt, "flipover", "fo", true)
  end
  asmlib.SetAsmConvar(oPly, "flipoverid", tableConcat(tF, sYm))
end

function TOOL:GetFlipOverEntity(bMute)
  local tF, nF = self:GetFlipOverArray()
  if(not tF or nF <= 0) then return nil, nF end
  local tE, nE, ply = {}, 0, self:GetOwner()
  for iD = 1, nF do local eID = Entity(tF[iD])
    local bID = (not asmlib.IsOther(eID))
    local bMR = eID:GetNWBool(gsToolPrefL.."flipover")
    if(bID and bMR) then
      nE = (nE + 1); tE[nE] = eID
      self:UpdateColorEnt(eID, "flipover", "fo")
    else
      if(SERVER and not bMute) then
        local sR, sE = asmlib.GetReport4(iD, eID, bID, bMR), tostring(tF[iD])
        asmlib.LogInstance("Flip over mismatch ID "..sR, gtArgsLogs)
        asmlib.Notify(ply, "Flip over mismatch ID ["..sE.."] !", "GENERIC")
      end
    end
  end; return tE, nE
end

function TOOL:ClearFlipOver(bSync, bMute)
  local ply = self:GetOwner()
  local tF, nF = self:GetFlipOverArray()
  for iD = 1, nF do local eID = Entity(tF[iD])
    if(not asmlib.IsOther(eID)) then
      self:UpdateColorEnt(eID, "flipover", "fo", false) end
  end; asmlib.SetAsmConvar(ply, "flipoverid", "")
  if(not bMute) then
    asmlib.LogInstance("Flip over cleared", gtArgsLogs)
    asmlib.Notify(ply,"Flip over cleared !","CLEANUP")
  end -- Make sure to delete the relation on both client and server
end

function TOOL:GetFlipOverOrigin(stTrace, bPntN)
  local trEnt, trHit = stTrace.Entity, stTrace.HitNormal
  local wOver, wNorm = Vector(), Vector()
  if(not (trEnt and trEnt:IsValid())) then
    wOver:Set(stTrace.HitPos); wNorm:Set(trHit)
    return wOver, wNorm
  end
  wOver:Set(trEnt:LocalToWorld(trEnt:OBBCenter())); wNorm:Set(trHit)
  if(bPntN) then
    local wOrig, wAucs = Vector(), Angle()
    local model, trMod = self:GetModel(), trEnt:GetModel()
    local trID, trMin, trPOA, trRec = asmlib.GetEntityHitID(trEnt, stTrace.HitPos, true)
    if(model == trMod and trRec and (tonumber(trRec.Size) or 0) > 1) then
      local pointid, pnextid = self:GetPointID()
      local vXX, vO1, vO2 = asmlib.IntersectRayModel(trMod, pointid, pnextid)
      if(vXX) then
        asmlib.SetVector(wOrig, trPOA.O)
        wOrig:Set(trEnt:LocalToWorld(wOrig))
        wOver:Set(trEnt:LocalToWorld(vXX))
        vO1:Set(trEnt:LocalToWorld(vO1))
        vO2:Set(trEnt:LocalToWorld(vO2))
        asmlib.SetAngle (wAucs, trPOA.A)
        wAucs:Set(trEnt:LocalToWorldAngles(wAucs))
        wNorm:Set(wAucs:Up())
        return wOver, wNorm, wOrig, vO1, vO2
      end
    else
      if(trPOA) then
        asmlib.SetVector(wOrig, trPOA.O)
        wOrig:Set(trEnt:LocalToWorld(wOrig))
        asmlib.SetAngle (wAucs, trPOA.A)
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
    asmlib.LogInstance(self:GetStatus(stTrace,"Model <"..sModel.."> not piece"),gtArgsLogs); return false end
  local ply = self:GetOwner()
  local pointid, pnextid = self:GetPointID()
        pointid, pnextid = asmlib.SnapReview(pointid, pnextid, trRec.Size)
  asmlib.Notify(ply,"Model: "..stringGetFileName(sModel).." selected !","UNDO")
  asmlib.SetAsmConvar(ply,"pointid", pointid)
  asmlib.SetAsmConvar(ply,"pnextid", pnextid)
  asmlib.SetAsmConvar(ply, "model" , sModel)
  asmlib.LogInstance("Success <"..sModel..">",gtArgsLogs); return true
end

function TOOL:CurveClear(bAll, bMute)
  local ply = self:GetOwner()
  local tC  = asmlib.GetCacheCurve(ply)
  if(tC.Size and tC.Size > 0) then
    if(bAll) then -- Clear all the nodes
      tableEmpty(tC.Snap); tC.SSize = 0
      tableEmpty(tC.Node)
      tableEmpty(tC.Norm)
      tableEmpty(tC.Base); tC.Size = 0
      tableEmpty(tC.CNode)
      tableEmpty(tC.CNorm); tC.CSize = 0
      if(not bMute) then
        asmlib.Notify(ply, "Nodes cleared ["..tC.Size.."] !", "CLEANUP")
        netStart(gsLibName.."SendDeleteAllCurveNode")
        netWriteEntity(ply); netSend(ply)
        ply:SetNWBool(gsToolPrefL.."engcurve", false)
      end
    else -- Clear the last specific node from the array
      tableRemove(tC.Node)
      tableRemove(tC.Norm)
      tableEmpty(tC.Snap); tC.SSize = 0
      tableRemove(tC.Base); tC.Size = (tC.Size - 1)
      if(not bMute) then
        asmlib.Notify(ply, "Node removed ["..tC.Size.."] !", "CLEANUP")
        netStart(gsLibName.."SendDeleteCurveNode");
        netWriteEntity(ply); netSend(ply)
        ply:SetNWBool(gsToolPrefL.."engcurve", true)
      end
    end
  end; return tC -- Returns the updated curve nodes table
end

function TOOL:GetCurveTransform(stTrace)
  if(not stTrace) then
    asmlib.LogInstance("Trace missing", gtArgsLogs); return nil end
  if(not stTrace.Hit) then
    asmlib.LogInstance("Trace not hit", gtArgsLogs); return nil end
  local ply      = self:GetOwner()
  local angsnap  = self:GetAngSnap()
  local elevpnt  = self:GetElevation()
  local surfsnap = self:GetSurfaceSnap()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  local oID, oMin, oPOA, oRec     = nil, nil, nil, nil
  local aAng, vHit, vOrg = Angle(), Vector(), Vector()
  local eEnt, vNrm = stTrace.Entity, stTrace.HitNormal
  aAng:Set(asmlib.GetNormalAngle(ply, stTrace, surfsnap, angsnap))
  vHit:Set(stTrace.HitPos); vOrg:Add(vHit)
  if(ply:KeyDown(IN_USE) and eEnt and eEnt:IsValid()) then
    oID, oMin, oPOA, oRec = asmlib.GetEntityHitID(eEnt, vHit)
    if(oID and oMin and oPOA and oRec) then
      asmlib.SetVector(vOrg, oPOA.O); vOrg:Rotate(eEnt:GetAngles()); vOrg:Add(eEnt:GetPos())
      asmlib.SetAngle (aAng, oPOA.A); aAng:Set(eEnt:LocalToWorldAngles(aAng))
    end -- Use the track piece active end to create realative curve node
  else -- Offset the curve node when it is not driven by an active point
    vOrg:Add(vNrm * elevpnt)
  end
  vOrg:Add(aAng:Up()      * nextz)
  vOrg:Add(aAng:Right()   * nexty)
  vOrg:Add(aAng:Forward() * nextx)
  aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
  aAng:RotateAroundAxis(aAng:Right()  , nextpic)
  aAng:RotateAroundAxis(aAng:Forward(), nextrol)
  return vOrg, aAng, vHit, oPOA
end

function TOOL:CurveInsert(stTrace, bMute)
  local ply, model = self:GetOwner(), self:GetModel(), stTrace.Entity
  local vOrg, aAng, vHit = self:GetCurveTransform(stTrace); if(not vOrg) then
    asmlib.LogInstance("Transform missing", gtArgsLogs); return nil end
  local tC = asmlib.GetCacheCurve(ply); if(not tC) then
    asmlib.LogInstance("Curve missing", gtArgsLogs); return nil end
  tC.Size = (tC.Size + 1)
  tC.Node[tC.Size] = vOrg
  tC.Norm[tC.Size] = aAng:Up()
  tC.Base[tC.Size] = vHit
  if(not bMute) then
    asmlib.Notify(ply, "Node inserted ["..tC.Size.."] !", "CLEANUP")
    netStart(gsLibName.."SendCreateCurveNode")
      netWriteEntity(ply)
      netWriteVector(tC.Node[tC.Size])
      netWriteVector(tC.Norm[tC.Size])
      netWriteVector(tC.Base[tC.Size])
    netSend(ply)
    ply:SetNWBool(gsToolPrefL.."engcurve", true)
  end
  return tC -- Returns the updated curve nodes table
end

function TOOL:CurveUpdate(stTrace, bMute)
  local ply = self:GetOwner()
  local vOrg, aAng, vHit = self:GetCurveTransform(stTrace); if(not vOrg) then
    asmlib.LogInstance("Transform missing", gtArgsLogs); return nil end
  local tC = asmlib.GetCacheCurve(ply); if(not tC) then
    asmlib.LogInstance("Curve missing", gtArgsLogs); return nil end
  if(not (tC.Size and tC.Size > 0)) then
    asmlib.Notify(ply,"Populate nodes first !","ERROR")
    asmlib.LogInstance("Nodes missing", gtArgsLogs); return nil
  end
  local mD, mL = asmlib.GetNearest(vHit, tC.Base)
  tC.Node[mD]:Set(vOrg)
  tC.Norm[mD]:Set(aAng:Up())
  tC.Base[mD]:Set(vHit)
  if(not bMute) then
    asmlib.Notify(ply, "Node ["..mD.."] updated !", "CLEANUP")
    netStart(gsLibName.."SendUpdateCurveNode")
      netWriteEntity(ply)
      netWriteVector(tC.Node[mD])
      netWriteVector(tC.Norm[mD])
      netWriteVector(tC.Base[mD])
      netWriteUInt(mD, 16)
    netSend(ply)
    ply:SetNWBool(gsToolPrefL.."engcurve", true)
  end; return tC -- Returns the updated curve nodes table
end

function TOOL:CurveCheck()
  local ply = self:GetOwner()
  local model = self:GetModel()
  local fnmodel = stringGetFileName(model)
  local pointid, pnextid = self:GetPointID()
  local nEps = asmlib.GetOpVar("EPSILON_ZERO")
  -- Check the model in the database
  local hdRec = asmlib.CacheQueryPiece(model); if(not asmlib.IsHere(hdRec)) then
    asmlib.LogInstance("Holder model not piece: "..fnmodel, gtArgsLogs); return nil end
  -- Disable for stack having less than two vertices
  local tC = asmlib.GetCacheCurve(ply); if(tC.Size and tC.Size < 2) then
    asmlib.Notify(ply,"Two vertices needed !","ERROR")
    asmlib.LogInstance("Two vertices needed: "..fnmodel, gtArgsLogs); return nil
  end
  -- Disable for single active end track segments
  if(hdRec.Size <= 1) then
    asmlib.Notify(ply,"Segmented track needed !","ERROR")
    asmlib.LogInstance("Segmented track needed: "..fnmodel, gtArgsLogs); return nil end
  -- Disable for missing start track segments
  local sPOA = asmlib.LocatePOA(hdRec, pointid); if(not sPOA) then
    asmlib.Notify(ply,"Start segment missing !","ERROR")
    asmlib.LogInstance("Start segment missing: "..fnmodel, gtArgsLogs); return nil
  end
  -- Disable for missing end track segments
  local ePOA = asmlib.LocatePOA(hdRec, pnextid); if(not ePOA) then
    asmlib.Notify(ply,"End segment missing !","ERROR")
    asmlib.LogInstance("End segment missing: "..fnmodel, gtArgsLogs); return nil
  end
  -- Read the active point and check piece shape
  local sO, sA = tC.Info.Pos[1], tC.Info.Ang[1]
        asmlib.SetVector(sO, sPOA.O); asmlib.SetAngle(sA, sPOA.A)
  -- Read the next point to check the piece shape
  local eO, eA = tC.Info.Pos[2], tC.Info.Ang[2]
        asmlib.SetVector(eO, ePOA.O); asmlib.SetAngle(eA, ePOA.A)
  -- Disable for non-straight track segments
  if(sA:Forward():Cross(eA:Forward()):Length() >= nEps) then
    asmlib.Notify(ply,"Segment curved "..fnmodel.." !","ERROR")
    asmlib.LogInstance("Segment curved: "..fnmodel, gtArgsLogs); return nil
  end
  -- Disable for 180 curve track segments
  if(sA:Forward():Dot(eA:Forward()) >= 0) then
    asmlib.Notify(ply,"Segment overturn "..fnmodel.." !","ERROR")
    asmlib.LogInstance("Segment overturn: "..fnmodel, gtArgsLogs); return nil
  end
  -- Disable for ramp track segments
  if(sA:Forward():Dot((sO - eO):GetNormalized()) < (1 - nEps)) then
    asmlib.Notify(ply,"Segment gradient "..fnmodel.." !","ERROR")
    asmlib.LogInstance("Segment gradient: "..fnmodel, gtArgsLogs); return nil
  end
  return tC -- Returns the updated curve nodes table
end

function TOOL:LeftClick(stTrace)
  if(CLIENT) then -- Do not do stuff when CLIENT attempts somrthing
    asmlib.LogInstance("Working on client",gtArgsLogs); return true end
  if(not asmlib.IsInit()) then -- Do not do stuff when library is not initialized
    asmlib.LogInstance("Library error",gtArgsLogs); return false end
  if(not stTrace) then -- Do not do stuff when there is no trace
    asmlib.LogInstance("Trace missing",gtArgsLogs); return false end
  if(not stTrace.Hit) then -- Do not do stuff when there is nothing hit
    asmlib.LogInstance("Trace not hit",gtArgsLogs); return false end
  local ply        = self:GetOwner()
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
  local bnderrmod  = self:GetBoundErrorMode()
  local appangfst  = self:ApplyAngularFirst()
  local applinfst  = self:ApplyLinearFirst()
  local nocollidew = self:GetNocollideWorld()
  local fnmodel    = stringGetFileName(model)
  local aninfo , anEnt   = self:GetAnchor()
  local pointid, pnextid = self:GetPointID()
  local workmode, workname = self:GetWorkingMode()
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()

  if(workmode == 3) then
    local hdRec = asmlib.CacheQueryPiece(model); if(not asmlib.IsHere(hdRec)) then
      asmlib.LogInstance(self:GetStatus(stTrace,"(Hold) Holder model not piece"),gtArgsLogs); return false end
    local tC = self:CurveCheck(); if(not asmlib.IsHere(tC)) then
      asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) Arguments validation fail"), gtArgsLogs); return nil end
    local curvefact = self:GetCurveFactor()
    local curvsmple = self:GetCurveSamples()
    local crvturnlm = self:GetCurvatureTurn()
    local crvleanlm = self:GetCurvatureLean()
    local sO, sA, ePieceO = tC.Info.Pos[1], tC.Info.Ang[1], nil
    local eO, eA, ePieceN = tC.Info.Pos[2], tC.Info.Ang[2], nil
    local nD, iTry, iMak, iStk = (eO - sO):Length(), 0, 0, 0
    local sItr, fInt = "", asmlib.GetOpVar("FORM_INTEGER")
    asmlib.CalculateRomCurve(ply, curvsmple, curvefact)
    if(stackcnt > 0) then
      asmlib.UndoCrate(gsUndoPrefN..stringGetFileName(model).." ( Curve #"..stackcnt.." )")
    else
      asmlib.UndoCrate(gsUndoPrefN..stringGetFileName(model).." ( Curve )")
    end
    for iD = 1, (tC.CSize - 1) do
      local tS, nL = asmlib.UpdateCurveSnap(ply, iD, nD)
      if(tS and tS[1] and tS.Size and tS.Size > 0) then
        for iK = 1, tS.Size do local tV, ePiece = tS[iK], nil
          local stSpawn = asmlib.GetNormalSpawn(ply, tV[1], tV[2], model, pointid)
          if(not stSpawn) then -- Make sure it persists to set it afterwards
            asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) Cannot obtain spawn data"),gtArgsLogs); return false end
          if(crvturnlm > 0 or crvleanlm > 0) then
            local nF, nU = asmlib.GetTurningFactor(ply, tS, iK)
            if(nF and nF < crvturnlm) then
              local sItr = fInt:format(iD)
              local nPnt = asmlib.GetNearest(tV[1], tC.Node)
              local sCan = ("%4.3f"):format(nU)
              local sNar = asmlib.GetReport3(sItr,nPnt,sCan)
              asmlib.UndoFinish(ply, sItr..sNar)
              asmlib.Notify(ply, "Curve turn excessive at "..sNar.." !", "ERROR")
              asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) "..sNar..": Turn excessive"), gtArgsLogs); return true
            end
            if(nU and nU < crvleanlm) then
              local sItr = fInt:format(iD)
              local nPnt = asmlib.GetNearest(tV[1], tC.Node)
              local sCan = ("%4.3f"):format(nU)
              local sNar = asmlib.GetReport3(sItr,nPnt,sCan)
              asmlib.UndoFinish(ply, sItr..sNar)
              asmlib.Notify(ply, "Curve lean excessive at "..sNar.." !", "ERROR")
              asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) "..sNar..": Lean excessive"), gtArgsLogs); return true
            end
          end
          while(iTry < maxstatts and not ePiece) do iTry = (iTry + 1)
            ePiece = asmlib.MakePiece(ply,model,stSpawn.SPos,stSpawn.SAng,mass,bgskids,conPalette:Select("w"),bnderrmod) end
          if(stackcnt > 0) then if(iStk < stackcnt) then iStk = (iStk + 1) else ePiece:Remove(); ePiece = nil end end
          iMak = (iMak + (ePiece and 1 or 0)); sItr = fInt:format(iMak)
          if(ePiece) then ePieceO, ePieceN = ePieceN, ePiece -- We still have enough memory to preform the stacking
            if(not asmlib.ApplyPhysicalSettings(ePieceN,ignphysgn,freeze,gravity,physmater)) then
              asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) "..sItr..": Apply physical settings fail"),gtArgsLogs); return false end
            if(not asmlib.ApplyPhysicalAnchor(ePieceN,(anEnt or ePieceO),weld,nil,nil,forcelim)) then
              asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) "..sItr..": Apply weld fail"),gtArgsLogs); return false end
            if(not asmlib.ApplyPhysicalAnchor(ePieceN,ePieceO,nil,nocollide,nocollidew,forcelim)) then
              asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) "..sItr..": Apply no-collide fail"),gtArgsLogs); return false end
            asmlib.UndoAddEntity(ePieceN); iTry = 0 -- Reset the stack attempts count
          else asmlib.UndoFinish(ply, sItr) -- We still have enough memory to preform the stacking
            if(stackcnt > 0) then -- Output different log message when stack count is used for curve segments limit
              asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) "..sItr..": Segment limit reached"), gtArgsLogs); return true
            else asmlib.LogInstance(self:GetStatus(stTrace,"(Curve) "..sItr..": All stack attempts fail"), gtArgsLogs); return true end
          end
        end
      end
    end
    asmlib.UndoFinish(ply)
    asmlib.LogInstance("(Curve) Success",gtArgsLogs); return true
  elseif(workmode == 4 and self:GetFlipOverFlag()) then
    local wOver, wNorm = self:GetFlipOverOrigin(stTrace, ply:KeyDown(IN_SPEED))
    local tE, nE = self:GetFlipOverEntity()
    if(not tE or nE <= 0) then
      asmlib.Notify(ply, "Flip over no tracks selected !", "ERROR")
      asmlib.LogInstance(self:GetStatus(stTrace,"(Over) No tracks selected",trEnt),gtArgsLogs); return false
    end
    for iD = 1, nE do local eID = tE[iD]
      if(not asmlib.IsOther(eID)) then local sM = eID:GetModel()
        asmlib.UndoCrate(gsUndoPrefN..asmlib.GetReport2(iD, stringGetFileName(sM)).." ( Over )")
        local spPos, spAng = asmlib.GetTransformOBB(eID, wOver, wNorm, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
        local ePiece = asmlib.MakePiece(ply,sM,spPos,spAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
        if(ePiece) then
          if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
            asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Apply physical settings fail"),gtArgsLogs); return false end
          asmlib.UndoAddEntity(ePiece)
        else
          asmlib.UndoFinish(ply, asmlib.GetReport2(iD, stringGetFileName(sM)))
          asmlib.Notify(ply, "Flip over spawn invalid "..asmlib.GetReport2(iD, sM).." !", "ERROR")
        end
        asmlib.UndoFinish(ply)
      end
    end; return true
  end

  local hdRec = asmlib.CacheQueryPiece(model); if(not asmlib.IsHere(hdRec)) then
    asmlib.LogInstance(self:GetStatus(stTrace,"(Hold) Holder model not piece"),gtArgsLogs); return false end

  if(stTrace.HitWorld) then -- Switch the tool mode ( Spawn )
    local vPos = Vector(); vPos:Set(stTrace.HitNormal); vPos:Mul(elevpnt); vPos:Add(stTrace.HitPos)
    local aAng = asmlib.GetNormalAngle(ply,stTrace,surfsnap,angsnap)
    if(spawncn) then  -- Spawn on mass center
      aAng:RotateAroundAxis(aAng:Up()     ,-nextyaw)
      aAng:RotateAroundAxis(aAng:Right()  , nextpic)
      aAng:RotateAroundAxis(aAng:Forward(), nextrol)
    else
      local stSpawn = asmlib.GetNormalSpawn(ply,vPos,aAng,model,
                        pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(not stSpawn) then -- Make sure it persists to set it afterwards
        asmlib.LogInstance(self:GetStatus(stTrace,"(World) Cannot obtain spawn data"),gtArgsLogs); return false end
      vPos:Set(stSpawn.SPos); aAng:Set(stSpawn.SAng)
    end
    local ePiece = asmlib.MakePiece(ply,model,vPos,aAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
    if(ePiece) then
      if(spawncn) then -- Adjust the position when created correctly
        asmlib.SetCenter(ePiece, vPos, aAng, nextx, -nexty, nextz)
      end
      if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(World) Failed to apply physical settings",ePiece),gtArgsLogs); return false end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,anEnt,weld,nocollide,nocollidew,forcelim)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(World) Failed to apply physical anchor",ePiece),gtArgsLogs); return false end
      asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( World )")
      asmlib.UndoAddEntity(ePiece)
      asmlib.UndoFinish(ply)
      asmlib.LogInstance("(World) Success",gtArgsLogs); return true
    end
    asmlib.LogInstance(self:GetStatus(stTrace,"(World) Failed to create"),gtArgsLogs); return false
  end

  if(not (trEnt and trEnt:IsValid())) then
    asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Trace entity invalid"),gtArgsLogs); return false end
  if(asmlib.IsOther(trEnt)) then
    asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Trace other object"),gtArgsLogs); return false end
  if(not asmlib.IsPhysTrace(stTrace)) then
    asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Trace not physical object"),gtArgsLogs); return false end

  local trRec = asmlib.CacheQueryPiece(trEnt:GetModel()); if(not asmlib.IsHere(trRec)) then
    asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Trace model not piece"),gtArgsLogs); return false end

  local stSpawn = asmlib.GetEntitySpawn(ply,trEnt,stTrace.HitPos,model,pointid,
                           actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
  if(not stSpawn) then -- Not aiming into an active point update settings/properties
    if(ply:KeyDown(IN_USE)) then -- Physical
      if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Physical) Failed to apply physical settings",trEnt),gtArgsLogs); return false end
      if(not asmlib.ApplyPhysicalAnchor(trEnt,anEnt,weld,nocollide,nocollidew,forcelim)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Physical) Failed to apply physical anchor",trEnt),gtArgsLogs); return false end
      trEnt:GetPhysicsObject():SetMass(mass)
      asmlib.LogInstance("(Physical) Success",gtArgsLogs)
    elseif(ply:KeyDown(IN_SPEED)) then -- Fast single flip over the anchor relative to a piece OBB
      if(not (anEnt and anEnt:IsValid())) then return false end
      if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Failed to apply physical settings",trEnt),gtArgsLogs); return false end
      local spPos, spAng = asmlib.GetTransformOBB(anEnt, trEnt:LocalToWorld(trEnt:OBBCenter()),
                             stTrace.HitNormal, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
      local ePiece = asmlib.MakePiece(ply,anEnt:GetModel(),spPos,spAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
      if(ePiece) then
        if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
          asmlib.LogInstance(self:GetStatus(stTrace,"(Over) Apply physical settings fail"),gtArgsLogs); return false end
        asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( Over )")
        asmlib.UndoAddEntity(ePiece)
        asmlib.UndoFinish(ply)
        asmlib.LogInstance("(Over) Success",gtArgsLogs); return true
      end
    else -- Visual
      local IDs = gsSymDir:Explode(bgskids)
      if(not asmlib.AttachBodyGroups(trEnt,IDs[1] or "")) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Bodygroup/Skin) Failed",trEnt),gtArgsLogs); return false end
      trEnt:SetSkin(mathClamp(tonumber(IDs[2]) or 0,0,trEnt:SkinCount()-1))
      asmlib.LogInstance("(Bodygroup/Skin) Success",gtArgsLogs)
    end; return true
  end

  -- IN_SPEED: Switch the tool mode ( Stacking )
  if((workmode == 1) and (stackcnt > 0) and ply:KeyDown(IN_SPEED) and (tonumber(hdRec.Size) or 0) > 1) then
    if(goThQueue:IsBusy(ply)) then asmlib.Notify(ply,"Surver busy stacking "..fnmodel.." !","ERROR"); return true end
    if(pointid == pnextid) then asmlib.LogInstance(self:GetStatus(stTrace,"Point ID overlap"),gtArgsLogs); return false end
    local hdOffs = asmlib.LocatePOA(stSpawn.HRec,pnextid)
    if(not hdOffs) then -- Make sure it is present
      asmlib.Notify(ply,"Cannot find next PointID !","ERROR")
      asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) Missing next point ID"),gtArgsLogs); return false
    end -- Validated existent next point ID
    goThQueue:Set(ply, {
      start = 1   ,
      spawn = {}  ,
      sppos = Vector(stSpawn.SPos),
      spang = Angle (stSpawn.SAng),
      vtemp = Vector(),
      entpn = nil,
      entpo = trEnt,
      itrys = 0,
      itera = 0,
      srate = spawnrate
    }, function(oPly, oArg)
      for iD = oArg.start, stackcnt do
        oPly:SetNWFloat(gsToolPrefL.."progress", 100 * (iD / stackcnt))
        local sItr, ePiece = asmlib.GetOpVar("FORM_INTEGER"):format(iD), nil
        while(oArg.itrys < maxstatts and not ePiece) do oArg.itrys = (oArg.itrys + 1)
          ePiece = asmlib.MakePiece(oPly,model,oArg.sppos,oArg.spang,mass,bgskids,conPalette:Select("w"),bnderrmod) end
        if(ePiece) then oArg.entpn = ePiece -- Set position is valid and store reference to the track piece
          if(not asmlib.ApplyPhysicalSettings(oArg.entpn,ignphysgn,freeze,gravity,physmater)) then oArg.itera = iD
            asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": Apply physical settings fail"),gtArgsLogs); return false end
          if(not asmlib.ApplyPhysicalAnchor(oArg.entpn,(anEnt or oArg.entpo),weld,nil,nil,forcelim)) then oArg.itera = iD
            asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": Apply weld fail"),gtArgsLogs); return false end
          if(not asmlib.ApplyPhysicalAnchor(oArg.entpn,oArg.entpo,nil,nocollide,nocollidew,forcelim)) then oArg.itera = iD
            asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": Apply no-collide fail"),gtArgsLogs); return false end
          asmlib.SetVector(oArg.vtemp,hdOffs.P); oArg.vtemp:Rotate(oArg.spang)
          oArg.vtemp:Add(oArg.entpn:GetPos()); tableInsert(oArg.eundo, oArg.entpn)
          if(appangfst) then nextpic, nextyaw, nextrol, appangfst = 0, 0, 0, false end
          if(applinfst) then nextx  , nexty  , nextz  , applinfst = 0, 0, 0, false end
          oArg.spawn = asmlib.GetEntitySpawn(oPly,oArg.entpn,oArg.vtemp,model,pointid,
                         actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol,oArg.spawn)
          if(not oArg.spawn) then -- Someting happend spawn is not available and task must be removed
            asmlib.Notify(oPly,"Cannot obtain spawn data !", "ERROR"); oArg.itera = iD
            asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": Stacking has invalid user data"),gtArgsLogs); return false
          end -- Spawn data is valid for the current iteration iNdex
          oArg.sppos:Set(oArg.spawn.SPos); oArg.spang:Set(oArg.spawn.SAng)
          oArg.entpo, oArg.itrys, oArg.srate = oArg.entpn, 0, (oArg.srate - 1)
          -- Check whenever the routine item is still busy
          if(oArg.srate <= 0) then
            oArg.start, oArg.srate = (iD + 1), spawnrate
            asmlib.LogInstance("(Stack) Next ["..oArg.start.."]",gtArgsLogs);
            return true -- The server is still busy with the task
          end
        else oArg.itera = iD -- Someting happend piece cannot be created and task must be removed
          asmlib.LogInstance(self:GetStatus(stTrace,"(Stack) "..sItr..": All stack attempts fail"),gtArgsLogs); return false
        end -- We still have enough memory to preform the stacking
      end -- Update the progress and successfully tell the task we are not busy anymore
      oPly:SetNWFloat(gsToolPrefL.."progress", 0)
      asmlib.LogInstance("(Stack) Success",gtArgsLogs); return false
    end, workname)
    goThQueue:Start(ply, function(oPly, oArg) oArg.eundo = {} end)
    goThQueue:Close(ply, function(oPly, oArg)
      asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( Stack #"..stackcnt.." )")
      for iD = 1, #oArg.eundo do
        asmlib.UndoAddEntity(oArg.eundo[iD]) end
      if(oArg.itera > 0) then
        local fItr = asmlib.GetOpVar("FORM_INTEGER")
        local sItr = fItr:format(oArg.itera)
        asmlib.UndoFinish(oPly, sItr)
      else
        asmlib.UndoFinish(oPly)
      end
    end); return true
  else -- Switch the tool mode ( Snapping )
    if(workmode == 2) then -- Make a ray intersection spawn update
      if(not self:IntersectSnap(trEnt, stTrace.HitPos, stSpawn)) then
        asmlib.LogInstance("(Ray) Skip intersection sequence. Snapping",gtArgsLogs) end
    end
    local ePiece = asmlib.MakePiece(ply,model,stSpawn.SPos,stSpawn.SAng,mass,bgskids,conPalette:Select("w"),bnderrmod)
    if(ePiece) then
      if(not asmlib.ApplyPhysicalSettings(ePiece,ignphysgn,freeze,gravity,physmater)) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Snap) Apply physical settings fail"),gtArgsLogs); return false end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,(anEnt or trEnt),weld,nil,nil,forcelim)) then -- Weld all created to the anchor/previous
        asmlib.LogInstance(self:GetStatus(stTrace,"(Snap) Apply weld fail"),gtArgsLogs); return false end
      if(not asmlib.ApplyPhysicalAnchor(ePiece,trEnt,nil,nocollide,nocollidew,forcelim)) then       -- NoCollide all to previous
        asmlib.LogInstance(self:GetStatus(stTrace,"(Snap) Apply no-collide fail"),gtArgsLogs); return false end
      asmlib.UndoCrate(gsUndoPrefN..fnmodel.." ( Snap )")
      asmlib.UndoAddEntity(ePiece)
      asmlib.UndoFinish(ply)
      asmlib.LogInstance("(Snap) Success",gtArgsLogs); return true
    end
    asmlib.LogInstance(self:GetStatus(stTrace,"(Snap) Crating piece fail"),gtArgsLogs); return false
  end
end

--[[
 * If tells what will happen if the RightClick of the mouse is pressed
 * Changes the active point chosen by the holder or copy the model
]]--
function TOOL:RightClick(stTrace)
  if(CLIENT) then
    asmlib.LogInstance("Working on client",gtArgsLogs); return true end
  if(not asmlib.IsInit()) then
    asmlib.LogInstance("Library fail",gtArgsLogs); return false end
  if(not stTrace) then
    asmlib.LogInstance("Trace missing",gtArgsLogs); return false end
  local trEnt     = stTrace.Entity
  local ply       = self:GetOwner()
  local workmode  = self:GetWorkingMode()
  local enpntmscr = self:GetScrollMouse()
  if(workmode == 3) then local tC
    if(ply:KeyDown(IN_SPEED)) then tC = self:CurveUpdate(stTrace)
    else tC = self:CurveInsert(stTrace) end; return (tC and true or false)
  elseif(workmode == 4 and not ply:KeyDown(IN_SPEED)) then
    self:SetFlipOver(trEnt); return true
  end
  if(stTrace.HitWorld) then
    if(enpntmscr or (ply:KeyDown(IN_USE) and not enpntmscr)) then
      asmlib.SetAsmConvar(ply,"openframe",asmlib.GetAsmConvar("maxfruse" ,"INT"))
      asmlib.LogInstance("(World) Success open frame",gtArgsLogs); return true
    end
  elseif(trEnt and trEnt:IsValid()) then
    if(enpntmscr or (ply:KeyDown(IN_USE) and not enpntmscr)) then
      if(not self:SelectModel(trEnt:GetModel())) then
        asmlib.LogInstance(self:GetStatus(stTrace,"(Select,"..tostring(enpntmscr)..") Model not piece"),gtArgsLogs); return false end
      asmlib.LogInstance("(Select,"..tostring(enpntmscr)..") Success",gtArgsLogs); return true
    end
  end
  if(not enpntmscr) then
    local nDir = (ply:KeyDown(IN_SPEED) and -1 or 1)
    self:SwitchPoint(nDir,ply:KeyDown(IN_DUCK))
    asmlib.LogInstance("(Point) Success",gtArgsLogs); return true
  end
end

function TOOL:Reload(stTrace)
  if(CLIENT) then
    asmlib.LogInstance("Working on client",gtArgsLogs); return true end
  if(not stTrace) then
    asmlib.LogInstance("Invalid trace",gtArgsLogs); return false end
  local ply      = self:GetOwner()
  local trEnt    = stTrace.Entity
  local workmode = self:GetWorkingMode()
  local bfover   = self:GetFlipOverFlag()
  if(stTrace.HitWorld) then
    if(self:GetDeveloperMode()) then
      asmlib.SetLogControl(self:GetLogLines(),self:GetLogFile()) end
    if(self:GetExportDB()) then
      if(ply:KeyDown(IN_USE)) then
        asmlib.SetAsmConvar(ply,"openextdb")
        asmlib.LogInstance("(World) Success open expdb",gtArgsLogs)
      else
        asmlib.ExportDSV("PIECES")
        asmlib.ExportDSV("ADDITIONS")
        asmlib.ExportDSV("PHYSPROPERTIES")
        asmlib.LogInstance("(World) Exporting DB",gtArgsLogs)
      end
      asmlib.SetAsmConvar(ply, "exportdb", 0)
    end
    if(ply:KeyDown(IN_SPEED)) then
      if(workmode == 1) then self:ClearAnchor(false)
        asmlib.LogInstance("(World) Anchor clear",gtArgsLogs)
      elseif(workmode == 2) then self:IntersectClear(false)
        asmlib.LogInstance("(World) Relate clear",gtArgsLogs)
      elseif(workmode == 3) then self:CurveClear(true)
        asmlib.LogInstance("(World) Nodes cleared",gtArgsLogs)
      elseif(workmode == 4 and bfover) then self:ClearFlipOver()
        asmlib.LogInstance("(World) Flip over cleared",gtArgsLogs)
      end
    else
      if(workmode == 3) then self:CurveClear(false)
        asmlib.LogInstance("(World) Node removed",gtArgsLogs)
      elseif(workmode == 4 and bfover) then self:ClearFlipOver()
        asmlib.LogInstance("(World) Flip over cleared",gtArgsLogs)
      end
    end; asmlib.LogInstance("(World) Success",gtArgsLogs); return true
  elseif(trEnt and trEnt:IsValid()) then
    if(not asmlib.IsPhysTrace(stTrace)) then return false end
    if(asmlib.IsOther(trEnt)) then
      asmlib.LogInstance("(Prop) Trace other object",gtArgsLogs); return false end
    if(ply:KeyDown(IN_SPEED)) then
      if(workmode == 1) then -- General anchor
        if(not self:SetAnchor(stTrace)) then
          asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Anchor set fail"),gtArgsLogs); return false end
        asmlib.LogInstance("(Prop) Anchor set",gtArgsLogs); return true
      elseif(workmode == 2) then -- Intersect relation
        if(not self:IntersectRelate(ply, trEnt, stTrace.HitPos)) then
          asmlib.LogInstance(self:GetStatus(stTrace,"(Prop) Relation set fail"),gtArgsLogs); return false end
        asmlib.LogInstance("(Prop) Relation set",gtArgsLogs); return true
      elseif(workmode == 3) then self:CurveClear(true)
        asmlib.LogInstance("(Prop) Nodes cleared",gtArgsLogs); return true
      elseif(workmode == 4 and bfover) then self:ClearFlipOver()
        asmlib.LogInstance("(Prop) Flip over cleared",gtArgsLogs); return true
      end
    else
      if(workmode == 3) then self:CurveClear(false)
        asmlib.LogInstance("(Prop) Node removed",gtArgsLogs); return true
      elseif(workmode == 4 and bfover) then self:ClearFlipOver()
        asmlib.LogInstance("(Prop) Flip over cleared",gtArgsLogs); return true
      end
    end
    local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
    if(asmlib.IsHere(trRec)) then trEnt:Remove()
      asmlib.LogInstance("(Prop) Remove piece",gtArgsLogs); return true
    end
  end; return false
end

function TOOL:Holster()
  asmlib.ClearGhosts()
end

function TOOL:UpdateGhostFlipOver(stTrace, sPos, sAng)
  local atGho = asmlib.GetOpVar("ARRAY_GHOST")
  local tE, nE = self:GetFlipOverEntity(true)
  if(tE and self:GetFlipOverFlag()) then
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
  local ply = self:GetOwner()
  local tCrv = self:CurveCheck()
  local bCrv = ply:GetNWBool(gsToolPrefL.."engcurve", false)
  if(tCrv and tCrv.Size and tCrv.Size > 1) then
    local model = self:GetModel()
    local pointid, pnextid = self:GetPointID()
    local tGho, iGho, eGho = asmlib.GetOpVar("ARRAY_GHOST"), 0
    if(bCrv) then
      asmlib.LogInstance("(Curve) Recalc ghost",gtArgsLogs)
      ply:SetNWBool(gsToolPrefL.."engcurve", false)
      local curvefact = self:GetCurveFactor()
      local curvsmple = self:GetCurveSamples()
      local sO, sA, ePieceO = tCrv.Info.Pos[1], tCrv.Info.Ang[1], nil
      local eO, eA, ePieceN = tCrv.Info.Pos[2], tCrv.Info.Ang[2], nil
      local nD, iTry = (eO - sO):Length(), 0
      local iMak, iStk, sItr = 0, 0
      asmlib.CalculateRomCurve(ply, curvsmple, curvefact)
      for iD = 1, tCrv.CSize-1 do
        local tS = asmlib.UpdateCurveSnap(ply, iD, nD)
        if(tS and tS[1] and tS.Size and tS.Size > 0) then
          for iK = 1, tS.Size do local tV = tS[iK]; iGho = (iGho + 1); eGho = tGho[iGho]
            local stSpawn = asmlib.GetNormalSpawn(ply, tV[1], tV[2], model, pointid)
            if(eGho and eGho:IsValid()) then eGho:SetNoDraw(true); if(stSpawn) then
              eGho:SetPos(stSpawn.SPos); eGho:SetAngles(stSpawn.SAng); eGho:SetNoDraw(false) end
            end
          end
        end
      end
    else
      local tSnp, iGho, eGho = tCrv.Snap, 0, nil
      if(tSnp and tSnp[1] and tCrv.SSize and tCrv.SSize > 0) then
        for iD = 1, tCrv.SSize do local tS = tSnp[iD]
          for iK = 1, tS.Size  do local tV = tS[iK]; iGho = (iGho + 1); eGho = tGho[iGho]
            local stSpawn = asmlib.GetNormalSpawn(ply, tV[1], tV[2], model, pointid)
            if(eGho and eGho:IsValid()) then eGho:SetNoDraw(true); if(stSpawn) then
              eGho:SetPos(stSpawn.SPos); eGho:SetAngles(stSpawn.SAng); eGho:SetNoDraw(false) end
            end
          end
        end
      end
    end
  end
end

function TOOL:UpdateGhost(oPly)
  if(not asmlib.FadeGhosts(true)) then return nil end
  if(self:GetGhostsCount() <= 0) then return nil end
  local stTrace = asmlib.GetCacheTrace(oPly)
  if(not stTrace) then return nil end
  if(not asmlib.HasGhosts()) then return nil end
  local workmode = self:GetWorkingMode()
  if(workmode == 3) then self:UpdateGhostCurve() return nil end
  local atGho = asmlib.GetOpVar("ARRAY_GHOST")
  local trEnt, model = stTrace.Entity, self:GetModel()
  local pointid, pnextid = self:GetPointID()
  local nextx, nexty, nextz = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  if(stTrace.HitWorld) then
    local ePiece   = atGho[1]
    local angsnap  = self:GetAngSnap()
    local elevpnt  = self:GetElevation()
    local surfsnap = self:GetSurfaceSnap()
    local vPos = Vector(); vPos:Set(stTrace.HitNormal); vPos:Mul(elevpnt); vPos:Add(stTrace.HitPos)
    local aAng = asmlib.GetNormalAngle(oPly,stTrace,surfsnap,angsnap)
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
        if(workmode == 4) then
          self:UpdateGhostFlipOver(stTrace, stSpawn.SPos, stSpawn.SAng)
        else
          ePiece:SetPos(stSpawn.SPos); ePiece:SetAngles(stSpawn.SAng); ePiece:SetNoDraw(false)
        end
      end
    end
  elseif(trEnt and trEnt:IsValid()) then
    if(asmlib.IsOther(trEnt)) then return nil end
    local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
    if(asmlib.IsHere(trRec)) then
      local ePiece    = atGho[1]
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
            if(not hdOffs) then return nil end -- Validated existent next point ID
            for iNdex = 1, atGho.Size do ePiece = atGho[iNdex]
              ePiece:SetPos(stSpawn.SPos); ePiece:SetAngles(stSpawn.SAng); ePiece:SetNoDraw(false)
              asmlib.SetVector(vTemp,hdOffs.P); vTemp:Rotate(stSpawn.SAng); vTemp:Add(ePiece:GetPos())
              if(appangfst) then nextpic,nextyaw,nextrol, appangfst = 0,0,0,false end
              if(applinfst) then nextx  ,nexty  ,nextz  , applinfst = 0,0,0,false end
              stSpawn = asmlib.GetEntitySpawn(oPly,ePiece,vTemp,model,pointid,
                actrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
              if(not stSpawn) then return nil end
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
    end
  end
end

function TOOL:ElevateGhost(oEnt, oPly)
  if(not (oPly and oPly:IsValid() and oPly:IsPlayer())) then
    asmlib.LogInstance("Player invalid <"..tostring(oPly)..">",gtArgsLogs); return nil end
  local spawncn, elevpnt = self:GetSpawnCenter(), 0
  if(oEnt and oEnt:IsValid()) then
    if(spawncn) then -- Distance for the piece spawned on the ground
      local vobdbox = oEnt:OBBMins(); elevpnt = -vobdbox[cvZ]
    else local pointid, pnextid = self:GetPointID()
      elevpnt = (asmlib.GetPointElevation(oEnt, pointid) or 0)
    end; asmlib.LogInstance("("..tostring(spawncn)..") <"..tostring(elevpnt)..">",gtArgsLogs)
  end; asmlib.SetAsmConvar(oPly, "elevpnt", elevpnt)
end

function TOOL:Think()
  if(not asmlib.IsInit()) then return end
  local model = self:GetModel()
  if(utilIsValidModel(model)) then
    local workmode = self:GetWorkingMode()
    if(CLIENT) then -- Precache the model or it is invalid otherwise
      local bOld = asmlib.IsFlag("old_close_frame", asmlib.IsFlag("new_close_frame"))
      local bNew = asmlib.IsFlag("new_close_frame", inputIsKeyDown(KEY_E))
      if(not bOld and bNew and inputIsKeyDown(KEY_LALT)) then
        local pnFrame = conElements:Pull() -- Retrieve a panel from the stack
        if(IsValid(pnFrame)) then pnFrame:Close() end -- Call close on it !
      end -- Shortcut for closing the routine pieces. A `close` call, get it :D
    end
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
  local ply, iD = LocalPlayer(), 1
  local stS = asmlib.GetCacheSpawn(ply)
  local arK = asmlib.GetOpVar("STRUCT_SPAWN")
  local fky = asmlib.GetOpVar("FORM_DRWSPKY")
  local w,h = oScreen:GetSize()
  oScreen:SetTextEdge(0,230)
  oScreen:DrawText(tostring(arK.Name),sCol,sMeth,tArgs)
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
          if(not bs) then asmlib.LogInstance(sr, gtArgsLogs); return end
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
  oScreen:DrawLine(Rp, Rf, "r")
  oScreen:DrawLine(Rp, Ru, "b")
  oScreen:DrawCircle(Rp, asmlib.GetViewRadius(oPly, rOrg), "y", "SEGM", {35})
  return Rp, Rf, Ru
end

function TOOL:DrawRelateAssist(oScreen, oPly, stTrace)
  local trEnt, trHit = stTrace.Entity, stTrace.HitPos
  local trRec = asmlib.CacheQueryPiece(trEnt:GetModel())
  if(not asmlib.IsHere(trRec)) then return end
  local nRad, nLn = asmlib.GetCacheRadius(oPly, trHit), self:GetSizeUCS()
  local vTmp, aTmp, trLen, trPOA = Vector(), Angle(), 0, nil
  local trPos, trAng = trEnt:GetPos(), trEnt:GetAngles()
  for ID = 1, trRec.Size do
    local stPOA = asmlib.LocatePOA(trRec,ID); if(not stPOA) then
      asmlib.LogInstance("Cannot locate #"..tostring(ID),gtArgsLogs); return nil end
    asmlib.SetVector(vTmp, stPOA.O); vTmp:Rotate(trAng); vTmp:Add(trPos)
    oScreen:DrawCircle(vTmp:ToScreen(), asmlib.GetViewRadius(oPly, vTmp), "y", "SEGM", {35})
    vTmp:Sub(trHit); if(not trPOA or (vTmp:Length() < trLen)) then trLen, trPOA = vTmp:Length(), stPOA end
  end
  asmlib.SetVector(vTmp,trPOA.O); vTmp:Rotate(trAng); vTmp:Add(trPos)
  asmlib.SetAngle (aTmp,trPOA.A); aTmp:Set(trEnt:LocalToWorldAngles(aTmp))
  local Hp, Op = trHit:ToScreen(), vTmp:ToScreen()
  local vF, vU = aTmp:Forward(), aTmp:Up()
  vF:Mul(nLn); vU:Mul(0.5 * nLn); vF:Add(vTmp); vU:Add(vTmp)
  local xF, xU = vF:ToScreen(), vU:ToScreen()
  oScreen:DrawCircle(Hp, nRad, "y")
  oScreen:DrawLine(Hp, Op, "g")
  oScreen:DrawLine(xF, Op, "r")
  oScreen:DrawLine(xU, Op, "b")
end

function TOOL:DrawSnapAssist(oScreen, oPly, stTrace)
  local actrad = self:GetActiveRadius()
  local trRec  = asmlib.CacheQueryPiece(stTrace.Entity:GetModel())
  if(not asmlib.IsHere(trRec)) then return end
  local nRad = asmlib.GetCacheRadius(oPly, stTrace.HitPos)
  for ID = 1, trRec.Size do
    local stPOA = asmlib.LocatePOA(trRec,ID); if(not stPOA) then
      asmlib.LogInstance("Cannot locate #"..tostring(ID),gtArgsLogs); return nil end
    oScreen:DrawPOA(oPly, stTrace.Entity, stPOA, actrad / 4.9)
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
    oScreen:DrawLine(Os,Ss,"m")
    oScreen:DrawCircle(Ss, asmlib.GetViewRadius(oPly, sPos),"c")
    oScreen:DrawCircle(xX, asmlib.GetViewRadius(oPly, xx, 2), "b")
    oScreen:DrawLine(xX,O1,"ry")
    oScreen:DrawLine(xX,O2)
    oScreen:DrawCircle(O1, asmlib.GetViewRadius(oPly, vO1, 0.5), "r")
    oScreen:DrawCircle(O2, asmlib.GetViewRadius(oPly, vO2, 0.5), "g")
    return xX, O1, O2
  end; return nil
end

function TOOL:DrawPillarIntersection(oScreen, vX, vX1, vX2)
  local oPly, XX = self:GetOwner(), vX:ToScreen()
  local X1, X2 = vX1:ToScreen(), vX2:ToScreen()
  oScreen:DrawLine(X1,X2,"ry")
  oScreen:DrawCircle(X1, asmlib.GetViewRadius(oPly, vX1),"r")
  oScreen:DrawCircle(X2, asmlib.GetViewRadius(oPly, vX2),"g")
  oScreen:DrawCircle(XX, asmlib.GetViewRadius(oPly, vX),"b")
  return XX, X1, X2
end

function TOOL:DrawCurveNode(oScreen, oPly, stTrace)
  local vOrg, aAng, vHit, oPOA = self:GetCurveTransform(stTrace); if(not vOrg) then
    asmlib.LogInstance("Transform missing", gtArgsLogs); return end
  local tC, nS = asmlib.GetCacheCurve(oPly), self:GetSizeUCS(); if(not tC) then
    asmlib.LogInstance("Curve missing", gtArgsLogs); return end
  local xyO, xyH = vOrg:ToScreen(), vHit:ToScreen()
  local nR = asmlib.GetCacheRadius(oPly, vHit, 2)
  local xyZ = (vOrg + nS * aAng:Up()):ToScreen()
  local xyX = (vOrg + nS * aAng:Forward()):ToScreen()
  local bRp, vT, mD, mL = inputIsKeyDown(KEY_LSHIFT), Vector()
  oScreen:DrawLine(xyO, xyH, "y", "SURF")
  oScreen:DrawCircle(xyH, asmlib.GetViewRadius(oPly, vHit, 2), "y", "SEGM", {35})
  oScreen:DrawLine(xyO, xyX, "r")
  oScreen:DrawCircle(xyO, asmlib.GetViewRadius(oPly, vOrg, 6))
  oScreen:DrawLine(xyO, xyZ, "b")
  if(tC.Size and tC.Size > 0) then
    for iD = 1, tC.Size do local rN = (iD == 1 and 6 or 2)
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
      if(bRp) then vT:Set(vB); vT:Sub(vHit)
        local nT = vT:Length() -- Get current length
        if(mL and mD) then -- Length is allocated
          if(nT <= mL) then mD, mL = iD, nT end
        else mD, mL = iD, nT end
      end
    end
  end
  if(tC.Size and tC.Size > 0) then
    if(bRp) then
      local xyN = tC.Node[mD]:ToScreen()
      oScreen:DrawLine(xyN, xyO, "r")
    else
      local xyN = tC.Node[tC.Size]:ToScreen()
      oScreen:DrawLine(xyN, xyO, "y")
    end
  end
  if(oPOA) then local trEnt = stTrace.Entity
    asmlib.SetVector(vOrg, oPOA.O)
    vOrg:Rotate(trEnt:GetAngles())
    vOrg:Add(trEnt:GetPos())
    local xyO = vOrg:ToScreen()
    oScreen:DrawLine(xyH, xyO, "y")
  end
end

function TOOL:DrawNextPoint(oScreen, oPly, stSpawn)
  local pointid, pnextid = self:GetPointID()
  local oRec  = stSpawn.HRec
  local stPOA = asmlib.LocatePOA(oRec, pnextid)
  if(stPOA and oRec.Size > 1) then
    local vN = Vector(); asmlib.SetVector(vN, stPOA.O)
          vN:Rotate(stSpawn.SAng); vN:Add(stSpawn.SPos)
    local Np, Op = vN:ToScreen(), stSpawn.OPos:ToScreen()
    oScreen:DrawLine(Op, Np, "g")
    oScreen:DrawCircle(Np, asmlib.GetViewRadius(oPly, vN, 0.5), "g")
  end
end

function TOOL:DrawFlipOver(hudMonitor, oPly, stTrace)
  local model, trEnt = self:GetModel(), stTrace.Entity
  local actrad, vT = self:GetActiveRadius(), Vector()
  local bActp, xH = inputIsKeyDown(KEY_LSHIFT), stTrace.HitPos:ToScreen()
  local wOv, wNr, wOr, wO1, wO2  = self:GetFlipOverOrigin(stTrace, bActp)
  local nextx  , nexty  , nextz   = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  vT:Set(wNr); vT:Mul(actrad); vT:Add(wOv)
  local oO, oN = wOv:ToScreen(), vT:ToScreen()
  hudMonitor:DrawLine(oO, oN, "y", "SURF")
  hudMonitor:DrawCircle(oN, asmlib.GetViewRadius(oPly, vT, 0.5), "r")
  hudMonitor:DrawLine(oO, xH, "g")
  hudMonitor:DrawCircle(xH, asmlib.GetViewRadius(oPly, stTrace.HitPos, 0.5))
  local tE, nE = self:GetFlipOverEntity(true)
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
  if(bActp and not stTrace.HitWorld and wOr) then
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
      hudMonitor:DrawCircle(Op, asmlib.GetViewRadius(oPly, wOr))
      hudMonitor:DrawCircle(oO, asmlib.GetViewRadius(oPly, wOv, 1.5))
    end
  else
    hudMonitor:DrawCircle(oO, asmlib.GetViewRadius(oPly, wOv, 1.5))
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
    local xyC = asmlib.NewXY(xyP.x + xyS.x / 2, xyP.y + xyS.y / 2)
    hudMonitor:DrawTextCenter(xyC, fP:format(nPrg), "k", "SURF", {"Trebuchet24"})
  end
end

function TOOL:DrawHUD()
  if(SERVER) then return end
  if(not asmlib.IsInit()) then return end
  local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
  local hudMonitor = asmlib.MakeScreen(0,0,scrW,scrH,conPalette,"GAME")
  if(not hudMonitor) then asmlib.LogInstance("Invalid screen",gtArgsLogs); return nil end
  if(not self:GetAdviser()) then return end
  local oPly = LocalPlayer()
  local stTrace = asmlib.GetCacheTrace(oPly)
  if(not (stTrace and stTrace.Hit)) then return end
  self:DrawProgress(hudMonitor, oPly)
  local workmode, model = self:GetWorkingMode(), self:GetModel()
  if(workmode == 3) then
    self:DrawCurveNode(hudMonitor, oPly, stTrace)
    if(not self:GetDeveloperMode()) then return end
    self:DrawTextSpawn(hudMonitor, "k","SURF",{"DebugSpawnTA"}); return
  end
  local trEnt, trHit = stTrace.Entity, stTrace.HitPos
  local nrad = asmlib.GetCacheRadius(oPly, trHit)
  local pointid, pnextid = self:GetPointID()
  local nextx, nexty, nextz = self:GetPosOffsets()
  local nextpic, nextyaw, nextrol = self:GetAngOffsets()
  local sizeucs, Tp = self:GetSizeUCS(), trHit:ToScreen()
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
        self:DrawSnapAssist(hudMonitor, oPly, stTrace)
      elseif(workmode == 2) then
        self:DrawRelateAssist(hudMonitor, oPly, stTrace)
      elseif(workmode == 4) then
        self:DrawFlipOver(hudMonitor, oPly, stTrace)
      end; return -- The return is very very important ... Must stop on invalid spawn
    else -- Patch the drawing for certain working modes
      if(workmode == 4 and self:GetFlipOverFlag()) then
        self:DrawFlipOver(hudMonitor, oPly, stTrace); return end
      local Hp = stSpawn.HPnt:ToScreen()
      local Ob = hudMonitor:DrawUCS(oPly, stSpawn.BPos, stSpawn.BAng, "SURF", {sizeucs})
      local Os = hudMonitor:DrawUCS(oPly, stSpawn.OPos, stSpawn.OAng)
      hudMonitor:DrawLine(Ob,Tp,"y")
      hudMonitor:DrawCircle(Tp,(nrad * (stSpawn.RLen / actrad)) / 2)
      hudMonitor:DrawLine(Ob,Os)
      hudMonitor:DrawLine(Ob,Pp,"r")
      hudMonitor:DrawCircle(Os, asmlib.GetViewRadius(oPly, stSpawn.OPos, 0.5),"r")
      if(workmode == 1) then
        self:DrawNextPoint(hudMonitor, oPly, stSpawn)
      elseif(workmode == 2) then -- Draw point intersection
        local vX, vX1, vX2 = self:IntersectSnap(trEnt, trHit, stSpawn, true)
        local Rp, Re = self:DrawRelateIntersection(hudMonitor, oPly)
        if(Rp and vX) then
          local xX , O1 , O2  = self:DrawModelIntersection(hudMonitor, oPly, stSpawn)
          local pXx, pX1, pX2 = self:DrawPillarIntersection(hudMonitor, vX ,vX1, vX2)
          hudMonitor:DrawLine(Rp,xX,"ry")
          hudMonitor:DrawLine(Os,xX)
          hudMonitor:DrawLine(Rp,O2,"g")
          hudMonitor:DrawLine(Os,O1,"r")
          hudMonitor:DrawLine(xX,pXx,"b")
        end
      end
      local Ss = stSpawn.SPos:ToScreen()
      hudMonitor:DrawLine(Os,Ss,"m")
      hudMonitor:DrawCircle(Ss, asmlib.GetViewRadius(oPly, stSpawn.SPos),"c")
      if(not self:GetDeveloperMode()) then return end
      self:DrawTextSpawn(hudMonitor, "k","SURF",{"DebugSpawnTA"})
    end
  elseif(stTrace.HitWorld) then
    if(workmode == 4 and self:GetFlipOverFlag()) then
      self:DrawFlipOver(hudMonitor, oPly, stTrace); return end
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
      hudMonitor:DrawUCS(oPly, vPos, aAng, "SURF", {sizeucs})
      if(workmode == 2) then -- Draw point intersection
        self:DrawRelateIntersection(hudMonitor, oPly) end
      if(not self:GetDeveloperMode()) then return end
      local x,y = hudMonitor:GetCenter(10,10)
      hudMonitor:SetTextEdge(x,y)
      hudMonitor:DrawText("Org POS: "..tostring(vPos),"k","SURF",{"Trebuchet18"})
      hudMonitor:DrawText("Org ANG: "..tostring(aAng))
    else -- Relative to the active Point
      if(not (pointid > 0 and pnextid > 0)) then return end
      local stSpawn = asmlib.GetNormalSpawn(oPly,trHit + elevpnt * stTrace.HitNormal,
                         aAng,model,pointid,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
      if(not stSpawn) then return end
      local Hp = stSpawn.HPnt:ToScreen()
      local Ob = hudMonitor:DrawUCS(oPly, stSpawn.BPos, stSpawn.BAng, "SURF", {sizeucs})
      local Os = hudMonitor:DrawUCS(oPly, stSpawn.OPos, stSpawn.OAng)
      hudMonitor:DrawLine(Ob,Tp,"y")
      hudMonitor:DrawCircle(Tp,nrad / 2)
      hudMonitor:DrawLine(Ob,Os)
      hudMonitor:DrawCircle(Os, asmlib.GetViewRadius(oPly, stSpawn.OPos, 0.5), "r")
      if(workmode == 1) then
        self:DrawNextPoint(hudMonitor, oPly, stSpawn)
      elseif(workmode == 2) then -- Draw point intersection
        self:DrawRelateIntersection(hudMonitor, oPly)
        self:DrawModelIntersection(hudMonitor, oPly, stSpawn)
      end
      local Ss = stSpawn.SPos:ToScreen()
      hudMonitor:DrawLine(Os,Ss,"m")
      hudMonitor:DrawCircle(Ss, asmlib.GetViewRadius(oPly, stSpawn.SPos),"c")
      if(not self:GetDeveloperMode()) then return end
      self:DrawTextSpawn(hudMonitor, "k","SURF",{"DebugSpawnTA"})
    end
  end
end

function TOOL:DrawToolScreen(w, h)
  if(SERVER) then return end
  if(not asmlib.IsInit()) then return end
  local scrTool = asmlib.MakeScreen(0,0,w,h,conPalette,"TOOL")
  if(not scrTool) then asmlib.LogInstance("Invalid screen",gtArgsLogs); return nil end
  local xyT, xyB = scrTool:GetCorners()
  scrTool:DrawRect(xyT,xyB,"k","SURF",{"vgui/white"})
  scrTool:SetTextEdge(xyT.x,xyT.y)
  local oPly = LocalPlayer()
  local stTrace = asmlib.GetCacheTrace(oPly)
  local anInfo, anEnt = self:GetAnchor()
  local tInfo = gsSymRev:Explode(anInfo)
  if(not (stTrace and stTrace.Hit)) then
    scrTool:DrawText("Trace status: Invalid","r","SURF",{"Trebuchet24"})
    scrTool:DrawTextAdd("  ["..(tInfo[1] or gsNoID).."]","an"); return nil
  end
  scrTool:DrawText("Trace status: Valid","g","SURF",{"Trebuchet24"})
  scrTool:DrawTextAdd("  ["..(tInfo[1] or gsNoID).."]","an")
  local model = self:GetModel()
  local hdRec = asmlib.CacheQueryPiece(model)
  if(not asmlib.IsHere(hdRec)) then
    scrTool:DrawText("Holds Model: Invalid","r")
    scrTool:DrawTextAdd("  ["..gsModeDataB.."]","db")
    return
  end
  scrTool:DrawText("Holds Model: Valid","g")
  scrTool:DrawTextAdd("  ["..gsModeDataB.."]","db")
  local trEnt    = stTrace.Entity
  local workmode = self:GetWorkingMode()
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
  scrTool:DrawText("CurAR: "..(trRLen or gsNoAV),"y")
  scrTool:DrawText("MaxCL: "..actrad.." < ["..maxrad.."]","c")
  local txX, txY, txW, txH, txsX, txsY = scrTool:GetTextState()
  local nRad = mathClamp(h - txH  - (txsY / 2),0,h) / 2
  local cPos = mathClamp(h - nRad - (txsY / 3),0,h)
  local xyPs = asmlib.NewXY(cPos, cPos)
  local workmode, workname = self:GetWorkingMode()
  scrTool:DrawCircle(xyPs, mathClamp(actrad/maxrad,0,1)*nRad, "c","SURF")
  scrTool:DrawCircle(xyPs, nRad, "m")
  scrTool:DrawText("Date: "..asmlib.GetDate(),"w")
  scrTool:DrawText("Time: "..asmlib.GetTime())
  if(trRLen) then scrTool:DrawCircle(xyPs, nRad * mathClamp(trRLen/maxrad,0,1),"y") end
  scrTool:DrawText("Work: ["..workmode.."] "..workname, "wm")
end

-- Enter `spawnmenu_reload` in the console to reload the panel
function TOOL.BuildCPanel(CPanel)
  CPanel:ClearControls(); CPanel:DockPadding(5, 0, 5, 10)
  local drmSkin, sLog = CPanel:GetSkin(), "*TOOL.BuildCPanel"
  local devmode = asmlib.GetAsmConvar("devmode", "BUL")
  local sCall, pItem, sName, aData = "_cpan" -- pItem is the current panel created
          CPanel:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".name"))
  pItem = CPanel:Help   (asmlib.GetPhrase("tool."..gsToolNameL..".desc"))

  local pComboPresets = vguiCreate("ControlPresets", CPanel)
        pComboPresets:SetPreset(gsToolNameL)
        pComboPresets:AddOption("Default", asmlib.GetOpVar("STORE_CONVARS"))
        for key, val in pairs(tableGetKeys(asmlib.GetOpVar("STORE_CONVARS"))) do
          pComboPresets:AddConVar(val) end
  CPanel:AddItem(pComboPresets)

  local cqPanel = asmlib.CacheQueryPanel(devmode); if(not cqPanel) then
    asmlib.LogInstance("Panel population empty",sLog); return nil end
  local makTab = asmlib.GetBuilderNick("PIECES"); if(not asmlib.IsHere(makTab)) then
    asmlib.LogInstance("Missing builder table",sLog); return nil end
  local defTable = makTab:GetDefinition()
  local catTypes = asmlib.GetOpVar("TABLE_CATEGORIES")
  local pTree    = vguiCreate("DTree", CPanel)
        pTree:SetTall(400)
        pTree:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".model"))
        pTree:SetIndentSize(0)
        pTree:UpdateColours(drmSkin)
  local iCnt, iTyp, pTypes, pCateg, pNode = 1, 1, {}, {}
  while(cqPanel[iCnt]) do
    local vRec, bNow = cqPanel[iCnt], true
    local sMod = vRec[makTab:GetColumnName(1)]
    local sTyp = vRec[makTab:GetColumnName(2)]
    local sNam = vRec[makTab:GetColumnName(3)]
    if(fileExists(sMod, "GAME")) then
      if(not (asmlib.IsBlank(sTyp) or pTypes[sTyp])) then
        local pRoot = pTree:AddNode(sTyp) -- No type folder made already
              pRoot:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".type"))
              pRoot.Icon:SetImage(asmlib.ToIcon(defTable.Name))
              pRoot.DoClick = function(pnSelf)
                if(inputIsKeyDown(KEY_LSHIFT)) then
                  pnSelf:ExpandRecurse(true)
                else pnSelf:SetExpanded(true) end
              end
              pRoot.DoRightClick = function()
                local ID = asmlib.WorkshopID(sTyp)
                if(ID and ID > 0 and inputIsKeyDown(KEY_LSHIFT)) then
                  guiOpenURL(asmlib.GetOpVar("FORM_URLADDON"):format(ID))
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
            if(not asmlib.IsTable(ptCat)) then ptCat = {ptCat} end
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
            end -- When the category has atleast one element
          else -- Store the creation information of the ones without category for later
            tableInsert(pCateg[sTyp], {sNam, sMod}); bNow = false
          end -- Is there is any category apply it
        end
      end
      -- Register the node associated with the track piece now when now intended for later
      if(bNow) then asmlib.SetDirectoryNode(pItem, sNam, sMod) end
      -- SnapReview is ignored because a query must be executed for points count
    else asmlib.LogInstance("Ignoring item "..asmlib.GetReport3(sTyp, sNam, sMod),sLog) end
    iCnt = iCnt + 1
  end
  -- Attach the uncategorized items to the type root
  for typ, val in pairs(pCateg) do
    for iD = 1, #val do
      local pan = pTypes[typ]
      local nam, mod = unpack(val[iD])
      asmlib.SetDirectoryNode(pan, nam, mod)
      asmlib.LogInstance("Rooting item "..asmlib.GetReport3(typ, nam, mod),sLog)
    end
  end -- Process all the items without category defined
  CPanel:AddItem(pTree)
  asmlib.LogInstance("Found items #"..tostring(iCnt-1),sLog)

  -- http://wiki.garrysmod.com/page/Category:DComboBox
  local sName = asmlib.GetAsmConvar("workmode", "NAM")
  local aData = asmlib.GetAsmConvar("workmode", "INT")
  local pComboToolMode = CPanel:ComboBox(asmlib.GetPhrase("tool."..gsToolNameL..".workmode_con"), sName)
        pComboToolMode:SetSortItems(false)
        pComboToolMode:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".workmode"))
        pComboToolMode.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
        for iD = 1, conWorkMode:GetSize() do
          local sW = tostring(conWorkMode:Select(iD) or gsNoAV):lower()
          local sI = asmlib.ToIcon("workmode_"..sW)
          local sT = asmlib.GetPhrase("tool."..gsToolNameL..".workmode_"..iD)
          pComboToolMode:AddChoice(sT, iD, (iD == aData), sI)
        end
  pComboToolMode:Dock(TOP) -- Setting tallness gets ingnored otherwise
  pComboToolMode:SetTall(20)

  local sName = asmlib.GetAsmConvar("physmater", "NAM")
  local pComboPhysType = CPanel:ComboBox(asmlib.GetPhrase("tool."..gsToolNameL..".phytype_con"))
        pComboPhysType:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".phytype"))
        pComboPhysType:SetValue(asmlib.GetPhrase("tool."..gsToolNameL..".phytype_def"))
        pComboPhysType.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
        pComboPhysType:Dock(TOP) -- Setting tallness gets ingnored otherwise
        pComboPhysType:SetTall(20)
  local pComboPhysName = CPanel:ComboBox(asmlib.GetPhrase("tool."..gsToolNameL..".phyname_con"), sName)
        pComboPhysName:SetTall(30)
        pComboPhysName:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".phyname"))
        pComboPhysName:SetValue(asmlib.GetTerm(asmlib.GetAsmConvar("physmater","STR"),
                                asmlib.GetPhrase("tool."..gsToolNameL..".phyname_def")))
        pComboPhysName.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
        pComboPhysName:Dock(TOP) -- Setting tallness gets ingnored otherwise
        pComboPhysName:SetTall(20)
  local cqProperty = asmlib.CacheQueryProperty(); if(not cqProperty) then
    asmlib.LogInstance("Property population empty",sLog); return nil end
  while(cqProperty[iTyp]) do
    local sT, sI = cqProperty[iTyp], asmlib.ToIcon("property_type")
    pComboPhysType:AddChoice(sT, sT, false, sI); iTyp = iTyp + 1
  end
  pComboPhysType.OnSelect = function(pnSelf, nInd, sVal, anyData)
    local cqNames = asmlib.CacheQueryProperty(sVal)
    if(cqNames) then local iNam = 1; pComboPhysName:Clear()
      pComboPhysName:SetValue(asmlib.GetPhrase("tool."..gsToolNameL..".phyname_def"))
      while(cqNames[iNam]) do
        local sN, sI = cqNames[iNam], asmlib.ToIcon("property_name")
        pComboPhysName:AddChoice(sN, sN, false, sI); iNam = iNam + 1
      end
    else asmlib.LogInstance("Property type <"..sVal.."> names mismatch",sLog) end
  end

  cvarsRemoveChangeCallback(sName, sName..sCall)
  cvarsAddChangeCallback(sName, function(sVar, vOld, vNew)
    pComboPhysName:SetValue(vNew) end, sName..sCall);
  asmlib.LogTable(cqProperty,"Property",sLog)

  -- http://wiki.garrysmod.com/page/Category:DTextEntry
  local sName = asmlib.GetAsmConvar("bgskids", "NAM")
  local pText = CPanel:TextEntry(asmlib.GetPhrase("tool."..gsToolNameL..".bgskids_con"), sName)
        pText:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".bgskids"))
        pText:SetText(asmlib.GetTerm(asmlib.GetAsmConvar("bgskids", "STR"),
                      asmlib.GetPhrase("tool."..gsToolNameL..".bgskids_def")))
        pText:SetEnabled(false); pText:SetTall(20)

  local sName = asmlib.GetAsmConvar("bgskids", "NAM")
  cvarsRemoveChangeCallback(sName, sName..sCall)
  cvarsAddChangeCallback(sName, function(sVar, vOld, vNew)
    pText:SetText(vNew); pText:SetValue(vNew) end, sName..sCall);

  local nMaxLin, iMaxDec = asmlib.GetAsmConvar("maxlinear","FLT"), asmlib.GetAsmConvar("maxmenupr","INT")
  pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".mass_con"), gsToolPrefL.."mass", 1, asmlib.GetAsmConvar("maxmass", "FLT")  , 0)
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".mass"))
  pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".activrad_con"), gsToolPrefL.."activrad", 0, asmlib.GetAsmConvar("maxactrad", "FLT"), iMaxDec)
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".activrad"))
  pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".stackcnt_con"), gsToolPrefL.."stackcnt", 0, asmlib.GetAsmConvar("maxstcnt", "INT"), 0)
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".stackcnt"))
  pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".angsnap_con"), gsToolPrefL.."angsnap", 0, gnMaxRot, iMaxDec)
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".angsnap"))
  pItem = CPanel:Button   (asmlib.GetPhrase ("tool."..gsToolNameL..".resetvars_con"), gsToolPrefL.."resetvars")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".resetvars"))
  asmlib.SetButtonSlider(CPanel,"nextpic","FLT",-gnMaxRot, gnMaxRot,iMaxDec,
    {{Text="+"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV, asmlib.GetAsmConvar("incsnpang","FLT"))) end},
     {Text="-"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV,-asmlib.GetAsmConvar("incsnpang","FLT"))) end},
     {Text="+/-" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,-vV) end},
     {Text="@90" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSign((vV < 0) and vV or (vV+1))* 90) end},
     {Text="@180", Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSign((vV < 0) and vV or (vV+1))*180) end},
     {Text="@M"  , Click=function(pBut, sNam, vV) SetClipboardText(vV) end},
     {Text="@0"  , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam, 0) end}})
  asmlib.SetButtonSlider(CPanel,"nextyaw","FLT",-gnMaxRot, gnMaxRot,iMaxDec,
    {{Text="+"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV, asmlib.GetAsmConvar("incsnpang","FLT"))) end},
     {Text="-"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV,-asmlib.GetAsmConvar("incsnpang","FLT"))) end},
     {Text="+/-" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,-vV) end},
     {Text="@90" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSign((vV < 0) and vV or (vV+1))* 90) end},
     {Text="@180", Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSign((vV < 0) and vV or (vV+1))*180) end},
     {Text="@M"  , Click=function(pBut, sNam, vV) SetClipboardText(vV) end},
     {Text="@0"  , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam, 0) end}})
  asmlib.SetButtonSlider(CPanel,"nextrol","FLT",-gnMaxRot, gnMaxRot,iMaxDec,
    {{Text="+"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV, asmlib.GetAsmConvar("incsnpang","FLT"))) end},
     {Text="-"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV,-asmlib.GetAsmConvar("incsnpang","FLT"))) end},
     {Text="+/-" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,-vV) end},
     {Text="@90" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSign((vV < 0) and vV or (vV+1))* 90) end},
     {Text="@180", Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSign((vV < 0) and vV or (vV+1))*180) end},
     {Text="@M"  , Click=function(pBut, sNam, vV) SetClipboardText(vV) end},
     {Text="@0"  , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam, 0) end}})
  asmlib.SetButtonSlider(CPanel,"nextx","FLT",-nMaxLin, nMaxLin,iMaxDec,
    {{Text="+"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV, asmlib.GetAsmConvar("incsnplin","FLT"))) end},
     {Text="-"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV,-asmlib.GetAsmConvar("incsnplin","FLT"))) end},
     {Text="+/-" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,-vV) end},
     {Text="@M"  , Click=function(pBut, sNam, vV) SetClipboardText(vV) end},
     {Text="@0"  , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam, 0) end}})
  asmlib.SetButtonSlider(CPanel,"nexty","FLT",-nMaxLin, nMaxLin,iMaxDec,
    {{Text="+"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV, asmlib.GetAsmConvar("incsnplin","FLT"))) end},
     {Text="-"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV,-asmlib.GetAsmConvar("incsnplin","FLT"))) end},
     {Text="+/-" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,-vV) end},
     {Text="@M"  , Click=function(pBut, sNam, vV) SetClipboardText(vV) end},
     {Text="@0"  , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam, 0) end}})
  asmlib.SetButtonSlider(CPanel,"nextz","FLT",-nMaxLin, nMaxLin,iMaxDec,
    {{Text="+"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV, asmlib.GetAsmConvar("incsnplin","FLT"))) end},
     {Text="-"   , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,asmlib.GetSnapInc(pBut,vV,-asmlib.GetAsmConvar("incsnplin","FLT"))) end},
     {Text="+/-" , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam,-vV) end},
     {Text="@M"  , Click=function(pBut, sNam, vV) SetClipboardText(vV) end},
     {Text="@0"  , Click=function(pBut, sNam, vV) asmlib.SetAsmConvar(nil,sNam, 0) end}})
  pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".forcelim_con"), gsToolPrefL.."forcelim", 0, asmlib.GetAsmConvar("maxforce" ,"FLT"), iMaxDec)
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".forcelim"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".weld_con"), gsToolPrefL.."weld")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".weld"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".nocollide_con"), gsToolPrefL.."nocollide")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".nocollide"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".nocollidew_con"), gsToolPrefL.."nocollidew")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".nocollidew"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".freeze_con"), gsToolPrefL.."freeze")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".freeze"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".ignphysgn_con"), gsToolPrefL.."ignphysgn")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".ignphysgn"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".gravity_con"), gsToolPrefL.."gravity")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".gravity"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".igntype_con"), gsToolPrefL.."igntype")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".igntype"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".spnflat_con"), gsToolPrefL.."spnflat")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".spnflat"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".spawncn_con"), gsToolPrefL.."spawncn")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".spawncn"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".surfsnap_con"), gsToolPrefL.."surfsnap")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".surfsnap"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".appangfst_con"), gsToolPrefL.."appangfst")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".appangfst"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".applinfst_con"), gsToolPrefL.."applinfst")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".applinfst"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".adviser_con"), gsToolPrefL.."adviser")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".adviser"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".pntasist_con"), gsToolPrefL.."pntasist")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pntasist"))
  pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".engunsnap_con"), gsToolPrefL.."engunsnap")
           pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".engunsnap"))
end

if(CLIENT) then
  -- Enter `spawnmenu_reload` in the console to reload the panel
  local function setupUserSettings(CPanel)
    local drmSkin, pItem, nLow, nHig = CPanel:GetSkin(); CPanel:ClearControls(); CPanel:DockPadding(5, 0, 5, 10)
    local iMaxDec, nMaxStk = asmlib.GetAsmConvar("maxmenupr","INT"), asmlib.GetAsmConvar("maxstcnt", "INT")
    CPanel:ControlHelp("Client side player preferences ( Convars created in the tool client configuration )")
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."sizeucs")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".sizeucs_con"), gsToolPrefL.."sizeucs", nLow, nHig, iMaxDec)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".sizeucs"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("sizeucs", "FLT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."incsnpang")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".incsnpang_con"), gsToolPrefL.."incsnpang", nLow, nHig, 0)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".incsnpang"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("incsnpang", "INT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."incsnplin")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".incsnplin_con"), gsToolPrefL.."incsnplin", nLow, nHig, 0)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".incsnplin"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("incsnplin", "INT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."ghostcnt")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".ghostcnt_con"), gsToolPrefL.."ghostcnt", nLow, nMaxStk, 0)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".ghostcnt"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("ghostcnt", "INT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."crvturnlm")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".crvturnlm_con"), gsToolPrefL.."crvturnlm", nLow, nHig, iMaxDec)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".crvturnlm"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("crvturnlm", "FLT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."crvleanlm")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".crvleanlm_con"), gsToolPrefL.."crvleanlm", nLow, nHig, iMaxDec)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".crvleanlm"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("crvleanlm", "FLT"))
    pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".enradmenu_con"), gsToolPrefL.."enradmenu")
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".enradmenu"))
    pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".enpntmscr_con"), gsToolPrefL.."enpntmscr")
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".enpntmscr"))
  end

  asmlib.DoAction("TWEAK_PANEL", "Utilities", "User", setupUserSettings)

  -- Enter `spawnmenu_reload` in the console to reload the panel
  local function setupAdminSettings(CPanel) local nLow, nHig = 0, 0
    local drmSkin, pItem = CPanel:GetSkin(); CPanel:ClearControls(); CPanel:DockPadding(5, 0, 5, 10)
    local nMaxLin, iMaxDec = asmlib.GetAsmConvar("maxlinear","FLT"), asmlib.GetAsmConvar("maxmenupr","INT")
    CPanel:ControlHelp("Non-replicated convar controls ( Different values on server and client )")
    pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".logfile_con"), gsToolPrefL.."logfile")
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".logfile"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."logsmax")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".logsmax_con"), gsToolPrefL.."logsmax", nLow, nHig, 0)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".logsmax"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("logsmax", "INT"))
    pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".devmode_con"), gsToolPrefL.."devmode")
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".devmode"))
    pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".exportdb_con"), gsToolPrefL.."exportdb")
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".exportdb"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."maxtrmarg")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".maxtrmarg_con"), gsToolPrefL.."maxtrmarg", nLow, nHig, iMaxDec)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".maxtrmarg"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("maxtrmarg", "FLT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."maxmenupr")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".maxmenupr_con"), gsToolPrefL.."maxmenupr", nLow, nHig, 0)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".maxmenupr"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("maxmenupr", "INT"))
    CPanel:ControlHelp("Replicated convar controls ( The server value is sent to all clients to be used )")
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."spawnrate")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".spawnrate_con"), gsToolPrefL.."spawnrate", nLow, nHig, 0)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".spawnrate"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("spawnrate", "INT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."maxmass")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".maxmass_con"), gsToolPrefL.."maxmass", nLow, nHig, iMaxDec)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".maxmass"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("maxmass", "FLT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."maxlinear")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".maxlinear_con"), gsToolPrefL.."maxlinear", nLow, nHig, iMaxDec)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".maxlinear"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("maxlinear", "FLT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."maxforce")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".maxforce_con"), gsToolPrefL.."maxforce", nLow, nHig, iMaxDec)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".maxforce"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("maxforce", "FLT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."maxactrad")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".maxactrad_con"), gsToolPrefL.."maxactrad", nLow, nHig, iMaxDec)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".maxactrad"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("maxactrad", "FLT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."maxstcnt")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".maxstcnt_con"), gsToolPrefL.."maxstcnt", nLow, nHig, 0)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".maxstcnt"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("maxstcnt", "INT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."maxstatts")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".maxstatts_con"), gsToolPrefL.."maxstatts", nLow, nHig, 0)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".maxstatts"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("maxstatts", "INT"))
    pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".enwiremod_con"), gsToolPrefL.."enwiremod")
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".enwiremod"))
    pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".enctxmenu_con"), gsToolPrefL.."enctxmenu")
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".enctxmenu"))
    pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".enctxmall_con"), gsToolPrefL.."enctxmall")
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".enctxmall"))
    pItem = CPanel:CheckBox (asmlib.GetPhrase ("tool."..gsToolNameL..".endsvlock_con"), gsToolPrefL.."endsvlock")
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".endsvlock"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."curvefact")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".curvefact_con"), gsToolPrefL.."curvefact", nLow, nHig, iMaxDec)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".curvefact"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("curvefact", "FLT"))
    nLow, nHig = asmlib.GetBorder(gsToolPrefL.."curvsmple")
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("tool."..gsToolNameL..".curvsmple_con"), gsToolPrefL.."curvsmple", nLow, nHig, 0)
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".curvsmple"))
             pItem:SetDefaultValue(asmlib.GetAsmConvar("curvsmple", "INT"))
    local sName, tSet = asmlib.GetAsmConvar("modedb", "NAM"), {"LUA", "SQL"}
    pItem = CPanel:ComboBox(asmlib.GetPhrase("tool."..gsToolNameL..".modedb_con"), sName)
    pItem:SetSortItems(false); pItem:Dock(TOP); pItem:SetTall(20)
    pItem:SetValue(asmlib.GetOpVar("MODE_DATABASE"))
    pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".modedb"))
    pItem.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
    pItem.OnSelect = function(pnSelf, nInd, sVal, anyData)
      asmlib.SetAsmConvar(nil, "modedb", anyData) end
    for iD = 1, #tSet do local sI = tSet[iD]
      local sIco = asmlib.ToIcon("database_mode_"..sI:lower())
      pItem:AddChoice(sI, sI, false, sIco)
    end
    local sName, tSet = asmlib.GetAsmConvar("bnderrmod", "NAM"), {"OFF", "LOG", "HINT", "GENERIC", "ERROR"}
    pItem = CPanel:ComboBox(asmlib.GetPhrase("tool."..gsToolNameL..".bnderrmod_con"), sName)
    pItem:SetSortItems(false); pItem:Dock(TOP); pItem:SetTall(20)
    pItem:SetValue(asmlib.GetAsmConvar("bnderrmod", "STR"))
    pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".bnderrmod"))
    pItem.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
    pItem.OnSelect = function(pnSelf, nInd, sVal, anyData)
      asmlib.SetAsmConvar(nil, "bnderrmod", anyData) end
    for iD = 1, #tSet do local sI = tSet[iD]
      local sIco = asmlib.ToIcon("bnderrmod_"..sI:lower())
      local sKey = ("tool."..gsToolNameL..".bnderrmod_"..sI:lower())
      pItem:AddChoice(asmlib.GetPhrase(sKey), sI, false, sIco)
    end
    pItem = CPanel:NumSlider(asmlib.GetPhrase ("sbox_max"..gsLimitName.."_con"), "sbox_max"..gsLimitName, 0, 3000, 0)
             pItem:SetTooltip(asmlib.GetPhrase("sbox_max"..gsLimitName))
    -- Setup the memory manager
    pItem = vguiCreate("DCategoryList", CPanel)
    pItem:Dock(TOP); pItem:SetTall(333)
    local tMod, tPan = {"CQT", "OBJ"}, {}
    local tVar = gsSymDir:Explode(asmlib.GetAsmConvar("timermode","STR"))
    local iD, mkTab, sRev = 1, asmlib.GetBuilderID(1), asmlib.GetOpVar("OPSYM_REVISION")
    while(mkTab) do tPan[iD] = {}; local vPan = tPan[iD]
      local tSet = sRev:Explode(tostring(tVar[iD] or ""))
      local pDef = mkTab:GetDefinition()
      local sMem = asmlib.GetPhrase("tool."..gsToolNameL..".timermode_mem")
      local pMem = pItem:Add(sMem.." "..pDef.Nick)
            pMem:SetTooltip(sMem.." "..pDef.Nick)
      vPan["MODE"] = vguiCreate("DComboBox", pItem); local pMode = vPan["MODE"]
      pMode:Dock(TOP); pMode:SetTall(25)
      pMode:UpdateColours(drmSkin)
      pMode:SetSortItems(false)
      pMode:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".timermode_md"))
      pMode.DoRightClick = function(pnSelf) asmlib.SetComboBoxClipboard(pnSelf) end
      for iK = 1, #tMod do local sK = tMod[iK]
        local sIco = asmlib.ToIcon("timermode_time")
        local sKey = ("tool."..gsToolNameL..".timermode_"..sK:lower())
        local bSel = (tostring(tSet[1]) == sK)
        pMode:AddChoice(asmlib.GetPhrase(sKey), sK, bSel, sIco)
      end
      vPan["LIFE"] = vguiCreate("DNumSlider", pItem); local pLife = vPan["LIFE"]
      pLife:SetMin(0); pLife:SetMax(3600)
      pLife:SetDecimals(iMaxDec)
      pLife:SetValue(tonumber(tSet[2]) or 0)
      pLife:SetDefaultValue(tonumber(tSet[2]) or 0)
      pLife:SizeToContents()
      pLife:SetText(asmlib.GetPhrase("tool."..gsToolNameL..".timermode_lf_con"))
      pLife:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".timermode_lf"))
      vPan["CLEAR"] = vguiCreate("DCheckBoxLabel", pItem); local pCler = vPan["CLEAR"]
      pCler:SetValue((tonumber(tSet[3]) or 0) ~= 0)
      pCler:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".timermode_rd"))
      pCler:SetText(asmlib.GetPhrase("tool."..gsToolNameL..".timermode_rd_con"))
      vPan["COLLECT"] = vguiCreate("DCheckBoxLabel", pItem); local pColl = vPan["COLLECT"]
      pColl:SetValue((tonumber(tSet[4]) or 0) ~= 0)
      pColl:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".timermode_ct"))
      pColl:SetText(asmlib.GetPhrase("tool."..gsToolNameL..".timermode_ct_con"))
      iD = (iD + 1); mkTab = asmlib.GetBuilderID(iD)
    end
    pItem:UpdateColours(drmSkin)
    pItem = CPanel:Button(asmlib.GetPhrase("tool."..gsToolNameL..".timermode_ap_con"))
             pItem:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".timermode_ap"))
    pItem.DoClick = function(pnSelf)
      if(inputIsKeyDown(KEY_LSHIFT)) then
        local fW = asmlib.GetOpVar("FORM_GITWIKI")
        guiOpenURL(fW:format("Memory-manager-configuration"))
      else
        local tTim, sRev = {}, asmlib.GetOpVar("OPSYM_REVISION")
        for iD = 1, #tPan do local vP, tS = tPan[iD], {}
          local pM, pL = vP["MODE" ], vP["LIFE"]
          local pC, bG = vP["CLEAR"], vP["COLLECT"]
          tS[1] = tostring(pM:GetOptionData(pM:GetSelectedID()) or "")
          tS[2] = tostring(tonumber(pL:GetValue() or 0))
          tS[3] = tostring(pC:GetValue() and 1 or 0)
          tS[4] = tostring(bG:GetValue() and 1 or 0)
          tTim[iD] = tableConcat(tS, sRev)
        end
        asmlib.SetAsmConvar(nil, "timermode", tableConcat(tTim, gsSymDir))
      end
    end
    pItem:Dock(TOP); pItem:SetTall(30)
  end

  asmlib.DoAction("TWEAK_PANEL", "Utilities", "Admin", setupAdminSettings)
end
