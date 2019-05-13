# TrackAssembly

---

# Copyright 2015 [ME](http://steamcommunity.com/profiles/76561197988124141) !

## IF YOU HAPPEN TO FIND REUPLOADS WITH DIFFERENT ORIGIN REPORT THEM TO ME IMMIDEATELY !!!

![TrackAssemblyTool](https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/screenshot.jpg)

## Description

This script can give you the ability to connect prop-segmented track pieces fast.
It is optimized and brings the track building time consuming to a minimum.
It uses pre-defined active points to snap the segments the best way there is in
[Garry's Mod](https://store.steampowered.com/app/4000/Garrys_Mod/).

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

#### What kind of features does this script has?
  * Track curve fitting alignment based on [ray intersection for precise piece layout](https://www.youtube.com/watch?v=1rsDHU79J50)
  * [Extendible database](https://github.com/dvdvideo1234/TrackAssemblyTool/wiki/Database-extension) via delimited [text file](https://www.youtube.com/watch?v=Pz0_RGwgfaY) or a [lua script](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/autosave/z_autorun_add_pieces.lua)
  * [Extendible database](https://github.com/dvdvideo1234/TrackAssemblyTool/wiki/Database-extension) via text file [load list](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/trackasmlib_dsv.txt) and [list prefixes](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/Test_s_track_packTRACKASSEMBLY_PIECES.txt) [categories](https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/Test_s_track_packTRACKASSEMBLY_CATEGORY.txt)
  * Switching database storage between Lua table and SQL
  * Spawning pieces on the map
  * Snapping pieces on the map surface ( if checked )
  * Snapping the first piece angle to user defined value
  * Snapping already spawned pieces by [using only the physgun](https://www.youtube.com/watch?v=BxMlZMMGHrs)
  * Snapping/spawning with [custom user offsets](https://www.youtube.com/watch?v=e1IK2zJ_Djk)
  * Snapping/spawning with zero pitch and roll. Good for track leveling
  * Snapping/spawning at the mass-center or the active point ( if checked )
  * Fast changing the active track ends ( Alt + mouse scroll ). Good switching turns direction
  * Custom user defined active radius based snapping
  * Custom active point and radius location assistant
  * Custom active point position angle and orientation adviser
  * Advanced duplicator can be used on the track created
  * Custom [entity][ref-entity] properties ( weld, freeze, no-collide )
  * User can disable phys-gun grabbing on a piece. Good for turntables
  * Ability to list up the most used pieces on the server ( E + MRIGHT ). Close shortcut (ALT + E)
  * Ability to search among the most server popular pieces by [Lua patterns](https://www.lua.org/pil/20.2.html)
  * Ability to export server and client database as a file
  * Tool-tips for every button are available and can be [translated easily](https://github.com/dvdvideo1234/TrackAssemblyTool/wiki/Translations)
  * Ability to spawn scripted track switches of other dedicated class ( Ron's 2ft )
  * Ability to modify the bodygroups and skins of a track piece ( with duping )
  * Ability to modify track piece [surface behavior](https://www.youtube.com/watch?v=ALBnlFeC9tU) ( wood, metal, slime, tire )
  * Ability to extend a track piece spawn with [additional entities](https://www.youtube.com/watch?v=jKGBUNDMN6A)
  * Includes integrated wiremod extension for processing and reading the database

#### Where can I find the tool in-game ?
You can find the tool in the `Constriction` section of Garry's mod
[spawn menu](https://wiki.garrysmod.com/page/Opening_The_Spawnmenu) under the name of `Track assembly`.
**The name of the tool depends on what language are you using when playing Garry's mod.**
On the right in the tool's menu, you can locate the track pieces tree.
Expand the desired piece type to use for building your track by clicking on a node, then select the desired piece.

#### How can I chose and select a desired track end ?
Just hold `KEY_LALT` ( Default: LALT ) and turn the mouse scroll around.
This will make the script chose the track active point you want.
When You hold `SPEED` ( Def: SHIFT ) the script will switch to
adjusting the next active point for the track stacking option.
This will affect what point is chosen when you continue the track you build.
The current and next active points will not be the same.

#### How do I use the old way for switching between the active points ?
There is this variable `trackassembly_enpntmscr` and as its name suggests
it controls the ***enable end-point mouse scroll***. Set it to `1` if you want
to switch the track ends via the mouse scroll or set it to `0` if you want
to use the old-school for the way of changing and selecting track ends.

#### Hey, I cannot align my track curves properly. Can you help ?
Yep sure. In the right panel, there is a drop-down menu which has a bunch of tool modes listed.
Go ahead and select the `Active point intersection`. After you change the mode, an intersection
relation [entity][ref-entity] is needed to complete the process. Hitting `SPEED + RELOAD` ( Default: Shift + R )
just like the anchor, will select the relation active point of the [entity][ref-entity] in question, which is closest
to the player hit position. Now trace a track piece and the ghost of the curve will be drawn. You can
clamp the spawn position in a box using the primary position flag `applinfst ( Apply linear first )` or switch
the origin angle with the ray direction angle by using primary angle flag `appangfst ( Apply angular first )`
In this working mode the angular and linear offsets adjust the piece offsets relative to the ray intersection
position where the trace and relation rays meet. Press `ATTACK1` ( Def: Left click ) if you are happy with where
the ghost is located and where the spawn piece will go at.

#### How can I use switchers ? I can't seem to make them work.
Every addon has its own way for dealing with the switchers. Others that are not listed here do not
have dedicated track switchers, so to switch them you must use two track pieces inside of each other.
Swap their solidness around using the [fading door tool](https://steamcommunity.com/sharedfiles/filedetails/?id=115753588),
so when one is solid a.k.a `CLOSED` and you can't pass trough it, the other must be no-collided to all `OPENED`. Therefore the
wheels of the train will follow only the track that is currently set being solid with fading door `CLOSED` function state:
 1. Dedicated [entity][ref-entity] addition like a lever you must press with your USE key
    * [Shinji85's Rails](https://www.youtube.com/watch?v=cHhf83w-YNM)
 2. Dedicated switcher [entity][ref-entity] class you must press
    with your USE key. You must press the [entity][ref-entity] custom switcher class itself:
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

#### How to use the tool control options when building a track ?
1. Pressing ATTACK1 ( Default: Left mouse button )
    1. When you are looking at the world the piece will just be spawned on the map.
    2. When you are looking at one of track piece's pre-defined active points
      * Will snap the piece that you're holding to the trace one.
      * If the traced piece's type is different than the holder piece's type,
        please check `Ignore track type` check-box.
      * If `Enable advisor` is checked, a coordinate system will appear,
        marking the origin position on the traced piece
      * If `Ghosts count` is larger than zero ghosted track pieces will be
        rendered to assist you with the building.
    3. When you are not looking at one of track piece's pre-defined active points,
      * Pressing USE ( Default: E ) Applies the physical settings/properties on a piece.
      * If not, you will update the piece's bodygroups/skin.
2. Pressing SPEED ( Default: SHIFT ) + ATTACK1 ( Default: Left mouse button )
Will stack as many pieces as shown by the slider `Pieces count`.
3. Pressing ATTACK2 ( Default: Right mouse button )
      * Will select the trace model to use as a piece for building a track.
4. Pressing USE ( Default: E ) + ATTACK2 ( Default: Right mouse button )
      * When pointing to the world will open the `Frequent pieces by <PLAYER_NAME_HERE>` frame, from where
       you can select your routine pieces to use again in the track building process
       as well as [searching in the table](https://github.com/dvdvideo1234/TrackAssemblyTool#hey-there-is-a-text-box-and-a-drop-down-menu-next-to-the-exportdb-button-what-are-these-for-) either by `MODEL`, `TYPE`, `NAME`, `LAST_USED` to obtain the piece
       you want to continue your track with.
5. Pressing RELOAD ( Default: R )
      * When used in the world exports the database if the console variable `trackassembly_exportdb` is set to <>0,
      * When used on trace it removes it, if it's a track piece.
6. Pressing RELOAD ( Default: R ) + SPEED ( Default: SHIFT )
      * When pressing it on the world will clear the tool's selected prop to attach all the track pieces to ( anchor ).
      * When pressing it on the trace prop will set it as an anchor for other pieces spawned to be constrained to.
7. If you want to obtain different grip behavior for a wheel-powered/sliding train,
   you must use the surface material drop-down menus as you select first `TYPE` then `NAME`.
8. If you want to use desired bodygroups and/or skins on a piece, in the text field you must type bodygroup/skin
   selection code or generate one using the SCORE ( Default: TAB ) key while pointing to a prop with
   bodygroups/skins set by Garry's mod [context menu](https://wiki.garrysmod.com/page/The_Context_Menu). Press `ENTER` in the text field if you
   are happy with the selection to apply it.
9. Piece mass slider is used to set the mass of the next track piece to be spawned.
10. Active radius is used to set the minimum distance needed to select an active point when pointing at a piece.
11. Pieces count shows the maximum number of pieces to be stacked.
12. The `Angular alignment` slider is used to snap the first piece ( Requested by [Magnum](http://steamcommunity.com/profiles/76561198004847743) )
   to a user-defined angle ( Usually 45 ) so that the track building process becomes easier. The
   whole track build will be snapped also because you are building it relative to the first piece.
13. The force limit slider ( Requested by `The Arbitor 90` ) defines the maximum force to be applied
   on the weld joint between two pieces connected before it breaks. You can use this to build collapsible
   track bridges. Set the option to zero if you want it to be unbreakable ( by default ).
14. The weld/no-collide/freeze/phys-gun grab/gravity are considered basic Gmod knowledge,
   because they are defined by their own and not going to be explained further.
15. The `Ignore track type` check-box if checked, will enable snapping between pieces of a different type.
16. The `Spawn horizontally` ( as the name suggests ) if checked, will spawn the next pieces horizontally to the
   map ground if the additional angle offsets are zeros. If not they will be added to the resulting angle.
17. The `Origin from mass-centre` check-box if checked, will align the piece spawned to its mass-centre.
18. The `Snap to trace surface` check-box if checked, will snap the chosen track directly to the trace surface.
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
  * [SligWolf's Tiny hover racer](https://steamcommunity.com/sharedfiles/filedetails/?id=1375275167)

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

#### Hey, do you remember that roller coaster assistant addon ?
It was snapping pieces when you got them close to each other and they magically connect.
Does this script has a feature like this ? Yes, it does. When looking at the panel in the right, there is a check-box labeled
`Enable physgun snap` that you must check. This makes the server to perform some
traces relative to the active points of the piece and search for other pieces to snap to.
If the snapping conditions are present, it will snap the trace piece on physgun release at
that end, which the server trace hits. Check the [wiki page](https://github.com/dvdvideo1234/TrackAssemblyTool/wiki/Additional-features#physgun-snapping-feature) for more information.

#### Can you tell me how to read the physgun snap legend drawn on the screen ?
Easy. Here are some things to know for never getting confused with this:
1. If the line with the middle circle is green, that means a valid prop [entity][ref-entity] is traced
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

#### Hey, there is a text-box and a drop-down menu next to the `ExportDB` button. What are these for ?
Well, when a server owners set the `trackassembly_maxfruse` to a higher value, a slider appears.
If the client has used many pieces during his/her routine, he/she cannot possibly locate the ones
he/she needs, especially, when they are at the bottom of the list as not `frequently used` pieces.
That's why it was needed some kind of a filter. With the drop-down menu, you can chose whatever
field to filter the data on (`<Search BY>` either `Model`, `Type`, `Name`, `Act`). Do not bother that
the name is displayed in the pieces list. [That's normal](https://theportalwiki.com/wiki/Cave_Johnson). For 95% of the
models, it is dynamically generated using the `*.mdl` file, so there is really no point in viewing
the model parameter on the pieces panel. If you need the model you can right-click its dedicated line
in the list to copy it into the clipboard. In the text-box, to search you have to enter a pattern that
you want to perform the filtering with. The result will populate the list view, only with these
pieces, whatever desired field value is matched by the pattern given. The pattern is a standard
Lua one, which is supported by the `string.*` library and you can also [google it](http://lmgtfy.com/?q=lua+string+library+pattern+matching) ;)

#### May I put this thing in another third party website ?
***No I will not give you my permission to do that... Why ...***
That way you will upload some half-baked malicious tool, waste your time with stupid
things and confuse everybody with this so-called `unofficial` version of the Track assembly tool.
Not to mention that the stunned people ***will NOT GET ANY updates*** !
The best you can do is just point to the [original GIT repository](https://github.com/dvdvideo1234/TrackAssemblyTool)
avoiding any version mismatches and confusions. So please don't upload the script to any other sites. ***[I mean it!](https://www.youtube.com/watch?v=b1Om3vX1GlA)***

[ref-entity]: http://wiki.garrysmod.com/page/Category:Entity
