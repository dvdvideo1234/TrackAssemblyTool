local sAddon = "Your addon name goes here"

--[[
 Create a table and populate it as shown below
 In the square brackets goes your model,
 and then for every active point you must have one array of
 strings, where the elements match the following data settings.
 You can use the reverse sign event /@/ to reverse any component of the parameterization
 and also the disable event /#/ to make TA auto-fill the value provided
 {TYPE	NAME	LINEID	POINT	ORIGIN	ANGLE	CLASS}
 TYPE   > This string is the name of the tipe your stuff will reside in the panel
 NAME   > This is the name of your track piece. Put /#/ here to be auto-generated form the model
 LINEID > This is the ID of the point that can be selected for building. They must be sequential
 POINT  > This is the position vector that TA searhes and selects.
          An empty string is treated as the ORIGIN.
          Disabling this using the disable event makes it hidden when the active point is searched for
 ORIGIN > This is the origin relative to which the next track piece position is calculated
          An empty string is treated as {0,0,0}. Disabling this makes it non-selectable by the holder
 ANGLE  > This is the angle relative to which the forward and up vectors are calculated.
          An empty string is treated as {0,0,0}. Disabling this also makes it use {0,0,0}
 CLASS  > This string is filled up when your entity class is not /prop_physics/ but something else
          used by ents.Create of the gmod ents api library. Keep this empty if your stuff is a normal prop 
]]
local myTable = {
  ["models/props_phx/construct/metal_plate1x2.mdl"] = {
    {"Test-TYPE" ,"#", "1", "","-0.02664,-23.73248,2.96593","0,-90,0",""},
    {"Test-TYPE" ,"#", "2", "","-0.02664, 71.17773,2.96593","0, 90,0",""}
  },
  ["models/props_phx/construct/windows/window1x2.mdl"] = {
    {"Test-TYPE" ,"#", "1", "","-0.02664,-23.73248,2.96593","0,-90,0",""},
    {"Test-TYPE" ,"#", "2", "","-0.02664,  71.17773,2.96593","0,90,0",""}
  }
}

--[[
 * This logic statement is needed for reporting the error in the console if the
 * process fails. For actually prodice an error you can replace the /print/
 * statement with one of following api calls:
 * http://wiki.garrysmod.com/page/Global/error
 * http://wiki.garrysmod.com/page/Global/Error
 * http://wiki.garrysmod.com/page/Global/ErrorNoHalt
 @ bSuccess = SynchronizeExtendedDSV(sTable, sDelim, bRepl, tData, sPref, sAddon)
 * sTable > The table you want to sync
 * sDelim > The delimiter used by the server/client ( defaut is a tab symbol )
 * bRepl  > If set to /true/, makes the api to replace the repeting models with
            these of your addon. If set to /false/ keeps the current model in the
            database and ignores yours if they are the same file.
 * tData  > A data table like the one descibed above
 * sPref  > An export file custom prefix. For synchronizing it must be /ex_/
 * sAddon > Ahh, yes, finally the addon. Here you must put your addon name, so if anything
 *          goes wrong with the lua file, he addon name will be reported in the logs
]]--
if(not trackasmlib.SynchronizeExtendedDSV("PIECES","\t",false,myTable,"ex_",sAddon)) then
  print(sAddon..": Transrapid tracks failed to synchronize the extended database") 
else trackasmlib.LogInstance("Synchronized EXT: <"..sAddon..">") end

