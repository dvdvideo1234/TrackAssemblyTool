TrackAssembly
=============

**Copyright 2015 ME !**

**IF YOU HAPPEN TO FIND REUPLOADS WITH DIFFERENT ORIGIN REPORT THEM TO ME IMMIDEATELY !!!**

![TrackAssemblyTool](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/screenshot.jpg)


On the Steam WS: http://steamcommunity.com/sharedfiles/filedetails/?id=287012681

General FAQ:
```
Q: What does this thing do?
A: This script is optimized for assembling a prop-segmented track inside the game "Garry's mod".
   It uses pre-defined active pints to snap the props the best way there is.

Q: Why did you consider making this thing ?
A: I was always annoyed when building a railroad track in-game, spending a lot of time
   just to align the pieces together, so I thought "Here is a bright idea!" and there you have it :)
   Also another great achievement progress is in place, so 10x guys for helping me, help you, help us all !
   ( Portal quote )

Q: What are the most important things that I need in order to build a track using this script?
A: Just subscribe to the workshop item:
     http://steamcommunity.com/sharedfiles/filedetails/?id=287012681
     or download the last stable release:
     https://github.com/dvdvideo1234/TrackAssemblyTool/releases
     and extract it inside ..\GarrysMod\garrysmod\addons
   You can find the tool in the "Constriction" section of the Garry's mod "Q" menu under the name of "Track Assembly".
   On the right in the tool's menu you can locate the track pieces tree.
   Expand the desired piece type to use for building your track by clicking on a node, then select the desired piece.
   Pressing ATTACK1 ( Default: Left mouse button )
     When you are looking at the world the piece will just be spawned on the map.
     When you are looking at one of track piece's pre-defined active points
       Will snap the piece that you're holding to the trace one.
       If the trace piece's type is different than the holder piece's type, please check "Ignore track type" checkbox.
       If "Enable advisor" is checked, a coordinate system will appear, marking the origin position on the trace piece
       If "Enable ghosting" is checked the ghost track piece will be rendered to assist you with the building.
     When you are not looking at one of track piece's pre-defined active points, you will update the piece's bodygroups.
   Pressing DUCK ( Default: Ctrl ) + ATTACK1 ( Default: Left mouse button )
     Will select the trace model to use as a piece for building.
   Pressing SPEED ( Default: Shift ) + ATTACK1 ( Default: Left mouse button ) 
     Will stack as many pieces as shown by the slider "Pieces count".
   Pressing ATTACK2 ( Default: Right mouse button )
     Will increment the chosen active position of the piece that you're holding.
   Pressing SPEED ( Default: Shift ) + ATTACK2 ( Default: Right mouse button )
     Will decrement the chosen active position of the piece that you're holding.
   Pressing USE ( Default: E ) + ATTACK2 ( Default: Right mouse button )
     When pointing to the world will open the "Frequent pieces by <PLAYER_NAME_HERE>" frame form where
       you can select your routine pieces to use again in the track building process
       as well as searching in the table either by MODEL, TYPE, NAME, LAST_USED to obtain the piece
       you want to continue your track with.
       ( Hay, there is a text-box and a drop down menu next to the "ExportDB" button. What are these for ? )
   Pressing DUCK ( Default: Ctrl ) + ATTACK2 ( Default: Right mouse button )
     Will increment the next active point chosen of the piece that you're holding.
   Pressing DUCK ( Default: Ctrl ) + SPEED ( Default: Shift ) + ATTACK2 ( Default: Right mouse button )
     Will decrement the next active point chosen of the piece that you're holding.
   Pressing RELOAD ( Default: R )
     When used on trace it removes it, if it's a track piece.
     When Pressing it on world will clear the tool's selected prop to attach all the track pieces to ( anchor ).
   Pressing RELOAD ( Default: R ) + SPEED ( Default: Shift )
     Will set the trace prop as an anchor for other pieces spawned to be welded to.
   If you want to obtain different grip behaviour for a wheel-powered train,
     you may use the surface material drop-down menus as you select first "TYPE" then "NAME".
   The "Yaw snap amount" slider is used to snap the first piece ( Requested by Magnum )
     to a user-defined angle ( Usually 45 ) so that the track building process becomes easier. The
     whole track build will be snapped also, because you are building it relative to the first piece.
   The "Snap to trace surface" checkbox if checked, will snap the chosen track directly to the
     trace surface. 
     
   In the text field you may type bodygroup/skin selection code or generate one using the SCORE ( Default: TAB ) key
     while pointing to a prop with bodygroups/skins set by Garry's mod entity right click menu.
     Press "ENTER" in the text field if you are happy with the selection to apply it.
   Piece mass slider is used to set the mass of the next track piece to be spawned.
   Active radius is used to set the minimum distance needed to select an active point when pointing to e piece.
   When building a track using a different than the default way is needed you may use:
     UCS Pitch/Yaw/Roll are angle offsets used for orientating the base coordinate system in order to snap the piece as the user desires.
     Offset X(Forward-RED)/Y(Right-GREEN)/Z(Up-BLUE) are linear offsets used for additional user offset regarding the next track piece to be spawned.
   The button "Reset All Offsets" as the name suggests clears the offsets mentioned above ( UCS% and Offset% ).

Q: What will happen if something gets updated?
A: First of all this FAQ will be UPDATED AS THE TOOL GOES. So everything that
   the tool supports will be represented here as a "manual" or something.
   That's what is this FAQ for anyway ...

Q: Which addons did you work on?
A: Here they are, with available status, why I did not do some of them ( in the time of developing ):
    1) PHX Monorails,
    2) PHX Regular Tracks ( Ignore "switcher_2" missing part of the collision model),
    3) SligWolf's Rerailers old and new(1,2,3)
    4) SProps
    5) PHX XQM Coaster tracks
    6) SligWolf's Mini train tracks and switchers
    7) PHX Road Pieces ( including ramps big and small )
    8) PHX Monorail Iron Beams
    9) PHX XQM BallRails
   10) Magnum's gauge rails
   11) Metrostroi rails ( Ignore, twisted collision models )
   12) Shinji85's BodybroupRail pieces
   13) gm_trainset map props ( Ignore, it's not designed to be a prop )
   14) SligWolf's Railcar
   15) Some Bridges
   16) gm_sunsetgulch map props ( Ignore, it's not designed to be a prop )
   17) StevenTechno's Buildings pack
   18) Mr. Train's M-Gauge rails
   19) Bobsters's two gauge rails

Q: Dude the rails are not showing in the menu, what should I do ?
A: SUBSCRIBE TO THE OWNER OF THE ADDON !!!!
N: Which addons did you work on?

Q: Are there going to be more of those?
A: Yes, I developed my dynamic database, so I can insert any model I want.
   When I have free time I will make more, because its a lot of data I insert in the DB

Q: Will you create more models in the future?
A: Well, It depends what do you mean by "create".
   If it is for the making of the 3D models, then NO ( big one ) I've got no experience in
   that stuff nether am I a 3D artist. Other than that if the models are created by the 3D artists,
   I will be more then happy to add them in to the TrackAssembly Tool if their collision model meets
   the minimum requirements.
   ( Made a model once, but it turned out quite nasty xD, so better leave the job to the right people.)

Q: Where are the trains/vehicles, are there any of these?
A: Dude seriously, make them yourself, what's the point of playing Gmod then ... xD

Q: What is this yellow line into the advisor, what is it for ?
A: Remember when I got suggestions to do the switchers.
   This is an easy way of indicating which NEXT active position ( of some... )
   is chosen when stacking is in place. The end of the line with the green
   circle points to the next active position that is chosen.

Q: Well, I am having hard time placing the last track flat
   relative to the map ground, can you help me?
A: Check "Next piece flat to surface" track option.

Q: I want to place the first piece relative to the mass-centre or the chosen point, how can I do that ?
A: Emm, check/uncheck "Spawn at mass-centre" checkbox.
N: If you uncheck it, the position were you pointing at becomes origin,
   so you need to offset your piece as you want to, using the Pos/Ang offsets!

Q: Dude the piece is still spawning in the the ground, what should I do?
A: Amm uncheck "Origin from mass-centre" and check "Auto-offset up",
   I Put this like that, so we can still have custom offsets :).
  
Q: I want to disable the gravity on a piece, how should I do that?
A: Uncheck "Enable pieces gravity" checkbox

Q: How can I guess Bodygroup IDs and skins, it's annoying...
A: Naa, just use the Garry's right-click context menu to select body-groups/skins
   If you are happy with the selection, click in the text-box and then hit the TAB button.
   The selection code will be auto-generated in there, press ENTER and it's done :).

Q: Dude, I want to snap the track piece directly to the trace surface, how should I do that ?
A: Emm, Check the "Snap to trace surface" option.

Q: How can I control errors when the clients are flooding my server with rails,
   and stacking/spawning outside of the map bounds?
A: Easy, :D Just set "trackassembly_bnderrmod" to one of the following values
   0 -> Clients are allowed to stack/spawn out of the map bounds without restriction
   1 -> Clients are not allowed to stack/spawn out of the map bounds. The error is logged.
   2 -> Clients are not allowed to stack/spawn out of the map bounds. Hunt message is displayed.
   3 -> Clients are not allowed to stack/spawn out of the map bounds. Generic message is displayed.
   4 -> Clients are not allowed to stack/spawn out of the map bounds. Error message is displayed.
   But remember young samurai, this variable is only server side, and because of that
   you can only access it via single player or set it in the "server.vdf" gmod start-up file. 
   May the force be with you and your server !
N: The error is logged if the logs are enabled !
   ( See:  Hay, how should I proceed when I am experiencing errors points 10 - 12 ).
   
Q: Does this thing have any wire extensions and how can I control then
   when my clients are abusing them ?
A: Yes it does. You can enable/disable the wire extension using the
   convar "trackassembly_enwiremod" and set it to 0 or <>0 respectively ( =0 disables it ).

Q: What do the tool versions represent?
A: The first number will get an increase when a new major update has arrived.
   The second number is the commit number in the repository, related to
   some smaller changes and fixes. For example rearranging the code,
   performance optimizations, doing the same thing ,but in more "elegant"
   way and such.

Q: Hay, you said that we can switch the tool database between Lua or SQL. Is it working yet ?
   I want to use Lua mode, because I've got third-party SQLite server. How can I switch to Lua mode ?
A: You can do the following:
   1) On the tool screen next to holder's model validation you shall see the database mode.
   2) Bring up the console and write "trackassembly_modedb LUA" ( or "SQL" to go to SQL mode respectively without the quotes ).
   3) Press enter and restart Gmod.
   4) Look at the tool screen. After holder's model validation it shall write the new mode.
   5) Done. You are now in LUA mode.
N: SQL is still the best option for using the tool with, because only
   small amount of models have to stay in the cache for a given amount
   of time, rather than the whole database forever ( till the server is up that is .. ),
   so please use SQL mode when possible if you want to save some amount of RAM.

Q: Can I do something about my server's performance and how can I configure the memory manager properly?
A: You can chose a memory management algorithm by setting trackassembly_timermode to "mode@life@clear@collect"
   for any table sequentially divided by "/". First of all the memory manager is available only in SQL mode,
   because in LUA mode, all the records are already in the memory and thus, there is no need to manage ( delete )
   anything automatically. An example timer setting looks something like this: ( CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1 ).
   Here "mode" setting is the memory management algorithm to be used ( either "CQT" or "OBJ" ) for the table.
   These are explained below what they do. The "life" in the cache for the record is how much time in seconds
   the data will spend sitting in the cache, until it gets deleted to save some memory ( For the example above
   an half an hour for PIECES, 15 minutes for ADDITIONS and 10 minutes for PHYSPROPERTIES ).
   The greater the number, the more persistent are the records and less queries will be used to retrieve the data.
   Setting this to "0" will turn-off the memory management for the table.
   The "clear" setting if <>0, assigns a nil to the record, marking it for
   deletion by Lua's garbage collector. The "collect" setting if <>0 calls the garbage collector when a
   record is marked or =0 leaves it to the game's garbage collector. It's pretty much for you to decide, because
   every setting has its pros and cons.
   "CQT" - The memory management is called every time a new piece is requested from the cache and
           not found. Therefore a query should be processed to retrieve it from the database, so
           as it does at the end it runs a "for k, v pairs(Cache)" cycle, inspecting which record is
           old enough ( not used for given amount of time ) to be deleted and marks it for deletion.
     Pros: Lighter algorithm.
           No need for additional memory allocation for timers.
           Garbage collector ( "collect" <>0 ) is called once to process all the obsolete records.
     Cons: Uses particular points in time when a record is used/loaded and judges by these how old is it.
           Records do not get deleted from the cache at the exact moment when the life in the cache runs out.
     Used: When there is no need of many timer objects to store in the memory    OR
           they cannot be created due to some reasons not related to the TA tool OR
           the time precision does not matter when the record gets deleted       OR
           the server will run out of memory when creating too much objects ( timers ).
   "OBJ" - It attaches a timer object ( That's why the OBJ xD ) to every record
           created in the cache with one repetition for given amount of time ( The life  )
           in seconds. After the time is passed, the record is marked for deletion, and the timer is destroyed.
     Pros: Obsolete ( not so frequently used ) records are deleted at the exact given time when processed.
           Timer is deleted with the record.
           It uses a running process, rather than points in time to control the memory management.
     Cons: Heavier algorithm.
           Needs additional memory for the timers.
           Garbage collector ( "collect" <>0 ) is called on every timer function call.
     Used: When server has enough memory for the timers OR
           the record has to be deleted at the exact moment the life passes.

Q: Does this script stores the created queries for later use. Can I disable/enable this option ?
A: Yes you can. Just set the trackassembly_enqstore to 0/<>0 respectively.

Q: Hay, there is a text-box and a drop down menu next to the "ExportDB" button. What are these for ?
A: Well, when a server owners set the "trackasmlib_maxfruse" to a higher value, a slider appears.
   If the client has used many pieces during his/her routine, he/she cannot possibly locate the ones
   he/she needs, especially, when they are at the bottom of the list as "not frequently used" pieces.
   That's why it was needed some kind of a filter. With the drop-down menu you can chose whatever
   field to filter the data on (<Search BY> either "Model", "Type", "Name", "Act"). Do not bother that
   the name is not displayed in the pieces list. That's normal ( Cave Johnson xD ). For 95% of the
   models it is dynamically generated using the *.mdl file, so there is really no point in viewing
   that parameter on the pieces panel. In the text-box, to search you have to enter a pattern that
   you want to preform the filtering with. The result will populate the list view, only with these
   pieces, whatever desired field value is matched by the pattern given. The pattern is a standard
   Lua one, which is supported by the string.* library an you can also google it ;)
   http://lmgtfy.com/?q=lua+string+library+pattern+matching

Q: Hay, how should I proceed when I am experiencing errors ?
A: First of all if the the error origin is not the TA, 
    I can't pretty much help you with it, but I will do my best
    If the error is related to the TA then:
    1) While in-game ( or the TA's link ) unsubscribe to TA
    2) Delete the TA's *.gma file
    3) Enter Gmod to see that you've unsubscribed to TA
    4) Delete the cache "..\GarrysMod\garrysmod\cache"
    5) In the game library, right click on Gmod and select "Properties"
    6) Navigate to "Local Files" and click "Verify integrity of the game cache"
    7) Go to http://steamcommunity.com/sharedfiles/filedetails/?id=287012681 
    8) Hit the subscribe button
    9) If the error does not go away please proceed to ( 10 - 16 )
   10) Enable the logs via the console "trackassembly_logsmax 10000" hit enter
   11) Enable the log file via the console "trackassembly_logfile trackasmlib_log" hit enter
   12) Point to the world in-game hold SPEED ( Default: Shift ) + RELOAD ( Default: R )
   13) Now the hardest part - While in-game do some stuff and make it crash again.
   14) Navigate to ..Steam\steamapps\common\GarrysMod\garrysmod\data\trackassembly\trackasmlib_log.txt
   15) Report the log and the error to https://github.com/dvdvideo1234/TrackAssemblyTool/issues
   16) If you don't bother using the workshop, then please use the GitHub link instead.
       Be sure to download only a stable release version: https://github.com/dvdvideo1234/TrackAssemblyTool/releases
       GitHub: https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master
       SVN     https://github.com/dvdvideo1234/TrackAssemblyTool/trunk

Q: Yo, can I add some personal models to TA ?
A: Yes, you can. For every active point, you have to add a line in the table PIECES.
    1) In the console ( Bring it up with ~ key under ESC ): "trackassembly_exportdb 1" [ press enter ]
    2) After exporting, tables are located under ..common\GarrysMod\garrysmod\data\trackassembly\dsv\ [DSV Folder]
    3) Server: Point the crosshair anywhere on the map, then hit SPEED ( Default: Shift ) + RELOAD ( Default: R )
    4) Client: Just bring up the Frequently used pieces screen, then click the "Export client's DB" button
    5) Use Excel or another table editing program to edit the files sv_*.txt and cl_*.txt
    6) After you are done, proceed as below [Excel 2010] 
    6) [Excel 2010] File -> Save As -> Navigate to the DSV folder if you are not in there already
    7) [Excel 2010] File name: *TRACKASSEMBLY_PIECES.txt
    8) [Excel 2010] Save as type: "Text (Tab delimited)(*.txt)"
    9) [Excel 2010] Replace it if you must (don't worry you can always generate it again ( points 3) and 4) )
   10) [Excel 2010] It will prompt you that the file you are saving does contain features not compatible with "TAB Delimited" format
   11) [Excel 2010] Click "Yes" and close Excel
   12) [Excel 2010] It will want you to save it again, so just click "Don't Save"
   13) [Excel 2010] You are good to go
N: After adding these models, the database can be exported again.
   This will generate export data, that can be located under "../data/trackassembly/exp/"
   If you want me to review your custom models/addon, please provide these inserts to me.
   Whether it is for PIECES, ADDITIONS, PHYSPROPERTIES, these files will be generated with
   the instance prefix also ( cl_*.txt and sv_*.txt ). Please provide me the client side file.

Q: May I PUT this thing in another third party website ?
A: No I will not give you my permission to do that... Why ...
   That way you will upload some half-baked tool, waste your time with stupid
   things and confuse everybody with this so called "unofficial" version of the TrackAssembly tool.
   Not to mention that the stunned people will NOT GET ANY updates!
   So please don't!

```
Just CLK the subscribe to the button above. And also Thumbs Up ! XD

