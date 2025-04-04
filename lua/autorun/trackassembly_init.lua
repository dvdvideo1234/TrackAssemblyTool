------------ LOCALIZNG FUNCTIONS ------------

local pcall                         = pcall
local Time                          = CurTime
local IsValid                       = IsValid
local tobool                        = tobool
local istable                       = istable
local isfunction                    = isfunction
local tonumber                      = tonumber
local tostring                      = tostring
local SetClipboardText              = SetClipboardText
local netStart                      = net and net.Start
local netSendToServer               = net and net.SendToServer
local netReceive                    = net and net.Receive
local netReadEntity                 = net and net.ReadEntity
local netReadVector                 = net and net.ReadVector
local netReadNormal                 = net and net.ReadNormal
local netReadAngle                  = net and net.ReadAngle
local netReadBool                   = net and net.ReadBool
local netReadUInt                   = net and net.ReadUInt
local netWriteEntity                = net and net.WriteEntity
local netWriteUInt                  = net and net.WriteUInt
local bitBor                        = bit and bit.bor
local sqlBegin                      = sql and sql.Begin
local sqlCommit                     = sql and sql.Commit
local guiMouseX                     = gui and gui.MouseX
local guiMouseY                     = gui and gui.MouseY
local guiOpenURL                    = gui and gui.OpenURL
local guiEnableScreenClicker        = gui and gui.EnableScreenClicker
local entsGetByIndex                = ents and ents.GetByIndex
local mathAtan2                     = math and math.atan2
local mathCeil                      = math and math.ceil
local mathFloor                     = math and math.floor
local mathClamp                     = math and math.Clamp
local mathMin                       = math and math.min
local mathMax                       = math and math.max
local mathNormalizeAngle            = math and math.NormalizeAngle
local gameGetWorld                  = game and game.GetWorld
local tableConcat                   = table and table.concat
local tableRemove                   = table and table.remove
local tableEmpty                    = table and table.Empty
local tableInsert                   = table and table.insert
local utilAddNetworkString          = util and util.AddNetworkString
local vguiCreate                    = vgui and vgui.Create
local fileExists                    = file and file.Exists
local fileFind                      = file and file.Find
local fileRead                      = file and file.Read
local fileWrite                     = file and file.Write
local fileDelete                    = file and file.Delete
local fileTime                      = file and file.Time
local fileSize                      = file and file.Size
local fileOpen                      = file and file.Open
local hookAdd                       = hook and hook.Add
local hookRemove                    = hook and hook.Remove
local timerSimple                   = timer and timer.Simple
local inputIsKeyDown                = input and input.IsKeyDown
local inputIsMouseDown              = input and input.IsMouseDown
local inputGetCursorPos             = input and input.GetCursorPos
local stringUpper                   = string and string.upper
local stringGetFileName             = string and string.GetFileFromFilename
local surfaceCreateFont             = surface and surface.CreateFont
local surfaceScreenWidth            = surface and surface.ScreenWidth
local surfaceScreenHeight           = surface and surface.ScreenHeight
local gamemodeCall                  = gamemode and gamemode.Call
local cvarsAddChangeCallback        = cvars and cvars.AddChangeCallback
local cvarsRemoveChangeCallback     = cvars and cvars.RemoveChangeCallback
local languageGetPhrase             = language and language.GetPhrase
local propertiesAdd                 = properties and properties.Add
local propertiesGetHovered          = properties and properties.GetHovered
local propertiesCanBeTargeted       = properties and properties.CanBeTargeted
local constraintFindConstraints     = constraint and constraint.FindConstraints
local constraintFind                = constraint and constraint.Find
local controlpanelGet               = controlpanel and controlpanel.Get
local spawnmenuAddToolMenuOption    = spawnmenu and spawnmenu.AddToolMenuOption

------------ INCLUDE LIBRARY ------------
if(SERVER) then
  AddCSLuaFile("trackassembly/trackasmlib.lua")
end
include("trackassembly/trackasmlib.lua")

------------ MODULE POINTER ------------

local asmlib = trackasmlib; if(not asmlib) then -- Module present
  ErrorNoHalt("INIT: Track assembly tool module fail"); return end

------------ CONFIGURE ASMLIB ------------

asmlib.InitBase("track","assembly")
asmlib.SetOpVar("TOOL_VERSION","9.780")

------------ CONFIGURE GLOBAL INIT OPVARS ------------

local gtInitLogs  = asmlib.GetOpVar("LOG_INIT")
local gvVecZero   = asmlib.GetOpVar("VEC_ZERO")
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVISION")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gnRatio     = asmlib.GetOpVar("GOLDEN_RATIO")
local gnMaxRot    = asmlib.GetOpVar("MAX_ROTATION")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsToolPrefU = asmlib.GetOpVar("TOOLNAME_PU")
local gsGenerPrf  = asmlib.GetOpVar("DBEXP_PREFGEN")
local gsLimitName = asmlib.GetOpVar("CVAR_LIMITNAME")
local gsDirDSV    = asmlib.GetOpVar("DIRPATH_BAS")..asmlib.GetOpVar("DIRPATH_DSV")
local gsNoAnchor  = asmlib.GetOpVar("MISS_NOID")..gsSymRev..asmlib.GetOpVar("MISS_NOMD")
local gsGenerDSV  = gsDirDSV..gsGenerPrf..gsToolPrefU

------------ VARIABLE FLAGS ------------

local varLanguage = GetConVar("gmod_language")
-- Client and server have independent value
local gnIndependentUsed = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
-- Server tells the client what value to use
local gnServerControled = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY, FCVAR_REPLICATED)

------------ BORDERS ------------

asmlib.SetBorder("non-neg", 0)
asmlib.SetBorder("sbox_max"..gsLimitName , 0)
asmlib.SetBorder(gsToolPrefL.."crvturnlm", 0, 1)
asmlib.SetBorder(gsToolPrefL.."crvleanlm", 0, 1)
asmlib.SetBorder(gsToolPrefL.."curvefact", 0, 1)
asmlib.SetBorder(gsToolPrefL.."curvsmple", 0)
asmlib.SetBorder(gsToolPrefL.."devmode"  , 0, 1)
asmlib.SetBorder(gsToolPrefL.."enctxmall", 0, 1)
asmlib.SetBorder(gsToolPrefL.."enctxmenu", 0, 1)
asmlib.SetBorder(gsToolPrefL.."endsvlock", 0, 1)
asmlib.SetBorder(gsToolPrefL.."enwiremod", 0, 1)
asmlib.SetBorder(gsToolPrefL.."enmultask", 0, 1)
asmlib.SetBorder(gsToolPrefL.."ghostcnt" , 0)
asmlib.SetBorder(gsToolPrefL.."angsnap"  , 0, gnMaxRot)
asmlib.SetBorder(gsToolPrefL.."incsnpang", 0, gnMaxRot)
asmlib.SetBorder(gsToolPrefL.."incsnplin", 0, 250)
asmlib.SetBorder(gsToolPrefL.."logfile"  , 0, 1)
asmlib.SetBorder(gsToolPrefL.."logsmax"  , 0, 100000)
asmlib.SetBorder(gsToolPrefL.."maxactrad", 1, 400)
asmlib.SetBorder(gsToolPrefL.."maxforce" , 0, 200000)
asmlib.SetBorder(gsToolPrefL.."maxfruse" , 1, 150)
asmlib.SetBorder(gsToolPrefL.."maxlinear", 0)
asmlib.SetBorder(gsToolPrefL.."maxmass"  , 1)
asmlib.SetBorder(gsToolPrefL.."maxmenupr", 0, 10)
asmlib.SetBorder(gsToolPrefL.."maxstatts", 1, 10)
asmlib.SetBorder(gsToolPrefL.."maxstcnt" , 1)
asmlib.SetBorder(gsToolPrefL.."maxghcnt" , 1)
asmlib.SetBorder(gsToolPrefL.."maxtrmarg", 0, 1)
asmlib.SetBorder(gsToolPrefL.."maxspmarg", -100, 100)
asmlib.SetBorder(gsToolPrefL.."sizeucs"  , 0, 50)
asmlib.SetBorder(gsToolPrefL.."spawnrate", 1, 10)
asmlib.SetBorder(gsToolPrefL.."sgradmenu", 1, 16)
asmlib.SetBorder(gsToolPrefL.."dtmessage", 0, 10)
asmlib.SetBorder(gsToolPrefL.."ghostblnd", 0, 1)
asmlib.SetBorder(gsToolPrefL.."crvsuprev", -2, 2)
asmlib.SetBorder(gsToolPrefL.."rtradmenu", -gnMaxRot, gnMaxRot)

------------ CONFIGURE LOGGING ------------

asmlib.SetOpVar("LOG_DEBUGEN",false)
asmlib.NewAsmConvar("logsmax", 0, nil, gnIndependentUsed, "Maximum logging lines being written")
asmlib.NewAsmConvar("logfile", 0, nil, gnIndependentUsed, "File logging output flag control")
asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"), asmlib.GetAsmConvar("logfile","BUL"))
asmlib.SettingsLogs("SKIP"); asmlib.SettingsLogs("ONLY")

------------ CONFIGURE NON-REPLICATED CVARS ------------ Client's got a mind of its own

asmlib.NewAsmConvar("modedb"   , "LUA", nil, gnIndependentUsed, "Database storage operating mode LUA or SQL")
asmlib.NewAsmConvar("devmode"  ,    0 , nil, gnIndependentUsed, "Toggle developer mode on/off server side")
asmlib.NewAsmConvar("maxtrmarg", 0.02 , nil, gnIndependentUsed, "Maximum time to avoid performing new traces")
asmlib.NewAsmConvar("maxmenupr",    5 , nil, gnIndependentUsed, "Maximum decimal places utilized in the control panel")
asmlib.NewAsmConvar("timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1", nil, gnIndependentUsed, "Memory management setting when DB mode is SQL")

------------ CONFIGURE REPLICATED CVARS ------------ Server tells the client what value to use

asmlib.NewAsmConvar("maxmass"  , 50000 , nil, gnServerControled, "Maximum mass that can be applied on a piece")
asmlib.NewAsmConvar("maxlinear", 5000  , nil, gnServerControled, "Maximum linear offset of the piece")
asmlib.NewAsmConvar("maxforce" , 100000, nil, gnServerControled, "Maximum force limit when creating welds")
asmlib.NewAsmConvar("maxactrad", 200   , nil, gnServerControled, "Maximum active radius to search for a point ID")
asmlib.NewAsmConvar("maxstcnt" , 200   , nil, gnServerControled, "Maximum spawned pieces in stacking mode")
asmlib.NewAsmConvar("maxghcnt" , 1500  , nil, gnServerControled, "Maximum ghost pieces being spawned by client")
asmlib.NewAsmConvar("enwiremod", 1     , nil, gnServerControled, "Toggle the wire extension on/off server side")
asmlib.NewAsmConvar("enmultask", 1     , nil, gnServerControled, "Toggle the spawn multitasking on/off server side")
asmlib.NewAsmConvar("enctxmenu", 1     , nil, gnServerControled, "Toggle the context menu on/off in general")
asmlib.NewAsmConvar("enctxmall", 0     , nil, gnServerControled, "Toggle the context menu on/off for all props")
asmlib.NewAsmConvar("endsvlock", 0     , nil, gnServerControled, "Toggle the DSV external database file update on/off")
asmlib.NewAsmConvar("curvefact", 0.5   , nil, gnServerControled, "Parametric constant track curving factor")
asmlib.NewAsmConvar("curvsmple", 50    , nil, gnServerControled, "Amount of samples between two curve nodes")
asmlib.NewAsmConvar("spawnrate",  1    , nil, gnServerControled, "Maximum pieces spawned in every think tick")
asmlib.NewAsmConvar("bnderrmod","LOG"  , nil, gnServerControled, "Unreasonable position error handling mode")
asmlib.NewAsmConvar("maxfruse" ,  50   , nil, gnServerControled, "Maximum frequent pieces to be listed")
asmlib.NewAsmConvar("maxspmarg",  0    , nil, gnServerControled, "Maximum spawn distance new piece created margin")
asmlib.NewAsmConvar("dtmessage",  1    , nil, gnServerControled, "Time interval for server addressed messages")
asmlib.NewAsmConvar("*sbox_max"..gsLimitName, 1500, nil, gnServerControled, "Maximum number of tracks to be spawned")

------------ CONFIGURE INTERNALS ------------

asmlib.IsFlag("new_close_frame", false) -- The old state for frame shortcut detecting a pulse
asmlib.IsFlag("old_close_frame", false) -- The new state for frame shortcut detecting a pulse
asmlib.IsFlag("tg_context_menu", false) -- Raises whenever the user opens the game context menu
asmlib.IsFlag("en_dsv_datalock", asmlib.GetAsmConvar("endsvlock", "BUL"))
asmlib.SetOpVar("MODE_DATABASE", asmlib.GetAsmConvar("modedb"   , "STR"))
asmlib.SetOpVar("TRACE_MARGIN" , asmlib.GetAsmConvar("maxtrmarg", "FLT"))
asmlib.SetOpVar("SPAWN_MARGIN" , asmlib.GetAsmConvar("maxspmarg", "FLT"))
asmlib.SetOpVar("MSDELTA_SEND" , asmlib.GetAsmConvar("dtmessage", "FLT"))

------------ GLOBAL VARIABLES ------------

local gsMoDB     = asmlib.GetOpVar("MODE_DATABASE")
local gaTimerSet = gsSymDir:Explode(asmlib.GetAsmConvar("timermode","STR"))
local conPalette = asmlib.GetContainer("COLORS_LIST")
      conPalette:Record("a" ,asmlib.GetColor(  0,   0,   0,   0)) -- Invisible
      conPalette:Record("r" ,asmlib.GetColor(255,   0,   0, 255)) -- Red
      conPalette:Record("g" ,asmlib.GetColor(  0, 255,   0, 255)) -- Green
      conPalette:Record("b" ,asmlib.GetColor(  0,   0, 255, 255)) -- Blue
      conPalette:Record("c" ,asmlib.GetColor(  0, 255, 255, 255)) -- Cyan
      conPalette:Record("m" ,asmlib.GetColor(255,   0, 255, 255)) -- Magenta
      conPalette:Record("y" ,asmlib.GetColor(255, 255,   0, 255)) -- Yellow
      conPalette:Record("w" ,asmlib.GetColor(255, 255, 255, 255)) -- White
      conPalette:Record("k" ,asmlib.GetColor(  0,   0,   0, 255)) -- Black
      conPalette:Record("gh",asmlib.GetColor(255, 255, 255, 150)) -- Ghosts base color
      conPalette:Record("tx",asmlib.GetColor( 80,  80,  80, 255)) -- Panel names text color
      conPalette:Record("an",asmlib.GetColor(180, 255, 150, 255)) -- Selected anchor
      conPalette:Record("db",asmlib.GetColor(220, 164,  52, 255)) -- Database mode
      conPalette:Record("ry",asmlib.GetColor(230, 200,  80, 255)) -- Ray tracing
      conPalette:Record("wm",asmlib.GetColor(143, 244,  66, 255)) -- Working mode HUD
      conPalette:Record("bx",asmlib.GetColor(250, 250, 200, 255)) -- Radial menu box
      conPalette:Record("fo",asmlib.GetColor(147,  92, 204, 255)) -- Flip over rails
      conPalette:Record("pf",asmlib.GetColor(150, 255, 150, 240)) -- Progress bar foreground
      conPalette:Record("pb",asmlib.GetColor(150, 150, 255, 190)) -- Progress bar background

local conElements = asmlib.GetContainer("LIST_VGUI")
local conWorkMode = asmlib.GetContainer("WORK_MODE")
      conWorkMode:Push("SNAP" ) -- General spawning and snapping mode
      conWorkMode:Push("CROSS") -- Ray cross intersect interpolation
      conWorkMode:Push("CURVE") -- Catmull-Rom spline interpolation fitting
      conWorkMode:Push("OVER" ) -- Trace normal ray location piece flip-snap
      conWorkMode:Push("TURN" ) -- Produces smoother turns with Bezier curve

------------ CALLBACKS ------------

local conCallBack = asmlib.GetContainer("CALLBAC_FUNC")
      conCallBack:Push({"maxtrmarg", function(sV, vO, vN)
        local nM = (tonumber(vN) or 0); nM = ((nM > 0) and nM or 0)
        asmlib.SetOpVar("TRACE_MARGIN", nM)
      end})
      conCallBack:Push({"maxspmarg", function(sV, vO, vN)
        local nM = (tonumber(vN) or 0)
        asmlib.SetOpVar("SPAWN_MARGIN", nM)
      end})
      conCallBack:Push({"logsmax", function(sV, vO, vN)
        local nM = asmlib.BorderValue((tonumber(vN) or 0), "non-neg")
        asmlib.SetOpVar("LOG_MAXLOGS", nM)
      end})
      conCallBack:Push({"logfile", function(sV, vO, vN)
        asmlib.IsFlag("en_logging_file", tobool(vN))
      end})
      conCallBack:Push({"endsvlock", function(sV, vO, vN)
        asmlib.IsFlag("en_dsv_datalock", tobool(vN))
      end})
      conCallBack:Push({"timermode", function(sV, vO, vN)
        local arTim = gsSymDir:Explode(vN)
        local mkTab, ID = asmlib.GetBuilderID(1), 1
        while(mkTab) do local sTim = arTim[ID]
          local defTab = mkTab:GetDefinition(); mkTab:TimerSetup(sTim)
          asmlib.LogInstance("Timer apply "..asmlib.GetReport(defTab.Nick,sTim),gtInitLogs)
          ID = ID + 1; mkTab = asmlib.GetBuilderID(ID) -- Next table on the list
        end; asmlib.LogInstance("Timer update "..asmlib.GetReport(vN),gtInitLogs)
      end})
      conCallBack:Push({"dtmessage", function(sV, vO, vN)
        if(SERVER) then
          local sK = gsToolPrefL.."dtmessage"
          local nD = (tonumber(vN) or 0)
                nD = asmlib.BorderValue(nD, sK)
          asmlib.SetOpVar("MSDELTA_SEND", nD)
        end
      end})

for iD = 1, conCallBack:GetSize() do
  local val = conCallBack:Select(iD)
  local nam = asmlib.GetAsmConvar(val[1], "NAM")
  cvarsRemoveChangeCallback(nam, nam.."_init")
  cvarsAddChangeCallback(nam, val[2], nam.."_init")
end

------------ RECORDS ------------

asmlib.SetOpVar("STRUCT_SPAWN",{
  Name = "Spawn data definition",
  Draw = {
    ["RDB"] = function(scr, key, typ, inf, def, spn)
      local rec, fmt = spn[key], asmlib.GetOpVar("FORM_DRAWDBG")
      local fky, nav = asmlib.GetOpVar("FORM_DRWSPKY"), asmlib.GetOpVar("MISS_NOAV")
      local out = (rec and tostring(stringGetFileName(rec.Slot)) or nav)
      scr:DrawText(fmt:format(fky:format(key), typ, out, inf))
    end,
    ["MTX"] = function(scr, key, typ, inf, def, spn)
      local tab = spn[key]:ToTable()
      local fmt = asmlib.GetOpVar("FORM_DRAWDBG")
      local fky = asmlib.GetOpVar("FORM_DRWSPKY")
      for iR = 1, 4 do
        local out = asmlib.GetReport(iR,tableConcat(tab[iR], ","))
        scr:DrawText(fmt:format(fky:format(key), typ, out, inf))
      end
    end,
  },
  {Name = "Origin",
    {"BPos", "VEC", "Base coordinate position"},
    {"BAng", "ANG", "Base coordinate angle"},
    {"OPos", "VEC", "Origin position"},
    {"OAng", "ANG", "Origin angle"},
    {"SPos", "VEC", "Piece spawn position"},
    {"SAng", "ANG", "Piece spawn angle"},
    {"SMtx", "MTX", "Spawn translation and rotation matrix"},
    {"RLen", "NUM", "Piece active radius"}
  },
  {Name = "Holder",
    {"HRec", "RDB", "Pointer to the holder record"},
    {"HID" , "NUM", "Point ID the holder has selected"},
    {"HPnt", "VEC", "P # Holder active point location"},
    {"HOrg", "VEC", "O # Holder piece location origin when snapped"},
    {"HAng", "ANG", "A # Holder piece orientation origin when snapped"},
    {"HMtx", "MTX", "Holder translation and rotation matrix"}
  },
  {Name = "Traced",
    {"TRec", "RDB", "Pointer to the trace record"},
    {"TID" , "NUM", "Point ID that the trace has found"},
    {"TPnt", "VEC", "P # Trace active point location"},
    {"TOrg", "VEC", "O # Trace piece location origin when snapped"},
    {"TAng", "ANG", "A # Trace piece orientation origin when snapped"},
    {"TMtx", "MTX", "Trace translation and rotation matrix"}
  },
  {Name = "Offsets",
    {"ANxt", "ANG", "Origin angle offsets"},
    {"PNxt", "VEC", "Piece position offsets"}
  }
})

------------ ACTIONS ------------

if(SERVER) then

  utilAddNetworkString(gsLibName.."SendDeleteGhosts")
  utilAddNetworkString(gsLibName.."SendIntersectClear")
  utilAddNetworkString(gsLibName.."SendIntersectRelate")
  utilAddNetworkString(gsLibName.."SendCreateCurveNode")
  utilAddNetworkString(gsLibName.."SendUpdateCurveNode")
  utilAddNetworkString(gsLibName.."SendDeleteCurveNode")
  utilAddNetworkString(gsLibName.."SendDeleteAllCurveNode")

  asmlib.SetAction("DUPE_PHYS_SETTINGS", -- Duplicator wrapper
    function(oPly,oEnt,tData) local sLog = "*DUPE_PHYS_SETTINGS"
      if(not asmlib.ApplyPhysicalSettings(oEnt,tData[1],tData[2],tData[3],tData[4])) then
        asmlib.LogInstance("Failed to apply physical settings on "..tostring(oEnt),sLog); return nil end
      asmlib.LogInstance("Success",sLog); return nil
    end)

  asmlib.SetAction("PLAYER_QUIT",
    function(oPly) local sLog = "*PLAYER_QUIT" -- Clear player cache when disconnects
      if(not asmlib.CacheClear(oPly)) then
        asmlib.LogInstance("Failed swiping stuff "..tostring(oPly),sLog); return nil end
      asmlib.LogInstance("Success",sLog); return nil
    end)

  asmlib.SetAction("PHYSGUN_DROP",
    function(pPly, trEnt) local sLog = "*PHYSGUN_DROP"
      if(not asmlib.IsPlayer(pPly)) then
        asmlib.LogInstance("Player invalid",sLog); return nil end
      if(pPly:GetInfoNum(gsToolPrefL.."engunsnap", 0) == 0) then
        asmlib.LogInstance("Snapping disabled",sLog); return nil end
      if(not (trEnt and trEnt:IsValid())) then
        asmlib.LogInstance("Trace entity invalid",sLog); return nil end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel()); if(not trRec) then
        asmlib.LogInstance("Trace not piece",sLog); return nil end
      local maxlinear  = asmlib.GetAsmConvar("maxlinear","FLT")
      local bnderrmod  = asmlib.GetAsmConvar("bnderrmod","STR")
      local ignphysgn  = (pPly:GetInfoNum(gsToolPrefL.."ignphysgn" , 0) ~= 0)
      local freeze     = (pPly:GetInfoNum(gsToolPrefL.."freeze"    , 0) ~= 0)
      local gravity    = (pPly:GetInfoNum(gsToolPrefL.."gravity"   , 0) ~= 0)
      local weld       = (pPly:GetInfoNum(gsToolPrefL.."weld"      , 0) ~= 0)
      local nocollide  = (pPly:GetInfoNum(gsToolPrefL.."nocollide" , 0) ~= 0)
      local nocollidew = (pPly:GetInfoNum(gsToolPrefL.."nocollidew", 0) ~= 0)
      local spnflat    = (pPly:GetInfoNum(gsToolPrefL.."spnflat"   , 0) ~= 0)
      local igntype    = (pPly:GetInfoNum(gsToolPrefL.."igntype"   , 0) ~= 0)
      local physmater  = (pPly:GetInfo   (gsToolPrefL.."physmater" , "metal"))
      local nextx      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextx"   , 0),-maxlinear, maxlinear)
      local nexty      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nexty"   , 0),-maxlinear, maxlinear)
      local nextz      = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextz"   , 0),-maxlinear, maxlinear)
      local nextpic    = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextpic" , 0),-gnMaxRot, gnMaxRot)
      local nextyaw    = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextyaw" , 0),-gnMaxRot, gnMaxRot)
      local nextrol    = mathClamp(pPly:GetInfoNum(gsToolPrefL.."nextrol" , 0),-gnMaxRot, gnMaxRot)
      local forcelim   = mathClamp(pPly:GetInfoNum(gsToolPrefL.."forcelim", 0),0,asmlib.GetAsmConvar("maxforce" , "FLT"))
      local activrad   = mathClamp(pPly:GetInfoNum(gsToolPrefL.."activrad", 0),0,asmlib.GetAsmConvar("maxactrad", "FLT"))
      local trPos, trAng, trRad, trID, trTr = trEnt:GetPos(), trEnt:GetAngles(), activrad, 0
      for ID = 1, trRec.Size, 1 do -- Hits distance shorter than the active radius
        local oTr, oDt = asmlib.GetTraceEntityPoint(trEnt, ID, activrad)
        local rTr = (activrad * oTr.Fraction) -- Estimate active fraction length
        if(oTr and oTr.Hit and (rTr < trRad)) then local eTr = oTr.Entity
          if(eTr and eTr:IsValid()) then trRad, trID, trTr = rTr, ID, oTr end
        end
      end -- The trace with the shortest distance is found
      if(trTr and trTr.Hit and (trID > 0) and (trID <= trRec.Size)) then
        local stSpawn = asmlib.GetEntitySpawn(pPly,trTr.Entity,trTr.HitPos,trRec.Slot,trID,
                          activrad,spnflat,igntype,nextx,nexty,nextz,nextpic,nextyaw,nextrol)
        if(stSpawn) then
          if(not asmlib.SetPosBound(trEnt, stSpawn.SPos, pPly, bnderrmod)) then
            asmlib.LogInstance("User "..pPly:Nick().." snapped <"..trRec.Slot.."> outside bounds",sLog); return nil end
          trEnt:SetAngles(stSpawn.SAng)
          if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
            asmlib.LogInstance("Failed to apply physical settings",sLog); return nil end
          if(not asmlib.ApplyPhysicalAnchor(trEnt,trTr.Entity,weld,nocollide,nocollidew,forcelim)) then
            asmlib.LogInstance("Failed to apply physical anchor",sLog); return nil end
        end
      end
    end)
end

if(CLIENT) then

  surfaceCreateFont("DebugSpawnTA",{
    font = "Courier New", size = 14,
    weight = 600
  })

  -- Listen for changes of the language and reload the tool's menu to update the localizations
  cvarsRemoveChangeCallback(varLanguage:GetName(), gsToolPrefL.."lang")
  cvarsAddChangeCallback(varLanguage:GetName(), function(sNam, vO, vN)
    local sLog, bS, vOut, fUser, fAdmn = "*UPDATE_CONTROL_PANEL("..vO.."/"..vN..")"
    local oTool = asmlib.GetOpVar("STORE_TOOLOBJ"); if(not asmlib.IsHere(oTool)) then
      asmlib.LogInstance("Tool object missing", sLog); return end
    -- Retrieve the control panel from the tool main tab
    local fCont = oTool.BuildCPanel -- Function to populate the tool
    local pCont = controlpanelGet(gsToolNameL); if(not IsValid(pCont)) then
      asmlib.LogInstance("Control invalid", sLog); return end
    -- Retrieve the utilities user preferences panel
    bS, vOut = asmlib.DoAction("TWEAK_PANEL", "Utilities", "User"); if(not bS) then
      asmlib.LogInstance("User miss: "..vOut, sLog); return end; fUser = vOut
    local pUser = controlpanelGet(gsToolNameL.."_utilities_user"); if(not IsValid(pUser)) then
      asmlib.LogInstance("User invalid", sLog); return end
    -- Retrieve the utilities admin preferences panel
    bS, vOut = asmlib.DoAction("TWEAK_PANEL", "Utilities", "Admin"); if(not bS) then
      asmlib.LogInstance("Admin miss: "..vOut, sLog); return end; fAdmn = vOut
    local pAdmn = controlpanelGet(gsToolNameL.."_utilities_admin"); if(not IsValid(pAdmn)) then
      asmlib.LogInstance("Admin invalid", sLog); return end
    -- Wipe the panel so it is clear of contents sliders buttons and stuff
    pCont:ClearControls(); pUser:ClearControls(); pAdmn:ClearControls()
    -- Panels are cleared and we change the language utilizing localify
    bS, vOut = pcall(fCont, pCont) if(not bS) then
      asmlib.LogInstance("Control fail: "..vOut, sLog); return
    else asmlib.LogInstance("Control: "..asmlib.GetReport(pCont.Name), sLog) end
    bS, vOut = pcall(fUser, pUser) if(not bS) then
      asmlib.LogInstance("User fail: "..vOut, sLog); return
    else asmlib.LogInstance("User: "..asmlib.GetReport(pUser.Name), sLog) end
    bS, vOut = pcall(fAdmn, pAdmn) if(not bS) then
      asmlib.LogInstance("Admin fail: "..vOut, sLog); return
    else asmlib.LogInstance("Admin: "..asmlib.GetReport(pAdmn.Name), sLog) end
  end, gsToolPrefL.."lang")

  -- https://wiki.facepunch.com/gmod/Silkicons
  asmlib.ToIcon(gsToolPrefU.."PIECES"        , "database_connect")
  asmlib.ToIcon(gsToolPrefU.."ADDITIONS"     , "bricks"          )
  asmlib.ToIcon(gsToolPrefU.."PHYSPROPERTIES", "wand"            )
  asmlib.ToIcon(gsToolPrefL.."context_menu"  , "database_gear"   )
  asmlib.ToIcon("subfolder_item"        , "folder_brick"      )
  asmlib.ToIcon("pn_contextm_cp"        , "page_copy"         )
  asmlib.ToIcon("pn_contextm_cpbx"      , "application_go"    )
  asmlib.ToIcon("pn_contextm_cprw"      , "report_go"         )
  asmlib.ToIcon("pn_contextm_cpty"      , "database_go"       )
  asmlib.ToIcon("pn_contextm_cpnm"      , "script_go"         )
  asmlib.ToIcon("pn_contextm_cpth"      , "map_go"            )
  asmlib.ToIcon("pn_contextm_cpmd"      , "brick_go"          )
  asmlib.ToIcon("pn_contextm_li"        , "database"          )
  asmlib.ToIcon("pn_contextm_licg"      , "database_edit"     )
  asmlib.ToIcon("pn_contextm_licr"      , "database_add"      )
  asmlib.ToIcon("pn_contextm_lirm"      , "database_delete"   )
  asmlib.ToIcon("pn_contextm_ws"        , "cart"              )
  asmlib.ToIcon("pn_contextm_wsid"      , "key_go"            )
  asmlib.ToIcon("pn_contextm_wsop"      , "world"             )
  asmlib.ToIcon("pn_contextm_ex"        , "transmit"          )
  asmlib.ToIcon("pn_contextm_exdv"      , "database_table"    )
  asmlib.ToIcon("pn_contextm_exru"      , "script_code"       )
  asmlib.ToIcon("pn_contextm_mv"        , "joystick"          )
  asmlib.ToIcon("pn_contextm_mvup"      , "arrow_up"          )
  asmlib.ToIcon("pn_contextm_mvdn"      , "arrow_down"        )
  asmlib.ToIcon("pn_contextm_mvtp"      , "arrow_redo"        )
  asmlib.ToIcon("pn_contextm_mvbt"      , "arrow_undo"        )
  asmlib.ToIcon("pn_contextm_st"        , "database_gear"     )
  asmlib.ToIcon("pn_contextm_si"        , "database_key"      )
  asmlib.ToIcon("pn_contextm_stnk"      , "folder_find"       )
  asmlib.ToIcon("pn_contextm_stpt"      , "map_go"            )
  asmlib.ToIcon("pn_contextm_sttm"      , "time_go"           )
  asmlib.ToIcon("pn_contextm_stsz"      , "compress"          )
  asmlib.ToIcon("pn_contextm_sted"      , "table_edit"        )
  asmlib.ToIcon("pn_contextm_stdl"      , "table_delete"      )
  asmlib.ToIcon("pn_contextm_tg"        , "database_connect"  )
  asmlib.ToIcon("pn_contextm_ep"        , "zoom"              )
  asmlib.ToIcon("pn_routine_end"   , "arrow_refresh"     )
  asmlib.ToIcon("pn_routine_typ"   , "package"           )
  asmlib.ToIcon("pn_routine_nam"   , "tag_green"         )
  asmlib.ToIcon("pn_routine_mod"   , "brick"             )
  asmlib.ToIcon("model"            , "brick"             )
  asmlib.ToIcon("mass"             , "basket_put"        )
  asmlib.ToIcon("bgskids"          , "layers"            )
  asmlib.ToIcon("phyname"          , "wand"              )
  asmlib.ToIcon("ignphysgn"        , "lightning_go"      )
  asmlib.ToIcon("freeze"           , "lock"              )
  asmlib.ToIcon("gravity"          , "ruby_put"          )
  asmlib.ToIcon("weld"             , "wrench"            )
  asmlib.ToIcon("nocollide"        , "shape_group"       )
  asmlib.ToIcon("nocollidew"       , "world_go"          )
  asmlib.ToIcon("workmode_snap"    , "plugin"            ) -- General spawning and snapping mode
  asmlib.ToIcon("workmode_cross"   , "chart_line"        ) -- Ray cross intersect interpolation
  asmlib.ToIcon("workmode_curve"   , "vector"            ) -- Catmull-Rom curve line segment fitting
  asmlib.ToIcon("workmode_over"    , "shape_move_back"   ) -- Trace normal ray location piece flip-spawn
  asmlib.ToIcon("workmode_turn"    , "arrow_turn_right"  ) -- Produces smoother turns with Bezier curve
  asmlib.ToIcon("property_type"    , "package_green"     )
  asmlib.ToIcon("property_name"    , "note"              )
  asmlib.ToIcon("modedb_lua"       , "database_lightning")
  asmlib.ToIcon("modedb_sql"       , "database_link"     )
  asmlib.ToIcon("timermode_cqt"    , "time_go"           )
  asmlib.ToIcon("timermode_obj"    , "clock_go"          )
  asmlib.ToIcon("bnderrmod_off"    , "shape_square"      )
  asmlib.ToIcon("bnderrmod_log"    , "shape_square_edit" )
  asmlib.ToIcon("bnderrmod_hint"   , "shape_square_go"   )
  asmlib.ToIcon("bnderrmod_generic", "shape_square_link" )
  asmlib.ToIcon("bnderrmod_error"  , "shape_square_error")

  -- Workshop matching crap
  asmlib.WorkshopID("SligWolf's Rerailer"         , "132843280")
  asmlib.WorkshopID("SligWolf's Mini Trains"      , "149759773")
  asmlib.WorkshopID("SProps"                      , "173482196")
  asmlib.WorkshopID("Magnum's Rails"              , "290130567")
  asmlib.WorkshopID("SligWolf's Bodygroup Car"    , "173717507")
  asmlib.WorkshopID("Random Bridges"              , "343061215")
  asmlib.WorkshopID("StevenTechno's Buildings 1.0", "331192490")
  asmlib.WorkshopID("Mr.Train's M-Gauge"          , "517442747")
  asmlib.WorkshopID("Mr.Train's G-Gauge"          , "590574800")
  asmlib.WorkshopID("Bobster's two feet rails"    , "489114511")
  asmlib.WorkshopID("G Scale Track Pack"          , "718239260")
  asmlib.WorkshopID("Ron's Minitrain Props"       , "728833183")
  asmlib.WorkshopID("SligWolf's Modelpack"        , "147812851")
  asmlib.WorkshopID("Battleship's abandoned rails", "807162936")
  asmlib.WorkshopID("Ron's 2ft track pack"        , "634000136")
  asmlib.WorkshopID("Ron's G Scale Track pack"    , "865735701")
  asmlib.WorkshopID("AlexCookie's 2ft track pack" , "740453553")
  asmlib.WorkshopID("CAP Walkway"                 , "180210973")
  asmlib.WorkshopID("SligWolf's Tiny Hover Racer" , "1375275167")
  asmlib.WorkshopID("Joe's track pack"            , "1658816805")
  asmlib.WorkshopID("Plarail"                     , "1512053748")
  asmlib.WorkshopID("StevenTechno's Buildings 2.0", "1888013789")
  asmlib.WorkshopID("Modular Canals"              , "1336622735")
  asmlib.WorkshopID("Trackmania United Props"     , "1955876643")
  asmlib.WorkshopID("Anyone's Horrible Trackpack" , "2194528273")
  asmlib.WorkshopID("Modular Sewer"               , "2340192251")
  asmlib.WorkshopID("RockMan's Fortification"     , "3071058065")
  asmlib.WorkshopID("SligWolf's Suspension Train" , "3297918081")
  asmlib.WorkshopID("Modular City Street"         , "3314861708")
  asmlib.WorkshopID("Scene Builder"               , "2233731395")
  asmlib.WorkshopID("Modular Dungeons"            , "3302818415")

  asmlib.SetAction("CLEAR_GHOSTS" , function() asmlib.ClearGhosts() end)
  asmlib.SetAction("CTXMENU_OPEN" , function() asmlib.IsFlag("tg_context_menu", true ) end)
  asmlib.SetAction("CTXMENU_CLOSE", function() asmlib.IsFlag("tg_context_menu", false) end)

  asmlib.SetAction("CREATE_CURVE_NODE",
    function(nLen) local oPly, sLog = netReadEntity(), "*CREATE_CURVE_NODE"
      local vNode, vNorm, vBase = netReadVector(), netReadNormal(), netReadVector()
      local vOrgw, aAngw, bRayw = netReadVector(), netReadAngle() , netReadBool()
      local iD, tC = netReadUInt(16), asmlib.GetCacheCurve(oPly) -- Read the curve
      if(iD > 0 and tC.Norm[iD] and tC.Size and tC.Size >= 2) then
        tC.Norm[iD]:Set(netReadNormal()) end -- Update the previews curve normal
      tableInsert(tC.Node, vNode); tableInsert(tC.Norm, vNorm)
      tableInsert(tC.Base, vBase); tableInsert(tC.Rays, {vOrgw, aAngw, bRayw})
      tC.Size = (tC.Size + 1) -- Register the index after writing the data for drawing
    end)

  asmlib.SetAction("UPDATE_CURVE_NODE",
    function(nLen) local oPly, sLog = netReadEntity(), "*UPDATE_CURVE_NODE"
      local vNode, vNorm, vBase = netReadVector(), netReadNormal(), netReadVector()
      local vOrgw, aAngw, bRayw = netReadVector(), netReadAngle() , netReadBool()
      local iD, tC = netReadUInt(16), asmlib.GetCacheCurve(oPly)
      tC.Node[iD]:Set(vNode); tC.Norm[iD]:Set(vNorm)
      tC.Base[iD]:Set(vBase); tC.Rays[iD] = {vOrgw, aAngw, bRayw}
    end)

  asmlib.SetAction("DELETE_CURVE_NODE",
    function(nLen) local oPly, sLog = netReadEntity(), "*DELETE_CURVE_NODE"
      local tC = asmlib.GetCacheCurve(oPly)
      if(tC.Size and tC.Size > 0) then
        tC.Size = (tC.Size - 1) -- Register the index before wiping the data for drawing
        tableRemove(tC.Node); tableRemove(tC.Norm)
        tableRemove(tC.Base); tableRemove(tC.Rays)
        if(tC.Size and tC.Size > 0) then
          tC.Norm[tC.Size]:Set(tC.Rays[tC.Size][2]:Up())
        end
      end
    end)

  asmlib.SetAction("DELETE_ALL_CURVE_NODE",
    function(nLen) local oPly, sLog = netReadEntity(), "*DELETE_ALL_CURVE_NODE"
      local tC = asmlib.GetCacheCurve(oPly)
      if(tC.Size and tC.Size > 0) then
        tableEmpty(tC.Node); tableEmpty(tC.Norm)
        tableEmpty(tC.Base); tableEmpty(tC.Rays)
        tC.Size = 0 -- Register the index before wiping the data for drawing
      end
    end)

  asmlib.SetAction("CLEAR_RELATION",
    function(nLen) local oPly, sLog = netReadEntity(), "*CLEAR_RELATION"
      asmlib.LogInstance("{"..tostring(nLen)..","..tostring(oPly).."}", sLog)
      if(not asmlib.IntersectRayClear(oPly, "relate")) then
        asmlib.LogInstance("Failed clearing ray", sLog); return nil end
      asmlib.LogInstance("Success", sLog); return nil
    end) -- Net receive intersect relation clear client-side

  asmlib.SetAction("CREATE_RELATION",
    function(nLen) local sLog = "*CREATE_RELATION"
      local oEnt, vHit, oPly = netReadEntity(), netReadVector(), netReadEntity()
      asmlib.LogInstance("{"..tostring(nLen)..","..tostring(oPly).."}", sLog)
      if(not asmlib.IntersectRayCreate(oPly, oEnt, vHit, "relate")) then
        asmlib.LogInstance("Failed updating ray", sLog); return nil end
      asmlib.LogInstance("Success", sLog); return nil
    end) -- Net receive intersect relation create client-side

  asmlib.SetAction("BIND_PRESS", -- Must have the same parameters as the hook
    function(oPly,sBind,bPress) local sLog = "*BIND_PRESS"
      local oPly, acSw, acTo = asmlib.GetHookInfo()
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",sLog); return nil end
      if(not acTo) then -- Make sure we have a tool
        asmlib.LogInstance("Tool missing",sLog); return nil end
      if(((sBind == "invnext") or (sBind == "invprev")) and bPress) then
        -- Switch functionality of the mouse wheel only for TA
        if(not inputIsKeyDown(KEY_LALT)) then
          asmlib.LogInstance("Active key missing",sLog); return nil end
        if(not acTo:GetScrollMouse()) then
          asmlib.LogInstance("(SCROLL) Scrolling disabled",sLog); return nil end
        local nDir = ((sBind == "invnext") and -1) or ((sBind == "invprev") and 1) or 0
        acTo:SwitchPoint(nDir,inputIsKeyDown(KEY_LSHIFT))
        asmlib.LogInstance("("..sBind..") Processed",sLog); return true
      elseif((sBind == "+zoom") and bPress) then -- Work mode radial menu selection
        if(inputIsMouseDown(MOUSE_MIDDLE)) then -- Reserve the mouse middle for radial menu
          if(not acTo:GetRadialMenu()) then -- Zoom is bind on the middle mouse button
            asmlib.LogInstance("("..sBind..") Menu disabled",sLog); return nil end
          asmlib.LogInstance("("..sBind..") Processed",sLog); return true
        end; return nil -- Need to disable the zoom when bind on the mouse middle
      end -- Override only for TA and skip touching anything else
      asmlib.LogInstance("("..sBind..") Skipped",sLog); return nil
    end) -- Read client configuration

  asmlib.SetAction("DRAW_RADMENU", -- Must have the same parameters as the hook
    function() local sLog = "*DRAW_RADMENU"
      local oPly, acSw, acTo = asmlib.GetHookInfo()
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",sLog) return nil end
      if(not acTo) then -- Make sure we have a tool
        asmlib.LogInstance("Tool missing",sLog); return nil end
      if(not acTo:GetRadialMenu()) then
        asmlib.LogInstance("Menu disabled",sLog); return nil end
      if(inputIsMouseDown(MOUSE_MIDDLE)) then guiEnableScreenClicker(true) else
        guiEnableScreenClicker(false); asmlib.LogInstance("Release",sLog); return nil
      end -- Draw while holding the mouse middle button
      local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
      local actMonitor = asmlib.GetScreen(0,0,scrW,scrH,conPalette,"GAME")
      if(not actMonitor) then asmlib.LogInstance("Screen invalid",sLog); return nil end
      local nMd = asmlib.GetOpVar("MAX_ROTATION")
      local nDr, sM = asmlib.GetOpVar("DEG_RAD"), asmlib.GetOpVar("MISS_NOAV")
      local nBr = (acTo:GetRadialAngle() * nDr)
      local nK, nN = acTo:GetRadialSegm(), conWorkMode:GetSize()
      local nR  = (mathMin(scrW, scrH) / (2 * gnRatio))
      local mXY = asmlib.NewXY(guiMouseX(), guiMouseY())
      local vCn = asmlib.NewXY(mathFloor(scrW/2), mathFloor(scrH/2))
      local nMr, vTx, nD = (nMd * nDr), asmlib.NewXY(), (nR / gnRatio) -- Max angle [2pi]
      local vA, vB = asmlib.NewXY(), asmlib.NewXY()
      local tP = {asmlib.NewXY(), asmlib.NewXY(), asmlib.NewXY(), asmlib.NewXY()}
      local vF, vN = asmlib.NewXY(nR, 0), asmlib.NewXY(mathClamp(nR - nD, 0, nR), 0)
      asmlib.RotateXY(vN, nBr); asmlib.RotateXY(vF, nBr) -- Near and far base rotation
      asmlib.NegY(asmlib.SubXY(vA, mXY, vCn)) -- Origin [0;0] is located at top left
      asmlib.RotateXY(vA, -nBr) -- Correctly read the wiper vector to identify working mode
      local aW = mathAtan2(vA.y, vA.x) -- Read wiper angle and normalize the value
            aW = ((aW < 0) and (aW + nMr) or aW) -- Convert [0;+pi;-pi;0] to [0;2pi]
      local iW = mathFloor(((aW / nMr) * nN) + 1) -- Calculate fraction ID for working mode
      local dA = (nMr / (nK * nN)) -- Two times smaller step to handle centers as well
      asmlib.SetXY(vA, vF); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[4], vA)
      asmlib.SetXY(vA, vN); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[3], vA)
      local nT, nB = mathCeil((nK - 1) / 2) + 1, mathFloor((nK - 1) / 2) + 1
      for iD = 1, nN do asmlib.SetXY(vTx, 0, 0)
        local sW = tostring(conWorkMode:Select(iD) or sM) -- Read selection name
        local sC = ((iW == iD) and "pf" or "pb") -- Change color for selected option
        -- Draw polygon segment using triangles with the same color and array of vertices
        for iK = 1, nK do -- Interpolate the circle with given number of segments
          asmlib.SetXY(tP[1], tP[4]); asmlib.SetXY(tP[2], tP[3])
          asmlib.RotateXY(vN, dA); asmlib.RotateXY(vF, dA) -- Go to the next base line
          asmlib.SetXY(vA, vF); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[4], vA)
          asmlib.SetXY(vB, vN); asmlib.NegY(vB); asmlib.AddXY(vB, vB, vCn); asmlib.SetXY(tP[3], vB)
          actMonitor:DrawPoly(tP, sC, "SURF", {"vgui/white"}) -- Draw textured polygon
          -- Draw working mode name by placing centered text and the polygon midpoint
          if(nT == nB) then -- The index is at the farthest point
            if(nB == iK) then -- Odd. Use closest four vertices are taken
              asmlib.MidXY(vA, tP[1], tP[2]); asmlib.MidXY(vB, tP[3], tP[4])
              asmlib.MidXY(vA, vA, vB); asmlib.AddXY(vTx, vTx, vA)
            end -- When counter is at the top calculate text position
          else -- Even. Use the rod middle point of the two vertexes
            if(nB == iK) then asmlib.MidXY(vTx, vA, vB) end
          end -- Otherwise calculation is not triggered and does nothing
        end -- One segment for working mode selection is drawn
        actMonitor:SetTextStart(vTx.x, vTx.y):DrawText(sW, "k", "SURF", {"Trebuchet24", true})
      end; asmlib.SetAsmConvar(oPly, "workmode", iW); return true
    end)

  asmlib.SetAction("DRAW_GHOSTS", -- Must have the same parameters as the hook
    function() local sLog = "*DRAW_GHOSTS"
      local oPly, acSw, acTo = asmlib.GetHookInfo()
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",sLog); return nil end
      if(not acTo) then -- Make sure we have a tool
        asmlib.LogInstance("Tool missing",sLog); return nil end
      local model = acTo:GetModel()
      if(not asmlib.IsModel(model)) then asmlib.ClearGhosts()
        asmlib.LogInstance("Invalid model",sLog); return nil end
      local ghcnt = acTo:GetGhostsDepth()
      local atGho = asmlib.GetOpVar("ARRAY_GHOST")
      if(not (asmlib.HasGhosts() and ghcnt == atGho.Size and atGho.Slot == model)) then
        if(not asmlib.NewGhosts(ghcnt, model)) then
          asmlib.LogInstance("Ghosting fail",sLog); return nil end
        acTo:ElevateGhost(atGho[1], oPly) -- Elevate the properly created ghost
      end; acTo:UpdateGhost(oPly) -- Update ghosts stack for the local player
    end) -- Read client configuration

  asmlib.SetAction("OPEN_EXTERNDB",
    function() -- Must have the same parameters as the hook
      local oPly = LocalPlayer()
      local sLog = "*OPEN_EXTERNDB"
      local scrW = surfaceScreenWidth()
      local scrH = surfaceScreenHeight()
      local sVer = asmlib.GetOpVar("TOOL_VERSION")
      local xyPos, nAut  = asmlib.NewXY(scrW/4,scrH/4), (gnRatio - 1)
      local xyDsz, xyTmp = asmlib.NewXY(5,5), asmlib.NewXY()
      local xySiz = asmlib.NewXY(nAut * scrW, nAut * scrH)
      local pnFrame = vguiCreate("DFrame"); if(not IsValid(pnFrame)) then
        asmlib.LogInstance("Frame invalid",sLog); return nil end
      pnFrame:SetPos(xyPos.x, xyPos.y)
      pnFrame:SetSize(xySiz.x, xySiz.y)
      pnFrame:SetTitle(languageGetPhrase("tool."..gsToolNameL..".pn_externdb_hd").." "..oPly:Nick().." {"..sVer.."}")
      pnFrame:SetDraggable(true)
      pnFrame:SetDeleteOnClose(false)
      pnFrame.OnClose = function(pnSelf)
        local iK = conElements:Find(pnSelf) -- Find panel key index
        if(IsValid(pnSelf)) then pnSelf:Remove() end -- Delete the valid panel
        if(asmlib.IsHere(iK)) then conElements:Pull(iK) end -- Pull the key out
      end
      local sMis = asmlib.GetOpVar("MISS_NOAV")
      local sLib = asmlib.GetOpVar("NAME_LIBRARY")
      local sBas = asmlib.GetOpVar("DIRPATH_BAS")
      local sSet = asmlib.GetOpVar("DIRPATH_SET")
      local sPrU = asmlib.GetOpVar("TOOLNAME_PU")
      local sRev = asmlib.GetOpVar("OPSYM_REVISION")
      local sDsv = sBas..asmlib.GetOpVar("DIRPATH_DSV")
      local fDSV = sDsv..("%s"..sPrU.."%s.txt")
      local sNam = (sBas..sSet..sLib.."_dsv.txt")
      local nW, nH = pnFrame:GetSize()
      local sDel, nB, nT = "\t", 22, 23
      xyPos.x, xyPos.y = xyDsz.x, (xyDsz.y + nT)
      xySiz.x = (nW - 2 * xyDsz.x)
      xySiz.y = (nH - nT - 2*xyDsz.y) - 2*xyDsz.y - 2*nB
      local wAct = mathFloor(((gnRatio - 1) / 10) * xySiz.x)
      local wUse, wSrc = mathFloor(xySiz.x - wAct), (xySiz.x * nAut)
      local pnListView = vguiCreate("DListView")
      if(not IsValid(pnListView)) then pnFrame:Close()
        asmlib.LogInstance("List view invalid",sLog); return nil end
      pnListView:SetParent(pnFrame)
      pnListView:SetVisible(true)
      pnListView:SetSortable(false)
      pnListView:SetMultiSelect(false)
      pnListView:SetPos(xyPos.x, xyPos.y)
      pnListView:SetSize(xySiz.x, xySiz.y)
      pnListView:SetName(languageGetPhrase("tool."..gsToolNameL..".pn_extdsv_lb"))
      pnListView:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pn_extdsv_hd"))
      pnListView:AddColumn(languageGetPhrase("tool."..gsToolNameL..".pn_extdsv_act")):SetFixedWidth(wAct)
      pnListView:AddColumn(languageGetPhrase("tool."..gsToolNameL..".pn_extdsv_prf")):SetFixedWidth(wUse - wSrc)
      pnListView:AddColumn(languageGetPhrase("tool."..gsToolNameL..".pn_extdsv_inf")):SetFixedWidth(wSrc)
      -- Next entry to import/export to list view
      xyPos.y = xyPos.y + xySiz.y + xyDsz.y
      xySiz.y = nB -- General Y-size of elements
      local tpText = {Size = #pnListView.Columns}
      function tpText:Scan(pnRow, bChng)
        if(not IsValid(pnRow)) then return end
        local bChng = (bChng and asmlib.IsHere(bChng))
        for iV = 1, self.Size do
          local ptx = self[iV] -- Pick a panel
          local str = pnRow:GetColumnText(iV)
          ptx:SetValue(str); ptx:SetText(str)
        end -- Exchange data with list view and text. Setup change line flag
        if(bChng) then self.Chng = true else self.Chng = nil end
      end
      function tpText:Swap(pnSor, pnDes)
        if(not IsValid(pnSor)) then return end
        if(not IsValid(pnDes)) then return end
        local bChng = (bChng and asmlib.IsHere(bChng))
        for iV = 1, self.Size do
          local str = pnDes:GetColumnText(iV)
          pnDes:SetColumnText(iV, pnSor:GetColumnText(iV))
          pnSor:SetColumnText(iV, str)
          pnListView:ClearSelection()
          pnListView:SelectItem(pnDes)
        end -- Exchange data with list view and text. Setup change line flag
      end
      for iC = 1, tpText.Size do
        local pC = pnListView.Columns[iC]
        local cW = math.min(pC:GetMinWidth(), pC:GetMaxWidth())
        if(iC == 1 or iC == tpText.Size) then
          xySiz.x = cW - (xyDsz.x / 2)
        else xySiz.x = cW - xyDsz.x end; pC:SetWide(cW)
        local pnText = vguiCreate("DTextEntry"); if(not IsValid(pnText)) then pnFrame:Close()
          asmlib.LogInstance("Entry invalid "..GetReport(iC), sLog..".TextEntry"); return nil end
        pnText:SetParent(pnFrame)
        pnText:SetEditable(true)
        pnText:SetPos(xyPos.x, xyPos.y)
        pnText:SetSize(xySiz.x, xySiz.y)
        pnText:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pn_externdb_ttt").." "
                        ..languageGetPhrase("tool."..gsToolNameL..".pn_ext_dsv_"..iC))
        xyPos.x = xyPos.x + xySiz.x + xyDsz.x; tpText[iC] = pnText
        pnText.OnEnter = function(pnSelf)
          local tDat, sMis = {}, asmlib.GetOpVar("MISS_NOAV")
          for iV = 1, tpText.Size do tDat[iV] = tpText[iV]:GetValue() end
          -- Active line. Contains X/V
          tDat[1] = tostring(tDat[1] or "X")
          tDat[1] = (tDat[1]:Trim():upper():sub(1,1))
          tDat[1] = ((tDat[1] == "V") and "V" or "X")
          -- Database unique prefix. Contains non-spaces
          tDat[2] = tostring(tDat[2] or "")
          tDat[2] = tDat[2]:Trim():gsub("[^%w]","_")
          -- Additional information. It can be anything
          tDat[3] = tostring(tDat[3] or ""):Trim()
          tDat[3] = (asmlib.IsBlank(tDat[3]) and sMis or tDat[3])
          if(asmlib.IsBlank(tDat[1])) then return end
          if(asmlib.IsBlank(tDat[2])) then return end
          local iD, pnRow = pnListView:GetSelectedLine()
          if(asmlib.IsHere(iD) and IsValid(pnRow)) then
            if(iD and iD > 0 and pnRow and tpText.Chng) then tpText.Chng = nil
              for iU = 1, tpText.Size do pnRow:SetColumnText(iU, tDat[iU]) end
            else pnListView:AddLine(tDat[1], tDat[2], tDat[3]):SetTooltip(tDat[3]) end
          else pnListView:AddLine(tDat[1], tDat[2], tDat[3]):SetTooltip(tDat[3]) end
          for iV = 1, tpText.Size do tpText[iV]:SetValue(""); tpText[iV]:SetText("") end
        end
      end
      -- Import button. when clicked loads file into the panel
      local pnImport = vguiCreate("DButton")
      if(not IsValid(pnImport)) then pnFrame:Close()
        asmlib.LogInstance("Import button invalid", sLog); return nil end
      xyPos.x = pnListView:GetPos()
      xyPos.y = xyPos.y + xySiz.y + xyDsz.y
      xySiz.x = ((pnListView:GetWide() - xyDsz.x) / 2)
      pnImport:SetPos(xyPos.x, xyPos.y)
      pnImport:SetSize(xySiz.x, xySiz.y)
      pnImport:SetParent(pnFrame)
      pnImport:SetFont("Trebuchet24")
      pnImport:SetText(languageGetPhrase("tool."..gsToolNameL..".pn_externdb_bti"))
      pnImport:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pn_externdb_bti_tp"))
      pnImport.DoRightClick = function() end
      pnImport.DoClick = function(pnSelf) pnListView:Clear()
        if(not fileExists(sNam, "DATA")) then fileWrite(sNam, "") end
        local fD = fileOpen(sNam, "rb", "DATA"); if(not fD) then pnFrame:Close()
          asmlib.LogInstance("File error", sLog..".Import"); return nil end
        local sGen = (gsDirDSV..gsGenerPrf..gsToolPrefU.."*.txt")
        local tGen = fileFind(sGen, "DATA"); if(tGen and #tGen > 0) then
          pnListView:AddLine("V", gsGenerPrf, sGen):SetTooltip(gsDirDSV)
        else local iG = (tGen and #tGen or 0)
          asmlib.LogInstance("Generic database: "..asmlib.GetReport(iG, sGen), sLog..".Import") end
        local sLine, bEOF, bAct = "", false, true
        while(not bEOF) do
          sLine, bEOF = asmlib.GetStringFile(fD)
          if(not asmlib.IsBlank(sLine)) then local sKey, sPrg
            if(not asmlib.IsDisable(sLine)) then bAct = true else
              bAct, sLine = false, sLine:sub(2,-1):Trim() end
            local nS, nE = sLine:find("%s+")
            if(nS and nE) then
              sKey = sLine:sub(1, nS-1)
              sPrg = sLine:sub(nE+1,-1)
            else sKey, sPrg = sLine, sMis end
            pnListView:AddLine((bAct and "V" or "X"), sKey, sPrg):SetTooltip(sPrg)
          end
        end; fD:Close()
      end; pnImport:DoClick()
      -- Export button. When clicked loads contents into the file
      local pnExport = vguiCreate("DButton")
      if(not IsValid(pnExport)) then pnFrame:Close()
        asmlib.LogInstance("Export button invalid", sLog); return nil end
      xyPos.x = xyPos.x + xySiz.x + xyDsz.x
      pnExport:SetPos(xyPos.x, xyPos.y)
      pnExport:SetSize(xySiz.x, xySiz.y)
      pnExport:SetParent(pnFrame)
      pnExport:SetFont("Trebuchet24")
      pnExport:SetText(languageGetPhrase("tool."..gsToolNameL..".pn_externdb_bte"))
      pnExport:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pn_externdb_bte_tp"))
      pnExport.DoRightClick = function() end
      pnExport.DoClick = function(pnSelf)
        local fD = fileOpen(sNam, "wb", "DATA"); if(not fD) then pnFrame:Close()
          asmlib.LogInstance("File error",sLog..".Export"); return nil end
        local tLine = pnListView:GetLines()
        local sOff  = asmlib.GetOpVar("OPSYM_DISABLE")
        for iL = 1, #tLine do local pCur = tLine[iL]
          local sAct = ((pCur:GetColumnText(1) == "V") and "" or sOff)
          local sPrf, sPth = pCur:GetColumnText(2), pCur:GetColumnText(3)
          if(not asmlib.IsBlank(sPth)) then sPth = sDel..sPth end
          if(sPrf ~= gsGenerPrf) then fD:Write(sAct..sPrf..sPth.."\n") end
        end; fD:Flush(); fD:Close()
      end
      pnListView.OnRowRightClick = function(pnSelf, nIndex, pnLine)
        local pnMenu = vguiCreate("DMenu")
        if(not IsValid(pnMenu)) then pnFrame:Close()
          asmlib.LogInstance("Menu invalid",sLog..".ListView"); return nil end
        local sI, mX, mY = "pn_contextm_", inputGetCursorPos()
        local sP, sT = pnLine:GetColumnText(2), ("tool."..gsToolNameL.."."..sI)
        -- Enable and disable DSV
        pnMenu:AddOption(languageGetPhrase(sT.."tg"),
          function() pnLine:SetColumnText(1, ((pnLine:GetColumnText(1) == "V") and "X" or "V"))
        end):SetImage(asmlib.ToIcon(sI.."tg"))
        -- Copy to clipboard various values and things
        local pIn, pOp = pnMenu:AddSubMenu(languageGetPhrase(sT.."cp"))
        if(not IsValid(pIn)) then pnFrame:Close()
          asmlib.LogInstance("Copy menu invalid",sLog..".ListView"); return nil end
        if(not IsValid(pOp)) then pnFrame:Close()
          asmlib.LogInstance("Copy opts invalid",sLog..".ListView"); return nil end
        pOp:SetIcon(asmlib.ToIcon(sI.."cp"))
        pIn:AddOption(languageGetPhrase(sT.."cpbx"),
          function() asmlib.SetListViewBoxClipboard(pnSelf, mX, mY) end):SetImage(asmlib.ToIcon(sI.."cpbx"))
        pIn:AddOption(languageGetPhrase(sT.."cprw"),
          function() asmlib.SetListViewRowClipboard(pnSelf) end):SetImage(asmlib.ToIcon(sI.."cprw"))
        pIn:AddOption(languageGetPhrase(sT.."cpth"),
          function() SetClipboardText(sDsv) end):SetImage(asmlib.ToIcon(sI.."cpth"))
        -- Move current line around
        local pIn, pOp = pnMenu:AddSubMenu(languageGetPhrase(sT.."mv"))
        if(not IsValid(pIn)) then pnFrame:Close()
          asmlib.LogInstance("Internals menu invalid",sLog..".ListView"); return nil end
        if(not IsValid(pOp)) then pnFrame:Close()
          asmlib.LogInstance("Internals opts invalid",sLog..".ListView"); return nil end
        pOp:SetIcon(asmlib.ToIcon(sI.."mv"))
        pIn:AddOption(languageGetPhrase(sT.."mvup"),
          function()
            if(nIndex <= 1) then return end
            tpText:Swap(pnLine, pnSelf:GetLine(nIndex - 1))
          end):SetImage(asmlib.ToIcon(sI.."mvup"))
        pIn:AddOption(languageGetPhrase(sT.."mvdn"),
          function() local nT = #pnSelf:GetLines()
            if(nIndex >= nT) then return end
            tpText:Swap(pnLine, pnSelf:GetLine(nIndex + 1))
          end):SetImage(asmlib.ToIcon(sI.."mvdn"))
        pIn:AddOption(languageGetPhrase(sT.."mvtp"),
          function()
            if(nIndex <= 1) then return end
            tpText:Swap(pnLine, pnSelf:GetLine(1))
          end):SetImage(asmlib.ToIcon(sI.."mvtp"))
        pIn:AddOption(languageGetPhrase(sT.."mvbt"),
          function() local nT = #pnSelf:GetLines()
            if(nIndex >= nT) then return end
            tpText:Swap(pnLine, pnSelf:GetLine(nT))
          end):SetImage(asmlib.ToIcon(sI.."mvbt"))
        -- Panel data line manipulation for import/export
        local pIn, pOp = pnMenu:AddSubMenu(languageGetPhrase(sT.."li"))
        if(not IsValid(pIn)) then pnFrame:Close()
          asmlib.LogInstance("Internals menu invalid",sLog..".ListView"); return nil end
        if(not IsValid(pOp)) then pnFrame:Close()
          asmlib.LogInstance("Internals opts invalid",sLog..".ListView"); return nil end
        pOp:SetIcon(asmlib.ToIcon(sI.."li"))
        pIn:AddOption(languageGetPhrase(sT.."licg"),
          function() tpText:Scan(pnLine, true) end):SetImage(asmlib.ToIcon(sI.."licg"))
        pIn:AddOption(languageGetPhrase(sT.."licr"),
          function() tpText:Scan(pnLine) end):SetImage(asmlib.ToIcon(sI.."licr"))
        pIn:AddOption(languageGetPhrase(sT.."lirm"),
          function() pnSelf:RemoveLine(nIndex) end):SetImage(asmlib.ToIcon(sI.."lirm"))
        -- Populate the sub-menu with all table nicknames
        local iD, pIn, pOp = 1, nil, nil
        local makTab = asmlib.GetBuilderID(iD)
        while(makTab) do
          local defTab = makTab:GetDefinition()
          local sFile = fDSV:format(sP, defTab.Nick)
          if(fileExists(sFile, "DATA")) then
            if(not (pIn and pOp)) then
              -- Manipulate content local settings related to the line
              pIn, pOp = pnMenu:AddSubMenu(languageGetPhrase(sT.."st"))
              if(not IsValid(pIn)) then pnFrame:Close()
                asmlib.LogInstance("Settings menu invalid",sLog..".ListView"); return nil end
              if(not IsValid(pOp)) then pnFrame:Close()
                asmlib.LogInstance("Settings opts invalid",sLog..".ListView"); return nil end
              pOp:SetIcon(asmlib.ToIcon(sI.."st"))
            end -- When there is at least one DSV table present make table sub-menu
            if(pIn and pOp) then -- When the sub-menu pointer is available add tables
              local pTb, pOb = pIn:AddSubMenu(defTab.Nick)
              if(not IsValid(pTb)) then pnFrame:Close()
                asmlib.LogInstance("Manage menu invalid"..GetReport(iD, defTab.Nick),sLog..".ListView"); return nil end
              if(not IsValid(pOb)) then pnFrame:Close()
                asmlib.LogInstance("Manage opts invalid",sLog..".ListView"); return nil end
              pOb:SetIcon(asmlib.ToIcon(sI.."si"))
              pTb:AddOption(languageGetPhrase(sT.."stnk"),
                function() SetClipboardText(defTab.Nick) end):SetImage(asmlib.ToIcon(sI.."stnk"))
              pTb:AddOption(languageGetPhrase(sT.."stpt"),
                function() SetClipboardText(sFile) end):SetImage(asmlib.ToIcon(sI.."stpt"))
              pTb:AddOption(languageGetPhrase(sT.."sttm"),
                function() SetClipboardText(asmlib.GetDateTime(fileTime(sFile, "DATA"))) end):SetImage(asmlib.ToIcon(sI.."sttm"))
              pTb:AddOption(languageGetPhrase(sT.."stsz"),
                function() SetClipboardText(tostring(fileSize(sFile, "DATA")).."B") end):SetImage(asmlib.ToIcon(sI.."stsz"))
              pTb:AddOption(languageGetPhrase(sT.."sted"),
                function() -- Edit the database contents using the Luapad addon
                  if(not luapad) then -- Luapad is not installed then do nothing
                    asmlib.LogInstance("Skipped "..asmlib.GetReport(sFile), sLog..".ListView"); return end
                  asmlib.LogInstance  ("Modify "..asmlib.GetReport(sFile), sLog..".ListView")
                  if(luapad.Frame) then luapad.Frame:SetVisible(true); luapad.Frame:Center() else luapad.Toggle() end
                  luapad.AddTab("["..sP.."]["..defTab.Nick.."]", fileRead(sFile, "DATA"), sDsv);
                  if(defTab.Nick == "PIECES") then -- Load the category provider for this DSV
                    local sCats = fDSV:format(sP, "CATEGORY"); if(fileExists(sCats,"DATA")) then
                      luapad.AddTab("["..sP.."][CATEGORY]", fileRead(sCats, "DATA"), sDsv);
                    end -- This is done so we can distinguish between luapad and other panels
                  end -- Luapad is designed not to be closed so we need to make it invisible
                  luapad.Frame:SetVisible(true); luapad.Frame:Center()
                  luapad.Frame:MakePopup(); conElements:Push({luapad.Frame})
                end):SetImage(asmlib.ToIcon(sI.."sted"))
              pTb:AddOption(languageGetPhrase(sT.."stdl"),
                function() fileDelete(sFile)
                  asmlib.LogInstance("Deleted "..asmlib.GetReport(sFile), sLog..".ListView")
                  if(defTab.Nick == "PIECES") then local sCats = fDSV:format(sP, "CATEGORY")
                    if(fileExists(sCats,"DATA")) then fileDelete(sCats) -- Delete category when present
                      asmlib.LogInstance("Deleted "..asmlib.GetReport(sCats), sLog..".ListView") end
                  end
                end):SetImage(asmlib.ToIcon(sI.."stdl"))
            end
          end
          iD = (iD + 1); makTab = asmlib.GetBuilderID(iD)
        end
        pnMenu:Open()
      end -- Populate the tables for every database
      pnFrame:SetVisible(true); pnFrame:Center(); pnFrame:MakePopup()
      conElements:Push(pnFrame); asmlib.LogInstance("Success",sLog); return nil
    end) -- Read client configuration

  asmlib.SetAction("OPEN_FRAME",
    function(oPly,oCom,oArgs) local sLog = "*OPEN_FRAME"
      local frUsed = asmlib.GetFrequentPieces(oArgs[1]); if(not asmlib.IsHere(frUsed)) then
        asmlib.LogInstance("Retrieving most frequent models failed ["..tostring(oArgs[1]).."]",sLog); return nil end
      local makTab = asmlib.GetBuilderNick("PIECES"); if(not asmlib.IsHere(makTab)) then
        asmlib.LogInstance("Missing builder for table PIECES",sLog); return nil end
      local defTab = makTab:GetDefinition(); if(not defTab) then
        asmlib.LogInstance("Missing definition for table PIECES",sLog); return nil end
      local pnFrame = vguiCreate("DFrame"); if(not IsValid(pnFrame)) then
        asmlib.LogInstance("Frame invalid",sLog); return nil end
      ------------ Screen resolution and configuration ------------
      local scrW     = surfaceScreenWidth()
      local scrH     = surfaceScreenHeight()
      local sVersion = asmlib.GetOpVar("TOOL_VERSION")
      local xyZero   = {x =  0, y = 20} -- The start location of left-top
      local xyDelta  = {x = 10, y = 10} -- Distance between panels
      local xySiz    = {x =  0, y =  0} -- Current panel size
      local xyPos    = {x =  0, y =  0} -- Current panel position
      local xyTmp    = {x =  0, y =  0} -- Temporary coordinate
      ------------ Frame ------------
      xySiz.x = (scrW / gnRatio) -- This defines the size of the frame
      xyPos.x, xyPos.y = (scrW / 4), (scrH / 4)
      xySiz.y = mathFloor(xySiz.x / (1 + gnRatio))
      pnFrame:SetTitle(languageGetPhrase("tool."..gsToolNameL..".pn_routine_hd").." "..oPly:Nick().." {"..sVersion.."}")
      pnFrame:SetVisible(true)
      pnFrame:SetDraggable(true)
      pnFrame:SetDeleteOnClose(false)
      pnFrame:SetPos(xyPos.x, xyPos.y)
      pnFrame:SetSize(xySiz.x, xySiz.y)
      pnFrame.OnClose = function(pnSelf)
        local iK = conElements:Find(pnSelf) -- Find panel key index
        if(IsValid(pnSelf)) then pnSelf:Remove() end -- Delete the valid panel
        if(asmlib.IsHere(iK)) then conElements:Pull(iK) end -- Pull the key out
      end
      ------------ Button ------------
      xyTmp.x, xyTmp.y = pnFrame:GetSize()
      xySiz.x = (xyTmp.x / (8.5 * gnRatio)) -- Display properly the name
      xySiz.y = (xySiz.x / (1.5 * gnRatio)) -- Used by combo-box and text-box
      xyPos.x = xyZero.x + xyDelta.x
      xyPos.y = xyZero.y + xyDelta.y
      local pnButton = vguiCreate("DButton")
      if(not IsValid(pnButton)) then pnFrame:Close()
        asmlib.LogInstance("Button invalid",sLog); return nil end
      pnButton:SetParent(pnFrame)
      pnButton:SetPos(xyPos.x, xyPos.y)
      pnButton:SetSize(xySiz.x, xySiz.y)
      pnButton:SetVisible(true)
      pnButton:SetName(languageGetPhrase("tool."..gsToolNameL..".pn_export_lb"))
      pnButton:SetText(languageGetPhrase("tool."..gsToolNameL..".pn_export_lb"))
      pnButton:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pn_export"))
      ------------ ComboBox ------------
      xyPos.x, xyPos.y = pnButton:GetPos()
      xyTmp.x, xyTmp.y = pnButton:GetSize()
      xyPos.x = xyPos.x + xyTmp.x + xyDelta.x
      xySiz.x, xySiz.y = (gnRatio * xyTmp.x), xyTmp.y
      local pnComboBox = vguiCreate("DComboBox")
      if(not IsValid(pnComboBox)) then pnFrame:Close()
        asmlib.LogInstance("Combo invalid",sLog); return nil end
      pnComboBox:SetParent(pnFrame)
      pnComboBox:SetPos(xyPos.x,xyPos.y)
      pnComboBox:SetSize(xySiz.x,xySiz.y)
      pnComboBox:SetVisible(true)
      pnComboBox:SetSortItems(false)
      pnComboBox:SetName(languageGetPhrase("tool."..gsToolNameL..".pn_srchcol_lb"))
      pnComboBox:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pn_srchcol"))
      pnComboBox:SetValue(languageGetPhrase("tool."..gsToolNameL..".pn_srchcol_lb"))
      pnComboBox:AddChoice(languageGetPhrase("tool."..gsToolNameL..".pn_routine_mod"), 1, false, asmlib.ToIcon("pn_routine_mod"))
      pnComboBox:AddChoice(languageGetPhrase("tool."..gsToolNameL..".pn_routine_typ"), 2, false, asmlib.ToIcon("pn_routine_typ"))
      pnComboBox:AddChoice(languageGetPhrase("tool."..gsToolNameL..".pn_routine_nam"), 3, false, asmlib.ToIcon("pn_routine_nam"))
      pnComboBox:AddChoice(languageGetPhrase("tool."..gsToolNameL..".pn_routine_end"), 4, false, asmlib.ToIcon("pn_routine_end"))
      pnComboBox.OnSelect = function(pnSelf, nInd, sVal, anyData)
        asmlib.LogInstance("Selected "..asmlib.GetReport(nInd,sVal,anyData),sLog..".ComboBox")
        pnSelf:SetValue(sVal)
      end
      ------------ ModelPanel ------------
      xyTmp.x, xyTmp.y = pnFrame:GetSize()
      xyPos.x, xyPos.y = pnComboBox:GetPos()
      xySiz.x = (xyTmp.x / (1.9 * gnRatio)) -- Display the model properly
      xyPos.x = xyTmp.x - xySiz.x - xyDelta.x
      xySiz.y = xyTmp.y - xyPos.y - xyDelta.y
      ------------------------------------------------
      local pnModelPanel = vguiCreate("DModelPanel")
      if(not IsValid(pnModelPanel)) then pnFrame:Close()
        asmlib.LogInstance("Model display invalid",sLog); return nil end
      pnModelPanel:SetParent(pnFrame)
      pnModelPanel:SetPos(xyPos.x,xyPos.y)
      pnModelPanel:SetSize(xySiz.x,xySiz.y)
      pnModelPanel:SetVisible(true)
      pnModelPanel:SetName(languageGetPhrase("tool."..gsToolNameL..".pn_display_lb"))
      pnModelPanel:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pn_display"))
      pnModelPanel.LayoutEntity = function(pnSelf, oEnt)
        if(pnSelf.bAnimated) then pnSelf:RunAnimation() end
        local uiBox = asmlib.CacheBoxLayout(oEnt); if(not asmlib.IsHere(uiBox)) then
          asmlib.LogInstance("Box invalid",sLog..".ModelPanel"); return nil end
        if(inputIsMouseDown(MOUSE_RIGHT) and pnSelf:IsHovered()) then
          if(pnSelf.pcX and pnSelf.pcY) then
            local nX, nY = guiMouseX(), guiMouseY()
            local aP, aY, aR = uiBox.Ang:Unpack()
            aP = mathNormalizeAngle(nY - pnSelf.pcY)
            aR = mathNormalizeAngle(pnSelf.pcX - nX)
            uiBox.Ang:SetUnpacked(aP, aY, aR)
          else pnSelf.pcX, pnSelf.pcY = guiMouseX(), guiMouseY() end
        else pnSelf.pcX, pnSelf.pcY = nil, nil end
        local stSpawn = asmlib.GetNormalSpawn(oPly, gvVecZero, uiBox.Ang, oEnt:GetModel(), 1)
        if(not stSpawn) then asmlib.LogInstance("Spawn data fail",sLog..".LayoutEntity"); return nil end
        stSpawn.SAng:RotateAroundAxis(stSpawn.SAng:Up(), mathNormalizeAngle(40 * Time()))
        stSpawn.SPos:Set(uiBox.Cen); stSpawn.SPos:Rotate(stSpawn.SAng)
        stSpawn.SPos:Mul(-1); stSpawn.SPos:Add(uiBox.Cen)
        oEnt:SetAngles(stSpawn.SAng); oEnt:SetPos(stSpawn.SPos)
      end
      ------------ TextEntry ------------
      xyPos.x, xyPos.y = pnComboBox:GetPos()
      xyTmp.x, xyTmp.y = pnComboBox:GetSize()
      xyPos.x = xyPos.x + xyTmp.x + xyDelta.x
      xySiz.y = xyTmp.y
      ------------------------------------------------
      xyTmp.x, xyTmp.y = pnModelPanel:GetPos()
      xySiz.x = xyTmp.x - xyPos.x - xyDelta.x
      ------------------------------------------------
      local pnTextEntry = vguiCreate("DTextEntry")
      if(not IsValid(pnTextEntry)) then pnFrame:Close()
        asmlib.LogInstance("Textbox invalid",sLog); return nil end
      pnTextEntry:SetParent(pnFrame)
      pnTextEntry:SetPos(xyPos.x,xyPos.y)
      pnTextEntry:SetSize(xySiz.x,xySiz.y)
      pnTextEntry:SetVisible(true)
      pnTextEntry:SetName(languageGetPhrase("tool."..gsToolNameL..".pn_pattern_lb"))
      pnTextEntry:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pn_pattern"))
      ------------ ListView ------------
      xyPos.x, xyPos.y = pnButton:GetPos()
      xyTmp.x, xyTmp.y = pnButton:GetSize()
      xyPos.y = xyPos.y + xyTmp.y + xyDelta.y
      ------------------------------------------------
      xyTmp.x, xyTmp.y = pnTextEntry:GetPos()
      xySiz.x, xySiz.y = pnTextEntry:GetSize()
      xySiz.x = xyTmp.x + xySiz.x - xyDelta.x
      ------------------------------------------------
      xyTmp.x, xyTmp.y = pnFrame:GetSize()
      xySiz.y = xyTmp.y - xyPos.y - xyDelta.y
      ------------------------------------------------
      local wUse = mathFloor(0.120377559 * xySiz.x)
      local wAct = mathFloor(0.047460893 * xySiz.x)
      local wTyp = mathFloor(0.314127559 * xySiz.x)
      local wNam = xySiz.x - wUse - wAct - wTyp
      local pnListView = vguiCreate("DListView")
      if(not IsValid(pnListView)) then pnFrame:Close()
        asmlib.LogInstance("List view invalid",sLog); return nil end
      pnListView:SetParent(pnFrame)
      pnListView:SetVisible(false)
      pnListView:SetSortable(true)
      pnListView:SetMultiSelect(false)
      pnListView:SetPos(xyPos.x,xyPos.y)
      pnListView:SetSize(xySiz.x,xySiz.y)
      pnListView:SetName(languageGetPhrase("tool."..gsToolNameL..".pn_routine_lb"))
      pnListView:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".pn_routine"))
      pnListView:AddColumn(languageGetPhrase("tool."..gsToolNameL..".pn_routine_use")):SetFixedWidth(wUse) -- (1)
      pnListView:AddColumn(languageGetPhrase("tool."..gsToolNameL..".pn_routine_end")):SetFixedWidth(wAct) -- (2)
      pnListView:AddColumn(languageGetPhrase("tool."..gsToolNameL..".pn_routine_typ")):SetFixedWidth(wTyp) -- (3)
      pnListView:AddColumn(languageGetPhrase("tool."..gsToolNameL..".pn_routine_nam")):SetFixedWidth(wNam) -- (4)
      pnListView:AddColumn(""):SetFixedWidth(0) -- (5) This is actually the hidden model of the piece used.
      pnListView.OnRowSelected = function(pnSelf, nIndex, pnLine)
        local uiMod =  tostring(pnLine:GetColumnText(5)  or asmlib.GetOpVar("MISS_NOMD")) -- Actually the model in the table
        local uiAct = (tonumber(pnLine:GetColumnText(2)) or 0); pnModelPanel:SetModel(uiMod) -- Active track ends per model create entity
        local uiEnt = pnModelPanel:GetEntity(); if(not (uiEnt and uiEnt:IsValid())) then -- Makes sure the entity is validated first
          asmlib.LogInstance("Model entity invalid "..asmlib.GetReport(uiMod), sLog..".ListView"); return nil end
        uiEnt:SetModel(uiMod); uiEnt:SetModelName(uiMod) -- Apply the model on the model panel even for changed compiled model paths
        local uiBox = asmlib.CacheBoxLayout(uiEnt,gnRatio,gnRatio-1); if(not asmlib.IsHere(uiBox)) then
          asmlib.LogInstance("Box invalid for <"..uiMod..">",sLog..".ListView"); return nil end
        pnModelPanel:SetLookAt(uiBox.Eye); pnModelPanel:SetCamPos(uiBox.Cam)
        local pointid, pnextid = asmlib.GetAsmConvar("pointid","INT"), asmlib.GetAsmConvar("pnextid","INT")
              pointid, pnextid = asmlib.SnapReview(pointid, pnextid, uiAct); SetClipboardText(uiMod)
        asmlib.SetAsmConvar(oPly,"pointid", pointid)
        asmlib.SetAsmConvar(oPly,"pnextid", pnextid)
        asmlib.SetAsmConvar(oPly, "model" , uiMod)
      end -- Copy the line model to the clipboard so it can be pasted with Ctrl+V
      pnListView.OnRowRightClick = function(pnSelf, nIndex, pnLine)
        local sI, mX, mY = "pn_contextm_", inputGetCursorPos()
        local sT, sTyp = "tool.trackassembly."..sI, pnLine:GetColumnText(3)
        local bEx = asmlib.GetAsmConvar("exportdb", "BUL")
        local sID = asmlib.WorkshopID(sTyp)
        local pMenu = vguiCreate("DMenu")
        if(not IsValid(pMenu)) then pnFrame:Close()
          asmlib.LogInstance("Menu invalid",sLog..".ListView"); return nil end
        -- Copy to clipboard various values and things
        local pIn, pOp = pMenu:AddSubMenu(languageGetPhrase(sT.."cp"))
        if(not IsValid(pIn)) then pnFrame:Close()
          asmlib.LogInstance("Copy menu invalid",sLog..".ListView"); return nil end
        if(not IsValid(pOp)) then pnFrame:Close()
          asmlib.LogInstance("Copy opts invalid",sLog..".ListView"); return nil end
        pOp:SetIcon(asmlib.ToIcon(sI.."cp"))
        pIn:AddOption(languageGetPhrase(sT.."cpmd"),
          function() SetClipboardText(pnLine:GetColumnText(5)) end):SetImage(asmlib.ToIcon(sI.."cpmd"))
        pIn:AddOption(languageGetPhrase(sT.."cpbx"),
          function() asmlib.SetListViewBoxClipboard(pnSelf, mX, mY) end):SetImage(asmlib.ToIcon(sI.."cpbx"))
        pIn:AddOption(languageGetPhrase(sT.."cprw"),
          function() asmlib.SetListViewRowClipboard(pnSelf) end):SetImage(asmlib.ToIcon(sI.."cprw"))
        -- Handle workshop specific options
        if(sID) then
          local sUR = asmlib.GetOpVar("FORM_URLADDON")
          local pIn, pOp = pMenu:AddSubMenu(languageGetPhrase(sT.."ws"))
          if(not IsValid(pIn)) then
            LogInstance("Base WS invalid"); return nil end
          pOp:SetIcon(asmlib.ToIcon(sI.."ws"))
          pIn:AddOption(languageGetPhrase(sT.."wsid"),
            function() SetClipboardText(sID) end):SetIcon(asmlib.ToIcon(sI.."wsid"))
          pIn:AddOption(languageGetPhrase(sT.."wsop"),
            function() guiOpenURL(sUR:format(sID)) end):SetIcon(asmlib.ToIcon(sI.."wsop"))
        end
        -- Export database contents
        if(bEx) then
          local pIn, pOp = pMenu:AddSubMenu(languageGetPhrase(sT.."ex"))
          if(not (IsValid(pIn) and IsValid(pOp))) then
            asmlib.LogInstance("Base export invalid"); return nil end
          pOp:SetIcon(asmlib.ToIcon(sI.."ex"))
          pIn:AddOption(languageGetPhrase(sT.."exdv"),
            function()
              asmlib.SetAsmConvar(oPly, "exportdb", 0)
              local oPly = LocalPlayer(); if(not asmlib.IsPlayer(oPly)) then
              asmlib.LogInstance("Player invalid"); return nil end
              asmlib.LogInstance("Export "..asmlib.GetReport(oPly:Nick(), sTyp))
              asmlib.ExportTypeDSV(sTyp)
            end):SetIcon(asmlib.ToIcon(sI.."exdv"))
          pIn:AddOption(languageGetPhrase(sT.."exru"),
            function()
              asmlib.SetAsmConvar(oPly, "exportdb", 0)
              local oPly = LocalPlayer(); if(not asmlib.IsPlayer(oPly)) then
              asmlib.LogInstance("Player invalid"); return nil end
              asmlib.LogInstance("Export "..asmlib.GetReport(oPly:Nick(), sTyp))
              asmlib.ExportTypeRun(sTyp)
            end):SetIcon(asmlib.ToIcon(sI.."exru"))
        end
        pMenu:Open()
      end
      if(not asmlib.UpdateListView(pnListView,frUsed)) then
        asmlib.LogInstance("Populate the list view failed",sLog); return nil end
      -- The button database export by type uses the current active type in the ListView line
      pnButton.DoClick = function(pnSelf)
        asmlib.LogInstance("Click "..asmlib.GetReport(pnSelf:GetText()), sLog..".Button")
        if(asmlib.GetAsmConvar("exportdb", "BUL")) then
          asmlib.SetAsmConvar(oPly, "exportdb", 0)
          if(inputIsKeyDown(KEY_LSHIFT)) then
            if(not asmlib.ExportSyncDB()) then
              asmlib.LogInstance("Export invalid", sLog..".Button"); return nil end
          else
            local fPref = "["..gsMoDB:lower().."-dsv]"..gsGenerPrf
            asmlib.ExportCategory(3, nil, fPref, true)
            asmlib.ExportDSV("PIECES", fPref, nil, true)
            asmlib.ExportDSV("ADDITIONS", fPref, nil, true)
            asmlib.ExportDSV("PHYSPROPERTIES", fPref, nil, true)
            asmlib.LogInstance("Export data", sLog..".Button")
          end
        else
          local fW = asmlib.GetOpVar("FORM_GITWIKI")
          guiOpenURL(fW:format("Additional-features"))
        end
      end
      pnButton.DoRightClick = function(pnSelf)
        if(asmlib.GetAsmConvar("exportdb", "BUL")) then
          asmlib.SetAsmConvar(oPly, "exportdb", 0)
          local bS, vOut = asmlib.DoAction("OPEN_EXTERNDB"); if(not bS) then
            asmlib.LogInstance("Open manager:"..vOut, sLog..".Button"); return nil end
          asmlib.LogInstance("Open manager", sLog..".Button")
        else
          local fW = asmlib.GetOpVar("FORM_GITWIKI")
          guiOpenURL(fW:format("Additional-features"))
        end
      end
      -- Leave the TextEntry here so it can access and update the local ListView reference
      pnTextEntry.OnEnter = function(pnSelf)
        local sPa = tostring(pnSelf:GetValue() or "")
        local sAbr, nID = pnComboBox:GetSelected() -- Returns two values
              sAbr, nID = tostring(sAbr or ""), (tonumber(nID) or 0)
        if(not asmlib.UpdateListView(pnListView, frUsed, nID, sPa)) then
          asmlib.LogInstance("Update ListView fail"..asmlib.GetReport(sAbr,nID,sPa), sLog..".TextEntry"); return nil
        end
      end
      pnFrame:SetVisible(true); pnFrame:Center(); pnFrame:MakePopup()
      conElements:Push(pnFrame); asmlib.LogInstance("Success",sLog); return nil
    end)

  asmlib.SetAction("DRAW_PHYSGUN",
    function() local sLog = "*DRAW_PHYSGUN"
      if(not asmlib.IsInit()) then return nil end
      if(not asmlib.GetAsmConvar("engunsnap", "BUL")) then
        asmlib.LogInstance("Extension disabled",sLog); return nil end
      if(not asmlib.GetAsmConvar("adviser", "BUL")) then
        asmlib.LogInstance("Adviser disabled",sLog); return nil end
      local oPly, acSw = asmlib.GetHookInfo("weapon_physgun")
      if(not oPly) then asmlib.LogInstance("Hook mismatch",sLog); return nil end
      local hasghost = asmlib.HasGhosts(); asmlib.FadeGhosts(true)
      if(not inputIsMouseDown(MOUSE_LEFT)) then
        if(hasghost) then timerSimple(0, asmlib.ClearGhosts) end
        asmlib.LogInstance("Physgun not hold",sLog); return nil
      end -- When the player is not holding the piece clear ghosts
      local actTr = asmlib.GetCacheTrace(oPly); if(not actTr) then
        asmlib.LogInstance("Trace missing",sLog); return nil end
      if(not actTr.Hit) then asmlib.LogInstance("Trace not hit",sLog); return nil end
      if(actTr.HitWorld) then asmlib.LogInstance("Trace world",sLog); return nil end
      local trEnt = actTr.Entity; if(not (trEnt and trEnt:IsValid())) then
        asmlib.LogInstance("Trace entity invalid",sLog); return nil end
      if(trEnt:GetNWBool(gsToolPrefL.."physgundisabled")) then
        asmlib.LogInstance("Trace entity physgun disabled",sLog); return nil end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel()); if(not trRec) then
        asmlib.LogInstance("Trace not piece",sLog); return nil end
      local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
      local actMonitor = asmlib.GetScreen(0,0,scrW,scrH,conPalette,"GAME")
      if(not actMonitor) then asmlib.LogInstance("Invalid screen",sLog); return nil end
      local atGhosts  = asmlib.GetOpVar("ARRAY_GHOST")
      local ghostcnt  = asmlib.GetAsmConvar("ghostcnt", "FLT")
      local igntype   = asmlib.GetAsmConvar("igntype" , "BUL")
      local spnflat   = asmlib.GetAsmConvar("spnflat" , "BUL")
      local activrad  = asmlib.GetAsmConvar("activrad", "FLT")
      local maxlinear = asmlib.GetAsmConvar("maxlinear","FLT")
      local sizeucs   = mathClamp(asmlib.GetAsmConvar("sizeucs", "FLT"),0,maxlinear)
      local nextx     = mathClamp(asmlib.GetAsmConvar("nextx"  , "FLT"),0,maxlinear)
      local nexty     = mathClamp(asmlib.GetAsmConvar("nexty"  , "FLT"),0,maxlinear)
      local nextz     = mathClamp(asmlib.GetAsmConvar("nextz"  , "FLT"),0,maxlinear)
      local nextpic   = mathClamp(asmlib.GetAsmConvar("nextpic", "FLT"),-gnMaxRot,gnMaxRot)
      local nextyaw   = mathClamp(asmlib.GetAsmConvar("nextyaw", "FLT"),-gnMaxRot,gnMaxRot)
      local nextrol   = mathClamp(asmlib.GetAsmConvar("nextrol", "FLT"),-gnMaxRot,gnMaxRot)
      for trID = 1, trRec.Size, 1 do
        local oTr, oDt = asmlib.GetTraceEntityPoint(trEnt, trID, activrad)
        if(oTr) then
          local xyS, xyE = oDt.start:ToScreen(), oDt.endpos:ToScreen()
          local rdS = asmlib.GetCacheRadius(oPly, oTr.HitPos, 1)
          if(oTr.Hit) then
            local tgE, xyH = oTr.Entity, oTr.HitPos:ToScreen()
            if(tgE and tgE:IsValid()) then
              actMonitor:DrawCircle(xyS, asmlib.GetViewRadius(oPly, oDt.start), "y", "SURF")
              actMonitor:DrawLine  (xyS, xyH, "g", "SURF")
              actMonitor:DrawCircle(xyH, asmlib.GetViewRadius(oPly, oTr.HitPos), "g")
              actMonitor:DrawLine  (xyH, xyE, "y")
              actSpawn = asmlib.GetEntitySpawn(oPly,tgE,oTr.HitPos,trRec.Slot,trID,activrad,
                           spnflat,igntype, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
              if(actSpawn) then -- When spawn data is availabe draw adviser
                if(asmlib.IsModel(trRec.Slot)) then -- The model has valid pre-cache
                  if(ghostcnt > 0) then -- The ghosting is enabled
                    if(not (hasghost and atGhosts.Size == 1 and trRec.Slot == atGhosts.Slot)) then
                      if(not asmlib.NewGhosts(1, trRec.Slot)) then
                        asmlib.LogInstance("Ghosting fail",sLog); return nil end
                    end local eGho = atGhosts[1]; eGho:SetNoDraw(false)
                    eGho:SetPos(actSpawn.SPos); eGho:SetAngles(actSpawn.SAng)
                  end -- When the ghosting is disabled saves memory
                  local xyO = actSpawn.OPos:ToScreen()
                  local xyB = actSpawn.BPos:ToScreen()
                  local xyS = actSpawn.SPos:ToScreen()
                  local xyP = actSpawn.TPnt:ToScreen()
                  actMonitor:DrawLine  (xyH, xyP, "g")
                  actMonitor:DrawCircle(xyP, asmlib.GetViewRadius(oPly, actSpawn.TPnt) / 2, "r")
                  actMonitor:DrawCircle(xyB, asmlib.GetViewRadius(oPly, actSpawn.BPos), "y")
                  actMonitor:DrawLine  (xyB, xyP, "r")
                  actMonitor:DrawLine  (xyB, xyO, "y")
                  -- Origin and spawn information
                  actMonitor:DrawLine  (xyO, xyS, "m")
                  actMonitor:DrawCircle(xyS, asmlib.GetViewRadius(oPly, actSpawn.SPos), "c")
                  -- Origin and base coordinate systems
                  actMonitor:DrawUCS(oPly, actSpawn.OPos, actSpawn.OAng, "SURF", {sizeucs, rdS})
                  actMonitor:DrawUCS(oPly, actSpawn.BPos, actSpawn.BAng)
                end
              else
                local tgRec = asmlib.CacheQueryPiece(tgE:GetModel())
                if(not asmlib.IsHere(tgRec)) then return nil end
                for tgI = 1, tgRec.Size do
                  local tgPOA = asmlib.LocatePOA(tgRec, tgI); if(not asmlib.IsHere(tgPOA)) then
                    asmlib.LogInstance("ID #"..tostring(ID).." not located",sLog); return nil end
                  actMonitor:DrawPOA(oPly, tgE, tgPOA, tgI, activrad)
                end
              end
            else
              actMonitor:DrawCircle(xyS, asmlib.GetViewRadius(oPly, oDt.start), "y", "SURF")
              actMonitor:DrawLine  (xyS, xyH, "y", "SURF")
              actMonitor:DrawCircle(xyH, asmlib.GetViewRadius(oPly, oTr.HitPos), "y")
              actMonitor:DrawLine  (xyH, xyE, "r")
            end
          else
            actMonitor:DrawCircle(xyS, asmlib.GetViewRadius(oPly, oDt.start), "y", "SURF")
            actMonitor:DrawLine  (xyS, xyE, "r", "SURF")
          end
        else
          local nRad = asmlib.GetCacheRadius(oPly, actTr.HitPos)
          for ID = 1, trRec.Size do
            local stPOA = asmlib.LocatePOA(trRec, ID); if(not stPOA) then
              asmlib.LogInstance("Cannot locate #"..tostring(ID), sLog); return end
            actMonitor:DrawPOA(oPly, trEnt, stPOA, ID, 0, false)
          end
        end
      end
    end)

    asmlib.SetAction("TWEAK_PANEL", -- Updates the function if present. Returns it when missing
      function(tDat, ...) local tArg = {...} -- Third argument controls the behavior
        local fFoo, sLog = tArg[3], "*TWEAK_PANEL"
        local sDir, sSub = tostring(tArg[1]):lower(), tostring(tArg[2]):lower()
        local bS, lDir = pcall(tDat.Foo, sDir); if(not bS) then
          asmlib.LogInstance("Fail folder "..asmlib.GetReport(sDir, lDir), sLog); return end
        local bS, lSub = pcall(tDat.Foo, sSub); if(not bS) then
          asmlib.LogInstance("Fail subfolder "..asmlib.GetReport(sSub, lSub), sLog); return end
        local sKey = tDat.Key:format(sDir, sSub)
        if(asmlib.IsHere(fFoo)) then
          if(not isfunction(fFoo)) then
            asmlib.LogInstance("Miss function "..asmlib.GetReport(sDir, sSub, fFoo), sLog); return end
          if(not asmlib.IsHere(tDat.Bar[sDir])) then tDat.Bar[sDir] = {} end; tDat.Bar[sDir][sSub] = fFoo
          asmlib.LogInstance("Store "..asmlib.GetReport(sDir, sSub, fFoo), sLog)
          hookRemove(tDat.Hoo, sKey); hookAdd(tDat.Hoo, sKey, function()
            spawnmenuAddToolMenuOption(lDir, lSub, sKey, languageGetPhrase(tDat.Nam), "", "", fFoo) end)
        else
          if(not asmlib.IsHere(tDat.Bar[sDir])) then
            asmlib.LogInstance("Miss folder "..asmlib.GetReport(sDir), sLog); return end
          fFoo = tDat.Bar[sDir][sSub]; if(not asmlib.IsHere(fFoo)) then
            asmlib.LogInstance("Miss subfolder "..asmlib.GetReport(sDir, sSub), sLog); return end
          if(not isfunction(fFoo)) then
            asmlib.LogInstance("Miss function "..asmlib.GetReport(sDir, sSub, fFoo), sLog); return end
          asmlib.LogInstance("Cache "..asmlib.GetReport(sDir, sSub, fFoo), sLog); return fFoo
        end
      end,
      {
        Bar = {},
        Hoo = "PopulateToolMenu",
        Key = gsToolPrefL.."%s_%s",
        Nam = "tool."..gsToolNameL..".name",
        Foo = function(s) return s:gsub("^%l", stringUpper) end
      })
end

------------ INITIALIZE CONTEXT PROPERTIES ------------

local gsOptionsCM = gsToolPrefL.."context_menu"
local gsOptionsCV = gsToolPrefL.."context_values"
local gsOptionsLG = gsOptionsCM:gsub(gsToolPrefL, ""):upper()
local gtOptionsCM = {} -- This stores the context menu configuration
if(CLIENT) then -- Client specific control values
  gtOptionsCM.Order, gtOptionsCM.MenuIcon = 1600, asmlib.ToIcon(gsOptionsCM)
  gtOptionsCM.MenuLabel = languageGetPhrase("tool."..gsToolNameL..".name")
end
-- [1]: Translation language key
-- [2]: Flag to transmit the data to the server
-- [3]: Tells what is to be done with the value
-- [4]: Display when the data is available on the client
-- [5]: Network massage or assign the value to a player
local conContextMenu = asmlib.GetContainer("CONTEXT_MENU")
      conContextMenu:Push(
        {"tool."..gsToolNameL..".model", true,
          function(ePiece, oPly, oTr, sKey)
            local model = ePiece:GetModel()
            asmlib.SetAsmConvar(oPly, "model", model); return true
          end,
          function(ePiece, oPly, oTr, sKey)
            return tostring(ePiece:GetModel())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".bgskids", true,
          function(ePiece, oPly, oTr, sKey)
            local ski = asmlib.GetPropSkin(ePiece)
            local bgr = asmlib.GetPropBodyGroup(ePiece)
            asmlib.SetAsmConvar(oPly, "bgskids", bgr..gsSymDir..ski); return true
          end,
          function(ePiece, oPly, oTr, sKey)
            local ski = asmlib.GetPropSkin(ePiece)
            local bgr = asmlib.GetPropBodyGroup(ePiece)
            return tostring(bgr..gsSymDir..ski)
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".phyname", true,
          function(ePiece, oPly, oTr, sKey)
            local phPiece = ePiece:GetPhysicsObject()
            local physmater = phPiece:GetMaterial()
            asmlib.SetAsmConvar(oPly, "physmater", physmater); return true
          end, nil,
          function(ePiece)
            return tostring(ePiece:GetPhysicsObject():GetMaterial())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".mass", true,
          function(ePiece, oPly, oTr, sKey)
            local phPiece = ePiece:GetPhysicsObject()
            local mass = phPiece:GetMass()
            asmlib.SetAsmConvar(oPly, "mass", mass); return true
          end, nil,
          function(ePiece)
            return tonumber(ePiece:GetPhysicsObject():GetMass())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".ignphysgn", true,
          function(ePiece, oPly, oTr, sKey)
            local bSuc,bPi,bFr,bGr,sPh = asmlib.UnpackPhysicalSettings(ePiece)
            if(bSuc) then bPi = (not bPi) else return bSuc end
            return asmlib.ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
          end, nil,
          function(ePiece)
            return tobool(ePiece.PhysgunDisabled)
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".freeze", true,
          function(ePiece, oPly, oTr, sKey)
            local bSuc,bPi,bFr,bGr,sPh = asmlib.UnpackPhysicalSettings(ePiece)
            if(bSuc) then bFr = (not bFr) else return bSuc end
            return asmlib.ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
          end, nil,
          function(ePiece)
            return tobool(not ePiece:GetPhysicsObject():IsMotionEnabled())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".gravity", true,
          function(ePiece, oPly, oTr, sKey)
            local bSuc,bPi,bFr,bGr,sPh = asmlib.UnpackPhysicalSettings(ePiece)
            if(bSuc) then bGr = (not bGr) else return bSuc end
            return asmlib.ApplyPhysicalSettings(ePiece,bPi,bFr,bGr,sPh)
          end, nil,
          function(ePiece)
            return tobool(ePiece:GetPhysicsObject():IsGravityEnabled())
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".weld", true,
          function(ePiece, oPly, oTr, sKey)
            if(oPly:KeyDown(IN_SPEED)) then
              local tCn, ID = constraintFindConstraints(ePiece, "Weld"), 1
              while(tCn and tCn[ID]) do local eCn = tCn[ID].Constraint
                if(eCn and eCn:IsValid()) then eCn:Remove() end; ID = (ID + 1)
              end; asmlib.Notify(oPly,"Removed: Welds !","CLEANUP"); return true
            else
              local sAnch = oPly:GetInfo(gsToolPrefL.."anchor", gsNoAnchor)
              local tAnch = gsSymRev:Explode(sAnch)
              local nAnch = tonumber(tAnch[1]); if(not asmlib.IsHere(nAnch)) then
                asmlib.Notify(oPly,"Anchor: Mismatch "..sAnch.." !","ERROR") return false end
              local eBase = entsGetByIndex(nAnch); if(not (eBase and eBase:IsValid())) then
                asmlib.Notify(oPly,"Entity: Missing "..tostring(nAnch).." !","ERROR") return false end
              local maxforce = asmlib.GetAsmConvar("maxforce", "FLT")
              local forcelim = mathClamp(oPly:GetInfoNum(gsToolPrefL.."forcelim", 0), 0, maxforce)
              local bSuc, cnW, cnN, cnG = asmlib.ApplyPhysicalAnchor(ePiece,eBase,true,false,false,forcelim)
              if(bSuc and cnW and cnW:IsValid()) then
                local sIde = ePiece:EntIndex()..gsSymDir..eBase:EntIndex()
                asmlib.UndoCrate("TA Weld > "..asmlib.GetReport(sIde,cnW:GetClass()))
                asmlib.UndoAddEntity(cnW); asmlib.UndoFinish(oPly); return true
              end; return false
            end
          end, nil,
          function(ePiece)
            local tCn = constraintFindConstraints(ePiece, "Weld"); return #tCn
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".nocollide", true,
          function(ePiece, oPly, oTr, sKey)
            if(oPly:KeyDown(IN_SPEED)) then
              local tCn, ID = constraintFindConstraints(ePiece, "NoCollide"), 1
              while(tCn and tCn[ID]) do local eCn = tCn[ID].Constraint
                if(eCn and eCn:IsValid()) then eCn:Remove() end; ID = (ID + 1)
              end; asmlib.Notify(oPly,"Removed: NoCollides !","CLEANUP"); return true
            else -- Get anchor prop
              local sAnch = oPly:GetInfo(gsToolPrefL.."anchor", gsNoAnchor)
              local tAnch = gsSymRev:Explode(sAnch)
              local nAnch = tonumber(tAnch[1]); if(not asmlib.IsHere(nAnch)) then
                asmlib.Notify(oPly,"Anchor: Mismatch "..sAnch.." !","ERROR") return false end
              local eBase = entsGetByIndex(nAnch); if(not (eBase and eBase:IsValid())) then
                asmlib.Notify(oPly,"Entity: Missing "..nAnch.." !","ERROR") return false end
              local maxforce = asmlib.GetAsmConvar("maxforce", "FLT")
              local forcelim = mathClamp(oPly:GetInfoNum(gsToolPrefL.."forcelim", 0), 0, maxforce)
              local bSuc, cnW, cnN, cnG = asmlib.ApplyPhysicalAnchor(ePiece,eBase,false,true,false,forcelim)
              if(bSuc and cnN and cnN:IsValid()) then
                local sIde = ePiece:EntIndex()..gsSymDir..eBase:EntIndex()
                asmlib.UndoCrate("TA NoCollide > "..asmlib.GetReport(sIde,cnN:GetClass()))
                asmlib.UndoAddEntity(cnN); asmlib.UndoFinish(oPly); return true
              end; return false
            end
          end, nil,
          function(ePiece)
            local tCn = constraintFindConstraints(ePiece, "NoCollide"); return #tCn
          end
        })
      conContextMenu:Push(
        {"tool."..gsToolNameL..".nocollidew", true,
          function(ePiece, oPly, oTr, sKey)
            if(oPly:KeyDown(IN_SPEED)) then
              local eCn = constraintFind(ePiece, gameGetWorld(), "AdvBallsocket", 0, 0)
              if(eCn and eCn:IsValid()) then eCn:Remove()
                asmlib.Notify(oPly,"Removed: NoCollideWorld !","CLEANUP")
              else asmlib.Notify(oPly,"Missing: NoCollideWorld !","CLEANUP") end
            else
              local maxforce = asmlib.GetAsmConvar("maxforce", "FLT")
              local forcelim = mathClamp(oPly:GetInfoNum(gsToolPrefL.."forcelim", 0), 0, maxforce)
              local bSuc, cnW, cnN, cnG = asmlib.ApplyPhysicalAnchor(ePiece,nil,false,false,true,forcelim)
              if(bSuc and cnG and cnG:IsValid()) then
                asmlib.UndoCrate("TA NoCollideWorld > "..asmlib.GetReport(ePiece:EntIndex(),cnG:GetClass()))
                asmlib.UndoAddEntity(cnG); asmlib.UndoFinish(oPly); return true
              end; return false
            end
          end, nil,
          function(ePiece)
            local eCn = constraintFind(ePiece, gameGetWorld(), "AdvBallsocket", 0, 0)
            return tobool(eCn and eCn:IsValid())
          end
        })

if(SERVER) then
  -- [1] : End time to send the client request
  -- [2] : End time to draw the user notification
  local function PopulateEntity(nLen, oPly)
    local dTim = asmlib.GetOpVar("MSDELTA_SEND")
    local tHov = asmlib.GetOpVar("HOVER_TRIGGER")
    local pTim, cTim, nDel = tHov[oPly], Time(), 15
    if(not pTim) then pTim = {cTim, (nDel + cTim)}; tHov[oPly] = pTim end
    if(dTim == 0 or (dTim > 0 and cTim > (pTim[1] + dTim))) then
      if(cTim > pTim[2]) then pTim[2] = (cTim + nDel) end
      pTim[1] = cTim -- Raise the flag to notify the flooding client
      local oEnt, sLog = netReadEntity(), "*POPULATE_ENTITY" -- Logs identifier
      local sNoA = asmlib.GetOpVar("MISS_NOAV") -- String to put when not present
      asmlib.LogInstance("Populate:"..tostring(oEnt), sLog) -- Draw the entity log
      for iD = 1, conContextMenu:GetSize() do   -- Loop the context menu entries
        local tLine = conContextMenu:Select(iD) -- Grab the value from the container
        local sKey, wDraw = tLine[1], tLine[5]  -- Extract the key and handler
        if(type(wDraw) == "function") then      -- Check when the value is function
          local bS, vO = pcall(wDraw, oEnt); vO = tostring(vO) -- Always being string
          if(not bS) then oEnt:SetNWString(sKey, sNoA)
            asmlib.LogInstance("Populate:"..asmlib.GetReport(sKey,iD).." fail: "..vO, sLog)
          else
            asmlib.LogInstance("Populate:"..asmlib.GetReport(sKey,iD,vO), sLog)
            oEnt:SetNWString(sKey, vO) -- Write networked value to the hover entity
          end
        end
      end
    else
      if(cTim > pTim[2]) then
        asmlib.Notify(oPly,"Do not rush the context menu!","UNDO")
        pTim[2] = (cTim + nDel) -- For given amount of seconds
      end
    end
  end
  utilAddNetworkString(gsOptionsCV)
  netReceive(gsOptionsCV, PopulateEntity)
end

if(CLIENT) then
  asmlib.SetAction("UPDATE_CONTEXTVAL", -- Must have the same parameters as the hook
    function() local sLog = "*UPDATE_CONTEXTVAL"
      if(not asmlib.IsInit()) then return nil end
      if(not asmlib.IsFlag("tg_context_menu")) then return nil end -- Menu not opened
      if(not asmlib.GetAsmConvar("enctxmenu", "BUL")) then return nil end -- Menu not enabled
      local oPly = LocalPlayer(); if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Player invalid "..asmlib.GetReport(oPly)..">", sLog); return nil end
      local vEye, vAim, tTrig = EyePos(), oPly:GetAimVector(), asmlib.GetOpVar("HOVER_TRIGGER")
      local oEnt = propertiesGetHovered(vEye, vAim); tTrig[2] = tTrig[1]; tTrig[1] = oEnt
      if(asmlib.IsOther(oEnt) or tTrig[1] == tTrig[2]) then return nil end -- Entity trigger
      if(not asmlib.GetAsmConvar("enctxmall", "BUL")) then -- Enable for all props
        local oRec = asmlib.CacheQueryPiece(oEnt:GetModel())
        if(not asmlib.IsHere(oRec)) then return nil end
      end -- If the menu is not enabled for all props ged-a-ud!
      netStart(gsOptionsCV); netWriteEntity(oEnt); netSendToServer() -- Love message
      asmlib.LogInstance("Entity "..asmlib.GetReport(oEnt:GetClass(),oEnt:EntIndex()), sLog)
    end) -- Read client configuration
end

-- This filters what the context menu is available for
gtOptionsCM.Filter = function(self, ent, ply)
  if(asmlib.IsOther(ent)) then return false end
  if(not (ply and ply:IsValid())) then return false end
  if(not gamemodeCall("CanProperty", ply, gsOptionsCM, ent)) then return false end
  if(not asmlib.GetAsmConvar("enctxmenu", "BUL")) then return false end
  if(not asmlib.GetAsmConvar("enctxmall", "BUL")) then
    local oRec = asmlib.CacheQueryPiece(ent:GetModel())
    if(not asmlib.IsHere(oRec)) then return false end
  end -- If the menu is not enabled for all props check for track and ged-a-ud!
  return true -- The entity is track piece and TA menu is available
end
-- The routine which builds the context menu
gtOptionsCM.MenuOpen = function(self, opt, ent, tr)
  local oPly, pnSub = LocalPlayer(), opt:AddSubMenu(); if(not IsValid(pnSub)) then
    asmlib.LogInstance("Invalid context menu",gsOptionsLG); return end
  local fHash = (gsToolNameL.."%.(.*)$")
  for iD = 1, conContextMenu:GetSize() do
    local tLine = conContextMenu:Select(iD)
    local sKey , fDraw = tLine[1], tLine[4]
    local wDraw, sIcon = tLine[5], sKey:match(fHash)
    local sName = languageGetPhrase(sKey.."_con"):Trim():Trim(":")
    if(isfunction(fDraw)) then
      local bS, vE = pcall(fDraw, ent, oPly, tr, sKey); if(not bS) then
        asmlib.LogInstance("Request "..asmlib.GetReport(sKey,iD).." fail: "..vE,gsOptionsLG); return end
      sName = sName..": "..tostring(vE)          -- Attach client value ( CLIENT )
    elseif(isfunction(wDraw)) then
      sName = sName..": "..ent:GetNWString(sKey) -- Attach networked value ( SERVER )
    end; local fEval = function() self:Evaluate(ent,iD,tr,sKey) end
    local pnOpt = pnSub:AddOption(sName, fEval); if(not IsValid(pnOpt)) then
      asmlib.LogInstance("Invalid "..asmlib.GetReport(sKey,iD),gsOptionsLG); return end
    if(not asmlib.IsBlank(sIcon)) then pnOpt:SetIcon(asmlib.ToIcon(sIcon)) end
  end
end
-- Not used. Use the evaluate function instead
gtOptionsCM.Action = function(self, ent, tr) end
-- Use the custom evaluation function with index and key arguments
gtOptionsCM.Evaluate = function(self, ent, idx, key)
  local tLine = conContextMenu:Select(idx); if(not tLine) then
    asmlib.LogInstance("Skip "..asmlib.GetReport(idx),gsOptionsLG); return end
  local sKey, bTrans, fHandle = tLine[1], tLine[2], tLine[3]
  if(bTrans) then -- Transfer to SERVER
    self:MsgStart()
      netWriteEntity(ent)
      netWriteUInt(idx, 8)
    self:MsgEnd()
  else -- Call on the CLIENT
    local oPly = LocalPlayer()
    local oTr  = oPly:GetEyeTrace()
    local bS, vE = pcall(fHandle,ent,oPly,oTr,key); if(not bS) then
      asmlib.LogInstance("Request "..asmlib.GetReport(sKey,idx).." fail: "..vE,gsOptionsLG); return end
    if(bS and not vE) then asmlib.LogInstance("Failure "..asmlib.GetReport(sKey,idx),gsOptionsLG); return end
  end
end
-- What to happen on the server with our entity
gtOptionsCM.Receive = function(self, len, ply)
  local ent = netReadEntity()
  local idx = netReadUInt(8)
  local oTr = ply:GetEyeTrace()
  local tLine = conContextMenu:Select(idx); if(not tLine) then
    asmlib.LogInstance("Mismatch "..asmlib.GetReport(idx),gsOptionsLG); return end
  if(not self:Filter(ent, ply)) then return end
  if(not propertiesCanBeTargeted(ent, ply)) then return end
  local sKey, fHandle = tLine[1], tLine[3] -- Menu function handler
  local bS, vE = pcall(fHandle, ent, ply, oTr, sKey); if(not bS) then
    asmlib.LogInstance("Request "..asmlib.GetReport(sKey,idx).." fail: "..vE,gsOptionsLG); return end
  if(bS and not vE) then asmlib.LogInstance("Failure "..asmlib.GetReport(sKey,idx),gsOptionsLG); return end
end
-- Register the track assembly setup options in the context menu
propertiesAdd(gsOptionsCM, gtOptionsCM)

------------ INITIALIZE DB------------

asmlib.NewTable("PIECES",{
  Timer = gaTimerSet[1],
  Index = {{1,4,Un=true},{1},{2},{4}},
  Query = {
    ExportDSV       = {O = {2,3,1,4}},
    CacheQueryPiece = {W = {{1,"%s"}}, O = {4}},
    ExportTypeDSV   = {W = {{2,"%s"}}, O = {3,1,4}},
    ExportTypeRun   = {W = {{2,"%s"}}, O = {3,1,4}},
    Record          = {"%s","%s","%s","%d","%s","%s","%s","%s"},
    CacheQueryTree  = {S = {1,2,3}, W = {{4,"%d"}}, O = {2,3,1}},
    ExportSyncDB    = {S = {1,2,3}, W = {{4,"%d"}}, O = {2,3,1}}
  },
  Trigs = {
    Record = function(arLine, vSrc)
      local noMD  = asmlib.GetOpVar("MISS_NOMD")
      local noTY  = asmlib.GetOpVar("MISS_NOTP")
      local noSQL = asmlib.GetOpVar("MISS_NOSQL")
      local trCls = asmlib.GetOpVar("TRACE_CLASS")
      local emFva = asmlib.GetOpVar("EMPTYSTR_BLDS")
      arLine[2] = asmlib.GetEmpty(arLine[2], emFva, asmlib.Categorize(), noTY)
      arLine[3] = asmlib.GetEmpty(arLine[3], emFva, asmlib.ModelToName(arLine[1]), noMD)
      arLine[5] = asmlib.GetEmpty(arLine[5], asmlib.IsBlank, noSQL)
      arLine[6] = asmlib.GetEmpty(arLine[6], asmlib.IsBlank, noSQL)
      arLine[7] = asmlib.GetEmpty(arLine[7], asmlib.IsBlank, noSQL)
      arLine[8] = asmlib.GetEmpty(arLine[8], emFva, noSQL)
      if(not (asmlib.IsNull(arLine[8]) or asmlib.IsBlank(arLine[8]) or trCls[arLine[8]])) then
        asmlib.LogInstance("Register trace "..asmlib.GetReport(arLine[8],arLine[1]),vSrc)
        trCls[arLine[8]] = true; -- Register the class provided to the trace hit list
      end; return true
    end
  },
  Cache = {
    Record = function(makTab, tCache, snPK, arLine, vSrc)
      local defTab = makTab:GetDefinition()
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Used)) then stData.Used = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      if(not asmlib.IsHere(stData.Type)) then stData.Type = arLine[2] end
      if(not asmlib.IsHere(stData.Name)) then stData.Name = arLine[3] end
      if(not asmlib.IsHere(stData.Unit)) then stData.Unit = arLine[8] end
      local nOffsID = makTab:Match(arLine[4],4); if(not asmlib.IsHere(nOffsID)) then
        asmlib.LogInstance("Cannot match "..asmlib.GetReport(4,arLine[4],snPK),vSrc); return false end
      if(nOffsID ~= (stData.Size + 1)) then
        asmlib.LogInstance("Sequential mismatch "..asmlib.GetReport(nOffsID,snPK),vSrc); return false end
      local stPOA = asmlib.RegisterPOA(stData,nOffsID,arLine[5],arLine[6],arLine[7])
      if(not asmlib.IsHere(stPOA)) then
        asmlib.LogInstance("Cannot process "..asmlib.GetReport(nOffsID, snPK),vSrc); return false end
      stData.Size = stData.Size + 1; return true
    end,
    ExportSyncDB = function(oFile, makTab, tCache, sDelim, vSrc)
      local tSort, cT = asmlib.Arrange(tCache, "Type", "Name", "Slot"), nil
      if(not tSort) then asmlib.LogInstance("Cannot sort cache data",vSrc); return false end
      for iS = 1, tSort.Size do local stRec = tSort[iS]
        local sKey, vRec = stRec.Key, stRec.Rec
        if(not cT or cT ~= vRec.Type) then cT = vRec.Type
          local sW = tostring(asmlib.WorkshopID(cT) or sMiss)
          oFile:Write("# Categorize("..cT.."): "..sW.."\n")
        end
        oFile:Write(makTab:Match(vRec.Slot,1,true,"\"")..sDelim)
        oFile:Write(makTab:Match(vRec.Type,2,true,"\"")..sDelim)
        oFile:Write(makTab:Match(vRec.Name,3,true,"\"")); oFile:Write("\n")
      end; return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSrc)
      local defTab = makTab:GetDefinition()
      local tSort = asmlib.Arrange(tCache, "Type", "Name", "Slot"); if(not tSort) then
        asmlib.LogInstance("("..fPref..") Cannot sort cache data",vSrc); return false end
      local noSQL = asmlib.GetOpVar("MISS_NOSQL")
      local symOff = asmlib.GetOpVar("OPSYM_DISABLE")
      local sClass = asmlib.GetOpVar("ENTITY_DEFCLASS")
      for iR = 1, tSort.Size do
        local stRec = tSort[iR]
        local tData = tCache[stRec.Key]
        local sData, tOffs = defTab.Name, tData.Offs
              sData = sData..sDelim..makTab:Match(stRec.Key,1,true,"\"")..sDelim..
                makTab:Match(tData.Type,2,true,"\"")..sDelim..
                makTab:Match(tData.Name,3,true,"\"")
        -- Matching crashes only for numbers. The number is already inserted, so there will be no crash
        for iD = 1, #tOffs do
          local stPnt = tOffs[iD] -- Read current offsets from the model
          local sP, sO, sA = stPnt.P:Export(stPnt.O), stPnt.O:Export(), stPnt.A:Export()
          local sC = (asmlib.IsHere(tData.Unit) and tostring(tData.Unit) or noSQL)
                sC = ((sC == sClass) and noSQL or sC) -- Export default class as noSQL
          oFile:Write(sData..sDelim..makTab:Match(iD,4,true,"\"")..sDelim)
          oFile:Write("\""..sP.."\""..sDelim.."\""..sO.."\""..sDelim)
          oFile:Write("\""..sA.."\""..sDelim.."\""..sC.."\"\n")
        end
      end; return true
    end,
    ExportTypeDSV = function(fP, makP, PCache, fA, makA, ACache, fPref, sDelim, vSrc)
      local tSort = asmlib.Arrange(PCache, "Name", "Slot"); if(not tSort) then
        asmlib.LogInstance("("..fPref..") Cannot sort cache data",vSrc); return false end
      local defP, defA = makP:GetDefinition(), makA:GetDefinition()
      local noSQL = asmlib.GetOpVar("MISS_NOSQL")
      local symOff = asmlib.GetOpVar("OPSYM_DISABLE")
      local sClass = asmlib.GetOpVar("ENTITY_DEFCLASS")
      for iP = 1, tSort.Size do
        local stRec = tSort[iP]
        local tData = PCache[stRec.Key]
        local sPref = tData.Type:gsub("[^%w]","_"):lower()
        if(sPref == fPref) then
          local sData, tOffs = defP.Name, tData.Offs
                sData = sData..sDelim..makP:Match(stRec.Key,1,true,"\"")..sDelim..
                  makP:Match(tData.Type,2,true,"\"")..sDelim..
                  makP:Match(tData.Name,3,true,"\"")
          -- Matching crashes only for numbers. The number is already inserted, so there will be no crash
          for iD = 1, #tOffs do
            local stPnt = tOffs[iD] -- Read current offsets from the model
            local sP, sO, sA = stPnt.P:Export(stPnt.O), stPnt.O:Export(), stPnt.A:Export()
            local sC = (asmlib.IsHere(tData.Unit) and tostring(tData.Unit) or noSQL)
                  sC = ((sC == sClass) and noSQL or sC) -- Export default class as noSQL
            fP:Write(sData..sDelim..makP:Match(iD,4,true,"\""))
            fP:Write(sDelim.."\""..sP.."\""..sDelim.."\""..sO.."\"")
            fP:Write(sDelim.."\""..sA.."\""..sDelim.."\""..sC.."\"\n")
            if(iD == 1) then
              local tA = ACache[stRec.Key]
              if(tA and tA.Size and tA.Size > 0) then
                local sH = defA.Name..sDelim..makA:Match(stRec.Key,1,true,"\"")
                for iA = 1, tA.Size do fA:Write(sH) for iC = 2, defA.Size do
                  local sC = defA[iC][1]
                  local vC = tA[iA][sC]
                  fA:Write(sDelim..makA:Match(vC,iC,true,"\""))
                end fA:Write("\n") end
              end
            end
          end
        end
      end; return true
    end,
    ExportTypeRun = function(fE, fS, sType, makP, PCache, qPieces, vSrc)
      local coMo, coTy = makP:GetColumnName(1), makP:GetColumnName(2)
      local coNm, coLn = makP:GetColumnName(3), makP:GetColumnName(4)
      local coP , coO  = makP:GetColumnName(5), makP:GetColumnName(6)
      local coA , coC  = makP:GetColumnName(7), makP:GetColumnName(8)
      local sClass, iCnt = asmlib.GetOpVar("ENTITY_DEFCLASS"), 0
      for mod, rec in pairs(PCache) do
        if(rec.Type == sType) then
          local iID, tOffs = 1, rec.Offs -- Start from the first point
          local rPOA = tOffs[iID]; if(not asmlib.IsHere(rPOA)) then
            asmlib.LogInstance("Missing point ID "..asmlib.GetReport(iID, rec.Slot),vSrc) return false end
          for iID = 1, rec.Size do
            iCnt = (iCnt + 1); qPieces[iCnt] = {} -- Allocate row memory
            local qRow = qPieces[iCnt]; rPOA = tOffs[iID]
            local sP, sO, sA = rPOA.P:Export(rPOA.O), rPOA.O:Export(), rPOA.A:Export()
            local sC = (asmlib.IsHere(rec.Unit) and tostring(rec.Unit) or noSQL)
                  sC = ((sC == sClass) and noSQL or sC) -- Export default class as noSQL
            qRow[coMo] = rec.Slot
            qRow[coTy] = rec.Type
            qRow[coNm] = rec.Name
            qRow[coLn] = iID
            qRow[coP ] = sP; qRow[coO ] = sO
            qRow[coA ] = sA; qRow[coC ] = sC
          end
        end
      end -- Must be the same format as returned from SQL
      local tSort = asmlib.Arrange(qPieces, coNm, coMo, coLn); if(not tSort) then
        LogInstance("Sort cache mismatch",vSrc); return false
      end; tableEmpty(qPieces)
      for iD = 1, tSort.Size do qPieces[iD] = tSort[iD].Rec end
      asmlib.LogInstance("Sorted rows count "..asmlib.GetReport(tSort.Size, sType),vSrc)
      return true
    end,
    ExportContentsRun = function(aRow) aRow[2], aRow[4] = "myType", "gsSymOff"; return true end
  },
  [1] = {"MODEL" , "TEXT"   , "LOW", "QMK"},
  [2] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [3] = {"NAME"  , "TEXT"   ,  nil , "QMK"},
  [4] = {"LINEID", "INTEGER", "FLR",  nil },
  [5] = {"POINT" , "TEXT"   ,  nil ,  nil },
  [6] = {"ORIGIN", "TEXT"   ,  nil ,  nil },
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil },
  [8] = {"CLASS" , "TEXT"   ,  nil ,  nil }
},true,true)

asmlib.NewTable("ADDITIONS",{
  Timer = gaTimerSet[2],
  Index = {{1,4,Un=true},{1},{4}},
  Query = {
    ExportDSV           = {O = {1,4}},
    SetAdditionsRun     = {W = {{1,"%s"}}, O = {4}},
    CacheQueryAdditions = {W = {{1,"%s"}}, O = {4}},
    ExportTypeDSV       = {W = {{1,"%s"}}, O = {1,4}},
    Record              = {"%s","%s","%s","%d","%s","%s","%d","%d","%d","%d","%d","%d"}
  },
  Cache = {
    Record = function(makTab, tCache, snPK, arLine, vSrc)
      local defTab = makTab:GetDefinition()
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      local iID = makTab:Match(arLine[4],4); if(not asmlib.IsHere(iID)) then
        asmlib.LogInstance("Cannot match "..asmlib.GetReport(4,arLine[4],snPK),vSrc); return false end
      if(iID ~= (stData.Size + 1)) then
        asmlib.LogInstance("Sequential mismatch "..asmlib.GetReport(iID,snPK),vSrc); return false end
      stData[iID] = {} -- LineID has to be set properly
      for iCnt = 2, defTab.Size do local sC = makTab:GetColumnName(iCnt); if(not sC) then
        asmlib.LogInstance("Cannot index "..asmlib.GetReport(iCnt,snPK),vSrc); return false end
        stData[iID][sC] = makTab:Match(arLine[iCnt],iCnt); if(not asmlib.IsHere(stData[iID][sC])) then
          asmlib.LogInstance("Cannot match "..asmlib.GetReport(iCnt,arLine[iCnt],snPK),vSrc); return false end
      end; stData.Size = stData.Size + 1; return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSrc)
      local defTab = makTab:GetDefinition()
      local tSort = asmlib.Arrange(tCache, "Slot")
      for iRow = 1, tSort.Size do
        local tRow = tSort[iRow]
        local sKey, tRec = tRow.Key, tRow.Rec
        local sData = defTab.Name..sDelim..makTab:Match(sKey,1,true,"\"")
        for iRec = 1, #tRec do
          local vRec = tRec[iRec]; oFile:Write(sData)
          for iID = 2, defTab.Size do
            local sC = makTab:GetColumnName(iID); if(not sC) then
              asmlib.LogInstance("Cannot index "..asmlib.GetReport(iID,sKey),vSrc); return false end
            local vData = vRec[sC]; if(not sC) then
              asmlib.LogInstance("Cannot extract "..asmlib.GetReport(iID,sKey),vSrc); return false end
            local vM = makTab:Match(vData,iID,true,"\""); if(not asmlib.IsHere(vM)) then
              asmlib.LogInstance("Cannot match "..asmlib.GetReport(iID,vData)); return false
            end; oFile:Write(sDelim..tostring(vM or ""))
          end; oFile:Write("\n") -- Data is already inserted, there will be no crash
        end
      end; return true
    end,
    ExportContentsRun = function(aRow) aRow[4] = "gsSymOff"; return true end
  },
  [1]  = {"MODELBASE", "TEXT"   , "LOW", "QMK"},
  [2]  = {"MODELADD" , "TEXT"   , "LOW", "QMK"},
  [3]  = {"ENTCLASS" , "TEXT"   ,  nil ,  nil },
  [4]  = {"LINEID"   , "INTEGER", "FLR",  nil },
  [5]  = {"POSOFF"   , "TEXT"   ,  nil ,  nil },
  [6]  = {"ANGOFF"   , "TEXT"   ,  nil ,  nil },
  [7]  = {"MOVETYPE" , "INTEGER", "FLR",  nil },
  [8]  = {"PHYSINIT" , "INTEGER", "FLR",  nil },
  [9]  = {"DRSHADOW" , "INTEGER", "FLR",  nil },
  [10] = {"PHMOTION" , "INTEGER", "FLR",  nil },
  [11] = {"PHYSLEEP" , "INTEGER", "FLR",  nil },
  [12] = {"SETSOLID" , "INTEGER", "FLR",  nil },
},true,true)

asmlib.NewTable("PHYSPROPERTIES",{
  Timer = gaTimerSet[3],
  Index = {{1,2,Un=true},{1},{2}},
  Query = {
    Record    = {"%s","%d","%s"},
    ExportDSV = {O = {1,2}},
    CacheQueryProperty = {
      N = {S = {2, 3}, W = {{1,"%s"}}, O = {2}},
      T = {S = {1}   , W = {{2,"%s"}}, O = {1}},
    }
  },
  Trigs = {
    Record = function(arLine, vSrc)
      local noTY = asmlib.GetOpVar("MISS_NOTP")
      local emFva = asmlib.GetOpVar("EMPTYSTR_BLDS")
      arLine[1] = asmlib.GetEmpty(arLine[1], emFva, asmlib.Categorize(), noTY); return true
    end
  },
  Cache = {
    Record = function(makTab, tCache, snPK, arLine, vSrc)
      local skName = asmlib.GetOpVar("HASH_PROPERTY_NAMES")
      local skType = asmlib.GetOpVar("HASH_PROPERTY_TYPES")
      local tTypes = tCache[skType]; if(not tTypes) then
        tCache[skType] = {}; tTypes = tCache[skType]; tTypes.Size = 0 end
      local tNames = tCache[skName]; if(not tNames) then
        tCache[skName] = {}; tNames = tCache[skName] end
      local iNameID = makTab:Match(arLine[2],2); if(not asmlib.IsHere(iNameID)) then
        asmlib.LogInstance("Cannot match "..asmlib.GetReport(2,arLine[2],snPK),vSrc); return false end
      if(not asmlib.IsHere(tNames[snPK])) then -- If a new type is inserted
        tTypes.Size = (tTypes.Size + 1)
        tTypes[tTypes.Size] = snPK; tNames[snPK] = {}
        tNames[snPK].Size, tNames[snPK].Slot = 0, snPK
      end -- Data matching crashes only on numbers
      if(iNameID ~= (tNames[snPK].Size + 1)) then
        asmlib.LogInstance("Sequential mismatch "..asmlib.GetReport(iNameID,snPK),vSrc); return false end
      tNames[snPK].Size = tNames[snPK].Size + 1
      tNames[snPK][iNameID] = makTab:Match(arLine[3],3); return true
    end,
    ExportDSV = function(oF, makTab, tCache, fPref, sDelim, vSrc)
      local defTab = makTab:GetDefinition()
      local pT = asmlib.GetOpVar("HASH_PROPERTY_TYPES")
      local pN = asmlib.GetOpVar("HASH_PROPERTY_NAMES")
      local tTypes, tNames, tT = tCache[pT], tCache[pN], {}
      if(not (tTypes or tNames)) then
        asmlib.LogInstance("("..fPref..") No data found",vSrc); return false end
      for iD = 1, tTypes.Size do tableInsert(tT, tTypes[iD]) end
      local tS = asmlib.Arrange(tT); if(not tS) then
        asmlib.LogInstance("("..fPref..") Cannot sort cache data",vSrc); return false end
      for iS = 1, tS.Size do local sT = tS[iS].Rec
        local tProp = tNames[sT]; if(not tProp) then
          asmlib.LogInstance("("..fPref..") Missing index "..asmlib.GetReport(iS, sT),vSrc); return false end
        for iP = 1, tProp.Size do local sP = tProp[iP]
          oF:Write(defTab.Name..sDelim..makTab:Match(sT,1,true,"\"")..
                                sDelim..makTab:Match(iP,2,true,"\"")..
                                sDelim..makTab:Match(sP,3,true,"\"").."\n")
        end
      end; return true
    end,
    ExportContentsRun = function(aRow) aRow[1], aRow[2] = "myType", "gsSymOff"; return true end
  },
  [1] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [2] = {"LINEID", "INTEGER", "FLR",  nil },
  [3] = {"NAME"  , "TEXT"   ,  nil ,  nil }
},true,true)

------------ POPULATE DB ------------

--[[ Categories are only needed client side ]]--
if(CLIENT) then
  if(fileExists(gsGenerDSV.."CATEGORY.txt", "DATA")) then
    asmlib.LogInstance("DB CATEGORY from GENERIC",gtInitLogs)
    asmlib.ImportCategory(3, gsGenerPrf)
  else asmlib.LogInstance("DB CATEGORY from LUA",gtInitLogs) end
end

--[[ Track pieces parameterization legend
 * Utilizing a transform attachment is done by using "OPSYM_ENTPOSANG"
 * Disabling a component is preformed by using "OPSYM_DISABLE"
 * Active points data are strings of floats delimited by "OPSYM_SEPARATOR"
 * Disabling P     - The ID search point is treated as taking the origin
 * Disabling O     - The ID snap origin is treated as {0,0,0} vector
 * Disabling A     - The ID snap angle is treated as {0,0,0} angle
 * Disabling Type  - Makes it use the value of Categorize()
 * Disabling Name  - Makes it generate it using the model via ModelToName()
 * Disabling Class - Makes it use the default /prop_physics/
 * First  argument of Categorize() is used to provide default track type for TABLE:Record()
 * Second argument of Categorize() is used to generate track categories for the processed addon
]]--
if(fileExists(gsGenerDSV.."PIECES.txt", "DATA")) then
  asmlib.LogInstance("DB PIECES from GENERIC",gtInitLogs)
  asmlib.ImportDSV("PIECES", true, gsGenerPrf)
else
  if(gsMoDB == "SQL") then sqlBegin() end
  asmlib.LogInstance("DB PIECES from LUA",gtInitLogs)
  local PIECES = asmlib.GetBuilderNick("PIECES"); asmlib.ModelToNameRule("CLR")
  if(asmlib.GetAsmConvar("devmode" ,"BUL")) then
    asmlib.Categorize("Develop Sprops")
    PIECES:Record({"models/sprops/cuboids/height06/size_1/cube_6x6x6.mdl"   , "#", "x1", 1})
    PIECES:Record({"models/sprops/cuboids/height12/size_1/cube_12x12x12.mdl", "#", "x2", 1})
    PIECES:Record({"models/sprops/cuboids/non_set/cube_18x18x18.mdl"        , "#", "x3", 1})
    PIECES:Record({"models/sprops/cuboids/height24/size_1/cube_24x24x24.mdl", "#", "x4", 1})
    PIECES:Record({"models/sprops/cuboids/height36/size_1/cube_36x36x36.mdl", "#", "x5", 1})
    PIECES:Record({"models/sprops/cuboids/height48/size_1/cube_48x48x48.mdl", "#", "x6", 1})
    asmlib.Categorize("Develop PHX")
    PIECES:Record({"models/hunter/blocks/cube025x025x025.mdl", "#", "x1", 1})
    PIECES:Record({"models/hunter/blocks/cube05x05x05.mdl"   , "#", "x2", 1})
    PIECES:Record({"models/hunter/blocks/cube075x075x075.mdl", "#", "x3", 1})
    PIECES:Record({"models/hunter/blocks/cube1x1x1.mdl"      , "#", "x4", 1})
    asmlib.Categorize("Develop Test")
    PIECES:Record({"models/props_c17/furniturewashingmachine001a.mdl", "#", "#", 1, "#", "-0.05,0.006, 21.934", "-90,  0,180"})
    PIECES:Record({"models/props_c17/furniturewashingmachine001a.mdl", "#", "#", 2, "", "-0.05,0.006,-21.922", "90,180,180"})
  end
  asmlib.Categorize("PHX Monorail")
  PIECES:Record({"models/props_phx/trains/monorail1.mdl", "#", "Straight Short", 1, "", "229.885559,0.23999,13.87915"})
  PIECES:Record({"models/props_phx/trains/monorail1.mdl", "#", "Straight Short", 2, "", "-228.885254,0.239726,13.87915", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/monorail2.mdl", "#", "Straight Middle", 1, "", "0.239726,-462.635468,13.879296", "0,-90,0"})
  PIECES:Record({"models/props_phx/trains/monorail2.mdl", "#", "Straight Middle", 2, "", "0.239914,464.885315,13.879209", "0,90,0"})
  PIECES:Record({"models/props_phx/trains/monorail3.mdl", "#", "Straight Long", 1, "", "0.239949,-934.135559,13.879116", "0,-90,0"})
  PIECES:Record({"models/props_phx/trains/monorail3.mdl", "#", "Straight Long", 2, "", "0.239705, 930.885315,13.879150", "0, 90,0"})
  PIECES:Record({"models/props_phx/trains/monorail4.mdl", "#", "Straight Very Long", 1, "", "0.239664,-1867.13562,13.879143", "0,-90,0"})
  PIECES:Record({"models/props_phx/trains/monorail4.mdl", "#", "Straight Very Long", 2, "", "0.239664,1872.885376,13.879150", "0,90,0"})
  PIECES:Record({"models/props_phx/trains/monorail_curve2.mdl", "#", "Turn 45", 1, "", "-0.030396,-605.638428,13.881409"})
  PIECES:Record({"models/props_phx/trains/monorail_curve2.mdl", "#", "Turn 45", 2, "", "-428.018524,-428.362335,13.881714", "0,135,0"})
  PIECES:Record({"models/props_phx/trains/monorail_curve.mdl", "#", "Turn 90", 1, "", "-0.030518,-605.638184,13.880554"})
  PIECES:Record({"models/props_phx/trains/monorail_curve.mdl", "#", "Turn 90", 2, "", "-605.380859,-0.307583,13.881714", "0,90,0"})
  asmlib.Categorize("PHX Metal")
  asmlib.ModelToNameRule("SET",nil,{"track_","straight_"},nil)
  PIECES:Record({"models/props_phx/trains/track_32.mdl" , "#", "#", 1, "-0.327,-61.529,8.714", " 15.755127,0.001953,9.215"})
  PIECES:Record({"models/props_phx/trains/track_32.mdl" , "#", "#", 2, "-0.327, 61.529,8.714", "-16.239746,0.000244,9.215", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/track_64.mdl" , "#", "#", 1, "", " 31.999878, 0.001960,9.215"})
  PIECES:Record({"models/props_phx/trains/track_64.mdl" , "#", "#", 2, "", "-32.000275,-0.001469,9.215", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/track_128.mdl", "#", "#", 1, "", " 63.75531,  0.001953,9.215"})
  PIECES:Record({"models/props_phx/trains/track_128.mdl", "#", "#", 2, "", "-64.240356,-0.005125,9.215", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/track_256.mdl", "#", "#", 1, "", "  127.754944, 0.001953,9.215"})
  PIECES:Record({"models/props_phx/trains/track_256.mdl", "#", "#", 2, "", " -128.245117,-0.012207,9.215", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/track_512.mdl", "#", "#", 1, "", " 255.754791, 0.001465,9.215"})
  PIECES:Record({"models/props_phx/trains/track_512.mdl", "#", "#", 2, "", "-256.242401,-0.026855,9.215", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/track_1024.mdl", "#", "#", 1, "", " 511.754761,-4.7e-005,9.215"})
  PIECES:Record({"models/props_phx/trains/track_1024.mdl", "#", "#", 2, "", "-512.240601,-0.050828,9.215", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/track_2048.mdl", "#", "#", 1, "", " 1023.755066,0.000642,9.215"})
  PIECES:Record({"models/props_phx/trains/track_2048.mdl", "#", "#", 2, "", "-1024.242676,-0.109433,9.215", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/track_4096.mdl", "#", "#", 1, "", " 2047.755249, 0.001923,9.215"})
  PIECES:Record({"models/props_phx/trains/track_4096.mdl", "#", "#", 2, "", "-2048.240479,-0.225247,9.215", "0,-180,0"})
  asmlib.Categorize("PHX Regular")
  asmlib.ModelToNameRule("SET",{1,6},{"turn","turn_"})
  PIECES:Record({"models/props_phx/trains/tracks/track_single.mdl", "#", "#", 1, "-0.327,-61.529,8.714", " 15.45284,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_single.mdl", "#", "#", 2, "-0.327, 61.529,8.714", "-16.09597,0,12.548828", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_1x.mdl", "#", "#", 1, "", " 79.93032,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_1x.mdl", "#", "#", 2, "", "-70.05904,0,12.548828", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_2x.mdl", "#", "#", 1, "", "229.92037,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_2x.mdl", "#", "#", 2, "", "-70.05904,0,12.548828", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_4x.mdl", "#", "#", 1, "", "229.92037,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_4x.mdl", "#", "#", 2, "", "-370.03808,0,12.548828", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_8x.mdl", "#", "#", 1, "", "829.87936,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_8x.mdl", "#", "#", 2, "", "-370.03805,0,12.548828", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_16x.mdl", "#", "#", 1, "", "2029.79824,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_16x.mdl", "#", "#", 2, "", "-370.03799,0,12.548828", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_turn45.mdl", "#", "#", 1, "", "733.00021,-265.36572,11.218994"})
  PIECES:Record({"models/props_phx/trains/tracks/track_turn45.mdl", "#", "#", 2, "", "-83.2627,72.74402,11.218994", "0,135,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_turn90.mdl", "#", "#", 1, "", "733.00015,-265.36475,11.218994"})
  PIECES:Record({"models/props_phx/trains/tracks/track_turn90.mdl", "#", "#", 2, "", "-421.37549,889.00677,11.218994", "0,90,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_pass.mdl", "#", "Cross Road", 1, "", "229.92107,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_pass.mdl", "#", "Cross Road", 2, "", "-370.03738,0,12.548828", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_x.mdl", "#", "Cross 45", 1, "", "250.47439,49.613525,11.214844"})
  PIECES:Record({"models/props_phx/trains/tracks/track_x.mdl", "#", "Cross 45", 2, "", "-261.62405,261.73975,11.214844", "0,135,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_x.mdl", "#", "Cross 45", 3, "", "-349.48406,49.613525,11.214844", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_x.mdl", "#", "Cross 45", 4, "", "162.61111,-162.49341,11.214844", "0,-45,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_crossing.mdl", "#", "Cross 90", 1, "", "74.97414,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_crossing.mdl", "#", "Cross 90", 2, "", "-0.02246,74.99988,12.548828", "0,90,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_crossing.mdl", "#", "Cross 90", 3, "", "-75.01485,0,12.548828", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_crossing.mdl", "#", "Cross 90", 4, "", "-0.02246,-74.987,12.548828", "0,-90,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_225_down.mdl", "#", "#", 1, "", "-75.016,0,64.57", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_225_down.mdl", "#", "#", 2, "", "4.096,0,48.791", "22.5,0,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_225_up.mdl", "#", "#", 1, "", "-75.016,0,11.212", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_225_up.mdl", "#", "#", 2, "", "4.16287,0,27.05461", "-22.5,0,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_45_down.mdl", "#", "#", 1, "-75.016,0,64.568", "-75.013,-0.002,64.568", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_45_down.mdl", "#", "#", 2, "", "71.04594,0,3.95992", "45,0,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_45_up.mdl", "#", "#", 1, "", "-75.013,0,11.218", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_45_up.mdl", "#", "#", 2, "", "71.173,0,71.909", "-45,0,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch.mdl", "#", "Switch Right", 1, "", " 829.88009,0,11.218994"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch.mdl", "#", "Switch Right", 2, "", "-370.03738,0,11.218994", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch.mdl", "#", "Switch Right", 3, "", "-158.32591,338.09229,11.21899", "0,135,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch2.mdl", "#", "Switch Left [X]", 1, "", " 829.88009,0,11.218994"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch2.mdl", "#", "Switch Left [X]", 2, "", "-370.03738,0,11.218994", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch2.mdl", "#", "Switch Left [X]", 3, "", "-158.32668,-338.09521,11.21899", "0,-135,0"})
  asmlib.Categorize("SProps",[[function(m)
    local r = m:gsub("models/sprops/trans/train/",""):gsub("track_",""):sub(1,1)
    if(r == "s") then return "straight" elseif(r == "t") then return "turn"
    elseif(r == "h") then return "ramp" else return nil end end]])
  asmlib.ModelToNameRule("SET",nil,{"track_s0","straight_"},{"","x"})
  PIECES:Record({"models/sprops/trans/train/track_s01.mdl", "#", "#", 1, "", " 0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_s01.mdl", "#", "#", 2, "", "-162,0,7.624", "0,180,0"})
  PIECES:Record({"models/sprops/trans/train/track_s02.mdl", "#", "#", 1, "", " 0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_s02.mdl", "#", "#", 2, "", "-324,0,7.624", "0,180,0"})
  PIECES:Record({"models/sprops/trans/train/track_s03.mdl", "#", "#", 1, "", " 0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_s03.mdl", "#", "#", 2, "", "-486,0,7.624", "0,180,0"})
  PIECES:Record({"models/sprops/trans/train/track_s04.mdl", "#", "#", 1, "", " 0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_s04.mdl", "#", "#", 2, "", "-648,0,7.624", "0,180,0"})
  PIECES:Record({"models/sprops/trans/train/track_s05.mdl", "#", "#", 1, "", " 0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_s05.mdl", "#", "#", 2, "", "-1296.002,0,7.624", "0,180,0"})
  PIECES:Record({"models/sprops/trans/train/track_s06.mdl", "#", "#", 1, "", " 0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_s06.mdl", "#", "#", 2, "", "-2592.002,0,7.624", "0,180,0"})
  asmlib.ModelToNameRule("CLR")
  PIECES:Record({"models/sprops/trans/train/track_h01.mdl", "#", "Ramp", 1, "", "0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_h01.mdl", "#", "Ramp", 2, "", "-2525.98,0,503.58", "0,180,0"})
  PIECES:Record({"models/sprops/trans/train/track_h02.mdl", "#", "225 Up", 1, "", "0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_h02.mdl", "#", "225 Up", 2, "", "-1258.828,0,261.268", "-22.5,180,0"})
  PIECES:Record({"models/sprops/trans/train/track_h03.mdl", "#", "225 Down", 1, "", "0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_h03.mdl", "#", "225 Down", 2, "", "-1264.663,0,-247.177", "22.5,180,0"})
  asmlib.ModelToNameRule("SET",nil,{"track_t","turn_","02","big","01","small"},nil)
  PIECES:Record({"models/sprops/trans/train/track_t90_02.mdl", "#", "#", 1, "", "0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_t90_02.mdl", "#", "#", 2, "", "-1650,1650.0009765625,7.624", "0,90,0"})
  PIECES:Record({"models/sprops/trans/train/track_t90_01.mdl", "#", "#", 1, "", "0,0,7.624"})
  PIECES:Record({"models/sprops/trans/train/track_t90_01.mdl", "#", "#", 2, "", "-825,825,7.624", "0,90,0"})
  PIECES:Record({"models/sprops/trans/train/rerailer.mdl",     "#", "#", 1, "-1088.178,0,19.886", "-1280.383,0,7.618", "0,180,0"})
  asmlib.Categorize("XQM Coaster",[[function(m)
    local g = m:gsub("models/xqm/coastertrack/",""):gsub("%.mdl","")
    local r = g:match(".-_"):sub(1,-2)
    local n = g:gsub(r.."_", ""); return r, n; end]])
  PIECES:Record({"models/xqm/coastertrack/slope_225_1.mdl", "#", "#", 1, "", "75.790,-0.013,-2.414"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_1.mdl", "#", "#", 2, "", "-70.806,-0.003,26.580", "-22.5,180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_2.mdl", "#", "#", 1, "", "149.8, -0.013, -9.62"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_2.mdl", "#", "#", 2, "", "-141.814, 0.004, 48.442", "-22.5,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_3.mdl", "#", "#", 1, "", "225.199, -0.016, -16.814"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_3.mdl", "#", "#", 2, "", "-214.187, 0.006, 70.463", "-22.5,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_4.mdl", "#", "#", 1, "", "298.8, -0.013, -24.02"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_4.mdl", "#", "#", 2, "", "-285.799, 0.019, 92.158", "-22.5,180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_1.mdl", "#", "#", 1, "", "74.8, -0.013, -9.758"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_1.mdl", "#", "#", 2, "", "-59.846, 0.021, 45.855", "-45,180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_2.mdl", "#", "#", 1, "", "-148.199, 0.021, -24.085", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_2.mdl", "#", "#", 2, "", "121.828, -0.004, 88.131", "-45,0,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_3.mdl", "#", "#", 1, "", "-221.204, 0.005, -38.364", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_3.mdl", "#", "#", 2, "", "183.612, -0.018, 129.084", "-45,0,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_4.mdl", "#", "#", 1, "", "-293.8, -0.013, -52.661", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_4.mdl", "#", "#", 2, "", "245.168, -0.007, 170.857", "-45,0,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_1.mdl", "#", "#", 1, "", "75, -0.016, -9.757"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_1.mdl", "#", "#", 2, "", "-115.988, 0.017, 181.075", "-90,0,180"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_2.mdl", "#", "#", 1, "", "-148.198, -0.013, -24.085", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_2.mdl", "#", "#", 2, "", " 233.158,  0.013, 358.192", "-90, 180,180"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_3.mdl", "#", "#", 1, "", "-221.1, -0.013, -38.366", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_3.mdl", "#", "#", 2, "", "351.2, -0.013, 533.582", "-90,-180,180"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_4.mdl", "#", "#", 1, "", "-293.701, -0.013, -52.661", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_4.mdl", "#", "#", 2, "", "468.482, -0.013, 710.225", "-90,-180,180"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_down_1.mdl", "#", "#", 1, "", " -73.800, -0.013,  11.999", "  0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_down_1.mdl", "#", "#", 2, "", "  72.814, -0.013, -16.992", "22.5,0,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_down_2.mdl", "#", "#", 1, "", "-148.626, -0.013,  19.510", "  0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_down_2.mdl", "#", "#", 2, "", " 134.806, -0.011, -36.762", "22.5,0,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_down_3.mdl", "#", "#", 1, "", "-224.899,  0.010,  25.763", "  0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_down_3.mdl", "#", "#", 2, "", " 202.547, -0.014, -57.473", "22.5,0,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_down_4.mdl", "#", "#", 1, "", "-300.319,  0.017,  32.110", "  0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_225_down_4.mdl", "#", "#", 2, "", " 268.600,  0.052, -77.783", "22.5,0,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_down_1.mdl", "#", "#", 1, "", "-71.199, -0.013,  18.809", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_down_1.mdl", "#", "#", 2, "", " 63.815, -0.021, -37.126", "45,0,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_down_2.mdl", "#", "#", 1, "", "-144.8, -0.013, 33.103", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_down_2.mdl", "#", "#", 2, "", "125.217, -0.014, -78.778", "45,0,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_down_3.mdl", "#", "#", 1, "", "217.199, -0.013, 47.332"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_down_3.mdl", "#", "#", 2, "", "-187.587, 0.003, -120.127", "45,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_down_4.mdl", "#", "#", 1, "", "290.79, -0.013, 61.604"})
  PIECES:Record({"models/xqm/coastertrack/slope_45_down_4.mdl", "#", "#", 2, "", "-249.142, 0.017, -161.855", "45, 180, 0"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_down_1.mdl", "#", "#", 1, "", "-70.793, -0.038,   18.807", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_down_1.mdl", "#", "#", 2, "", "119.415, -0.013, -171.482", "90,-180,180"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_down_2.mdl", "#", "#", 1, "", "-144.804, -0.013, 33.103", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_down_2.mdl", "#", "#", 2, "", "237.418, -0.013, -349.306", "90,180,180"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_down_3.mdl", "#", "#", 1, "", "217.199, -0.013, 47.332"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_down_3.mdl", "#", "#", 2, "", "-355.101, 0.01, -524.496", "90,0,180"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_down_4.mdl", "#", "#", 1, "", "290.8, -0.013, 61.604"})
  PIECES:Record({"models/xqm/coastertrack/slope_90_down_4.mdl", "#", "#", 2, "", "-473.228, -0.013, -701.956", "90,0,180"})
  ------------ XQM Turn ------------
  PIECES:Record({"models/xqm/coastertrack/turn_45_1.mdl", "#", "#", 1, "", "73.232, -14.287, 4.894"})
  PIECES:Record({"models/xqm/coastertrack/turn_45_1.mdl", "#", "#", 2, "", "-62.119, 41.771, 4.888", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_45_2.mdl", "#", "#", 1, "", "145.801, -28.557, 4.893"})
  PIECES:Record({"models/xqm/coastertrack/turn_45_2.mdl", "#", "#", 2, "", "-123.848, 83.091, 4.921", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_45_3.mdl", "#", "#", 1, "", "218.8, -42.829, 4.899"})
  PIECES:Record({"models/xqm/coastertrack/turn_45_3.mdl", "#", "#", 2, "", "-184.844, 124.707, 4.88", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_45_4.mdl", "#", "#", 1, "", "292.197, -57.102, 4.896"})
  PIECES:Record({"models/xqm/coastertrack/turn_45_4.mdl", "#", "#", 2, "", "-246.823, 166.305, 4.888", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_1.mdl", "#", "#", 1, "", "73.199, -14.286, 4.894"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_1.mdl", "#", "#", 2, "", "-117.904, 176.785, 4.888", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_2.mdl", "#", "#", 1, "", "145.748, -28.566, 4.883"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_2.mdl", "#", "#", 2, "", "-235.851, 352.965, 4.883", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_3.mdl", "#", "#", 1, "", "219.199, -42.829, 4.9"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_3.mdl", "#", "#", 2, "", "-352.072, 529.25, 4.888", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_4.mdl", "#", "#", 1, "", "292.695, -57.102, 4.897"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_4.mdl", "#", "#", 2, "", "-470.379, 706.175, 4.887", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_1.mdl", "#", "#", 1, "", "72.8, 367.527, 4.894"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_1.mdl", "#", "#", 2, "", "72.8, -14.286, 4.894"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_3.mdl", "#", "#", 1, "", "218.767, -42.833, 4.888"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_3.mdl", "#", "#", 2, "", "218.767, 1100.169, 4.91"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_2.mdl", "#", "#", 1, "", "146.198, -28.561, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_2.mdl", "#", "#", 2, "", "146.041, 735.053, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_4.mdl", "#", "#", 1, "", "292.283, -57.102, 4.896"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_4.mdl", "#", "#", 2, "", "292.283, 1468.9, 4.896"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_tight_1.mdl", "#", "#", 1, "", "68.201, -27.47, 4.907"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_tight_1.mdl", "#", "#", 2, "", "-27.469, 68.408, 4.907", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_tight_2.mdl", "#", "#", 1, "", "134.784, -54.932, 4.883"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_tight_2.mdl", "#", "#", 2, "", "-54.9, 134.79, 4.908", "0, 90, 0"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_tight_3.mdl", "#", "#", 1, "", "203.169, -82.386, 4.885"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_tight_3.mdl", "#", "#", 2, "", "-82.342, 203.198, 4.884", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_tight_4.mdl", "#", "#", 1, "", "270.8, -109.856, 4.889"})
  PIECES:Record({"models/xqm/coastertrack/turn_90_tight_4.mdl", "#", "#", 2, "", "-109.812, 270.799, 4.89", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_tight_2.mdl", "#", "#", 1, "", "93.769, 96.842, 4.9", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_tight_2.mdl", "#", "#", 2, "", "-93.912, 96.841, 4.9", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_tight_3.mdl", "#", "#", 1, "", "138.58, 144.2, 4.906", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_tight_3.mdl", "#", "#", 2, "", "-142.846, 144.192, 4.888", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_tight_4.mdl", "#", "#", 1, "", "184.588, 191.8, 4.905", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_180_tight_4.mdl", "#", "#", 2, "", "-190.323, 191.8, 4.905", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_45_1.mdl", "#", "#", 1, "", "73.214, -14.287, 4.889"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_45_1.mdl", "#", "#", 2, "", "-62.103, 41.809, 49.893", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_45_2.mdl", "#", "#", 1, "", "145.789, -28.557, 4.888"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_45_2.mdl", "#", "#", 2, "", "-123.816, 83.09, 49.885", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_45_3.mdl", "#", "#", 1, "", "218.817, -42.829, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_45_3.mdl", "#", "#", 2, "", "-184.823, 124.712, 49.888", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_45_4.mdl", "#", "#", 1, "", "292.295, -57.102, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_45_4.mdl", "#", "#", 2, "", "-246.825, 166.303, 49.887", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_90_1.mdl", "#", "#", 1, "", "151.949, -115.536, -28.863"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_90_1.mdl", "#", "#", 2, "", "-39.186, 75.539, 61.137", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_90_2.mdl", "#", "#", 1, "", "247.052, -129.807, -17.611"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_90_2.mdl", "#", "#", 2, "", "-134.631, 251.731, 72.387", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_90_3.mdl", "#", "#", 1, "", "342.55, -166.589, -6.356"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_90_3.mdl", "#", "#", 2, "", "-228.353, 405.104, 83.627", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_90_4.mdl", "#", "#", 1, "", "461.445, -180.852, -6.363"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_90_4.mdl", "#", "#", 2, "", "-301.622, 582.445, 83.635", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_180_1.mdl", "#", "#", 1, "", "61.949, -171.786, -85.113"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_180_1.mdl", "#", "#", 2, "", "61.849, 210.026, 94.887"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_180_2.mdl", "#", "#", 1, "", "145.79, -377.307, -51.364"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_180_2.mdl", "#", "#", 2, "", "145.64, 386.277, 128.636"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_180_3.mdl", "#", "#", 1, "", "219.186, -560.329, -73.863"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_180_3.mdl", "#", "#", 2, "", "219.938, 582.673, 106.137"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_180_4.mdl", "#", "#", 1, "", "292.682, -57.062, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_180_4.mdl", "#", "#", 2, "", "292.882, 1468.926, 184.888"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_45_1.mdl", "#", "#", 1, "", "73.199, -14.286, 49.887"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_45_1.mdl", "#", "#", 2, "", "-62.097, 41.783, 4.886", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_45_2.mdl", "#", "#", 1, "", "145.79, -28.558, 49.879"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_45_2.mdl", "#", "#", 2, "", "-123.833, 83.088, 4.892", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_45_3.mdl", "#", "#", 1, "", "219.197, -42.829, 49.887"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_45_3.mdl", "#", "#", 2, "", "-185.095, 124.99, 4.888", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_45_4.mdl", "#", "#", 1, "", "292.695, -57.102, 49.887"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_45_4.mdl", "#", "#", 2, "", "-247.123, 166.602, 4.888", "0,135,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_90_1.mdl", "#", "#", 1, "", "128.858, -14.281, 72.387"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_90_1.mdl", "#", "#", 2, "", "-61.682, 176.749, -17.61", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_90_2.mdl", "#", "#", 1, "", "179.55, -28.557, 61.136"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_90_2.mdl", "#", "#", 2, "", "-202.131, 352.976, -28.864", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_90_3.mdl", "#", "#", 1, "", "241.3, -42.829, 61.136"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_90_3.mdl", "#", "#", 2, "", "-329.578, 528.859, -28.864", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_90_4.mdl", "#", "#", 1, "", "292.296, -57.102, 94.89"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_90_4.mdl", "#", "#", 2, "", "-470.372, 705.791, 4.886", "0,90,0"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_180_1.mdl", "#", "#", 1, "", "73.2, -149.286, 128.637"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_180_1.mdl", "#", "#", 2, "", "73.099, 232.527, -51.363"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_180_2.mdl", "#", "#", 1, "", "145.8, -287.306, 117.387"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_180_2.mdl", "#", "#", 2, "", "145.6, 476.307, -62.612"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_180_3.mdl", "#", "#", 1, "", "219.196, -391.579, 117.387"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_180_3.mdl", "#", "#", 2, "", "219.948, 751.399, -62.61"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_180_4.mdl", "#", "#", 1, "", "292.681, -630.852, 117.391"})
  PIECES:Record({"models/xqm/coastertrack/turn_slope_down_180_4.mdl", "#", "#", 2, "", "292.833, 895.14, -62.613"})
  --- XQM Bank --
  PIECES:Record({"models/xqm/coastertrack/bank_start_right_1.mdl", "#", "#", 1, "", "149.7, -0.005, 4.88"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_right_1.mdl", "#", "#", 2, "", "-149.7, 0.024, 4.865", "0,180,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_right_2.mdl", "#", "#", 1, "", "299.790,-0.021,4.885"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_right_2.mdl", "#", "#", 2, "", "-299.790,0.007,4.862", "0,180,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_right_3.mdl", "#", "#", 1, "", "449.8, -0.018, 4.896"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_right_3.mdl", "#", "#", 2, "", "-449.802, -0.003, 4.853", "0,-180,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_right_4.mdl", "#", "#", 1, "", "600.194, -0.017, 4.888"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_right_4.mdl", "#", "#", 2, "", "-600.199, 0.025, 4.872", "0,180,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_left_1.mdl", "#", "#", 1, "", "150.199, 0.032, 4.885"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_left_1.mdl", "#", "#", 2, "", "-150.168, -0.014, 4.881", "0,180,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_left_2.mdl", "#", "#", 1, "", "300.199, -0.011, 4.895"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_left_2.mdl", "#", "#", 2, "", "-300.198, 0.032, 4.914", "0,180,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_left_3.mdl", "#", "#", 1, "", "449.378, -0.025, 4.893"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_left_3.mdl", "#", "#", 2, "", "-449.801, 0.018, 4.896", "0,180,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_left_4.mdl", "#", "#", 1, "", "599.802, -0.013, 4.883"})
  PIECES:Record({"models/xqm/coastertrack/bank_start_left_4.mdl", "#", "#", 2, "", "-600.198, -0.015, 4.902", "0,-180,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_45_1.mdl", "#", "#", 1, "", "74.199, 14.457, 4.888", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_45_1.mdl", "#", "#", 2, "", "-63.081, -42.297, 4.912", "0,-135,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_45_2.mdl", "#", "#", 1, "", "147.199, 28.717, 4.886", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_45_2.mdl", "#", "#", 2, "", "-124.087, -83.935, 4.901", "0,-135,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_45_3.mdl", "#", "#", 1, "", "219.8, 42.98, 4.887", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_45_3.mdl", "#", "#", 2, "", "-185.808, -125.258, 4.908", "0,-135,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_45_4.mdl", "#", "#", 1, "", "292.799, 57.249, 4.89", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_45_4.mdl", "#", "#", 2, "", "-247.727, -166.794, 4.908", "0,-135,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_90_1.mdl", "#", "#", 1, "", "73.8, 14.448, 4.895", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_90_1.mdl", "#", "#", 2, "", "-119.757, -178.862, 4.909", "0,-90,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_90_2.mdl", "#", "#", 1, "", "147.2, 28.719, 4.887", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_90_2.mdl", "#", "#", 2, "", "-235.985, -355.128, 4.904", "0,-90,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_90_3.mdl", "#", "#", 1, "", "220.199, 42.985, 4.89", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_90_3.mdl", "#", "#", 2, "", "-353.929, -531.719, 4.91", "0,-90,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_90_4.mdl", "#", "#", 1, "", "292.790,57.259,4.881", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_90_4.mdl", "#", "#", 2, "", "-471.864,-707.923,4.910", "0,-90.00,-45.00"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_180_1.mdl", "#", "#", 1, "", "73.8, 14.45, 4.887", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_180_1.mdl", "#", "#", 2, "", "73.46, -372.816, 4.902", "0,0,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_180_2.mdl", "#", "#", 1, "", "146.8, 28.715, 4.888", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_180_2.mdl", "#", "#", 2, "", "147.376, -737.938, 4.911", "0,0,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_180_3.mdl", "#", "#", 1, "", "220.191, 43.001, 4.907", "0,0,45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_180_3.mdl", "#", "#", 2, "", "220.813, -1105.46, 4.883", "0,0,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_180_4.mdl", "#", "#", 1, "", "293.308, -1472.996, 4.916", "0,0,-45"})
  PIECES:Record({"models/xqm/coastertrack/bank_turn_180_4.mdl", "#", "#", 2, "", "292.8, 57.26, 4.89", "0,0,45"})
  --- XQM Special ---
  PIECES:Record({"models/xqm/coastertrack/special_sturn_right_2.mdl", "#", "#", 1, "", "150.189, -36.538, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_right_2.mdl", "#", "#", 2, "", "-150.199, 36.554, 4.887", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_right_3.mdl", "#", "#", 1, "", "225.199, -36.549, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_right_3.mdl", "#", "#", 2, "", "-225.099, 36.55, 4.887", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_right_4.mdl", "#", "#", 1, "", "300.2, -36.649, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_right_4.mdl", "#", "#", 2, "", "-300.195, 36.561, 4.887", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_left_2.mdl", "#", "#", 1, "", "149.8, 36.553, 4.886"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_left_2.mdl", "#", "#", 2, "", "-149.8, -36.54, 4.886", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_left_3.mdl", "#", "#", 1, "", "225.159, 36.552, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_left_3.mdl", "#", "#", 2, "", "-225.2, -36.559, 4.886", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_left_4.mdl", "#", "#", 1, "", "299.8, 36.623, 4.886"})
  PIECES:Record({"models/xqm/coastertrack/special_sturn_left_4.mdl", "#", "#", 2, "", "-299.8, -36.6, 4.886", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_2.mdl", "#", "#", 1, "", "189.277, 59.435, 41.118", "0,90,-90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_2.mdl", "#", "#", 2, "", "-192.302, 46.789, -17.492", "22.5,90,90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_3.mdl", "#", "#", 1, "", "-285.755, -96.647, 32.538", "0,-90,-90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_3.mdl", "#", "#", 2, "", "281.393, -79.204, -55.216", "22.5,-90,90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_4.mdl", "#", "#", 1, "", "322.424, -72.015, 15.907", "0,-90,90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_4.mdl", "#", "#", 2, "", "-419.735, -44.894, 132.706", "-22.5,-90,-90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_full_2.mdl", "#", "#", 1, "", "-207.841, 30.414, 100.219", "-22.5,-90,-90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_full_2.mdl", "#", "#", 2, "", "-207.993, 7.31, -17.474", "22.5,90,90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_full_3.mdl", "#", "#", 1, "", "281.359, -6.612, 120.391", "-22.5,90,-90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_full_3.mdl", "#", "#", 2, "", "281.371, 28.004, -55.354", "22.5,-90,90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_full_4.mdl", "#", "#", 1, "", "322.609, 52.146, 251.028", "0,90,-90"})
  PIECES:Record({"models/xqm/coastertrack/special_helix_middle_full_4.mdl", "#", "#", 2, "", "322.431, 5.79, 15.895", "0,-90,90"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_right_1.mdl", "#", "#", 1, "", "150.199, 0.013, 4.886"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_right_1.mdl", "#", "#", 2, "", "-1050.199, -0.01, 4.886", "0,180,180"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_right_2.mdl", "#", "#", 1, "", "1126.907, -0.013, 4.883, 4.9"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_right_2.mdl", "#", "#", 2, "", "-1272.492, -0.164, 4.883", "0,-180,-180"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_right_3.mdl", "#", "#", 1, "", "1349.823, -0.012, 4.883"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_right_3.mdl", "#", "#", 2, "", "-2249.7, -0.013, 4.884", "0,-180,180"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_right_4.mdl", "#", "#", 1, "", "1950.199, -0.017, 4.889"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_right_4.mdl", "#", "#", 2, "", "-2850.199, -0.047, 4.88", "0,-180,180"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_left_1.mdl", "#", "#", 1, "", "150.079, -0.009, 4.878"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_left_1.mdl", "#", "#", 2, "", "-1050.198, -0.036, 4.877", "0,180,-180"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_left_2.mdl", "#", "#", 1, "", "299.8, -0.013, 4.884"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_left_2.mdl", "#", "#", 2, "", "-2099.8, -0.013, 4.883", "0,-180,180"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_left_3.mdl", "#", "#", 1, "", "449.801, -0.014, 4.882"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_left_3.mdl", "#", "#", 2, "", "-3149.802, -0.028, 4.871", "0,180,180"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_left_4.mdl", "#", "#", 1, "", "599.801, -0.014, 4.888"})
  PIECES:Record({"models/xqm/coastertrack/special_half_corkscrew_left_4.mdl", "#", "#", 2, "", "-4199.8, -0.013, 4.881", "0,-180,-180"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_right_1.mdl", "#", "#", 1, "", "150, -0.013, 4.886"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_right_1.mdl", "#", "#", 2, "", "-2250, -0.013, 4.886", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_right_3.mdl", "#", "#", 1, "", "2550.2, -0.012, 4.886"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_right_3.mdl", "#", "#", 2, "", "-4650.14, -0.013, 4.886", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_right_4.mdl", "#", "#", 1, "", "3749.790,-0.019,4.879"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_right_4.mdl", "#", "#", 2, "", "-5849.795, 0.008, 4.884", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_left_1.mdl", "#", "#", 1, "", "149.695, -0.02, 4.886"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_left_1.mdl", "#", "#", 2, "", "-2249.721, 0.014, 4.888", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_left_2.mdl", "#", "#", 1, "", "1350.218, 0.029, 4.883"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_left_2.mdl", "#", "#", 2, "", "-3450.199, -0.009, 4.887", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_left_3.mdl", "#", "#", 1, "", "2550, -0.013, 4.886"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_left_3.mdl", "#", "#", 2, "", "-4650.203, 0.023, 4.886", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_left_4.mdl", "#", "#", 1, "", "3749.804, -0.001, 4.888"})
  PIECES:Record({"models/xqm/coastertrack/special_full_corkscrew_left_4.mdl", "#", "#", 2, "", "-5849.8, 0.036, 4.888", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_full_loop_3.mdl", "#", "#", 1, "", "14.2, 67.584, -279.931"})
  PIECES:Record({"models/xqm/coastertrack/special_full_loop_3.mdl", "#", "#", 2, "", "-0.172, -67.619, -279.937", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_full_loop_4.mdl", "#", "#", 1, "", "2.16, 89.53, -307.495"})
  PIECES:Record({"models/xqm/coastertrack/special_full_loop_4.mdl", "#", "#", 2, "", "-18.191, -72.398, -307.642", "0,-180,0"})
  --- XQM Straight ---
  PIECES:Record({"models/xqm/coastertrack/straight_1.mdl", "#", "#", 1, "", "74.802, -0.013, 4.886, 0"})
  PIECES:Record({"models/xqm/coastertrack/straight_1.mdl", "#", "#", 2, "", "-74.803, -0.013, 4.886", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/straight_2.mdl", "#", "#", 1, "", "149.805, -0.013, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/straight_2.mdl", "#", "#", 2, "", "-149.805, -0.013, 4.887", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/straight_3.mdl", "#", "#", 1, "", "225.206, -0.013, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/straight_3.mdl", "#", "#", 2, "", "-225.196, -0.013, 4.887", "0,-180,0"})
  PIECES:Record({"models/xqm/coastertrack/straight_4.mdl", "#", "#", 1, "", "300.164, -0.013, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/straight_4.mdl", "#", "#", 2, "", "-300.189, -0.013, 4.887", "0,180,0"})
  PIECES:Record({"models/xqm/coastertrack/special_station.mdl", "#", "#", 1, "", "150.194, -0.045, 4.887"})
  PIECES:Record({"models/xqm/coastertrack/special_station.mdl", "#", "#", 2, "", "-150.184, -0.045, 4.887", "0,-180,0"})
  asmlib.Categorize("PHX Road")
  PIECES:Record({"models/props_phx/huge/road_short.mdl",  "#", "#", 1, "", "0, 299.693, 1.765", "0, 90,0"})
  PIECES:Record({"models/props_phx/huge/road_short.mdl",  "#", "#", 2, "", "0,-299.693, 1.765", "0,-90,0"})
  PIECES:Record({"models/props_phx/huge/road_medium.mdl", "#", "#", 1, "", "0, 599.386, 1.765", "0, 90,0"})
  PIECES:Record({"models/props_phx/huge/road_medium.mdl", "#", "#", 2, "", "0,-599.386, 1.765", "0,-90,0"})
  PIECES:Record({"models/props_phx/huge/road_long.mdl",   "#", "#", 1, "", "0, 1198.773, 1.765", "0, 90,0"})
  PIECES:Record({"models/props_phx/huge/road_long.mdl",   "#", "#", 2, "", "0,-1198.773, 1.765", "0,-90,0"})
  PIECES:Record({"models/props_phx/huge/road_curve.mdl",  "#", "#", 1, "", "162.813, 379.277, 1.879", "0, 90,0"})
  PIECES:Record({"models/props_phx/huge/road_curve.mdl",  "#", "#", 2, "", "-363.22, -146.757, 1.879", "0,-180,0"})
  PIECES:Record({"models/props_phx/misc/small_ramp.mdl",  "#", "#", 1, "", "-284.589, -3.599976, -1.672", "0,-180,0"})
  PIECES:Record({"models/props_phx/misc/small_ramp.mdl",  "#", "#", 2, "", " 312.608, -3.599976, 236.11", "-45,0,0"})
  PIECES:Record({"models/props_phx/misc/big_ramp.mdl",    "#", "#", 1, "", "-569.177, -7.199953, -3.075",  "0,-180,0"})
  PIECES:Record({"models/props_phx/misc/big_ramp.mdl",    "#", "#", 2, "", "625.022, -7.199953, 472.427", "-45,0,0"})
  asmlib.Categorize("PHX Monorail Beam")
  PIECES:Record({"models/props_phx/misc/iron_beam1.mdl", "#", "#", 1, "", " 22.411, 0.001, 5.002", "0, 0,0"})
  PIECES:Record({"models/props_phx/misc/iron_beam1.mdl", "#", "#", 2, "", "-22.413, 0.001, 5.002", "0,180,0"})
  PIECES:Record({"models/props_phx/misc/iron_beam2.mdl", "#", "#", 1, "", " 45.298, 0.001, 5.002", "0, 0,0"})
  PIECES:Record({"models/props_phx/misc/iron_beam2.mdl", "#", "#", 2, "", "-46.968, 0.001, 5.002", "0,180,0"})
  PIECES:Record({"models/props_phx/misc/iron_beam3.mdl", "#", "#", 1, "", " 93.069, 0, 5.002", "0, 0,0"})
  PIECES:Record({"models/props_phx/misc/iron_beam3.mdl", "#", "#", 2, "", "-94.079, 0.002, 5.002", "0,180,0"})
  PIECES:Record({"models/props_phx/misc/iron_beam4.mdl", "#", "#", 1, "", " 175.507, 0.001, 5.002",  "0, 0,0"})
  PIECES:Record({"models/props_phx/misc/iron_beam4.mdl", "#", "#", 2, "", "-201.413, 0.001, 5.002", "0,180,0"})
  asmlib.Categorize("XQM Ball Rails",[[function(m)
    local g = m:gsub("models/xqm/rails/",""):gsub("/","_")
    local r = g:match(".-_"); if(not r) then return end
    r = r:sub(1, -2); g = g:gsub(r.."_", "")
    local t, n = g:match(".-_"), g:gsub("%.mdl","")
    if(t) then t = t:sub(1, -2); g = g:gsub(r.."_", "")
      if(r:find(t)) then n = n:gsub(t.."_", "")
    end; end; return r, n; end]])
  PIECES:Record({"models/xqm/rails/tunnel_1.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/tunnel_1.mdl", "#", "#", 2, "", "-6, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/tunnel_2.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/tunnel_2.mdl", "#", "#", 2, "", "-18, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/tunnel_4.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/tunnel_4.mdl", "#", "#", 2, "", "-42, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/tunnel_8.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/tunnel_8.mdl", "#", "#", 2, "", "-90, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/tunnel_16.mdl","#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/tunnel_16.mdl","#", "#", 2, "", "-186, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/straight_1.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/straight_1.mdl", "#", "#", 2, "", "-6, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/straight_2.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/straight_2.mdl", "#", "#", 2, "", "-18, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/straight_4.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/straight_4.mdl", "#", "#", 2, "", "-42, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/straight_8.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/straight_8.mdl", "#", "#", 2, "", "-90, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/straight_16.mdl","#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/straight_16.mdl","#", "#", 2, "", "-186, 0, -2.25", "0,180,0"})
  PIECES:Record({"models/xqm/rails/funnel.mdl","#", "#", 1, "", "2.206, 0.003, 4.282", "90,0,180"})
  PIECES:Record({"models/xqm/rails/slope_down_15.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/slope_down_15.mdl", "#", "#", 2, "", "-20.245, -0.018, -4.13", "15,180,0"})
  PIECES:Record({"models/xqm/rails/slope_down_30.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/slope_down_30.mdl", "#", "#", 2, "", "-32.078, 0.022, -9.114", "30,180,0"})
  PIECES:Record({"models/xqm/rails/slope_down_45.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/slope_down_45.mdl", "#", "#", 2, "", "-42.144, -0.011, -16.998", "45,180,0"})
  PIECES:Record({"models/xqm/rails/slope_down_90.mdl", "#", "#", 1, "", "38, 0.019, 30.42"})
  PIECES:Record({"models/xqm/rails/slope_down_90.mdl", "#", "#", 2, "", "-30.418, -0.009, -37.98", "90,180,0"})
  PIECES:Record({"models/xqm/rails/slope_up_15.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/slope_up_15.mdl", "#", "#", 2, "", "-15.521, 0.014, -1.009", "-15,180,0"})
  PIECES:Record({"models/xqm/rails/slope_up_30.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/slope_up_30.mdl", "#", "#", 2, "", "-22.871, -0.019, 2.152", "-30,180,0"})
  PIECES:Record({"models/xqm/rails/slope_up_45.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/slope_up_45.mdl", "#", "#", 2, "", "-29.149, 0.006, 7.109", "-45,180,0"})
  PIECES:Record({"models/xqm/rails/slope_up_90.mdl", "#", "#", 1, "", "6.004, 0.005, 15.322"})
  PIECES:Record({"models/xqm/rails/slope_up_90.mdl", "#", "#", 2, "", "-44.066, -0.011, 65.001", "-90,180,0"})
  PIECES:Record({"models/xqm/rails/turn_15.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/turn_15.mdl", "#", "#", 2, "", "-17.591, 3.105, -2.25, -1.009", "0,165,0"})
  PIECES:Record({"models/xqm/rails/turn_30.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/turn_30.mdl", "#", "#", 2, "", "-28.676, 7.705, -2.252", "0,150,0"})
  PIECES:Record({"models/xqm/rails/turn_45.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/turn_45.mdl", "#", "#", 2, "", "-38.2, 15.001, -2.261", "0,135,0"})
  PIECES:Record({"models/xqm/rails/turn_90.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/turn_90.mdl", "#", "#", 2, "", "-58.848, 56.855, -2.255", "0,90,0"})
  PIECES:Record({"models/xqm/rails/turn_180.mdl", "#", "#", 1, "", "52.789, 44.753, -2.273", "0,90,0"})
  PIECES:Record({"models/xqm/rails/turn_180.mdl", "#", "#", 2, "", "-52.808, 44.743, -2.238", "0,90,0"})
  PIECES:Record({"models/xqm/rails/twist_45_left.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/twist_45_left.mdl", "#", "#", 2, "", "-90, 0, -2.25", "0,180,-45"})
  PIECES:Record({"models/xqm/rails/twist_90_left.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/twist_90_left.mdl", "#", "#", 2, "", "-186, 0, -2.25", "0,180,-90"})
  PIECES:Record({"models/xqm/rails/twist_45_right.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/twist_45_right.mdl", "#", "#", 2, "", "-90, 0, -2.25", "0,180,45"})
  PIECES:Record({"models/xqm/rails/twist_90_right.mdl", "#", "#", 1, "", "6, 0, -2.25"})
  PIECES:Record({"models/xqm/rails/twist_90_right.mdl", "#", "#", 2, "", "-186, 0, -2.25", "0,180,-90"})
  PIECES:Record({"models/xqm/rails/loop_left.mdl", "#", "#", 1, "", "13.7315, 41.726, -0.968", "0,22.5,-2.2585"})
  PIECES:Record({"models/xqm/rails/loop_left.mdl", "#", "#", 2, "", "-13.7315, -41.726, -0.968", "0,-157.5,-2.2585"})
  PIECES:Record({"models/xqm/rails/loop_right.mdl", "#", "#", 1, "", "13.864, -41.787, -0.953", "0,-22.5,2.433"})
  PIECES:Record({"models/xqm/rails/loop_right.mdl", "#", "#", 2, "", "-13.562, 41.789, -0.952", "0,157.5,2.433"})
  asmlib.Categorize("Magnum's Rails",[[function(m)
      local g = m:gsub("models/magtrains1ga/",""):gsub("/","_")
      local r = g:match(".-_"):sub(1, -2); g = g:gsub(r.."_", "")
      local t, n = g:match(".-_"), g:gsub("%.mdl","")
      if(t) then t = t:sub(1, -2); g = g:gsub(r.."_", "")
        if(r:find(t)) then n = n:gsub(t.."_", "") end
      end; if(r:find("switchbase")) then r = "switch" end; return r, n end]])
  PIECES:Record({"models/magtrains1ga/straight_0032.mdl", "#", "#", 1, "", " 16  , 0, 3.016"})
  PIECES:Record({"models/magtrains1ga/straight_0032.mdl", "#", "#", 2, "", "-16  , 0, 3.016", "0,180,0"})
  PIECES:Record({"models/magtrains1ga/straight_0064.mdl", "#", "#", 1, "", " 32  , 0, 3.016"})
  PIECES:Record({"models/magtrains1ga/straight_0064.mdl", "#", "#", 2, "", "-32  , 0, 3.016", "0,180,0"})
  PIECES:Record({"models/magtrains1ga/straight_0128.mdl", "#", "#", 1, "", " 64  , 0, 3.016"})
  PIECES:Record({"models/magtrains1ga/straight_0128.mdl", "#", "#", 2, "", "-64  , 0, 3.016", "0,180,0"})
  PIECES:Record({"models/magtrains1ga/straight_0256.mdl", "#", "#", 1, "", " 128 , 0, 3.016"})
  PIECES:Record({"models/magtrains1ga/straight_0256.mdl", "#", "#", 2, "", "-128 , 0, 3.016", "0,180,0"})
  PIECES:Record({"models/magtrains1ga/straight_0512.mdl", "#", "#", 1, "", " 256 , 0, 3.016"})
  PIECES:Record({"models/magtrains1ga/straight_0512.mdl", "#", "#", 2, "", "-256 , 0, 3.016", "0,180,0"})
  PIECES:Record({"models/magtrains1ga/straight_1024.mdl", "#", "#", 1, "", " 512 , 0, 3.016"})
  PIECES:Record({"models/magtrains1ga/straight_1024.mdl", "#", "#", 2, "", "-512 , 0, 3.016", "0,180,0"})
  PIECES:Record({"models/magtrains1ga/straight_2048.mdl", "#", "#", 1, "", " 1024, 0, 3.016"})
  PIECES:Record({"models/magtrains1ga/straight_2048.mdl", "#", "#", 2, "", "-1024, 0, 3.016", "0,180,0"})
  PIECES:Record({"models/magtrains1ga/curve_225.mdl", "#", "#", 1, "", "-0.01, 0, 3.016"})
  PIECES:Record({"models/magtrains1ga/curve_225.mdl", "#", "#", 2, "", "-587.955, -117.702, 3.016", "0,-157.5,0"})
  PIECES:Record({"models/magtrains1ga/curve_45.mdl", "#", "#", 1, "", "-0.012, 0, 3.016"})
  PIECES:Record({"models/magtrains1ga/curve_45.mdl", "#", "#", 2, "", "-1087.089, -451.055, 3.016", "0,-135,0"})
  PIECES:Record({"models/magtrains1ga/curve_90.mdl", "#", "#", 1, "", " 1086.58, 450.079, 3.016"})
  PIECES:Record({"models/magtrains1ga/curve_90.mdl", "#", "#", 2, "", "-449.475,-1085.92, 3.016", "0,-90,0"})
  PIECES:Record({"models/magtrains1ga/switchbase_left.mdl", "#", "#", 1, "", "0,0,0.01599"})
  PIECES:Record({"models/magtrains1ga/switchbase_left.mdl", "#", "#", 2, "", "-512,0,0.01599", "0,-180,0"})
  PIECES:Record({"models/magtrains1ga/switchbase_left.mdl", "#", "#", 3, "", "-587.75598,-117.69751,0.01599", "0,-157.5,0"})
  PIECES:Record({"models/magtrains1ga/switchbase_right.mdl", "#", "#", 1, "", "0,0,0.01599"})
  PIECES:Record({"models/magtrains1ga/switchbase_right.mdl", "#", "#", 2, "", "-512,0,0.01599", "0,-180,0"})
  PIECES:Record({"models/magtrains1ga/switchbase_right.mdl", "#", "#", 3, "", "-587.75598,117.69751,0.01599", "0,157.5,0"})
  PIECES:Record({"models/magtrains1ga/switch_straight.mdl", "#", "#", 1, "", "0,0,0.01599"})
  PIECES:Record({"models/magtrains1ga/switch_straight.mdl", "#", "#", 2, "", "-384,0,0.01599", "0,-180,0"})
  PIECES:Record({"models/magtrains1ga/switch_curve.mdl", "#", "#", 1, "", "0,0,0.01563"})
  PIECES:Record({"models/magtrains1ga/switch_curve.mdl", "#", "#", 2, "", "-373.42453,-45.55976,0.01562", "0,-166.08,0"})
  asmlib.Categorize("Random Bridges")
  PIECES:Record({"models/props_canal/canal_bridge01.mdl", "#", "#", 1, "", "455.345, -6.815, 201.73"})
  PIECES:Record({"models/props_canal/canal_bridge01.mdl", "#", "#", 2, "", "-456.655, -6.815, 201.73", "0,-180,0"})
  PIECES:Record({"models/props_canal/canal_bridge01b.mdl", "#", "#", 1, "", "910.69, -13.63, 403.46"})
  PIECES:Record({"models/props_canal/canal_bridge01b.mdl", "#", "#", 2, "", "-913.31, -13.63, 403.46", "0,-180,0"})
  PIECES:Record({"models/props_canal/canal_bridge02.mdl", "#", "#", 1, "", "0,  512.155, 288", "0,90,0"})
  PIECES:Record({"models/props_canal/canal_bridge02.mdl", "#", "#", 2, "", "0, -512.212, 288", "0,-90,0"})
  PIECES:Record({"models/props_canal/canal_bridge03a.mdl", "#", "#", 1, "", "320.89, 0, 187.742"})
  PIECES:Record({"models/props_canal/canal_bridge03a.mdl", "#", "#", 2, "", "-320.059, 0, 187.742", "0,-180,0"})
  PIECES:Record({"models/props_canal/canal_bridge03b.mdl", "#", "#", 1, "", "320.89, 0, 187.741"})
  PIECES:Record({"models/props_canal/canal_bridge03b.mdl", "#", "#", 2, "", "-320.059, 0, 187.741", "0,-180,0"})
  PIECES:Record({"models/props_canal/canal_bridge03c.mdl", "#", "#", 1, "", "1026.848, 0, 600.773"})
  PIECES:Record({"models/props_canal/canal_bridge03c.mdl", "#", "#", 2, "", "-1024.189, 0, 600.773", "0,-180,0"})
  asmlib.ModelToNameRule("SET",nil,{"bridge","bridge_","001",""},nil)
  PIECES:Record({"models/props_2fort/bridgesupports001.mdl", "#", "TF Support", 1, "", "448, 0, -14.268"})
  PIECES:Record({"models/props_2fort/bridgesupports001.mdl", "#", "TF Support", 2, "", "-448, 0, -15.558", "0,-180,0"})
  asmlib.ModelToNameRule("SET",nil,{"bridge01_","bridge_"},nil)
  PIECES:Record({"models/askari/bridge01_stlve.mdl", "#", "Stlve", 1, "", "192, 0, 189.531"})
  PIECES:Record({"models/askari/bridge01_stlve.mdl", "#", "Stlve", 2, "", "-192, 0, 189.531", "0,-180,0"})
  asmlib.ModelToNameRule("CLR")
  PIECES:Record({"models/karkar/bridge.mdl", "#", "Karkar", 1, "", "62.07, -343.696, 208.295", "0,-90,0"})
  PIECES:Record({"models/karkar/bridge.mdl", "#", "Karkar", 2, "", "62.07, 334.44, 208.295", "0,90,0"})
  PIECES:Record({"models/karkar/wooden_bridge_helly.mdl", "#", "#", 1, "", "0, 318.601, 26.783", "0,90,0"})
  PIECES:Record({"models/karkar/wooden_bridge_helly.mdl", "#", "#", 2, "", "0, -240.814, 2.85", "0,-90,0"})
  PIECES:Record({"models/karkar/wooden_bridge_helly_broken_bstk.mdl", "#", "#", 1, "", "-318.524, 0, 26.757", "0,-180,0"})
  PIECES:Record({"models/karkar/wooden_bridge_helly_broken_bstk.mdl", "#", "#", 2, "", "244.523, 0, 3.55"})
  PIECES:Record({"models/props/tresslebridge.mdl", "#", "#", 1, "", "374.246, -1.2345, 24.849"})
  PIECES:Record({"models/props/tresslebridge.mdl", "#", "#", 2, "", "-345.367, -1.2345, 24.85", "0,180,0"})
  PIECES:Record({"models/props_combine/combine_bridge.mdl", "#", "#", 1, "", "-8.401, 0, 124.685"})
  PIECES:Record({"models/props_combine/combine_bridge.mdl", "#", "#", 2, "", "-320, 0, 124.685", "0,180,0"})
  PIECES:Record({"models/props_combine/combine_bridge_b.mdl", "#", "#", 1, "", "-330.895, 0.039, 124.673"})
  PIECES:Record({"models/props_combine/combine_bridge_b.mdl", "#", "#", 2, "", "-522.855, 0.251, 124.671", "0,180,0"})
  PIECES:Record({"models/props_swamp/big_jetty.mdl", "#", "#", 1, "", "0, 116.668, 57.94", "0,90,0"})
  PIECES:Record({"models/props_swamp/big_jetty.mdl", "#", "#", 2, "", "0, -11.914, 57.939", "0,-90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_128.mdl", "#", "#", 1, "", "0, 67.452, 14.326", "0, 90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_128.mdl", "#", "#", 2, "", "0,-63.954, 14.325", "0,-90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_256.mdl", "#", "#", 1, "", "0, 131.491, 14.199", "0, 90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_256.mdl", "#", "#", 2, "", "0,-139.388, 14.198", "0,-90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_384.mdl", "#", "#", 1, "", "0, 199.517, 14.302", "0, 90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_384.mdl", "#", "#", 2, "", "0,-196.069, 14.215", "0,-90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_tall_128.mdl", "#", "#", 1, "", "0, 67.244, 14.323", "0, 90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_tall_128.mdl", "#", "#", 2, "", "0,-63.033, 14.337", "0,-90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_tall_256.mdl", "#", "#", 1, "", "0, 131.502, 14.339", "0, 90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_tall_256.mdl", "#", "#", 2, "", "0,-127.085, 14.319", "0,-90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_tall_384.mdl", "#", "#", 1, "", "0, 199.517, 14.332", "0, 90,0"})
  PIECES:Record({"models/props_swamp/boardwalk_tall_384.mdl", "#", "#", 2, "", "0,-196.012, 14.318", "0,-90,0"})
  PIECES:Record({"models/props_viaduct_event/underworld_bridge01.mdl", "#", "#", 1, "", "0,  68.767, 14.898", "0, 90,0"})
  PIECES:Record({"models/props_viaduct_event/underworld_bridge01.mdl", "#", "#", 2, "", "0, -70.316, 14.898", "0,-90,0"})
  PIECES:Record({"models/props_viaduct_event/underworld_bridge02.mdl", "#", "#", 1, "", "5.236, -13.396, 11.976", "0,-90,0"})
  PIECES:Record({"models/props_viaduct_event/underworld_bridge02.mdl", "#", "#", 2, "", "5.236, 479.851, 11.976", "0, 90,0"})
  PIECES:Record({"models/props_viaduct_event/underworld_bridge03.mdl", "#", "#", 1, "", "1.436, -12.169, 11.136", "0,-90,0"})
  PIECES:Record({"models/props_viaduct_event/underworld_bridge03.mdl", "#", "#", 2, "", "1.436, 480.851, 11.136", "0, 90,0"})
  PIECES:Record({"models/props_viaduct_event/underworld_bridge04.mdl", "#", "#", 1, "", "-2.253, -11.847, 10.696", "0,-90,0"})
  PIECES:Record({"models/props_viaduct_event/underworld_bridge04.mdl", "#", "#", 2, "", "-2.253, 480.851, 10.696", "0, 90,0"})
  PIECES:Record({"models/props_wasteland/bridge_low_res.mdl", "#", "#", 1, "", "5056, 219.145, 992.765"})
  PIECES:Record({"models/props_wasteland/bridge_low_res.mdl", "#", "#", 2, "", "-576, 219.145, 992.765", "0, 180,0"})
  asmlib.Categorize("StevenTechno's Buildings 1.0",[[function(m)
    local r = m:gsub("models/buildingspack/",""):gsub("%W.+$","")
    if  (r:find("emptylots")) then r = "empty_lots"
    elseif(r:find("roadsdw")) then r = r:gsub("roadsdw","double_")
    elseif(r:find("roadsw" )) then r = r:gsub("roadsw" ,"single_") end; return r; end]])
  asmlib.ModelToNameRule("SET",{1,3})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_1road_dl_sdw_1x1.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_1road_dl_sdw_1x1.mdl", "#", "#", 2, "", "-72,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_2road_dl_sdw_1x2.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_2road_dl_sdw_1x2.mdl", "#", "#", 2, "", "-144,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_3road_dl_sdw_1x3.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_3road_dl_sdw_1x3.mdl", "#", "#", 2, "", "-216,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_4road_dl_sdw_1x4.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_4road_dl_sdw_1x4.mdl", "#", "#", 2, "", "-288,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_5road_dl_sdw_1x5.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_5road_dl_sdw_1x5.mdl", "#", "#", 2, "", "-360,0,3.03125", "0,180,0"})
  asmlib.ModelToNameRule("SET",{1,4})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_10road_dl_sdw_1x32.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_10road_dl_sdw_1x32.mdl", "#", "#", 2, "", "-2304,0,3.03125", "0,180,0"})
  asmlib.ModelToNameRule("SET",nil,{"lot","lot_"},nil)
  PIECES:Record({"models/buildingspack/emptylots/lot16x16.mdl", "#", "#", 1, "", "-268, 575, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot16x16.mdl", "#", "#", 2, "", "-268, -577.002, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot16x16fence.mdl", "#", "#", 1, "", "-268, 575, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot16x16fence.mdl", "#", "#", 2, "", "-268, -577.002, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot32x32.mdl", "#", "#", 1, "", "-268, 1152.002, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot32x32.mdl", "#", "#", 2, "", "-267.999, -1151.292, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot32x32fence.mdl", "#", "#", 1, "", "-268, 1152.002, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot32x32fence.mdl", "#", "#", 2, "", "-267.999, -1151.292, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot8x8fence.mdl", "#", "#", 1, "", "-268, 288, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot8x8fence.mdl", "#", "#", 2, "", "-268, -287.996, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot8x8.mdl", "#", "#", 1, "", "-268, 288, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/emptylots/lot8x8.mdl", "#", "#", 2, "", "-268, -287.996, 3.03125", "0,-90,0"})
  asmlib.ModelToNameRule("SET",{1,3})
  PIECES:Record({"models/buildingspack/housing/3_0apartments_0.mdl", "#", "#", 1, "", "-268, 612.001, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/housing/3_0apartments_0.mdl", "#", "#", 2, "", "-268, -612, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/housing/3_1apartments_1.mdl", "#", "#", 1, "", "-268, 1248, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/housing/3_1apartments_1.mdl", "#", "#", 2, "", "-268, -1200, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/housing/3_3apartments_3.mdl", "#", "#", 1, "", "-268.008, 574.913, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/housing/3_3apartments_3.mdl", "#", "#", 2, "", "-268, -577, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/misc/6_2skyscraper1.mdl", "#", "#", 1, "", "0, -916, 3.03125"})
  PIECES:Record({"models/buildingspack/misc/6_2skyscraper1.mdl", "#", "#", 2, "", "0,  916, 3.03125"})
  PIECES:Record({"models/buildingspack/misc/6_2skyscraper1.mdl", "#", "#", 3, "", "-340, 1256, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/misc/6_2skyscraper1.mdl", "#", "#", 4, "", "-2172, 1256, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/misc/6_2skyscraper1.mdl", "#", "#", 5, "", "-2512, 916, 3.03125", "0,-180,0"})
  PIECES:Record({"models/buildingspack/misc/6_2skyscraper1.mdl", "#", "#", 6, "", "-2512, -916, 3.03125", "0,-180,0"})
  PIECES:Record({"models/buildingspack/misc/6_2skyscraper1.mdl", "#", "#", 7, "", "-2172, -1256, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/misc/6_2skyscraper1.mdl", "#", "#", 8, "", "-340, -1256, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/misc/6_3skyscraper2.mdl", "#", "#", 1, "", "0, -916, 3.03125"})
  PIECES:Record({"models/buildingspack/misc/6_3skyscraper2.mdl", "#", "#", 2, "", "0,  916, 3.03125"})
  PIECES:Record({"models/buildingspack/misc/6_3skyscraper2.mdl", "#", "#", 3, "", "-340, 1256, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/misc/6_3skyscraper2.mdl", "#", "#", 4, "", "-2172, 1256, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/misc/6_3skyscraper2.mdl", "#", "#", 5, "", "-2512, 916, 3.03125", "0,-180,0"})
  PIECES:Record({"models/buildingspack/misc/6_3skyscraper2.mdl", "#", "#", 6, "", "-2512, -916, 3.03125", "0,-180,0"})
  PIECES:Record({"models/buildingspack/misc/6_3skyscraper2.mdl", "#", "#", 7, "", "-2172, -1256, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/misc/6_3skyscraper2.mdl", "#", "#", 8, "", "-340, -1256, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/misc/6_4skyscraper3.mdl", "#", "#", 1, "", "0, -1492, 3.03125"})
  PIECES:Record({"models/buildingspack/misc/6_4skyscraper3.mdl", "#", "#", 2, "", "0,  1492, 3.03125"})
  PIECES:Record({"models/buildingspack/misc/6_4skyscraper3.mdl", "#", "#", 3, "", "-340, 1832, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/misc/6_4skyscraper3.mdl", "#", "#", 4, "", "-2172, 1832, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/misc/6_4skyscraper3.mdl", "#", "#", 5, "", "-2512, 1492, 3.03125", "0,-180,0"})
  PIECES:Record({"models/buildingspack/misc/6_4skyscraper3.mdl", "#", "#", 6, "", "-2512, -1492, 3.03125", "0,-180,0"})
  PIECES:Record({"models/buildingspack/misc/6_4skyscraper3.mdl", "#", "#", 7, "", "-2172, -1832, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/misc/6_4skyscraper3.mdl", "#", "#", 8, "", "-340, -1832, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/recreational/5_1club_lgbt.mdl", "#", "#", 1, "", "-268, 720, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/recreational/5_1club_lgbt.mdl", "#", "#", 2, "", "-268, -720, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/recreational/5_2stripclub.mdl", "#", "#", 1, "", "-268, 736, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/recreational/5_2stripclub.mdl", "#", "#", 2, "", "-268, -736, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/schultz/stores/4_0office.mdl", "#", "#", 1, "", "-267.986, 616.053, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/schultz/stores/4_0office.mdl", "#", "#", 2, "", "-268, -608, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/schultz/stores/4_1garage.mdl", "#", "#", 1, "", "-268, 698, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/schultz/stores/4_1garage.mdl", "#", "#", 2, "", "-268, -598, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/stores/4_1gas_station_a.mdl", "#", "#", 1, "", "-268, 604, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/stores/4_1gas_station_a.mdl", "#", "#", 2, "", "-268, -620, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/stores/4_1gas_station_b.mdl", "#", "#", 1, "", "-268, 612, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/stores/4_1gas_station_b.mdl", "#", "#", 2, "", "-268, -612, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/stores/4_3gunshop.mdl", "#", "#", 1, "", "-268, 504.001, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/stores/4_3gunshop.mdl", "#", "#", 2, "", "-268, -504, 3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/stores/4_4bank.mdl", "#", "#", 1, "", "-268, 504, 2.031232", "0,90,0"})
  PIECES:Record({"models/buildingspack/stores/4_4bank.mdl", "#", "#", 2, "", "-268, -504, 2.031232", "0,-90,0"})
  PIECES:Record({"models/buildingspack/stores/4_2pcshop.mdl", "#", "#", 1, "", "-268, 432, 3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/stores/4_2pcshop.mdl", "#", "#", 2, "", "-268, -432, 3.03125", "0,-90,0"})
  asmlib.ModelToNameRule("SET",{1,4},{"ion_","_"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_11road_intersection_4w.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_11road_intersection_4w.mdl", "#", "#", 2, "", "-340,340,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_11road_intersection_4w.mdl", "#", "#", 3, "", "-680,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_11road_intersection_4w.mdl", "#", "#", 4, "", "-340,-340,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_12road_intersection_3w.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_12road_intersection_3w.mdl", "#", "#", 2, "", "-340,340,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_12road_intersection_3w.mdl", "#", "#", 3, "", "-340,-340,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_13road_intersection_2w.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_13road_intersection_2w.mdl", "#", "#", 2, "", "-340,-340,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_14road_intersection_deadend.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_16road_intersection_turn2_16.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_16road_intersection_turn2_16.mdl", "#", "#", 2, "", "-1564,1564,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_15road_intersection_turn1.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadswsidewalk/2_15road_intersection_turn1.mdl", "#", "#", 2, "", "-340,-340,3.03125", "0,-90,0"})
  asmlib.ModelToNameRule("SET",{1,3},{"sdwhwy","_"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy1x1.mdl" , "#", "#", 1, "", "0,0,316.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy1x1.mdl" , "#", "#", 2, "", "-72,0,316.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_2roadsdwhwy1x4.mdl" , "#", "#", 1, "", "0,0,316.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_2roadsdwhwy1x4.mdl" , "#", "#", 2, "", "-288,0,316.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_3roadsdwhwy1x8.mdl" , "#", "#", 1, "", "0,0,316.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_3roadsdwhwy1x8.mdl" , "#", "#", 2, "", "-576,0,316.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_4roadsdwhwy1x16.mdl", "#", "#", 1, "", "0,0,316.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_4roadsdwhwy1x16.mdl", "#", "#", 2, "", "-1152,0,316.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_5roadsdwhwy1x32.mdl", "#", "#", 1, "", "0,0,316.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_5roadsdwhwy1x32.mdl", "#", "#", 2, "", "-2304,0,316.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_6roadsdwhwy1x64.mdl", "#", "#", 1, "", "0,0,316.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_6roadsdwhwy1x64.mdl", "#", "#", 2, "", "-4608,0,316.03125", "0,180,0"})
  asmlib.ModelToNameRule("SET",{1,3},{"sdwhwy","_","bridge","bridge_"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_8roadsdwhwybridge1x4.mdl", "#", "#", 1, "", "0,0,60.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_8roadsdwhwybridge1x4.mdl", "#", "#", 2, "", "-288,0,60.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_9roadsdwhwybridge1x8.mdl", "#", "#", 1, "", "0,0,60.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_9roadsdwhwybridge1x8.mdl", "#", "#", 2, "", "-576,0,60.03125", "0,180,0"})
  asmlib.ModelToNameRule("SET",{1,4},{"sdwhwy","_"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_10roadsdwhwybridge1x16.mdl", "#", "#", 1, "", "0,0,60.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_10roadsdwhwybridge1x16.mdl", "#", "#", 2, "", "-1152,0,60.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_11roadsdwhwybridge1x32.mdl", "#", "#", 1, "", "0,0,60.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_11roadsdwhwybridge1x32.mdl", "#", "#", 2, "", "-2304,0,60.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_12roadsdwhwybridge1x64.mdl", "#", "#", 1, "", "0,0,60.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_12roadsdwhwybridge1x64.mdl", "#", "#", 2, "", "-4608,0,60.03125", "0,180,0"})
  asmlib.ModelToNameRule("SET",{1,3},{"sdwhwy_","_","turn1","turn"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_7roadsdwhwy_turn1.mdl", "#", "#", 1, "", "0,0,316.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_7roadsdwhwy_turn1.mdl", "#", "#", 2, "", "-1692,1692,316.03125", "0,90,0"})
  asmlib.ModelToNameRule("SET",{1,3})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_0roadsdwsidewalktransfer.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_0roadsdwsidewalktransfer.mdl", "#", "#", 2, "", "-376,0,3.03125", "0,-180,0"})
  asmlib.ModelToNameRule("SET",{1,4},{"sdw","_"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_11roadsdwsidewalk_int_4way.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_11roadsdwsidewalk_int_4way.mdl", "#", "#", 2, "", "-540,540,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_11roadsdwsidewalk_int_4way.mdl", "#", "#", 3, "", "-1080,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_11roadsdwsidewalk_int_4way.mdl", "#", "#", 4, "", "-540,-540,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_12roadsdwsidewalk_int_3way.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_12roadsdwsidewalk_int_3way.mdl", "#", "#", 2, "", "-540,540,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_12roadsdwsidewalk_int_3way.mdl", "#", "#", 3, "", "-540,-540,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_13roadsdwsidewalk_int_2way.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_13roadsdwsidewalk_int_2way.mdl", "#", "#", 2, "", "-540,540,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_14roadsdwsidewalk_turn_1.mdl", "#", "#", 1, "", "0,-4,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_14roadsdwsidewalk_turn_1.mdl", "#", "#", 2, "", "-540,-544,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_15roadsdwsidewalk_turn_2.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_15roadsdwsidewalk_turn_2.mdl", "#", "#", 2, "", "-1692,1692,3.03125", "0,90,0"})
  asmlib.ModelToNameRule("SET",{1,3},{"sdw","_","walk","walk_"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_1roadsdwsidewalk1x1.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_1roadsdwsidewalk1x1.mdl", "#", "#", 2, "", "-72,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_2roadsdwsidewalk1x2.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_2roadsdwsidewalk1x2.mdl", "#", "#", 2, "", "-144,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_3roadsdwsidewalk1x3.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_3roadsdwsidewalk1x3.mdl", "#", "#", 2, "", "-216,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_4roadsdwsidewalk1x4.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_4roadsdwsidewalk1x4.mdl", "#", "#", 2, "", "-288,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_5roadsdwsidewalk1x5.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_5roadsdwsidewalk1x5.mdl", "#", "#", 2, "", "-360,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_6roadsdwsidewalk1x6.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_6roadsdwsidewalk1x6.mdl", "#", "#", 2, "", "-432,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_7roadsdwsidewalk1x7.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_7roadsdwsidewalk1x7.mdl", "#", "#", 2, "", "-504,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_8roadsdwsidewalk1x8.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_8roadsdwsidewalk1x8.mdl", "#", "#", 2, "", "-576,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_9roadsdwsidewalk1x16.mdl","#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_9roadsdwsidewalk1x16.mdl","#", "#", 2, "", "-1152,0,3.03125", "0,180,0"})
  asmlib.ModelToNameRule("SET",{1,4},{"sdw","_","walk","walk_"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_10roadsdwsidewalk1x32.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwsidewalk/0_10roadsdwsidewalk1x32.mdl", "#", "#", 2, "", "-2304,0,3.03125", "0,180,0"})
  asmlib.ModelToNameRule("SET",{1,3},{"sdwhwy_","_"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 2, "", "-1632,1152,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 3, "", "-2304,1152,315.031616", "0,90,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 4, "", "-2976,1152,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 5, "", "-2976.007,-1151.975,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 6, "", "-2304,-1152,315.031616", "0,-90,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 7, "", "-1632,-1152,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 8, "", "-4608,0,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_1roadsdwhwy_ramp_2.mdl", "#", "#", 1, "", "0,-671.994,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_1roadsdwhwy_ramp_2.mdl", "#", "#", 2, "", "0,0,315.031616"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_1roadsdwhwy_ramp_2.mdl", "#", "#", 3, "", "0,671.995,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_1roadsdwhwy_ramp_2.mdl", "#", "#", 4, "", "-4608,0,315.031616", "0,-180,0"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_1roadsdwhwy_ramp_stop.mdl", "#", "#", 1, "", "0,-671.994,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_1roadsdwhwy_ramp_stop.mdl", "#", "#", 2, "", "0,0,315.031616"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_1roadsdwhwy_ramp_stop.mdl", "#", "#", 3, "", "0,671.995,3.03125"})
  PIECES:Record({"models/buildingspack/roadsdwhighway/1_1roadsdwhwy_ramp_stop.mdl", "#", "#", 4, "", "-4160,0,15.202", "0,-180,0"})
  asmlib.Categorize("Portal Tubes")
  PIECES:Record({"models/props_bts/clear_tube_straight.mdl", "#", "#", 1, "", "0.009,0    , 63.896", "-90,  0,180"})
  PIECES:Record({"models/props_bts/clear_tube_straight.mdl", "#", "#", 2, "", "0.008,0.004,-63.897", " 90,180,180"})
  PIECES:Record({"models/props_bts/clear_tube_90deg.mdl" , "#", "#", 1, "", "64.041,0.049,  0.131"})
  PIECES:Record({"models/props_bts/clear_tube_90deg.mdl" , "#", "#", 2, "", " 0.002,0.040,-63.904", "90,0,180"})
  PIECES:Record({"models/props_bts/clear_tube_broken.mdl", "#", "#", 1, "", "0.009,0    , 63.896", "-90,  0,180"})
  PIECES:Record({"models/props_bts/clear_tube_broken.mdl", "#", "#", 2, "", "0.008,0.004,-63.897", " 90,180,180"})
  PIECES:Record({"models/props_bts/clear_tube_tjoint.mdl", "#", "#", 1, "", "-0.014,0.13,96.075", "-90,0,180"})
  PIECES:Record({"models/props_bts/clear_tube_tjoint.mdl", "#", "#", 2, "", "-0.004,-95.763,0.016", "0,-90,-90"})
  PIECES:Record({"models/props_bts/clear_tube_tjoint.mdl", "#", "#", 3, "", "0,96,0.083", "0,90,90"})
  asmlib.Categorize("Mr.Train's M-Gauge",[[function(m)
    local r = m:gsub("models/props/m_gauge/track/m_gauge_","")
    local n = r:gsub("%.mdl", ""); r = r:gsub("%W.+$","")
    if(tonumber(r:sub(1,1))) then r = "straight" else n = n:gsub(r.."_", "") end; return r, n; end]])
  asmlib.ModelToNameRule("SET",nil,{"m_gauge","straight"},nil)
  PIECES:Record({"models/props/m_gauge/track/m_gauge_32.mdl", "#", "#", 1, "", "16,0,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_32.mdl", "#", "#", 2, "", "-16,0,0.016", "0,-180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_64.mdl", "#", "#", 1, "", "32,0,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_64.mdl", "#", "#", 2, "", "-32,0,0.016", "0,-180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_128.mdl", "#", "#", 1, "", "64,0,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_128.mdl", "#", "#", 2, "", "-64,0,0.016", "0,-180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_256.mdl", "#", "#", 1, "", "128,0,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_256.mdl", "#", "#", 2, "", "-128,0,0.016", "0,-180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_512.mdl", "#", "#", 1, "", "256,0,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_512.mdl", "#", "#", 2, "", "-256,0,0.016", "0,-180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_1024.mdl", "#", "#", 1, "", "512,0,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_1024.mdl", "#", "#", 2, "", "-512,0,0.016", "0,-180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_2048.mdl", "#", "#", 1, "", "1024,0,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_2048.mdl", "#", "#", 2, "", "-1024,0,0.016", "0,-180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_4096.mdl", "#", "#", 1, "", "2048,0,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_4096.mdl", "#", "#", 2, "", "-2048,0,0.016", "0,-180,0"})
  asmlib.ModelToNameRule("SET",nil,{"_cross","","m_gauge_","cross_"},nil)
  PIECES:Record({"models/props/m_gauge/track/m_gauge_128_cross.mdl", "#", "#", 1, "", "64,0,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_128_cross.mdl", "#", "#", 2, "", "0,64,0.016", "0,90,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_128_cross.mdl", "#", "#", 3, "", "-64,0,0.016", "0,-180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_128_cross.mdl", "#", "#", 4, "", "0,-64,0.016", "0,-90,0"})
  asmlib.ModelToNameRule("SET",nil,{"m_gauge_",""},nil)
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_256.mdl", "#", "#", 1, "", "134.497,121.499,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_256.mdl", "#", "#", 2, "", "-121.5,-134.5,0.016", "0,-90,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_512.mdl", "#", "#", 1, "", "262.5,249.5,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_512.mdl", "#", "#", 2, "", "-249.5,-262.5,0.016", "0,-90,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_768.mdl", "#", "#", 1, "", "383.625,370.625,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_768.mdl", "#", "#", 2, "", "-370.625,-383.625,0.016", "0,-90,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_1024.mdl", "#", "#", 1, "", "518.5,505.5,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_1024.mdl", "#", "#", 2, "", "-505.5,-518.5,0.016", "0,-90,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_512_45.mdl", "#", "#", 1, "", "262.5,-249.497,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_512_45.mdl", "#", "#", 2, "", "-99.51,-99.507,0.015", "0,135,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_768_45.mdl", "#", "#", 1, "", "383.625,370.625,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_768_45.mdl", "#", "#", 2, "", "-149.73,149.729,0.016", "0,-135,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_1024_45.mdl", "#", "#", 1, "", "518.5,505.5,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_left_1024_45.mdl", "#", "#", 2, "", "-205.608,205.607,0.014", "0,-135,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_256.mdl", "#", "#", 1, "", "134.5,-121.5,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_256.mdl", "#", "#", 2, "", "-121.5,134.5,0.016", "0,90,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_512.mdl", "#", "#", 1, "", "262.5,-249.5,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_512.mdl", "#", "#", 2, "", "-249.5,262.5,0.016", "0,90,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_768.mdl", "#", "#", 1, "", "383.625,-370.625,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_768.mdl", "#", "#", 2, "", "-370.625,383.625,0.016", "0,90,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_1024.mdl", "#", "#", 1, "", "518.5,-505.5,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_1024.mdl", "#", "#", 2, "", "-505.5,518.5,0.016", "0,90,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_768_45.mdl", "#", "#", 1, "", "383.625,-370.625,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_768_45.mdl", "#", "#", 2, "", "-149.758,-149.751,0.012", "0,135,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_1024_45.mdl", "#", "#", 1, "", "518.5,-505.498,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_right_1024_45.mdl", "#", "#", 2, "", "-205.621,-205.618,0.014", "0,135,0"})
  asmlib.ModelToNameRule("SET",nil,{"m_gauge_","","over",""},nil)
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover.mdl", "#", "#", 1, "", "203,-75,-2.484"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover.mdl", "#", "#", 2, "", "203,75,-2.484"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover.mdl", "#", "#", 3, "", "-203,75,-2.484", "0,180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover.mdl", "#", "#", 4, "", "-203,-75,-2.484", "0,180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover_sl.mdl", "#", "#", 1, "", "75,-75,-2.484"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover_sl.mdl", "#", "#", 2, "", "203,75,-2.484"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover_sl.mdl", "#", "#", 3, "", "-75,75,-2.484", "0,180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover_sl.mdl", "#", "#", 4, "", "-203,-75,-2.484", "0,180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover_sr.mdl", "#", "#", 1, "", "203,-75,-2.484"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover_sr.mdl", "#", "#", 2, "", "75,75,-2.484"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover_sr.mdl", "#", "#", 3, "", "-203,75,-2.484", "0,180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_crossover_sr.mdl", "#", "#", 4, "", "-75,-75,-2.485", "0,180,0"})
  asmlib.ModelToNameRule("SET",nil,{"m_gauge_","","hand",""},nil)
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_lefthand.mdl", "#", "#", 1, "", "0,-10,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_lefthand.mdl", "#", "#", 2, "", "-256,-10,0.016", "0,180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_lefthand.mdl", "#", "#", 3, "", "-384,-160,0.016", "0,180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_righthand.mdl", "#", "#", 1, "", "0,10,0.016"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_righthand.mdl", "#", "#", 2, "", "-384,160,0.016", "0,180,0"})
  PIECES:Record({"models/props/m_gauge/track/m_gauge_switch_righthand.mdl", "#", "#", 3, "", "-256,10,0.016", "0,180,0"})
  asmlib.Categorize("Mr.Train's G-Gauge",[[function(m)
    local r = m:gsub("models/props/g_gauge/track/g_gauge_track_","")
    local n = r:gsub("%.mdl",""); r = r:gsub("%W.+$","")
    n = n:gsub(r.."_", ""); if(r == "s") then r = "curves" end; return r, n end]])
  asmlib.ModelToNameRule("SET",nil,{"g_gauge_track_",""},nil)
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_32.mdl"  , "#", "#", 1, "", " 16,0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_32.mdl"  , "#", "#", 2, "", "-16,0,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_ramp_1.mdl", "#", "#", 1, "", " 16,0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_ramp_1.mdl", "#", "#", 2, "", "-16,0,3.016", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_ramp_2.mdl", "#", "#", 1, "", " 16,0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_ramp_2.mdl", "#", "#", 2, "", "-16,0,4.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_ramp_3.mdl", "#", "#", 1, "", " 16,0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_ramp_3.mdl", "#", "#", 2, "", "-16,0,6.016", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_64.mdl"  , "#", "#", 1, "", " 32,0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_64.mdl"  , "#", "#", 2, "", "-32,0,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_128.mdl" , "#", "#", 1, "", " 64,0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_128.mdl" , "#", "#", 2, "", "-64,0,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_cross_128.mdl", "#", "#", 1, "", " 64,  0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_cross_128.mdl", "#", "#", 2, "", " 0 , 64,1.516", "0,90,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_cross_128.mdl", "#", "#", 3, "", "-64,  0,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_cross_128.mdl", "#", "#", 4, "", " 0 ,-64,1.516", "0,-90,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_256.mdl" , "#", "#", 1, "", " 128, 0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_256.mdl" , "#", "#", 2, "", "-128, 0,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_512.mdl" , "#", "#", 1, "", " 256, 0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_512.mdl" , "#", "#", 2, "", "-256, 0,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_1024.mdl", "#", "#", 1, "", " 512, 0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_1024.mdl", "#", "#", 2, "", "-512, 0,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_2048.mdl", "#", "#", 1, "", " 1024,0,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_straight_2048.mdl", "#", "#", 2, "", "-1024,0,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_s_right_22_5.mdl", "#", "#", 1, "", " 256,-39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_s_right_22_5.mdl", "#", "#", 2, "", "-256, 39,1.516" , "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_s_left_22_5.mdl" , "#", "#", 1, "", " 256, 39,1.516" })
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_s_left_22_5.mdl" , "#", "#", 2, "", "-256,-39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_right_1.mdl", "#", "#", 1, "", " 256,-39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_right_1.mdl", "#", "#", 2, "", "   0,-39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_right_1.mdl", "#", "#", 3, "", "-256, 39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_right_2.mdl", "#", "#", 1, "", " 256,-39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_right_2.mdl", "#", "#", 2, "", "   0,-39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_right_2.mdl", "#", "#", 3, "", "-256, 39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_left_1.mdl", "#", "#", 1, "", " 256,39 ,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_left_1.mdl", "#", "#", 2, "", "   0,39 ,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_left_1.mdl", "#", "#", 3, "", "-256,-39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_left_2.mdl", "#", "#", 1, "", " 256,39 ,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_left_2.mdl", "#", "#", 2, "", "   0,39 ,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_1_left_2.mdl", "#", "#", 3, "", "-256,-39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_right_1.mdl", "#", "#", 1, "", "195.938,39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_right_1.mdl", "#", "#", 2, "", "195.938,-39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_right_1.mdl", "#", "#", 3, "", "-195.937,-39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_right_1.mdl", "#", "#", 4, "", "-195.937,39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_right_2.mdl", "#", "#", 1, "", "195.938,39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_right_2.mdl", "#", "#", 2, "", "195.938,-39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_right_2.mdl", "#", "#", 3, "", "-195.937,-39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_right_2.mdl", "#", "#", 4, "", "-195.937,39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_left_1.mdl", "#", "#", 1, "", "195.938,39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_left_1.mdl", "#", "#", 2, "", "195.938,-39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_left_1.mdl", "#", "#", 3, "", "-195.937,-39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_left_1.mdl", "#", "#", 4, "", "-195.937,39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_left_2.mdl", "#", "#", 1, "", "195.938,39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_left_2.mdl", "#", "#", 2, "", "195.938,-39,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_left_2.mdl", "#", "#", 3, "", "-195.937,-39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_switch_2_left_2.mdl", "#", "#", 4, "", "-195.937,39,1.516", "0,-180,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_right_22_5.mdl", "#", "#", 1, "", "263.75,-248.25,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_right_22_5.mdl", "#", "#", 2, "", "67.872,-209.299,1.516", "0,157.5,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_right_45.mdl"  , "#", "#", 1, "", "263.75,-248.25,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_right_45.mdl"  , "#", "#", 2, "", "-98.302,-98.302,1.516", "0,135,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_right_90.mdl"  , "#", "#", 1, "", "263.75,-248.25,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_right_90.mdl"  , "#", "#", 2, "", "-248.25,263.75,1.516", "0,90,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_left_22_5.mdl" , "#", "#", 1, "", "263.75, 248.25,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_left_22_5.mdl" , "#", "#", 2, "", "67.855,209.265,1.516", "0,-157.5,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_left_45.mdl"   , "#", "#", 1, "", "263.75, 248.25,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_left_45.mdl"   , "#", "#", 2, "", "-98.326,98.323,1.516", "0,-135,0"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_left_90.mdl"   , "#", "#", 1, "", "263.75, 248.25,1.516"})
  PIECES:Record({"models/props/g_gauge/track/g_gauge_track_turn_left_90.mdl"   , "#", "#", 2, "", "-248.25,-263.75,1.516", "0,-90,0"})
  asmlib.Categorize("Bobster's two feet rails",[[function(m) local o = {}
    local n = m:gsub("models/bobsters_trains/rails/2ft/","")
    local r = n:match("^%a+"); n = n:gsub("%.mdl","")
    for w in n:gmatch("%a+") do
      if(r:find(w)) then n = n:gsub(w.."%W+", "") end
    end table.insert(o, r); local f = n:match("^%a+")
    if(f) then table.insert(o, f); n = n:gsub(f.."%W+", "") end; return o, n; end]])
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_16.mdl", "#", "#", 1, "0,-32,1.5", "8,0,3.017"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_16.mdl", "#", "#", 2, "0,32,1.5", "-8,0,3.017", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_32.mdl", "#", "#", 1, "0,-32,1.5", "16,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_32.mdl", "#", "#", 2, "0,32,1.5", "-16,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_64.mdl", "#", "#", 1, "", "32,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_64.mdl", "#", "#", 2, "", "-32,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_128.mdl", "#", "#", 1, "", "64,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_128.mdl", "#", "#", 2, "", "-64,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_bank_left.mdl", "#", "#", 1, "", " 128,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_bank_left.mdl", "#", "#", 2, "", "-128,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_bank_right.mdl", "#", "#", 1, "", " 128,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_bank_right.mdl", "#", "#", 2, "", "-128,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_256.mdl", "#", "#", 1, "", "128,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_256.mdl", "#", "#", 2, "", "-128,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_512.mdl", "#", "#", 1, "", "256,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_512.mdl", "#", "#", 2, "", "-256,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_1024.mdl", "#", "#", 1, "", "512,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_1024.mdl", "#", "#", 2, "", "-512,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_2048.mdl", "#", "#", 1, "", " 1024,0,3.017"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_2048.mdl", "#", "#", 2, "", "-1024,0,3.017", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_4096.mdl", "#", "#", 1, "", " 2048,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_4096.mdl", "#", "#", 2, "", "-2048,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_16.mdl", "#", "#", 1, "0,-32,1.5", "8,0,3.017"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_16.mdl", "#", "#", 2, "0,32,1.5", "-8,0,3.017", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_32.mdl", "#", "#", 1, "0,-32,1.5", "16,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_32.mdl", "#", "#", 2, "0,32,1.5", "-16,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_64.mdl", "#", "#", 1, "", "32,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_64.mdl", "#", "#", 2, "", "-32,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_128.mdl", "#", "#", 1, "", "64,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_128.mdl", "#", "#", 2, "", "-64,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_256.mdl", "#", "#", 1, "", "128,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_256.mdl", "#", "#", 2, "", "-128,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_512.mdl", "#", "#", 1, "", "256,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_512.mdl", "#", "#", 2, "", "-256,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_1024.mdl", "#", "#", 1, "", "512,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/straight_rack_1024.mdl", "#", "#", 2, "", "-512,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_right_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_right_512.mdl", "#", "#", 2, "", "124.736,-24.811,3.016", "0,-22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_left_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_left_512.mdl", "#", "#", 2, "", "124.735,24.812,3.016", "0,22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_right_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_right_1024.mdl", "#", "#", 2, "", "249.471,-49.623,3.016", "0,-22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_left_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_left_1024.mdl", "#", "#", 2, "", "249.471,49.621,3.016", "0,22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_right_2048.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_right_2048.mdl", "#", "#", 2, "", "498.945,-99.237,3.016", "0,-22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_left_2048.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_225_left_2048.mdl", "#", "#", 2, "", "498.941,99.246,3.016", "0,22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_left_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_left_512.mdl", "#", "#", 2, "", "230.481,95.468,3.016", "0,45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_right_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_right_512.mdl", "#", "#", 2, "", "230.481,-95.469,3.016", "0,-45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_right_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_right_1024.mdl", "#", "#", 2, "", "460.963,-190.936,3.016", "0,-45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_left_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_left_1024.mdl", "#", "#", 2, "", "460.962,190.936,3.016", "0,45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_right_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_right_512.mdl", "#", "#", 2, "", "325.949,-325.949,3.016", "0,-90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_left_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_left_512.mdl", "#", "#", 2, "", "325.949,325.95,3.016", "0,90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_right_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_right_1024.mdl", "#", "#", 2, "", "651.898,-651.899,3.016", "0,-90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_left_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_left_1024.mdl", "#", "#", 2, "", "651.898,651.898,3.016", "0,90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_right_2048.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_right_2048.mdl", "#", "#", 2, "", "1303.797,-1303.797,3.016", "0,-90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_left_2048.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_90_left_2048.mdl", "#", "#", 2, "", "1303.797,1303.797,3.016", "0,90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_right_2048.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_right_2048.mdl", "#", "#", 2, "", "921.925,-381.872,3.016", "0,-45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_left_2048.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_45_left_2048.mdl", "#", "#", 2, "", "921.925,381.872,3.016", "0,45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_right_512.mdl" , "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_right_512.mdl" , "#", "#", 2, "", "325.949,-325.949,3.016", "0,-90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_right_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_right_1024.mdl", "#", "#", 2, "", "651.926,-651.874,3.016", "0,-90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_right_2048.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_right_2048.mdl", "#", "#", 2, "", "1303.798,-1303.797,3.016", "0,-90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_left_512.mdl" , "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_left_512.mdl" , "#", "#", 2, "", "325.949,325.949,3.016", "0,90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_left_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_left_1024.mdl", "#", "#", 2, "", "651.899,651.898,3.016", "0,90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_left_2048.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_bank_90_left_2048.mdl", "#", "#", 2, "", "1303.797,1303.797,3.016", "0,90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/misc/cross.mdl", "#", "#", 1, "", "83,0,3.015"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/misc/cross.mdl", "#", "#", 2, "", "0.003,83,3.015", "0,90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/misc/cross.mdl", "#", "#", 3, "", "-83,0.003,3.015", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/misc/cross.mdl", "#", "#", 4, "", "0,-83,3.015", "0,-90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_left_switched.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_left_switched.mdl", "#", "#", 2, "", "256,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_left_switched.mdl", "#", "#", 3, "", "262.471,49.622,3.016", "0,22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_left_unswitched.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_left_unswitched.mdl", "#", "#", 2, "", "256,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_left_unswitched.mdl", "#", "#", 3, "", "262.471,49.622,3.016", "0,22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_right_switched.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_right_switched.mdl", "#", "#", 2, "", "256,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_right_switched.mdl", "#", "#", 3, "", "262.472,-49.622,3.016", "0,-22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_right_unswitched.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_right_unswitched.mdl", "#", "#", 2, "", "256,0,3.016"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/switches/switch_right_unswitched.mdl", "#", "#", 3, "", "262.472,-49.622,3.016", "0,-22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_225_right_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_225_right_512.mdl", "#", "#", 2, "", "124.736,-24.811,3.016", "0,-22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_225_left_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_225_left_512.mdl", "#", "#", 2, "", "124.735,24.812,3.016", "0,22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_225_right_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_225_right_1024.mdl", "#", "#", 2, "", "249.471,-49.623,3.016", "0,-22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_225_left_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_225_left_1024.mdl", "#", "#", 2, "", "249.471,49.621,3.016", "0,22.5,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_45_left_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_45_left_512.mdl", "#", "#", 2, "", "230.481,95.468,3.016", "0,45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_45_right_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_45_right_512.mdl", "#", "#", 2, "", "230.481,-95.469,3.016", "0,-45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_45_right_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,-180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_45_right_1024.mdl", "#", "#", 2, "", "460.963,-190.936,3.016", "0,-45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_45_left_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_45_left_1024.mdl", "#", "#", 2, "", "460.962,190.936,3.016", "0,45,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_90_right_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_90_right_512.mdl", "#", "#", 2, "", "325.949,-325.949,3.016", "0,-90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_90_left_512.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_90_left_512.mdl", "#", "#", 2, "", "325.949,325.95,3.016", "0,90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_90_right_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_90_right_1024.mdl", "#", "#", 2, "", "651.898,-651.899,3.016", "0,-90,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_90_left_1024.mdl", "#", "#", 1, "", "0,0,3.016", "0,180,0"})
  PIECES:Record({"models/bobsters_trains/rails/2ft/curves/curve_rack_90_left_1024.mdl", "#", "#", 2, "", "651.898,651.898,3.016", "0,90,0"})
  asmlib.Categorize("PHX Tubes Miscellaneous",[[function(m)
      local g = m:gsub("models/props_phx/construct/",""):gsub("/","_")
      local r = g:match(".-_"):sub(1, -2); g = g:gsub(r.."_", "")
      local t, n = g:match(".-_"), g:gsub("%.mdl","")
      if(t) then t = t:sub(1, -2); g = g:gsub(r.."_", "")
        if(r:find(t)) then n = n:gsub(t.."_", "") end
      end; return r, n; end]])
  --- Tubes Metal ---
  PIECES:Record({"models/props_phx/construct/metal_angle90.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_angle90.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/metal_angle180.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_angle180.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/metal_angle360.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_angle360.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/metal_dome90.mdl", "#", "#", 1, "", "0,0,0.025", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_dome180.mdl", "#", "#", 1, "", "0,0,0.025","90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_dome360.mdl", "#", "#", 1, "", "0,0,0.025","90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve.mdl", "#", "#", 1, "", "31.246,33.667,47.541", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve.mdl", "#", "#", 2, "", "31.222,33.69,0.095", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve2x2.mdl", "#", "#", 1, "", "31.246,33.667,95.083", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve2x2.mdl", "#", "#", 2, "", "31.241,33.671,0.183", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve180.mdl", "#", "#", 1, "", "0.02,0,47.538", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve180.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve180x2.mdl", "#", "#", 1, "", "0.02,0,95.081", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve180x2.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve360.mdl", "#", "#", 1, "", "0.02,0,47.538", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve360.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve360x2.mdl", "#", "#", 1, "", "0.02,0,95.076", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_plate_curve360x2.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  --- Tubes Glass ---
  PIECES:Record({"models/props_phx/construct/glass/glass_angle90.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_angle90.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_angle180.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_angle180.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_angle360.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_angle360.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_dome90.mdl", "#", "#", 1, "", "0,0,0.025", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_dome180.mdl", "#", "#", 1, "", "0,0,0.025","90,-180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_dome360.mdl", "#", "#", 1, "", "0,0,0.025","90,-180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve90x1.mdl", "#", "#", 1, "", "31.246,33.667,47.541", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve90x1.mdl", "#", "#", 2, "", "31.222,33.69,0.095", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve90x2.mdl", "#", "#", 1, "", "31.246,33.667,95.083", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve90x2.mdl", "#", "#", 2, "", "31.241,33.671,0.183", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve180x1.mdl", "#", "#", 1, "", "31.222,33.667,47.543", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve180x1.mdl", "#", "#", 2, "", "31.222,33.667,0.093", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve180x2.mdl", "#", "#", 1, "", "31.222,33.668,94.993", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve180x2.mdl", "#", "#", 2, "", "31.222,33.667,0.093", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve360x1.mdl", "#", "#", 1, "", "0.02,0,47.538", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve360x1.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve360x2.mdl", "#", "#", 1, "", "0.02,0,95.076", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/glass/glass_curve360x2.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  --- Tubes Wireframe ---
  PIECES:Record({"models/props_phx/construct/metal_wire_angle90x1.mdl", "#", "#", 1, "", "31.246,33.667,47.541", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle90x1.mdl", "#", "#", 2, "", "31.222,33.69,0.095", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle90x2.mdl", "#", "#", 1, "", "31.246,33.667,95.083", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle90x2.mdl", "#", "#", 2, "", "31.241,33.671,0.183", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle180x1.mdl", "#", "#", 1, "", "31.222,33.667,47.543", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle180x1.mdl", "#", "#", 2, "", "31.222,33.667,0.093", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle180x2.mdl", "#", "#", 1, "", "31.222,33.668,94.993", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle180x2.mdl", "#", "#", 2, "", "31.222,33.667,0.093", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle360x1.mdl", "#", "#", 1, "", "0.02,0,47.538", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle360x1.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle360x2.mdl", "#", "#", 1, "", "0.02,0,95.076", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/metal_wire_angle360x2.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  --- Tubes Wireframe Glass ---
  PIECES:Record({"models/props_phx/construct/windows/window_angle90.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_angle90.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_angle180.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_angle180.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_angle360.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_angle360.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_dome90.mdl", "#", "#", 1, "", "0,0,0.025", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_dome180.mdl", "#", "#", 1, "", "0,0,0.025","90,-180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_dome360.mdl", "#", "#", 1, "", "0,0,0.025","90,-180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve90x1.mdl", "#", "#", 1, "", "31.246,33.667,47.541", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve90x1.mdl", "#", "#", 2, "", "31.222,33.69,0.095", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve90x2.mdl", "#", "#", 1, "", "31.246,33.667,95.083", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve90x2.mdl", "#", "#", 2, "", "31.241,33.671,0.183", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve180x1.mdl", "#", "#", 1, "", "31.222,33.667,47.543", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve180x1.mdl", "#", "#", 2, "", "31.222,33.667,0.093", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve180x2.mdl", "#", "#", 1, "", "31.222,33.668,94.993", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve180x2.mdl", "#", "#", 2, "", "31.222,33.667,0.093", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve360x1.mdl", "#", "#", 1, "", "0.02,0,47.538", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve360x1.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve360x2.mdl", "#", "#", 1, "", "0.02,0,95.076", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/windows/window_curve360x2.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  --- Tubes Wood ---
  PIECES:Record({"models/props_phx/construct/wood/wood_angle90.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_angle90.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_angle180.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_angle180.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_angle360.mdl", "#", "#", 1, "", "-0.001,0,3.258", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_angle360.mdl", "#", "#", 2, "", "-0.001,0,0.255", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_dome90.mdl", "#", "#", 1, "", "0,0,0.025", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_dome180.mdl", "#", "#", 1, "", "0,0,0.025","90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_dome360.mdl", "#", "#", 1, "", "0,0,0.025","90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve90x1.mdl", "#", "#", 1, "", "0.02,0,47.541", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve90x1.mdl", "#", "#", 2, "", "0.02,0, 0.095", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve90x2.mdl", "#", "#", 1, "", "0.02,0,95.083", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve90x2.mdl", "#", "#", 2, "", "0.02,0, 0.183", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve180x1.mdl", "#", "#", 1, "", "0.02,0,47.538", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve180x1.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve180x2.mdl", "#", "#", 1, "", "0.02,0,95.081", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve180x2.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve360x1.mdl", "#", "#", 1, "", "0.02,0,47.538", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve360x1.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve360x2.mdl", "#", "#", 1, "", "0.02,0,95.076", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_curve360x2.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  --- Tubes Wireframe Wood ---
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle90x1.mdl", "#", "#", 1, "", "31.246,33.667,47.541", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle90x1.mdl", "#", "#", 2, "", "31.222,33.69,0.095", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle90x2.mdl", "#", "#", 1, "", "31.246,33.667,95.083", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle90x2.mdl", "#", "#", 2, "", "31.241,33.671,0.183", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle180x1.mdl", "#", "#", 1, "", "31.222,33.667,47.543", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle180x1.mdl", "#", "#", 2, "", "31.222,33.667,0.093", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle180x2.mdl", "#", "#", 1, "", "31.222,33.668,94.993", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle180x2.mdl", "#", "#", 2, "", "31.222,33.667,0.093", "90,-180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle360x1.mdl", "#", "#", 1, "", "0.02,0,47.538", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle360x1.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle360x2.mdl", "#", "#", 1, "", "0.02,0,95.076", "-90,0,180"})
  PIECES:Record({"models/props_phx/construct/wood/wood_wire_angle360x2.mdl", "#", "#", 2, "", "0.02,0,0.089", "90,180,180"})
  asmlib.Categorize("PHX Tubes Plastic",[[function(m)
    local g = m:gsub("models/hunter/",""):gsub("/","_")
    local r = g:match(".-_"):sub(1, -2); return r end]])
  PIECES:Record({"models/hunter/misc/platehole1x1a.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/misc/platehole1x1a.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/misc/platehole1x1b.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/misc/platehole1x1b.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/misc/platehole1x1c.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/misc/platehole1x1c.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/misc/platehole1x1d.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/misc/platehole1x1d.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x1.mdl" , "#", "#", 1, "", "0,0,47.450", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x1.mdl" , "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x1b.mdl", "#", "#", 1, "", "0,0,47.450", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x1b.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x1c.mdl", "#", "#", 1, "", "0,0,47.450", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x1c.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x1d.mdl", "#", "#", 1, "", "0,0,47.450", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x1d.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x2.mdl" , "#", "#", 1, "", "0,0,94.900", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x2.mdl" , "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x2b.mdl", "#", "#", 1, "", "0,0,94.900", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x2b.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x2c.mdl", "#", "#", 1, "", "0,0,94.900", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x2c.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x2d.mdl", "#", "#", 1, "", "0,0,94.900", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x2d.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x3.mdl" , "#", "#", 1, "", "0,0,142.35", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x3.mdl" , "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x3b.mdl", "#", "#", 1, "", "0,0,142.35", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x3b.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x3c.mdl", "#", "#", 1, "", "0,0,142.35", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x3c.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x3d.mdl", "#", "#", 1, "", "0,0,142.35", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x3d.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x4.mdl" , "#", "#", 1, "", "0,0,189.80", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x4.mdl" , "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x4b.mdl", "#", "#", 1, "", "0,0,189.80", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x4b.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x4c.mdl", "#", "#", 1, "", "0,0,189.80", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x4c.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x4d.mdl", "#", "#", 1, "", "0,0,189.80", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x4d.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x5.mdl" , "#", "#", 1, "", "0,0,237.25", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x5.mdl" , "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x5b.mdl", "#", "#", 1, "", "0,0,237.25", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x5b.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x5c.mdl", "#", "#", 1, "", "0,0,237.25", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x5c.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x5d.mdl", "#", "#", 1, "", "0,0,237.25", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x5d.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x6.mdl" , "#", "#", 1, "", "0,0,284.70", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x6.mdl" , "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x6b.mdl", "#", "#", 1, "", "0,0,284.70", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x6b.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x6c.mdl", "#", "#", 1, "", "0,0,284.70", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x6c.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x6d.mdl", "#", "#", 1, "", "0,0,284.70", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x6d.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x8.mdl", "#", "#", 1, "", "0,0,379.60", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x8.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x8b.mdl", "#", "#", 1, "", "0,0,379.60", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x8b.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x8c.mdl", "#", "#", 1, "", "0,0,379.60", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x8c.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube1x1x8d.mdl", "#", "#", 1, "", "0,0,379.60", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube1x1x8d.mdl", "#", "#", 2, "", ""          , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tubebend1x1x90.mdl", "#", "#", 1, "", "", "90,-180,180"})
  PIECES:Record({"models/hunter/tubes/tubebend1x1x90.mdl", "#", "#", 2, "", "0,23.725,23.725", "0,90,90"})
  PIECES:Record({"models/hunter/tubes/circle2x2.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/tubes/circle2x2.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/tubes/circle2x2b.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/tubes/circle2x2b.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/tubes/circle2x2c.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/tubes/circle2x2c.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/tubes/circle2x2d.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/tubes/circle2x2d.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/plates/platehole1x1.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/plates/platehole1x1.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/plates/platehole1x2.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/plates/platehole1x2.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/plates/platehole2x2.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/plates/platehole2x2.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/plates/platehole3.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/plates/platehole3.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/misc/shell2x2a.mdl", "#", "#", 1, "", "", "90,180,180"})
  PIECES:Record({"models/hunter/misc/shell2x2b.mdl", "#", "#", 1, "", "", "90,180,180"})
  PIECES:Record({"models/hunter/misc/shell2x2c.mdl", "#", "#", 1, "", "", "90,180,180"})
  PIECES:Record({"models/hunter/misc/shell2x2d.mdl", "#", "#", 1, "", "", "90,180,180"})
  PIECES:Record({"models/hunter/misc/shell2x2e.mdl", "#", "#", 1, "", "", "90,180,180"})
  PIECES:Record({"models/hunter/misc/shell2x2x45.mdl", "#", "#", 1, "0, -47.45, 0"})
  PIECES:Record({"models/hunter/misc/shell2x2x45.mdl", "#", "#", 2, "-33.552, -33.552, 0", "", "0,135,0"})
  PIECES:Record({"models/hunter/tubes/tube2x2x025.mdl" , "#", "#", 1, "", "0,0, 5.93125", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x025.mdl" , "#", "#", 2, "", "0,0,-5.93125", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x025b.mdl", "#", "#", 1, "", "0,0, 5.93125", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x025b.mdl", "#", "#", 2, "", "0,0,-5.93125", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x025c.mdl", "#", "#", 1, "", "0,0, 5.93125", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x025c.mdl", "#", "#", 2, "", "0,0,-5.93125", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x025d.mdl", "#", "#", 1, "", "0,0, 5.93125", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x025d.mdl", "#", "#", 2, "", "0,0,-5.93125", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x05.mdl"  , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x05.mdl"  , "#", "#", 2, "", "0,0,-11.8625", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x05b.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x05b.mdl" , "#", "#", 2, "", "0,0,-11.8625", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x05c.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x05c.mdl" , "#", "#", 2, "", "0,0,-11.8625", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x05d.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x05d.mdl" , "#", "#", 2, "", "0,0,-11.8625", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x1.mdl" , "#", "#", 1, "", "0,0, 23.726"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x1.mdl" , "#", "#", 2, "", "0,0,-23.726"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x1b.mdl", "#", "#", 1, "", "0,0, 23.726"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x1b.mdl", "#", "#", 2, "", "0,0,-23.726"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x1c.mdl", "#", "#", 1, "", "0,0, 23.726"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x1c.mdl", "#", "#", 2, "", "0,0,-23.726"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x1d.mdl", "#", "#", 1, "", "0,0, 23.726"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x1d.mdl", "#", "#", 2, "", "0,0,-23.726"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x2.mdl" , "#", "#", 1, "", "0,0, 47.45"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x2.mdl" , "#", "#", 2, "", "0,0,-47.45"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x2b.mdl", "#", "#", 1, "", "0,0, 47.45"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x2b.mdl", "#", "#", 2, "", "0,0,-47.45"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x2c.mdl", "#", "#", 1, "", "0,0, 47.45"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x2c.mdl", "#", "#", 2, "", "0,0,-47.45"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x2d.mdl", "#", "#", 1, "", "0,0, 47.45"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x2d.mdl", "#", "#", 2, "", "0,0,-47.45"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x4.mdl" , "#", "#", 1, "", "0,0, 94.9"     , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x4.mdl" , "#", "#", 2, "", "0,0,-94.9"     , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x4b.mdl", "#", "#", 1, "", "0,0, 94.9"     , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x4b.mdl", "#", "#", 2, "", "0,0,-94.9"     , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x4c.mdl", "#", "#", 1, "", "0,0, 94.9"     , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x4c.mdl", "#", "#", 2, "", "0,0,-94.9"     , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x4d.mdl", "#", "#", 1, "", "0,0, 94.9"     , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x4d.mdl", "#", "#", 2, "", "0,0,-94.9"     , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x8.mdl" , "#", "#", 1, "", "0,0, 189.8"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x8.mdl" , "#", "#", 2, "", "0,0,-189.8"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x8b.mdl", "#", "#", 1, "", "0,0, 189.8"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x8b.mdl", "#", "#", 2, "", "0,0,-189.8"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x8c.mdl", "#", "#", 1, "", "0,0, 189.8"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x8c.mdl", "#", "#", 2, "", "0,0,-189.8"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x8d.mdl", "#", "#", 1, "", "0,0, 189.8"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x8d.mdl", "#", "#", 2, "", "0,0,-189.8"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube2x2x16d.mdl", "#", "#", 1, "", "0,0,711.75"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x16d.mdl", "#", "#", 2, "", "0,0,-47.45"   , " 90,-180,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x+.mdl", "#", "#", 1, "", "0,0,47.45"      , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2x+.mdl", "#", "#", 2, "", "0,-47.45,0"     , "0,-90,-90"})
  PIECES:Record({"models/hunter/tubes/tube2x2x+.mdl", "#", "#", 3, "", "0,0,-47.45"     , " 90,0,0"})
  PIECES:Record({"models/hunter/tubes/tube2x2x+.mdl", "#", "#", 4, "", "0,47.45,0"      , "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tube2x2xt.mdl", "#", "#", 1, "", "0,0,-47.45"     , " 90,0,0"})
  PIECES:Record({"models/hunter/tubes/tube2x2xt.mdl", "#", "#", 2, "", "0,-47.45,0"     , "0,-90,-90"})
  PIECES:Record({"models/hunter/tubes/tube2x2xt.mdl", "#", "#", 3, "", "0,47.45,0"      , "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tube2x2xta.mdl", "#", "#", 1, "", "0,0,-23.725", "90,180,180"})
  PIECES:Record({"models/hunter/tubes/tube2x2xta.mdl", "#", "#", 2, "", "0,47.45,23.725", "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tube2x2xta.mdl", "#", "#", 3, "", "0,-47.45,23.725", "0,-90,-90"})
  PIECES:Record({"models/hunter/tubes/tube2x2xtb.mdl", "#", "#", 1, "", "0,-23.725,0", "0,-90,-90"})
  PIECES:Record({"models/hunter/tubes/tube2x2xtb.mdl", "#", "#", 2, "", "0,23.725,-47.45", "90,180,180"})
  PIECES:Record({"models/hunter/tubes/tubebend2x2x90.mdl", "#", "#", 1, "", "", "90,180,180"})
  PIECES:Record({"models/hunter/tubes/tubebend2x2x90.mdl", "#", "#", 2, "", "0,47.45,47.45", "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tubebend1x2x90.mdl", "#", "#", 1, "", "", "90,180,180"})
  PIECES:Record({"models/hunter/tubes/tubebend1x2x90.mdl", "#", "#", 2, "", "0,47.45,47.45", "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tubebend1x2x90a.mdl", "#", "#", 1, "", "", "90,180,180"})
  PIECES:Record({"models/hunter/tubes/tubebend1x2x90a.mdl", "#", "#", 2, "", "0,47.45,47.45", "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tubebend2x2x90outer.mdl", "#", "#", 1, "", "", "90,180,180"})
  PIECES:Record({"models/hunter/tubes/tubebend2x2x90outer.mdl", "#", "#", 2, "", "0,47.45,47.45", "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tubebend2x2x90square.mdl", "#", "#", 1, "", "0,0,-47.451", "90,-180,180"})
  PIECES:Record({"models/hunter/tubes/tubebend2x2x90square.mdl", "#", "#", 2, "", "0,47.417,0", "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tubebend1x2x90b.mdl", "#", "#", 1, "", "-47.45,0,47.45", "0,-180,90"})
  PIECES:Record({"models/hunter/tubes/tubebend1x2x90b.mdl", "#", "#", 2, "", "", "90,-90,180"})
  PIECES:Record({"models/hunter/tubes/tubebendinsidesquare.mdl", "#", "#", 1, "", "0,0,23.725", "-90,90,180"})
  PIECES:Record({"models/hunter/tubes/tubebendinsidesquare.mdl", "#", "#", 2, "", "-47.45,0,-23.724", "0,-180,90"})
  PIECES:Record({"models/hunter/tubes/tubebendinsidesquare2.mdl", "#", "#", 1, "", "0,0,23.725", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tubebendinsidesquare2.mdl", "#", "#", 2, "", "0,-47.45,-23.724", "0,-90,-90"})
  PIECES:Record({"models/hunter/tubes/tubebendoutsidesquare.mdl", "#", "#", 1, "0,0,47.45", "", "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tubebendoutsidesquare.mdl", "#", "#", 2, "0,-47.45,0", "", "90,180,180"})
  PIECES:Record({"models/hunter/tubes/tubebendoutsidesquare2.mdl", "#", "#", 1, "0,0,47.45", "", "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tubebendoutsidesquare2.mdl", "#", "#", 2, "0,-47.45,0", "", "90,180,180"})
  PIECES:Record({"models/hunter/tubes/circle4x4.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/tubes/circle4x4.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/tubes/circle4x4b.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/tubes/circle4x4b.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/tubes/circle4x4c.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/tubes/circle4x4c.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/tubes/circle4x4d.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/tubes/circle4x4d.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/misc/platehole4x4.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/misc/platehole4x4.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/misc/platehole4x4b.mdl", "#", "#", 1, "", "0,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/misc/platehole4x4b.mdl", "#", "#", 2, "", "0,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/misc/platehole4x4c.mdl", "#", "#", 1, "", "47.45,0, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/misc/platehole4x4c.mdl", "#", "#", 2, "", "47.45,0,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/misc/platehole4x4d.mdl", "#", "#", 1, "", "47.45,47.45, 1.5", "-90,  0,180"})
  PIECES:Record({"models/hunter/misc/platehole4x4d.mdl", "#", "#", 2, "", "47.45,47.45,-1.5", " 90,180,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x1to2x2.mdl", "#", "#", 1, "", "", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x1to2x2.mdl", "#", "#", 2, "", "0,0,-47.45"," 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x025.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x025.mdl" , "#", "#", 2, "", "0,0,0", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x025b.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x025b.mdl" , "#", "#", 2, "", "0,0,0", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x025c.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x025c.mdl" , "#", "#", 2, "", "0,0,0", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x025d.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x025d.mdl" , "#", "#", 2, "", "0,0,0", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x05.mdl"  , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x05.mdl"  , "#", "#", 2, "", "0,0,-11.8625", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x05b.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x05b.mdl" , "#", "#", 2, "", "0,0,-11.8625", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x05c.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x05c.mdl" , "#", "#", 2, "", "0,0,-11.8625", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x05d.mdl" , "#", "#", 1, "", "0,0, 11.8625", "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x05d.mdl" , "#", "#", 2, "", "0,0,-11.8625", " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x1.mdl" , "#", "#", 1, "", "0,0, 23.726"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x1.mdl" , "#", "#", 2, "", "0,0,-23.726"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x1b.mdl", "#", "#", 1, "", "0,0, 23.726"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x1b.mdl", "#", "#", 2, "", "0,0,-23.726"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x1c.mdl", "#", "#", 1, "", "0,0, 23.726"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x1c.mdl", "#", "#", 2, "", "0,0,-23.726"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x1d.mdl", "#", "#", 1, "", "0,0, 23.726"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x1d.mdl", "#", "#", 2, "", "0,0,-23.726"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x2.mdl" , "#", "#", 1, "", "0,0, 47.45"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x2.mdl" , "#", "#", 2, "", "0,0,-47.45"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x2b.mdl", "#", "#", 1, "", "0,0, 47.45"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x2b.mdl", "#", "#", 2, "", "0,0,-47.45"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x2c.mdl", "#", "#", 1, "", "0,0, 47.45"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x2c.mdl", "#", "#", 2, "", "0,0,-47.45"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x2d.mdl", "#", "#", 1, "", "0,0, 47.45"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x2d.mdl", "#", "#", 2, "", "0,0,-47.45"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x3.mdl" , "#", "#", 1, "", "0,0, 71.175"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x3.mdl" , "#", "#", 2, "", "0,0,-71.175"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x3b.mdl", "#", "#", 1, "", "0,0, 71.175"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x3b.mdl", "#", "#", 2, "", "0,0,-71.175"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x3c.mdl", "#", "#", 1, "", "0,0, 71.175"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x3c.mdl", "#", "#", 2, "", "0,0,-71.175"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x3d.mdl", "#", "#", 1, "", "0,0, 71.175"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x3d.mdl", "#", "#", 2, "", "0,0,-71.175"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x4.mdl" , "#", "#", 1, "", "0,0, 94.9"     , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x4.mdl" , "#", "#", 2, "", "0,0,-94.9"     , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x4b.mdl", "#", "#", 1, "", "0,0, 94.9"     , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x4b.mdl", "#", "#", 2, "", "0,0,-94.9"     , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x4c.mdl", "#", "#", 1, "", "0,0, 94.9"     , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x4c.mdl", "#", "#", 2, "", "0,0,-94.9"     , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x4d.mdl", "#", "#", 1, "", "0,0, 94.9"     , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x4d.mdl", "#", "#", 2, "", "0,0,-94.9"     , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x5.mdl" , "#", "#", 1, "", "0,0, 118.625"  , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x5.mdl" , "#", "#", 2, "", "0,0,-118.625"  , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x5b.mdl", "#", "#", 1, "", "0,0, 118.625"  , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x5b.mdl", "#", "#", 2, "", "0,0,-118.625"  , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x5c.mdl", "#", "#", 1, "", "0,0, 118.625"  , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x5c.mdl", "#", "#", 2, "", "0,0,-118.625"  , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x5d.mdl", "#", "#", 1, "", "0,0, 118.625"  , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x5d.mdl", "#", "#", 2, "", "0,0,-118.625"  , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x6.mdl" , "#", "#", 1, "", "0,0, 142.35"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x6.mdl" , "#", "#", 2, "", "0,0,-142.35"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x6b.mdl", "#", "#", 1, "", "0,0, 142.35"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x6b.mdl", "#", "#", 2, "", "0,0,-142.35"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x6c.mdl", "#", "#", 1, "", "0,0, 142.35"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x6c.mdl", "#", "#", 2, "", "0,0,-142.35"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x6d.mdl", "#", "#", 1, "", "0,0, 142.35"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x6d.mdl", "#", "#", 2, "", "0,0,-142.35"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x8.mdl" , "#", "#", 1, "", "0,0, 189.8"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x8.mdl" , "#", "#", 2, "", "0,0,-189.8"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x8b.mdl", "#", "#", 1, "", "0,0, 189.8"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x8b.mdl", "#", "#", 2, "", "0,0,-189.8"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x8c.mdl", "#", "#", 1, "", "0,0, 189.8"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x8c.mdl", "#", "#", 2, "", "0,0,-189.8"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x8d.mdl", "#", "#", 1, "", "0,0, 189.8"    , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x8d.mdl", "#", "#", 2, "", "0,0,-189.8"    , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x16.mdl" , "#", "#", 1, "", "0,0, 379.6"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x16.mdl" , "#", "#", 2, "", "0,0,-379.6"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x16b.mdl", "#", "#", 1, "", "0,0, 379.6"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x16b.mdl", "#", "#", 2, "", "0,0,-379.6"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x16c.mdl", "#", "#", 1, "", "0,0, 379.6"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x16c.mdl", "#", "#", 2, "", "0,0,-379.6"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tube4x4x16d.mdl", "#", "#", 1, "", "0,0, 379.6"   , "-90,0,180"})
  PIECES:Record({"models/hunter/tubes/tube4x4x16d.mdl", "#", "#", 2, "", "0,0,-379.6"   , " 90,0, 0 "})
  PIECES:Record({"models/hunter/tubes/tubebend4x4x90.mdl", "#", "#", 1, "", "0, 94.9,0" , "0,90,90"})
  PIECES:Record({"models/hunter/tubes/tubebend4x4x90.mdl", "#", "#", 2, "", "0,0,-94.9" , "90,-180,180"})
  asmlib.Categorize("G Scale Track Pack",[[function(m)
      local g = m:gsub("models/gscale/","")
      local r = g:match(".-/"):sub(1, -2)
      if    (r == "j") then r = "j switcher"
      elseif(r == "s") then r = "s switcher"
      elseif(r == "c0512") then r = "curve 512"
      elseif(r == "ibeam") then r = "iron beam"
      elseif(r == "ramp313") then r = "ramp 313" end; return r; end]])
  PIECES:Record({"models/gscale/straight/s0008.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/straight/s0008.mdl", "#", "#", 2, "", "  -8,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/straight/s0016.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/straight/s0016.mdl", "#", "#", 2, "", " -16,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/straight/s0032.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/straight/s0032.mdl", "#", "#", 2, "", " -32,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/straight/s0064.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/straight/s0064.mdl", "#", "#", 2, "", " -64,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/straight/s0128.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/straight/s0128.mdl", "#", "#", 2, "", "-128,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/straight/s0256.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/straight/s0256.mdl", "#", "#", 2, "", "-256,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/straight/s0512.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/straight/s0512.mdl", "#", "#", 2, "", "-512,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/straight/s1024.mdl", "#", "#", 1, "", "    0,0,1.016"})
  PIECES:Record({"models/gscale/straight/s1024.mdl", "#", "#", 2, "", "-1024,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/transition/t0032_q_s_1.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/transition/t0032_q_s_1.mdl", "#", "#", 2, "", " -32,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/transition/t0032_q_s_2.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/transition/t0032_q_s_2.mdl", "#", "#", 2, "", " -32,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/transition/t0032_q_t.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/transition/t0032_q_t.mdl", "#", "#", 2, "", " -32,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/c0512/225l.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/c0512/225l.mdl", "#", "#", 2, "", "-196.060471,-39.081982,1.016", "0,-157.5,0"})
  PIECES:Record({"models/gscale/c0512/225r.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/c0512/225r.mdl", "#", "#", 2, "", "-196.060471, 39.081982,1.016", "0, 157.5,0"})
  PIECES:Record({"models/gscale/c0512/45l.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/c0512/45l.mdl", "#", "#", 2, "", "-362,-150,1.016", "0,-135,0"})
  PIECES:Record({"models/gscale/c0512/45r.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/c0512/45r.mdl", "#", "#", 2, "", "-362,150,1.016", "0,135,0"})
  PIECES:Record({"models/gscale/c0512/90l.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/c0512/90l.mdl", "#", "#", 2, "", "-512,-512,1.016", "0,-90,0"})
  PIECES:Record({"models/gscale/c0512/90r.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/c0512/90r.mdl", "#", "#", 2, "", "-512, 512,1.016", "0, 90,0"})
  PIECES:Record({"models/gscale/c0512/s225l.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/c0512/s225l.mdl", "#", "#", 2, "", "-392,-78.125595,1.016", "0,180,0"})
  PIECES:Record({"models/gscale/c0512/s225r.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/c0512/s225r.mdl", "#", "#", 2, "", "-392, 78.125595,1.016", "0,180,0"})
  PIECES:Record({"models/gscale/j/l225_s.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/j/l225_s.mdl", "#", "#", 2, "", "-256,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/j/l225_s.mdl", "#", "#", 3, "", "-196.060471,-39.081982,1.016", "0,-157.5,0"})
  PIECES:Record({"models/gscale/j/l225_t.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/j/l225_t.mdl", "#", "#", 2, "", "-256,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/j/l225_t.mdl", "#", "#", 3, "", "-196.060471,-39.081982,1.016", "0,-157.5,0"})
  PIECES:Record({"models/gscale/j/r225_s.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/j/r225_s.mdl", "#", "#", 2, "", "-256,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/j/r225_s.mdl", "#", "#", 3, "", "-196.060471, 39.081982,1.016", "0, 157.5,0"})
  PIECES:Record({"models/gscale/j/r225_t.mdl", "#", "#", 1, "", " 0,0,1.016"})
  PIECES:Record({"models/gscale/j/r225_t.mdl", "#", "#", 2, "", "-256,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/j/r225_t.mdl", "#", "#", 3, "", "-196.060471, 39.081982,1.016", "0, 157.5,0"})
  PIECES:Record({"models/gscale/s/l225_s.mdl", "#", "#", 1, "", "   0,  0,1.016"})
  PIECES:Record({"models/gscale/s/l225_s.mdl", "#", "#", 2, "", "-256,  0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/s/l225_s.mdl", "#", "#", 3, "", "-392,-78,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/s/l225_s.mdl", "#", "#", 4, "", "-136,-78,1.016"})
  PIECES:Record({"models/gscale/s/l225_t.mdl", "#", "#", 1, "", "   0,  0,1.016"})
  PIECES:Record({"models/gscale/s/l225_t.mdl", "#", "#", 2, "", "-256,  0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/s/l225_t.mdl", "#", "#", 3, "", "-392,-78,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/s/l225_t.mdl", "#", "#", 4, "", "-136,-78,1.016"})
  PIECES:Record({"models/gscale/s/r225_s.mdl", "#", "#", 1, "", "   0,  0,1.016"})
  PIECES:Record({"models/gscale/s/r225_s.mdl", "#", "#", 2, "", "-256,  0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/s/r225_s.mdl", "#", "#", 3, "", "-392, 78,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/s/r225_s.mdl", "#", "#", 4, "", "-136, 78,1.016"})
  PIECES:Record({"models/gscale/s/r225_t.mdl", "#", "#", 1, "", "   0,  0,1.016"})
  PIECES:Record({"models/gscale/s/r225_t.mdl", "#", "#", 2, "", "-256,  0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/s/r225_t.mdl", "#", "#", 3, "", "-392, 78,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/s/r225_t.mdl", "#", "#", 4, "", "-136, 78,1.016"})
  PIECES:Record({"models/gscale/ramp313/r0032.mdl", "#", "#", 1, "", "  32,0,2.016"})
  PIECES:Record({"models/gscale/ramp313/r0032.mdl", "#", "#", 2, "", "   0,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ramp313/r0064.mdl", "#", "#", 1, "", "  64,0,3.016"})
  PIECES:Record({"models/gscale/ramp313/r0064.mdl", "#", "#", 2, "", "   0,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ramp313/r0128.mdl", "#", "#", 1, "", " 128,0,5.016"})
  PIECES:Record({"models/gscale/ramp313/r0128.mdl", "#", "#", 2, "", "   0,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ramp313/r0256.mdl", "#", "#", 1, "", " 256,0,9.016"})
  PIECES:Record({"models/gscale/ramp313/r0256.mdl", "#", "#", 2, "", "   0,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ramp313/r0512.mdl", "#", "#", 1, "", " 512,0,17.016"})
  PIECES:Record({"models/gscale/ramp313/r0512.mdl", "#", "#", 2, "", "   0,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ramp313/r1024.mdl", "#", "#", 1, "", "1024,0,33.016"})
  PIECES:Record({"models/gscale/ramp313/r1024.mdl", "#", "#", 2, "", "   0,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ibeam/s0032.mdl", "#", "#", 1, "", "    0,0,25.016"})
  PIECES:Record({"models/gscale/ibeam/s0032.mdl", "#", "#", 2, "", "  -32,0,25.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ibeam/s0064.mdl", "#", "#", 1, "", "    0,0,25.016"})
  PIECES:Record({"models/gscale/ibeam/s0064.mdl", "#", "#", 2, "", "  -64,0,25.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ibeam/s0128.mdl", "#", "#", 1, "", "    0,0,25.016"})
  PIECES:Record({"models/gscale/ibeam/s0128.mdl", "#", "#", 2, "", " -128,0,25.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ibeam/s0256.mdl", "#", "#", 1, "", "    0,0,25.016"})
  PIECES:Record({"models/gscale/ibeam/s0256.mdl", "#", "#", 2, "", " -256,0,25.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ibeam/s0512.mdl", "#", "#", 1, "", "    0,0,25.016"})
  PIECES:Record({"models/gscale/ibeam/s0512.mdl", "#", "#", 2, "", " -512,0,25.016", "0,-180,0"})
  PIECES:Record({"models/gscale/ibeam/s1024.mdl", "#", "#", 1, "", "    0,0,25.016"})
  PIECES:Record({"models/gscale/ibeam/s1024.mdl", "#", "#", 2, "", "-1024,0,25.016", "0,-180,0"})
  PIECES:Record({"models/gscale/siding/l225_s.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/siding/l225_s.mdl", "#", "#", 2, "", "-256,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/siding/l225_s.mdl", "#", "#", 3, "", "-392,-78,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/siding/l225_t.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/siding/l225_t.mdl", "#", "#", 2, "", "-256,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/siding/l225_t.mdl", "#", "#", 3, "", "-392,-78,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/siding/r225_s.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/siding/r225_s.mdl", "#", "#", 2, "", "-256,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/siding/r225_s.mdl", "#", "#", 3, "", "-392,78,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/siding/r225_t.mdl", "#", "#", 1, "", "   0,0,1.016"})
  PIECES:Record({"models/gscale/siding/r225_t.mdl", "#", "#", 2, "", "-256,0,1.016", "0,-180,0"})
  PIECES:Record({"models/gscale/siding/r225_t.mdl", "#", "#", 3, "", "-392,78,1.016", "0,-180,0"})
  asmlib.Categorize("Ron's Minitrain Props",[[function(m)
    local g = m:gsub("models/ron/minitrains/","")
    local r = g:match(".-/"):sub(1, -2)
    if(r == "elevations") then
      local s = g:gsub(r.."/", ""):gsub("/.+$", "")
      local n = g:match("[\\/]([^/\\]+)$"):gsub("%.mdl","")
      local p = n:match(".-_")
      if(p) then p = p:sub(1, -2)
        if(r:find(p)) then n = n:gsub(p, ""):sub(2,-1) end
      end; return {r, s}, n; end; return r; end]])
  PIECES:Record({"models/ron/minitrains/straight/1.mdl",   "#", "#", 1, "", " 0, 8.507, 1"})
  PIECES:Record({"models/ron/minitrains/straight/1.mdl",   "#", "#", 2, "", "-1, 8.507, 1", "0,-180,0"})
  PIECES:Record({"models/ron/minitrains/straight/2.mdl",   "#", "#", 1, "", " 0, 8.507, 1"})
  PIECES:Record({"models/ron/minitrains/straight/2.mdl",   "#", "#", 2, "", "-2, 8.507, 1", "0,-180,0"})
  PIECES:Record({"models/ron/minitrains/straight/4.mdl",   "#", "#", 1, "", " 0, 8.507, 1"})
  PIECES:Record({"models/ron/minitrains/straight/4.mdl",   "#", "#", 2, "", "-4, 8.507, 1", "0,-180,0"})
  PIECES:Record({"models/ron/minitrains/straight/8.mdl",   "#", "#", 1, "", " 0, 8.507, 1"})
  PIECES:Record({"models/ron/minitrains/straight/8.mdl",   "#", "#", 2, "", "-8, 8.507, 1", "0,-180,0"})
  PIECES:Record({"models/ron/minitrains/scenery/tunnel_64.mdl",   "#", "#", 1, "", "  0, 8.507, 1"})
  PIECES:Record({"models/ron/minitrains/scenery/tunnel_64.mdl",   "#", "#", 2, "", "-64, 8.507, 1", "0,-180,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_1.mdl", "#", "#", 1, "", "0, 0.5,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_1.mdl", "#", "#", 2, "", "0,-0.5,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_2.mdl", "#", "#", 1, "", "0, 1,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_2.mdl", "#", "#", 2, "", "0,-1,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_4.mdl", "#", "#", 1, "", "0, 2,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_4.mdl", "#", "#", 2, "", "0,-2,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_8.mdl", "#", "#", 1, "", "0, 4,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_8.mdl", "#", "#", 2, "", "0,-4,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_16.mdl", "#", "#", 1, "", "0, 8,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_16.mdl", "#", "#", 2, "", "0,-8,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_32.mdl", "#", "#", 1, "", "0, 16,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_32.mdl", "#", "#", 2, "", "0,-16,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_64.mdl", "#", "#", 1, "", "0, 32,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_64.mdl", "#", "#", 2, "", "0,-32,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_128.mdl", "#", "#", 1, "", "0, 64,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_128.mdl", "#", "#", 2, "", "0,-64,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_256.mdl", "#", "#", 1, "", "0, 128,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_256.mdl", "#", "#", 2, "", "0,-128,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_512.mdl", "#", "#", 1, "", "0, 256,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_512.mdl", "#", "#", 2, "", "0,-256,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_1024.mdl", "#", "#", 1, "", "0, 512,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/elevation_1024.mdl", "#", "#", 2, "", "0,-512,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_1.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_1.mdl", "#", "#", 2, "", "138.5,138.5,33"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_2.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_2.mdl", "#", "#", 2, "", "168.5,168.5,33"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_3.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_3.mdl", "#", "#", 2, "", "198.5,198.5,33"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_4.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_4.mdl", "#", "#", 2, "", "228.5,228.5,33"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_5.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_5.mdl", "#", "#", 2, "", "258.5,258.5,33"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_6.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_90_6.mdl", "#", "#", 2, "", "288.5,288.5,33"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_1.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_1.mdl", "#", "#", 2, "", "40.565710805663,97.934289194337,33", "0,45,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_2.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_2.mdl", "#", "#", 2, "", "49.352507370067,119.14749262993,33", "0,45,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_3.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_3.mdl", "#", "#", 2, "", "58.13930393447,140.360696065530,33", "0,45,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_4.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_4.mdl", "#", "#", 2, "", "66.926100498874,161.57389950113,33", "0,45,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_5.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_5.mdl", "#", "#", 2, "", "75.712897063277,182.78710293672,33", "0,45,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_6.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_45_6.mdl", "#", "#", 2, "", "84.499693627681,204.00030637232,33", "0,45,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_1.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_1.mdl", "#", "#", 2, "", "10.542684747187,53.001655382565,33", "0,67.5,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_2.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_2.mdl", "#", "#", 2, "", "12.826298771848,64.482158353518,33", "0,67.5,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_3.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_3.mdl", "#", "#", 2, "", "15.109912796510,75.962661324470,33", "0,67.5,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_4.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_4.mdl", "#", "#", 2, "", "17.393526821171,87.443164295423,33", "0,67.5,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_5.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_5.mdl", "#", "#", 2, "", "19.677140845832,98.923667266376,33", "0,67.5,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_6.mdl", "#", "#", 1, "", "0,0,33", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/curves/elevation_225_6.mdl", "#", "#", 2, "", "21.960754870494,110.40417023733,33", "0,67.5,0"})
  PIECES:Record({"models/ron/minitrains/elevations/ramps/elevation_ramp_128.mdl", "#", "#", 1, "", "0,  0, 1", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/ramps/elevation_ramp_128.mdl", "#", "#", 2, "", "0,144,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/ramps/elevation_ramp_256.mdl", "#", "#", 1, "", "0,  0, 1", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/ramps/elevation_ramp_256.mdl", "#", "#", 2, "", "0,272,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/ramps/elevation_ramp_512.mdl", "#", "#", 1, "", "0,  0, 1", "0,-90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/ramps/elevation_ramp_512.mdl", "#", "#", 2, "", "0,528,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/bridge.mdl", "#", "#", 1, "", "0, 64,33", "0, 90,0"})
  PIECES:Record({"models/ron/minitrains/elevations/straight/bridge.mdl", "#", "#", 2, "", "0,-64,33", "0,-90,0"})
  asmlib.Categorize("Transrapid",[[function(m)
      local g = m:gsub("models/ron/maglev/",""):gsub("/","_")
            g = g:gsub("[\\/]([^\\/]+)$",""):gsub("%.mdl","")
      local r = g:match(".-_"):sub(1, -2)
      if(r == "track") then g = g:gsub(r.."_", "")
        r = g:match(".-_"):sub(1, -2) else return nil end
      local t, n = g:match(".-_"), g:gsub(r.."_", "")
      if(t) then t = t:sub(1, -2); g = g:gsub(t.."_", "")
        if(r:find(t)) then n = n:gsub(t.."_", "") end
      end; return r, n; end]])
  PIECES:Record({"models/ron/maglev/support/support_a.mdl", "#", "#", 1, "", "0,0,3.984", "0,-180,0"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_128.mdl", "#", "#", 1, "", " 64,0,3.984"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_128.mdl", "#", "#", 2, "", "-64,0,3.984", "0,-180,0"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_256.mdl", "#", "#", 1, "", " 128,0,3.984"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_256.mdl", "#", "#", 2, "", "-128,0,3.984", "0,-180,0"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_512.mdl", "#", "#", 1, "", " 256,0,3.984"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_512.mdl", "#", "#", 2, "", "-256,0,3.984", "0,-180,0"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_1024.mdl", "#", "#", 1, "", " 512,0,3.984"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_1024.mdl", "#", "#", 2, "", "-512,0,3.984", "0,-180,0"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_1024_support.mdl", "#", "#", 1, "", " 512,0,3.984"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_1024_support.mdl", "#", "#", 2, "", "-512,0,3.984", "0,-180,0"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_2048.mdl", "#", "#", 1, "", " 1024,0,3.984"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_2048.mdl", "#", "#", 2, "", "-1024,0,3.984", "0,-180,0"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_2048_support.mdl", "#", "#", 1, "", " 1024,0,3.984"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_2048_support.mdl", "#", "#", 2, "", "-1024,0,3.984", "0,-180,0"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_4096.mdl", "#", "#", 1, "", " 2048,0,3.984"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_4096.mdl", "#", "#", 2, "", "-2048,0,3.984", "0,-180,0"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_4096_support.mdl", "#", "#", 1, "", " 2048,0,3.984"})
  PIECES:Record({"models/ron/maglev/track/straight/straight_4096_support.mdl", "#", "#", 2, "", "-2048,0,3.984", "0,-180,0"})
  asmlib.Categorize("Battleship's abandoned rails",[[function(m)
    local g = m:gsub("models/craptrax/","")
    local r = g:match(".+/"):sub(1, -2)
    local n = g:match("[\\/]([^\\/]+)$"):gsub("%.mdl","")
    if(r:find("straight")) then r = "straight"
    elseif(r:find("curve")) then r = "curve"
    elseif(r:find("switch")) then r = "switch" end
    local t = n:match(r.."_")
    if(t) then n = n:gsub(t,"") end; return r, n; end]])
  PIECES:Record({"models/craptrax/straight1x/straight_1x_nodamage.mdl", "#", "#", 1, "", " 64,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight1x/straight_1x_nodamage.mdl", "#", "#", 2, "", "-64,0,-16.110403", "0,-180,0"})
  PIECES:Record({"models/craptrax/straight1x/straight_1x_damaged.mdl" , "#", "#", 1, "", " 64,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight1x/straight_1x_damaged.mdl" , "#", "#", 2, "", "-64,0,-16.110403", "0,-180,0"})
  PIECES:Record({"models/craptrax/straight2x/straight_2x_nodamage.mdl", "#", "#", 1, "", " 128,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight2x/straight_2x_nodamage.mdl", "#", "#", 2, "", "-128,0,-16.110403", "0,-180,0"})
  PIECES:Record({"models/craptrax/straight2x/straight_2x_damaged.mdl" , "#", "#", 1, "", " 128,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight2x/straight_2x_damaged.mdl" , "#", "#", 2, "", "-128,0,-16.110403", "0,-180,0"})
  PIECES:Record({"models/craptrax/straight3x/straight_3x_nodamage.mdl", "#", "#", 1, "", " 192,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight3x/straight_3x_nodamage.mdl", "#", "#", 2, "", "-192,0,-16.110403", "0,180,0"})
  PIECES:Record({"models/craptrax/straight3x/straight_3x_damaged.mdl" , "#", "#", 1, "", " 192,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight3x/straight_3x_damaged.mdl" , "#", "#", 2, "", "-192,0,-16.110403", "0,180,0"})
  PIECES:Record({"models/craptrax/straight4x/straight_4x_nodamage.mdl", "#", "#", 1, "", " 256,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight4x/straight_4x_nodamage.mdl", "#", "#", 2, "", "-256,0,-16.110403", "0,-180,0"})
  PIECES:Record({"models/craptrax/straight4x/straight_4x_damaged.mdl" , "#", "#", 1, "", " 256,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight4x/straight_4x_damaged.mdl" , "#", "#", 2, "", "-256,0,-16.110403", "0,-180,0"})
  PIECES:Record({"models/craptrax/straight8x/straight_8x_nodamage.mdl", "#", "#", 1, "", " 512,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight8x/straight_8x_nodamage.mdl", "#", "#", 2, "", "-512,0,-16.110403", "0,180,0"})
  PIECES:Record({"models/craptrax/straight8x/straight_8x_damaged.mdl" , "#", "#", 1, "", " 512,0,-16.110403"})
  PIECES:Record({"models/craptrax/straight8x/straight_8x_damaged.mdl" , "#", "#", 2, "", "-512,0,-16.110403", "0,180,0"})
  PIECES:Record({"models/craptrax/curver1/curve_r1_nodamage.mdl"  , "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curver1/curve_r1_nodamage.mdl"  , "#", "#", 2, "", "-1060.13232,139.53517,-16.110403", "0,165,0"})
  PIECES:Record({"models/craptrax/curver1/curve_r1_damaged.mdl"   , "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curver1/curve_r1_damaged.mdl"   , "#", "#", 2, "", "-1060.13232,139.53517,-16.110403", "0,165,0"})
  PIECES:Record({"models/craptrax/curver11/curve_r11_nodamage.mdl", "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curver11/curve_r11_nodamage.mdl", "#", "#", 2, "", "-1086.07532,450.1528,-16.110403", "0,135,0"})
  PIECES:Record({"models/craptrax/curver11/curve_r11_damaged.mdl" , "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curver11/curve_r11_damaged.mdl" , "#", "#", 2, "", "-1086.07532,450.1528,-16.110403", "0,135,0"})
  PIECES:Record({"models/craptrax/curver2/curve_r2_nodamage.mdl"  , "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curver2/curve_r2_nodamage.mdl"  , "#", "#", 2, "", "-993.86975,130.8159,-16.110403", "0,165,0"})
  PIECES:Record({"models/craptrax/curver2/curve_r2_damaged.mdl"   , "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curver2/curve_r2_damaged.mdl"   , "#", "#", 2, "", "-993.86975,130.8159,-16.110403", "0,165,0"})
  PIECES:Record({"models/craptrax/curver3/curve_r3_nodamage.mdl"  , "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curver3/curve_r3_nodamage.mdl"  , "#", "#", 2, "", "-927.61951,122.07793,-16.110403", "0,165,0"})
  PIECES:Record({"models/craptrax/curver3/curve_r3_damaged.mdl"   , "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curver3/curve_r3_damaged.mdl"   , "#", "#", 2, "", "-927.61951,122.07793,-16.110403", "0,165,0"})
  PIECES:Record({"models/craptrax/curve_cs_std/curve_cs_std_nodamage.mdl", "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curve_cs_std/curve_cs_std_nodamage.mdl", "#", "#", 2, "", "-966.40771,127.97242,-16.110403", "0,165,0"})
  PIECES:Record({"models/craptrax/curve_cs_std/curve_cs_std_damaged.mdl" , "#", "#", 1, "", "0,0,-16.110403"})
  PIECES:Record({"models/craptrax/curve_cs_std/curve_cs_std_damaged.mdl" , "#", "#", 2, "", "-966.40771,127.97242,-16.110403", "0,165,0"})
  PIECES:Record({"models/craptrax/straight_cs_std/straight_cs_std_nodamage.mdl", "#", "#", 1, "", "454.40574,0.01251,-16.110403"})
  PIECES:Record({"models/craptrax/straight_cs_std/straight_cs_std_nodamage.mdl", "#", "#", 2, "", "-454.40574,0.01248,-16.110403", "0,180,0"})
  PIECES:Record({"models/craptrax/straight_cs_std/straight_cs_std_damaged.mdl" , "#", "#", 1, "", "454.40574,0.01251,-16.110403"})
  PIECES:Record({"models/craptrax/straight_cs_std/straight_cs_std_damaged.mdl" , "#", "#", 2, "", "-454.40574,0.01248,-16.110403", "0,180,0"})
  PIECES:Record({"models/craptrax/switch_left_std/switch_left_base_std.mdl", "#", "#", 1, "", " 512,0,-16.110403"})
  PIECES:Record({"models/craptrax/switch_left_std/switch_left_base_std.mdl", "#", "#", 2, "", "-512,0,-16.110403", "0,180,0"})
  PIECES:Record({"models/craptrax/switch_left_std/switch_left_base_std.mdl", "#", "#", 3, "", "-454.49805,-128.04355,-16.110403", "0,-165,0"})
  PIECES:Record({"models/craptrax/switch_right_std/switch_right_base_std.mdl", "#", "#", 1, "", " 512,0,-16.110403"})
  PIECES:Record({"models/craptrax/switch_right_std/switch_right_base_std.mdl", "#", "#", 2, "", "-512,0,-16.110403", "0,180,0"})
  PIECES:Record({"models/craptrax/switch_right_std/switch_right_base_std.mdl", "#", "#", 3, "", "-454.48437,128.0936,-16.110403", "0,165,0"})
  asmlib.Categorize("AlexCookie's 2ft track pack",[[function(m)
    local g = m:gsub("models/alexcookie/2ft/","")
    local r = g:match(".+/"):sub(1, -2)
    local n = g:match("[\\/]([^\\/]+)$"):gsub("%.mdl","")
    local t = n:match(r.."_"); if(t) then n = n:gsub(t,"") end; return r, n; end]])
  PIECES:Record({"models/alexcookie/2ft/misc/end1.mdl", "#", "#", 1, "", "0,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_32.mdl", "#", "#", 1, "", "32,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_32.mdl", "#", "#", 2, "", "0 ,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_64.mdl", "#", "#", 1, "", "64,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_64.mdl", "#", "#", 2, "", "0 ,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_128.mdl", "#", "#", 1, "", "128,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_128.mdl", "#", "#", 2, "", "0 ,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_256.mdl", "#", "#", 1, "", "256,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_256.mdl", "#", "#", 2, "", "0 ,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_512.mdl", "#", "#", 1, "", "512,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_512.mdl", "#", "#", 2, "", "0 ,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_1024.mdl", "#", "#", 1, "", "1024,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/straight/straight_1024.mdl", "#", "#", 2, "", "0 ,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/curve/curve_90_512.mdl", "#", "#", 1, "", "0,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/curve/curve_90_512.mdl", "#", "#", 2, "", "-480,-480,13.04688", "0,-90,0"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_left_0.mdl", "#", "#", 1, "", "0,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_left_0.mdl", "#", "#", 2, "", "-512,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_left_0.mdl", "#", "#", 3, "", "-480,-480,13.04688", "0,-90,0"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_left_1.mdl", "#", "#", 1, "", "0,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_left_1.mdl", "#", "#", 2, "", "-512,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_left_1.mdl", "#", "#", 3, "", "-480,-480,13.04688", "0,-90,0"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_right_0.mdl", "#", "#", 1, "", "0,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_right_0.mdl", "#", "#", 2, "", "-512,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_right_0.mdl", "#", "#", 3, "", "-480,480,13.04688", "0,90,0"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_right_1.mdl", "#", "#", 1, "", "0,0,13.04688"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_right_1.mdl", "#", "#", 2, "", "-512,0,13.04688", "0,-180,0"})
  PIECES:Record({"models/alexcookie/2ft/switch/switch_90_right_1.mdl", "#", "#", 3, "", "-480,480,13.04688", "0,90,0"})
  asmlib.Categorize("Joe's track pack",[[function(m)
    local g = m:gsub("models/joe/jtp/","")
    local r = g:match(".+/"):sub(1, -2)
    local n = g:match("[\\/]([^\\/]+)$"):gsub("%.mdl","")
    local t = r:find("/")
    if(t) then return {r:sub(1, t-1), r:sub(t+1, -1)}, n end; return r, n; end]])
  PIECES:Record({"models/joe/jtp/switch/1536/225_left_switch.mdl", "#", "#", 1, "", "0,0,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_left_switch.mdl", "#", "#", 2, "", "0,-512,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_left_switch.mdl", "#", "#", 3, "", "117,-588,6.56348", "0,-67.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_left_unswitched.mdl", "#", "#", 1, "", "0,0,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_left_unswitched.mdl", "#", "#", 2, "", "0,-512,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_left_unswitched.mdl", "#", "#", 3, "", "117,-588,6.56348", "0,-67.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_right_switch.mdl", "#", "#", 1, "", "0,0,6.56348"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_right_switch.mdl", "#", "#", 2, "", "-512,0,6.56348", "0,180,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_right_switch.mdl", "#", "#", 3, "", "-588,117,6.56348", "0,157.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_right_unswitched.mdl", "#", "#", 1, "", "0,0,6.56348"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_right_unswitched.mdl", "#", "#", 2, "", "-512,0,6.56348", "0,180,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_right_unswitched.mdl", "#", "#", 3, "", "-588,117,6.56348", "0,157.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_left_switched.mdl", "#", "#", 1, "", "117,588.00024,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_left_switched.mdl", "#", "#", 2, "", "195.92734,473.3591,6.56348", "0,67.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_left_switched.mdl", "#", "#", 3, "", "-0.10242,0.34741,6.56348", "0,-112.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_left_unswitched.mdl", "#", "#", 1, "", "117,588.00024,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_left_unswitched.mdl", "#", "#", 2, "", "195.92734,473.3591,6.56348", "0,67.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_left_unswitched.mdl", "#", "#", 3, "", "-0.10242,0.34741,6.56348", "0,-112.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_right_switched.mdl", "#", "#", 1, "", "-117,588,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_right_switched.mdl", "#", "#", 2, "", "-195.92795,473.35934,6.56348", "0,112.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_right_switched.mdl", "#", "#", 3, "", "0.09927,0.34661,6.56348", "0,-67.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_right_unswitched.mdl", "#", "#", 1, "", "-117,588,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_right_unswitched.mdl", "#", "#", 2, "", "-195.92795,473.35934,6.56348", "0,112.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/225_yard_right_unswitched.mdl", "#", "#", 3, "", "0.09927,0.34661,6.56348", "0,-67.5,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_left_switch.mdl", "#", "#", 1, "", "0,0,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_left_switch.mdl", "#", "#", 2, "", "0,-512,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_left_switch.mdl", "#", "#", 3, "", "450,-1086.01062,6.56348", "0,-45,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_left_unswitched.mdl", "#", "#", 1, "", "0,0,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_left_unswitched.mdl", "#", "#", 2, "", "0,-512,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_left_unswitched.mdl", "#", "#", 3, "", "450,-1086.01062,6.56348", "0,-45,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_right_switched.mdl", "#", "#", 1, "", "0,0,6.56248"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_right_switched.mdl", "#", "#", 2, "", "-512,0,6.5625", "0,180,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_right_switched.mdl", "#", "#", 3, "", "-1086.0105,450,6.60476", "0,135,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_right_unswitched.mdl", "#", "#", 1, "", "0,0,6.56248"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_right_unswitched.mdl", "#", "#", 2, "", "-512,0,6.5625", "0,180,0"})
  PIECES:Record({"models/joe/jtp/switch/1536/45_right_unswitched.mdl", "#", "#", 3, "", "-1086.0105,450,6.60476", "0,135,0"})
  PIECES:Record({"models/joe/jtp/straight/32.mdl"  , "#", "#", 1, "", "0, 16 ,6.56348", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/straight/32.mdl"  , "#", "#", 2, "", "0,-16 ,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/straight/64.mdl"  , "#", "#", 1, "", "0, 32 ,6.56348", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/straight/64.mdl"  , "#", "#", 2, "", "0,-32 ,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/straight/128.mdl" , "#", "#", 1, "", "0, 64 ,6.56348", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/straight/128.mdl" , "#", "#", 2, "", "0,-64 ,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/straight/256.mdl" , "#", "#", 1, "", "0, 128,6.56348", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/straight/256.mdl" , "#", "#", 2, "", "0,-128,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/straight/512.mdl" , "#", "#", 1, "", "0, 256,6.56348", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/straight/512.mdl" , "#", "#", 2, "", "0,-256,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/straight/1024.mdl", "#", "#", 1, "", "0, 512,6.56348", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/straight/1024.mdl", "#", "#", 2, "", "0,-512,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/straight/2048.mdl", "#", "#", 1, "", "0, 1024,6.56348", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/straight/2048.mdl", "#", "#", 2, "", "0,-1024,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/straight/3072.mdl", "#", "#", 1, "", "0, 1536,6.56348", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/straight/3072.mdl", "#", "#", 2, "", "0,-1536,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/straight/4096.mdl", "#", "#", 1, "", "0, 2048,6.56348", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/straight/4096.mdl", "#", "#", 2, "", "0,-2048,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/straight/custom_1.mdl", "#", "#", 1, "", "301,-7.00836,6.56348"})
  PIECES:Record({"models/joe/jtp/straight/custom_1.mdl", "#", "#", 2, "", "-301,7.00464,6.56348", "0,-180,0"})
  PIECES:Record({"models/joe/jtp/straight/siding_straight.mdl", "#", "#", 1, "", "0,332,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/straight/siding_straight.mdl", "#", "#", 2, "", "0,-331,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/turntable/turntable.mdl", "#", "#", 1, "", "0, 450,14.59378", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/turntable/turntable.mdl", "#", "#", 2, "", "0,-450,14.59378", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/turntable/turntable2.mdl", "#", "#", 1, "", "0, 450,14.59378", "0, 90,0"})
  PIECES:Record({"models/joe/jtp/turntable/turntable2.mdl", "#", "#", 2, "", "0,-450,14.59378", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/turntable/base_1.mdl", "#", "#", 1, "", " 450,0,2.59372"})
  PIECES:Record({"models/joe/jtp/turntable/base_1.mdl", "#", "#", 2, "", "-450,0,2.59372", "0,-180,0"})
  PIECES:Record({"models/joe/jtp/curve/1536.mdl", "#", "#", 1, "", "0,0,6.56348"})
  PIECES:Record({"models/joe/jtp/curve/1536.mdl", "#", "#", 2, "", "-1536,1536,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/curve/2304_90.mdl", "#", "#", 1, "", "0,0,6.5625"})
  PIECES:Record({"models/joe/jtp/curve/2304_90.mdl", "#", "#", 2, "", "-2005,2005,6.5625", "0,90,0"})
  PIECES:Record({"models/joe/jtp/curve/2048_90.mdl", "#", "#", 1, "", "0,0,6.5625", "0,90,0"})
  PIECES:Record({"models/joe/jtp/curve/2048_90.mdl", "#", "#", 2, "", "1769,-1769,6.5625"})
  PIECES:Record({"models/joe/jtp/curve/3072_90.mdl", "#", "#", 1, "", "0,0,6.5625", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/curve/3072_90.mdl", "#", "#", 2, "", "-3072,3072,6.5625", "0,180,0"})
  PIECES:Record({"models/joe/jtp/curve/4096_90.mdl", "#", "#", 1, "", "0,0,6.5625"})
  PIECES:Record({"models/joe/jtp/curve/4096_90.mdl", "#", "#", 2, "", "-4096,4096,6.5625", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/512_16.mdl", "#", "#", 1, "", "0,-256,-1.43457", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/grades/512_16.mdl", "#", "#", 2, "", "0, 256,14.56738", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/512_32.mdl", "#", "#", 1, "", "0,0,6.56152", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/grades/512_32.mdl", "#", "#", 2, "", "0,512,38.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/1024_16.mdl", "#", "#", 1, "", "0,0,6.5625", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/1024_16.mdl", "#", "#", 2, "", "0,-1024,22.5625", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/grades/1024_32.mdl", "#", "#", 1, "", "0,512,-9.43457", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/1024_32.mdl", "#", "#", 2, "", "0,-512,22.56836", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/throw/harpstand_2_pos.mdl", "#", "#", 1, "", "0, -86.5, 0"})
  PIECES:Record({"models/joe/jtp/trestle/trestle_1.mdl", "#", "#", 1, "", "0,0,249", "0,90,0"})
  PIECES:Record({"models/joe/jtp/trestle/trestle_2.mdl", "#", "#", 1, "", "0,0,249", "0,90,0"})
  PIECES:Record({"models/joe/jtp/trestle/trestle_3.mdl", "#", "#", 1, "", "0,0,249", "0,90,0"})
  PIECES:Record({"models/joe/jtp/trestle/trestle_4.mdl", "#", "#", 1, "", "0,0,249", "0,90,0"})
  PIECES:Record({"models/joe/jtp/misc/end_track_1.mdl", "#", "#", 1, "", "0, 32,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/misc/end_track_1.mdl", "#", "#", 2, "", "0,-32,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/misc/damaged_track_1.mdl", "#", "#", 1, "", "0,106,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/misc/damaged_track_1.mdl", "#", "#", 2, "", "0,-107,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/misc/diamond_90.mdl", "#", "#", 1, "", "105,0,6.56348"})
  PIECES:Record({"models/joe/jtp/misc/diamond_90.mdl", "#", "#", 2, "", "0,-105,6.56348", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/misc/diamond_90.mdl", "#", "#", 3, "", "-105,0,6.56348", "0,-180,0"})
  PIECES:Record({"models/joe/jtp/misc/diamond_90.mdl", "#", "#", 4, "", "0,105,6.56348", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/2048_32.mdl", "#", "#", 1, "", "0,0,6.56152", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/grades/2048_32.mdl", "#", "#", 2, "", "0,2048,38.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/2048_64.mdl", "#", "#", 1, "", "0,0,6.56152", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/grades/2048_64.mdl", "#", "#", 2, "", "0,2048,70.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/3072_48.mdl", "#", "#", 1, "", "0,0,6.56152", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/grades/3072_48.mdl", "#", "#", 2, "", "0,3072,54.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/3072_96.mdl", "#", "#", 1, "", "0,0,6.56152", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/grades/3072_96.mdl", "#", "#", 2, "", "0,3072,102.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/4096_64.mdl", "#", "#", 1, "", "0,0,6.56152", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/grades/4096_64.mdl", "#", "#", 2, "", "0,4096,70.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/4096_128.mdl", "#", "#", 1, "", "0,0,6.56152", "0,-90,0"})
  PIECES:Record({"models/joe/jtp/grades/4096_128.mdl", "#", "#", 2, "", "0,4096,134.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/curve/3072_48_left.mdl", "#", "#", 1, "", "0,0,6.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/curve/3072_48_left.mdl", "#", "#", 2, "", "3072,-3072,54.56152"})
  PIECES:Record({"models/joe/jtp/grades/curve/4096_48.mdl", "#", "#", 1, "", "0,0,6.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/curve/4096_48.mdl", "#", "#", 2, "", "-4096,-4096,54.56152", "0,-180,0"})
  PIECES:Record({"models/joe/jtp/grades/curve/4096_48_left.mdl", "#", "#", 1, "", "0,0,6.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/curve/4096_48_left.mdl", "#", "#", 2, "", "3072,-3072,54.56152"})
  PIECES:Record({"models/joe/jtp/grades/curve/4096_64_right.mdl", "#", "#", 1, "", "0,0,6.56152", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/curve/4096_64_right.mdl", "#", "#", 2, "", "-4096,-4096,70.56152", "0,-180,0"})
  PIECES:Record({"models/joe/jtp/grades/curve/4096_96_left.mdl", "#", "#", 1, "", "0,0,6.5625", "0,90,0"})
  PIECES:Record({"models/joe/jtp/grades/curve/4096_96_left.mdl", "#", "#", 2, "", "4096,-4096,102.5625"})
  asmlib.Categorize("StevenTechno's Buildings 2.0",[[function(m)
    local g = m:gsub("models/","")
    local r = g:match(".+/"):sub(1, -2)
    local n = g:match("[\\/]([^\\/]+)$"):gsub("%.mdl","")
    local t = r:find("/")
    if(t) then r, g = r:sub(1, t-1), r:sub(t+1, -1)
      if(r:find("road")) then r = "roads"
      elseif(r:find("building")) then r = "buildings" end
      return {r, g}, n end; return r, n; end]])
  asmlib.ModelToNameRule("SET",nil,{"^[%d-_]*",""},nil)
  PIECES:Record({"models/roads_pack/single_lane/0-0_single_lane_x1.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_lane/0-0_single_lane_x1.mdl", "#", "#", 2, "", "-72,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/single_lane/0-1_single_lane_x2.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_lane/0-1_single_lane_x2.mdl", "#", "#", 2, "", "-144,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/single_lane/0-2_single_lane_x4.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_lane/0-2_single_lane_x4.mdl", "#", "#", 2, "", "-288,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/single_lane/0-3_single_lane_x8.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_lane/0-3_single_lane_x8.mdl", "#", "#", 2, "", "-576,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/single_lane/0-4_single_lane_x16.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_lane/0-4_single_lane_x16.mdl", "#", "#", 2, "", "-1152,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/single_lane/0-5_single_lane_x32.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_lane/0-5_single_lane_x32.mdl", "#", "#", 2, "", "-2304,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/single_lane/0-6_single_lane_x64.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_lane/0-6_single_lane_x64.mdl", "#", "#", 2, "", "-4608,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/single_lane/0-7_single_lane_x128_phys.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_lane/0-7_single_lane_x128_phys.mdl", "#", "#", 2, "", "-9216,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-0_empty_lot_x8.mdl", "#", "#", 1, "", "-268, 288,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-0_empty_lot_x8.mdl", "#", "#", 2, "", "-268,-288,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-1_empty_lot_x16.mdl", "#", "#", 1, "", "-268, 576,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-1_empty_lot_x16.mdl", "#", "#", 2, "", "-268,-576,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-2_empty_lot_x32.mdl", "#", "#", 1, "", "-268, 1152,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-2_empty_lot_x32.mdl", "#", "#", 2, "", "-268,-1152,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-3_empty_lot_x64.mdl", "#", "#", 1, "", "-268, 2304,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-3_empty_lot_x64.mdl", "#", "#", 2, "", "-268,-2304,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-4_empty_lot_x128.mdl", "#", "#", 1, "", "-268, 4608,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-4_empty_lot_x128.mdl", "#", "#", 2, "", "-268,-4608,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-5_empty_lot_8x4.mdl", "#", "#", 1, "", "-268, 288,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-5_empty_lot_8x4.mdl", "#", "#", 2, "", "-268,-288,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-6_empty_lot_x16x8.mdl", "#", "#", 1, "", "-268, 576,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-6_empty_lot_x16x8.mdl", "#", "#", 2, "", "-268,-576,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-7_empty_lot_x32x16.mdl", "#", "#", 1, "", "-268, 1152,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-7_empty_lot_x32x16.mdl", "#", "#", 2, "", "-268,-1152,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-8_empty_lot_x64x32.mdl", "#", "#", 1, "", "-268, 2304,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-8_empty_lot_x64x32.mdl", "#", "#", 2, "", "-268,-2304,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-9_empty_lot_x128x64.mdl", "#", "#", 1, "", "-268, 4608,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/emptylots/0-9_empty_lot_x128x64.mdl", "#", "#", 2, "", "-268,-4608,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-0_apartments.mdl", "#", "#", 1, "", "-268, 616,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-0_apartments.mdl", "#", "#", 2, "", "-268,-608,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-0_apartments_nodoors.mdl", "#", "#", 1, "", "-268, 616,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-0_apartments_nodoors.mdl", "#", "#", 2, "", "-268,-608,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-1_apartments.mdl", "#", "#", 1, "", "-268, 1072,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-1_apartments.mdl", "#", "#", 2, "", "-268,-1016,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-1_apartments_nodoors.mdl", "#", "#", 1, "", "-268, 1072,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-1_apartments_nodoors.mdl", "#", "#", 2, "", "-268,-1016,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-2_apartments.mdl", "#", "#", 1, "", "-268, 576,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-2_apartments.mdl", "#", "#", 2, "", "-268,-576,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-2_apartments_nodoors.mdl", "#", "#", 1, "", "-268, 576,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-2_apartments_nodoors.mdl", "#", "#", 2, "", "-268,-576,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-3_apartments.mdl", "#", "#", 1, "", "-268, 900,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-3_apartments.mdl", "#", "#", 2, "", "-268,-900,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-3_apartments_nodoors.mdl", "#", "#", 1, "", "-268, 900,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/housing/1-3_apartments_nodoors.mdl", "#", "#", 2, "", "-268,-900,3.03125", "0,-90,0"})
  PIECES:Record({"models/roads_pack/single_turns/3-0_intersect_single_lane_a.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_turns/3-0_intersect_single_lane_a.mdl", "#", "#", 2, "", "-432, 432, 3.03125", "0,  90,0"})
  PIECES:Record({"models/roads_pack/single_turns/3-0_intersect_single_lane_a.mdl", "#", "#", 3, "", "-864,   0, 3.03125", "0, 180,0"})
  PIECES:Record({"models/roads_pack/single_turns/3-0_intersect_single_lane_a.mdl", "#", "#", 4, "", "-432,-432, 3.03125", "0, -90,0"})
  PIECES:Record({"models/roads_pack/single_turns/3-1_intersect_single_lane_b.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_turns/3-1_intersect_single_lane_b.mdl", "#", "#", 2, "", "-436, 432, 3.03125", "0,  90,0"})
  PIECES:Record({"models/roads_pack/single_turns/3-1_intersect_single_lane_b.mdl", "#", "#", 3, "", "-436,-432, 3.03125", "0, -90,0"})
  PIECES:Record({"models/roads_pack/single_turns/3-2_intersect_single_lane_c.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_turns/3-2_intersect_single_lane_c.mdl", "#", "#", 2, "", "-436, 432, 3.03125", "0,  90,0"})
  PIECES:Record({"models/roads_pack/single_turns/3-3_intersect_single_lane_d.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_turns/3-3_intersect_single_lane_d.mdl", "#", "#", 2, "", "-436,-432, 3.03125", "0, -90,0"})
  PIECES:Record({"models/roads_pack/single_turns/3-4_intersect_single_lane_e.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_turns/3-5_turn_single_lane_a.mdl", "#", "#", 1, "", "   0, -4,3.03125"})
  PIECES:Record({"models/roads_pack/single_turns/3-5_turn_single_lane_a.mdl", "#", "#", 2, "", "-428,424,3.03125", "0,90,0"})
  PIECES:Record({"models/roads_pack/single_turns/3-6_turn_single_lane_b.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/single_turns/3-6_turn_single_lane_b.mdl", "#", "#", 2, "", "-1508,1508,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/public/2-0_car_garage.mdl", "#", "#", 1, "", "-268, 936,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-0_car_garage.mdl", "#", "#", 2, "", "-268,-936,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-0_car_garage_nodoors.mdl", "#", "#", 1, "", "-268, 936,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-0_car_garage_nodoors.mdl", "#", "#", 2, "", "-268,-936,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-1_office_building.mdl", "#", "#", 1, "", "-268, 1224,4.0625", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-1_office_building.mdl", "#", "#", 2, "", "-268,-1224,4.0625", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-1_office_building_nodoors.mdl", "#", "#", 1, "", "-268, 1224,4.0625", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-1_office_building_nodoors.mdl", "#", "#", 2, "", "-268,-1224,4.0625", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-2_lgbt_club_a.mdl", "#", "#", 1, "", "-268, 936,4.0625", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-2_lgbt_club_a.mdl", "#", "#", 2, "", "-268,-936,4.0625", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-2_lgbt_club_a_nodoors.mdl", "#", "#", 1, "", "-268, 936,4.0625", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-2_lgbt_club_a_nodoors.mdl", "#", "#", 2, "", "-268,-936,4.0625", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-3_strip_club_a.mdl", "#", "#", 1, "", "-268, 1080,1.0625", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-3_strip_club_a.mdl", "#", "#", 2, "", "-268,-1080,1.0625", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-3_strip_club_a_nodoors.mdl", "#", "#", 1, "", "-268, 1080,1.0625", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-3_strip_club_a_nodoors.mdl", "#", "#", 2, "", "-268,-1080,1.0625", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-4_gas_stop.mdl", "#", "#", 1, "", "-268, 792,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-4_gas_stop.mdl", "#", "#", 2, "", "-268,-792,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-4_gas_stop_nodoors.mdl", "#", "#", 1, "", "-268, 792,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-4_gas_stop_nodoors.mdl", "#", "#", 2, "", "-268,-792,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-5_pc_shop.mdl", "#", "#", 1, "", "-268, 576,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-5_pc_shop.mdl", "#", "#", 2, "", "-268,-576,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-5_pc_shop_nodoors.mdl", "#", "#", 1, "", "-268, 576,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-5_pc_shop_nodoors.mdl", "#", "#", 2, "", "-268,-576,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-6_gun_shop.mdl", "#", "#", 1, "", "-268, 684,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-6_gun_shop.mdl", "#", "#", 2, "", "-268,-684,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-6_gun_shop_nodoors.mdl", "#", "#", 1, "", "-268, 684,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-6_gun_shop_nodoors.mdl", "#", "#", 2, "", "-268,-684,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-7_bank.mdl", "#", "#", 1, "", "-268, 792,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-7_bank.mdl", "#", "#", 2, "", "-268,-792,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-7_bank_nodoors.mdl", "#", "#", 1, "", "-268, 792,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-7_bank_nodoors.mdl", "#", "#", 2, "", "-268,-792,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-9_school_house.mdl", "#", "#", 1, "", "-268, 1328,1.0625", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-9_school_house.mdl", "#", "#", 2, "", "-268,-1336,1.0625", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/public/2-9_school_house_nodoors.mdl", "#", "#", 1, "", "-268, 1328,1.0625", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-9_school_house_nodoors.mdl", "#", "#", 2, "", "-268,-1336,1.0625", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-0_skyscraper_a.mdl", "#", "#", 1, "", "0,860,3.03125"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-0_skyscraper_a.mdl", "#", "#", 2, "", "-428,1288,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-0_skyscraper_a.mdl", "#", "#", 3, "", "-2148,1288,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-0_skyscraper_a.mdl", "#", "#", 4, "", "-2576,860,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-0_skyscraper_a.mdl", "#", "#", 5, "", "-2576,-860,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-0_skyscraper_a.mdl", "#", "#", 6, "", "-2148,-1288,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-0_skyscraper_a.mdl", "#", "#", 7, "", "-428,-1288,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-0_skyscraper_a.mdl", "#", "#", 8, "", "0,-860,3.03125"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-1_skyscraper_b.mdl", "#", "#", 1, "", "0,860,3.03125"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-1_skyscraper_b.mdl", "#", "#", 2, "", "-428,1288,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-1_skyscraper_b.mdl", "#", "#", 3, "", "-2148,1288,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-1_skyscraper_b.mdl", "#", "#", 4, "", "-2576,860,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-1_skyscraper_b.mdl", "#", "#", 5, "", "-2576,-860,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-1_skyscraper_b.mdl", "#", "#", 6, "", "-2148,-1288,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-1_skyscraper_b.mdl", "#", "#", 7, "", "-428,-1288,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-1_skyscraper_b.mdl", "#", "#", 8, "", "0,-860,3.03125"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-2_skyscraper_c.mdl", "#", "#", 1, "", "76,1584,3.03125"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-2_skyscraper_c.mdl", "#", "#", 2, "", "-356,2016,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-2_skyscraper_c.mdl", "#", "#", 3, "", "-2516,2016,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-2_skyscraper_c.mdl", "#", "#", 4, "", "-2948,1584,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-2_skyscraper_c.mdl", "#", "#", 5, "", "-2948,-1584,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-2_skyscraper_c.mdl", "#", "#", 6, "", "-2516,-2016,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-2_skyscraper_c.mdl", "#", "#", 7, "", "-356,-2016,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-2_skyscraper_c.mdl", "#", "#", 8, "", "76,-1584,3.03125"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-3_skyscraper_d.mdl", "#", "#", 1, "", "-1,1008,3.03125"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-3_skyscraper_d.mdl", "#", "#", 2, "", "-433,1440,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-3_skyscraper_d.mdl", "#", "#", 3, "", "-2449,1440,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-3_skyscraper_d.mdl", "#", "#", 4, "", "-2881,1008,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-3_skyscraper_d.mdl", "#", "#", 5, "", "-2881,-1008,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-3_skyscraper_d.mdl", "#", "#", 6, "", "-2449,-1440,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-3_skyscraper_d.mdl", "#", "#", 7, "", "-433,-1440,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-3_skyscraper_d.mdl", "#", "#", 8, "", "-1,-1008,3.03125"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-4_skyscraper_e.mdl", "#", "#", 1, "", "-1,1008,3.03125"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-4_skyscraper_e.mdl", "#", "#", 2, "", "-433,1440,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-4_skyscraper_e.mdl", "#", "#", 3, "", "-2449,1440,3.03125", "0,90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-4_skyscraper_e.mdl", "#", "#", 4, "", "-2881,1008,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-4_skyscraper_e.mdl", "#", "#", 5, "", "-2881,-1008,3.03125", "0,180,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-4_skyscraper_e.mdl", "#", "#", 6, "", "-2449,-1440,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-4_skyscraper_e.mdl", "#", "#", 7, "", "-433,-1440,3.03125", "0,-90,0"})
  PIECES:Record({"models/buildingspack2/skyscraper/3-4_skyscraper_e.mdl", "#", "#", 8, "", "-1,-1008,3.03125"})
  PIECES:Record({"models/buildingspack2/public/2-8_parking_garage.mdl", "#", "#", 1, "", "-268, 784,3.03125", "0, 90,0"})
  PIECES:Record({"models/buildingspack2/public/2-8_parking_garage.mdl", "#", "#", 2, "", "-268,-800,3.03125", "0,-90,0"})
  PIECES:Record({"models/roads_pack/connectors/2-0_single_to_double_connector.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/connectors/2-0_single_to_double_connector.mdl", "#", "#", 2, "", "-576,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/double_lane/1-0_double_lane_x1.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_lane/1-0_double_lane_x1.mdl", "#", "#", 2, "", "-72,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/double_lane/1-1_double_lane_x2.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_lane/1-1_double_lane_x2.mdl", "#", "#", 2, "", "-144,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/double_lane/1-2_double_lane_x4.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_lane/1-2_double_lane_x4.mdl", "#", "#", 2, "", "-288,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/double_lane/1-3_double_lane_x8.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_lane/1-3_double_lane_x8.mdl", "#", "#", 2, "", "-576,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/double_lane/1-4_double_lane_x16.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_lane/1-4_double_lane_x16.mdl", "#", "#", 2, "", "-1152,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/double_lane/1-5_double_lane_x32.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_lane/1-5_double_lane_x32.mdl", "#", "#", 2, "", "-2304,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/double_lane/1-6_double_lane_x64.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_lane/1-6_double_lane_x64.mdl", "#", "#", 2, "", "-4608,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/double_lane/1-7_double_lane_x128.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_lane/1-7_double_lane_x128.mdl", "#", "#", 2, "", "-9216,0,3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-4_highway_blank_x1.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-4_highway_blank_x1.mdl", "#", "#", 2, "", "-72,0,315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-4_highway_dash_x1.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-4_highway_dash_x1.mdl", "#", "#", 2, "", "-72,0,315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-5_highway_x2.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-5_highway_x2.mdl", "#", "#", 2, "", "-144,0,315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-6_highway_x4.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-6_highway_x4.mdl", "#", "#", 2, "", "-288,0,315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-7_highway_x8.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-7_highway_x8.mdl", "#", "#", 2, "", "-576,0,315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-8_highway_x16.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-8_highway_x16.mdl", "#", "#", 2, "", "-1152,0,315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-9_highway_x32.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-9_highway_x32.mdl", "#", "#", 2, "", "-2304,0,315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-10_highway_x64.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-10_highway_x64.mdl", "#", "#", 2, "", "-4608,0,315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-11_highway_x128.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-11_highway_x128.mdl", "#", "#", 2, "", "-9216,0,315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-0_intersect_double_lane_a.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_turns/4-0_intersect_double_lane_a.mdl", "#", "#", 2, "", "-628 , 628, 3.03125", "0, 90,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-0_intersect_double_lane_a.mdl", "#", "#", 3, "", "-1256,   0, 3.03125", "0,180,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-0_intersect_double_lane_a.mdl", "#", "#", 4, "", "-628 ,-628, 3.03125", "0,-90,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-1_intersect_double_lane_b.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_turns/4-1_intersect_double_lane_b.mdl", "#", "#", 2, "", "-628 , 628, 3.03125", "0, 90,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-1_intersect_double_lane_b.mdl", "#", "#", 3, "", "-628 ,-628, 3.03125", "0,-90,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-2_intersect_double_lane_c.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_turns/4-2_intersect_double_lane_c.mdl", "#", "#", 2, "", "-628 , 628, 3.03125", "0, 90,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-3_intersect_double_lane_d.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_turns/4-3_intersect_double_lane_d.mdl", "#", "#", 2, "", "-628,-628, 3.03125", "0, -90,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-4_intersect_double_lane_e.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/highway/5-1_highway_entrance_type_a_b.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/highway/5-1_highway_entrance_type_a_b.mdl", "#", "#", 2, "", "-2580, 0, 3.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-3_highway_entrance_type_b_b.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway/5-3_highway_entrance_type_b_b.mdl", "#", "#", 2, "", "-2736, 0, 315.03125", "0,-180,0"})
  PIECES:Record({"models/roads_pack/highway/5-2_highway_entrance_type_b_a.mdl", "#", "#", 1, "", "0,-4,3.03125"})
  PIECES:Record({"models/roads_pack/highway/5-2_highway_entrance_type_b_a.mdl", "#", "#", 2, "", "-2304, 1148, 315.03125", "0, 90,0"})
  PIECES:Record({"models/roads_pack/highway/5-2_highway_entrance_type_b_a.mdl", "#", "#", 3, "", "-4608,-4,3.03125", "0, 180,0"})
  PIECES:Record({"models/roads_pack/highway/5-2_highway_entrance_type_b_a.mdl", "#", "#", 4, "", "-2304,-1156, 315.03125", "0, -90,0"})
  PIECES:Record({"models/roads_pack/highway/5-0_highway_entrance_type_a_a.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/highway/5-0_highway_entrance_type_a_a.mdl", "#", "#", 2, "", "-2716, 556, 3.03125", "0, 90,0"})
  PIECES:Record({"models/roads_pack/highway/5-0_highway_entrance_type_a_a.mdl", "#", "#", 3, "", "-5432,0,3.03125", "0, 180,0"})
  PIECES:Record({"models/roads_pack/highway/5-0_highway_entrance_type_a_a.mdl", "#", "#", 4, "", "-2716,-556, 3.03125", "0, -90,0"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-0_highway_dash_x1.mdl", "#", "#", 1, "", "0,0,91.03125"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-0_highway_dash_x1.mdl", "#", "#", 2, "", "-72,0,91.03125", "0,180,0"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-0_highway_blank_x1.mdl", "#", "#", 1, "", "0,0,91.03125"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-0_highway_blank_x1.mdl", "#", "#", 2, "", "-72,0,91.03125", "0,180,0"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-1_highway_x2.mdl", "#", "#", 1, "", "0,0,91.03125"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-1_highway_x2.mdl", "#", "#", 2, "", "-144,0,91.03125", "0,180,0"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-2_highway_x8.mdl", "#", "#", 1, "", "0,0,91.03125"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-2_highway_x8.mdl", "#", "#", 2, "", "-576,0,91.03125", "0,180,0"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-3_highway_x32.mdl", "#", "#", 1, "", "0,0,91.03125"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-3_highway_x32.mdl", "#", "#", 2, "", "-2304,0,91.03125", "0,180,0"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-4_highway_x64.mdl", "#", "#", 1, "", "0,0,91.03125"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-4_highway_x64.mdl", "#", "#", 2, "", "-4608,0,91.03125", "0,180,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-5_turn_double_lane_a.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_turns/4-5_turn_double_lane_a.mdl", "#", "#", 2, "", "-628,628,3.03125", "0,90,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-6_turn_double_lane_b.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_turns/4-6_turn_double_lane_b.mdl", "#", "#", 2, "", "-2860,2860,3.03125", "0,90,0"})
  PIECES:Record({"models/roads_pack/double_turns/4-7_turn_double_lane_c.mdl", "#", "#", 1, "", "0,0,3.03125"})
  PIECES:Record({"models/roads_pack/double_turns/4-7_turn_double_lane_c.mdl", "#", "#", 2, "", "-5164,5164,3.03125", "0,90,0"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-5_highway_turn_a.mdl", "#", "#", 1, "", "0,-82,90.03125"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-5_highway_turn_a.mdl", "#", "#", 2, "", "-628,546,90.03125", "0,90,0"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-6_highway_turn_b.mdl", "#", "#", 1, "", "0,0,91.03125"})
  PIECES:Record({"models/roads_pack/highway_bridge/6-6_highway_turn_b.mdl", "#", "#", 2, "", "-2860,2860,91.03125", "0,90,0"})
  PIECES:Record({"models/roads_pack/highway_turns/6-0_highway_turn_a.mdl", "#", "#", 1, "", "0,-82,314.03125"})
  PIECES:Record({"models/roads_pack/highway_turns/6-0_highway_turn_a.mdl", "#", "#", 2, "", "-628,546,314.03125", "0,90,0"})
  PIECES:Record({"models/roads_pack/highway_turns/6-1_highway_turn_b.mdl", "#", "#", 1, "", "0,0,315.03125"})
  PIECES:Record({"models/roads_pack/highway_turns/6-1_highway_turn_b.mdl", "#", "#", 2, "", "-2860,2860,315.03125", "0,90,0"})
  asmlib.Categorize("Modular Canals",[[function(m)
    local n = m:gsub("models/props_d47_canals/interior_","")
    local r = n:match("%a+"); n = n:gsub("%.mdl",""); return r, n; end]])
  PIECES:Record({"models/props_d47_canals/interior_narrow_128.mdl", "#", "#", 1, "", "64,64,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_128.mdl", "#", "#", 2, "", "-64,64,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_256.mdl", "#", "#", 1, "", "128,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_256.mdl", "#", "#", 2, "", "-128,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_connector1.mdl", "#", "#", 1, "", "128,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_connector1.mdl", "#", "#", 2, "", "-128,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_connector2.mdl", "#", "#", 1, "", "128,64,0"})
  PIECES:Record({"models/props_d47_canals/interior_connector2.mdl", "#", "#", 2, "", "-128,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_connector3.mdl", "#", "#", 1, "", "128,-64,0"})
  PIECES:Record({"models/props_d47_canals/interior_connector3.mdl", "#", "#", 2, "", "-128,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_corner.mdl", "#", "#", 1, "", "56,-136,0", "0,-90,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_corner.mdl", "#", "#", 2, "", "-136,56,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_corner2.mdl", "#", "#", 1, "", "136,56,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_corner2.mdl", "#", "#", 2, "", "-56,-136,0", "0,-90,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_tjunc.mdl", "#", "#", 1, "", "56,248,0", "0,90,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_tjunc.mdl", "#", "#", 2, "", "-136,56,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_tjunc.mdl", "#", "#", 3, "", "56,-136,0", "0,-90,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_stairs.mdl", "#", "#", 1, "", "256,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_stairs.mdl", "#", "#", 2, "", "-256,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_stairs_mirrored.mdl", "#", "#", 1, "", "256,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_stairs_mirrored.mdl", "#", "#", 2, "", "-256,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_xjunc.mdl", "#", "#", 1, "", "192,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_xjunc.mdl", "#", "#", 2, "", "0,192,0", "0,90,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_xjunc.mdl", "#", "#", 3, "", "-192,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_narrow_xjunc.mdl", "#", "#", 4, "", "0,-192,0", "0,-90,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_128.mdl", "#", "#", 1, "", "64,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_128.mdl", "#", "#", 2, "", "-64,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_256.mdl", "#", "#", 1, "", "128,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_256.mdl", "#", "#", 2, "", "-128,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_corner.mdl", "#", "#", 1, "", "-200,56,0", "0,180,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_corner.mdl", "#", "#", 2, "", "56,-200,0", "0,-90,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_corner2.mdl", "#", "#", 1, "", "56,200,0", "0,90,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_corner2.mdl", "#", "#", 2, "", "-200,-56,0", "0,180,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_stairs.mdl", "#", "#", 1, "", "256,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_stairs.mdl", "#", "#", 2, "", "-256,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_stairs_mirrored.mdl", "#", "#", 1, "", "256,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_stairs_mirrored.mdl", "#", "#", 2, "", "-256,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_tjunc_narrow.mdl", "#", "#", 1, "", "0,-144,0", "0,-90,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_tjunc_narrow.mdl", "#", "#", 2, "", "128,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_tjunc_narrow.mdl", "#", "#", 3, "", "-128,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_xjunc_narrow.mdl", "#", "#", 1, "", "128,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_xjunc_narrow.mdl", "#", "#", 2, "", "0,-144,0", "0,-90,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_xjunc_narrow.mdl", "#", "#", 3, "", "-128,0,0", "0,-180,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_xjunc_narrow.mdl", "#", "#", 4, "", "0,144,0", "0,90,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_xjunc.mdl", "#", "#", 1, "", "256,0,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_xjunc.mdl", "#", "#", 2, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_xjunc.mdl", "#", "#", 3, "", "-256,0,0", "0,180,0"})
  PIECES:Record({"models/props_d47_canals/interior_wide_xjunc.mdl", "#", "#", 4, "", "0,256,0", "0,90,0"})
  asmlib.Categorize("Trackmania United Props",[[function(m)
    local g = m:gsub("models/nokillnando/trackmania/ground/", "")
    local r = g:match(".+/"):sub(1,-2); return r; end]])
  PIECES:Record({"models/nokillnando/trackmania/ground/straight/straightx1.mdl", "#", "#", 1, "", " 480,0,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/straight/straightx1.mdl", "#", "#", 2, "", "-480,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/dipmiddle.mdl", "#", "#", 1, "", " 477.1748,0,65.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/dipmiddle.mdl", "#", "#", 2, "", "-482.8252,0,65.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/obstaclenomiddle.mdl", "#", "#", 1, "", " 477.1748,0,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/obstaclenomiddle.mdl", "#", "#", 2, "", "-482.8252,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/obstaclex.mdl", "#", "#", 1, "", " 477.1748,0,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/obstaclex.mdl", "#", "#", 2, "", "-482.8252,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/pillardouble.mdl", "#", "#", 1, "", " 477.1748,0,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/pillardouble.mdl", "#", "#", 2, "", "-482.8252,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/pillarmiddle.mdl", "#", "#", 1, "", " 477.1748,0,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/pillarmiddle.mdl", "#", "#", 2, "", "-482.8252,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/pillartriple.mdl", "#", "#", 1, "", " 477.1748,0,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/obstacle/pillartriple.mdl", "#", "#", 2, "", "-482.8252,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/straight/boost.mdl", "#", "#", 1, "", " 478.86475,0,5.65527"})
  PIECES:Record({"models/nokillnando/trackmania/ground/straight/boost.mdl", "#", "#", 2, "", "-481.13525,0,5.65527", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/straight/straightstart.mdl", "#", "#", 1, "", "-122.82617,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/straight/trackstart.mdl", "#", "#", 1, "", "-9.6377,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/sbigleft.mdl", "#", "#", 1, "", "1983.89588,1142.77014,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/sbigleft.mdl", "#", "#", 2, "", "-1856.09961,-777.21912,5.65723", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/sbigright.mdl", "#", "#", 1, "", " 1983.89088,-1142.76953,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/sbigright.mdl", "#", "#", 2, "", "-1856.09950,777.21912,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/yout.mdl", "#", "#", 1, "", "-27.11389,0,5.65723", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/yout.mdl", "#", "#", 2, "", "1412.886,-1440,5.65723", "0,-90,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/yout.mdl", "#", "#", 3, "", "1412.886,1440,5.65723", "0,90,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/yin.mdl", "#", "#", 1, "", "-31.29919,0,5.65723", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/yin.mdl", "#", "#", 2, "", "1888.66163,-960,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/yin.mdl", "#", "#", 3, "", "1888.66163,960,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/x.mdl", "#", "#", 1, "", "477.174,0.00024,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/x.mdl", "#", "#", 2, "", "-2.69753,-479.99927,5.65723", "0,-90,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/x.mdl", "#", "#", 3, "", "-482.82501,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/x.mdl", "#", "#", 4, "", "-2.82444,479.99878,5.65723", "0,90,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/t.mdl", "#", "#", 1, "", "13.46277,465.00085,5.65723", "0,90,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/t.mdl", "#", "#", 2, "", "-465.00076,-14.71875,5.65723", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/t.mdl", "#", "#", 3, "", "492.17401,-14.99945,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/l.mdl", "#", "#", 1, "", "-391.19399,-91.63025,5.65723", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/l.mdl", "#", "#", 2, "", "88.80608,388.36523,5.65723", "0,90,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/90med.mdl", "#", "#", 1, "", "700.11916,1697.05518,5.65723", "0,90,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/90med.mdl", "#", "#", 2, "", "-1699.87913,-702.94385,5.65723", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/90small.mdl", "#", "#", 1, "", "418.94192,1018.23267,5.65723", "0,90,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/90small.mdl", "#", "#", 2, "", "-1021.05686,-421.76636,5.65723", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/90big.mdl", "#", "#", 1, "", "-2378.70115,-984.12146,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/90big.mdl", "#", "#", 2, "", "981.29665,2375.87769,5.65723", "0,90,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/loopleft.mdl", "#", "#", 1, "", "31.69263,15,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/loopleft.mdl", "#", "#", 2, "", "31.69263,-1905,2574.34", "0,0,180"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/loopright.mdl", "#", "#", 1, "", "28.85986,-15,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/loopright.mdl", "#", "#", 2, "", "28.85986,1905,2574.34", "0,0,180"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/smedleft.mdl", "#", "#", 1, "", " 1351.56785,517.28467,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/smedleft.mdl", "#", "#", 2, "", "-1528.42796,-442.71533,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/smedright.mdl", "#", "#", 1, "", "1430.14109,-565.99805,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/smedright.mdl", "#", "#", 2, "", "-1449.85471,394.00171,5.65723", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/ssmallright.mdl", "#", "#", 1, "", "958.12327,-530.2124,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/ssmallright.mdl", "#", "#", 2, "", "-961.83323,429.78589,5.65723", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/ssmallleft.mdl", "#", "#", 1, "", "958.12136,480.43057,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/ssmallleft.mdl", "#", "#", 2, "", "-961.83547,-479.56793,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/startingpoint.mdl", "#", "#", 1, "", "-477.88706,0.09363,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/endingpoint.mdl", "#", "#", 1, "", "255,0,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/endingpoint.mdl", "#", "#", 2, "", "-255,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/checkpoint.mdl", "#", "#", 1, "", " 480,0,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/checkpoint.mdl", "#", "#", 2, "", "-480,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/checkpointground.mdl", "#", "#", 1, "", "-180,0,0", "0,180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/jump/jumplow.mdl", "#", "#", 1, "", "-242.82343,0,5.65723", "0,-180,0"})
  PIECES:Record({"models/nokillnando/trackmania/ground/jump/jumphigh.mdl", "#", "#", 1, "", "-242.82343,0,5.65723", "0,-180,0"})
  asmlib.Categorize("Modular Sewer")
  asmlib.ModelToNameRule("SET",nil,{"sewertunnel",""},nil)
  PIECES:Record({"models/sewerpack/sewertunneli.mdl", "#", "#", 1, "", " 113.96,0,1"})
  PIECES:Record({"models/sewerpack/sewertunneli.mdl", "#", "#", 2, "", "-113.96,0,1", "0,180,0"})
  PIECES:Record({"models/sewerpack/sewertunnelcap.mdl", "#", "#", 1, "", "113.96,0,1"})
  PIECES:Record({"models/sewerpack/sewertunnelexit.mdl", "#", "#", 1, "", "-2.657,0,1", "0,-180,0"})
  PIECES:Record({"models/sewerpack/sewertunnelr.mdl", "#", "#", 1, "", "0.08838,0.09961,1"})
  PIECES:Record({"models/sewerpack/sewertunnelr.mdl", "#", "#", 2, "", "-113.87988,114.07129,1", "0,90,0"})
  PIECES:Record({"models/sewerpack/sewertunnelt.mdl", "#", "#", 1, "", " 113.96,0,1"})
  PIECES:Record({"models/sewerpack/sewertunnelt.mdl", "#", "#", 2, "", "0,-113.96,1", "0,-90,0"})
  PIECES:Record({"models/sewerpack/sewertunnelt.mdl", "#", "#", 3, "", "-113.96,0,1", "0,180,0"})
  PIECES:Record({"models/sewerpack/sewertunnelx.mdl", "#", "#", 1, "", "113.96,0,1"})
  PIECES:Record({"models/sewerpack/sewertunnelx.mdl", "#", "#", 2, "", "0,113.96,1", "0,90,0"})
  PIECES:Record({"models/sewerpack/sewertunnelx.mdl", "#", "#", 3, "", "0,-113.96,1", "0,-90,0"})
  PIECES:Record({"models/sewerpack/sewertunnelx.mdl", "#", "#", 4, "", "-113.96,0,1", "0,180,0"})
  asmlib.Categorize("Portal 2 Walkway UG",[[function(m)
    local g = m:gsub("models/props_underground/", "") return g:match("%w+") end]])
  asmlib.ModelToNameRule("SET",nil,{"%w+_",""},nil)
  PIECES:Record({"models/props_underground/walkway_32a.mdl", "#", "#", 1, "", "0, 16,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_32a.mdl", "#", "#", 2, "", "0,-16,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_32b.mdl", "#", "#", 1, "", "0, 16,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_32b.mdl", "#", "#", 2, "", "0,-16,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_32c.mdl", "#", "#", 1, "", "0, 16,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_32c.mdl", "#", "#", 2, "", "0,-16,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_64a.mdl", "#", "#", 1, "", "0, 32,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_64a.mdl", "#", "#", 2, "", "0,-32,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_64b.mdl", "#", "#", 1, "", "0, 32,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_64b.mdl", "#", "#", 2, "", "0,-32,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_64c.mdl", "#", "#", 1, "", "0, 32,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_64c.mdl", "#", "#", 2, "", "0,-32,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_128a.mdl", "#", "#", 1, "", "0, 64,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_128a.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_128b.mdl", "#", "#", 1, "", "0, 64,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_128b.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_128c.mdl", "#", "#", 1, "", "0, 64,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_128c.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_256a.mdl", "#", "#", 1, "", "0, 128,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_256a.mdl", "#", "#", 2, "", "0,-128,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_256b.mdl", "#", "#", 1, "", "0, 128,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_256b.mdl", "#", "#", 2, "", "0,-128,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_256c.mdl", "#", "#", 1, "", "0, 128,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_256c.mdl", "#", "#", 2, "", "0,-128,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_512a.mdl", "#", "#", 1, "", "0, 256,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_512a.mdl", "#", "#", 2, "", "0,-256,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_512b.mdl", "#", "#", 1, "", "0, 256,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_512b.mdl", "#", "#", 2, "", "0,-256,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_512c.mdl", "#", "#", 1, "", "0, 256,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_512c.mdl", "#", "#", 2, "", "0,-256,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_corner.mdl", "#", "#", 1, "", "64,0,-2.125"})
  PIECES:Record({"models/props_underground/walkway_corner.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_l.mdl", "#", "#", 1, "", "64,0,-2.125"})
  PIECES:Record({"models/props_underground/walkway_l.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_end_a.mdl", "#", "#", 1, "", "0,-16,-2.125","0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_end_b.mdl", "#", "#", 1, "", "0,-64,-2.125","0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_end_c.mdl", "#", "#", 1, "36,0,-2.125", "0, 4,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_end_c.mdl", "#", "#", 2, "-36,0,-2.125", "0,-4,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_end_cap.mdl", "#", "#", 1, "36,0,-2.125", "0, 4,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_end_cap.mdl", "#", "#", 2, "-36,0,-2.125", "0,-4,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_gate_frame.mdl", "#", "#", 1, "36,0,-2.125", "0, 4,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_gate_frame.mdl", "#", "#", 2, "-36,0,-2.125", "0,-4,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_gate_frame_alt.mdl", "#", "#", 1, "36,0,-2.125", "0, 4,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_gate_frame_alt.mdl", "#", "#", 2, "-36,0,-2.125", "0,-4,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_t.mdl", "#", "#", 1, "", "64,0,-2.125"})
  PIECES:Record({"models/props_underground/walkway_t.mdl", "#", "#", 2, "", "0,64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_t.mdl", "#", "#", 3, "", "0,-64,-2.125","0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_x.mdl", "#", "#", 1, "", "64,0,-2.125"})
  PIECES:Record({"models/props_underground/walkway_x.mdl", "#", "#", 2, "", "0,64,-2.125", "0, 90,0"})
  PIECES:Record({"models/props_underground/walkway_x.mdl", "#", "#", 3, "", "-64,0,-2.125","0,180,0"})
  PIECES:Record({"models/props_underground/walkway_x.mdl", "#", "#", 4, "", "0,-64,-2.125","0,-90,0"})
  PIECES:Record({"models/props_underground/stair_32.mdl", "#", "#", 1, "", "0,-56,-18.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/stair_32.mdl", "#", "#", 2, "", "0, 56,13.875", "0, 90,0"})
  PIECES:Record({"models/props_underground/stair_64.mdl", "#", "#", 1, "", "0,-80,-34.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/stair_64.mdl", "#", "#", 2, "", "0, 80,29.875", "0, 90,0"})
  PIECES:Record({"models/props_underground/stair_128.mdl", "#", "#", 1, "", "0,-128,-66.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/stair_128.mdl", "#", "#", 2, "", "0, 128,61.875", "0, 90,0"})
  PIECES:Record({"models/props_underground/stair_256.mdl", "#", "#", 1, "", "0,-224,-130.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/stair_256.mdl", "#", "#", 2, "", "0, 224,125.875", "0, 90,0"})
  PIECES:Record({"models/props_underground/stair_exit.mdl", "#", "#", 1, "", "0,-112,-66.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/stair_exit.mdl", "#", "#", 2, "", "0, 112,61.875", "0, 90,0"})
  PIECES:Record({"models/props_underground/stair_landing_a.mdl", "#", "#", 1, "", "48,-42,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/stair_landing_a.mdl", "#", "#", 2, "", "-48,-42,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/stair_landing_b.mdl", "#", "#", 1, "", "48,-42,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/stair_landing_b.mdl", "#", "#", 2, "", "-48,-42,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/stair_landing_b.mdl", "#", "#", 3, "", "-112,0,-2.125", "0,180,0"})
  PIECES:Record({"models/props_underground/railing_32a.mdl", "#", "#", 1, "", "-35,16,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/railing_32b.mdl", "#", "#", 1, "", "-35,16,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/railing_64a.mdl", "#", "#", 1, "", "-35,32,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/railing_64b.mdl", "#", "#", 1, "", "-35,32,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/railing_128a.mdl", "#", "#", 1, "", "-35,64,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/railing_128b.mdl", "#", "#", 1, "", "-35,64,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/railing_256a.mdl", "#", "#", 1, "", "-35,128,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/railing_256b.mdl", "#", "#", 1, "", "-35,128,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/railing_512a.mdl", "#", "#", 1, "", "-35,256,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/railing_512b.mdl", "#", "#", 1, "", "-35,256,-6.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_destroyed_64a.mdl", "#", "#", 1, "", "0,0,-2.125", "0,90,0"})
  PIECES:Record({"models/props_underground/walkway_destroyed_128a.mdl", "#", "#", 1, "", "0,0,-2.125", "0,90,0"})
  PIECES:Record({"models/props_underground/walkway_gate_a.mdl", "#", "#", 1, "", "0, 4,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_gate_a.mdl", "#", "#", 2, "", "0,-4,-2.125", "0,90,0"})
  PIECES:Record({"models/props_underground/walkway_gate_b.mdl", "#", "#", 1, "", "0, 4,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_underground/walkway_gate_b.mdl", "#", "#", 2, "", "0,-4,-2.125", "0,90,0"})
  asmlib.Categorize("CAP Walkway",[[function(m)
    local g = m:gsub("models/boba_fett/catwalk_build/", "")
    local p = g:match("%w+_"); return (p and p:sub(1,-2) or "other") end]])
  asmlib.ModelToNameRule("SET",nil,{"^%w+_+",""},nil)
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_short.mdl", "#", "#", 1, "", " 89.0125,0,-12.7"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_short.mdl", "#", "#", 2, "", "-89.0125,0,-12.7", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_corner.mdl", "#", "#", 1, "", "-137.4472,37.11516,-12.7", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_corner.mdl", "#", "#", 2, "", "37.11516,-137.4472,-12.7", "0,-90,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_end.mdl", "#", "#", 1, "", "-137.24675,0,-12.7", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_med.mdl", "#", "#", 1, "", " 172.23691,0,-12.7"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_med.mdl", "#", "#", 2, "", "-172.23691,0,-12.7", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_long.mdl", "#", "#", 1, "", " 337.7742,0,-12.7"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_long.mdl", "#", "#", 2, "", "-337.7742,0,-12.7", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_t.mdl", "#", "#", 1, "", "-137.44797,0,-12.7", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_t.mdl", "#", "#", 2, "", "37.12806,-174.55254,-12.7", "0,-90,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_t.mdl", "#", "#", 3, "", "37.12806,174.55254,-12.7", "0,90,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_x.mdl", "#", "#", 1, "", "174.55254,0,-12.7"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_x.mdl", "#", "#", 2, "", "0,174.55254,-12.7", "0,90,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_x.mdl", "#", "#", 3, "", "-174.55254,0,-12.7", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_x.mdl", "#", "#", 4, "", "0,-174.55254,-12.7", "0,-90,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_x_big.mdl", "#", "#", 1, "", "234.58699,0,-12.7"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_x_big.mdl", "#", "#", 2, "", "0.31703,234.26997,-12.7", "0,90,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_x_big.mdl", "#", "#", 3, "", "-233.95296,0,-12.7", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/catwalk_x_big.mdl", "#", "#", 4, "", "0.31701,-234.26991,-12.7", "0,-90,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/landing_platform.mdl", "#", "#", 1, "", "-755.98682,-348.96243,42.80078", "0,-180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/landing_platform.mdl", "#", "#", 2, "", "-755.98682,349.68161,42.80078", "0,-180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/gate_platform.mdl", "#", "#", 1, "", "330,0,3.3"})
  PIECES:Record({"models/boba_fett/catwalk_build/gate_platform.mdl", "#", "#", 2, "", "0,330,3.3", "0,90,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/gate_platform.mdl", "#", "#", 3, "", "-330,0,3.3", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/gate_platform.mdl", "#", "#", 4, "", "0,-330,3.3", "0,-90,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/nanog_end.mdl", "#", "#", 1, "", "-286.09482,-0.0823,3.74512", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/nanog_mid.mdl", "#", "#", 1, "", "-304.15,0,3.755", "0,180,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/nanog_mid.mdl", "#", "#", 2, "", "236.8,-197,3.755", "0,-40,0"})
  PIECES:Record({"models/boba_fett/catwalk_build/nanog_mid.mdl", "#", "#", 3, "", "236.8,197,3.755", "0,40,0"})
  asmlib.Categorize("Portal 2 High Walkway",[[function(m)
    local g = m:gsub("^.*walkway",""):gsub("%.mdl$", "")
    if(g:find("%d")) then return "straight"
    elseif(g:find("%a+_*")) then local s = g:match("%a+_*")
      if(s:len() <= 2) then return "turns" else return "special" end
    else return nil end end]])
  asmlib.ModelToNameRule("SET",nil,{"^.*walkway_*",""},nil)
  PIECES:Record({"models/props_bts/hanging_walkway_16a.mdl", "#", "#", 1, "", "0, 8,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_16a.mdl", "#", "#", 2, "", "0,-8,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_16b.mdl", "#", "#", 1, "", "0, 8,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_16b.mdl", "#", "#", 2, "", "0,-8,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_16c.mdl", "#", "#", 1, "", "0, 8,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_16c.mdl", "#", "#", 2, "", "0,-8,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_16d.mdl", "#", "#", 1, "", "0, 8,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_16d.mdl", "#", "#", 2, "", "0,-8,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_16e.mdl", "#", "#", 1, "", "0, 8,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_16e.mdl", "#", "#", 2, "", "0,-8,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32a.mdl", "#", "#", 1, "", "0, 16,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32a.mdl", "#", "#", 2, "", "0,-16,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32b.mdl", "#", "#", 1, "", "0, 16,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32b.mdl", "#", "#", 2, "", "0,-16,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32c.mdl", "#", "#", 1, "", "0, 16,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32c.mdl", "#", "#", 2, "", "0,-16,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32d.mdl", "#", "#", 1, "", "0, 16,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32d.mdl", "#", "#", 2, "", "0,-16,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32e.mdl", "#", "#", 1, "", "0, 16,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_32e.mdl", "#", "#", 2, "", "0,-16,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64a.mdl", "#", "#", 1, "", "0, 32,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64a.mdl", "#", "#", 2, "", "0,-32,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64b.mdl", "#", "#", 1, "", "0, 32,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64b.mdl", "#", "#", 2, "", "0,-32,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64c.mdl", "#", "#", 1, "", "0, 32,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64c.mdl", "#", "#", 2, "", "0,-32,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64d.mdl", "#", "#", 1, "", "0, 32,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64d.mdl", "#", "#", 2, "", "0,-32,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64e.mdl", "#", "#", 1, "", "0, 32,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_64e.mdl", "#", "#", 2, "", "0,-32,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128a.mdl", "#", "#", 1, "", "0, 64,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128a.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128b.mdl", "#", "#", 1, "", "0, 64,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128b.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128c.mdl", "#", "#", 1, "", "0, 64,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128c.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128d.mdl", "#", "#", 1, "", "0, 64,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128d.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128e.mdl", "#", "#", 1, "", "0, 64,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_128e.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256a.mdl", "#", "#", 1, "", "0, 128,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256a.mdl", "#", "#", 2, "", "0,-128,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256b.mdl", "#", "#", 1, "", "0, 128,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256b.mdl", "#", "#", 2, "", "0,-128,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256c.mdl", "#", "#", 1, "", "0, 128,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256c.mdl", "#", "#", 2, "", "0,-128,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256d.mdl", "#", "#", 1, "", "0, 128,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256d.mdl", "#", "#", 2, "", "0,-128,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256e.mdl", "#", "#", 1, "", "0, 128,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_256e.mdl", "#", "#", 2, "", "0,-128,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_angle_30.mdl", "#", "#", 1, "", "0,-44.01274,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_angle_30.mdl", "#", "#", 2, "", "40.52878,23.40695,-2.125", "0,30,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_corner.mdl", "#", "#", 1, "", "64,0,-2.125"})
  PIECES:Record({"models/props_bts/hanging_walkway_corner.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_end_a.mdl", "#", "#", 1, "", "0,-16,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_end_b.mdl", "#", "#", 1, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_end_cap.mdl", "#", "#", 1, "", "0,0,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_gate_a.mdl", "#", "#", 1, " 36.5,0,20", "", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_gate_a.mdl", "#", "#", 2, "-36.5,0,20", "", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_gate_frame.mdl", "#", "#", 1, " 36.5,0,20", "", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_gate_frame.mdl", "#", "#", 2, "-36.5,0,20", "", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_gate_door.mdl", "#", "#", 1, "", "", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_gate_door.mdl", "#", "#", 2, "", "0,8,0", "0, 90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_l.mdl", "#", "#", 1, "", "64, 0,-2.125"})
  PIECES:Record({"models/props_bts/hanging_walkway_l.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_l_norail.mdl", "#", "#", 1, "", "64, 0,-2.125"})
  PIECES:Record({"models/props_bts/hanging_walkway_l_norail.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_t.mdl", "#", "#", 1, "", "64, 0,-2.125"})
  PIECES:Record({"models/props_bts/hanging_walkway_t.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_t.mdl", "#", "#", 3, "", "0, 64,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_t_norail.mdl", "#", "#", 1, "", "64, 0,-2.125"})
  PIECES:Record({"models/props_bts/hanging_walkway_t_norail.mdl", "#", "#", 2, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_t_norail.mdl", "#", "#", 3, "", "0, 64,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_x.mdl", "#", "#", 1, "", "64,0,-2.125"})
  PIECES:Record({"models/props_bts/hanging_walkway_x.mdl", "#", "#", 2, "", "0,64,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_x.mdl", "#", "#", 3, "", "-64,0,-2.125", "0,180,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_x.mdl", "#", "#", 4, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_x_norail.mdl", "#", "#", 1, "", "64,0,-2.125"})
  PIECES:Record({"models/props_bts/hanging_walkway_x_norail.mdl", "#", "#", 2, "", "0,64,-2.125", "0,90,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_x_norail.mdl", "#", "#", 3, "", "-64,0,-2.125", "0,180,0"})
  PIECES:Record({"models/props_bts/hanging_walkway_x_norail.mdl", "#", "#", 4, "", "0,-64,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/walkway_destroyed_64a.mdl", "#", "#", 1, "", "0,0,-2.125", "0,-90,0"})
  PIECES:Record({"models/props_bts/walkway_destroyed_128a.mdl", "#", "#", 1, "", "0,0,-2.125", "0,90,0"})
  asmlib.Categorize("RockMan's Fortification",[[function(m)
    local r = m:gsub(".+/", ""):gsub("_.*",""); return r end]])
  asmlib.ModelToNameRule("SET",nil,{".+_",""},nil)
  PIECES:Record({"models/fortification collection/trench_straight.mdl", "#", "#", 1, "", "177,0,0"})
  PIECES:Record({"models/fortification collection/trench_straight.mdl", "#", "#", 2, "", "-177,0,0", "0,180,0"})
  PIECES:Record({"models/fortification collection/trench_end_corridor.mdl", "#", "#", 1, "", "177,0,0"})
  PIECES:Record({"models/fortification collection/trench_end_corridor.mdl", "#", "#", 2, "", "0,192,0", "0,90,0"})
  PIECES:Record({"models/fortification collection/trench_end_corridor.mdl", "#", "#", 3, "", "-177,0,0", "0,180,0"})
  PIECES:Record({"models/fortification collection/trench_3way.mdl", "#", "#", 1, "", "192,0,0"})
  PIECES:Record({"models/fortification collection/trench_3way.mdl", "#", "#", 2, "", "0,192,0", "0,90,0"})
  PIECES:Record({"models/fortification collection/trench_3way.mdl", "#", "#", 3, "", "-192,0,0", "0,180,0"})
  PIECES:Record({"models/fortification collection/trench_4way.mdl", "#", "#", 1, "", "192,0,0"})
  PIECES:Record({"models/fortification collection/trench_4way.mdl", "#", "#", 2, "", "0,192,0", "0,90,0"})
  PIECES:Record({"models/fortification collection/trench_4way.mdl", "#", "#", 3, "", "-192,0,0", "0,180,0"})
  PIECES:Record({"models/fortification collection/trench_4way.mdl", "#", "#", 4, "", "0,-192,0", "0,-90,0"})
  PIECES:Record({"models/fortification collection/trench_turn.mdl", "#", "#", 1, "", "16.5014,208.5,0", "0,90,0"})
  PIECES:Record({"models/fortification collection/trench_turn.mdl", "#", "#", 2, "", "-208.5,-16.5014,0", "0,-180,0"})
  PIECES:Record({"models/fortification collection/trench_end_single.mdl", "#", "#", 1, "", "0,-80,0", "0,-90,0"})
  PIECES:Record({"models/fortification collection/trench_end_single.mdl", "#", "#", 2, "", "0,80,0", "0,90,0"})
  PIECES:Record({"models/fortification collection/small_bunker1.mdl", "#", "#", 1, "", "0,-72,-24", "0,-90,0"})
  PIECES:Record({"models/fortification collection/small_bunker1a.mdl", "#", "#", 1, "", "0,-156,-24", "0,-90,0"})
  PIECES:Record({"models/fortification collection/small_bunker2.mdl", "#", "#", 1, "", "0,-100,-24", "0,-90,0"})
  PIECES:Record({"models/fortification collection/small_bunker2a.mdl", "#", "#", 1, "", "0,-156,-24", "0,-90,0"})
  asmlib.Categorize("SligWolf's Bodygroup Car")
  PIECES:Record({"models/sligwolf/bgcar/swrccross.mdl", "#", "Switcher Cross", 1, "", "500,0,0"})
  PIECES:Record({"models/sligwolf/bgcar/swrccross.mdl", "#", "Switcher Cross", 2, "", "-2673,0,0", "0,180,0"})
  PIECES:Record({"models/sligwolf/bgcar/swrccurve001.mdl", "#", "U-Turn", 1, "", "890, 748.009, 2.994"})
  PIECES:Record({"models/sligwolf/bgcar/swrccurve001.mdl", "#", "U-Turn", 2, "", "890, 451.998, 2.994"})
  PIECES:Record({"models/sligwolf/bgcar/swrccurve001.mdl", "#", "U-Turn", 3, "", "890, -452.001, 2.974"})
  PIECES:Record({"models/sligwolf/bgcar/swrccurve001.mdl", "#", "U-Turn", 4, "", "890, -748.027, 2.974"})
  PIECES:Record({"models/sligwolf/bgcar/swrclooping.mdl", "#", "Loop 180", 1, "", "810, -252.447, -0.005"})
  PIECES:Record({"models/sligwolf/bgcar/swrclooping.mdl", "#", "Loop 180", 2, "", "-809.999, 136.997, -0.002", "0,180,0"})
  PIECES:Record({"models/sligwolf/bgcar/swrcloopingspecial.mdl", "#", "LoopSwitch 180", 1, "", "927.001, -194.403, -0.036"})
  PIECES:Record({"models/sligwolf/bgcar/swrcloopingspecial.mdl", "#", "LoopSwitch 180", 2, "", "-809.999, 137.003, 350.984", "0,-180,0"})
  PIECES:Record({"models/sligwolf/bgcar/swrcloopingspecial.mdl", "#", "LoopSwitch 180", 3, "", "-809.999, -527.972, 350.984", "0,-180,0"})
  PIECES:Record({"models/sligwolf/bgcar/swrcramp.mdl", "#", "Ramp 45", 1, "", "1000, 0, 0"})
  PIECES:Record({"models/sligwolf/bgcar/swrcramp.mdl", "#", "Ramp 45", 2, "", "-641.92, 0, 269.672", "-45,-180,0"})
  PIECES:Record({"models/sligwolf/bgcar/swrctraffic_lights.mdl", "#", "Start Lights", 1, "", "0, -152.532, 0"})
  PIECES:Record({"models/sligwolf/bgcar/swrctraffic_lights.mdl", "#", "Start Lights", 2, "", "0, 152.554, 0"})
  PIECES:Record({"models/sligwolf/bgcar/swrctraffic_lights.mdl", "#", "Start Lights", 3, "", "0, 0, 0.042"})
  asmlib.Categorize("SligWolf's Rerailer")
  PIECES:Record({"models/sligwolf/rerailer/sw_rerailer_1.mdl", "#", "Single Short", 1, "-190.553,0,25.193", "211.414,0.015,-5.395"})
  PIECES:Record({"models/sligwolf/rerailer/sw_rerailer_2.mdl", "#", "Single Middle", 1, "-190.553,0,25.193", "211.414,0.015,-5.395"})
  PIECES:Record({"models/sligwolf/rerailer/sw_rerailer_3.mdl", "#", "Single Long", 1, "-190.553,0,25.193", "211.414,0.015,-5.395"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_1.mdl", "#", "Double Short", 1, "-221.409, 0, 3.031", "219.412, 0, -5.411"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_1.mdl", "#", "Double Short", 2, "-1103.05, 0, 0.009", "-1543.871, 0, -5.411", "0,-180,0"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_2.mdl", "#", "Double Middle", 1, "-265.554, 0, 3.031", "219.412, 0, -5.407"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_2.mdl", "#", "Double Middle", 2, "-1882.106, 0, 3.031", "-2367.072, 0, -5.412", "0,-180,0"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_3.mdl", "#", "Double Long", 1, "-258.249, -0.01, -0.002", "219.415, 0, -5.409"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_3.mdl", "#", "Double Long", 2, "-3124.199, -0.01, 2.997", "-3601.869, -0.377, -5.416", "0,-180,0"})
  asmlib.Categorize("Modular City Street", {"@highway", "@street" , "endcap", "turn", "ramp",
    "connector", "tjunction", "intersection", "elevated"}, "models/propper/dingles_modular_streets/")
  PIECES:Record({"models/propper/dingles_modular_streets/street64x512.mdl", "#", "#", 1, "", "0,-32,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street64x512.mdl", "#", "#", 2, "", "0, 32,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street64x768.mdl", "#", "#", 1, "", "0,-32,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street64x768.mdl", "#", "#", 2, "", "0, 32,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street128x512.mdl", "#", "#", 1, "", "0,-64,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street128x512.mdl", "#", "#", 2, "", "0, 64,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street128x768.mdl", "#", "#", 1, "", "0,-64,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street128x768.mdl", "#", "#", 2, "", "0, 64,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street128x512_crosswalk.mdl", "#", "#", 1, "", "0,-64,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street128x512_crosswalk.mdl", "#", "#", 2, "", "0, 64,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street128x768_crosswalk.mdl", "#", "#", 1, "", "0,-64,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street128x768_crosswalk.mdl", "#", "#", 2, "", "0, 64,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street256x512.mdl", "#", "#", 1, "", "0,-128,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street256x512.mdl", "#", "#", 2, "", "0, 128,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street256x768.mdl", "#", "#", 1, "", "0,-128,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street256x768.mdl", "#", "#", 2, "", "0, 128,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512.mdl", "#", "#", 1, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512.mdl", "#", "#", 2, "", "0, 256,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768.mdl", "#", "#", 1, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768.mdl", "#", "#", 2, "", "0, 256,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x512.mdl", "#", "#", 1, "", "0,-384,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x512.mdl", "#", "#", 2, "", "0, 384,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x768.mdl", "#", "#", 1, "", "0,-384,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x768.mdl", "#", "#", 2, "", "0, 384,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512.mdl", "#", "#", 1, "", "0,-512,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512.mdl", "#", "#", 2, "", "0, 512,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768.mdl", "#", "#", 1, "", "0,-512,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768.mdl", "#", "#", 2, "", "0, 512,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street2048x512.mdl", "#", "#", 1, "", "0,-1024,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street2048x512.mdl", "#", "#", 2, "", "0, 1024,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street2048x768.mdl", "#", "#", 1, "", "0,-1024,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street2048x768.mdl", "#", "#", 2, "", "0, 1024,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512_endcap_fancy1.mdl", "#", "#", 1, "", "0,-128,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512_endcap_fancy2.mdl", "#", "#", 1, "", "0,-128,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512_endcap_simple1.mdl", "#", "#", 1, "", "0,-64,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512_endcap_simple2.mdl", "#", "#", 1, "", "0,-64,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768_endcap_fancy1.mdl", "#", "#", 1, "", "0,-192,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768_endcap_fancy2.mdl", "#", "#", 1, "", "0,-192,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768_endcap_simple1.mdl", "#", "#", 1, "", "0,-64,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768_endcap_simple2.mdl", "#", "#", 1, "", "0,-64,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_concrete_to_stone_connector1.mdl", "#", "#", 1, "", "0, 256,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_concrete_to_stone_connector1.mdl", "#", "#", 2, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_concrete_to_stone_connector1.mdl", "#", "#", 3, "", "256,0,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_concrete_to_stone_connector2.mdl", "#", "#", 1, "", "0, 256,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_concrete_to_stone_connector2.mdl", "#", "#", 2, "", "-256,0,0", "0,180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_concrete_to_stone_connector2.mdl", "#", "#", 3, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_concrete_to_stone_connector2.mdl", "#", "#", 4, "", "256,0,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector1.mdl", "#", "#", 1, "", "0, 384,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector1.mdl", "#", "#", 2, "", "0,-384,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector1.mdl", "#", "#", 3, "", "384,0,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector2.mdl", "#", "#", 1, "", "0, 384,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector2.mdl", "#", "#", 2, "", "-384,0,0", "0,180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector2.mdl", "#", "#", 3, "", "0,-384,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768x768_concrete_to_stone_connector2.mdl", "#", "#", 4, "", "384,0,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_512_to_768_connector1.mdl", "#", "#", 1, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_512_to_768_connector1.mdl", "#", "#", 2, "", "384, 0, 0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_512_to_768_connector1.mdl", "#", "#", 3, "", "0, 256,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_512_to_768_connector2.mdl", "#", "#", 1, "", "0, 256,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_512_to_768_connector2.mdl", "#", "#", 2, "", "-384,0,0", "0,180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_512_to_768_connector2.mdl", "#", "#", 3, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_512_to_768_connector2.mdl", "#", "#", 4, "", "384,0,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_tjunction512x512.mdl", "#", "#", 1, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_tjunction512x512.mdl", "#", "#", 2, "", "256, 0, 0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_tjunction512x512.mdl", "#", "#", 3, "", "-256, 0, 0", "0,180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_tjunction768x768.mdl", "#", "#", 1, "", "0,-384,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_tjunction768x768.mdl", "#", "#", 2, "", "384, 0, 0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_tjunction768x768.mdl", "#", "#", 3, "", "-384,0,0", "0,180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_turn512x512.mdl", "#", "#", 1, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_turn512x512.mdl", "#", "#", 2, "", "256, 0, 0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_turn768x768.mdl", "#", "#", 1, "", "0,-384,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_turn768x768.mdl", "#", "#", 2, "", "384, 0, 0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_4wayintersection512x512.mdl", "#", "#", 1, "", "0, 256,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_4wayintersection512x512.mdl", "#", "#", 2, "", "-256,0,0", "0,180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_4wayintersection512x512.mdl", "#", "#", 3, "", "0,-256,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_4wayintersection512x512.mdl", "#", "#", 4, "", "256,0,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_4wayintersection768x768.mdl", "#", "#", 1, "", "0, 384,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_4wayintersection768x768.mdl", "#", "#", 2, "", "-384,0,0", "0,180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_4wayintersection768x768.mdl", "#", "#", 3, "", "0,-384,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street_4wayintersection768x768.mdl", "#", "#", 4, "", "384,0,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768_fork.mdl", "#", "#", 1, "", "0,-655,0", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768_fork.mdl", "#", "#", 2, "", " 994,655,-0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street768_fork.mdl", "#", "#", 3, "", "-994,655,0", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_elevated64high.mdl", "#", "#", 1, "", "0,256,24", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_elevated64high.mdl", "#", "#", 2, "", "0,-256,-24", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_elevated128high.mdl", "#", "#", 1, "", "0,256,56", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_elevated128high.mdl", "#", "#", 2, "", "0,-256,-56", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_elevated192high.mdl", "#", "#", 1, "", "0,256,88", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_elevated192high.mdl", "#", "#", 2, "", "0,-256,-88", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_elevated256high.mdl", "#", "#", 1, "", "0,256,120", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x512_elevated256high.mdl", "#", "#", 2, "", "0,-256,-120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768_elevated64high.mdl", "#", "#", 1, "", "0,256,24", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768_elevated64high.mdl", "#", "#", 2, "", "0,-256,-24", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768_elevated128high.mdl", "#", "#", 1, "", "0,256,56", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768_elevated128high.mdl", "#", "#", 2, "", "0,-256,-56", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768_elevated192high.mdl", "#", "#", 1, "", "0,256,88", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768_elevated192high.mdl", "#", "#", 2, "", "0,-256,-88", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768_elevated256high.mdl", "#", "#", 1, "", "0,256,120", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street512x768_elevated256high.mdl", "#", "#", 2, "", "0,-256,-120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512_elevated64high.mdl", "#", "#", 1, "", "0,512,24", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512_elevated64high.mdl", "#", "#", 2, "", "0,-512,-24", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512_elevated128high.mdl", "#", "#", 1, "", "0,512,56", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512_elevated128high.mdl", "#", "#", 2, "", "0,-512,-56", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512_elevated192high.mdl", "#", "#", 1, "", "0,512,88", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512_elevated192high.mdl", "#", "#", 2, "", "0,-512,-88", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512_elevated256high.mdl", "#", "#", 1, "", "0,512,120", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x512_elevated256high.mdl", "#", "#", 2, "", "0,-512,-120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768_elevated64high.mdl", "#", "#", 1, "", "0,512,24", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768_elevated64high.mdl", "#", "#", 2, "", "0,-512,-24", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768_elevated128high.mdl", "#", "#", 1, "", "0,512,56", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768_elevated128high.mdl", "#", "#", 2, "", "0,-512,-56", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768_elevated192high.mdl", "#", "#", 1, "", "0,512,88", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768_elevated192high.mdl", "#", "#", 2, "", "0,-512,-88", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768_elevated256high.mdl", "#", "#", 1, "", "0,512,120", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/street1024x768_elevated256high.mdl", "#", "#", 2, "", "0,-512,-120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_ramp_street768_short_tall_connector.mdl", "#", "#", 1, "", " 512,0,-8"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_ramp_street768_short_tall_connector.mdl", "#", "#", 2, "", "-512,0,248", "0,180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_ramp_street1024x768.mdl", "#", "#", 1, "", "0, 512, 120", "0, 90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_ramp_street1024x768.mdl", "#", "#", 2, "", "0,-512,-120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_ramp_street2048x768_tall.mdl", "#", "#", 1, "", "0, 1024, 248", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_ramp_street2048x768_tall.mdl", "#", "#", 2, "", "0,-1024,-248", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street256x768.mdl", "#", "#", 1, "", "0,64,120", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street256x768.mdl", "#", "#", 2, "", "0,-64,120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street256x768_tall.mdl", "#", "#", 1, "", "0,64,248", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street256x768_tall.mdl", "#", "#", 2, "", "0,-64,248", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street256x768_overpass.mdl", "#", "#", 1, "", "0,64,40", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street256x768_overpass.mdl", "#", "#", 2, "", "0,-64,40", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street512x768.mdl", "#", "#", 1, "", "0,256,120", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street512x768.mdl", "#", "#", 2, "", "0,-256,120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street512x768_tall.mdl", "#", "#", 1, "", "0,256,248", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street512x768_tall.mdl", "#", "#", 2, "", "0,-256,248", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street512x768_overpass.mdl", "#", "#", 1, "", "0,256,40", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street512x768_overpass.mdl", "#", "#", 2, "", "0,-256,40", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street768x768.mdl", "#", "#", 1, "", "0,384,120", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street768x768.mdl", "#", "#", 2, "", "0,-384,120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street768x768_tall.mdl", "#", "#", 1, "", "0,384,248", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street768x768_tall.mdl", "#", "#", 2, "", "0,-384,248", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street768x768_overpass.mdl", "#", "#", 1, "", "0,384,40", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street768x768_overpass.mdl", "#", "#", 2, "", "0,-384,40", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street1024x768.mdl", "#", "#", 1, "", "0,512,120", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street1024x768.mdl", "#", "#", 2, "", "0,-512,120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street1024x768_tall.mdl", "#", "#", 1, "", "0,512,248", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street1024x768_tall.mdl", "#", "#", 2, "", "0,-512,248", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street1024x768_overpass.mdl", "#", "#", 1, "", "0,512,40", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street1024x768_overpass.mdl", "#", "#", 2, "", "0,-512,40", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street2048x768.mdl", "#", "#", 1, "", "0,1024,120", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street2048x768.mdl", "#", "#", 2, "", "0,-1024,120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street2048x768_tall.mdl", "#", "#", 1, "", "0,1024,248", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street2048x768_tall.mdl", "#", "#", 2, "", "0,-1024,248", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street2048x768_overpass.mdl", "#", "#", 1, "", "0,1024,40", "0,90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street2048x768_overpass.mdl", "#", "#", 2, "", "0,-1024,40", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector.mdl", "#", "#", 1, "", " 384,-384,120"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector.mdl", "#", "#", 2, "", "-384, 384,120", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector.mdl", "#", "#", 3, "", "-384,-384,120", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_tall.mdl", "#", "#", 1, "", " 384,-384,248"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_tall.mdl", "#", "#", 2, "", "-384, 384,248", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_tall.mdl", "#", "#", 3, "", "-384,-384,248", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_mirrored.mdl", "#", "#", 1, "", " 384,-384,120"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_mirrored.mdl", "#", "#", 2, "", " 384, 384,120"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_mirrored.mdl", "#", "#", 3, "", "-384,-384,120", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_mirrored_tall.mdl", "#", "#", 1, "", " 384,-384,248"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_mirrored_tall.mdl", "#", "#", 2, "", " 384, 384,248"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_mirrored_tall.mdl", "#", "#", 3, "", "-384,-384,248", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_double.mdl", "#", "#", 1, "", " 384,-384,120"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_double.mdl", "#", "#", 2, "", " 384, 384,120"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_double.mdl", "#", "#", 3, "", "-384, 384,120", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_double.mdl", "#", "#", 4, "", "-384,-384,120", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_double_tall.mdl", "#", "#", 1, "", " 384,-384,248"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_double_tall.mdl", "#", "#", 2, "", " 384, 384,248"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_double_tall.mdl", "#", "#", 3, "", "-384, 384,248", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768rampconnector_double_tall.mdl", "#", "#", 4, "", "-384,-384,248", "0,-180,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_256turn.mdl", "#", "#", 1, "", "256,128,120"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_256turn.mdl", "#", "#", 2, "", "-128,-256,120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_256turn_tall.mdl", "#", "#", 1, "", "256,128,248"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_256turn_tall.mdl", "#", "#", 2, "", "-128,-256,248", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_512turn.mdl", "#", "#", 1, "", "512,256,120"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_512turn.mdl", "#", "#", 2, "", "-256,-512,120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_512turn_tall.mdl", "#", "#", 1, "", "512,256,248"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_512turn_tall.mdl", "#", "#", 2, "", "-256,-512,248", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768turn.mdl", "#", "#", 1, "", "768,384,120"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768turn.mdl", "#", "#", 2, "", "-384,-768,120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768turn_tall.mdl", "#", "#", 1, "", "768,384,248"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_768turn_tall.mdl", "#", "#", 2, "", "-384,-768,248", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_1024turn.mdl", "#", "#", 1, "", "1024,512,120"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_1024turn.mdl", "#", "#", 2, "", "-512,-1024,120", "0,-90,0"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_1024turn_tall.mdl", "#", "#", 1, "", "1024,512,248"})
  PIECES:Record({"models/propper/dingles_modular_streets/highway_street_1024turn_tall.mdl", "#", "#", 2, "", "-512,-1024,248", "0,-90,0"})
  asmlib.Categorize("Scene Builder", [[function(m)
    local g = m:gsub("models/scene_building/","")
    local r = g:gsub("/.+$",""); return r end]])
  PIECES:Record({"models/scene_building/sewer_system/arch_small_hall.mdl", "#", "#", 1, "", "0, 47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_small_hall.mdl", "#", "#", 2, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_small_hall_med.mdl", "#", "#", 1, "", "0, 23,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_small_hall_med.mdl", "#", "#", 2, "", "0,-23,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_small_hall_small.mdl", "#", "#", 1, "", "0, 11,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_small_hall_small.mdl", "#", "#", 2, "", "0,-11,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_hall_corner.mdl", "#", "#", 1, "", "0,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_hall_corner.mdl", "#", "#", 2, "", "47,0,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_hall_3way.mdl", "#", "#", 1, "", "0,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_hall_3way.mdl", "#", "#", 2, "", "47,0,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_hall_3way.mdl", "#", "#", 3, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_hall_4way.mdl", "#", "#", 1, "", "0,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_hall_4way.mdl", "#", "#", 2, "", "47,0,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_hall_4way.mdl", "#", "#", 3, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_hall_4way.mdl", "#", "#", 4, "", "-47,0,0", "0,-180,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_small_door1.mdl", "#", "#", 1, "", "0, 47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_small_door1.mdl", "#", "#", 2, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_small_door2.mdl", "#", "#", 1, "", "0, 47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/arch_small_door2.mdl", "#", "#", 2, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/beam_door.mdl", "#", "#", 1, "", "0, 6,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/beam_door.mdl", "#", "#", 2, "", "0,-6,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/beam_hall.mdl", "#", "#", 1, "", "0, 45,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/beam_hall.mdl", "#", "#", 2, "", "0,-45,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/beam_hall_sky.mdl", "#", "#", 1, "", "0, 44,-10", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/beam_hall_sky.mdl", "#", "#", 2, "", "0,-44,-10", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/beam_hall_sky_dip.mdl", "#", "#", 1, "", "0, 44,4", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/beam_hall_sky_dip.mdl", "#", "#", 2, "", "0,-44,4", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/comp_roundroom.mdl", "#", "#", 1, "", "-20,128,-26", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/comp_roundroom.mdl", "#", "#", 2, "", "-94,-28, 14", "0,-180,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_1door_med.mdl", "#", "#", 1, "", "0, 15,0", "0, 90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_1door_med.mdl", "#", "#", 2, "", "0,-15,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_2door.mdl", "#", "#", 1, "", "145,0,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_2door.mdl", "#", "#", 2, "", "0,-175,-20", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_2door.mdl", "#", "#", 3, "", "-145,0,0", "0,-180,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_2door.mdl", "#", "#", 4, "", "0,175,-20", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_2sec.mdl", "#", "#", 1, "", "171,28,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_2sec.mdl", "#", "#", 2, "", "-28,-171,0","0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_3sec.mdl", "#", "#", 1, "", "0,-172,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_3sec.mdl", "#", "#", 2, "", "-200,28,0", "0,-180,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_3sec.mdl", "#", "#", 3, "", "200,28,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_big_bend.mdl", "#", "#", 1, "", "8.2,-121,-4", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_big_bend.mdl", "#", "#", 2, "", "-49.604,18.618,-4", "0,135,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_door.mdl", "#", "#", 1, "", "-145,0,0", "0,-180,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_door.mdl", "#", "#", 2, "", "0,175,-20", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_door.mdl", "#", "#", 3, "", "0,-175,-20", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_ent.mdl", "#", "#", 1, "", "0, 59,-16", "0, 90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_ent.mdl", "#", "#", 2, "", "0,-59,-20", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_ent_gate.mdl", "#", "#", 1, "", "0, 59,-16", "0, 90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_ent_gate.mdl", "#", "#", 2, "", "0,-59,-20", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_short.mdl", "#", "#", 1, "", "0, 31,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_short.mdl", "#", "#", 2, "", "0,-31,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_mid.mdl", "#", "#", 1, "", "0, 63,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_mid.mdl", "#", "#", 2, "", "0,-63,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_long.mdl", "#", "#", 1, "", "0, 115,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_long.mdl", "#", "#", 2, "", "0,-115,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_2sec.mdl", "#", "#", 1, "", "91,24.5,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_2sec.mdl", "#", "#", 2, "", "-24,-91,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_bend.mdl", "#", "#", 1, "", "91,27.015,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_bend.mdl", "#", "#", 2, "", "-27,-91,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_3sec.mdl", "#", "#", 1, "", "112,24.4982,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_3sec.mdl", "#", "#", 2, "", "-2.80149,-90,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_3sec.mdl", "#", "#", 3, "", "-112,24.362,0", "0,-180,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_bend_half.mdl", "#", "#", 1, "", "24.6314,19.6809,0", "0,45,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_pipe_bend_half.mdl", "#", "#", 2, "", "-6.55228,-65.1073,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_straight.mdl", "#", "#", 1, "", "0, 95,0", "0,90,0"})
  PIECES:Record({"models/scene_building/sewer_system/tunnel_straight.mdl", "#", "#", 2, "", "0,-95,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_1door.mdl", "#", "#", 1, "", "0,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_1door.mdl", "#", "#", 2, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_1door_side.mdl", "#", "#", 1, "", "0,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_1door_side.mdl", "#", "#", 2, "", "-43,0,0", "0,180,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_1door_side.mdl", "#", "#", 3, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_1door_sml.mdl", "#", "#", 1, "", "0,5,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_1door_sml.mdl", "#", "#", 2, "", "0,-5,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_l.mdl", "#", "#", 1, "", "43,-4,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_l.mdl", "#", "#", 2, "", "0, 47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_l.mdl", "#", "#", 3, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_opp.mdl", "#", "#", 1, "", "0, 47,0", "0, 90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_opp.mdl", "#", "#", 2, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_opp_small.mdl", "#", "#", 1, "", "0, 31,0", "0, 90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_opp_small.mdl", "#", "#", 2, "", "0,-31,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_r.mdl", "#", "#", 1, "", "0,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_r.mdl", "#", "#", 2, "", "-43,-4,0", "0,180,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_r.mdl", "#", "#", 3, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_side.mdl", "#", "#", 1, "", "43,0,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_side.mdl", "#", "#", 2, "", "0,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_side.mdl", "#", "#", 3, "", "-43,0,0", "0,180,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_2door_side.mdl", "#", "#", 4, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_3door.mdl", "#", "#", 1, "", "43,-4,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_3door.mdl", "#", "#", 2, "", "0,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_3door.mdl", "#", "#", 3, "", "-43,-4,0","0,180,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_3door.mdl", "#", "#", 4, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector.mdl", "#", "#", 1, "", "0, 47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector.mdl", "#", "#", 2, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_3way.mdl", "#", "#", 1, "", "2,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_3way.mdl", "#", "#", 2, "", "-45,0,0", "0,-180,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_3way.mdl", "#", "#", 3, "", "2,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_4way.mdl", "#", "#", 1, "", "47,0,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_4way.mdl", "#", "#", 2, "", "0,47,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_4way.mdl", "#", "#", 3, "", "-47,0,0", "0,-180,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_4way.mdl", "#", "#", 4, "", "0,-47,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_corner.mdl", "#", "#", 1, "", "-45,2,0", "0,180,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_corner.mdl", "#", "#", 2, "", "2,-45,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_hallways/hall_connector_deadend.mdl", "#", "#", 1, "", "0,-45,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/1door.mdl", "#", "#", 1, "", "0,123,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/1door_l.mdl", "#", "#", 1, "", "-64,123,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/1door_r.mdl", "#", "#", 1, "", "64,123,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp.mdl", "#", "#", 1, "", "-64,123,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp.mdl", "#", "#", 2, "", "-64,-123,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp_l.mdl", "#", "#", 1, "", "-64,123,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp_l.mdl", "#", "#", 2, "", "64,-123,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp_ml.mdl", "#", "#", 1, "", "-64,123,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp_ml.mdl", "#", "#", 2, "", "0,-123,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp_mr.mdl", "#", "#", 1, "", "64,123,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp_mr.mdl", "#", "#", 2, "", "0,-123,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp_r.mdl", "#", "#", 1, "", "64,123,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opp_r.mdl", "#", "#", 2, "", "-64,-123,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opposites.mdl", "#", "#", 1, "", "0,123,0", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_opposites.mdl", "#", "#", 2, "", "0,-123,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_sides.mdl", "#", "#", 1, "", "123,0,0"})
  PIECES:Record({"models/scene_building/small_rooms/2door_sides.mdl", "#", "#", 2, "", "0,-123,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/3door.mdl", "#", "#", 1, "", "123,0,0"})
  PIECES:Record({"models/scene_building/small_rooms/3door.mdl", "#", "#", 2, "", "0, 123,0", "0, 90,0"})
  PIECES:Record({"models/scene_building/small_rooms/3door.mdl", "#", "#", 3, "", "0,-123,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/4door.mdl", "#", "#", 1, "", "123,0,0"})
  PIECES:Record({"models/scene_building/small_rooms/4door.mdl", "#", "#", 2, "", "0, 123,0", "0, 90,0"})
  PIECES:Record({"models/scene_building/small_rooms/4door.mdl", "#", "#", 3, "", "-123,0,0", "0,180,0"})
  PIECES:Record({"models/scene_building/small_rooms/4door.mdl", "#", "#", 4, "", "0,-123,0", "0,-90,0"})
  PIECES:Record({"models/scene_building/small_rooms/stairs_straight.mdl", "#", "#", 1, "", "0,163,64", "0,90,0"})
  PIECES:Record({"models/scene_building/small_rooms/stairs_straight.mdl", "#", "#", 2, "", "0,-163,-64", "0,-90,0"})
  asmlib.Categorize("Modular Dungeons",[[function(m)
    local g = m:gsub("models/coldsaturnight/dungeons/","")
    local r, n = g:gsub("%.mdl",""):lower(), nil
    if(r:find("^combine")) then
      n = r:gsub("^combine", ""); r = "combine"
    else r, n = nil, nil end; return r, n end]])
  PIECES:Record({"models/coldsaturnight/dungeons/combinearmory.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridor.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridor.mdl", "#", "#", 2, "", "-256,0,80", "0,180,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridorend.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridorcross.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridorcross.mdl", "#", "#", 2, "", "0,256,80", "0,90,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridorcross.mdl", "#", "#", 3, "", "-256,0,80", "0,-180,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridorcross.mdl", "#", "#", 4, "", "0,-256,80", "0,-90,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridort.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridort.mdl", "#", "#", 2, "", "-256,0,80", "0,-180,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridort.mdl", "#", "#", 3, "", "0,-256,80", "0,-90,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridorturn.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinecorridorturn.mdl", "#", "#", 2, "", "0,-256,80", "0,-90,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineentry.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineentry.mdl", "#", "#", 2, "", "0,256,80", "0,90,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineentry.mdl", "#", "#", 3, "", "-256,0,80", "0,180,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineentry.mdl", "#", "#", 4, "", "0,-256,80", "0,-90,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineladder.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineladder.mdl", "#", "#", 2, "", "-256,0,336", "0,180,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineroom.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineroom.mdl", "#", "#", 2, "", "-256,0,80", "0,180,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineroom.mdl", "#", "#", 3, "", "0,-256,80", "0,-90,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineroomend.mdl", "#", "#", 1, "", "0,-256,80", "0,90,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineroomend.mdl", "#", "#", 2, "", "0,-256,80", "0,-90,0"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineshaft.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combineshaftend.mdl", "#", "#", 1, "", "256,0,80"})
  PIECES:Record({"models/coldsaturnight/dungeons/combinestart.mdl", "#", "#", 1, "", "256,0,80"})
  if(gsMoDB == "SQL") then sqlCommit() end
end

if(fileExists(gsGenerDSV.."PHYSPROPERTIES.txt", "DATA")) then
  asmlib.LogInstance("DB PHYSPROPERTIES from GENERIC",gtInitLogs)
  asmlib.ImportDSV("PHYSPROPERTIES", true, gsGenerPrf)
else --- Valve's physical properties: https://developer.valvesoftware.com/wiki/Material_surface_properties
  if(gsMoDB == "SQL") then sqlBegin() end
  asmlib.LogInstance("DB PHYSPROPERTIES from LUA",gtInitLogs)
  local PHYSPROPERTIES = asmlib.GetBuilderNick("PHYSPROPERTIES"); asmlib.ModelToNameRule("CLR")
  asmlib.Categorize("Concrete")
  PHYSPROPERTIES:Record({"#", 1 , "brick"          })
  PHYSPROPERTIES:Record({"#", 2 , "concrete"       })
  PHYSPROPERTIES:Record({"#", 3 , "concrete_block" })
  PHYSPROPERTIES:Record({"#", 4 , "gravel"         })
  PHYSPROPERTIES:Record({"#", 5 , "rock"           })
  asmlib.Categorize("Frozen")
  PHYSPROPERTIES:Record({"#", 1 , "snow"      })
  PHYSPROPERTIES:Record({"#", 2 , "ice"       })
  PHYSPROPERTIES:Record({"#", 3 , "gmod_ice"  })
  asmlib.Categorize("Liquid")
  PHYSPROPERTIES:Record({"#", 1 , "slime" })
  PHYSPROPERTIES:Record({"#", 2 , "water" })
  PHYSPROPERTIES:Record({"#", 3 , "wade"  })
  asmlib.Categorize("Manufactured")
  PHYSPROPERTIES:Record({"#", 1 , "jeeptire"                })
  PHYSPROPERTIES:Record({"#", 2 , "jalopytire"              })
  PHYSPROPERTIES:Record({"#", 3 , "rubber"                  })
  PHYSPROPERTIES:Record({"#", 4 , "rubbertire"              })
  PHYSPROPERTIES:Record({"#", 5 , "slidingrubbertire"       })
  PHYSPROPERTIES:Record({"#", 6 , "slidingrubbertire_front" })
  PHYSPROPERTIES:Record({"#", 7 , "slidingrubbertire_rear"  })
  PHYSPROPERTIES:Record({"#", 8 , "brakingrubbertire"       })
  PHYSPROPERTIES:Record({"#", 9 , "tile"                    })
  PHYSPROPERTIES:Record({"#", 10, "paper"                   })
  PHYSPROPERTIES:Record({"#", 11, "papercup"                })
  PHYSPROPERTIES:Record({"#", 12, "cardboard"               })
  PHYSPROPERTIES:Record({"#", 13, "plaster"                 })
  PHYSPROPERTIES:Record({"#", 14, "plastic_barrel"          })
  PHYSPROPERTIES:Record({"#", 15, "plastic_barrel_buoyant"  })
  PHYSPROPERTIES:Record({"#", 16, "Plastic_Box"             })
  PHYSPROPERTIES:Record({"#", 17, "plastic"                 })
  PHYSPROPERTIES:Record({"#", 18, "glass"                   })
  PHYSPROPERTIES:Record({"#", 19, "glassbottle"             })
  PHYSPROPERTIES:Record({"#", 20, "combine_glass"           })
  asmlib.Categorize("Metal")
  PHYSPROPERTIES:Record({"#", 1 , "canister"              })
  PHYSPROPERTIES:Record({"#", 2 , "chain"                 })
  PHYSPROPERTIES:Record({"#", 3 , "chainlink"             })
  PHYSPROPERTIES:Record({"#", 4 , "combine_metal"         })
  PHYSPROPERTIES:Record({"#", 5 , "crowbar"               })
  PHYSPROPERTIES:Record({"#", 6 , "floating_metal_barrel" })
  PHYSPROPERTIES:Record({"#", 7 , "grenade"               })
  PHYSPROPERTIES:Record({"#", 8 , "gunship"               })
  PHYSPROPERTIES:Record({"#", 9 , "metal"                 })
  PHYSPROPERTIES:Record({"#", 10, "metal_barrel"          })
  PHYSPROPERTIES:Record({"#", 11, "metal_bouncy"          })
  PHYSPROPERTIES:Record({"#", 12, "Metal_Box"             })
  PHYSPROPERTIES:Record({"#", 13, "metal_seafloorcar"     })
  PHYSPROPERTIES:Record({"#", 14, "metalgrate"            })
  PHYSPROPERTIES:Record({"#", 15, "metalpanel"            })
  PHYSPROPERTIES:Record({"#", 16, "metalvent"             })
  PHYSPROPERTIES:Record({"#", 17, "metalvehicle"          })
  PHYSPROPERTIES:Record({"#", 18, "paintcan"              })
  PHYSPROPERTIES:Record({"#", 19, "popcan"                })
  PHYSPROPERTIES:Record({"#", 20, "roller"                })
  PHYSPROPERTIES:Record({"#", 21, "slipperymetal"         })
  PHYSPROPERTIES:Record({"#", 22, "solidmetal"            })
  PHYSPROPERTIES:Record({"#", 23, "strider"               })
  PHYSPROPERTIES:Record({"#", 24, "weapon"                })
  asmlib.Categorize("Miscellaneous")
  PHYSPROPERTIES:Record({"#", 1 , "carpet"       })
  PHYSPROPERTIES:Record({"#", 2 , "ceiling_tile" })
  PHYSPROPERTIES:Record({"#", 3 , "computer"     })
  PHYSPROPERTIES:Record({"#", 4 , "pottery"      })
  asmlib.Categorize("Organic")
  PHYSPROPERTIES:Record({"#", 1 , "alienflesh"  })
  PHYSPROPERTIES:Record({"#", 2 , "antlion"     })
  PHYSPROPERTIES:Record({"#", 3 , "armorflesh"  })
  PHYSPROPERTIES:Record({"#", 4 , "bloodyflesh" })
  PHYSPROPERTIES:Record({"#", 5 , "flesh"       })
  PHYSPROPERTIES:Record({"#", 6 , "foliage"     })
  PHYSPROPERTIES:Record({"#", 7 , "watermelon"  })
  PHYSPROPERTIES:Record({"#", 8 , "zombieflesh" })
  asmlib.Categorize("Special")
  PHYSPROPERTIES:Record({"#", 1 , "default"             })
  PHYSPROPERTIES:Record({"#", 2 , "default_silent"      })
  PHYSPROPERTIES:Record({"#", 3 , "floatingstandable"   })
  PHYSPROPERTIES:Record({"#", 4 , "item"                })
  PHYSPROPERTIES:Record({"#", 5 , "ladder"              })
  PHYSPROPERTIES:Record({"#", 6 , "no_decal"            })
  PHYSPROPERTIES:Record({"#", 7 , "player"              })
  PHYSPROPERTIES:Record({"#", 8 , "player_control_clip" })
  asmlib.Categorize("Terrain")
  PHYSPROPERTIES:Record({"#", 1 , "dirt"          })
  PHYSPROPERTIES:Record({"#", 2 , "grass"         })
  PHYSPROPERTIES:Record({"#", 3 , "gravel"        })
  PHYSPROPERTIES:Record({"#", 4 , "mud"           })
  PHYSPROPERTIES:Record({"#", 5 , "quicksand"     })
  PHYSPROPERTIES:Record({"#", 6 , "sand"          })
  PHYSPROPERTIES:Record({"#", 7 , "slipperyslime" })
  PHYSPROPERTIES:Record({"#", 8 , "antlionsand"   })
  asmlib.Categorize("Wood")
  PHYSPROPERTIES:Record({"#", 1 , "wood"          })
  PHYSPROPERTIES:Record({"#", 2 , "Wood_Box"      })
  PHYSPROPERTIES:Record({"#", 3 , "Wood_Furniture"})
  PHYSPROPERTIES:Record({"#", 4 , "Wood_Plank"    })
  PHYSPROPERTIES:Record({"#", 5 , "Wood_Panel"    })
  PHYSPROPERTIES:Record({"#", 6 , "Wood_Solid"    })
  if(gsMoDB == "SQL") then sqlCommit() end
end

if(fileExists(gsGenerDSV.."ADDITIONS.txt", "DATA")) then
  asmlib.LogInstance("DB ADDITIONS from GENERIC",gtInitLogs)
  asmlib.ImportDSV("ADDITIONS", true, gsGenerPrf)
else
  if(gsMoDB == "SQL") then sqlBegin() end
  asmlib.LogInstance("DB ADDITIONS from LUA",gtInitLogs)
  local ADDITIONS = asmlib.GetBuilderNick("ADDITIONS"); asmlib.ModelToNameRule("CLR")
  if(gsMoDB == "SQL") then sqlCommit() end
end

asmlib.LogInstance("Version: "..asmlib.GetOpVar("TOOL_VERSION"), gtInitLogs)
collectgarbage()
