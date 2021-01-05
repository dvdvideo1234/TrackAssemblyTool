------------ INCLUDE LIBRARY ------------
if(SERVER) then
  AddCSLuaFile("trackassembly/trackasmlib.lua")
end
include("trackassembly/trackasmlib.lua")

------------ LOCALIZNG FUNCTIONS ------------

local pcall                         = pcall
local Angle                         = Angle
local Vector                        = Vector
local IsValid                       = IsValid
local tobool                        = tobool
local tonumber                      = tonumber
local tostring                      = tostring
local CreateConVar                  = CreateConVar
local SetClipboardText              = SetClipboardText
local osDate                        = os and os.date
local netStart                      = net and net.Start
local netSendToServer               = net and net.SendToServer
local netReceive                    = net and net.Receive
local netReadEntity                 = net and net.ReadEntity
local netReadVector                 = net and net.ReadVector
local netReadString                 = net and net.ReadString
local netReadUInt                   = net and net.ReadUInt
local netWriteString                = net and net.WriteString
local netWriteEntity                = net and net.WriteEntity
local netWriteUInt                  = net and net.WriteUInt
local bitBor                        = bit and bit.bor
local sqlQuery                      = sql and sql.Query
local sqlBegin                      = sql and sql.Begin
local sqlCommit                     = sql and sql.Commit
local guiMouseX                     = gui and gui.MouseX
local guiMouseY                     = gui and gui.MouseY
local guiOpenURL                    = gui and gui.OpenURL
local guiEnableScreenClicker        = gui and gui.EnableScreenClicker
local entsGetByIndex                = ents and ents.GetByIndex
local mathFloor                     = math and math.floor
local mathClamp                     = math and math.Clamp
local mathRound                     = math and math.Round
local mathMin                       = math and math.min
local mathHuge                      = math and math.huge
local gameGetWorld                  = game and game.GetWorld
local tableConcat                   = table and table.concat
local tableRemove                   = table and table.remove
local tableEmpty                    = table and table.Empty
local tableInsert                   = table and table.insert
local mathAbs                       = math and math.abs
local utilAddNetworkString          = util and util.AddNetworkString
local utilIsValidModel              = util and util.IsValidModel
local vguiCreate                    = vgui and vgui.Create
local fileExists                    = file and file.Exists
local fileFind                      = file and file.Find
local fileWrite                     = file and file.Write
local fileDelete                    = file and file.Delete
local fileTime                      = file and file.Time
local fileSize                      = file and file.Size
local fileOpen                      = file and file.Open
local hookAdd                       = hook and hook.Add
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
local propertiesAdd                 = properties and properties.Add
local propertiesGetHovered          = properties and properties.GetHovered
local propertiesCanBeTargeted       = properties and properties.CanBeTargeted
local constraintFindConstraints     = constraint and constraint.FindConstraints
local constraintFind                = constraint and constraint.Find
local controlpanelGet               = controlpanel and controlpanel.Get
local duplicatorStoreEntityModifier = duplicator and duplicator.StoreEntityModifier
local spawnmenuAddToolMenuOption    = spawnmenu and spawnmenu.AddToolMenuOption

------------ MODULE POINTER ------------

local asmlib     = trackasmlib
local gtArgsLogs = {"", false, 0}
local gtInitLogs = {"*Init", false, 0}

------------ CONFIGURE ASMLIB ------------

asmlib.InitBase("track","assembly")
asmlib.SetOpVar("TOOL_VERSION","8.633")
asmlib.SetIndexes("V" ,    "x",  "y",   "z")
asmlib.SetIndexes("A" ,"pitch","yaw","roll")
asmlib.SetIndexes("WV",1,2,3)
asmlib.SetIndexes("WA",1,2,3)

------------ CONFIGURE GLOBAL INIT OPVARS ------------

local gsNoID      = asmlib.GetOpVar("MISS_NOID") -- No such ID
local gsNoMD      = asmlib.GetOpVar("MISS_NOMD") -- No model
local gsSymRev    = asmlib.GetOpVar("OPSYM_REVISION")
local gsSymDir    = asmlib.GetOpVar("OPSYM_DIRECTORY")
local gsLibName   = asmlib.GetOpVar("NAME_LIBRARY")
local gnRatio     = asmlib.GetOpVar("GOLDEN_RATIO")
local gnMaxRot    = asmlib.GetOpVar("MAX_ROTATION")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")
local gsToolNameU = asmlib.GetOpVar("TOOLNAME_NU")
local gsToolPrefL = asmlib.GetOpVar("TOOLNAME_PL")
local gsToolPrefU = asmlib.GetOpVar("TOOLNAME_PU")
local gsLangForm  = asmlib.GetOpVar("FORM_LANGPATH")
local gsLimitName = asmlib.GetOpVar("CVAR_LIMITNAME")
local gtCallBack  = asmlib.GetOpVar("TABLE_CALLBACK")
local gsNoAnchor  = gsNoID..gsSymRev..gsNoMD
local gtTransFile = fileFind(gsLangForm:format("lua/", "*.lua"), "GAME")
local gsFullDSV   = asmlib.GetOpVar("DIRPATH_BAS")..asmlib.GetOpVar("DIRPATH_DSV")..
                    asmlib.GetInstPref()..asmlib.GetOpVar("TOOLNAME_PU")

------------ VARIABLE FLAGS ------------

local varLanguage = GetConVar("gmod_language")
-- Client and server have independent value
local gnIndependentUsed = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
-- Server tells the client what value to use
local gnServerControled = bitBor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY, FCVAR_REPLICATED)

------------ BORDERS ------------

asmlib.SetBorder("non-neg", 0, mathHuge)
asmlib.SetBorder("sbox_max"..gsLimitName , 0, mathHuge)
asmlib.SetBorder(gsToolPrefL.."crvturnlm", 0, 1)
asmlib.SetBorder(gsToolPrefL.."crvleanlm", 0, 1)
asmlib.SetBorder(gsToolPrefL.."curvefact", 0, 1)
asmlib.SetBorder(gsToolPrefL.."curvsmple", 0, 200)
asmlib.SetBorder(gsToolPrefL.."devmode"  , 0, 1)
asmlib.SetBorder(gsToolPrefL.."enctxmall", 0, 1)
asmlib.SetBorder(gsToolPrefL.."enctxmenu", 0, 1)
asmlib.SetBorder(gsToolPrefL.."endsvlock", 0, 1)
asmlib.SetBorder(gsToolPrefL.."enwiremod", 0, 1)
asmlib.SetBorder(gsToolPrefL.."ghostcnt" , 0, 200)
asmlib.SetBorder(gsToolPrefL.."incsnpang", 0, gnMaxRot)
asmlib.SetBorder(gsToolPrefL.."incsnplin", 0, 200)
asmlib.SetBorder(gsToolPrefL.."logfile"  , 0, 1)
asmlib.SetBorder(gsToolPrefL.."logsmax"  , 0, 100000)
asmlib.SetBorder(gsToolPrefL.."maxactrad", 1, 200)
asmlib.SetBorder(gsToolPrefL.."maxforce" , 0, 200000)
asmlib.SetBorder(gsToolPrefL.."maxfruse" , 1, 100)
asmlib.SetBorder(gsToolPrefL.."maxlinear", 0, 10000)
asmlib.SetBorder(gsToolPrefL.."maxmass"  , 1, 100000)
asmlib.SetBorder(gsToolPrefL.."maxmenupr", 0, 10)
asmlib.SetBorder(gsToolPrefL.."maxstatts", 1, 10)
asmlib.SetBorder(gsToolPrefL.."maxstcnt" , 1, 400)
asmlib.SetBorder(gsToolPrefL.."maxtrmarg", 0, 1)
asmlib.SetBorder(gsToolPrefL.."sizeucs"  , 0, 50)
asmlib.SetBorder(gsToolPrefL.."spawnrate", 1, 20)

------------ CONFIGURE LOGGING ------------

asmlib.SetOpVar("LOG_DEBUGEN",false)
asmlib.MakeAsmConvar("logsmax"  , 0 , nil, gnIndependentUsed, "Maximum logging lines being written")
asmlib.MakeAsmConvar("logfile"  , 0 , nil, gnIndependentUsed, "File logging output flag control")
asmlib.SetLogControl(asmlib.GetAsmConvar("logsmax","INT"),asmlib.GetAsmConvar("logfile","BUL"))
asmlib.SettingsLogs("SKIP"); asmlib.SettingsLogs("ONLY")

------------ CONFIGURE NON-REPLICATED CVARS ------------ Client's got a mind of its own

asmlib.MakeAsmConvar("modedb"   , "LUA", nil, gnIndependentUsed, "Database storage operating mode LUA or SQL")
asmlib.MakeAsmConvar("devmode"  ,    0 , nil, gnIndependentUsed, "Toggle developer mode on/off server side")
asmlib.MakeAsmConvar("maxtrmarg", 0.02 , nil, gnIndependentUsed, "Maximum time to avoid performing new traces")
asmlib.MakeAsmConvar("maxmenupr",    5 , nil, gnIndependentUsed, "Maximum decimal places utilized in the control panel")
asmlib.MakeAsmConvar("timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1", nil, gnIndependentUsed, "Memory management setting when DB mode is SQL")

------------ CONFIGURE REPLICATED CVARS ------------ Server tells the client what value to use

asmlib.MakeAsmConvar("maxmass"  , 50000 , nil, gnServerControled, "Maximum mass that can be applied on a piece")
asmlib.MakeAsmConvar("maxlinear", 5000  , nil, gnServerControled, "Maximum linear offset of the piece")
asmlib.MakeAsmConvar("maxforce" , 100000, nil, gnServerControled, "Maximum force limit when creating welds")
asmlib.MakeAsmConvar("maxactrad", 200   , nil, gnServerControled, "Maximum active radius to search for a point ID")
asmlib.MakeAsmConvar("maxstcnt" , 200   , nil, gnServerControled, "Maximum spawned pieces in stacking mode")
asmlib.MakeAsmConvar("enwiremod", 1     , nil, gnServerControled, "Toggle the wire extension on/off server side")
asmlib.MakeAsmConvar("enctxmenu", 1     , nil, gnServerControled, "Toggle the context menu on/off in general")
asmlib.MakeAsmConvar("enctxmall", 0     , nil, gnServerControled, "Toggle the context menu on/off for all props")
asmlib.MakeAsmConvar("endsvlock", 0     , nil, gnServerControled, "Toggle the DSV external database file update on/off")
asmlib.MakeAsmConvar("curvefact", 0.5   , nil, gnServerControled, "Parametric constant track curving factor")
asmlib.MakeAsmConvar("curvsmple", 50    , nil, gnServerControled, "Amount of samples between two curve nodes")

if(SERVER) then
  asmlib.MakeAsmConvar("spawnrate",  5  , nil, gnServerControled, "Maximum pieces spawned in every think tick")
  asmlib.MakeAsmConvar("bnderrmod","LOG", nil, gnServerControled, "Unreasonable position error handling mode")
  asmlib.MakeAsmConvar("maxfruse" ,  50 , nil, gnServerControled, "Maximum frequent pieces to be listed")
  asmlib.MakeAsmConvar("*sbox_max"..gsLimitName, 1500, nil, gnServerControled, "Maximum number of tracks to be spawned")
end

------------ CONFIGURE INTERNALS ------------

asmlib.IsFlag("new_close_frame", false) -- The old state for frame shortcut detecting a pulse
asmlib.IsFlag("old_close_frame", false) -- The new state for frame shortcut detecting a pulse
asmlib.IsFlag("tg_context_menu", false) -- Raises whenever the user opens the game context menu
asmlib.IsFlag("en_dsv_datalock", asmlib.GetAsmConvar("endsvlock", "BUL"))
asmlib.SetOpVar("MODE_DATABASE", asmlib.GetAsmConvar("modedb"   , "STR"))
asmlib.SetOpVar("TRACE_MARGIN" , asmlib.GetAsmConvar("maxtrmarg", "FLT"))

------------ GLOBAL VARIABLES ------------

local gsMoDB      = asmlib.GetOpVar("MODE_DATABASE")
local gaTimerSet  = gsSymDir:Explode(asmlib.GetAsmConvar("timermode","STR"))
local conPalette  = asmlib.GetContainer("COLORS_LIST")
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
      conWorkMode:Push("CURVE") -- Catmull–Rom spline interpolation fitting
      conWorkMode:Push("OVER" ) -- Trace normal ray location piece flip-snap

------------ CALLBACKS ------------

local conCallBack = asmlib.GetContainer("CALLBAC_FUNC")
      conCallBack:Push({"maxtrmarg", function(sVar, vOld, vNew)
        local nM = (tonumber(vNew) or 0); nM = ((nM > 0) and nM or 0)
        asmlib.SetOpVar("TRACE_MARGIN", nM)
      end})
      conCallBack:Push({"logsmax", function(sVar, vOld, vNew)
        local nM = asmlib.BorderValue((tonumber(vNew) or 0), "non-neg")
        asmlib.SetOpVar("LOG_MAXLOGS", nM)
      end})
      conCallBack:Push({"logfile", function(sVar, vOld, vNew)
        asmlib.IsFlag("en_logging_file", tobool(vNew))
      end})
      conCallBack:Push({"endsvlock", function(sVar, vOld, vNew)
        asmlib.IsFlag("en_dsv_datalock", tobool(vNew))
      end})
      conCallBack:Push({"timermode", function(sVar, vOld, vNew)
        local arTim = gsSymDir:Explode(vNew)
        local mkTab, ID = asmlib.GetBuilderID(1), 1
        while(mkTab) do local sTim = arTim[ID]
          local defTab = mkTab:GetDefinition(); mkTab:TimerSetup(sTim)
          asmlib.LogInstance("Timer apply "..asmlib.GetReport2(defTab.Nick,sTim),gtInitLogs)
          ID = ID + 1; mkTab = asmlib.GetBuilderID(ID) -- Next table on the list
        end; asmlib.LogInstance("Timer update "..asmlib.GetReport(vNew),gtInitLogs)
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
        local out = asmlib.GetReport2(iR,tableConcat(tab[iR], ","))
        scr:DrawText(fmt:format(fky:format(key), typ, out, inf))
      end
    end,
  },
  {Name = "Origin",
    {"F"   , "VEC", "Origin forward vector"},
    {"R"   , "VEC", "Origin right vector"},
    {"U"   , "VEC", "Origin up vector"},
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

  -- Send language definitions to the client to populate the menu
  for iD = 1, #gtTransFile do AddCSLuaFile(gsLangForm:format("",gtTransFile[iD])) end

  utilAddNetworkString(gsLibName.."SendIntersectClear")
  utilAddNetworkString(gsLibName.."SendIntersectRelate")
  utilAddNetworkString(gsLibName.."SendCreateCurveNode")
  utilAddNetworkString(gsLibName.."SendUpdateCurveNode")
  utilAddNetworkString(gsLibName.."SendDeleteCurveNode")
  utilAddNetworkString(gsLibName.."SendDeleteAllCurveNode")

  asmlib.SetAction("DUPE_PHYS_SETTINGS", -- Duplicator wrapper
    function(oPly,oEnt,tData) gtArgsLogs[1] = "*DUPE_PHYS_SETTINGS"
      if(not asmlib.ApplyPhysicalSettings(oEnt,tData[1],tData[2],tData[3],tData[4])) then
        asmlib.LogInstance("Failed to apply physical settings on "..tostring(oEnt),gtArgsLogs); return nil end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end)

  asmlib.SetAction("PLAYER_QUIT",
    function(oPly) gtArgsLogs[1] = "*PLAYER_QUIT" -- Clear player cache when disconnects
      if(not asmlib.CacheClear(oPly)) then
        asmlib.LogInstance("Failed swiping stuff "..tostring(oPly),gtArgsLogs); return nil end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end)

  asmlib.SetAction("PHYSGUN_DROP",
    function(pPly, trEnt) gtArgsLogs[1] = "*PHYSGUN_DROP"
      if(not asmlib.IsPlayer(pPly)) then
        asmlib.LogInstance("Player invalid",gtArgsLogs); return nil end
      if(pPly:GetInfoNum(gsToolPrefL.."engunsnap", 0) == 0) then
        asmlib.LogInstance("Snapping disabled",gtArgsLogs); return nil end
      if(not (trEnt and trEnt:IsValid())) then
        asmlib.LogInstance("Trace entity invalid",gtArgsLogs); return nil end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel()); if(not trRec) then
        asmlib.LogInstance("Trace not piece",gtArgsLogs); return nil end
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
      local activrad   = mathClamp(pPly:GetInfoNum(gsToolPrefL.."activrad", 0),1,asmlib.GetAsmConvar("maxactrad", "FLT"))
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
          if(not asmlib.SetPosBound(trEnt,stSpawn.SPos or GetOpVar("VEC_ZERO"),pPly,bnderrmod)) then
            asmlib.LogInstance("User "..pPly:Nick().." snapped <"..trRec.Slot.."> outside bounds",gtArgsLogs); return nil end
          trEnt:SetAngles(stSpawn.SAng)
          if(not asmlib.ApplyPhysicalSettings(trEnt,ignphysgn,freeze,gravity,physmater)) then
            asmlib.LogInstance("Failed to apply physical settings",gtArgsLogs); return nil end
          if(not asmlib.ApplyPhysicalAnchor(trEnt,trTr.Entity,weld,nocollide,nocollidew,forcelim)) then
            asmlib.LogInstance("Failed to apply physical anchor",gtArgsLogs); return nil end
        end
      end
    end)
end

if(CLIENT) then

  surfaceCreateFont("DebugSpawnTA",{
    font = "Courier New",
    size = 14,
    weight = 600
  })

  -- Initialize tool translations and load the lua file dedicated to the language
  asmlib.InitLocalify(varLanguage:GetString())

  -- Listen for changes to the localify language and reload the tool's menu to update the localizations
  cvarsRemoveChangeCallback(varLanguage:GetName(), gsToolPrefL.."lang")
  cvarsAddChangeCallback(varLanguage:GetName(), function(sNam, vO, vN)
    gtArgsLogs[1] = "*UPDATE_CONTROL_PANEL"; asmlib.InitLocalify(vN)
    local oTool = asmlib.GetOpVar("STORE_TOOLOBJ"); if(not asmlib.IsHere(oTool)) then
      asmlib.LogInstance("Tool object missing", gtArgsLogs); return end
    local cPanel = controlpanelGet(oTool.Mode); if(not IsValid(cPanel)) then
      asmlib.LogInstance("Control panel invalid", gtArgsLogs); return end
    cPanel:ClearControls(); oTool.BuildCPanel(cPanel) -- Rebuild the tool panel
  end, gsToolPrefL.."lang")

  -- http://www.famfamfam.com/lab/icons/silk/preview.php
  asmlib.ToIcon(gsToolPrefU.."PIECES"        , "database_connect")
  asmlib.ToIcon(gsToolPrefU.."ADDITIONS"     , "bricks"          )
  asmlib.ToIcon(gsToolPrefU.."PHYSPROPERTIES", "wand"            )
  asmlib.ToIcon(gsToolPrefL.."context_menu"  , "database_gear"   )
  asmlib.ToIcon("category_item"    , "folder"         )
  asmlib.ToIcon("pn_externdb_1"    , "database"       )
  asmlib.ToIcon("pn_externdb_2"    , "folder_database")
  asmlib.ToIcon("pn_externdb_3"    , "database_table" )
  asmlib.ToIcon("pn_externdb_4"    , "database_link"  )
  asmlib.ToIcon("pn_externdb_5"    , "time_go"        )
  asmlib.ToIcon("pn_externdb_6"    , "compress"       )
  asmlib.ToIcon("pn_externdb_7"    , "database_edit"  )
  asmlib.ToIcon("pn_externdb_8"    , "database_delete")
  asmlib.ToIcon("model"            , "brick"          )
  asmlib.ToIcon("mass"             , "basket_put"     )
  asmlib.ToIcon("bgskids"          , "layers"         )
  asmlib.ToIcon("phyname"          , "wand"           )
  asmlib.ToIcon("ignphysgn"        , "lightning_go"   )
  asmlib.ToIcon("freeze"           , "lock"           )
  asmlib.ToIcon("gravity"          , "ruby_put"       )
  asmlib.ToIcon("weld"             , "wrench"         )
  asmlib.ToIcon("nocollide"        , "shape_group"    )
  asmlib.ToIcon("nocollidew"       , "world_go"       )
  asmlib.ToIcon("dsvlist_extdb"    , "database_go"    )
  asmlib.ToIcon("workmode_snap"    , "plugin"         ) -- General spawning and snapping mode
  asmlib.ToIcon("workmode_cross"   , "chart_line"     ) -- Ray cross intersect interpolation
  asmlib.ToIcon("workmode_curve"   , "vector"         ) -- Catmull–Rom curve line segment fitting
  asmlib.ToIcon("workmode_over"    , "shape_move_back") -- Trace normal ray location piece flip-spawn
  asmlib.ToIcon("property_type"    , "package_green"  )
  asmlib.ToIcon("property_name"    , "note"           )
  asmlib.ToIcon("database_mode_lua", "database_lightning")
  asmlib.ToIcon("database_mode_sql", "database_link"     )
  asmlib.ToIcon("timermode_cqt"    , "time_go"           )
  asmlib.ToIcon("timermode_obj"    , "clock_go"          )
  asmlib.ToIcon("bnderrmod_off"    , "shape_square"      )
  asmlib.ToIcon("bnderrmod_log"    , "shape_square_edit" )
  asmlib.ToIcon("bnderrmod_hint"   , "shape_square_go"   )
  asmlib.ToIcon("bnderrmod_generic", "shape_square_link" )
  asmlib.ToIcon("bnderrmod_error"  , "shape_square_error")

  -- Workshop matching crap
  asmlib.WorkshopID("SligWolf's Rerailers"        , 132843280)
  asmlib.WorkshopID("SligWolf's Minitrains"       , 149759773)
  asmlib.WorkshopID("SProps"                      , 173482196)
  asmlib.WorkshopID("Magnum's Rails"              , 290130567)
  asmlib.WorkshopID("SligWolf's Railcar"          , 173717507)
  asmlib.WorkshopID("Random Bridges"              , 343061215)
  asmlib.WorkshopID("StevenTechno's Buildings 1.0", 331192490)
  asmlib.WorkshopID("Mr.Train's M-Gauge"          , 517442747)
  asmlib.WorkshopID("Mr.Train's G-Gauge"          , 590574800)
  asmlib.WorkshopID("Bobster's two feet rails"    , 489114511)
  asmlib.WorkshopID("G Scale Track Pack"          , 718239260)
  asmlib.WorkshopID("Ron's Minitrain Props"       , 728833183)
  asmlib.WorkshopID("SligWolf's White Rails"      , 147812851)
  asmlib.WorkshopID("SligWolf's Minihover"        , 147812851)
  asmlib.WorkshopID("Battleship's abandoned rails", 807162936)
  asmlib.WorkshopID("AlexCookie's 2ft track pack" , 740453553)
  asmlib.WorkshopID("Joe's track pack"            , 1658816805)
  asmlib.WorkshopID("StevenTechno's Buildings 2.0", 1888013789)
  asmlib.WorkshopID("Modular canals"              , 1336622735)
  asmlib.WorkshopID("Trackmania United Props"     , 1955876643)

  asmlib.SetAction("CTXMENU_OPEN" , function() asmlib.IsFlag("tg_context_menu", true ) end)
  asmlib.SetAction("CTXMENU_CLOSE", function() asmlib.IsFlag("tg_context_menu", false) end)

  asmlib.SetAction("CREATE_CURVE_NODE",
    function(nLen) local oPly = netReadEntity(); gtArgsLogs[1] = "*DELETE_CURVE_NODE"
      local vNode, vNorm, vBase = netReadVector(), netReadVector(), netReadVector()
      local tC = asmlib.GetCacheCurve(oPly) -- Read the curve data location
      tableInsert(tC.Node, vNode); tableInsert(tC.Norm, vNorm); tableInsert(tC.Base, vBase);
      tC.Size = (tC.Size + 1) -- Register the index after writing the data for drawing
    end)

  asmlib.SetAction("UPDATE_CURVE_NODE",
    function(nLen) local oPly = netReadEntity(); gtArgsLogs[1] = "*UPDATE_CURVE_NODE"
      local vNode, vNorm, vBase = netReadVector(), netReadVector(), netReadVector()
      local iD, tC = netReadUInt(16), asmlib.GetCacheCurve(oPly)
      tC.Node[iD]:Set(vNode); tC.Norm[iD]:Set(vNorm); tC.Base[iD]:Set(vBase)
    end)

  asmlib.SetAction("DELETE_CURVE_NODE",
    function(nLen) local oPly = netReadEntity(); gtArgsLogs[1] = "*DELETE_CURVE_NODE"
      local tC = asmlib.GetCacheCurve(oPly)
      tC.Size = (tC.Size - 1) -- Register the index before wiping the data for drawing
      tableRemove(tC.Node); tableRemove(tC.Norm); tableRemove(tC.Base)
    end)

  asmlib.SetAction("DELETE_ALL_CURVE_NODE",
    function(nLen) local oPly = netReadEntity(); gtArgsLogs[1] = "*DELETE_ALL_CURVE_NODE"
      local tC = asmlib.GetCacheCurve(oPly)
      if(tC.Size and tC.Size > 0) then
        tableEmpty(tC.Node); tableEmpty(tC.Norm); tableEmpty(tC.Base)
        tC.Size = 0 -- Register the index before wiping the data for drawing
      end
    end)

  asmlib.SetAction("CLEAR_RELATION",
    function(nLen) local oPly = netReadEntity(); gtArgsLogs[1] = "*CLEAR_RELATION"
      asmlib.LogInstance("{"..tostring(nLen)..","..tostring(oPly).."}",gtArgsLogs)
      if(not asmlib.IntersectRayClear(oPly, "relate")) then
        asmlib.LogInstance("Failed clearing ray",gtArgsLogs); return nil end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end) -- Net receive intersect relation clear client-side

  asmlib.SetAction("CREATE_RELATION",
    function(nLen) gtArgsLogs[1] = "*CREATE_RELATION"
      local oEnt, vHit, oPly = netReadEntity(), netReadVector(), netReadEntity()
      asmlib.LogInstance("{"..tostring(nLen)..","..tostring(oPly).."}",gtArgsLogs)
      if(not asmlib.IntersectRayCreate(oPly, oEnt, vHit, "relate")) then
        asmlib.LogInstance("Failed updating ray",gtArgsLogs); return nil end
      asmlib.LogInstance("Success",gtArgsLogs); return nil
    end) -- Net receive intersect relation create client-side

  asmlib.SetAction("BIND_PRESS", -- Must have the same parameters as the hook
    function(oPly,sBind,bPress) gtArgsLogs[1] = "*BIND_PRESS"
      local oPly, actSwep, actTool = asmlib.GetHookInfo(gtArgsLogs)
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",gtArgsLogs); return nil end
      if(((sBind == "invnext") or (sBind == "invprev")) and bPress) then
        -- Switch functionality of the mouse wheel only for TA
        if(not inputIsKeyDown(KEY_LALT)) then
          asmlib.LogInstance("Active key missing",gtArgsLogs); return nil end
        if(not actTool:GetScrollMouse()) then
          asmlib.LogInstance("(SCROLL) Scrolling disabled",gtArgsLogs); return nil end
        local nDir = ((sBind == "invnext") and -1) or ((sBind == "invprev") and 1) or 0
        actTool:SwitchPoint(nDir,inputIsKeyDown(KEY_LSHIFT))
        asmlib.LogInstance("("..sBind..") Processed",gtArgsLogs); return true
      elseif((sBind == "+zoom") and bPress) then -- Work mode radial menu selection
        if(inputIsMouseDown(MOUSE_MIDDLE)) then -- Reserve the mouse middle for radial menu
          if(not actTool:GetRadialMenu()) then -- Zoom is bind on the middle mouse button
            asmlib.LogInstance("("..sBind..") Menu disabled",gtArgsLogs); return nil end
          asmlib.LogInstance("("..sBind..") Processed",gtArgsLogs); return true
        end; return nil -- Need to disable the zoom when bind on the mouse middle
      end -- Override only for TA and skip touching anything else
      asmlib.LogInstance("("..sBind..") Skipped",gtArgsLogs); return nil
    end) -- Read client configuration

  asmlib.SetAction("DRAW_RADMENU", -- Must have the same parameters as the hook
    function() gtArgsLogs[1] = "*DRAW_RADMENU"
      local oPly, actSwep, actTool = asmlib.GetHookInfo(gtArgsLogs)
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",gtArgsLogs) return nil end
      if(not actTool:GetRadialMenu()) then
        asmlib.LogInstance("Menu disabled",gtArgsLogs); return nil end
      if(inputIsMouseDown(MOUSE_MIDDLE)) then guiEnableScreenClicker(true) else
        guiEnableScreenClicker(false); asmlib.LogInstance("Release",gtArgsLogs); return nil
      end -- Draw while holding the mouse middle button
      local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
      local actMonitor = asmlib.GetScreen(0,0,scrW,scrH,conPalette,"GAME")
      if(not actMonitor) then asmlib.LogInstance("Screen invalid",gtArgsLogs); return nil end
      local nR, nN = (mathMin(scrW, scrH) / (2 * gnRatio)), conWorkMode:GetSize()
      local mXY = asmlib.NewXY(guiMouseX(), guiMouseY())
      local vCn = asmlib.NewXY(mathFloor(scrW/2), mathFloor(scrH/2))
      local nDr, sM = asmlib.GetOpVar("DEG_RAD"), asmlib.GetOpVar("MISS_NOAV")
      local nMx = (asmlib.GetOpVar("MAX_ROTATION") * nDr) -- Max angle [2pi]
      local vA, vB, nD = asmlib.NewXY(), asmlib.NewXY(), (nR / gnRatio)
      local tP = {asmlib.NewXY(), asmlib.NewXY(), asmlib.NewXY(), asmlib.NewXY()}
      local vF, vN = asmlib.NewXY(nR, 0), asmlib.NewXY(mathClamp(nR - nD, 0, nR), 0)
      asmlib.NegY(asmlib.SubXY(vA, mXY, vCn)) -- Obtain selection wiper vector
      local aW = asmlib.GetAngleXY(vA) -- Read wiper angle and normalize
            aW = ((aW < 0) and (aW + nMx) or aW) -- Convert [0;+pi;-pi;0] to [0;2pi]
      local iW = mathFloor(((aW / nMx) * nN) + 1) -- Calculate fraction ID for working mode
      local dA = (nMx / (2 * nN)) -- Two times smaller step to hangle centers as well
      asmlib.SetXY(vA, vF); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[4], vA)
      asmlib.SetXY(vA, vN); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[3], vA)
      for iD = 1, nN do
        asmlib.SetXY(tP[1], tP[4]); asmlib.SetXY(tP[2], tP[3])
        local sW = tostring(conWorkMode:Select(iD) or sM) -- Read selection name
        local sC = ((iW == iD) and "pf" or "pb") -- Change color for selected option
        -- Draw polygon segment using triangles with the same color and array of vertices
        asmlib.RotateXY(vN, 2 * dA); asmlib.RotateXY(vF, 2 * dA) -- Go to the next base line
        asmlib.SetXY(vA, vF); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[4], vA)
        asmlib.SetXY(vA, vN); asmlib.NegY(vA); asmlib.AddXY(vA, vA, vCn); asmlib.SetXY(tP[3], vA)
        actMonitor:DrawPoly(tP, sC, "SURF", {"vgui/white"}) -- Draw textured polygon
        -- Draw working mode name by placing centered text and the polygon midpoint
        asmlib.MidXY(vA, tP[1], tP[2]); asmlib.MidXY(vB, tP[3], tP[4]); asmlib.MidXY(vA, vA, vB)
        actMonitor:SetTextStart(vA.x, vA.y):DrawText(sW, "k", "SURF", {"Trebuchet24", true})
      end; asmlib.SetAsmConvar(oPly, "workmode", iW); return true
    end)

  asmlib.SetAction("DRAW_GHOSTS", -- Must have the same parameters as the hook
    function() gtArgsLogs[1] = "*DRAW_GHOSTS"
      local oPly, actSwep, actTool = asmlib.GetHookInfo(gtArgsLogs)
      if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Hook mismatch",gtArgsLogs); return nil end
      local model = actTool:GetModel()
      local ghcnt = actTool:GetGhostsDepth()
      local atGho = asmlib.GetOpVar("ARRAY_GHOST")
      if(utilIsValidModel(model)) then
        if(not (asmlib.HasGhosts() and ghcnt == atGho.Size and atGho.Slot == model)) then
          if(not asmlib.MakeGhosts(ghcnt, model)) then
            asmlib.LogInstance("Ghosting fail",gtArgsLogs); return nil end
          actTool:ElevateGhost(atGho[1], oPly) -- Elevate the properly created ghost
        end; actTool:UpdateGhost(oPly) -- Update ghosts stack for the local player
      end
    end) -- Read client configuration

  asmlib.SetAction("OPEN_EXTERNDB", -- Must have the same parameters as the hook
    function(oPly,oCom,oArgs) gtArgsLogs[1] = "*OPEN_EXTERNDB"
      local scrW = surfaceScreenWidth()
      local scrH = surfaceScreenHeight()
      local sVer = asmlib.GetOpVar("TOOL_VERSION")
      local xyPos, nAut  = asmlib.NewXY(scrW/4,scrH/4), (gnRatio - 1)
      local xyDsz, xyTmp = asmlib.NewXY(5,5), asmlib.NewXY()
      local xySiz = asmlib.NewXY(nAut * scrW, nAut * scrH)
      local pnFrame = vguiCreate("DFrame"); if(not IsValid(pnFrame)) then
        asmlib.LogInstance("Frame invalid",gtArgsLogs); return nil end
      pnFrame:SetPos(xyPos.x, xyPos.y)
      pnFrame:SetSize(xySiz.x, xySiz.y)
      pnFrame:SetTitle(asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb_hd").." "..oPly:Nick().." {"..sVer.."}")
      pnFrame:SetDraggable(true)
      pnFrame:SetDeleteOnClose(false)
      pnFrame.OnClose = function(pnSelf)
        local iK = conElements:Find(pnSelf) -- Find panel key index
        if(IsValid(pnSelf)) then pnSelf:Remove() end -- Delete the valid panel
        if(asmlib.IsHere(iK)) then conElements:Pull(iK) end -- Pull the key out
      end
      local pnSheet = vguiCreate("DPropertySheet")
      if(not IsValid(pnSheet)) then pnFrame:Close()
        asmlib.LogInstance("Sheet invalid",gtArgsLogs); return nil end
      pnSheet:SetParent(pnFrame)
      pnSheet:Dock(FILL)
      local sOff = asmlib.GetOpVar("OPSYM_DISABLE")
      local sMis = asmlib.GetOpVar("MISS_NOAV")
      local sLib = asmlib.GetOpVar("NAME_LIBRARY")
      local sBas = asmlib.GetOpVar("DIRPATH_BAS")
      local sPrU = asmlib.GetOpVar("TOOLNAME_PU")
      local sRev = asmlib.GetOpVar("OPSYM_REVISION")
      local sDsv = sBas..asmlib.GetOpVar("DIRPATH_DSV")
      local fDSV = sDsv..("%s"..sPrU.."%s.txt")
      local sNam = (sBas..sLib.."_dsv.txt")
      local pnDSV = vguiCreate("DPanel")
      if(not IsValid(pnDSV)) then pnFrame:Close()
        asmlib.LogInstance("DSV list invalid",gtArgsLogs); return nil end
      pnDSV:SetParent(pnSheet)
      pnDSV:DockMargin(xyDsz.x, xyDsz.y, xyDsz.x, xyDsz.y)
      pnDSV:DockPadding(xyDsz.x, xyDsz.y, xyDsz.x, xyDsz.y)
      pnDSV:Dock(FILL)
      local tInfo = pnSheet:AddSheet("DSV", pnDSV, asmlib.ToIcon("dsvlist_extdb"))
      tInfo.Tab:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb").." DSV")
      local nW, nH = pnFrame:GetSize()
      xyPos.x, xyPos.y = xyDsz.x, xyDsz.y
      xySiz.x = (nW - 6 * xyDsz.x)
      xySiz.y = ((nH - 6 * xyDsz.y) - 52)
      local wAct = mathFloor(((gnRatio - 1) / 6) * xySiz.x)
      local wUse = mathFloor(xySiz.x - wAct)
      local pnListView = vguiCreate("DListView")
      if(not IsValid(pnListView)) then pnFrame:Close()
        asmlib.LogInstance("List view invalid",gtArgsLogs); return nil end
      pnListView:SetParent(pnDSV)
      pnListView:SetVisible(true)
      pnListView:SetSortable(false)
      pnListView:SetMultiSelect(false)
      pnListView:SetPos(xyPos.x,xyPos.y)
      pnListView:SetSize(xySiz.x,xySiz.y)
      pnListView:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_ext_dsv_lb"))
      pnListView:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_ext_dsv_hd"))
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_ext_dsv_1")):SetFixedWidth(wUse)
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_ext_dsv_2")):SetFixedWidth(wAct)
      pnListView:AddColumn(""):SetFixedWidth(0) -- The hidden path to the population file
      if(not fileExists(sNam, "DATA")) then fileWrite(sNam, "") end
      local oDSV = fileOpen(sNam, "rb", "DATA"); if(not oDSV) then pnFrame:Close()
        asmlib.LogInstance("DSV list missing",gtArgsLogs); return nil end
      local sDel, sLine, bEOF, bAct = "\t", "", false, true
      while(not bEOF) do
        sLine, bEOF = asmlib.GetStringFile(oDSV)
        if(not asmlib.IsBlank(sLine)) then local sKey, sPrg
          if(sLine:sub(1,1) ~= sOff) then bAct = true else
            bAct, sLine = false, sLine:sub(2,-1):Trim() end
          local nB, nE = sLine:find("%s+")
          if(nB and nE) then
            sKey = sLine:sub(1, nB-1)
            sPrg = sLine:sub(nE+1,-1)
          else sKey, sPrg = sLine, sMis end
          pnListView:AddLine(sKey, tostring(bAct), sPrg):SetTooltip(sPrg)
        end
      end; oDSV:Close()
      pnListView.OnRowSelected = function(pnSelf, nIndex, pnLine)
        if(inputIsMouseDown(MOUSE_LEFT)) then
          if(inputIsKeyDown(KEY_LSHIFT)) then -- Delete the file
            fileDelete(sNam); pnSelf:Clear()  -- The panel will be recreated
          else pnSelf:RemoveLine(nIndex) end  -- Just remove the line selected
        end -- Process only the left mouse button
      end
      pnListView.OnRowRightClick = function(pnSelf, nIndex, pnLine)
        if(inputIsMouseDown(MOUSE_RIGHT)) then
          if(inputIsKeyDown(KEY_LSHIFT)) then -- Export all lines to the file
            local oDSV = fileOpen(sNam, "wb", "DATA")
            if(not oDSV) then pnFrame:Close()
              asmlib.LogInstance("DSV list missing",gtArgsLogs); return nil end
            local tLine = pnSelf:GetLines()
            for iK, pnCur in pairs(tLine) do
              local sPrf = pnCur:GetColumnText(1)
              local sCom = ((pnCur:GetColumnText(2) == "true") and "" or sOff)
              local sPth = pnCur:GetColumnText(3)
              oDSV:Write(sCom..sPrf..sDel..sPth.."\n")
            end; oDSV:Flush(); oDSV:Close()
          else
            local sPrf = pnLine:GetColumnText(1)
            local sCom = ((pnLine:GetColumnText(2) == "true") and "" or sOff)
            local sPth = pnLine:GetColumnText(3)
            SetClipboardText(sCom..sPrf..sPth)
          end
        end -- Process only the right mouse button
      end -- Populate the tables for every database
      local iD, makTab = 1, asmlib.GetBuilderID(1)
      while(makTab) do
        local pnTable = vguiCreate("DPanel")
        if(not IsValid(pnTable)) then pnFrame:Close()
          asmlib.LogInstance("Category invalid",gtArgsLogs); return nil end
        local defTab = makTab:GetDefinition()
        pnTable:SetParent(pnSheet)
        pnTable:DockMargin(xyDsz.x, xyDsz.y, xyDsz.x, xyDsz.y)
        pnTable:DockPadding(xyDsz.x, xyDsz.y, xyDsz.x, xyDsz.y)
        pnTable:Dock(FILL)
        local tInfo = pnSheet:AddSheet(defTab.Nick, pnTable, asmlib.ToIcon(defTab.Name))
        tInfo.Tab:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb").." "..defTab.Nick)
        local tFile = fileFind(fDSV:format("*", defTab.Nick), "DATA")
        if(asmlib.IsTable(tFile) and tFile[1]) then
          local nF, nW, nH = #tFile, pnFrame:GetSize()
          xySiz.x, xyPos.x, xyPos.y = (nW - 6 * xyDsz.x), xyDsz.x, xyDsz.y
          xySiz.y = (((nH - 6 * xyDsz.y) - ((nF -1) * xyDsz.y) - 52) / nF)
          for iP = 1, nF do local sCur = tFile[iP]
            local pnManage = vguiCreate("DButton")
            if(not IsValid(pnSheet)) then pnFrame:Close()
              asmlib.LogInstance("Button invalid ["..tostring(iP).."]",gtArgsLogs); return nil end
            local nB, nE = sCur:upper():find(sPrU..defTab.Nick);
            if(nB and nE) then
              local sPref = sCur:sub(1, nB - 1)
              local sFile = fDSV:format(sPref, defTab.Nick)
              pnManage:SetParent(pnTable)
              pnManage:SetPos(xyPos.x, xyPos.y)
              pnManage:SetSize(xySiz.x, xySiz.y)
              pnManage:SetFont("Trebuchet24")
              pnManage:SetText(sPref)
              pnManage:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb_lb").." "..sFile)
              pnManage.DoRightClick = function(pnSelf)
                local pnMenu = vguiCreate("DMenu")
                if(not IsValid(pnMenu)) then pnFrame:Close()
                  asmlib.LogInstance("Menu invalid",gtArgsLogs); return nil end
                local iO, tOptions = 1, {
                  function() SetClipboardText(pnSelf:GetText()) end,
                  function() SetClipboardText(sDsv) end,
                  function() SetClipboardText(defTab.Nick) end,
                  function() SetClipboardText(sFile) end,
                  function() SetClipboardText(asmlib.GetDateTime(fileTime(sFile, "DATA"))) end,
                  function() SetClipboardText(tostring(fileSize(sFile, "DATA")).."B") end,
                  function() asmlib.SetAsmConvar(oPly, "*luapad", gsToolNameL) end,
                  function() fileDelete(sFile); asmlib.LogInstance("Deleted <"..sFile..">",gtArgsLogs)
                    if(defTab.Nick == "PIECES") then local sCat = fDSV:format(sPref,"CATEGORY")
                      if(fileExists(sCat,"DATA")) then fileDelete(sCat)
                        asmlib.LogInstance("Deleted <"..sCat..">",gtArgsLogs) end
                    end; pnManage:Remove()
                  end
                }
                while(tOptions[iO]) do local sO = tostring(iO)
                  local sDescr = asmlib.GetPhrase("tool."..gsToolNameL..".pn_externdb_"..sO)
                  pnMenu:AddOption(sDescr, tOptions[iO]):SetIcon(asmlib.ToIcon("pn_externdb_"..sO))
                  iO = iO + 1 -- Loop trough the functions list and add to the menu
                end; pnMenu:Open()
              end
            else asmlib.LogInstance("File missing ["..tostring(iP).."]",gtArgsLogs) end
            xyPos.y = xyPos.y + xySiz.y + xyDsz.y
          end
        else
          asmlib.LogInstance("Missing <"..defTab.Nick..">",gtArgsLogs)
        end
        iD = (iD + 1); makTab = asmlib.GetBuilderID(iD)
      end; pnFrame:SetVisible(true); pnFrame:Center(); pnFrame:MakePopup(); collectgarbage()
      conElements:Push(pnFrame); asmlib.LogInstance("Success",gtArgsLogs); return nil
    end) -- Read client configuration

  asmlib.SetAction("OPEN_FRAME",
    function(oPly,oCom,oArgs) gtArgsLogs[1] = "*OPEN_FRAME"
      local frUsed, nCount = asmlib.GetFrequentModels(oArgs[1]); if(not asmlib.IsHere(frUsed)) then
        asmlib.LogInstance("Retrieving most frequent models failed ["..tostring(oArgs[1]).."]",gtArgsLogs); return nil end
      local makTab = asmlib.GetBuilderNick("PIECES"); if(not asmlib.IsHere(makTab)) then
        asmlib.LogInstance("Missing builder for table PIECES",gtArgsLogs); return nil end
      local defTab = makTab:GetDefinition(); if(not defTab) then
        asmlib.LogInstance("Missing definition for table PIECES",gtArgsLogs); return nil end
      local pnFrame = vguiCreate("DFrame"); if(not IsValid(pnFrame)) then
        asmlib.LogInstance("Frame invalid",gtArgsLogs); return nil end
      ------------ Screen resolution and configuration ------------
      local scrW         = surfaceScreenWidth()
      local scrH         = surfaceScreenHeight()
      local sVersion     = asmlib.GetOpVar("TOOL_VERSION")
      local xyZero       = {x =  0, y = 20} -- The start location of left-top
      local xyDelta      = {x = 10, y = 10} -- Distance between panels
      local xySiz        = {x =  0, y =  0} -- Current panel size
      local xyPos        = {x =  0, y =  0} -- Current panel position
      local xyTmp        = {x =  0, y =  0} -- Temporary coordinate
      ------------ Frame ------------
      xySiz.x = (scrW / gnRatio) -- This defines the size of the frame
      xyPos.x, xyPos.y = (scrW / 4), (scrH / 4)
      xySiz.y = mathFloor(xySiz.x / (1 + gnRatio))
      pnFrame:SetTitle(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_hd").." "..oPly:Nick().." {"..sVersion.."}")
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
        asmlib.LogInstance("Button invalid",gtArgsLogs); return nil end
      pnButton:SetParent(pnFrame)
      pnButton:SetPos(xyPos.x, xyPos.y)
      pnButton:SetSize(xySiz.x, xySiz.y)
      pnButton:SetVisible(true)
      pnButton:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_export_lb"))
      pnButton:SetText(asmlib.GetPhrase("tool."..gsToolNameL..".pn_export_lb"))
      pnButton:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_export"))
      ------------ ComboBox ------------
      xyPos.x, xyPos.y = pnButton:GetPos()
      xyTmp.x, xyTmp.y = pnButton:GetSize()
      xyPos.x = xyPos.x + xyTmp.x + xyDelta.x
      xySiz.x, xySiz.y = (gnRatio * xyTmp.x), xyTmp.y
      local pnComboBox = vguiCreate("DComboBox")
      if(not IsValid(pnComboBox)) then pnFrame:Close()
        asmlib.LogInstance("Combo invalid",gtArgsLogs); return nil end
      pnComboBox:SetParent(pnFrame)
      pnComboBox:SetPos(xyPos.x,xyPos.y)
      pnComboBox:SetSize(xySiz.x,xySiz.y)
      pnComboBox:SetVisible(true)
      pnComboBox:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb"))
      pnComboBox:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol"))
      pnComboBox:SetValue(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb"))
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb1"), makTab:GetColumnName(1))
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb2"), makTab:GetColumnName(2))
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb3"), makTab:GetColumnName(3))
      pnComboBox:AddChoice(asmlib.GetPhrase("tool."..gsToolNameL..".pn_srchcol_lb4"), makTab:GetColumnName(4))
      pnComboBox.OnSelect = function(pnSelf, nInd, sVal, anyData) gtArgsLogs[1] = "OPEN_FRAME.ComboBox"
        asmlib.LogInstance("Selected "..asmlib.GetReport3(nInd,sVal,anyData),gtArgsLogs)
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
        asmlib.LogInstance("Model display invalid",gtArgsLogs); return nil end
      pnModelPanel:SetParent(pnFrame)
      pnModelPanel:SetPos(xyPos.x,xyPos.y)
      pnModelPanel:SetSize(xySiz.x,xySiz.y)
      pnModelPanel:SetVisible(true)
      pnModelPanel:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_display_lb"))
      pnModelPanel:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_display"))
      pnModelPanel.LayoutEntity = function(pnSelf, oEnt) gtArgsLogs[1] = "OPEN_FRAME.ModelPanel"
        if(pnSelf.bAnimated) then pnSelf:RunAnimation() end
        local uiBox = asmlib.CacheBoxLayout(oEnt,40); if(not asmlib.IsHere(uiBox)) then
          asmlib.LogInstance("Box invalid",gtArgsLogs); return nil end
        local vPos, aAng = asmlib.GetOpVar("VEC_ZERO"), uiBox.Ang
        local stSpawn = asmlib.GetNormalSpawn(oPly, vPos, aAng, oEnt:GetModel(), 1)
              stSpawn.SPos:Set(uiBox.Cen)
              stSpawn.SPos:Rotate(stSpawn.SAng)
              stSpawn.SPos:Mul(-1)
              stSpawn.SPos:Add(uiBox.Cen)
        oEnt:SetAngles(stSpawn.SAng)
        oEnt:SetPos(stSpawn.SPos)
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
        asmlib.LogInstance("Textbox invalid",gtArgsLogs); return nil end
      pnTextEntry:SetParent(pnFrame)
      pnTextEntry:SetPos(xyPos.x,xyPos.y)
      pnTextEntry:SetSize(xySiz.x,xySiz.y)
      pnTextEntry:SetVisible(true)
      pnTextEntry:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_pattern_lb"))
      pnTextEntry:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_pattern"))
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
        asmlib.LogInstance("List view invalid",gtArgsLogs); return nil end
      pnListView:SetParent(pnFrame)
      pnListView:SetVisible(false)
      pnListView:SetSortable(true)
      pnListView:SetMultiSelect(false)
      pnListView:SetPos(xyPos.x,xyPos.y)
      pnListView:SetSize(xySiz.x,xySiz.y)
      pnListView:SetName(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb"))
      pnListView:SetTooltip(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine"))
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb1")):SetFixedWidth(wUse) -- (1)
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb2")):SetFixedWidth(wAct) -- (2)
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb3")):SetFixedWidth(wTyp) -- (3)
      pnListView:AddColumn(asmlib.GetPhrase("tool."..gsToolNameL..".pn_routine_lb4")):SetFixedWidth(wNam) -- (4)
      pnListView:AddColumn(""):SetFixedWidth(0) -- (5) This is actually the hidden model of the piece used.
      pnListView.OnRowSelected = function(pnSelf, nIndex, pnLine) gtArgsLogs[1] = "OPEN_FRAME.ListView"
        local uiMod =  tostring(pnLine:GetColumnText(5)  or asmlib.GetOpVar("MISS_NOMD")) -- Actually the model in the table
        local uiAct = (tonumber(pnLine:GetColumnText(2)) or 0); pnModelPanel:SetModel(uiMod) -- Active track ends per model create entity
        local uiEnt = pnModelPanel:GetEntity(); if(not (uiEnt and uiEnt:IsValid())) then -- Makes sure the entity is validated first
          asmlib.LogInstance("Model entity invalid "..asmlib.GetReport(uiMod), gtArgsLogs); return nil end
        uiEnt:SetModel(uiMod); uiEnt:SetModelName(uiMod) -- Apply the model on the model panel even for changed compiled model paths
        local uiBox = asmlib.CacheBoxLayout(pnModelPanel:GetEntity(),0,gnRatio,gnRatio-1); if(not asmlib.IsHere(uiBox)) then
          asmlib.LogInstance("Box invalid for <"..uiMod..">",gtArgsLogs); return nil end
        pnModelPanel:SetLookAt(uiBox.Eye); pnModelPanel:SetCamPos(uiBox.Cam)
        local pointid, pnextid = asmlib.GetAsmConvar("pointid","INT"), asmlib.GetAsmConvar("pnextid","INT")
              pointid, pnextid = asmlib.SnapReview(pointid, pnextid, uiAct); SetClipboardText(uiMod)
        asmlib.SetAsmConvar(oPly,"pointid", pointid)
        asmlib.SetAsmConvar(oPly,"pnextid", pnextid)
        asmlib.SetAsmConvar(oPly, "model" , uiMod)
      end -- Copy the line model to the clipboard so it can be pasted with Ctrl+V
      pnListView.OnRowRightClick = function(pnSelf, nIndex, pnLine)
        local nCnt, nX, nY = 0, inputGetCursorPos(); nX, nY = pnSelf:ScreenToLocal(nX, nY)
        while(nX > 0) do nCnt = (nCnt + 1); nX = (nX - pnSelf:ColumnWidth(nCnt)) end
        SetClipboardText(pnLine:GetColumnText(nCnt))
      end
      if(not asmlib.UpdateListView(pnListView,frUsed,nCount)) then
        asmlib.LogInstance("Populate the list view failed",gtArgsLogs); return nil end
      -- The button dababase export by type uses the current active type in the ListView line
      pnButton.DoClick = function(pnSelf) gtArgsLogs[1] = "OPEN_FRAME.Button"
        asmlib.LogInstance("Click "..asmlib.GetReport(pnSelf:GetText()), gtArgsLogs)
        if(asmlib.GetAsmConvar("exportdb", "BUL")) then
          if(inputIsKeyDown(KEY_LSHIFT)) then local sType
            local iD, pnLine = pnListView:GetSelectedLine()
            if(asmlib.IsHere(iD)) then sType = pnLine:GetColumnText(3)
            else local model = asmlib.GetAsmConvar("model", "STR")
              local oRec = asmlib.CacheQueryPiece(model)
              if(asmlib.IsHere(oRec)) then sType = oRec.Type
              else LogInstance("Not piece <"..model..">") end
            end
            asmlib.ExportTypeAR(sType)
            asmlib.LogInstance("Export type "..asmlib.GetReport(sType), gtArgsLogs)
          else
            asmlib.ExportCategory(3)
            asmlib.ExportDSV("PIECES")
            asmlib.ExportDSV("ADDITIONS")
            asmlib.ExportDSV("PHYSPROPERTIES")
            asmlib.LogInstance("Export instance", gtArgsLogs)
          end
          asmlib.SetAsmConvar(oPly, "exportdb", 0)
        else
          if(inputIsKeyDown(KEY_LSHIFT)) then
            local fW = asmlib.GetOpVar("FORM_GITWIKI")
            guiOpenURL(fW:format("Additional-features"))
          end
        end
      end
      -- Leave the TextEntry here so it can access and update the local ListView reference
      pnTextEntry.OnEnter = function(pnSelf) gtArgsLogs[1] = "OPEN_FRAME.TextEntry"
        local sPat = tostring(pnSelf:GetValue() or "")
        local sAbr, sCol = pnComboBox:GetSelected() -- Returns two values
              sAbr, sCol = tostring(sAbr or ""), tostring(sCol or "")
        if(not asmlib.UpdateListView(pnListView,frUsed,nCount,sCol,sPat)) then
          asmlib.LogInstance("Update ListView fail"..asmlib.GetReport3(sAbr,sCol,sPat,gtArgsLogs)); return nil
        end
      end
      pnFrame:SetVisible(true); pnFrame:Center(); pnFrame:MakePopup(); collectgarbage()
      conElements:Push(pnFrame); asmlib.LogInstance("Success",gtArgsLogs); return nil
    end)

  asmlib.SetAction("DRAW_PHYSGUN",
    function() gtArgsLogs[1] = "*DRAW_PHYSGUN"
      if(not asmlib.IsInit()) then return nil end
      if(not asmlib.GetAsmConvar("engunsnap", "BUL")) then
        asmlib.LogInstance("Extension disabled",gtArgsLogs); return nil end
      if(not asmlib.GetAsmConvar("adviser", "BUL")) then
        asmlib.LogInstance("Adviser disabled",gtArgsLogs); return nil end
      local oPly, actSwep = asmlib.GetHookInfo(gtArgsLogs, "weapon_physgun")
      if(not oPly) then asmlib.LogInstance("Hook mismatch",gtArgsLogs); return nil end
      local hasghost = asmlib.HasGhosts(); asmlib.FadeGhosts(true)
      if(not inputIsMouseDown(MOUSE_LEFT)) then
        if(hasghost) then timerSimple(0, asmlib.ClearGhosts) end
        asmlib.LogInstance("Physgun not hold",gtArgsLogs); return nil
      end -- When the player is not holding the piece clear ghosts
      local actTr = asmlib.GetCacheTrace(oPly); if(not actTr) then
        asmlib.LogInstance("Trace missing",gtArgsLogs); return nil end
      if(not actTr.Hit) then asmlib.LogInstance("Trace not hit",gtArgsLogs); return nil end
      if(actTr.HitWorld) then asmlib.LogInstance("Trace world",gtArgsLogs); return nil end
      local trEnt = actTr.Entity; if(not (trEnt and trEnt:IsValid())) then
        asmlib.LogInstance("Trace entity invalid",gtArgsLogs); return nil end
      if(trEnt:GetNWBool(gsToolPrefL.."physgundisabled")) then
        asmlib.LogInstance("Trace entity physgun disabled",gtArgsLogs); return nil end
      local trRec = asmlib.CacheQueryPiece(trEnt:GetModel()); if(not trRec) then
        asmlib.LogInstance("Trace not piece",gtArgsLogs); return nil end
      local scrW, scrH = surfaceScreenWidth(), surfaceScreenHeight()
      local actMonitor = asmlib.GetScreen(0,0,scrW,scrH,conPalette,"GAME")
      if(not actMonitor) then asmlib.LogInstance("Invalid screen",gtArgsLogs); return nil end
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
        local xyS, xyE = oDt.start:ToScreen(), oDt.endpos:ToScreen()
        local rdS = asmlib.GetCacheRadius(oPly, oTr.HitPos, 1)
        if(oTr and oTr.Hit) then actMonitor:GetColor()
          local tgE, xyH = oTr.Entity, oTr.HitPos:ToScreen()
          if(tgE and tgE:IsValid()) then
            actMonitor:DrawCircle(xyS, asmlib.GetViewRadius(oPly, oDt.start), "y", "SURF")
            actMonitor:DrawLine  (xyS, xyH, "g", "SURF")
            actMonitor:DrawCircle(xyH, asmlib.GetViewRadius(oPly, oTr.HitPos), "g")
            actMonitor:DrawLine  (xyH, xyE, "y")
            actSpawn = asmlib.GetEntitySpawn(oPly,tgE,oTr.HitPos,trRec.Slot,trID,activrad,
                         spnflat,igntype, nextx, nexty, nextz, nextpic, nextyaw, nextrol)
            if(actSpawn) then -- When spawn data is availabe draw adviser
              if(utilIsValidModel(trRec.Slot)) then -- The model has valid pre-cache
                if(ghostcnt > 0) then -- The ghosting is enabled
                  if(not (hasghost and atGhosts.Size == 1 and trRec.Slot == atGhosts.Slot)) then
                    if(not asmlib.MakeGhosts(1, trRec.Slot)) then
                      asmlib.LogInstance("Ghosting fail",gtArgsLogs); return nil end
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
                  asmlib.LogInstance("ID #"..tostring(ID).." not located",gtArgsLogs); return nil end
                actMonitor:DrawPOA(oPly,tgE,tgPOA,activrad,rdS)
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
      end
    end)

    asmlib.SetAction("TWEAK_PANEL",
      function(tDat, ...)
        local tArg = {...}; gtArgsLogs[1] = "*TWEAK_PANEL"
        local sDir, sSub = tostring(tArg[1]):lower(), tostring(tArg[2]):lower()
        local fFoo = tArg[3]; if(not asmlib.IsFunction(fFoo)) then
          asmlib.LogInstance("Function miss "..asmlib.GetReport2(sDir, sSub), gtArgsLogs); return end
        local bS, lDir = pcall(tDat.Foo, sDir); if (not bS) then
          asmlib.LogInstance("Folder ["..sDir.."] "..lDir, gtArgsLogs); return end
        local bS, lSub = pcall(tDat.Foo, sSub); if (not bS) then
          asmlib.LogInstance("Subfolder ["..sSub.."] "..lSub, gtArgsLogs); return end
        local sKey = tDat.Key:format(sDir, sSub)
        hookAdd("PopulateToolMenu", sKey, function()
          local sNam = asmlib.GetPhrase(tDat.Nam)
          spawnmenuAddToolMenuOption(lDir, lSub, sKey, sNam, "", "", tArg[3])
        end)
      end,
      {
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
gtOptionsCM.Order, gtOptionsCM.MenuIcon = 1600, asmlib.ToIcon(gsOptionsCM)
gtOptionsCM.MenuLabel = asmlib.GetPhrase("tool."..gsToolNameL..".name")

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
                asmlib.UndoCrate("TA Weld > "..asmlib.GetReport2(sIde,cnW:GetClass()))
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
                asmlib.UndoCrate("TA NoCollide > "..asmlib.GetReport2(sIde,cnN:GetClass()))
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
                asmlib.UndoCrate("TA NoCollideWorld > "..asmlib.GetReport2(ePiece:EntIndex(),cnG:GetClass()))
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
  local function PopulateEntity(nLen)
    local oEnt = netReadEntity(); gtArgsLogs[1] = "*POPULATE_ENTITY"
    local sNoA = asmlib.GetOpVar("MISS_NOAV") -- Default drawn string
    asmlib.LogInstance("Entity"..asmlib.GetReport2(oEnt:GetClass(),oEnt:EntIndex()), gtArgsLogs)
    for iD = 1, conContextMenu:GetSize() do
      local tLine = conContextMenu:Select(iD) -- Grab the value from the container
      local sKey, wDraw = tLine[1], tLine[5]  -- Extract the key and handler
      if(type(wDraw) == "function") then      -- Check when the value is function
        local bS, vE = pcall(wDraw, oEnt); vE = tostring(vE) -- Always being string
        if(not bS) then oEnt:SetNWString(sKey, sNoA)
          asmlib.LogInstance("Request"..asmlib.GetReport2(sKey,iD).." fail: "..vE, gtArgsLogs); return end
        asmlib.LogInstance("Handler"..asmlib.GetReport2(sKey,iD,vE), gtArgsLogs)
        oEnt:SetNWString(sKey, vE) -- Write networked value to the hover entity
      end
    end
  end
  utilAddNetworkString(gsOptionsCV)
  netReceive(gsOptionsCV, PopulateEntity)
end

if(CLIENT) then
  asmlib.SetAction("UPDATE_CONTEXTVAL", -- Must have the same parameters as the hook
    function() gtArgsLogs[1] = "*UPDATE_CONTEXTVAL"
      if(not asmlib.IsInit()) then return nil end
      if(not asmlib.IsFlag("tg_context_menu")) then return nil end -- Menu not opened
      if(not asmlib.GetAsmConvar("enctxmenu", "BUL")) then return nil end -- Menu not enabled
      local oPly = LocalPlayer(); if(not asmlib.IsPlayer(oPly)) then
        asmlib.LogInstance("Player invalid "..asmlib.GetReport(oPly)..">", gtArgsLogs); return nil end
      local vEye, vAim, tTrig = EyePos(), oPly:GetAimVector(), asmlib.GetOpVar("HOVER_TRIGGER")
      local oEnt = propertiesGetHovered(vEye, vAim); tTrig[2] = tTrig[1]; tTrig[1] = oEnt
      if(asmlib.IsOther(oEnt) or tTrig[1] == tTrig[2]) then return nil end -- Entity trigger
      if(not asmlib.GetAsmConvar("enctxmall", "BUL")) then -- Enable for all props
        local oRec = asmlib.CacheQueryPiece(oEnt:GetModel())
        if(not asmlib.IsHere(oRec)) then return nil end
      end -- If the menu is not enabled for all props ged-a-ud!
      netStart(gsOptionsCV); netWriteEntity(oEnt); netSendToServer() -- Love message
      asmlib.LogInstance("Entity "..asmlib.GetReport2(oEnt:GetClass(),oEnt:EntIndex()), gtArgsLogs)
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
  gtOptionsCM.MenuLabel = asmlib.GetPhrase("tool."..gsToolNameL..".name")
  local oPly, pnSub = LocalPlayer(), opt:AddSubMenu(); if(not IsValid(pnSub)) then
    asmlib.LogInstance("Invalid context menu",gsOptionsLG); return end
  local fHash = (gsToolNameL.."%.(.*)$")
  for iD = 1, conContextMenu:GetSize() do
    local tLine = conContextMenu:Select(iD)
    local sKey , fDraw = tLine[1], tLine[4]
    local wDraw, sIcon = tLine[5], sKey:match(fHash)
    local sName = asmlib.GetPhrase(sKey.."_con"):Trim():Trim(":")
    if(asmlib.IsFunction(fDraw)) then
      local bS, vE = pcall(fDraw, ent, oPly, tr, sKey); if(not bS) then
        asmlib.LogInstance("Request "..asmlib.GetReport2(sKey,iD).." fail: "..vE,gsOptionsLG); return end
      sName = sName..": "..tostring(vE)          -- Attach client value ( CLIENT )
    elseif(asmlib.IsFunction(wDraw)) then
      sName = sName..": "..ent:GetNWString(sKey) -- Attach networked value ( SERVER )
    end; local fEval = function() self:Evaluate(ent,iD,tr,sKey) end
    local pnOpt = pnSub:AddOption(sName, fEval); if(not IsValid(pnOpt)) then
      asmlib.LogInstance("Invalid "..asmlib.GetReport2(sKey,iD),gsOptionsLG); return end
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
      asmlib.LogInstance("Request "..asmlib.GetReport2(sKey,idx).." fail: "..vE,gsOptionsLG); return end
    if(bS and not vE) then asmlib.LogInstance("Failure "..asmlib.GetReport2(sKey,idx),gsOptionsLG); return end
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
    asmlib.LogInstance("Request "..asmlib.GetReport2(sKey,idx).." fail: "..vE,gsOptionsLG); return end
  if(bS and not vE) then asmlib.LogInstance("Failure "..asmlib.GetReport2(sKey,idx),gsOptionsLG); return end
end
-- Register the track assembly setup options in the context menu
propertiesAdd(gsOptionsCM, gtOptionsCM)

------------ INITIALIZE DB------------

asmlib.CreateTable("PIECES",{
  Timer = gaTimerSet[1],
  Index = {{1},{4},{1,4}},
  Trigs = {
    Record = function(arLine, vSrc)
      local noMD  = asmlib.GetOpVar("MISS_NOMD")
      local noTY  = asmlib.GetOpVar("MISS_NOTP")
      local noSQL = asmlib.GetOpVar("MISS_NOSQL")
      local trCls = asmlib.GetOpVar("TRACE_CLASS")
      arLine[2] = asmlib.GetTerm(arLine[2], noTY, asmlib.Categorize())
      arLine[3] = asmlib.GetTerm(arLine[3], noMD, asmlib.ModelToName(arLine[1]))
      arLine[8] = asmlib.GetTerm(arLine[8], noSQL, noSQL)
      if(not (asmlib.IsNull(arLine[8]) or trCls[arLine[8]] or asmlib.IsBlank(arLine[8]))) then
        asmlib.LogInstance("Register trace "..asmlib.GetReport2(arLine[8],arLine[1]),vSrc)
        trCls[arLine[8]] = true; -- Register the class provided to the trace hit list
      end; return true
    end
  },
  Cache = {
    Record = function(makTab, tCache, snPK, arLine, vSrc)
      local defTab = makTab:GetDefinition()
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Type)) then stData.Type = arLine[2] end
      if(not asmlib.IsHere(stData.Name)) then stData.Name = arLine[3] end
      if(not asmlib.IsHere(stData.Unit)) then stData.Unit = arLine[8] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      local nOffsID = makTab:Match(arLine[4],4); if(not asmlib.IsHere(nOffsID)) then
        asmlib.LogInstance("Cannot match "..asmlib.GetReport3(4,arLine[4],snPK),vSrc); return false end
      local stPOA = asmlib.RegisterPOA(stData,nOffsID,arLine[5],arLine[6],arLine[7])
        if(not asmlib.IsHere(stPOA)) then
        asmlib.LogInstance("Cannot process offset #"..tostring(nOffsID).." for "..
          tostring(snPK),vSrc); return false end
      if(nOffsID > stData.Size) then stData.Size = nOffsID else
        asmlib.LogInstance("Offset #"..tostring(nOffsID)..
          " sequential mismatch",vSrc); return false end
      return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSrc)
      local tData, defTab = {}, makTab:GetDefinition()
      for mod, rec in pairs(tCache) do
        tData[mod] = {KEY = (rec.Type..rec.Name..mod)} end
      local tSort = asmlib.Sort(tData,{"KEY"})
      if(not tSort) then oFile:Flush(); oFile:Close()
        asmlib.LogInstance("("..fPref..") Cannot sort cache data",vSrc); return false end
      for iIdx = 1, tSort.Size do local stRec = tSort[iIdx]
        local tData = tCache[stRec.Key]
        local sData, tOffs = defTab.Name, tData.Offs
              sData = sData..sDelim..makTab:Match(stRec.Key,1,true,"\"")..sDelim..
                makTab:Match(tData.Type,2,true,"\"")..sDelim..
                makTab:Match(((asmlib.ModelToName(stRec.Key) == tData.Name) and symOff or tData.Name),3,true,"\"")
        -- Matching crashes only for numbers. The number is already inserted, so there will be no crash
        for iInd = 1, #tOffs do local stPnt = tData.Offs[iInd]
          local sP, sO, sA = asmlib.ExportPOA(stPnt, "")
          local sC = (tData.Unit and tostring(tData.Unit or "") or "")
          oFile:Write(sData..sDelim..makTab:Match(iInd,4,true,"\"")..sDelim..
            "\""..sP.."\""..sDelim.."\""..sO.."\""..sDelim.."\""..sA.."\""..sDelim.."\""..sC.."\"\n")
        end
      end; return true
    end,
    ExportAR = function(aRow) aRow[2], aRow[4] = "myType", "gsSymOff" end
  },
  Query = {
    Record = {"%s","%s","%s","%d","%s","%s","%s","%s"},
    ExportDSV = {2,3,1,4}
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

asmlib.CreateTable("ADDITIONS",{
  Timer = gaTimerSet[2],
  Index = {{1},{4},{1,4}},
  Query = {
    Record = {"%s","%s","%s","%d","%s","%s","%d","%d","%d","%d","%d","%d"},
    ExportDSV = {1,4}
  },
  Cache = {
    Record = function(makTab, tCache, snPK, arLine, vSrc)
      local defTab = makTab:GetDefinition()
      local stData = tCache[snPK]; if(not stData) then
        tCache[snPK] = {}; stData = tCache[snPK] end
      if(not asmlib.IsHere(stData.Size)) then stData.Size = 0 end
      if(not asmlib.IsHere(stData.Slot)) then stData.Slot = snPK end
      local nCnt, iID = 2, makTab:Match(arLine[4],4); if(not asmlib.IsHere(iID)) then
        asmlib.LogInstance("Cannot match "..asmlib.GetReport3(4,arLine[4],snPK),vSrc); return false end
      stData[iID] = {} -- LineID has to be set properly
      while(nCnt <= defTab.Size) do sCol = makTab:GetColumnName(nCnt)
        stData[iID][sCol] = makTab:Match(arLine[nCnt],nCnt)
        if(not asmlib.IsHere(stData[iID][sCol])) then -- Check data conversion output
          asmlib.LogInstance("Cannot match "..asmlib.GetReport3(nCnt,arLine[nCnt],snPK),vSrc); return false
        end; nCnt = (nCnt + 1)
      end; stData.Size = iID; return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSrc)
      local defTab = makTab:GetDefinition()
      for mod, rec in pairs(tCache) do
        local sData = defTab.Name..sDelim..mod
        for iIdx = 1, #rec do local tData = rec[iIdx]; oFile:Write(sData)
          for iID = 2, defTab.Size do local vData = tData[makTab:GetColumnName(iID)]
            local vM = makTab:Match(vData,iID,true,"\""); if(not asmlib.IsHere(vM)) then
              asmlib.LogInstance("Cannot match "..asmlib.GetReport3()); return false
            end; oFile:Write(sDelim..tostring(vM or ""))
          end; oFile:Write("\n") -- Data is already inserted, there will be no crash
        end
      end; return true
    end,
    ExportAR = function(aRow) aRow[4] = "gsSymOff" end
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

asmlib.CreateTable("PHYSPROPERTIES",{
  Timer = gaTimerSet[3],
  Index = {{1},{2},{1,2}},
  Trigs = {
    Record = function(arLine)
      arLine[1] = asmlib.GetTerm(arLine[1],"TYPE",asmlib.Categorize()); return true
    end
  },
  Cache = {
    Record = function(makTab, tCache, snPK, arLine, vSrc)
      local skName = asmlib.GetOpVar("HASH_PROPERTY_NAMES")
      local skType = asmlib.GetOpVar("HASH_PROPERTY_TYPES")
      local defTab = makTab:GetDefinition()
      local tTypes = tCache[skType]; if(not tTypes) then
        tCache[skType] = {}; tTypes = tCache[skType]; tTypes.Size = 0 end
      local tNames = tCache[skName]; if(not tNames) then
        tCache[skName] = {}; tNames = tCache[skName] end
      local iNameID = makTab:Match(arLine[2],2); if(not asmlib.IsHere(iNameID)) then
        asmlib.LogInstance("Cannot match "..asmlib.GetReport3(2,arLine[2],snPK),vSrc); return false end
      if(not asmlib.IsHere(tNames[snPK])) then -- If a new type is inserted
        tTypes.Size = (tTypes.Size + 1)
        tTypes[tTypes.Size] = snPK; tNames[snPK] = {}
        tNames[snPK].Size, tNames[snPK].Slot = 0, snPK
      end -- Data matching crashes only on numbers
      tNames[snPK].Size = iNameID
      tNames[snPK][iNameID] = makTab:Match(arLine[3],3); return true
    end,
    ExportDSV = function(oFile, makTab, tCache, fPref, sDelim, vSrc)
      local defTab = makTab:GetDefinition()
      local tTypes = tCache[asmlib.GetOpVar("HASH_PROPERTY_TYPES")]
      local tNames = tCache[asmlib.GetOpVar("HASH_PROPERTY_NAMES")]
      if(not (tTypes or tNames)) then F:Flush(); F:Close()
        asmlib.LogInstance("("..fPref..") No data found",vSrc); return false end
      for iInd = 1, tTypes.Size do local sType = tTypes[iInd]
        local tType = tNames[sType]; if(not tType) then F:Flush(); F:Close()
          asmlib.LogInstance("("..fPref..") Missing index #"..iInd.." on type <"..sType..">",vSrc); return false end
        for iCnt = 1, tType.Size do local vType = tType[iCnt]
          oFile:Write(defTab.Name..sDelim..makTab:Match(sType,1,true,"\"")..
                                   sDelim..makTab:Match(iCnt ,2,true,"\"")..
                                   sDelim..makTab:Match(vType,3,true,"\"").."\n")
        end
      end; return true
    end,
    ExportAR = function(aRow) aRow[1], aRow[2] = "myType", "gsSymOff" end
  },
  Query = {
    Record = {"%s","%d","%s"},
    ExportDSV = {1,2}
  },
  [1] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [2] = {"LINEID", "INTEGER", "FLR",  nil },
  [3] = {"NAME"  , "TEXT"   ,  nil ,  nil }
},true,true)

------------ POPULATE DB ------------

--[[ Categories are only needed client side ]]--
if(CLIENT) then
  if(fileExists(gsFullDSV.."CATEGORY.txt", "DATA")) then
    asmlib.LogInstance("DB CATEGORY from DSV",gtInitLogs)
    asmlib.ImportCategory(3)
  else asmlib.LogInstance("DB CATEGORY from LUA",gtInitLogs) end
end

--[[ Track pieces parametrization legend
 * Disabling of a component is preformed by using "OPSYM_DISABLE"
 * Disabling A     - The ID angle is treated as {0,0,0}
 * Disabling Type  - Makes it use the value of Categorize()
 * Disabling Name  - Makes it generate it using the model via ModelToName()
 * Disabling Class - Makes it use the default /prop_physics/
 * First  argument of Categorize() is used to provide default track type for TABLE:Record()
 * Second argument of Categorize() is used to generate track categories for the processed addon
]]--
if(fileExists(gsFullDSV.."PIECES.txt", "DATA")) then
  asmlib.LogInstance("DB PIECES from DSV",gtInitLogs)
  asmlib.ImportDSV("PIECES", true)
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
  asmlib.Categorize("SligWolf's Rerailers")
  PIECES:Record({"models/props_phx/trains/sw_rerailer_1.mdl", "#", "Short Single", 1, "-190.553,0,25.193", "211.414,0.015,-5.395"})
  PIECES:Record({"models/props_phx/trains/sw_rerailer_2.mdl", "#", "Middle Single", 1, "-190.553,0,25.193", "211.414,0.015,-5.395"})
  PIECES:Record({"models/props_phx/trains/sw_rerailer_3.mdl", "#", "Long Single", 1, "-190.553,0,25.193", "211.414,0.015,-5.395"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_3.mdl", "#", "Long Double", 1, "-258.249, -0.01, -0.002", "219.415, 0, -5.409"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_3.mdl", "#", "Long Double", 2, "-3124.199, -0.01, 2.997", "-3601.869, -0.377, -5.416", "0,-180,0"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_2.mdl", "#", "Middle Double", 1, "-265.554, 0, 3.031", "219.412, 0, -5.407"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_2.mdl", "#", "Middle Double", 2, "-1882.106, 0, 3.031", "-2367.072, 0, -5.412", "0,-180,0"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_1.mdl", "#", "Short Double", 1, "-221.409, 0, 3.031", "219.412, 0, -5.411"})
  PIECES:Record({"models/sligwolf/rerailer/rerailer_1.mdl", "#", "Short Double", 2, "-1103.05, 0, 0.009", "-1543.871, 0, -5.411", "0,-180,0"})
  asmlib.Categorize("SligWolf's Minitrains",[[function(m)
    local r = m:gsub("models/minitrains/",""):gsub("%W.+$","")
    if(r == "sw") then r = "buffer" end; return r; end]])
  PIECES:Record({"models/minitrains/straight_16.mdl",   "#", "#", 1, "", "0,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_16.mdl",   "#", "#", 2, "", "-16,-8.5065,1", "0,-180,0"})
  PIECES:Record({"models/minitrains/straight_32.mdl",   "#", "#", 1, "", "0,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_32.mdl",   "#", "#", 2, "", "-32,-8.5065,1", "0,-180,0"})
  PIECES:Record({"models/minitrains/straight_64.mdl",   "#", "#", 1, "", "0,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_64.mdl",   "#", "#", 2, "", "-64,-8.5065,1", "0,-180,0"})
  PIECES:Record({"models/minitrains/straight_128.mdl",  "#", "#", 1, "", "0,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_128.mdl",  "#", "#", 2, "", "-128,-8.5065,1", "0,-180,0"})
  PIECES:Record({"models/minitrains/straight_256.mdl",  "#", "#", 1, "", "0,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_256.mdl",  "#", "#", 2, "", "-256,-8.5065,1", "0,-180,0"})
  PIECES:Record({"models/minitrains/straight_512.mdl",  "#", "#", 1, "", "0,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_512.mdl",  "#", "#", 2, "", "-512,-8.5065,1", "0,-180,0"})
  PIECES:Record({"models/minitrains/straight_1024.mdl", "#", "#", 1, "", "0,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_1024.mdl", "#", "#", 2, "", "-1024,-8.5065,1", "0,-180,0"})
  asmlib.ModelToNameRule("SET",nil,{"diagonal_","ramp_"},nil)
  PIECES:Record({"models/minitrains/straight_diagonal_128.mdl", "#", "#", 1, "", "8,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_diagonal_128.mdl", "#", "#", 2, "", "-136,-8.5065,33", "0,-180,0"})
  PIECES:Record({"models/minitrains/straight_diagonal_256.mdl", "#", "#", 1, "", "8,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_diagonal_256.mdl", "#", "#", 2, "", "-264,-8.5065,33", "0,-180,0"})
  PIECES:Record({"models/minitrains/straight_diagonal_512.mdl", "#", "#", 1, "", "8,-8.5065,1"})
  PIECES:Record({"models/minitrains/straight_diagonal_512.mdl", "#", "#", 2, "", "-520,-8.5065,33", "0,-180,0"})
  asmlib.ModelToNameRule("CLR")
  PIECES:Record({"models/minitrains/curve_1_90.mdl", "#", "#", 1, "", "-0.011, -8.5, 1"})
  PIECES:Record({"models/minitrains/curve_1_90.mdl", "#", "#", 2, "", "-138.51, 130, 1", "0,90,0"})
  PIECES:Record({"models/minitrains/curve_2_90.mdl", "#", "#", 1, "", "-0.011, -8.5, 1"})
  PIECES:Record({"models/minitrains/curve_2_90.mdl", "#", "#", 2, "", "-168.51, 160, 0.996", "0,90,0"})
  PIECES:Record({"models/minitrains/curve_3_90.mdl", "#", "#", 1, "", "-0.011, -8.5, 1"})
  PIECES:Record({"models/minitrains/curve_3_90.mdl", "#", "#", 2, "", "-198.51, 190, 0.995", "0,90,0"})
  PIECES:Record({"models/minitrains/curve_4_90.mdl", "#", "#", 1, "", "-0.011, -8.5, 1"})
  PIECES:Record({"models/minitrains/curve_4_90.mdl", "#", "#", 2, "", "-228.51, 220, 0.994", "0,90,0"})
  PIECES:Record({"models/minitrains/curve_5_90.mdl", "#", "#", 1, "", "-0.011, -8.5, 1"})
  PIECES:Record({"models/minitrains/curve_5_90.mdl", "#", "#", 2, "", "-258.51, 250, 0.994", "0,90,0"})
  PIECES:Record({"models/minitrains/curve_6_90.mdl", "#", "#", 1, "", "-0.011, -8.5, 1"})
  PIECES:Record({"models/minitrains/curve_6_90.mdl", "#", "#", 2, "", "-288.51, 280, 0.993", "0,90,0"})
  PIECES:Record({"models/minitrains/curve_1_45.mdl", "#", "#", 1, "", "-0.004, -8.506, 1"})
  PIECES:Record({"models/minitrains/curve_1_45.mdl", "#", "#", 2, "", "-97.956, 32.044, 1", "0,135,0"})
  PIECES:Record({"models/minitrains/curve_2_45.mdl", "#", "#", 1, "", "-0.004, -8.506, 1"})
  PIECES:Record({"models/minitrains/curve_2_45.mdl", "#", "#", 2, "", "-119.15, 40.853, 1", "0,135,0"})
  PIECES:Record({"models/minitrains/curve_3_45.mdl", "#", "#", 1, "", "-0.004, -8.506, 1"})
  PIECES:Record({"models/minitrains/curve_3_45.mdl", "#", "#", 2, "", "-140.368, 49.631, 1", "0,135,0"})
  PIECES:Record({"models/minitrains/curve_4_45.mdl", "#", "#", 1, "", "-0.004, -8.506, 1"})
  PIECES:Record({"models/minitrains/curve_4_45.mdl", "#", "#", 2, "", "-161.567, 58.434, 1", "0,135,0"})
  PIECES:Record({"models/minitrains/curve_5_45.mdl", "#", "#", 1, "", "-0.004, -8.506, 1"})
  PIECES:Record({"models/minitrains/curve_5_45.mdl", "#", "#", 2, "", "-182.769, 67.232, 1", "0,135,0"})
  PIECES:Record({"models/minitrains/curve_6_45.mdl", "#", "#", 1, "", "-0.004, -8.506, 1"})
  PIECES:Record({"models/minitrains/curve_6_45.mdl", "#", "#", 2, "", "-203.983, 76.019, 1", "0,135,0"})
  PIECES:Record({"models/minitrains/curve_1_22-5.mdl", "#", "#", 1, "", "-0.005, -8.505, 1"})
  PIECES:Record({"models/minitrains/curve_1_22-5.mdl", "#", "#", 2, "", "-53.014, 2.013, 1", "0,157.5,0"})
  PIECES:Record({"models/minitrains/curve_2_22-5.mdl", "#", "#", 1, "", "-0.005, -8.505, 1"})
  PIECES:Record({"models/minitrains/curve_2_22-5.mdl", "#", "#", 2, "", "-64.492, 4.307, 1", "0,157.5,0"})
  PIECES:Record({"models/minitrains/curve_3_22-5.mdl", "#", "#", 1, "", "-0.005, -8.505, 1"})
  PIECES:Record({"models/minitrains/curve_3_22-5.mdl", "#", "#", 2, "", "-75.965, 6.599, 1", "0,157.5,0"})
  PIECES:Record({"models/minitrains/curve_4_22-5.mdl", "#", "#", 1, "", "-0.005, -8.505, 1"})
  PIECES:Record({"models/minitrains/curve_4_22-5.mdl", "#", "#", 2, "", "-87.437, 8.904, 1", "0,157.5,0"})
  PIECES:Record({"models/minitrains/curve_5_22-5.mdl", "#", "#", 1, "", "-0.005, -8.505, 1"})
  PIECES:Record({"models/minitrains/curve_5_22-5.mdl", "#", "#", 2, "", "-98.913, 11.205,1", "0,157.5,0"})
  PIECES:Record({"models/minitrains/curve_6_22-5.mdl", "#", "#", 1, "", "-0.005, -8.505, 1"})
  PIECES:Record({"models/minitrains/curve_6_22-5.mdl", "#", "#", 2, "", "-110.405, 13.455, 1", "0,157.5,0"})
  PIECES:Record({"models/minitrains/curve_1_s_small.mdl", "#", "#", 1, "", "-0.007, -8.507, 1"})
  PIECES:Record({"models/minitrains/curve_1_s_small.mdl", "#", "#", 2, "", "-105.994, 12.497, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_2_s_small.mdl", "#", "#", 1, "", "-0.007, -8.507, 1"})
  PIECES:Record({"models/minitrains/curve_2_s_small.mdl", "#", "#", 2, "", "-128.994, 17.497, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_3_s_small.mdl", "#", "#", 1, "", "-0.007, -8.507, 1"})
  PIECES:Record({"models/minitrains/curve_3_s_small.mdl", "#", "#", 2, "", "-151.994, 21.497, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_4_s_small.mdl", "#", "#", 1, "", "-0.007, -8.507, 1"})
  PIECES:Record({"models/minitrains/curve_4_s_small.mdl", "#", "#", 2, "", "-174.994, 26.497, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_5_s_small.mdl", "#", "#", 1, "", "-0.007, -8.507, 1"})
  PIECES:Record({"models/minitrains/curve_5_s_small.mdl", "#", "#", 2, "", "-197.994, 31.497, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_6_s_small.mdl", "#", "#", 1, "", "-0.007, -8.507, 1"})
  PIECES:Record({"models/minitrains/curve_6_s_small.mdl", "#", "#", 2, "", "-220.994, 35.497, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_1_s_medium.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_1_s_medium.mdl", "#", "#", 2, "", "-195.966, 72.51, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_2_s_medium.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_2_s_medium.mdl", "#", "#", 2, "", "-237.966, 90.51, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_3_s_medium.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_3_s_medium.mdl", "#", "#", 2, "", "-280.966, 107.51, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_4_s_medium.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_4_s_medium.mdl", "#", "#", 2, "", "-322.966, 125.51, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_5_s_medium.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_5_s_medium.mdl", "#", "#", 2, "", "-365.991, 142.507, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_6_s_medium.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_6_s_medium.mdl", "#", "#", 2, "", "-407.99, 160.51, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_1_s_big.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_1_s_big.mdl", "#", "#", 2, "", "-277.01, 268.511, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_2_s_big.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_2_s_big.mdl", "#", "#", 2, "", "-336.99, 328.521, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_3_s_big.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_3_s_big.mdl", "#", "#", 2, "", "-397.033, 388.521, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_4_s_big.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_4_s_big.mdl", "#", "#", 2, "", "-456.991, 448.521, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_5_s_big.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_5_s_big.mdl", "#", "#", 2, "", "-516.985, 508.521, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/curve_6_s_big.mdl", "#", "#", 1, "", "-0.007, -8.504, 1"})
  PIECES:Record({"models/minitrains/curve_6_s_big.mdl", "#", "#", 2, "", "-576.985, 568.521, 1", "0,180,0"})
  PIECES:Record({"models/minitrains/rerailer.mdl", "#", "Rerailer Double", 1, "", "190, 0, 1.01758"})
  PIECES:Record({"models/minitrains/rerailer.mdl", "#", "Rerailer Double", 2, "", "-190, 0, 1.01758", "0,180,0"})
  PIECES:Record({"models/minitrains/sw_buffer_stop.mdl", "#", "Buffer Stop", 1, "", "9.43, -8.011, -1", "0,-180,0"})
  PIECES:Record({"models/minitrains/switch.mdl", "#", "Switch Y", 1, "", "0, -8.509, 1", "", "gmod_sw_minitrain_switch"})
  PIECES:Record({"models/minitrains/switch.mdl", "#", "Switch Y", 2, "", "-128, 6.493, 1", "0,-180,0", "gmod_sw_minitrain_switch"})
  PIECES:Record({"models/minitrains/switch.mdl", "#", "Switch Y", 3, "", "-128, -23.512, 1", "0,-180,0","gmod_sw_minitrain_switch"})
  PIECES:Record({"models/minitrains/switch_double.mdl", "#", "#", 1, "", "16,21.5135,1", "", "gmod_sw_minitrain_doubleswitch"})
  PIECES:Record({"models/minitrains/switch_double.mdl", "#", "#", 2, "", "-144,21.5135,1", "0,180,0", "gmod_sw_minitrain_doubleswitch"})
  PIECES:Record({"models/minitrains/switch_double.mdl", "#", "#", 3, "", "16,-8.51317,1", "", "gmod_sw_minitrain_doubleswitch"})
  PIECES:Record({"models/minitrains/switch_double.mdl", "#", "#", 4, "", "-144,-8.51317,1", "0,180,0", "gmod_sw_minitrain_doubleswitch"})
  PIECES:Record({"models/minitrains/switch_w_1_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_w1"})
  PIECES:Record({"models/minitrains/switch_w_1_128.mdl", "#", "#", 2, "", "-97.94826,32.05148,1", "0,135,0", "gmod_sw_minitrain_switch_w1"})
  PIECES:Record({"models/minitrains/switch_w_1_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_w1"})
  PIECES:Record({"models/minitrains/switch_w_1_128.mdl", "#", "#", 4, "", "-97.94826,-49.05152,1", "0,-135,0", "gmod_sw_minitrain_switch_w1"})
  PIECES:Record({"models/minitrains/switch_w_2_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_w2"})
  PIECES:Record({"models/minitrains/switch_w_2_128.mdl", "#", "#", 2, "", "-119.15060, 40.84935,1", "0, 135,0", "gmod_sw_minitrain_switch_w2"})
  PIECES:Record({"models/minitrains/switch_w_2_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,-180,0", "gmod_sw_minitrain_switch_w2"})
  PIECES:Record({"models/minitrains/switch_w_2_128.mdl", "#", "#", 4, "", "-119.15061,-57.84934,1", "0,-135,0", "gmod_sw_minitrain_switch_w2"})
  PIECES:Record({"models/minitrains/switch_w_3_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_w3"})
  PIECES:Record({"models/minitrains/switch_w_3_128.mdl", "#", "#", 2, "", "-140.36781,49.63218,1", "0,135,0", "gmod_sw_minitrain_switch_w3"})
  PIECES:Record({"models/minitrains/switch_w_3_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_w3"})
  PIECES:Record({"models/minitrains/switch_w_3_128.mdl", "#", "#", 4, "", "-140.36781,-66.63219,1", "0,-135,0", "gmod_sw_minitrain_switch_w3"})
  PIECES:Record({"models/minitrains/switch_w_4_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_w4"})
  PIECES:Record({"models/minitrains/switch_w_4_128.mdl", "#", "#", 2, "", "-87.45033,8.87626,1", "0,157.5,0", "gmod_sw_minitrain_switch_w4"})
  PIECES:Record({"models/minitrains/switch_w_4_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_w4"})
  PIECES:Record({"models/minitrains/switch_w_4_128.mdl", "#", "#", 4, "", "-87.45378,-25.86791,1", "0,-157.5,0", "gmod_sw_minitrain_switch_w4"})
  PIECES:Record({"models/minitrains/switch_w_5_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_w5"})
  PIECES:Record({"models/minitrains/switch_w_5_128.mdl", "#", "#", 2, "", "-98.92384,11.17581,1", "0,157.5,0", "gmod_sw_minitrain_switch_w5"})
  PIECES:Record({"models/minitrains/switch_w_5_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_w5"})
  PIECES:Record({"models/minitrains/switch_w_5_128.mdl", "#", "#", 4, "", "-98.92188,-28.17954,1", "0,-157.5,0", "gmod_sw_minitrain_switch_w5"})
  PIECES:Record({"models/minitrains/switch_w_6_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_w6"})
  PIECES:Record({"models/minitrains/switch_w_6_128.mdl", "#", "#", 2, "", "-110.40305,13.45934,1", "0,157.5,0", "gmod_sw_minitrain_switch_w6"})
  PIECES:Record({"models/minitrains/switch_w_6_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_w6"})
  PIECES:Record({"models/minitrains/switch_w_6_128.mdl", "#", "#", 4, "", "-110.40065,-30.46272,1", "0,-157.5,0", "gmod_sw_minitrain_switch_w6"})
  PIECES:Record({"models/minitrains/switch_y_1_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_y1"})
  PIECES:Record({"models/minitrains/switch_y_1_128.mdl", "#", "#", 2, "", "-97.94826,32.05148,1", "0,135,0", "gmod_sw_minitrain_switch_y1"})
  PIECES:Record({"models/minitrains/switch_y_1_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_y1"})
  PIECES:Record({"models/minitrains/switch_y_2_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_y2"})
  PIECES:Record({"models/minitrains/switch_y_2_128.mdl", "#", "#", 2, "", "-119.15060, 40.84935,1", "0, 135,0", "gmod_sw_minitrain_switch_y2"})
  PIECES:Record({"models/minitrains/switch_y_2_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,-180,0", "gmod_sw_minitrain_switch_y2"})
  PIECES:Record({"models/minitrains/switch_y_3_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_y3"})
  PIECES:Record({"models/minitrains/switch_y_3_128.mdl", "#", "#", 2, "", "-140.36781,49.63218,1", "0,135,0", "gmod_sw_minitrain_switch_y3"})
  PIECES:Record({"models/minitrains/switch_y_3_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_y3"})
  PIECES:Record({"models/minitrains/switch_y_4_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_y4"})
  PIECES:Record({"models/minitrains/switch_y_4_128.mdl", "#", "#", 2, "", "-87.45033,8.87626,1", "0,157.5,0", "gmod_sw_minitrain_switch_y4"})
  PIECES:Record({"models/minitrains/switch_y_4_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_y4"})
  PIECES:Record({"models/minitrains/switch_y_5_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_y5"})
  PIECES:Record({"models/minitrains/switch_y_5_128.mdl", "#", "#", 2, "", "-98.92384,11.17581,1", "0,157.5,0", "gmod_sw_minitrain_switch_y5"})
  PIECES:Record({"models/minitrains/switch_y_5_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_y5"})
  PIECES:Record({"models/minitrains/switch_y_6_128.mdl", "#", "#", 1, "", "0,-8.5,1", "", "gmod_sw_minitrain_switch_y6"})
  PIECES:Record({"models/minitrains/switch_y_6_128.mdl", "#", "#", 2, "", "-110.40305,13.45934,1", "0,157.5,0", "gmod_sw_minitrain_switch_y6"})
  PIECES:Record({"models/minitrains/switch_y_6_128.mdl", "#", "#", 3, "", "-128,-8.5,1", "0,180,0", "gmod_sw_minitrain_switch_y6"})
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
  asmlib.ModelToNameRule("SET",{1,6})
  PIECES:Record({"models/props_phx/trains/tracks/track_single.mdl", "#", "#", 1, "-0.327,-61.529,8.714", " 15.451782, 1.5e-005,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_single.mdl", "#", "#", 2, "-0.327, 61.529,8.714", "-16.094971,-1.0e-006,12.548828", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_1x.mdl", "#", "#", 1, "", " 79.929352,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_1x.mdl", "#", "#", 2, "", "-70.058060,6e-006,12.548828", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_crossing.mdl", "#", "Cross 90", 1, "", " 74.973145, 1e-005,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_crossing.mdl", "#", "Cross 90", 2, "", "-75.013794,-7e-006,12.548828", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_crossing.mdl", "#", "Cross 90", 3, "", "-0.022434 , 74.999878,12.548828", "0,90,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_crossing.mdl", "#", "Cross 90", 4, "", "-0.022434 ,-74.987061,12.548828", "0,-90,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_2x.mdl", "#", "#", 1, "", "229.919388,0,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_2x.mdl", "#", "#", 2, "", "-70.05806,-6e-006,12.548828", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_4x.mdl", "#", "#", 1, "", " 229.919388, 3.1e-005,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_4x.mdl", "#", "#", 2, "", "-370.037079,-3.2e-005,12.548828", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_pass.mdl", "#", "Cross Road", 1, "", " 229.920044,2e-005,11.214844"})
  PIECES:Record({"models/props_phx/trains/tracks/track_pass.mdl", "#", "Cross Road", 2, "", "-370.036377,2e-006,11.214844", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_8x.mdl", "#", "#", 1, "", " 829.878418, 3.8e-005,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_8x.mdl", "#", "#", 2, "", "-370.036865,-2.5e-005,12.548828", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_16x.mdl", "#", "#", 1, "", "2029.797363,0.000133,12.548828"})
  PIECES:Record({"models/props_phx/trains/tracks/track_16x.mdl", "#", "#", 2, "", "-370.036865,-2e-0060,12.548828", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_x.mdl", "#", "Cross 45", 1, "", " 250.473389,  49.613159,11.214844"})
  PIECES:Record({"models/props_phx/trains/tracks/track_x.mdl", "#", "Cross 45", 2, "", "-349.483032,  49.613129,11.214844", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_x.mdl", "#", "Cross 45", 3, "", " 162.610229,-162.4935  ,11.214844", "0, -45,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_x.mdl", "#", "Cross 45", 4, "", "-261.623718, 261.740234,11.214844", "0, 135,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_225_down.mdl", "#", "#", 1, "", "-75.016,-0.006,64.57", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_225_down.mdl", "#", "#", 2, "", "4.096,-0.007,48.791", "22.5,0,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_225_up.mdl", "#", "#", 1, "", "-75.016,0.007,11.212", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_225_up.mdl", "#", "#", 2, "", "4.196,0,27.054", "-22.5,0,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_45_down.mdl", "#", "#", 1, "-75.016,-0.002,64.568", "-75.013,-0.002,64.568", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_45_down.mdl", "#", "#", 2, "", "71.037,-0.018,3.951", "45,0,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_45_up.mdl", "#", "#", 1, "", "-75.013,0.007,11.218", "0,180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_45_up.mdl", "#", "#", 2, "", "71.173,0.003,71.909", "-45,0,0"})
  asmlib.ModelToNameRule("SET",{1,6},{"turn","turn_"})
  PIECES:Record({"models/props_phx/trains/tracks/track_turn45.mdl", "#", "#", 1, "", "733.000061,-265.363037,11.218994"})
  PIECES:Record({"models/props_phx/trains/tracks/track_turn45.mdl", "#", "#", 2, "", "-83.264610,  72.744667,11.218994", "0,135,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_turn90.mdl", "#", "#", 1, "", "733.000061,-265.363037,11.218994"})
  PIECES:Record({"models/props_phx/trains/tracks/track_turn90.mdl", "#", "#", 2, "", "-421.363312,889.005493,11.218994", "0,90,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch.mdl", "#", "Switch Right", 1, "", " 829.879700,0.00158700, 11.218994"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch.mdl", "#", "Switch Right", 2, "", "-370.037231,0.00025600, 11.218994", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch.mdl", "#", "Switch Right", 3, "", "-158.311737,338.107941, 11.218994", "0,135,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch2.mdl", "#", "Switch Left [X]", 1, "", " 829.880005,  -0.001465, 11.218994"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch2.mdl", "#", "Switch Left [X]", 2, "", "-370.037262,  -0.000456, 11.218994", "0,-180,0"})
  PIECES:Record({"models/props_phx/trains/tracks/track_switch2.mdl", "#", "Switch Left [X]", 3, "", "-158.311356,-338.111572, 11.218994", "0,-135,0"})
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
    local r = g:match(".-_"):sub(1, -2); g = g:gsub(r.."_", "")
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
  asmlib.Categorize("SligWolf's Railcar")
  PIECES:Record({"models/swrcs/swrccross.mdl", "#", "Switcher Cross", 1, "", "500,0,0"})
  PIECES:Record({"models/swrcs/swrccross.mdl", "#", "Switcher Cross", 2, "", "-2673,0,0", "0,180,0"})
  PIECES:Record({"models/swrcs/swrccurve001.mdl", "#", "U-Turn", 1, "", "890, 748.009, 2.994"})
  PIECES:Record({"models/swrcs/swrccurve001.mdl", "#", "U-Turn", 2, "", "890, 451.998, 2.994"})
  PIECES:Record({"models/swrcs/swrccurve001.mdl", "#", "U-Turn", 3, "", "890, -452.001, 2.974"})
  PIECES:Record({"models/swrcs/swrccurve001.mdl", "#", "U-Turn", 4, "", "890, -748.027, 2.974"})
  PIECES:Record({"models/swrcs/swrclooping.mdl", "#", "Loop 180", 1, "", "810, -252.447, -0.005"})
  PIECES:Record({"models/swrcs/swrclooping.mdl", "#", "Loop 180", 2, "", "-809.999, 136.997, -0.002", "0,180,0"})
  PIECES:Record({"models/swrcs/swrcloopingspecial.mdl", "#", "LoopSwitch 180", 1, "", "927.001, -194.403, -0.036"})
  PIECES:Record({"models/swrcs/swrcloopingspecial.mdl", "#", "LoopSwitch 180", 2, "", "-809.999, 137.003, 350.984", "0,-180,0"})
  PIECES:Record({"models/swrcs/swrcloopingspecial.mdl", "#", "LoopSwitch 180", 3, "", "-809.999, -527.972, 350.984", "0,-180,0"})
  PIECES:Record({"models/swrcs/swrcramp.mdl", "#", "Ramp 45", 1, "", "1000, 0, 0"})
  PIECES:Record({"models/swrcs/swrcramp.mdl", "#", "Ramp 45", 2, "", "-641.92, 0, 269.672", "-45,-180,0"})
  PIECES:Record({"models/swrcs/swrctraffic_lights.mdl", "#", "Start Lights", 1, "", "0, -152.532, 0"})
  PIECES:Record({"models/swrcs/swrctraffic_lights.mdl", "#", "Start Lights", 2, "", "0, 152.554, 0"})
  PIECES:Record({"models/swrcs/swrctraffic_lights.mdl", "#", "Start Lights", 3, "", "0, 0, 0.042"})
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
  asmlib.Categorize("SligWolf's White Rails",[[function(m)
    local g = m:gsub("models/sligwolf/rails/",""):gsub("/","_")
    local r = g:match(".-_"):sub(1, -2); g = g:gsub(r.."_", "")
    local t, n = g:match(".-_"), g:gsub("%.mdl","")
    if(t) then t = t:sub(1, -2); g = g:gsub(r.."_", "")
      if(r:find(t)) then n = n:gsub(t.."_", "") end
    end; return r, n; end]])
  PIECES:Record({"models/sligwolf/rails/straight_128.mdl" , "#", "#", 1, "", "   0,-46,6.625"})
  PIECES:Record({"models/sligwolf/rails/straight_128.mdl" , "#", "#", 2, "", "-128,-46,6.625", "0,-180,0"})
  PIECES:Record({"models/sligwolf/rails/straight_256.mdl" , "#", "#", 1, "", "   0,-46,6.625"})
  PIECES:Record({"models/sligwolf/rails/straight_256.mdl" , "#", "#", 2, "", "-256,-46,6.625", "0,-180,0"})
  PIECES:Record({"models/sligwolf/rails/straight_512.mdl" , "#", "#", 1, "", "   0,-46,6.625"})
  PIECES:Record({"models/sligwolf/rails/straight_512.mdl" , "#", "#", 2, "", "-512,-46,6.625", "0,-180,0"})
  PIECES:Record({"models/sligwolf/rails/straight_1024.mdl", "#", "#", 1, "", "   0,-46,6.625"})
  PIECES:Record({"models/sligwolf/rails/straight_1024.mdl", "#", "#", 2, "", "-1024,-46,6.625", "0,-180,0"})
  PIECES:Record({"models/sligwolf/rails/buffer.mdl"   , "#", "#", 1, "", "-82,0,6.28418"})
  PIECES:Record({"models/sligwolf/rails/curve_225.mdl", "#", "#", 1, "", "0,-46,6.625"})
  PIECES:Record({"models/sligwolf/rails/curve_225.mdl", "#", "#", 2, "", "-766.13226318359,-198.39318847656,6.625", "0,-157.5,0"})
  PIECES:Record({"models/sligwolf/rails/curve_45.mdl" , "#", "#", 1, "", "0,-46,6.625"})
  PIECES:Record({"models/sligwolf/rails/curve_45.mdl" , "#", "#", 2, "", "-1415.6279296875,-632.37231445313,6.625", "0,-135,0"})
  PIECES:Record({"models/sligwolf/rails/curve_90.mdl" , "#", "#", 1, "", "0,-46,6.625"})
  PIECES:Record({"models/sligwolf/rails/curve_90.mdl" , "#", "#", 2, "", "-2002,-2048,6.625", "0,-90,0"})
  PIECES:Record({"models/sligwolf/rails/switch_225_y.mdl", "#", "#", 1, "", "0,-46,6.625", "","gmod_sw_modelpack_switch_y"})
  PIECES:Record({"models/sligwolf/rails/switch_225_y.mdl", "#", "#", 2, "", "-766.132,-198.393, 6.625", "0,-157.5,0","gmod_sw_modelpack_switch_y"})
  PIECES:Record({"models/sligwolf/rails/switch_225_y.mdl", "#", "#", 3, "", "-766.122, 106.393, 6.625", "0, 157.5,0","gmod_sw_modelpack_switch_y"})
  PIECES:Record({"models/sligwolf/rails/switch_225_r.mdl", "#", "#", 1, "", "0,-46,6.625", "","gmod_sw_modelpack_switch_r"})
  PIECES:Record({"models/sligwolf/rails/switch_225_r.mdl", "#", "#", 2, "", "-768,-46,6.625", "0,-180,0","gmod_sw_modelpack_switch_r"})
  PIECES:Record({"models/sligwolf/rails/switch_225_r.mdl", "#", "#", 3, "", "-766.122, 106.393, 6.625", "0, 157.5,0","gmod_sw_modelpack_switch_r"})
  PIECES:Record({"models/sligwolf/rails/switch_225_l.mdl", "#", "#", 1, "", "0,-46,6.625", "","gmod_sw_modelpack_switch_l"})
  PIECES:Record({"models/sligwolf/rails/switch_225_l.mdl", "#", "#", 2, "", "-768,-46,6.625", "0,-180,0","gmod_sw_modelpack_switch_l"})
  PIECES:Record({"models/sligwolf/rails/switch_225_l.mdl", "#", "#", 3, "", "-766.132,-198.393, 6.625", "0,-157.5,0","gmod_sw_modelpack_switch_l"})
  asmlib.Categorize("SligWolf's Minihover",[[function(m)
    local n = m:gsub("models/sligwolf/minihover/hover_","")
    local r = n:match("%a+"); n = n:gsub("%.mdl",""); return r, n; end]])
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x4_small.mdl"     , "#", "#", 1, "", " 104, 32,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x4_small.mdl"     , "#", "#", 2, "", "-104, 32,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x4_mid.mdl"       , "#", "#", 1, "", " 208, 32,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x4_mid.mdl"       , "#", "#", 2, "", "-208, 32,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x4_long.mdl"      , "#", "#", 1, "", " 312, 32,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x4_long.mdl"      , "#", "#", 2, "", "-312, 32,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_small.mdl"     , "#", "#", 1, "", " 104,-16,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_small.mdl"     , "#", "#", 2, "", "-104,-16,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_mid.mdl"       , "#", "#", 1, "", " 208,-16,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_mid.mdl"       , "#", "#", 2, "", "-208,-16,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_long.mdl"      , "#", "#", 1, "", " 312,-16,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_long.mdl"      , "#", "#", 2, "", "-312,-16,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_splitter.mdl"  , "#", "#", 1, "", "-104, 80 ,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_splitter.mdl"  , "#", "#", 2, "", " 312, 30 ,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_splitter.mdl"  , "#", "#", 3, "", " 312, 130,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_splitter_i.mdl", "#", "#", 1, "", " 104,-80 ,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_splitter_i.mdl", "#", "#", 2, "", "-312,-30 ,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_splitter_i.mdl", "#", "#", 3, "", "-312,-130,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_to_x4.mdl"     , "#", "#", 1, "", " 104, 16 ,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_to_x4.mdl"     , "#", "#", 2, "", "-312, 16 ,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_to_x4_i.mdl"   , "#", "#", 1, "", " 104, 16 ,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_straight_x8_to_x4_i.mdl"   , "#", "#", 2, "", "-312, 16 ,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_trackend_x4.mdl"           , "#", "#", 1, "", " 52, 32,1.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_trackend_x4.mdl"           , "#", "#", 2, "", "-52, 32,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_trackend_x4_i.mdl"         , "#", "#", 1, "", " 52, 32,1.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_trackend_x4_i.mdl"         , "#", "#", 2, "", "-52, 32,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_trackend_x8.mdl"           , "#", "#", 1, "", " 52,-16,1.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_trackend_x8.mdl"           , "#", "#", 2, "", "-52,-16,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_trackend_x8_i.mdl"         , "#", "#", 1, "", " 52,-16,1.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_trackend_x8_i.mdl"         , "#", "#", 2, "", "-52,-16,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_ramp_small.mdl"            , "#", "#", 1, "", "-26, 28, 5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_ramp_small.mdl"            , "#", "#", 2, "", "157.1996,28,83.378784", "-52.5,0,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_ramp_small_i.mdl"          , "#", "#", 1, "", "-26, 28, 5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_ramp_small_i.mdl"          , "#", "#", 2, "", "157.1996,28,83.378784", "-52.5,0,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_ramp.mdl"                  , "#", "#", 1, "", "-26,-20,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_ramp.mdl"                  , "#", "#", 2, "", "157.184906,-20,83.365128", "-52.5,0,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_ramp_i.mdl"                , "#", "#", 1, "", "-26,-20,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_ramp_i.mdl"                , "#", "#", 2, "", "157.184906,-20,83.365128", "-52.5,0,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop_quarter.mdl"          , "#", "#", 1, "", "-25.99988,-19.999998,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop_quarter.mdl"          , "#", "#", 2, "", "198.190018,-20,229.959763", "-90,0,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop_quarter_i.mdl"        , "#", "#", 1, "", "-25.99988,-19.999998,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop_quarter_i.mdl"        , "#", "#", 2, "", "198.190018,-20,229.959763", "-90,0,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_bow_small.mdl"             , "#", "#", 1, "", "157.982788,27.999634,83.837219"  })
  PIECES:Record({"models/sligwolf/minihover/hover_bow_small.mdl"             , "#", "#", 2, "", "-27.439621,28.012085,5.100098"   , "52.5,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_bow_small_i.mdl"           , "#", "#", 1, "", "157.982788,27.999634,83.837219"  })
  PIECES:Record({"models/sligwolf/minihover/hover_bow_small_i.mdl"           , "#", "#", 2, "", "-27.439621,28.012085,5.100098"   , "52.5,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_bow.mdl"                   , "#", "#", 1, "", "157.982285,-19.999878,83.837341" })
  PIECES:Record({"models/sligwolf/minihover/hover_bow.mdl"                   , "#", "#", 2, "", "-27.427399,-19.999756,5.118835"  , "52.5,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_bow_i.mdl"                 , "#", "#", 1, "", "157.982285,-19.999878,83.837341" })
  PIECES:Record({"models/sligwolf/minihover/hover_bow_i.mdl"                 , "#", "#", 2, "", "-27.427399,-19.999756,5.118835"  , "52.5,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop1.mdl"                 , "#", "#", 1, "", "104.00061,136.000061 ,5.81"   })
  PIECES:Record({"models/sligwolf/minihover/hover_loop1.mdl"                 , "#", "#", 2, "", "-103.999908,32.000008,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop1i.mdl"                , "#", "#", 1, "", "103.999817,-136,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop1i.mdl"                , "#", "#", 2, "", "-103.999939,-32,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop2.mdl"                 , "#", "#", 1, "", "103.999878,227.998291,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop2.mdl"                 , "#", "#", 2, "", "-103.999939,19.998779,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop2i.mdl"                , "#", "#", 1, "", "103.999939,-227.999084,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_loop2i.mdl"                , "#", "#", 2, "", "-103.999878,-19.999634,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_45.mdl"            , "#", "#", 1, "", "0.000114,-95.999878,5.81"  , "0, 180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_45.mdl"            , "#", "#", 2, "", "101.823112,-53.823227,5.81", "0,  45,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_45_i.mdl"          , "#", "#", 1, "", "0.000144, 95.999756,5.81"  , "0, 180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_45_i.mdl"          , "#", "#", 2, "", "101.823288,53.82341,5.81"  , "0, -45,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_45_s.mdl"          , "#", "#", 1, "", "203.999496,-12.000174,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_45_s.mdl"          , "#", "#", 2, "", "0.000535,-95.999512,5.81"  , "0, 180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_45_s_i.mdl"        , "#", "#", 1, "", "203.999725,12.000124,5.81" })
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_45_s_i.mdl"        , "#", "#", 2, "", "0.000274,96.000008,5.81"   , "0, 180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_90.mdl"            , "#", "#", 1, "", "144,47.999947,5.81", "0,90,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_90.mdl"            , "#", "#", 2, "", "0.000122,-95.999756,5.81" , "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_90_i.mdl"          , "#", "#", 1, "", "144,-47.999886,5.81", "0,-90,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_1_90_i.mdl"          , "#", "#", 2, "", "6.1e-005,95.999756,5.81", "0, 180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_45.mdl"            , "#", "#", 1, "", "237.587524,2.412376,5.81", "0,45,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_45.mdl"            , "#", "#", 2, "", "0.000122,-95.999756,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_45_i.mdl"          , "#", "#", 1, "", "237.587646,-2.412163,5.81", "0,-45,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_45_i.mdl"          , "#", "#", 2, "", "6.1e-005,95.999756  ,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_45_s.mdl"          , "#", "#", 1, "", "475.999939,99.999634,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_45_s.mdl"          , "#", "#", 2, "", "0.000108,-95.999756,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_45_s_i.mdl"        , "#", "#", 1, "", "475.999908,-99.999756,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_45_s_i.mdl"        , "#", "#", 2, "", "0.0001,95.999756,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_90.mdl"            , "#", "#", 1, "", "335.999756,239.999954,5.81", "0,90,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_90.mdl"            , "#", "#", 2, "", "0.000122,-95.999756,5.81"  , "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_90_i.mdl"          , "#", "#", 1, "", "335.999756,-239.999954,5.81", "0,-90,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_2_90_i.mdl"          , "#", "#", 2, "", "6.9e-005,95.999756,5.81"    , "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_45.mdl"            , "#", "#", 1, "", "373.352264,58.647644,5.81", "0,45,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_45.mdl"            , "#", "#", 2, "", "0.000107,-95.999756,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_45_i.mdl"          , "#", "#", 1, "", "373.352448,-58.647461,5.81", "0,-45,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_45_i.mdl"          , "#", "#", 2, "", "9.2e-005,96,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_45_s.mdl"          , "#", "#", 1, "", "745.999939,214.000244,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_45_s.mdl"          , "#", "#", 2, "", "0.000107,-95.999756,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_45_s_i.mdl"        , "#", "#", 1, "", "745.999939,-214,5.81"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_45_s_i.mdl"        , "#", "#", 2, "", "9.2e-005,96,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_90.mdl"            , "#", "#", 1, "", "0.000107,-95.999756,5.81", "0,-180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_90.mdl"            , "#", "#", 2, "", "528,431.999939,5.81", "0,90,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_90_i.mdl"          , "#", "#", 1, "", "9.2e-005,95.999756,5.81", "0,180,0"})
  PIECES:Record({"models/sligwolf/minihover/hover_curve_3_90_i.mdl"          , "#", "#", 2, "", "527.999756,-431.999878,5.81", "0,-90,0"})
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
  asmlib.Categorize("Modular canals",[[function(m)
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
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/yout.mdl", "#", "#", 1, "", "-27.11389,0,5.65723", "0,180,0", ""})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/yout.mdl", "#", "#", 2, "", "1412.886,-1440,5.65723", "0,-90,0", ""})
  PIECES:Record({"models/nokillnando/trackmania/ground/turns/yout.mdl", "#", "#", 3, "", "1412.886,1440,5.65723", "0,90,0", ""})
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
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/loopleft.mdl", "#", "#", 2, "", "31.69263,-1905,2574.34", "0,0,180", ""})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/loopright.mdl", "#", "#", 1, "", "28.85986,-15,5.65723"})
  PIECES:Record({"models/nokillnando/trackmania/ground/misc/loopright.mdl", "#", "#", 2, "", "28.85986,1905,2574.34", "0,0,180", ""})
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
  PIECES:Record({"models/nokillnando/trackmania/ground/jump/jumplow.mdl", "#", "#", 1, "", "-242.82343,0,5.65723", "0,-180,0", ""})
  PIECES:Record({"models/nokillnando/trackmania/ground/jump/jumphigh.mdl", "#", "#", 1, "", "-242.82343,0,5.65723", "0,-180,0", ""})
  if(gsMoDB == "SQL") then sqlCommit() end
end

if(fileExists(gsFullDSV.."PHYSPROPERTIES.txt", "DATA")) then
  asmlib.LogInstance("DB PHYSPROPERTIES from DSV",gtInitLogs)
  asmlib.ImportDSV("PHYSPROPERTIES", true)
else --- Valve's physical properties: https://developer.valvesoftware.com/wiki/Material_surface_properties
  if(gsMoDB == "SQL") then sqlBegin() end
  asmlib.LogInstance("DB PHYSPROPERTIES from LUA",gtInitLogs)
  local PHYSPROPERTIES = asmlib.GetBuilderNick("PHYSPROPERTIES"); asmlib.ModelToNameRule("CLR")
  asmlib.Categorize("Special")
  PHYSPROPERTIES:Record({"#", 1 , "default"             })
  PHYSPROPERTIES:Record({"#", 2 , "default_silent"      })
  PHYSPROPERTIES:Record({"#", 3 , "floatingstandable"   })
  PHYSPROPERTIES:Record({"#", 4 , "item"                })
  PHYSPROPERTIES:Record({"#", 5 , "ladder"              })
  PHYSPROPERTIES:Record({"#", 6 , "no_decal"            })
  PHYSPROPERTIES:Record({"#", 7 , "player"              })
  PHYSPROPERTIES:Record({"#", 8 , "player_control_clip" })
  asmlib.Categorize("Concrete")
  PHYSPROPERTIES:Record({"#", 1 , "brick"          })
  PHYSPROPERTIES:Record({"#", 2 , "concrete"       })
  PHYSPROPERTIES:Record({"#", 3 , "concrete_block" })
  PHYSPROPERTIES:Record({"#", 4 , "gravel"         })
  PHYSPROPERTIES:Record({"#", 5 , "rock"           })
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
  asmlib.Categorize("Wood")
  PHYSPROPERTIES:Record({"#", 1 , "wood"          })
  PHYSPROPERTIES:Record({"#", 2 , "Wood_Box"      })
  PHYSPROPERTIES:Record({"#", 3 , "Wood_Furniture"})
  PHYSPROPERTIES:Record({"#", 4 , "Wood_Plank"    })
  PHYSPROPERTIES:Record({"#", 5 , "Wood_Panel"    })
  PHYSPROPERTIES:Record({"#", 6 , "Wood_Solid"    })
  asmlib.Categorize("Terrain")
  PHYSPROPERTIES:Record({"#", 1 , "dirt"          })
  PHYSPROPERTIES:Record({"#", 2 , "grass"         })
  PHYSPROPERTIES:Record({"#", 3 , "gravel"        })
  PHYSPROPERTIES:Record({"#", 4 , "mud"           })
  PHYSPROPERTIES:Record({"#", 5 , "quicksand"     })
  PHYSPROPERTIES:Record({"#", 6 , "sand"          })
  PHYSPROPERTIES:Record({"#", 7 , "slipperyslime" })
  PHYSPROPERTIES:Record({"#", 8 , "antlionsand"   })
  asmlib.Categorize("Liquid")
  PHYSPROPERTIES:Record({"#", 1 , "slime" })
  PHYSPROPERTIES:Record({"#", 2 , "water" })
  PHYSPROPERTIES:Record({"#", 3 , "wade"  })
  asmlib.Categorize("Frozen")
  PHYSPROPERTIES:Record({"#", 1 , "snow"      })
  PHYSPROPERTIES:Record({"#", 2 , "ice"       })
  PHYSPROPERTIES:Record({"#", 3 , "gmod_ice"  })
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
  if(gsMoDB == "SQL") then sqlCommit() end
end

if(fileExists(gsFullDSV.."ADDITIONS.txt", "DATA")) then
  asmlib.LogInstance("DB ADDITIONS from DSV",gtInitLogs)
  asmlib.ImportDSV("ADDITIONS", true)
else
  if(gsMoDB == "SQL") then sqlBegin() end
  asmlib.LogInstance("DB ADDITIONS from LUA",gtInitLogs)
  local ADDITIONS = asmlib.GetBuilderNick("ADDITIONS"); asmlib.ModelToNameRule("CLR")
  if(gsMoDB == "SQL") then sqlCommit() end
end

asmlib.LogInstance("Version: "..asmlib.GetOpVar("TOOL_VERSION"), gtInitLogs)
collectgarbage()
