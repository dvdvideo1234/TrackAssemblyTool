--[[
 * The purpose of this Lua file is to add your track pack pieces to the
 * track assembly tool, so they can appear in the tool selection menu.
 * Why the name starts with /z/ you may ask. When Gmod loads the game
 * it goes trough all the Lua addons alphabetically.
 * That means your file name ( The file you are reading right now )
 * must be greater alphabetically than /trackasmlib/, so the API of the
 * module can be loaded before you can use it like seen below.
]]--

-- Local reference to the module.
local asmlib = trackasmlib; if(not asmlib) then -- Module present
  ErrorNoHaltWithStack("TOOL: Track assembly tool module fail!\n"); return end

--[[
 * This is your addon name. It is mandatory and it must be string.
 * It is used by TA in order to classify the content you are creating
 * It must NOT be an empty string nil or any other type regarding
 * The value will be automatically pattern converted to a index prefix
]]
local myAddon = "Shinji85's Rails" -- Your addon name goes here

-- Log messages identifier. Leave DSV here or change it if you like
local mySource = "DSV"

--[[
 * Change this if you want to use different in-game type
 * You can also use multiple types myType1, myType2,
 * myType3, ... myType/n when your addon contains
 * multiple model packs.
]]--
local myType = myAddon -- The type your addon resides in the tool with

-- This is used for addon relation prefix. Fingers away from it
local myPrefix = myAddon:gsub("[^%w]","_") -- Addon prefix

-- This is the script path. It tells TA who wants to add these models
-- Do not touch this also, it is used for debugging
local myScript = tostring(debug.getinfo(1).source or "N/A")
      myScript = "@"..myScript:gsub("^%W+", ""):gsub("\\","/")
      mySource = tostring(mySource or ""):gsub("^%W+", "")
      mySource = (asmlib.IsBlank(mySource) and "DSV" or mySource)

-- Store a reference to disable symbol
local gsMissDB = asmlib.GetOpVar("MISS_NOSQL")
local gsDirDSV = asmlib.GetOpVar("DIRPATH_DSV")
local gsToolPF = asmlib.GetOpVar("TOOLNAME_PU")
local gsSymOff = asmlib.GetOpVar("OPSYM_DISABLE")

-- This is the path to your DSV
local myDsv = asmlib.GetLibraryPath(gsDirDSV, myPrefix, gsToolPF.."PIECES")

--[[
 * This flag is used when the track pieces list needs to be processed.
 * It generally represents the locking file persistence flag. It is
 * bound to finding a "PIECES" DSV external database for the prefix
 * of your addon. You can use it for boolean value deciding whenever
 * or not to run certain events. For example you can stop exporting
 * your local database every time Gmod loads, but then the user will
 * skip the available updates of your addon until he/she deletes the DSVs.
]]--
local myFlag = file.Exists(myDsv, "DATA")

--[[
 * This function defines what happens when there is an error present
 * Usually you can tell Gmod that you want it to generate an error
 * and throw the message to the log also. In this case you will not
 * have to change the function name in lots of places
 * when you need it to do something else.
--]]
local function ThrowError(vMesg)
  local sMesg = (myScript.." > ("..myAddon.."): "..tostring(vMesg)) -- Convert to string
  if(asmlib) then asmlib.LogInstance(sMesg, mySource) end -- Update the tool logs
  ErrorNoHaltWithStack(sMesg.."\n") -- Produce an error without breaking the stack
end

--[[
 * This logic statement is needed for reporting the error
 * in the console if the process fails.
 *
 @ bSuccess = trackasmlib.SynchronizeDSV(sTable, tData, bRepl, sPref, sDelim)
 * sTable > The table you want to sync
 * tData  > A data table like the one described above
 * bRepl  > If set to /true/, makes the API replace the repeating models with
            these of your addon. This is nice when you are constantly updating your track packs
            If set to /false/ keeps the current model in the
            database and ignores yours if they are the same file.
 * sPref  > An export file custom prefix. For synchronizing it must be related to your addon
 * sDelim > The delimiter used by the server/client ( default is a tab symbol )
 *
 @ bSuccess = trackasmlib.TranslateDSV(sTable, sPref, sDelim)
 * sTable > The table you want to translate to Lua script
 * sPref  > An export file custom prefix. For synchronizing it must be related to your addon
 * sDelim > The delimiter used by the server/client ( default is a tab symbol )
]]--
local function DoSynchronize(sName, tData, bRepl)
  local sRep = asmlib.GetReport(myPrefix, sName) -- Generate report if error is present
  if(not asmlib.IsEmpty(tData)) then -- Something to be processed. Do stuff when the table is not empty
    asmlib.LogInstance("Synchronization START "..sRep, mySource) -- Signal start synchronization
    if(not asmlib.SynchronizeDSV(sName, tData, bRepl, myPrefix)) then -- Attempt to synchronize
      ThrowError("Failed to synchronize content") -- Raise error when fails to sync tracks data
    else -- Successful. You are saving me from all the work for manually generating these
      asmlib.LogInstance("Translation START "..sRep, mySource) -- Signal start translation
      if(not asmlib.TranslateDSV(sName, myPrefix)) then -- Attempt to translate the DSV to Lua source
        ThrowError("Failed to translate content") end -- Raise error when fails
      asmlib.LogInstance("Translation OK "..sRep, mySource) -- Translation is successful
    end -- Now we have Lua inserts and DSV. Otherwise sent empty table and print status in logs
  else asmlib.LogInstance("Synchronization EMPTY "..sRep, mySource) end -- Nothing to be done
end

--[[
 * Register the addon to the auto-load prefix list when the
 * PIECES file is missing. The auto-load list is located in
 * (/garrysmod/data/trackassembly/set/trackasmlib_dsv.txt)
 * a.k.a the DATA folder of Garry's mod.
 *
 * @bSuccess = trackasmlib.RegisterDSV(sProg, sPref, sDelim)
 * sProg  > The program which registered the DSV
 * sPref  > The external data prefix to be added ( default instance prefix )
 * sDelim > The delimiter to be used for processing ( default tab )
 * bSkip  > Skip addition for the DSV prefix if exists ( default `false` )
]]--
local function DoRegister(bSkip)
  local sRep = asmlib.GetReport(myPrefix, bSkip) -- Generate report if error is present
  asmlib.LogInstance("Registration START "..sRep, mySource)
  if(bSkip) then -- Your DSV must be registered only once when loading for the first time
    asmlib.LogInstance("Registration SKIP "..sRep, mySource)
  else -- If the locking file is not located that means this is the first run of your script
    if(not asmlib.RegisterDSV(myScript, myPrefix)) then -- Register the DSV prefix and check for error
      ThrowError("Failed to register content") -- Throw the error if fails
    end -- Third argument is the delimiter. The default tab is used
    asmlib.LogInstance("Registration OK "..sRep, mySource)
  end
end

--[[
 * This logic statement is needed for reporting the error in the console if the
 * process fails.
 *
 @ bSuccess = trackasmlib.ExportCategory(nInd, tData, sPref)
 * nInd   > The index equal indent format to be stored with ( generally = 3 )
 * tData  > The category functional definition you want to use to divide your stuff with
 * sPref  > An export file custom prefix. For synchronizing
 *          it must be related to your addon ( default is instance prefix )
]]--
local function DoCategory(tCatg)
  local sRep = asmlib.GetReport(myPrefix, bSkip) -- Generate report if error is present
  asmlib.LogInstance("Category export START "..sRep, mySource)
  if(CLIENT) then -- Category handling is client side only
    if(not asmlib.IsEmpty(tCatg)) then
      if(not asmlib.ExportCategory(3, tCatg, myPrefix)) then
        ThrowError("Failed to synchronize category")
      end; asmlib.LogInstance("Category export OK "..sRep, mySource)
    else asmlib.LogInstance("Category export SKIP "..sRep, mySource) end
  else asmlib.LogInstance("Category export SERVER "..sRep, mySource) end
end

-- Tell TA what custom script we just called don't touch it
asmlib.LogInstance(">>> "..myScript.." ("..tostring(myFlag).."): {"..myAddon..", "..myPrefix.."}", mySource)

-- Register the addon to the workshop ID list
asmlib.WorkshopID(myAddon, "326640186")

-- Register the addon to the plugable DSV list
local bS, vO = pcall(DoRegister, myFlag)
if(not bS) then ThrowError("Registration error: "..vO) end

--[[
 * This is used if you want to make internal categories for your addon
 * You must make a function as a string under the hash of your addon
 * The function must take only one argument and that is the model
 * For every sub-category of your track pieces, you must return a table
 * with that much elements or return a /nil/ value to add the piece to
 * the root of your branch. You can also return a second value if you
 * want to override the track piece name. If you need to use categories
 * for multiple track types, just put their hashes in  the table below
 * and make every track point to its dedicated category handler.
]]--
local myCategory = {
  [myType] = {Txt = [[
    function(m) local c
    local r = m:gsub("models/shinji85/train/rail_", "")
    if(r:find("cross")) then c = "crossing"
    elseif(r:find("switch")) then c = "switch"
    elseif(r:find("curve")) then c = "curve"
    elseif(r:find("bumper")) then c = "bumper"
    elseif(r:find("junction")) then c = "junction"
    elseif(r:find("%dx")) then c = "straight" end; return c end
  ]]}
}

-- Register the addon category to the plugable DSV list
local bS, vO = pcall(DoCategory, myCategory)
if(not bS) then ThrowError("Category error: "..vO) end

--[[
 * Create a table and populate it as shown below
 * In the square brackets goes your MODEL,
 * and then for every active point, you must have one array of
 * strings, where the elements match the following data settings.
 * You can use the disable event /#/ to make TA auto-fill
 * the value provided and you can also add multiple track types myType[1-n].
 * If you need to use piece origin/angle with model attachment, you must use
 * the attachment extraction event /!/. The model attachment format is
 * /!<attachment_name>/ and it depends what attachment name you gave it when you
 * created the model. If you need TA to extract the origin/angle from an attachment named
 * /test/ for example, you just need to put the string /!test/ in the origin/angle column for that model.
 * {MODEL, TYPE, NAME, LINEID, POINT, ORIGIN, ANGLE, CLASS}
 * MODEL  > This string contains the path to your /*.mdl/ file. It is mandatory and
 *          taken in pairs with LINEID, it forms the unique identifier of every record.
 *          When used in /DSV/ mode ( like seen below ) it is used as a hash index.
 * TYPE   > This string is the name of the type your stuff will reside in the panel.
 *          Disabling this, makes it use the value of the /DEFAULT_TYPE/ variable.
 *          If it is empty uses the string /TYPE/, so make sure you fill this.
 * NAME   > This is the name of your track piece. Put /#/ here to be auto-generated from
 *          the model ( from the last slash to the file extension ).
 * LINEID > This is the ID of the point that can be selected for building. They must be
 *          sequential and mandatory. If provided, the ID must the same as the row index under
 *          a given model key. Disabling this, makes it use the index of the current line.
 *          Use that to swap the active points around by only moving the desired row up or down.
 *          For the example table definition below, the line ID in the database will be the same.
 * POINT  > This is the location vector that TA searches and selects the related ORIGIN for.
 *          An empty string is treated as taking the ORIGIN when assuming player traces can hit the origin
 *          Disabling via /#/ makes it take the ORIGIN. Used to disable a point but keep original data
 *          You can also fill it with attachment event /!/ followed by your attachment name.
 * ORIGIN > This is the origin relative to which the next track piece position is calculated
 *          An empty string is treated as {0,0,0}. Disabling via /#/ also makes it use {0,0,0}
 *          You can also fill it with attachment event /!/ followed by your attachment name. It's mandatory
 * ANGLE  > This is the angle relative to which the forward and up vectors are calculated.
 *          An empty string is treated as {0,0,0}. Disabling via /#/ also makes it use {0,0,0}
 *          You can also fill it with attachment event /!/ followed by your attachment name. It's mandatory
 * CLASS  > This string is populated up when your entity class is not /prop_physics/ but something else
 *          used by ents.Create of the gmod ents API library. Keep this empty if your stuff is a normal prop.
 *          Disabling via /#/ makes it take the NULL value. In this case the model is spawned as a prop
]]--
local myPieces = {
  ["models/shinji85/train/rail_16x.mdl"] = {
    {myType, "Straight 16x", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Straight 16x", gsSymOff, gsMissDB, "-2048,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_1x.mdl"] = {
    {myType, "Straight 1x", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Straight 1x", gsSymOff, gsMissDB, "-128,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_2x.mdl"] = {
    {myType, "Straight 2x", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Straight 2x", gsSymOff, gsMissDB, "-256,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_4x.mdl"] = {
    {myType, "Straight 4x", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Straight 4x", gsSymOff, gsMissDB, "-512,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_4x_crossing.mdl"] = {
    {myType, "Crossing 4x", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Crossing 4x", gsSymOff, gsMissDB, "-512,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_8x.mdl"] = {
    {myType, "Straight 8x", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Straight 8x", gsSymOff, gsMissDB, "-1024,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_bumper.mdl"] = {
    {myType, "Bumper", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB}
  },
  ["models/shinji85/train/rail_cross_4x.mdl"] = {
    {myType, "Cross 4x", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Cross 4x", gsSymOff, gsMissDB, "-512,0,7.346", "0,180,0", gsMissDB},
    {myType, "Cross 4x", gsSymOff, gsMissDB, "-256,-256,7.346", "0,270,0", gsMissDB},
    {myType, "Cross 4x", gsSymOff, gsMissDB, "-256,256,7.346", "0,90,0", gsMissDB}
  },
  ["models/shinji85/train/rail_cs.mdl"] = {
    {myType, "Counter Switch", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Counter Switch", gsSymOff, gsMissDB, "-908.81165,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_csfix.mdl"] = {
    {myType, "Counter Switch Fix", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Counter Switch Fix", gsSymOff, gsMissDB, "-115.18847,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_curve_cc.mdl"] = {
    {myType, "Curve Cc", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Curve Cc", gsSymOff, gsMissDB, "-966.40515,128,7.346", "0,165,0", gsMissDB}
  },
  ["models/shinji85/train/rail_curve_r1.mdl"] = {
    {myType, "Curve R1", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Curve R1", gsSymOff, gsMissDB, "-1060.12341,139.56763,7.346", "0,165,0", gsMissDB}
  },
  ["models/shinji85/train/rail_curve_r11.mdl"] = {
    {myType, "Curve R11", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Curve R11", gsSymOff, gsMissDB, "-1086.11584,449.88458,7.346", "0,135,0", gsMissDB}
  },
  ["models/shinji85/train/rail_curve_r12.mdl"] = {
    {myType, "Curve R12", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Curve R12", gsSymOff, gsMissDB, "-905.09656,374.90414,7.346", "0,135,0", gsMissDB}
  },
  ["models/shinji85/train/rail_curve_r13.mdl"] = {
    {myType, "Curve R13", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Curve R13", gsSymOff, gsMissDB, "-724.07727,299.92276,7.346", "0,135,0", gsMissDB}
  },
  ["models/shinji85/train/rail_curve_r2.mdl"] = {
    {myType, "Curve R2", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Curve R2", gsSymOff, gsMissDB, "-993.86572,130.84471,7.346", "0,165,0", gsMissDB}
  },
  ["models/shinji85/train/rail_curve_r3.mdl"] = {
    {myType, "Curve R3", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Curve R3", gsSymOff, gsMissDB, "-927.60797,122.1218,7.346", "0,165,0", gsMissDB}
  },
  ["models/shinji85/train/rail_cx.mdl"] = {
    {myType, "Counter X", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Counter X", gsSymOff, gsMissDB, "-362.51361,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_cxfix.mdl"] = {
    {myType, "Counter X Fix", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Counter X Fix", gsSymOff, gsMissDB, "-149.48648,0,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_double_4x_crossing.mdl"] = {
    {myType, "Crossing Double 4x", gsSymOff, gsMissDB, "0,128,7.346", gsMissDB, gsMissDB},
    {myType, "Crossing Double 4x", gsSymOff, gsMissDB, "-512,128,7.346", "0,180,0", gsMissDB},
    {myType, "Crossing Double 4x", gsSymOff, gsMissDB, "0,-128,7.346", gsMissDB, gsMissDB},
    {myType, "Crossing Double 4x", gsSymOff, gsMissDB, "-512,-128,7.346", "0,180,0", gsMissDB}
  },
  ["models/shinji85/train/rail_double_bumper.mdl"] = {
    {myType, "Bumper Double", gsSymOff, gsMissDB, "0,128,7.346", gsMissDB, gsMissDB},
    {myType, "Bumper Double", gsSymOff, gsMissDB, "0,-128,7.346", gsMissDB, gsMissDB}
  },
  ["models/shinji85/train/rail_l_switch.mdl"] = {
    {myType, "Left Switch", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Left Switch", gsSymOff, gsMissDB, "-1024,0,7.346", "0,180,0", gsMissDB},
    {myType, "Left Switch", gsSymOff, gsMissDB, "-966.40515,-128,7.346", "0,195,0", gsMissDB}
  },
  ["models/shinji85/train/rail_r_switch.mdl"] = {
    {myType, "Right Switch", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "Right Switch", gsSymOff, gsMissDB, "-1024,0,7.346", "0,180,0", gsMissDB},
    {myType, "Right Switch", gsSymOff, gsMissDB, "-966.40515,128,7.346", "0,165,0", gsMissDB}
  },
  ["models/shinji85/train/rail_x_junction.mdl"] = {
    {myType, "X Junction", gsSymOff, gsMissDB, "0,0,7.346", gsMissDB, gsMissDB},
    {myType, "X Junction", gsSymOff, gsMissDB, "-494.55,0,7.346", "0,180,0", gsMissDB},
    {myType, "X Junction", gsSymOff, gsMissDB, "-33.129,-123.63866,7.346", "0,-30,0", gsMissDB},
    {myType, "X Junction", gsSymOff, gsMissDB, "-461.42175,123.63649,7.346", "0,150,0", gsMissDB}
  }
}

-- Register the addon PIECES to the plugable DSV list
local bS, vO = pcall(DoSynchronize, "PIECES", myPieces, true)
if(not bS) then ThrowError("PIECES error: "..vO) end

--[[
 * Create a table and populate it as shown below
 * In the square brackets goes your MODELBASE,
 * and then for every active point, you must have one array of
 * strings and numbers, where the elements match the following data settings.
 * {MODELBASE, MODELADD, ENTCLASS, LINEID, POSOFF, ANGOFF, MOVETYPE, PHYSINIT, DRSHADOW, PHMOTION, PHYSLEEP, SETSOLID}
 * MODELBASE > This string contains the path to your base /*.mdl/ file the additions will be attached to.
 *             It is mandatory and taken in pairs with LINEID, it forms the unique identifier of every record.
 *             When used in /DSV/ mode ( like seen below ) it is used as a hash index.
 * MODELADD  > This is the /*.mdl/ path of the addition entity. It is mandatory and cannot be disabled.
 * ENTCLASS  > This is the class of the addition entity. When disabled or missing it defaults to a normal prop.
 * LINEID    > This is the ID of the point that can be selected for building. They must be
 *             sequential and mandatory. If provided, the ID must the same as the row index under
 *             a given model key. Disabling this, makes it use the index of the current line.
 *             Use that to swap the active points around by only moving the desired row up or down.
 *             For the example table definition below, the line ID in the database will be the same.
 * POSOFF    > This is the local position vector offset that TA uses to place the addition relative to MODELBASE.
 *             A NULL, empty, disabled or not available string is treated as taking {0,0,0}.
 * ANGOFF    > This is the local angle offset that TA uses to place the addition.
 *             A NULL, empty, disabled or not available string is treated as taking {0,0,0}.
 * MOVETYPE  > This internally calls /Entity:SetMoveType/ if the database parameter is zero or greater.
 * PHYSINIT  > This internally calls /Entity:PhysicsInit/ if the database parameter is zero or greater.
 * DRSHADOW  > This internally calls /Entity:DrawShadow/ if the database parameter is not zero.
 *             The call evaluates to /true/ for positive numbers and /false/ for negative.
 *             When the parameter is equal to zero skips the call of /Entity:DrawShadow/
 * PHMOTION  > This internally calls /PhysObj:EnableMotion/ if the database parameter is not zero on the validated physics object.
 *             The call evaluates to /true/ for positive numbers and /false/ for negative.
 *             When the parameter is equal to zero skips the call of /Entity:EnableMotion/
 * PHYSLEEP  > This internally calls /PhysObj:Sleep/ if the database parameter is grater than zero on the validated physics object.
 *             When the parameter is equal or less than zero skips the call of /Entity:Sleep/
 * SETSOLID  > This internally calls /Entity:SetSolid/ if the database parameter is zero or greater.
]]--
local myAdditions = {
  ["models/shinji85/train/rail_l_switch.mdl"] = {
    {"models/shinji85/train/sw_lever.mdl", "buttonswitch", gsSymOff, "-100,-125,0", "0,180,0", -1, -1, -1, 0, -1, -1},
    {"models/shinji85/train/rail_l_switcher1.mdl", "prop_dynamic", gsSymOff, gsMissDB, gsMissDB, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, -1, -1, 1, SOLID_VPHYSICS},
    {"models/shinji85/train/rail_l_switcher2.mdl", "prop_dynamic", gsSymOff, gsMissDB, gsMissDB, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, -1, 0, -1, SOLID_NONE}
  },
  ["models/shinji85/train/rail_r_switch.mdl"] = {
    {"models/shinji85/train/sw_lever.mdl", "buttonswitch", gsSymOff, "-100,125,0", gsMissDB, -1, -1, -1, 0, -1, -1},
    {"models/shinji85/train/rail_r_switcher1.mdl", "prop_dynamic", gsSymOff, gsMissDB, gsMissDB, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, -1, -1, 1, SOLID_VPHYSICS},
    {"models/shinji85/train/rail_r_switcher2.mdl", "prop_dynamic", gsSymOff, gsMissDB, gsMissDB, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, -1, 0, -1, SOLID_NONE}
  }
}

-- Register the addon ADDITIONS to the plugable DSV list
local bS, vO = pcall(DoSynchronize, "ADDITIONS", myAdditions, true)
if(not bS) then ThrowError("ADDITIONS error: "..vO) end

--[[
 * Create a table and populate it as shown below
 * In the square brackets goes your TYPE,
 * and then for every active point, you must have one array of
 * strings and numbers, where the elements match the following data settings.
 * {TYPE, LINEID, NAME}
 * TYPE   > This is the category under your physical properties are stored internally.
 *          It is mandatory and taken in pairs with LINEID, it forms the unique identifier of every record.
 *          When used in /DSV/ mode ( like seen below ) it is used as a hash index.
 * LINEID > This is the ID of the point that can be selected for building. They must be
 *          sequential and mandatory. If provided, the ID must the same as the row index under
 *          a given model key. Disabling this, makes it use the index of the current line.
 *          Use that to swap the active points around by only moving the desired row up or down.
 *          For the example table definition below, the line ID in the database will be the same.
 * NAME   > This stores the name of the physical property. It must an actual physical property.
]]--
local myPhysproperties = {}

-- Register the addon PHYSPROPERTIES to the plugable DSV list
local bS, vO = pcall(DoSynchronize, "PHYSPROPERTIES", myPhysproperties, true)
if(not bS) then ThrowError("PHYSPROPERTIES error: "..vO) end

asmlib.LogInstance("<<< "..myScript, mySource)
