-- Local reference to the module
local asmlib = trackasmlib

-- Change this to your addon name
local myAddon = "Ron's test maglev" -- Your addon name goes here

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
local myPrefix = myAddon:gsub("[^%w]","_") -- Addon prefix

-- This is the script path. It tells TA who wants to add these models
-- Do not touch this also, it is used for debugging
local myScript = tostring(debug.getinfo(1).source or "N/A")
      myScript = "@"..myScript:gsub("^%W+", ""):gsub("\\","/")

local function myThrowError(vMesg)
  local sMesg = tostring(vMesg)                    -- Make sure the message is string
  if(asmlib) then asmlib.LogInstance(sMesg) end    -- Output the message into the logs
  myError(myScript.." > ("..myAddon.."): "..sMesg) -- Generate an error in the console ( optional )
end

if(asmlib) then
  -- Store a reference to disable symbol
  local gsSymOff = asmlib.GetOpVar("OPSYM_DISABLE")

  -- This is the path to your DSV
  local myDsv = asmlib.GetOpVar("DIRPATH_BAS")..
                asmlib.GetOpVar("DIRPATH_DSV")..myPrefix..
                asmlib.GetOpVar("TOOLNAME_PU")

  local myFlag = file.Exists(myDsv.."PIECES.txt","DATA")

  -- Tell TA what custom script we just called don't touch it
  asmlib.LogInstance(">>> "..myScript.." ("..tostring(myFlag).."): {"..myAddon..", "..myPrefix.."}")

  asmlib.LogInstance("RegisterDSV start <"..myPrefix..">")
  if(myFlag) then -- Your DSV must be registered only once when loading for the first time
    asmlib.LogInstance("RegisterDSV skip <"..myPrefix..">")
  else -- If the locking file is not located that means this is the first run of your script
    if(not asmlib.RegisterDSV(myScript, myPrefix)) then -- Register the DSV prefix and check for error
      myThrowError("Failed to register DSV") -- Throw the error if fails
    end -- Third argument is the delimiter. The default tab is used
    asmlib.LogInstance("RegisterDSV done <"..myPrefix..">")
  end

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

  asmlib.LogInstance("ExportCategory start <"..myPrefix..">")
  if(CLIENT) then
    if(not asmlib.ExportCategory(3, myCategory, myPrefix)) then
      myThrowError("Failed to synchronize category")
    end
    asmlib.LogInstance("ExportCategory done <"..myPrefix..">")
  else
    asmlib.LogInstance("ExportCategory skip <"..myPrefix..">")
  end

  local myTable = {
    ["models/ron/maglev/track/straight/straight_128.mdl"] = { -- Here goes the model of your pack
      {myType , gsSymOff, gsSymOff, "","!1","",""}, -- The first point parameter
      {myType , gsSymOff, gsSymOff, "","!2","",""}  -- The second point parameter
    }
  }

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
