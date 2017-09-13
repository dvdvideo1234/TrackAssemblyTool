TrackAssembly
=============

**Copyright 2015 ME !**

**IF YOU HAPPEN TO FIND REUPLOADS WITH DIFFERENT ORIGIN REPORT THEM TO ME IMMIDEATELY !!!**

![TrackAssemblyTool](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/screenshot.jpg)


On the Steam WS: http://steamcommunity.com/sharedfiles/filedetails/?id=287012681

General FAQ:
```
Q: What does this thing do?
A: This script is optimized for assembling a prop-segmented track inside the game "Garry's mod".
   It uses pre-defined active points to snap the props the best way there is.

Q: Why did you consider making this thing ?
A: I was always annoyed when building a railroad track in-game, spending a lot of time
   just to align the pieces together, so I thought "Here is a bright idea!" and there you have it :)
   Also, another great achievement progress is in place, so 10x guys for helping me, help you, help us all !
   ( Portal quote )

Q: What are the most important things that I need in order to build a track using this script?
A: Just subscribe to the workshop item:
     http://steamcommunity.com/sharedfiles/filedetails/?id=287012681
     or download the last stable release:
     https://github.com/dvdvideo1234/TrackAssemblyTool/releases
     and extract it inside ..\GarrysMod\garrysmod\addons
   You can find the tool in the "Constriction" section of Garry's mod "Q" menu under the name of "Track assembly".
   On the right in the tool's menu, you can locate the track pieces tree.
   Expand the desired piece type to use for building your track by clicking on a node, then select the desired piece.
   If "trackassembly_enpntmscr" is set to "1"
     Pressing ALT + NEXT_WEAPON ( Default: Mouse wheel down )
         Will increment the chosen active position of the piece that you're holding.
       When pressing SPEED ( Default: Shift )
         Will increment the chosen next position of the piece that you're holding.
     Pressing ALT + PREV_WEAPON ( Default: Mouse wheel up )
         Will decrement the chosen active position of the piece that you're holding.
       When pressing SPEED ( Default: Shift )
         Will decrement the chosen next position of the piece that you're holding.
   If "trackassembly_enpntmscr" is set to "0"
     Pressing ATTACK2 ( Default: Right mouse button )
         Will increment the chosen active position of the piece that you're holding.
       When pressing DUCK ( Default: Ctrl )
         Will increment the chosen next position of the piece that you're holding.
     Pressing ATTACK2 ( Default: Right mouse button ) + SPEED ( Default: Shift )
         Will decrement the chosen active position of the piece that you're holding.
       When pressing DUCK ( Default: Ctrl )
         Will decrement the chosen next position of the piece that you're holding.
   Pressing ATTACK1 ( Default: Left mouse button )
     When you are looking at the world the piece will just be spawned on the map.
     When you are looking at one of track piece's pre-defined active points
       Will snap the piece that you're holding to the trace one.
       If the traced piece's type is different than the holder piece's type,
         please check "Ignore track type" checkbox.
       If "Enable advisor" is checked, a coordinate system will appear,
         marking the origin position on the traced piece
       If "Enable ghosting" is checked the ghost track piece will be
         rendered to assist you with the building.
     When you are not looking at one of track piece's pre-defined active points,
       Pressing USE ( Default: E ) Applies the physical settings/properties on a piece.
       If not, you will update the piece's bodygroups/skin.
   Pressing SPEED ( Default: Shift ) + ATTACK1 ( Default: Left mouse button )
     Will stack as many pieces as shown by the slider "Pieces count".
   Pressing ATTACK2 ( Default: Right mouse button )
     Will select the trace model to use as a piece for building a track.
   Pressing USE ( Default: E ) + ATTACK2 ( Default: Right mouse button )
     When pointing to the world will open the "Frequent pieces by <PLAYER_NAME_HERE>" frame, from where
       you can select your routine pieces to use again in the track building process
       as well as searching in the table either by MODEL, TYPE, NAME, LAST_USED to obtain the piece
       you want to continue your track with.
       ( Hey, there is a textbox and a dropdown menu next to the "ExportDB" button. What are these for ? )
   Pressing RELOAD ( Default: R )
     When used in the world exports the database if the console variable "trackassembly_exportdb" is set to <>0,
     When used on trace it removes it, if it's a track piece.
   Pressing RELOAD ( Default: R ) + SPEED ( Default: Shift )
     When pressing it on the world will clear the tool's selected prop to attach all the track pieces to ( anchor ).
     When pressing it on the trace prop will set it as an anchor for other pieces spawned to be constrained to.
   If you want to obtain different grip behavior for a wheel-powered/sliding train,
     you must use the surface material drop-down menus as you select first "TYPE" then "NAME".
   If you want to use desired bodygroups and/or skins on a piece, in the text field you must type bodygroup/skin
     selection code or generate one using the SCORE ( Default: TAB ) key while pointing to a prop with
     bodygroups/skins set by Garry's mod entity right click menu. Press "ENTER" in the text field if you
     are happy with the selection to apply it.
   Piece mass slider is used to set the mass of the next track piece to be spawned.
   Active radius is used to set the minimum distance needed to select an active point when pointing at a piece.
   Pieces count shows the maximum number of pieces to be stacked.
   The "Yaw snap amount" slider is used to snap the first piece ( Requested by Magnum )
     to a user-defined angle ( Usually 45 ) so that the track building process becomes easier. The
     whole track build will be snapped also because you are building it relative to the first piece.
   The force limit slider ( Requested by The Arbitor 90 ) defines the maximum force to be applied
     on the weld joint between two pieces connected before it breaks. You can use this to build collapsible
     track bridges. Set the option to zero if you want it to be unbreakable ( by default ).
   The weld/no-collide/freeze/phys-gun grab/gravity are considered basic Gmod knowledge,
     because they are defined by their own and not going to be explained further.
   The "Ignore track type" checkbox if checked, will enable snapping between pieces of a different type.
   The "Spawn horizontally" ( as the name suggests ) if checked, will spawn the next pieces horizontally to the
     map ground if the additional angle offsets are zeros. If not they will be added to the resulting angle.
   The "Origin from mass-centre" checkbox if checked, will align the piece spawned to its mass-centre.
   The "Snap to trace surface" checkbox if checked, will snap the chosen track directly to the trace surface.
```
![SurfSnap](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/surfsnap.jpg)
```
   The "Draw adviser" checkbox if checked, will draw a composition of lines and circles to assist you with the building.
```
![DrawAdvaiser](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/snapadvaiser.jpg)
```
   The "Draw assistant" checkbox if checked, will draw circles to assist you where the active points are.
```
![PointAssist](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/pointassist.jpg)
```
   The "Draw holder ghost" checkbox if checked, will render the current piece that you are holding at the moment.
   When building a track using a different than the default way is needed you may use:
     UCS Pitch/Yaw/Roll are angle offsets used for orientating the base coordinate system in order to snap the piece as the user desires.
     Offset X(Forward-RED)/Y(Right-GREEN)/Z(Up-BLUE) are linear offsets used for additional user offset regarding the next track piece to be spawned.
   The button "Reset All Offsets" as the name suggests clears the offsets mentioned above ( UCS% and Offset% ).

Q: What will happen if something gets updated?
A: First of all this FAQ will be UPDATED AS THE TOOL GOES. So everything that
   the tool supports will be represented here as a "manual" or something.
   That's what is this FAQ for anyway ( Though most people don't bother to read it before asking )...

Q: Which addons did you work on?
A: Here they are, with available status, why I did not do some of them ( at the time of developing ):
    1) PHX Monorails
    2) PHX Regular Tracks ( For "switcher_2" [X] is inserted in the name as it misses collision meshes ),
    3) SligWolf's Rerailers old and new(1,2,3)
      https://steamcommunity.com/sharedfiles/filedetails/?id=132843280
    4) SProps
      https://steamcommunity.com/sharedfiles/filedetails/?id=173482196
    5) PHX XQM Coaster tracks
    6) SligWolf's Mini train tracks and switches
      https://steamcommunity.com/sharedfiles/filedetails/?id=149759773
    7) PHX Road Pieces ( including ramps big and small )
    8) PHX Monorail Iron Beams
    9) PHX XQM BallRails
   10) Magnum's gauge rails ( Owner support has stopped. No updates )
      https://steamcommunity.com/sharedfiles/filedetails/?id=290130567
   11) Metrostroi rails ( Ignore, twisted collision models )
   12) Shinji85's BodybroupRail pieces
      https://steamcommunity.com/sharedfiles/filedetails/?id=326640186
   13) gm_trainset map props ( Ignore, it's not designed to be a prop )
   14) SligWolf's Railcar
      https://steamcommunity.com/sharedfiles/filedetails/?id=173717507
   15) Some Bridges
   16) gm_sunsetgulch map props ( Ignore, it's not designed to be a prop )
   17) StevenTechno's Buildings pack
      https://steamcommunity.com/sharedfiles/filedetails/?id=331192490
   18) Mr. Train's M-Gauge rails
      https://steamcommunity.com/sharedfiles/filedetails/?id=517442747
   19) Bobsters's two gauge rails
      https://steamcommunity.com/sharedfiles/filedetails/?id=489114511
   20) Mr. Train's G-Gauge rails
      https://steamcommunity.com/sharedfiles/filedetails/?id=590574800
   21) Ron's 56 gauge rails ( Removed by the addon owner. Discontinued )
   22) Ron's 2ft track pack ( Maintained by the owner )
      http://steamcommunity.com/sharedfiles/filedetails/?id=634000136
   23) PHX Tubes
   24) Magnum's second track pack ( Ignore, it's not designed to be a prop )
   25) qwertyaaa's G Scale Track Pack
      http://steamcommunity.com/sharedfiles/filedetails/?id=718239260
   26) SligWolf's ModelPack ( Mini hover tracks ) ( White rails )
      https://steamcommunity.com/sharedfiles/filedetails/?id=147812851
   27) Ron's Minitrain Props
      http://steamcommunity.com/sharedfiles/filedetails/?id=728833183
   28) Battleship's abandoned rails
      http://steamcommunity.com/sharedfiles/filedetails/?id=807162936
   29) Ron's G-Scale track pack ( Maintained by the owner )
      https://steamcommunity.com/sharedfiles/filedetails/?id=865735701
   30) AlexCookie's 2ft track pack
      http://steamcommunity.com/sharedfiles/filedetails/?id=740453553

Q: Where are the trains/vehicles, are there any of these?
A: Dude seriously, make them yourself, what's the point of playing Gmod then ... xD

Q: Dude the rails are not showing in the menu, what should I do ?
A: SUBSCRIBE TO THE OWNER OF THE ADDON !!!!
N: Which addons did you work on?

Q: Are there going to be more of these?
A: Yes, I developed my dynamic database, so I can insert any model I want.
   When I have free time I will make more, because it's a lot of data I insert in the DB

Q: Will you create more models in the future?
A: Well, It depends on what you mean by "create".
   If it is for the making of the 3D models, then NO ( big one ) I've got no experience in
   that stuff neither am I a 3D artist. Other than that if the models are created by the 3D artists,
   I will be more then happy to add them into the Track assembly tool if their collision model meets
   the minimum requirements.
   ( Made a model once, but it turned out quite nasty xD, so better leave the job to the right people.)

Q: Could you make the tool so there will be categories for my addon?
A: Well, yeah, technically I can map any path given. However these with properly
   ordered folders are easier to handle. Here are some good and bad practices for folder alignment.
   Legend of the path elements used in a model:
     "/"          --> Slash represents directory divider ( Like in D:/Steam/common/Garry'smod )
     "#"          --> Any kind of delimiter valid for a file name( Like dashes, underscores etc.)
     %addonname%  --> Name of your addon (For example: SPros)
     %category%   --> Category, which you want your pices to be divided by ( Like straight, curves, raps, bridges etc.)
     %piecename%  --> The file name of the piece created in the addon ( Ending with *.mdl of cource)
   The good practices ( The category should be bordered by delimiters ):
      models/%addonname%/tracks/%category%/%piecename%.mdl
      models/%addonname%/%category%/%piecename%.mdl
      models/%addonname%/%category%#%piecename%.mdl
   Examples: (#="_", %addonname%="ron/2ft", %category%="tram", %piecename%="%category%_32_grass.mdl")
      models/ron/2ft/tram/tram_32_grass.mdl ( The "tram" is taken right after "models/ron/2ft/" )
   The the bad practices ( The category is missing or not strongly defined. There is not enough information given):
      models/%addonname%/tracks/%piecename%.mdl
      models/%addonname%/%piecename%#255#down.mdl
      models/%addonname%/03#1#asd#%piecename%#90.mdl
   Examples: (#="_", %addonname%="props_phx", %piecename%="track_128.mdl")
      models/props_phx/trains/track_128.mdl ( Here, the category "straight" is not present at all )

Q: Hey, remember that rollercoaster assistant addon, that was snapping pieces when you got
   them close to each other and they magically connect. Does this script has a feature like this ?
A: Yes, it does. When looking at the panel in the right, there is a checkbox labeled
   "Enable physgun snap" that you must check. This makes the server to perform some
   traces relative to the active points of the piece and search for other pieces to snap to.
   If the snapping conditions are present, it will snap the trace piece on physgun release at
   that end, which the server trace hits.

Q: Can you tell me how to read the physgun snap legend drawn on the screen ?
A: Easy. Here are some things to know for never getting confused with this:
   If the line with the middle circle is green, that means a valid prop entity is traced
     The green circle shows where the trace hits and the yellow what part of trace is inside the prop
     If in this case the trace is a valid piece, the origin and raduis to the point selected are drawn using
     a yellow circle line, always shorter than the active radius. After that the spawn position and distance
     are drawn by using cyan circle and margenta line respectively. The forward and the up direction vectors
     of the origin are drawn using red and blue lines respectively.
   If the line is yellow, that means the trace has hit someting else ( For example the world )
     The yellow circle shows again where the trace hits and the red line the part inside the non-prop
   If there is a red line with yellow circle, then there is an active point there, which is searching
     for props to snap to when you drop ( release the left click ) the piece with the physgun.
N: You can also disable the drawing by unchecking the "Draw adviser" checkbox
   or unchecking the option for "Enable physgun snap", making it pointles to be drawn without the
   base option enabled. To enable the drawing, both must be enabled ( Adviser and snapping ).

Q: What is this green line/circle into the base advisor, what is it for ?
A: Remember when I got suggestions to do the switchers.
   This is an easy way of indicating which next active position ( of some )
   is chosen when stacking is in place. The end of the line with the green
   circle points to the next active position that is chosen.

Q: Dude I've messed up my console variables, how can I factory reset them ?
A: Easy. First, you need to enable the developer mode via "trackassembly_devmode 1"
   Then in the bodygroup/skin text box ( or "trackassembly_bgskids" variable ) type:
   "reset cvars"
     Resets all cvars to the factory default settings
   "delete"
     Followed by a space for deleting the exported database without quitting
     the game, followed by either "cl" or "sv" or both, separated by space
     to delete the client or server or both instance generated databases
   Press enter to apply an option from these above and click the "Reset variables" button.
N: The console variables being set in this question will be reset also

Q: Dude how can I control the spawned pieces in multiplayer
A: Easy. The track pieces are props, so they are registered to:
   1) Variable "sbox_maxprops"     The maximum props on the server
   2) Variable "sbox_maxasmtracks" A variable for the maximum things spawned via TA
   You can trigger these limits independently from one another. For example:
   "maxprops" is 50 and "maxasmtracks" is 30 will trigger maxasmtracks
   "maxprops" is 30 and "maxasmtracks" is 50 will trigger maxprops
   "maxprops" is 50 and "maxasmtracks" is 50 will trigger maxasmtracks
N: If you want a server with many props and fewer tracks, then lower maxasmtracks
   Default value is 1500 for "maxasmtracks" to rely on the props limit

Q: How can I control errors when the clients are flooding my server with rails,
   and stacking/spawning outside of the map bounds?
A: Easy. Just set "trackassembly_bnderrmod" to one of the following values
   OFF     -> Clients are allowed to stack/spawn out of the map bounds without restriction
   LOG     -> Clients are not allowed to stack/spawn out of the map bounds. The error is logged.
   HINT    -> Clients are not allowed to stack/spawn out of the map bounds. Hunt message is displayed.
   GENERIC -> Clients are not allowed to stack/spawn out of the map bounds. Generic message is displayed.
   ERROR   -> Clients are not allowed to stack/spawn out of the map bounds. Error message is displayed.
   Other value will be treated as "LOG".
   But remember young samurai, this variable is only server side, and because of that
   you can only access it via single player or set it in the "server.vdf" gmod start-up file.
   May the force be with you and your server !
N: The error is logged if the logs are enabled !
   ( See:  Hey, how should I proceed when I am experiencing errors points 10 - 12 ).

Q: Does this thing have any wire extensions and how can I control then
   when my clients are abusing them ?
A: Yes it does. You can enable/disable the wire extension using the
   convar "trackassembly_enwiremod" and set it to 0 or <>0 respectively ( =0 disables it ).

Q: What do the tool versions represent?
A: The first number will get an increase when a new major update has arrived.
   The second number is the commit number in the repository, related to
   some smaller changes and fixes. For example rearranging the code, new features,
   performance optimizations, doing the same thing ,but in more "elegant"
   way and such.

Q: I want to use custom maximum limit tweaks for my server. Could you recommend appropriate cvars ?
A: Here is the list of the maximum value tweaks ( prefixed with "trackassembly_" of course ):
   "maxmass"   - Controls the mass upper limit of the piece spawned ( the lower bound is "1" )
   "maxlinear" - Controls the maximum offset that can be applied by next x,y,z linear offsets
   "maxforce"  - Controls the force limit upper border on the welds made between pieces
   "maxactrad" - Controls the vastness of the active point search area
   "maxstcnt"  - Controls the maximum pieces that can be spawned in stacking mode
   "maxfruse"  - Controls the maximum records that can be located under the frequent pieces list
N: For further track spawn control refer to: "Dude how can I control the spawned pieces in multiplayer"

Q: Hey, you said that we can switch the tool database between Lua or SQL. Is it working yet ?
   I want to use Lua mode because I've got third-party SQLite server. How can I switch to Lua mode ?
A: You can do the following:
   1) On the tool screen next to holder's model validation you shall see the database mode.
   2) Bring up the console and write "trackassembly_modedb LUA" ( or "SQL" to go to SQL mode respectively without the quotes ).
   3) Press enter and restart Gmod.
   4) Look at the tool screen. After holder's model validation, it shall write the new mode.
   5) Done. You are now in LUA mode.
N: SQL is still the best option for using the tool with for servers, because only a few models have to
   stay in the cache for a given amount of time, rather than the whole database forever ( till the server
   is up that is ), so please use SQL mode when possible if you want to save some amount of RAM.
   LUA mode is used as a default option, because some people have third party SQL servers, which messes with
   the sql.* library of the game and does not allow me to create the needed sql tables and records properly.

Q: Can I do something about my server's performance and how can I configure the memory manager properly?
A: You can choose a memory management algorithm by setting trackassembly_timermode to "mode@life@clear@collect"
   for any table sequentially divided by "/". First of all the memory manager is available only in SQL mode,
   because in LUA mode, all the records are already in the memory and thus, there is no need to manage ( delete )
   anything automatically. An example timer setting looks something like this: ( CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1 ).
   Here "mode" setting is the memory management algorithm to be used ( either "CQT" or "OBJ" ) for the table.
   These are explained below what they do. The "life" in the cache for the record is how much time in seconds
   the data will spend sitting in the cache, until it gets deleted to save some memory ( For the example above
   a half an hour for PIECES, 15 minutes for ADDITIONS and 10 minutes for PHYSPROPERTIES ).
   The greater the number, the more persistent are the records and fewer queries will be used to retrieve the data.
   Setting this to "0" will turn off the memory management for the table.
   The "clear" setting if <>0, assigns a nil to the record, marking it for
   deletion by Lua's garbage collector. The "collect" setting if <>0 calls the garbage collector when a
   record is marked or =0 leaves it to the game's garbage collector. It's pretty much for you to decide because
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
           the server will run out of memory when creating too many objects ( timers ).
   "OBJ" - It attaches a timer object ( That's why the OBJ xD ) to every record
           created in the cache with one repetition for given amount of time ( The life  )
           in seconds. After the time is passed, the record is marked for deletion, and the timer is destroyed.
     Pros: Obsolete ( not so frequently used ) records are deleted at the exact given time when processed.
           The timer is deleted with the record.
           It uses a running process, rather than points in time to control the memory management.
     Cons: Heavier algorithm.
           Needs additional memory for the timers.
           Garbage collector ( "collect" <>0 ) is called on every timer function call.
     Used: When server has enough memory for the timers OR
           the record has to be deleted at the exact moment the life passes.

Q: Does this script store the created queries for later use ?
A: Yes. That way it performs faster statements generation with very little memory consumed.
   Statement storage is based on caller name ( Good example is "CacheQueryPiece" ) where
   the program tries to retrieve the generated query, without going trough the trouble to
   concatenate all the fields. For the most expensive function "CacheQueryPiece", the request
   is done using the model, so in the statement it is substituted as an argument provided
   to "SQLCacheStmt(<hash>, <stmt>, <arguments>)" ). That way the base statement
   is stored once and formatted everytime it needs to be used.

Q: Hey, there is a textbox and a dropdown menu next to the "ExportDB" button. What are these for ?
A: Well, when a server owners set the "trackassembly_maxfruse" to a higher value, a slider appears.
   If the client has used many pieces during his/her routine, he/she cannot possibly locate the ones
   he/she needs, especially, when they are at the bottom of the list as "not frequently used" pieces.
   That's why it was needed some kind of a filter. With the drop-down menu, you can chose whatever
   field to filter the data on (<Search BY> either "Model", "Type", "Name", "Act"). Do not bother that
   the name is not displayed in the pieces list. That's normal ( Cave Johnson xD ). For 95% of the
   models, it is dynamically generated using the *.mdl file, so there is really no point in viewing
   that parameter on the pieces panel. In the textbox, to search you have to enter a pattern that
   you want to perform the filtering with. The result will populate the list view, only with these
   pieces, whatever desired field value is matched by the pattern given. The pattern is a standard
   Lua one, which is supported by the string.* library and you can also google it ;)
   http://lmgtfy.com/?q=lua+string+library+pattern+matching

Q: May I become a volunteer to translate the script to my native language and how can I use translations ?
A: Yes you may, though always make sure to use the abbreviation for the language codes provided
   by https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes ( Column "ISO 639-1" )
   If you want to translate it into Bulgarian for example ( my native ) you must duplicate all the
   translations like seen below. I took English translation and translated it to Bulgarian.
   English  : asmlib.SetLocalify("en","tool."..gsToolNameL..".activrad_con" , "Active radius:")
   Bulgarian: asmlib.SetLocalify("bg","tool."..gsToolNameL..".activrad_con" , "Активен радиус:")
   Change the language used by the game ( cvar "gmod_language" ) to your native. Done !

Q: Hey, how should I proceed when I am experiencing errors ?
A: First of all if the error origin is not the TA,
    I can't pretty much help you with it, but I will do my best
    If the error is related to the TA then:
    1) Delete database ( if any ) located in ..common\GarrysMod\garrysmod\data\trackassembly\dsv\*.*
    2) Delete the TA's *.gma file from garrysmod\addons
    3) Delete the cache "..\GarrysMod\garrysmod\cache"
    4) In the game library, right click on Gmod and select "Properties"
    5) Navigate to "Local Files" and click "Verify integrity of the game cache"
    6) Enter Gmod and while in-game open the console and paste "trackassembly_exportdb 0" ( without the quotes )
    7) Done ! It all should work now. If not, proceed as below ( 8 - 14 )
    8) Enable the logs via the console "trackassembly_logsmax 10000" hit enter
    9) Enable the log file via the console "trackassembly_logfile 1" hit enter
   10) Enable developer mode via "trackassembly_devmode 1"
   11) Server: Point to the world in-game and press RELOAD ( Default: R )
   12) Client: Click the "Reset Variables" button
   13) Now the hardest part - While in-game do some stuff and make it crash again.
   14) Navigate to ..Steam\steamapps\common\GarrysMod\garrysmod\data\trackassembly\trackasmlib_log.txt
   15) Report the log and the error to https://github.com/dvdvideo1234/TrackAssemblyTool/issues
   16) If you don't bother using the workshop ( Yeah, I hate it too ), then please use the GitHub link instead.
       Be sure to download only a stable release version: https://github.com/dvdvideo1234/TrackAssemblyTool/releases
       GitHub: https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master
       SVN     https://github.com/dvdvideo1234/TrackAssemblyTool/trunk

Q: Yo, can I add some personal models to TA ?
A: Yes, you can. For every active point, you have to add a line in the table PIECES.
    1) In the console ( Bring it up with ~ key under ESC ): "trackassembly_exportdb 1" [ press enter ]
    2) Server: Point the crosshair anywhere on the map, then hit SPEED ( Default: Shift ) + RELOAD ( Default: R )
    3) Client: Just bring up the Frequently used pieces screen, then click the "Export client's DB" button
    4) Use Excel or another table editing program to edit the files sv_*.txt and cl_*.txt
    5) After exporting, tables are located under ..common\GarrysMod\garrysmod\data\trackassembly\dsv\ [DSV Folder]
    6) Navigate to the DSV folder using explorer(Windows)/nautilus(Linux) and proceed
    7) Open all *TRACKASSEMBLY_PIECES.txt files and make your edits using tab-delimited [Excel 2010]
    8) [Excel 2010] File -> Save As -> Navigate to the DSV folder if you are not in there already
    9) [Excel 2010] File name: *TRACKASSEMBLY_PIECES.txt
   10) [Excel 2010] Save as type: "Text (Tab delimited)(*.txt)"
   11) [Excel 2010] Replace it if you must (don't worry you can always generate it again ( points 3) and 4) )
   12) [Excel 2010] It will prompt you that the file you are saving does contain features not compatible with "TAB Delimited" format
   13) [Excel 2010] Click "Yes" and close Excel
   14) [Excel 2010] It will want you to save it again, so just click "Don't Save"
   15) [Excel 2010] You are good to go
   If you have trouble with this step by step tutorial, maybe this will help
     https://www.youtube.com/watch?v=Pz0_RGwgfaY
N: After adding these models, the database can be exported again.
   This will generate export data, that can be located under "../data/trackassembly/exp/"
   If you want me to review your custom models/addon, please provide these inserts to me.
   Whether it is for PIECES, ADDITIONS, PHYSPROPERTIES, these files will be generated with
   the instance prefix also ( cl_*.txt and sv_*.txt ). Please provide me the client side file.

Q: Hey, I am making a track pack and as you may know the workshop does not support *.txt files
   shipping. That's why I need to make a lua file which synchronizes the tracks from my addon on
   the server and the client. How can I add my custom models on startup, so they can be added to
   the pieces list ?
A: You must add your addon to the auto-load pieces list located in "/data/trackassembly/trackasmlib_dsv.txt"
   This registers your (*.txt) files for automatic database insertion during tool script initialization.
   To disable an addon from loading its pieces in the database, you can always comment it via a
   hashtag (#) in front of the line definition that you want disabled. The addon registered multiple
   times will not be loaded on startup until the user makes a review of the auto-load list for the
   repeating sequences for the given prefix. The adding is done using the function /RegisterDSV/.
   Beware that you need a lock file not to add the same addon on both client and server.
   After this is ready you must add your pieces. You must create you own Lua file which generates
   the table data in DSV format ( tab delimited ). There is this /SynchronizeDSV/
   function, which does exactly that. It's always good to have the pieces table used for a locking file.
   If you want to use categories for your custom pieces list, you must use the /ExportCategory/ function.
   Every question you may have for creating such script is explained in the example below,
   where you have to call it on auto-run ( For example: your_addon/lua/autorun/your_script.lua ) like this:
   https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/autosave/z_autorun_add_pieces.lua
   After you test your script and it does work with TA you can add it to your track pack,
   upload it to the workshop without any hassle as it is (*.lua) file and it will not be rejected.
N: When all your script goes according to the plan you will have this:
```
![AddonScriptAdd](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/track_addon.jpg)
```
Q: May I PUT this thing in another third party website ?
A: No I will not give you my permission to do that... Why ...
   That way you will upload some half-baked malicious tool, waste your time with stupid
   things and confuse everybody with this so-called "unofficial" version of the Track assembly tool.
   Not to mention that the stunned people will NOT GET ANY updates!
   The best you can do is just point to the original GIT repository avoiding any version mismatches and confusions.
   So please don't upload the script to any other sites. I mean it!

```
Just click the subscribe button above and you are good to go! Thumbs Up ! XD
