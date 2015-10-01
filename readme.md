TrackAssembly
=============

**Copyright 2015 ME !**

**IF YOU HAPPEN TO FIND REUPLOADS WITH DIFFERENT ORIGIN REPORT THEM TO ME IMMIDEATELY !!!**

![TrackAssemblyTool](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/screenshot.jpg)


On the Steam WS: http://steamcommunity.com/sharedfiles/filedetails/?id=287012681

General FAQ:
```
Q: What doest this thing do?
A: This tool is optimized for assembling a track.

Q: Why did you consider making this thing ?
A: I was always annoyed when building a railroad track, spending a lot of time
   just to align the pieces together, so I thought "Here is a bright idea!" and there you have it :)
   Also another great achievement progress is in place, so 10x guys for helping me, help you, help us all !
   ( Portal quote )

Q: Dude the rails are not showing in the menu, what should I do ?
A: SUBSCRIBE TO THE OWNER OF THE ADDON !!!!
Note: What addons did you work on?

Q: Where is the TrackAssembly tool located?
A: It should be always "Q -> Construction [ Left side, "Tools" part ] -> Track Assembly Tool".
   Anywhere else than there, means that you have "different version", so please report it ! 
   
Q: Will you create more models in the future?
A: Well, It depends what do you mean by "create".
   If it is for the making of the 3D models, then NO ( big one ) I've got no experience in
   that stuff nether am I a 3D artist. Other than that if the models are created by the 3D artists,
   I will be more then happy to add them in to the TrackAssembly Tool if their collision model meets
   the minimum requirements.
   ( Made a model once, but it turned out quite nasty xD, so better leave the job to the right people.)
   
Q: What will happen if something gets updated?
A: First of all this FAQ will be UPDATED AS THE TOOL GOES. So everything that
   the tool supports will be represented here as a "manual" or something.
   That's what is this FAQ for anyway ...

Q: Where are the trains / vehicles, are there any of those?
A: Dude seriously, make them yourself, what's the point of playing Gmod then ... xD

Q: What addons did you work on?
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

Q: Are there going to be more of those?
A: Yes, I developed my dynamic database, so I can insert any model I want.
   When I have free time I will make more, because its a lot of data i insert in the DB

Q: How can I change fast my piece model?
A: Duck Key ( Default: Crtl ) + Left click.

Q: How can I open the recently used pieces list.
A: Press USE ( Default: E ) + Right mouse button.

Q: How can I make a track with multiple piece segments?
A: Hold Speed/Run ( Default: Shift ), point to an active position then Left click while holding.

Q: How to choose Previous, Next active position and vice-versa?
A: Shift + RightClick, Right Click.

Q: Can I assemble tracks in a different than default way?
A: Yes, use the X,Y,Z P,Y and R offsets.

Q: How can I assemble a track with different piece types in one place?
A: Check "Ignore track type" checkbox.

Q: Can I rid of the ghosted piece temporary ?
A: Yes you can uncheck "Enable ghosting" checkbox.

Q: What is this new yellow line into the advisor, what is it for ?
A: Remember when I got suggestions to do the switchers.
   This is an easy way of indicating which NEXT active position ( of some... )
   is chosen when stacking is in place. The end of the line with the green
   circle points to the next active position that is chosen.

Q: I want to change the active position of the next
   rail when stacking, could you help me with that?
A: Do you see the yellow line with the circle, use E + RightClk
   or E + Shift + RigthClk to change its position and vice-versa.
   Now use the stacking option ( Shift + LeftClk ).

Q: Well, I am having hard time placing the last track flat
   relative to the map ground, can you help me?
A: Check "Next piece flat to surface" track option, then point
   to an active position and click the Left mouse button.

Q: I want to place the first piece relative to the mass-centre like the previous
   version or relative to the chosen point, how can I do that ?
A: EEmm, check/uncheck "Spawn at mass-centre" checkbox.
N: If you uncheck it, the position were you pointing at becomes origin,
   so you need to offset your piece as you want to, using the Pos/Ang offsets!

Q: I want to snap the first piece in N-Degrees. Please Help ! ( Requested by Magnum )
A: See the "Yaw snap amount" slider ! Use that to Snap your first piece.
   Everything greater than 0 will become the "Snap amount".
N: Assembling the track relative to the first piece will be snapped also, because
   you are building it relative to the first piece as an origin !

Q: Are there any other options?
A: Yes, there are, but you don't need them, because they
   are intended for developing xD, so just play along :)

Q: Dude the piece is still spawning in the the ground, what should I do?
A: Amm uncheck "Origin from mass-centre" and check "Auto-offset up",
   I Put this like that, so we can still have custom offsets :)
   The tool adapts to its user xD

Q: Can I change the surface properties of a piece to obtain a better grip
A: Yeah, choose a type from the upper combo then mat. name from the one below it.

Q: I want to disable the gravity on a piece, how should I do that?
A: Uncheck "Enable pieces gravity" checkbox

Q: How can I guess Bodygroup IDs and skins, it's annoying...
A: Naa, just use the Garry's right-click context menu to select body-groups/skins
   If you are happy with the selection, click in the text-box and then hit the TAB button.
   The selection code will be auto-generated in there, press ENTER and it's done :).

Q: Dude, I want to snap the track piece direcly to the trace serface, how shold I do that ?
A: Emm Check the "Snap to trace surface" option.

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

Q: May I PUT this thing in another third party website ?
A: No I will not give you my permission to do that... Why ...
   That way you will upload some half-baked tool, waste your time with stupid
   things and confuse everybody with this so called "unofficial" version of the TrackAssembly tool.
   Not to mention that the stunned people will NOT GET ANY updates !
   So please don't !

Q: Hay, how should I proceed when I am experiencing errors ?
A: First of all if the the error origin is not the TA, 
    I can't pretty much help you with it, but I will do my best
    If the error is related to the TA then:
    1) While ingame ( or the TA's link ) unsubscribe to TA
    2) Delete the TA's *.gma file
    3) Enter Gmod to see that you've unsubscribed TA
    4) Delete the cache "..\GarrysMod\garrysmod\cache"
    5) In the game library, right click on Gmod and select "Properties"
    6) Navigate to "Local Files" and click "Verify integrity of the game cache"
    7) Go to http://steamcommunity.com/sharedfiles/filedetails/?id=287012681 
    8) Hit the subscribe button
    9) If the error does not go away pls proceed to ( 10 - 16 )
   10) Enable the logs via the console "trackassembly_logsmax 10000" hit enter
   11) Enable the log file via the console "trackassembly_logfile trackasmlib_log" hit enter
   12) Point to the world ingame hold "IN_SPEED" ( Running: Shift ) + Reload
   13) Now the hardest part - While ingame do some stuff and make it crash 
   14) Navigate to ..Steam\steamapps\common\GarrysMod\garrysmod\data\trackassembly\trackasmlib_log.txt
   15) Report the log and the error to http://steamcommunity.com/workshop/filedetails/discussion/287012681/35220315967153021/
   16) If you don't boter using the workshop, then please use the GitHub link instead
       GitHub: https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master
       SVN     https://github.com/dvdvideo1234/TrackAssemblyTool/trunk

Q: Yo, can I add some personal models to TA ?
A: Yes, you can. For every active point, you have to add a line in the table PIECES.
    1) In the console ( Bring it up with ~ key under ESC ): "trackassembly_exportdb 1" [ press enter ]
    2) After exporting, tables are located under ..common\GarrysMod\garrysmod\data\trackassembly\dsv\ [DSV Folder]
    3) Server: Point the crosshair anywhere on the map, then hit IN_SPEED ( Def: Shift ) + IN_RELOAD ( Def: R )
    4) Client: Just bring up the Frequently used pieces screen, then click the "Export client's DB" button
    5) Use Excel or another table editing program to edit the files sv_*.txt and cl_*.txt
    6) After you are done, proseed as below [Excel 2010] 
    6) [Excel 2010] File -> Save As -> Navigate to the DSV folder if you are not in there already
    7) [Excel 2010] File name: *TRACKASSEMBLY_PIECES.txt
    8) [Excel 2010] Save as type: "Text (Tab delimited)(*.txt)"
    9) [Excel 2010] Replace it if you must (don't worry you can alway generate it again ( points 3) and 4) )
   10) [Excel 2010] It will prompt you that the file you are saving does contain features not compatible with "TAB Delimited" format
   11) [Excel 2010] Just Click "Yes" and close Excel
   12) [Excel 2010] It will want to save it again, so you should click "Don't Save"
   13) [Excel 2010] You are good to go
```
Just CLK the subscribe to the button above. And also Thumbs Up ! XD
