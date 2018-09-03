--[[
 * The purpose of this Lua file is to add your track pack pieces to the
 * track assembly tool, so they can appear in the tool selection menu.
 * Why the name starts with /z/ you may ask. When Gmod loads the game
 * it goes trough all the Lua addons alphabetically.
 * That means your file name ( The file you are reading right now )
 * must be greater alphabetically than /trackasmlib/, so the API of the
 * module can be loaded before you can use it like seen below.
]]--
-- Local reference to the module
local asmlib = trackasmlib

-- Change this to your addon name
local myAddon = "Ron's test maglev" -- Your addon name goes here

--[[
 * Change this if you want to use different in-game type
 * You can also use multiple types myType1, myType2,
 * myType3, ... myType/n when your addon contains
 * multiple model packs
]]--
local myType  = myAddon -- The type your addon resides in the tool with

--[[
 * For actually produce an error you can replace the /print/
 * statement with one of following API calls:
 * http://wiki.garrysmod.com/page/Global/error
 * http://wiki.garrysmod.com/page/Global/Error
 * http://wiki.garrysmod.com/page/Global/ErrorNoHalt
]]
local myError = print

-- This is used for addon relation prefix. Fingers away from it
local myPrefix = myAddon:gsub("[^%w]","_")

-- This is the script path. It tells TA who wants to add these models
-- Do not touch this also, it is used for debugging
local myScript = debug.getinfo(1)
      myScript = myScript and myScript.source or "N/A"

--[[
 * This function defines what happens when there is an error present
 * Usually you can tell Gmod that you want it to generate an error
 * and throw the message to the log also. In this case you will not
 * have to change the change the function name in lots of places
 * when you need it to do something else
--]]
local function myThrowError(vMesg)
  local sMesg = tostring(vMesg)                    -- Make sure the message is string
  if(asmlib) then asmlib.LogInstance(sMesg) end    -- Output the message into the logs
  myError(myScript.." > ("..myAddon.."): "..sMesg) -- Generate an error in the console ( optional )
end

if(asmlib) then
  -- This is the path to your DSV
  local myDsv = asmlib.GetOpVar("DIRPATH_BAS")..
                asmlib.GetOpVar("DIRPATH_DSV")..myPrefix..
                asmlib.GetOpVar("TOOLNAME_PU")
  --[[
   * This flag is used when the track pieces list needs to be processed.
   * It generally represents the locking file persistence flag. It is
   * bound to finding a "PIECES" DSV external database for the prefix
   * of your addon. You can use it for boolean value deciding whenever
   * or not to run certain events. For example you can stop exporting
   * your local database every time Gmod loads, but then the user will
   * skip the available updates of your addon until he/she deletes the DSVs
  ]]--
  local myFlag = file.Exists(myDsv.."PIECES.txt","DATA")

  -- Tell TA what custom script we just called don't touch it
  asmlib.LogInstance(">>> "..myScript.." ("..tostring(myFlag).."): {"..myAddon..", "..myPrefix.."}")

  --[[
   * Register the addon to the auto-load prefix list when the
   * PIECES file is missing. The auto-load list is located in
   * (/garrysmod/data/trackassembly/trackasmlib_dsv.txt)
   * a.k.a the DATA folder of Garry's mod
   *
   * @bSuccess = RegisterDSV(sProg, sPref, sDelim)
   * sProg  > The program which registered the DSV
   * sPref  > The external data prefix to be added ( default instance prefix )
   * sDelim > The delimiter to be used for processing ( default tab )
  ]]--
  asmlib.LogInstance("RegisterDSV start <"..myPrefix..">")
  if(myFlag) then -- Your DSV must be registered only once when loading for the first time
    asmlib.LogInstance("RegisterDSV skip <"..myPrefix..">")
  else -- If the locking file is not located that means this is the first run of your script
    if(not asmlib.RegisterDSV(myScript, myPrefix)) then -- Register the DSV prefix and check for error
      myThrowError("Failed to register DSV") -- Throw the error if fails
    end -- Third argument is the delimiter. The default tab is used
    asmlib.LogInstance("RegisterDSV done <"..myPrefix..">")
  end
  --[[
   * This is used if you want to make internal categories for your addon
   * You must make a function as a string under the hash of your addon
   * The function must take only one argument and that is the model
   * For every sub-category of your track pieces, you must return a table
   * with that much elements or return a /nil/ value to add the piece to
   * the root of your branch. You can also return a second value if you
   * want to override the track piece name.
  ]]--
  local myCategory = {
    [myType] = {Txt = [[
      function(m)
        local function conv(x) return " "..x:sub(2,2):upper() end
        local r = m:gsub("models/ron/maglev/",""):gsub("[\\/]([^\\/]+)$","");
        if(r:find("track")) then r = r:gsub("track/","")
        elseif(r:find("support")) then r = nil end; return r and {("_"..r):gsub("_%w",conv):sub(2,-1)}
      end
    ]]}
  }

  --[[
   * This logic statement is needed for reporting the error in the console if the
   * process fails.
   *
   @ bSuccess = ExportCategory(nInd, tData, sPref)
   * nInd   > The index equal indent format to be stored with ( generally = 3 )
   * tData  > The category functional definition you want to use to divide your stuff with
   * sPref  > An export file custom prefix. For synchronizing
   * it must be related to your addon ( default is instance prefix )
  ]]--
  asmlib.LogInstance("ExportCategory start <"..myPrefix..">")
  if(CLIENT) then
    if(not asmlib.ExportCategory(3, myCategory, myPrefix)) then
      myThrowError("Failed to synchronize category")
    end
    asmlib.LogInstance("ExportCategory done <"..myPrefix..">")
  else
    asmlib.LogInstance("ExportCategory skip <"..myPrefix..">")
  end

  --[[
   * Create a table and populate it as shown below
   * In the square brackets goes your model,
   * and then for every active point, you must have one array of
   * strings, where the elements match the following data settings.
   * You can use the reverse sign event /@/ to reverse any component of the
   * parametrization and also the disable event /#/ to make TA auto-fill
   * the value provided {TYPE, NAME, LINEID, POINT, ORIGIN, ANGLE, CLASS}
   * TYPE   > This string is the name of the type your stuff will reside in the panel
   *          Disabling this, makes it use the value of the /DEFAULT_TYPE/ variable
   *          If it is empty uses the string /TYPE/, so make sure you fill this
   * NAME   > This is the name of your track piece. Put /#/ here to be auto-generated from
   *          the model ( from the last slash to the file extension )
   * LINEID > This is the ID of the point that can be selected for building. They must be
   *          sequential and mandatory
   * POINT  > This is the position vector that TA searches and selects.
   *          An empty string is treated as taking the ORIGIN.
   *          Disabling this using the disable event makes it hidden when the active point is searched for
   * ORIGIN > This is the origin relative to which the next track piece position is calculated
   *          An empty string is treated as {0,0,0}. Disabling this makes it non-selectable by the holder
   * ANGLE  > This is the angle relative to which the forward and up vectors are calculated.
   *          An empty string is treated as {0,0,0}. Disabling this also makes it use {0,0,0}
   * CLASS  > This string is filled up when your entity class is not /prop_physics/ but something else
   *          used by ents.Create of the gmod ents API library. Keep this empty if your stuff is a normal prop
  ]]--
  local myTable = {
    ["models/ron/maglev/track/straight/straight_128.mdl"] = { -- Here goes the model of your pack
      {myType ,"#", 1, "","!1","!1",""}, -- The first point parameter
      {myType ,"#", 2, "","!2","!2",""}  -- The second point parameter
    }
  }

  --[[
   * This logic statement is needed for reporting the error in the console if the
   * process fails.
   *
   @ bSuccess = SynchronizeDSV(sTable, tData, bRepl, sPref, sDelim)
   * sTable > The table you want to sync
   * tData  > A data table like the one described above
   * bRepl  > If set to /true/, makes the API to replace the repeating models with
              these of your addon. This is nice when you are constantly updating your track packs
              If set to /false/ keeps the current model in the
              database and ignores yours if they are the same file.
   * sPref  > An export file custom prefix. For synchronizing it must be related to your addon
   * sDelim > The delimiter used by the server/client ( default is a tab symbol )
   *
   @ bSuccess = TranslateDSV(sTable, sPref, sDelim)
   * sTable > The table you want to translate to Lua script
   * sPref  > An export file custom prefix. For synchronizing it must be related to your addon
   * sDelim > The delimiter used by the server/client ( default is a tab symbol )
  ]]--
  asmlib.LogInstance("SynchronizeDSV start <"..myPrefix..">")
  if(not asmlib.SynchronizeDSV("PIECES", myTable, true, myPrefix)) then
    myThrowError("Failed to synchronize track pieces")
  else -- You are saving me from all the work for manually generating these
    asmlib.LogInstance("TranslateDSV start <"..myPrefix..">")
    if(not asmlib.TranslateDSV("PIECES", myPrefix)) then
      myThrowError("Failed to translate DSV into Lua") end
    asmlib.LogInstance("TranslateDSV done <"..myPrefix..">")
  end -- Now we have Lua inserts and DSV

  asmlib.LogInstance("<<< "..myScript)
else
  myThrowError("Failed loading the required module")
end
