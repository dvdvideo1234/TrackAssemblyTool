local sAddon = "Ron's Transrapid"

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

if(not trackasmlib.SynchronizeExtendedDSV("PIECES","\t",false,myTable,"ex_",sAddon)) then
  print(sAddon..": Transrapid tracks failed to synchronize the extended database") 
else trackasmlib.LogInstance("Synchronized EXT: <"..sAddon..">") end

