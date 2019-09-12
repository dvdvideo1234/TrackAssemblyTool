return function(sTool, sLimit) local tSet = {} -- English ( Column "ISO 639-1" )
  ------ CONFIGURE TRANSLATIONS ------ https://en.wikipedia.org/wiki/ISO_639-1
  -- con >> control # def >> default # hd >> header # lb >> label
  tSet["tool."..sTool..".1"             ] = "Assembles a prop-segmented track"
  tSet["tool."..sTool..".left"          ] = "Spawn/snap a piece. Hold SHIFT to stack"
  tSet["tool."..sTool..".right"         ] = "Switch assembly points. Hold SHIFT for versa (Quick: ALT + SCROLL)"
  tSet["tool."..sTool..".right_use"     ] = "Open frequently used pieces menu"
  tSet["tool."..sTool..".reload"        ] = "Remove a piece. Hold SHIFT to select an anchor"
  tSet["tool."..sTool..".desc"          ] = "Assembles a track for vehicles to run on"
  tSet["tool."..sTool..".name"          ] = "Track assembly"
  tSet["tool."..sTool..".phytype"       ] = "Select physical properties type of the ones listed here"
  tSet["tool."..sTool..".phytype_def"   ] = "<Select Surface Material TYPE>"
  tSet["tool."..sTool..".phyname"       ] = "Select physical properties name to use when creating the track as this will affect the surface friction"
  tSet["tool."..sTool..".phyname_con"   ] = "Surface material name:"
  tSet["tool."..sTool..".phyname_def"   ] = "<Select Surface Material NAME>"
  tSet["tool."..sTool..".bgskids"       ] = "Selection code of comma delimited Bodygroup/Skin ID"
  tSet["tool."..sTool..".bgskids_con"   ] = "Bodygroup/Skin:"
  tSet["tool."..sTool..".bgskids_def"   ] = "Write selection code here. For example 1,0,0,2,1/3"
  tSet["tool."..sTool..".mass"          ] = "How heavy the piece spawned will be"
  tSet["tool."..sTool..".mass_con"      ] = "Piece mass:"
  tSet["tool."..sTool..".model"         ] = "Select a piece to start/continue your track with by expanding a type and clicking on a node"
  tSet["tool."..sTool..".model_con"     ] = "Piece model:"
  tSet["tool."..sTool..".activrad"      ] = "Minimum distance needed to select an active point"
  tSet["tool."..sTool..".activrad_con"  ] = "Active radius:"
  tSet["tool."..sTool..".stackcnt"      ] = "Maximum number of pieces to create while stacking"
  tSet["tool."..sTool..".stackcnt_con"  ] = "Pieces count:"
  tSet["tool."..sTool..".angsnap"       ] = "Snap the first piece spawned at this much degrees"
  tSet["tool."..sTool..".angsnap_con"   ] = "Angular alignment:"
  tSet["tool."..sTool..".resetvars"     ] = "Click to reset the additional values"
  tSet["tool."..sTool..".resetvars_con" ] = "V Reset variables V"
  tSet["tool."..sTool..".nextpic"       ] = "Additional origin angular pitch offset"
  tSet["tool."..sTool..".nextpic_con"   ] = "Origin pitch:"
  tSet["tool."..sTool..".nextyaw"       ] = "Additional origin angular yaw offset"
  tSet["tool."..sTool..".nextyaw_con"   ] = "Origin yaw:"
  tSet["tool."..sTool..".nextrol"       ] = "Additional origin angular roll offset"
  tSet["tool."..sTool..".nextrol_con"   ] = "Origin roll:"
  tSet["tool."..sTool..".nextx"         ] = "Additional origin linear X offset"
  tSet["tool."..sTool..".nextx_con"     ] = "Offset X:"
  tSet["tool."..sTool..".nexty"         ] = "Additional origin linear Y offset"
  tSet["tool."..sTool..".nexty_con"     ] = "Offset Y:"
  tSet["tool."..sTool..".nextz"         ] = "Additional origin linear Z offset"
  tSet["tool."..sTool..".nextz_con"     ] = "Offset Z:"
  tSet["tool."..sTool..".gravity"       ] = "Controls the gravity on the piece spawned"
  tSet["tool."..sTool..".gravity_con"   ] = "Apply piece gravity"
  tSet["tool."..sTool..".weld"          ] = "Creates welds between pieces or pieces/anchor"
  tSet["tool."..sTool..".weld_con"      ] = "Weld"
  tSet["tool."..sTool..".forcelim"      ] = "Controls how much force is needed to break the weld"
  tSet["tool."..sTool..".forcelim_con"  ] = "Force limit:"
  tSet["tool."..sTool..".ignphysgn"     ] = "Ignores physics gun grab on the piece spawned/snapped/stacked"
  tSet["tool."..sTool..".ignphysgn_con" ] = "Ignore physics gun"
  tSet["tool."..sTool..".nocollide"     ] = "Creates a no-collide between pieces or pieces/anchor"
  tSet["tool."..sTool..".nocollide_con" ] = "NoCollide"
  tSet["tool."..sTool..".nocollidew"    ] = "Creates a no-collide between pieces and world"
  tSet["tool."..sTool..".nocollidew_con"] = "NoCollide world"
  tSet["tool."..sTool..".freeze"        ] = "Makes the piece spawn in a frozen state"
  tSet["tool."..sTool..".freeze_con"    ] = "Freeze piece"
  tSet["tool."..sTool..".igntype"       ] = "Makes the tool ignore the different piece types on snapping/stacking"
  tSet["tool."..sTool..".igntype_con"   ] = "Ignore track type"
  tSet["tool."..sTool..".spnflat"       ] = "The next piece will be spawned/snapped/stacked horizontally"
  tSet["tool."..sTool..".spnflat_con"   ] = "Spawn horizontally"
  tSet["tool."..sTool..".spawncn"       ] = "Spawns the piece at the center, else spawns relative to the active point chosen"
  tSet["tool."..sTool..".spawncn_con"   ] = "Origin from center"
  tSet["tool."..sTool..".surfsnap"      ] = "Snaps the piece to the surface the player is pointing at"
  tSet["tool."..sTool..".surfsnap_con"  ] = "Snap to trace surface"
  tSet["tool."..sTool..".appangfst"     ] = "Apply the angular offsets only on the first piece"
  tSet["tool."..sTool..".appangfst_con" ] = "Apply angular on first"
  tSet["tool."..sTool..".applinfst"     ] = "Apply the linear offsets only on the first piece"
  tSet["tool."..sTool..".applinfst_con" ] = "Apply linear on first"
  tSet["tool."..sTool..".adviser"       ] = "Controls rendering the tool position/angle adviser"
  tSet["tool."..sTool..".adviser_con"   ] = "Draw adviser"
  tSet["tool."..sTool..".pntasist"      ] = "Controls rendering the tool snap point assistant"
  tSet["tool."..sTool..".pntasist_con"  ] = "Draw assistant"
  tSet["tool."..sTool..".ghostcnt"      ] = "Controls rendering the tool ghosted holder pieces count"
  tSet["tool."..sTool..".ghostcnt_con"  ] = "Draw holder ghosts"
  tSet["tool."..sTool..".engunsnap"     ] = "Controls snapping when the piece is dropped by the player physgun"
  tSet["tool."..sTool..".engunsnap_con" ] = "Enable physgun snap"
  tSet["tool."..sTool..".workmode"      ] = "Change this option to select a different working mode"
  tSet["tool."..sTool..".workmode_1"    ] = "General spawn/snap pieces"
  tSet["tool."..sTool..".workmode_2"    ] = "Active point intersection"
  tSet["tool."..sTool..".pn_export"     ] = "Click to export the client database as a file"
  tSet["tool."..sTool..".pn_export_lb"  ] = "Export DB"
  tSet["tool."..sTool..".pn_routine"    ] = "The list of your frequently used track pieces"
  tSet["tool."..sTool..".pn_routine_hd" ] = "Frequent pieces by:"
  tSet["tool."..sTool..".pn_externdb"   ] = "The external databases available for:"
  tSet["tool."..sTool..".pn_externdb_hd"] = "External databases by:"
  tSet["tool."..sTool..".pn_externdb_lb"] = "Right click for options:"
  tSet["tool."..sTool..".pn_externdb_1" ] = "Copy prefix"
  tSet["tool."..sTool..".pn_externdb_2" ] = "Copy table"
  tSet["tool."..sTool..".pn_externdb_3" ] = "Copy folder"
  tSet["tool."..sTool..".pn_externdb_4" ] = "Copy path"
  tSet["tool."..sTool..".pn_externdb_5" ] = "Copy header"
  tSet["tool."..sTool..".pn_externdb_6" ] = "Open luapad"
  tSet["tool."..sTool..".pn_externdb_7" ] = "Delete file"
  tSet["tool."..sTool..".pn_display"    ] = "The model of your track piece is displayed here"
  tSet["tool."..sTool..".pn_pattern"    ] = "Write a pattern here and hit ENTER to preform a search"
  tSet["tool."..sTool..".pn_srchcol"    ] = "Choose which list column you want to preform a search on"
  tSet["tool."..sTool..".pn_srchcol_lb" ] = "<Search by>"
  tSet["tool."..sTool..".pn_srchcol_lb1"] = "Model"
  tSet["tool."..sTool..".pn_srchcol_lb2"] = "Type"
  tSet["tool."..sTool..".pn_srchcol_lb3"] = "Name"
  tSet["tool."..sTool..".pn_srchcol_lb4"] = "End"
  tSet["tool."..sTool..".pn_routine_lb" ] = "Routine items"
  tSet["tool."..sTool..".pn_routine_lb1"] = "Used"
  tSet["tool."..sTool..".pn_routine_lb2"] = "End"
  tSet["tool."..sTool..".pn_routine_lb3"] = "Type"
  tSet["tool."..sTool..".pn_routine_lb4"] = "Name"
  tSet["tool."..sTool..".pn_display_lb" ] = "Piece display"
  tSet["tool."..sTool..".pn_pattern_lb" ] = "Write pattern"
  tSet["Cleanup_"..sLimit               ] = "Assembled track pieces"
  tSet["Cleaned_"..sLimit               ] = "Cleaned up all track pieces"
  tSet["SBoxLimit_"..sLimit             ] = "You've hit the spawned tracks limit!"
return tSet end
