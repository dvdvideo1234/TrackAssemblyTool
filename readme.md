# TrackAssembly

---

# Copyright 2015 [ME](http://steamcommunity.com/profiles/76561197988124141) !

## IF YOU HAPPEN TO FIND REUPLOADS WITH DIFFERENT ORIGIN REPORT THEM TO ME IMMIDEATELY !!!

![TrackAssemblyTool](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/screenshot.jpg)

## Description

This script can give you the ability to connect prop-segmented track pieces fast.
It is optimized and brings the track building time consuming to a minimum.
It uses pre-defined active points to snap the segments the best way there is in Garry's Mod

## General FAQ:

#### Donations
I am supporting this tool in my free time mostly and it was quite a ride since I already first
created it. But since my lack of time for playing gmod has been drastically increased some
people asked me if I accept donations, here is [the link to my PayPal](https://www.paypal.me/DeyanVasilev).

#### How can I install this?
You can subscribe to it in the workshop [here](http://steamcommunity.com/sharedfiles/filedetails/?id=287012681)
or download the latest stable release from [here](https://github.com/dvdvideo1234/TrackAssemblyTool/releases).
After downloading the release extracting it in `../GarrysMod/garrysmod/addons` and you are practically done.

#### Why did you consider making this thing ?
I was always annoyed when building a railroad track in-game, spending a lot of time
just to align the pieces together, so I thought `Here is a bright idea!` and there you have it :)
Also, another great achievement progress is in place, so 10x guys for
[helping me, help you, help us all](https://www.youtube.com/watch?v=2TZyb0n2DAw) !

#### Who are the people that helped you in some way for maintaining this project ?
Here is the list of all the people that helped me by answering my questions
about their track packs or in some other way. It is possible that missed someone, so please excuse me:
  * [Ron Thunderr](https://steamcommunity.com/profiles/76561198121926395)
  * [Magnum](https://steamcommunity.com/profiles/76561198004847743)
  * [SligWolf](https://steamcommunity.com/profiles/76561198010984952)
  * [Qwertyaaa](https://steamcommunity.com/profiles/76561198033658330)
  * [Mr. Train](https://steamcommunity.com/profiles/76561198041277955)
  * [Shinji85](https://steamcommunity.com/profiles/76561197962603247)
  * [StevenTechno](https://steamcommunity.com/profiles/76561198006216679)
  * [Battleship](https://steamcommunity.com/profiles/76561198170859437)
  * [CalocoDoesGames](https://steamcommunity.com/profiles/76561198059235055)
  * [Dat-Mudkip](https://steamcommunity.com/profiles/76561198074186688)
  * [AlexCookie](https://steamcommunity.com/profiles/76561198143297186)
  * [Grocel](https://steamcommunity.com/profiles/76561197970000386)
  * [Puppyjaws](https://steamcommunity.com/profiles/76561198146226478)
  * [Bullseye SBT](https://steamcommunity.com/profiles/76561198082120871)
  * [AlexALX](https://steamcommunity.com/profiles/76561198049628741)
  * [Puppyguard12](http://steamcommunity.com/profiles/76561198077265201)
  * [Gedo789](https://github.com/Gedo789)
  * The Arbitor 90
  * PePena
  * meme
  * Fennecai
  * robgray026
  * [SCI] Ickycoolboy(R)
  * THE BENEFITS DON'T STOP HERE
  * Gecko_
  * kozi

#### What kind of features does this script has?
  * Track curve fitting alignment based on [ray intersection for precise piece layout](https://www.youtube.com/watch?v=1rsDHU79J50)
  * Extendible database via [text file](https://www.youtube.com/watch?v=Pz0_RGwgfaY) or a [lua script](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/autosave/z_autorun_add_pieces.lua)
  * Extendible database via [text file load list](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/trackasmlib_dsv.txt) and [list prefixes](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/Test_s_track_packTRACKASSEMBLY_PIECES.txt) [categories](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/Test_s_track_packTRACKASSEMBLY_CATEGORY.txt)
  * Switching database storage between Lua table and SQL
  * Spawning pieces on the map
  * Snapping pieces on the map surface ( if checked )
  * Snapping/spawning with [custom user offsets](https://www.youtube.com/watch?v=e1IK2zJ_Djk)
  * Snapping/spawning with zero pitch. Good for track levelling
  * Snapping/spawning at the mass-center or the active point ( if checked )
  * Snapping the first piece angle to user defined value
  * Snapping already spawned pieces by [using only the physgun](https://www.youtube.com/watch?v=BxMlZMMGHrs)
  * Fast changing the active track ends ( Alt + mouse scroll ). Good switching turns direction
  * Custom user defined active radius based snapping
  * Custom active point and radius location assistant
  * Custom active point position angle and orientation adviser
  * Advanced duplicator can be used on the track created
  * Custom entity properties ( weld, freeze, no-collide )
  * User can disable phys-gun grabbing on a piece. Good for turntables
  * Ability to list up the most used pieces on the server ( E + MRIGHT ). Close shortcut (ALT + E)
  * Ability to search among the most server popular pieces by [Lua patterns](https://www.lua.org/pil/20.2.html)
  * Ability to export server and client database as a file
  * Tool-tips for every button are available and can be translated easily
  * Ability to spawn scripted track switches of other class ( Ron's 2ft )
  * Ability to modify the bodygroups and skins of a track piece ( with duping )
  * Ability to modify track piece [surface behaviour](https://www.youtube.com/watch?v=ALBnlFeC9tU) ( wood, metal, slime, tire )
  * Ability to extend a track piece spawn with [additional entities](https://www.youtube.com/watch?v=jKGBUNDMN6A)
  * Includes integrated wiremod extension

#### Where can I find the tool in-game ?
You can find the tool in the `Constriction` section of Garry's mod
[spawn menu](https://wiki.garrysmod.com/page/Opening_The_Spawnmenu) under the name of `Track assembly`.
*The name of the tool depends on what language are you using when playing Garry's mod.*
On the right in the tool's menu, you can locate the track pieces tree.
Expand the desired piece type to use for building your track by clicking on a node, then select the desired piece.

#### How can I chose and select a desired track end ?
Just hold `KEY_LALT` ( Default: LALT ) and turn the mouse scroll around.
This will make the script chose the track active point you want.
When You hold `SPEED` ( Def: SHIFT ) the script will switch to
adjusting the next active point for the track stacking option.
This will affect what point is chosen when you continue the track you build.
The current and next active points will not be the same.

#### Hey, I cannot align my track curves properly. Can you help ?
Yep sure. In the right panel, there is a drop-down menu which has a bunch of tool modes listed.
Go ahead and select the `Active point intersection`. After you change the mode, an intersection
relation entity is needed to complete the process. Hitting `SPEED + RELOAD` ( Default: Shift + R )
just like the anchor, will select the relation active point of the entity in question, which is closest
to the player hit position. Now trace a track piece and the ghost of the curve will be drawn. You can
clamp the spawn position in a box using the primary position flag `applinfst ( Apply linear first )` or switch
the origin angle with the ray direction angle by using primary angle flag `appangfst ( Apply angular first )`
In this working mode the angular and linear offsets adjust the piece offsets relative to the ray intersection
position where the trace and relation rays meet. Press `ATTACK1` ( Def: Left click ) if you are happy with where
the ghost is located and where the spawn piece will go at.

#### How can I use the switchers ? I can't seem to make them work.
Every addon has its own way for dealing with the switchers. Others that are not listed here do not
have dedicated track switchers, so to switch them you must use two track pieces inside of each other.
Swap their solidness around using the [fading door tool](https://steamcommunity.com/sharedfiles/filedetails/?id=115753588),
so when one is solid a.k.a `CLOSED` and you can't pass trough it, the other must be no-collided to all `OPENED`. Therefore the
wheels of the train will follow only the track that is currently set being solid with fading door `CLOSED` function state:
 1. Dedicated entity like a lever you must press with your USE key
    * [Shinji85's Rails](https://www.youtube.com/watch?v=cHhf83w-YNM)
 2. Dedicated switcher [entity](wiki.garrysmod.com/page/Category:Entity)
    you must press with your USE key. You must press the custom switcher [entity](wiki.garrysmod.com/page/Category:Entity) itself:
    * `Sligwolf's mini trains`
    * `SligWolf's White Rails`
    * `Ron's 2ft track pack`
 3. Dedicated switched/unswitched model. You have to swap the two models around to switch the track by using a script (Lua, E2, EAdv, Starfall)
    * `Robster's pack`
    * `AlexCookie's 2ft track pack`
 4. Dedicated switcher model and a switcher moving needle that you must assemble to get track switching functionality
    * `Mr.Train's M-Gauge`
    * `Mr.Train's G-Gauge`
    * `Battleship's abandoned rails`
 
#### How do I use the old way for switching between the active points ?
There is this variable `trackassembly_enpntmscr` and as its name suggests
it controls the ***enable end-point mouse scroll***. Set it to `1` if you want
to switch the track ends via the mouse scroll or set it to `0` if you want
to use the old-school for the way of changing and selecting track ends.

#### How to use the tool control options when building a track ?
1. Pressing ATTACK1 ( Default: Left mouse button )
    1. When you are looking at the world the piece will just be spawned on the map.
    2. When you are looking at one of track piece's pre-defined active points
      * Will snap the piece that you're holding to the trace one.
      * If the traced piece's type is different than the holder piece's type,
        please check `Ignore track type` check-box.
      * If `Enable advisor` is checked, a coordinate system will appear,
        marking the origin position on the traced piece
      * If `Enable ghosting` is checked the ghost track piece will be
        rendered to assist you with the building.
    3. When you are not looking at one of track piece's pre-defined active points,
      * Pressing USE ( Default: E ) Applies the physical settings/properties on a piece.
      * If not, you will update the piece's bodygroups/skin.
2. Pressing SPEED ( Default: SHIFT ) + ATTACK1 ( Default: Left mouse button )
Will stack as many pieces as shown by the slider `Pieces count`.
    1. Pressing ATTACK2 ( Default: Right mouse button )
      * Will select the trace model to use as a piece for building a track.
    2. Pressing USE ( Default: E ) + ATTACK2 ( Default: Right mouse button )
      * When pointing to the world will open the `Frequent pieces by <PLAYER_NAME_HERE>` frame, from where
       you can select your routine pieces to use again in the track building process
       as well as [searching in the table](https://github.com/dvdvideo1234/TrackAssemblyTool#hey-there-is-a-text-box-and-a-drop-down-menu-next-to-the-exportdb-button-what-are-these-for-) either by `MODEL`, `TYPE`, `NAME`, `LAST_USED` to obtain the piece
       you want to continue your track with.
    3. Pressing RELOAD ( Default: R )
      * When used in the world exports the database if the console variable `trackassembly_exportdb` is set to <>0,
      * When used on trace it removes it, if it's a track piece.
    4. Pressing RELOAD ( Default: R ) + SPEED ( Default: SHIFT )
      * When pressing it on the world will clear the tool's selected prop to attach all the track pieces to ( anchor ).
      * When pressing it on the trace prop will set it as an anchor for other pieces spawned to be constrained to.
3. If you want to obtain different grip behaviour for a wheel-powered/sliding train,
   you must use the surface material drop-down menus as you select first `TYPE` then `NAME`.
4. If you want to use desired bodygroups and/or skins on a piece, in the text field you must type bodygroup/skin
   selection code or generate one using the SCORE ( Default: TAB ) key while pointing to a prop with
   bodygroups/skins set by Garry's mod [context menu](https://wiki.garrysmod.com/page/The_Context_Menu). Press `ENTER` in the text field if you
   are happy with the selection to apply it.
5. Piece mass slider is used to set the mass of the next track piece to be spawned.
6. Active radius is used to set the minimum distance needed to select an active point when pointing at a piece.
7. Pieces count shows the maximum number of pieces to be stacked.
8. The `Angular alignment` slider is used to snap the first piece ( Requested by [Magnum](http://steamcommunity.com/profiles/76561198004847743) )
   to a user-defined angle ( Usually 45 ) so that the track building process becomes easier. The
   whole track build will be snapped also because you are building it relative to the first piece.
9. The force limit slider ( Requested by `The Arbitor 90` ) defines the maximum force to be applied
   on the weld joint between two pieces connected before it breaks. You can use this to build collapsible
   track bridges. Set the option to zero if you want it to be unbreakable ( by default ).
10. The weld/no-collide/freeze/phys-gun grab/gravity are considered basic Gmod knowledge,
   because they are defined by their own and not going to be explained further.
11. The `Ignore track type` check-box if checked, will enable snapping between pieces of a different type.
12. The `Spawn horizontally` ( as the name suggests ) if checked, will spawn the next pieces horizontally to the
   map ground if the additional angle offsets are zeros. If not they will be added to the resulting angle.
13. The `Origin from mass-centre` check-box if checked, will align the piece spawned to its mass-centre.
14. The `Snap to trace surface` check-box if checked, will snap the chosen track directly to the trace surface.
![SurfSnap](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/surfsnap.jpg)

15. The `Draw adviser` check-box if checked, will draw a composition of lines and circles to assist you with the building.
![DrawAdvaiser](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/snapadvaiser.jpg)

16. The `Draw assistant` check-box if checked, will draw circles to assist you where the active points are.
![PointAssist](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/pointassist.jpg)

17. The `Draw holder ghost` check-box if checked, will render the current piece that you are holding at the moment.
18. When building a track using a different than the default way is needed you may use:
     UCS Pitch/Yaw/Roll are angle offsets used for orientating the base coordinate system in order to snap the piece as the user desires.
     Offset X(Forward-RED)/Y(Right-GREEN)/Z(Up-BLUE) are linear offsets used for additional user offset regarding the next track piece to be spawned.
19. The button `Reset All Offsets` as the name suggests clears the offsets mentioned above ( UCS% and Offset% ).

#### What will happen if something gets updated?
First of all this FAQ will be UPDATED AS THE TOOL GOES. So everything that
the tool supports will be represented here as a manual or something.
That's what is this FAQ for anyway ( Though most people don't bother to read it before asking )...

#### Which addons did you work on?
Here they are, with available status, why I did not do some of them ( at the time of developing ).
The ones that are **included** in Garry's mod do not have links and are marked below:
  * PHX Monorails **(INCLUDED)**
  * PHX Regular Tracks ( For `switcher_2` `[X]` in the name as it misses collision meshes ) **(INCLUDED)**
  * [SligWolf's Retailers](https://steamcommunity.com/sharedfiles/filedetails/?id=132843280) old and new(1,2,3)
  * [SProps](https://steamcommunity.com/sharedfiles/filedetails/?id=173482196)
  * PHX XQM Coaster tracks **(INCLUDED)**
  * [SligWolf's Mini train tracks and switches](https://steamcommunity.com/sharedfiles/filedetails/?id=149759773)
  * PHX Road Pieces ( including ramps big and small ) **(INCLUDED)**
  * PHX Monorail Iron Beams **(INCLUDED)**
  * PHX XQM BallRails **(INCLUDED)**
  * [Magnum's gauge rails](https://steamcommunity.com/sharedfiles/filedetails/?id=290130567) ( Owner support has stopped. No updates )
  * [Metrostroi rails](https://steamcommunity.com/sharedfiles/filedetails/?id=261801217) ( Ignore, not designed as prop )
  * [Shinji85's BodybroupRail pieces](https://steamcommunity.com/sharedfiles/filedetails/?id=326640186)
  * [gm_trainset map props](https://steamcommunity.com/sharedfiles/filedetails/?id=248213731) ( Ignore, not designed as prop )
  * [SligWolf's Railcar](https://steamcommunity.com/sharedfiles/filedetails/?id=173717507)
  * [Bridges pack](https://steamcommunity.com/sharedfiles/filedetails/?id=343061215)
  * [gm_sunsetgulch map props](https://steamcommunity.com/sharedfiles/filedetails/?id=311697867) ( Ignore, not designed as prop )
  * [StevenTechno's Buildings pack](https://steamcommunity.com/sharedfiles/filedetails/?id=331192490)
  * [Mr. Train's M-Gauge rails](https://steamcommunity.com/sharedfiles/filedetails/?id=517442747)
  * [Bobsters's two gauge rails](https://steamcommunity.com/sharedfiles/filedetails/?id=489114511)
  * [Mr. Train's G-Gauge rails](https://steamcommunity.com/sharedfiles/filedetails/?id=590574800)
  * Ron's 56 gauge rails ( Removed by the addon owner and [discontinued](https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master/data/discontinued/owner-discontinued) )
  * [Ron's 2ft track pack](https://steamcommunity.com/sharedfiles/filedetails/?id=634000136) ( [Maintained by the owner](https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master/data/discontinued/owner-maintained) )
  * PHX Tubes **(INCLUDED)**
  * [Magnum's second track pack](https://steamcommunity.com/sharedfiles/filedetails/?id=391016040) ( Ignore, not designed as prop )
  * [qwertyaaa's G Scale Track Pack](https://steamcommunity.com/sharedfiles/filedetails/?id=718239260)
  * [SligWolf's ModelPack](https://steamcommunity.com/sharedfiles/filedetails/?id=147812851) ( Mini hover tracks ) ( White rails )
  * [Ron's Minitrain Props](https://steamcommunity.com/sharedfiles/filedetails/?id=728833183)
  * [Battleship's abandoned rails](https://steamcommunity.com/sharedfiles/filedetails/?id=807162936)
  * [Ron's G-Scale track pack](https://steamcommunity.com/sharedfiles/filedetails/?id=865735701) ( [Maintained by the owner](https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master/data/discontinued/owner-maintained) )
  * [AlexCookie's 2ft track pack](https://steamcommunity.com/sharedfiles/filedetails/?id=740453553)

#### Where are the trains/vehicles[,](https://tfwiki.net/wiki/Team_Bullet_Train) are there any of these?
Dude seriously, make them yourself, what's the point of playing Gmod then ... xD

#### Dude the rails are not showing in the menu, what should I do ?
[SUBSCRIBE TO THE OWNER OF THE ADDON !!!!](https://github.com/dvdvideo1234/TrackAssemblyTool#which-addons-did-you-work-on)

#### Are there going to be more of these?
Yes, I developed my dynamic database, so I can insert any model I want.
When I have free time I will make more, because it's a lot of data I insert in the DB

#### Will you create more models in the future?
Well, It depends on what you mean by `create`.
If it is for the making of the 3D models, then ***NO*** ( big one ) I've got no experience in
that stuff neither am I a 3D artist. Other than that if the models are created by the 3D artists,
I will be more then happy to add them into the Track assembly tool if their collision model meets
the minimum requirements.
( Made a model once, but it turned out quite nasty xD, so better leave the job to the right people.)

#### Could you make the tool so there will be categories for my addon?
Well, yeah, technically I can map any path given. However these with properly
ordered folders are easier to handle. Here are some good and bad practices for folder alignment.
Legend of the path elements used in a model:
```
/            --> Slash represents directory divider ( Like in D:/Steam/common/Garry's mod )
#            --> Any kind of delimiter valid for a file name( Like dashes, underscores etc.)
%addonname%  --> Name of your addon (For example: SPros)
%category%   --> Category, which you want your pieces to be divided by ( Like straight, curves, raps, bridges etc.)
%piecename%  --> The file name of the piece created in the addon ( Ending with *.mdl of course)
```
The good practices ( The category should be bordered by delimiters ):
```
   models/%addonname%/tracks/%category%/%piecename%.mdl
   models/%addonname%/%category%/%piecename%.mdl
   models/%addonname%/%category%#%piecename%.mdl
```
Examples: (`#`="_", `%addonname%`="ron/2ft", `%category%`="tram", `%piecename%`="`%category%`_32_grass.mdl")
```
   models/ron/2ft/tram/tram_32_grass.mdl ( The "tram" is taken right after "models/ron/2ft/" )
```
The the bad practices ( The category is missing or not strongly defined. There is not enough information given):
```
   models/%addonname%/tracks/%piecename%.mdl
   models/%addonname%/%piecename%#255#down.mdl
   models/%addonname%/03#1#asd#%piecename%#90.mdl
```
Examples: (`#`="_", `%addonname%`="props_phx", `%piecename%`="track_128.mdl")
```
   models/props_phx/trains/track_128.mdl ( Here, the category "straight" is not present at all )
```

#### Hey, remember that roller coaster assistant addon, that was snapping pieces when you got them close to each other and they magically connect. Does this script has a feature like this ?
Yes, it does. When looking at the panel in the right, there is a check-box labelled
`Enable physgun snap` that you must check. This makes the server to perform some
traces relative to the active points of the piece and search for other pieces to snap to.
If the snapping conditions are present, it will snap the trace piece on physgun release at
that end, which the server trace hits.

#### Can you tell me how to read the physgun snap legend drawn on the screen ?
Easy. Here are some things to know for never getting confused with this:
1. If the line with the middle circle is green, that means a valid prop entity is traced
The green circle shows where the trace hits and the yellow what part of trace is inside the prop
If in this case the trace is a valid piece, the origin and radius to the point selected are drawn using
a yellow circle line, always shorter than the active radius. After that the spawn position and distance
are drawn by using cyan circle and magenta line respectively. The forward and the up direction vectors
of the origin are drawn using red and blue lines respectively.
2. If the line is yellow, that means the trace has hit something else ( For example the world )
The yellow circle shows again where the trace hits and the red line the part inside the non-prop
3. If there is a red line with yellow circle, then there is an active point there, which is searching
for props to snap to when you drop ( release the left click ) the piece with the physgun.
*You can also disable the drawing by unchecking the `Draw adviser` check-box
or unchecking the option for `Enable physgun snap`, making it pointless to be drawn without the
base option enabled. To enable the drawing, both must be enabled ( Adviser and snapping ).*

#### What is this green line/circle into the base advisor, what is it for ?
Remember when I got suggestions to do the switchers.
This is an easy way of indicating which next active position ( of some )
is chosen when stacking is in place. The end of the line with the green
circle points to the next active position that is chosen.

#### Dude I've messed up my console variables, how can I factory reset them ?
Easy. First, you need to enable the developer mode via `trackassembly_devmode 1`
Then in the bodyguard/skin text box ( or `trackassembly_bgskids` variable ) type:
* `reset cvars`
  Resets all cvars to the factory default settings
* `delete`
  Followed by a space for deleting a bunch exported databases without quitting
  the game, followed by the `prefixes` you want to delete, separated by space,
  You can delete multiple prefixes at once. For client use `cl` and server `sv`.
  Press enter to apply an option from these above and click the `Reset variables` button.

*Note: The console variables being set in this question will be reset also*

#### How can I control errors when the clients are flooding my server with rails, and stacking/spawning outside of the map bounds?
Easy. Just set `trackassembly_bnderrmod` to one of the following values
```
OFF     -> Clients are allowed to stack/spawn out of the map bounds without restriction
LOG     -> Clients are not allowed to stack/spawn out of the map bounds. The error is logged.
HINT    -> Clients are not allowed to stack/spawn out of the map bounds. Hunt message is displayed.
GENERIC -> Clients are not allowed to stack/spawn out of the map bounds. Generic message is displayed.
ERROR   -> Clients are not allowed to stack/spawn out of the map bounds. Error message is displayed.
```
Other value will be treated as `LOG`. But remember young samurai, this variable is only server side,
and because of that you can only access it via single player or set it in the `server.vdf` gmod
start-up file. May the force be with you and your server !
*<br>Note: The error is logged if the logs are enabled !*

#### Is there any feature which can be used to control which log messages can show up and which will not?
You can easily do that by creating settings for the logs. These are nothing more than
text files, where contents are matched to the logs you want to skip. The location that you
must create these files in is located here: `data/trackassembly/trackasmlib_sl<suffix>.txt`
There are the types of logging settings, where the file `<suffix>` matches it with down casing:
  * `skip` (`trackasmlib_slskip.txt`): If a log message is found persisting in this list,
                                   it won't show in the output (a.k.a black listed).
                                   This is good when a function is called many times and floods
  * `only` (`trackasmlib_slonly.txt`): All other log messages will be blocked besides the ones
                                   in this list (a.k.a only ones white listed)
                                   This is good when you want to see only one single thing

These are [mine](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/trackasmlib_slskip.txt) if you want to take a look how to create one.

#### Does this thing have any wire extensions and how can I control then when my clients are abusing them ?
Yes it does. You can enable/disable the wire extension using the
convar `trackassembly_enwiremod` and set it to `0` to disable the wire
extension and `1` to enable it.

#### What do the tool versions represent?
The first number will get an increase when a new major update has arrived.
The second number is the commit number in the repository, related to
some smaller changes and fixes. For example rearranging the code, new features,
performance optimizations, doing the same thing, but in more elegant
way and such.

#### I want to use custom tweaks for my server. Could you recommend appropriate cvars ?
Here is the list of the maximum value tweaks and settings to control the script:
```
  trackassembly_maxtrmarg - Controls the maximum time needed to perform a new player-cached trace
  trackassembly_maxmass   - Controls the mass upper limit of the piece spawned ( the lower bound is "1" )
  trackassembly_maxlinear - Controls the maximum offset that can be applied by next x,y,z linear offsets
  trackassembly_maxforce  - Controls the force limit upper border on the welds made between pieces
  trackassembly_maxactrad - Controls the vastness of the active point search area
  trackassembly_maxstcnt  - Controls the maximum pieces that can be spawned in stacking mode
  trackassembly_maxfruse  - Controls the maximum records that can be located under the frequent pieces list
  sbox_maxprops           - The maximum props on the server ( Gmod default control )
  sbox_maxasmtracks       - A variable for the maximum things spawned via TA
```
You can trigger these limits independently from one another. For example:
  * Value `maxprops` is `50` and `maxasmtracks` is `30` will trigger maxasmtracks
  * Value `maxprops` is `30` and `maxasmtracks` is `50` will trigger maxprops
  * Value `maxprops` is `50` and `maxasmtracks` is `50` will trigger maxasmtracks

*Note: If you want a server with many props and fewer tracks, then lower maxasmtracks
Default value is 1500 for `maxasmtracks` to rely on the props limit.*

#### I want to use Lua mode because I've got third-party SQLite server. How can I switch to Lua mode ?
You can do the following:
  1. On the tool screen next to holder's model validation you shall see the database mode.
  2. Bring up the console and write `trackassembly_modedb LUA` ( or `SQL` to go to SQL mode respectively ).
  3. Press enter and restart Gmod.
  4. Look at the tool screen. After holder's model validation, it shall write the new mode.
  5. Done. You are now in `LUA` mode.

Using `SQL` mode is still the best option for using the tool with for servers, because only a few models have to
stay in the cache for a given amount of time, rather than the whole database forever ( till the server
is up that is ), so please use `SQL` mode when possible if you want to save some amount of RAM.
`LUA` mode is used as a default option, because some people have third party SQL servers, which messes with
the `sql.*` library of the game and does not allow me to create the needed SQL tables and records properly.

#### Can I do something about my server's performance and how can I configure the memory manager properly?
You can choose a memory management algorithm by setting `trackassembly_timermode` to `mode@life@clear@collect`
for any table sequentially divided by `/`. First of all the memory manager is available only in `SQL` mode,
because in `LUA` mode, all the records are already in the memory and thus, there is no need to manage ( delete )
anything automatically. An example timer setting looks something like this: `CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1`.
Here `mode` setting is the memory management algorithm to be used ( either `CQT` or `OBJ` ) for the table.
These are explained below what they do. The `life` in the cache for the record is how much time in seconds
the data will spend sitting in the cache, until it gets deleted to save some memory ( For the example above
a half an hour for `PIECES`, 15 minutes for `ADDITIONS` and 10 minutes for `PHYSPROPERTIES` ).
The greater the number, the more persistent are the records and fewer queries will be used to retrieve the data.
Setting this to `0` will turn off the memory management for the table.
The `clear` setting if different than `0`, assigns a `nil` to the record, marking it for
deletion by Lua's garbage collector. The `collect` setting if different than `0` calls the garbage collector when a
record is marked or equal to `0` leaves it to the game's garbage collector. It's pretty much for you to decide because
every setting has its pros and cons.
  1. `CQT` - The memory management is called every time a new piece is requested from the cache and
        not found. Therefore a query should be processed to retrieve it from the database, so
        as it does at the end it runs a "for k, v pairs(Cache)" cycle, inspecting which record is
        old enough ( not used for given amount of time ) to be deleted and marks it for deletion.
    * Pros: Lighter algorithm.
        No need for additional memory allocation for timers.
        Garbage collector ( `collect` different than `0` ) is called once to process all the obsolete records.
    * Cons: Uses particular points in time when a record is used/loaded and judges by these how old is it.
        Records do not get deleted from the cache at the exact moment when the life in the cache runs out.
    * Used: When there is no need of many timer objects to store in the memory ***OR***
        they cannot be created due to some reasons not related to the TA tool ***OR***
        the time precision does not matter when the record gets deleted ***OR***
        the server will run out of memory when creating too many objects ( timers ).
  2. `OBJ` - It attaches a timer object ( That's why the `OBJ` xD ) to every record
        created in the cache with one repetition for given amount of time ( The life  )
        in seconds. After the time is passed, the record is marked for deletion, and the timer is destroyed.
    * Pros: Obsolete ( not so frequently used ) records are deleted at the exact given time when processed.
        The timer is deleted with the record.
        It uses a running process, rather than points in time to control the memory management.
    * Cons: Heavier algorithm.
        Needs additional memory for the timers.
        Garbage collector ( `collect` different than `0` ) is called on every timer function call.
    * Used: When server has enough memory for the timers ***OR***
        the record has to be deleted at the exact moment the life passes.

#### Does this script store the created queries for later use ?
Yes. That way it performs faster statements generation with very little memory consumed.
Statement storage is based on caller name. Good example is `CacheQueryPiece` where
the program tries to retrieve the generated query, without going trough the trouble to
concatenate all the fields. For the most expensive function `CacheQueryPiece`, the request
is done using the model, so in the statement it is substituted as an argument provided
to `SQLCacheStmt(<hash>, <stmt>, <arguments>)`. That way the base statement
is stored once and formatted every time it needs to be used.

#### Hey, there is a text-box and a drop-down menu next to the `ExportDB` button. What are these for ?
Well, when a server owners set the `trackassembly_maxfruse` to a higher value, a slider appears.
If the client has used many pieces during his/her routine, he/she cannot possibly locate the ones
he/she needs, especially, when they are at the bottom of the list as not `frequently used` pieces.
That's why it was needed some kind of a filter. With the drop-down menu, you can chose whatever
field to filter the data on (`<Search BY>` either `Model`, `Type`, `Name`, `Act`). Do not bother that
the name is not displayed in the pieces list. [That's normal](https://theportalwiki.com/wiki/Cave_Johnson). For 95% of the
models, it is dynamically generated using the `*.mdl` file, so there is really no point in viewing
that parameter on the pieces panel. In the text-box, to search you have to enter a pattern that
you want to perform the filtering with. The result will populate the list view, only with these
pieces, whatever desired field value is matched by the pattern given. The pattern is a standard
Lua one, which is supported by the `string.*` library and you can also [google it](http://lmgtfy.com/?q=lua+string+library+pattern+matching) ;)

#### May I become a volunteer to translate the script to my native language and how can I use translations ?
Yes you may, though always make sure to use the abbreviation for the language codes provided
[here ( Column "ISO 639-1" )](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
If you want to translate it into [Bulgarian](https://en.wikipedia.org/wiki/Bulgarian_language) for example ( my [native](https://en.wikipedia.org/wiki/First_language) ) you must duplicate all the
translations like seen below. I took English translation and translated it to Bulgarian.
```
English  : asmlib.SetLocalify("en","tool."..gsToolNameL..".activrad_con" , "Active radius:")
Bulgarian: asmlib.SetLocalify("bg","tool."..gsToolNameL..".activrad_con" , "Активен радиус:")
```
Change the language used by the game ( cvar `gmod_language` ) to your native. Done !

#### Hey, how should I proceed when I am experiencing errors ?
First of all if the error origin is not the TA,
 I can't pretty much help you with it, but I will do my best
 If the error is related to the TA then:
 1. Delete the external configurations in `..common/GarrysMod/garrysmod/data/trackassembly`
   * Delete database ( if any ) located in `dsv/*.txt`.
       Remember to back up your personal database if any !                 ( optional )
   * Delete the DSV auto-load list located in `trackasmlib_dsv.txt`
       Remember to back up your personal database if any !                 ( optional )
   * Delete the Lua exports ( if any ) located in `ins/*.txt`            ( optional )
   * Delete the Log program settings located in `trackasmlib_sl*.txt`    ( optional )
   * Delete the whole folder if necessary                                ( optional )
       Remember to back up your personal database !                        ( optional )
 2. Delete the TA's `*.gma` file from `garrysmod/addons`
 3. Delete the cache `../GarrysMod/garrysmod/cache`
 4. In the game library, right click on Gmod and select `Properties`
 5. Navigate to `Local Files` and click `Verify integrity of the game cache`
 6. Enter Gmod and while in-game open the console and paste `trackassembly_exportdb 0` ( without the quotes )
 7. Done ! It all should work now. If not, proceed as below ( 8 - 14 )
 8. Enable the logs via the console `trackassembly_logsmax 10000` hit enter
 9. Enable the log file via the console `trackassembly_logfile 1` hit enter
10. Enable developer mode via `trackassembly_devmode 1`
11. Server: Point to the world in-game and press RELOAD ( Default: R )
12. Client: Click the `Reset Variables` button
13. Now the hardest part[.](https://mondomedia.com/embed/Vpbbbc) While in-game do some stuff and make it crash again.
14. Navigate to `..Steam/steamapps/common/GarrysMod/garrysmod/data/trackassembly/trackasmlib_log.txt`
15. Report the log and the errors [here](https://github.com/dvdvideo1234/TrackAssemblyTool/issues)
16. If you don't bother using the workshop ( Yeah, I hate it too ), then please use the
   [GitHub link](https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master)
    or the [SVN](https://github.com/dvdvideo1234/TrackAssemblyTool/trunk) instead.
    Be sure to download only a stable [release version](https://github.com/dvdvideo1234/TrackAssemblyTool/releases)

#### How can I add some personal models to TA to extend the database ?
For every active point, you have to add a line in the table PIECES.
  1. The first method involves editing the general database. That way your custom track
    pieces are not divided and are inside the general data pool for client and server.
    This is good if you want to test something fast.
      1. In the console ( Bring it up with `~` key under ESC ): `trackassembly_exportdb 1` [ press enter ]
      2. Server: Point the crosshair anywhere on the map, then hit SPEED ( Default: Shift ) + RELOAD ( Default: R )
      3. Client: Just bring up the Frequently used pieces screen, then click the `Export client's DB` button
      4. Use Excel or another table editing program to edit the files `sv_*.txt` and `cl_*.txt`
      5. After exporting, tables are located under `..common/GarrysMod/garrysmod/data/trackassembly/dsv/` [DSV Folder]
      6. Navigate to the DSV folder using explorer(Windows)/nautilus(Linux) and proceed
      7. Open all *TRACKASSEMBLY_PIECES.txt files and make your edits using tab-delimited [Excel 2010]
      8. [Excel 2010] `File` -> `Save As` -> Navigate to the `DSV` folder if you are not in there already
      9. [Excel 2010] File name: `*TRACKASSEMBLY_PIECES.txt`
     10. [Excel 2010] Save as type: `Text (Tab delimited)(*.txt)`
     11. [Excel 2010] Replace it if you must (don't worry you can always generate it again ( points 3. and 4. )
     12. [Excel 2010] It will prompt you that the file you are saving does contain features not compatible with `TAB Delimited` format
     13. [Excel 2010] Click `Yes` and close Excel
     14. [Excel 2010] It will want you to save it again, so just click `Don't Save`
     15. [Excel 2010] You are good to go
     If you have trouble with this step by step tutorial, maybe [this](https://www.youtube.com/watch?v=Pz0_RGwgfaY) will help
  2. The second method involves personal `DSV` database. This option is mostly used when you want to
    separate your own stuff from the general data pool. The track pack creators use this method to
    add their custom track models in the database via [Lua script](https://github.com/dvdvideo1234/TrackAssemblyTool#how-how-can-i-make-a-script-which-synchronizes-the-database-of-my-track-pack-). Let's call the `<database_prefix>` `MyStuff_`
    ( what's added ) and your addon name `John Doe's trackpack` ( who has added it a.k.a the data exporter )
      * Navigate to `..common/GarrysMod/garrysmod/data/trackassembly`
      * Open the file `trackasmlib_dsv.txt`. If it does not exist then just create it.
        * You can always comment an addon to prevent it loading its pieces to the database via `#`
            a hash tag symbol in front of the line which you want disabled.
      * Inside the file you just have to add the content `<database_prefix>[TAB symbol]<data_exporter>`
        * For the example above you will have `MyStuff_[-->]John Doe's trackpack`
        * The second value is optional, but you will need a tab symbol to separate these
            two if you put it there. If you don't put it, you need only the prefix
      * Open the file `dsv/MyStuff_TRACKASSEMBLY_PIECES.txt`
         If it does not exist then just create it. This file is mandatory. Now insert
         [your track piece models](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/Test_s_track_packTRACKASSEMBLY_PIECES.txt)
         and they will be loaded during the tool initialization
      * Open the file `dsv/MyStuff_TRACKASSEMBLY_CATEGORY.txt`. If it does not exist then just create it.
         This is optional ! It is done when you want to use classification categories for your database
         The format contains open definition delimiter, closing one and a separator.
         Between these you must have your addon name and a function defined as a string. The token
         opening the definition is `[===[` `(1)`. The token used for delimiter is `===` `(2)`. The closing
         sequence for the definition is `]===]` `(3)` and it means that the definition ends.
         Between `(1)` and `(2)` you must have the addon name (ex. John Doe's trackpack)
         Between `(2)` and `(3)` you must have an actual Lua function written as string
         `function(m) ( do some stuff ) end`, where the `m` parameter is dynamically populated
         with the track piece model path. You must use that value to extract the category
         you need. Usually this is one of the
         [sub-directories of the model](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/Test_s_track_packTRACKASSEMBLY_CATEGORY.txt)
         path or piece prefix/suffix
      * Open the file `dsv/MyStuff_TRACKASSEMBLY_ADDITIONS.txt`
         This is optional ! If it does not exist then just create it. This file hold definitions of what props
         must be spawned with the track pieces. These are like scenery, buttons and stuff.
         A good example for an addon which uses [ADDITIONS](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/cl_TRACKASSEMBLY_ADDITIONS.txt) parameters is `Shinji's track pack`
      * Open the file `dsv/MyStuff_TRACKASSEMBLY_PHYSPROPERTIES.txt`
         This is optional ! If it does not exist then just create it. This part is optional if you need
         additional physical properties

*Note: After adding these models, the database can be exported again.
This will generate export data, that can be located under `../data/trackassembly/exp/`
If you want me to review your custom models/addon, please provide these inserts to me.
Whether it is for PIECES, ADDITIONS, PHYSPROPERTIES, these files will be generated with
the instance prefix also `( cl_*.txt and sv_*.txt )`. **Please provide me the client side file.***

#### How, how can I make a script which synchronizes the database of my track pack ?
You must add your addon to the auto-load pieces list located in `/data/trackassembly/trackasmlib_dsv.txt`
This registers your `*.txt` files for automatic database insertion during tool script initialization.
To disable an addon from loading its pieces in the database, you can always comment it via a
hash tag `#` in front of the line definition that you want disabled. The addon registered multiple
times will not be loaded on start-up until the user makes a review of the auto-load list for the
repeating sequences for the given prefix. The adding is done using the function `RegisterDSV`.
Beware that you need a lock file not to add the same addon on both client and server.
After this is ready you must add your pieces. You must create you own Lua file which generates
the table data in `DSV` format ( tab delimited ). There is this `SynchronizeDSV`
function, which does exactly that. It's always good to have the pieces table used for a locking file.
If you want to use categories for your custom pieces list, you must use the `ExportCategory` function.
Every question you may have for creating such script is explained in the example below,
where you have to call it on auto-run. For example: `your_addon/lua/autorun/your_script.lua`
[like this](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/autosave/z_autorun_add_pieces.lua).
After you test your script and it does work with TA you can add it to your track pack,
upload it to the workshop without any hassle as it is `*.lua` file and it will not be rejected.
*Note: When all your script goes according to the plan you will have this:*
![AddonScriptAdd](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/track_addon.jpg)

#### May I put this thing in another third party website ?
***No I will not give you my permission to do that... Why ...***
That way you will upload some half-baked malicious tool, waste your time with stupid
things and confuse everybody with this so-called `unofficial` version of the Track assembly tool.
Not to mention that the stunned people ***will NOT GET ANY updates*** !
The best you can do is just point to the [original GIT repository](https://github.com/dvdvideo1234/TrackAssemblyTool)
avoiding any version mismatches and confusions. So please don't upload the script to any other sites. ***I mean it!***
