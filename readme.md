# TrackAssembly

---

# Copyright 2015 [ME](http://steamcommunity.com/profiles/76561197988124141) !

## IF YOU HAPPEN TO FIND REUPLOADS WITH DIFFERENT ORIGIN REPORT THEM TO ME IMMIDEATELY !!!

![TrackAssemblyTool][ref-screenshot]

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
  * Context menu for direct track entity [value export and manipulation][ref-value-exp]
  * Track curve fitting alignment based on [ray intersection for precise piece layout][ref-vid-inters]
  * [Extendible database][ref-dbext] via [text file][ref-text-file] or a [lua script][ref-lua-script]
  * [Extendible database][ref-dbext] via [load list][ref-load-list] and [list prefixes][ref-list-pref]
    [type categories][ref-categ]
  * Switching database storage between [Lua table][ref-ltab] and [SQLite][ref-tsql]
  * Spawning pieces on the map
  * Snapping pieces on the map surface ( if checked )
  * Snapping the first piece angle to user defined value
  * Snapping already spawned pieces by [using only the physgun][ref-vid-physnap]
  * Snapping/spawning with [custom user offsets][ref-usr-offs]
  * Snapping/spawning with zero pitch and roll. Good for track leveling
  * Snapping/spawning at the mass-center or the active point ( if checked )
  * Fast changing the active track ends ( `ALT` + mouse scroll ). Good switching turns direction
  * Custom user defined active radius based snapping
  * Custom active point and radius location assistant
  * Custom active point position angle and orientation adviser
  * Advanced duplicator can be used on the track created
  * Custom [entity][ref-entity] properties ( weld, freeze, no-collide )
  * User can disable phys-gun grabbing on a piece. Good for turntables
  * Ability to list the frequent pieces on the server (`MRIGHT`). Close shortcut (`ALT + E`)
  * Ability to search among the most server popular pieces by [Lua patterns](https://www.lua.org/pil/20.2.html)
  * Ability to export server and client database as a file
  * Tool-tips for every button are available and can be [translated easily][ref-trans]
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
Just hold `KEY_LALT` ( Def: `LALT` ) and turn the mouse scroll around.
This will make the script chose the track active point you want.
When You hold `SPEED` ( Def: `SHIFT` ) the script will switch to
adjusting the next active point for the track stacking option.
This will affect what point is chosen when you continue the track you build.
The current and next active points will not be the same.

#### I am scrolling and the point mouse scroll is enabled. Why is the track end not switched?
Sometimes selecting last weapon is bind to the `KEY_LALT` ( Def: `LALT` )
button by default. If that condition is present for you, the mouse scroll track piece
selecttion will not work. If you insist of using the mouse scroll and I don't blame you,
because it's faster and much convinient, just unbind the `KEY_LALT` ( Def: `LALT` ) button
via `unbind alt` ( `unbind <key_binded> ` ). That way the game will no longer process alt with priority to last weapon switch.

#### How do I use the old way for switching between the active points ?
There is this variable `trackassembly_enpntmscr` and as its name suggests
it controls the ***enable end-point mouse scroll***. Set it to `1` if you want
to switch the track ends via the mouse scroll or set it to `0` if you want
to use the old-school for the way of changing and selecting track ends.

#### Hey, I cannot align my track curves properly. Can you help ?
Yep sure. In the right panel, there is a drop-down menu which has a bunch of tool modes listed.
Go ahead and select the `Active point intersection`. After you change the mode, an intersection
relation [entity][ref-entity] is needed to complete the process. Hitting `SPEED + RELOAD`
( Def: `SHIFT + R` ) just like the anchor, will select the relation active point of the
[entity][ref-entity] in question, which is closest to the player hit position. Now trace a track
piece and the ghost of the curve will be drawn. You can clamp the spawn position in a box using
the primary position flag `applinfst ( Apply linear first )` or switch
the origin angle with the ray direction angle by using primary angle flag
`appangfst ( Apply angular first )`. In this working mode the angular and linear offsets adjust the
piece offsets relative to the ray intersection position where the trace and relation rays
meet. Press `ATTACK1` ( Def: Left click ) if you are happy with where
the ghost is located and where the spawn piece will go at.

#### The tool has too few track varieties. Can you make the pieces resizable ?
In sorta yes, however, there is no way to add this feature natively and so far I did not found a decent method,
which will not potentially break the entire game. While resizing props client-side is quite easy, in the server,
this task is very hard, close to impossible. The gmod API does not provide an ellegant solution to this,
which meets the real-time performance requirements. Resizing track curves is by far the most complex task of this
sort as far as evert single piece is conserned. If you take the track width in consideratoion, the resizing method
must not just select `X`, `Y` or `Z` axes, because the piece will get distortions along the curve ( ex. For `90`
degree curves streching by `X` will increase first point lenght, however, it will also adjust the second point width )
In Gmod there is this [`PhysicsInitConvex`][ref-resz-api] API that does
just that, but the spawning will take a very long time considering the amount it tates to resize every polygon on the
server. When the track is spawned outside the map bounds it will immidiately crash the game.
Thus, I beleve that stacking two or more tracks is always better than resizing a prop !

#### How can I use switchers ? I can't seem to make them work.
Every addon has its own way for dealing with the switchers. Others that are not listed here do not
have dedicated track switchers, so to switch them you must use two track pieces inside of each other.
Swap their solidness around using the [fading door tool][ref-fade-door],
so when one is solid a.k.a `CLOSED` and you can't pass trough it, the other must be no-collided to all `OPENED`. Therefore the
wheels of the train will follow only the track that is currently set being solid with fading door `CLOSED` function state:
 1. Dedicated [entity][ref-entity] addition like a lever you must press with your `USE` key
    * [Shinji85's Rails](https://www.youtube.com/watch?v=cHhf83w-YNM)
 2. Dedicated switcher [entity][ref-entity] class you must press
    with your `USE` key. You must press the [entity][ref-entity] custom switcher class itself:
    * `Sligwolf's mini trains`
    * `SligWolf's White Rails`
    * `Ron's 2ft track pack`
 3. Dedicated switched/unswitched model. You have to swap the two [models][ref-model] around
    to switch the track by using a script ( [gLua][ref-glua], [E2][ref-exp2], [EAdv][ref-expadv],
    [Starfall][ref-starfall] )
    * `Robster's pack`
    * `AlexCookie's 2ft track pack`
 4. Dedicated switcher model and a switcher moving needle that you must assemble to get track switching functionality
    * `Mr.Train's M-Gauge`
    * `Mr.Train's G-Gauge`
    * `Battleship's abandoned rails`

#### How to use the tool control options when building a track ?
1. Pressing `ATTACK1` ( Def: Left mouse button )
  * When you are looking at the world the piece will just be spawned on the map.
  * When you are looking at one of track piece's pre-defined active points
    * Will snap the piece that you're holding to the trace one.
    * If the traced piece's type is different than the holder piece's type,
      please check `Ignore track type` check-box.
    * If `Enable advisor` is checked, a coordinate system will appear,
      marking the origin position on the traced piece
    * If `Ghosts count` is larger than zero ghosted track pieces will be
      rendered to assist you with the building.
  * When you are not looking at one of track piece's pre-defined active points,
    * Pressing `USE` ( Def: E ) Applies the physical settings/properties on a piece.
    * If not, you will update the piece's bodygroups/skin.
2. Pressing `SPEED` ( Def: `SHIFT` ) + `ATTACK1` ( Def: Left mouse button )
  * Will stack as many pieces as shown by the slider `Pieces count`.
3. Pressing `ATTACK2` ( Def: Right mouse button )
  * When pointing to the world will open the `Frequent pieces by <PLAYER_NAME_HERE>` frame,
    from where you can select your routine pieces to use again in the track building process
    as well as [searching in the table][ref-search] either by `MODEL`, `TYPE`, `NAME`, `LAST_USED`
    to obtain the piece you want to continue your track with.
  * When pointing to a prop will select the trace model to use as a piece for building a track.
  * **Note: When `trackassembly_enpntmscr` is disabled, you have to press `USE` ( Def: `E` )
    to run these, otherwise just the active track points will be switched using the old
    method of selection.**
4. Pressing `RELOAD` ( Def: `R` )
  * When pressing it on the world will clear the tool's selected prop to attach all the
    track pieces to ( anchor / relation ).
  * **Note: When `trackassembly_devmode` is enabled, will update the log control options.**
  * **Note: When `trackassembly_exportdb` is enabled and `USE` ( Def: `E` ) is pressed, the
    external database manager menu will be opened to confugure database pefixes, otherwise
    will export the [server database][ref-sv-db] [`sv_`][ref-dsv-dir] as a file
    in [DSV format][ref-dsv-dir].**
  * When pressing it on the trace prop will set it as an anchor/relation for other pieces spawned
    to be constrained to.

#### Context menu pieces manipulation
The [context menu][ref-ctx-menu]
options are used to manipulate the selected track pieces directly or
as an interface to export various entity values to the tool console variables.
Explanation of each control option is given in the summary below.
1. `Piece model` option exports the selected track model to the tool console
    variables. This is the same as copying the model via right click.
2. `Bodygroup/Skin` option transfers the generated bodygroup/skin selection
    to the tool console variables and populates the dedicated value display in the
    tool panel. The textbox is only a display and cannot be modified manually.
3. `Surface material name` option will export the surface material name to the
    tool console variables. This option will also update the properties name
    combo box to display the new value that is used.
4. `Piece mass` option exports the selected track mass to the
    tool console variables. The tool panel mass slider is updated accordingly
5. `Ignore physics gun` option toggles the physics gun grabbing function on the track piece
    selected. When the grabbing is disabled, the player cannot interact with the
    track piece in any way, including grab, shake or unfreeze. This is good when you make
    turntables or attach moving tracks or needles, which must not be affected by any player's
    physics gun. If the option is enabled, click it again to disable it or the other way around.
6. `Freeze piece` option will put the track piece in a frozen state and it will disable
    its motion. The piece stays in the same position until external fore is applied on it.
    This is good when you want your track bridge to have fake non-welded pieces.
    If the option is enabled, click it again to disable it or the other way around.
7. `Apply piece gravity` option controlls the gravity affecting the selected track piece.
    If the option is enabled, click it again to disable it or the other way around.
8. `Weld` option controlls the created welds on a piece. You must select an anchor to weld
    the right clicked piece to, when you are in regular `SNAP` mode displayed on the tool screen.
    when the anchor is not selected or it is invalid, a message will be displayed to warn you.
    You can also remove welds by holding `SPEED` ( Def: SHIFT ) and clicking the option.
    The amount of welds will be displayed next to the optoion control.
9. `NoCollide` option controlls the created collides on a piece. You must select an anchor
    to nocollide the right clicked piece to, when you are in regular `SNAP` mode displayed on
    the tool screen. When the anchor is not selected or it is invalid, a message will be displayed
    to warn you. You can also remove nocollides by holding `SPEED` ( Def: SHIFT ) and clicking
    the option. The amount of nocollides will be displayed next to the optoion control.
9. `NoCollide world` option controlls the created world collides on a piece. The constraint
    acnchor in this case is the world itself. Click on the option to create no collide world
    constrant or by holding `SPEED` ( Def: SHIFT ) and click to remove it. The flag of
    of the constraint will be displayed in the menu control option. The value will be `true`
    if there is a still a no-collide world and [`phys_ragdollconstraint`][ref-rag-constr] between
    the piece and the world. If it stays in `true` after you remove it, that means there are more
    than one constraints remaining connected to the trace.

#### How to use the tool control panel and what function does each item have ?
1. `Track surface grip modifier` combo box is used if you want to obtain different
    grip behavior for a wheel-powered/sliding train,
    you must use the surface material drop-down menu combo boxes as you select first
    `TYPE` from the top one to setup the group of properties you want to apply then
    `NAME`, to select the actual surface material you want applied.
2. `Piece bodygroups and skin selection` is used when you want desired bodygroups
    and/or skins on a piece. The textbox is a display showing the `bodygroup/skin`
    selection code (ex. `1,2,3,4/5`) generated using the [context menu][ref-ctx-menu].
    You cannot change the textbox value manually by tiping. Currently `Bodygroup/Skin`
    (ex. [English](https://en.wikipedia.org/wiki/English_language)) option name will vary
    based on the language used.
    When you click it it will populate the text display in the tool menu.
3. `Piece mass` setup control slider is used to set the mass of the next track piece to be
    spawned. The larger the number the havier spawned track piece gets. Larger values are
    recommended.
4. `Active radius` control slider is used to set the minimum distance needed to select an
    active point when
    pointing at a piece. Keep this maxed out if you don't want to bother with track end selection.
5. `Stack count` control value shows the maximum number of pieces to be snapped in `stacking` mode.
    Change this to something larger than one if you want to extend your track by stacking.
6. `Angular alignment` control
    The slider is used to snap the first piece ( Requested by [Magnum](http://steamcommunity.com/profiles/76561198004847743) )
    to a user-defined angle ( Usually `45` ) so that the track building process becomes easier. The
    whole track build will be snapped also because you are building it relative to the first piece.
7. `Force limit` control ( Requested by `The Arbitor 90` ) defines the maximum force to be applied
    on the weld joint between two pieces connected before it breaks. You can use this to build collapsible
    track bridges. Set the option to zero if you want it to be unbreakable ( by default ).
8. Options `weld`, `no-collide`, `no-collide world` ( Requested by Frosty ), `freeze`,
    `phys-gun grab` and `gravity` are considered basic Gmod knowledge, because they are
    defined by their own and not going to be explained further.
9. Option `Ignore track type` if checked, will enable snapping between pieces of a different
   types.
10. Option `Spawn horizontally` ( as the name suggests ) if checked, will spawn the next
    pieces horizontally relative to the map ground if the additional angle offsets are zeros.
    If not they will be added to the resulting angle.
11. Option `Origin from mass-center` if checked, will align the piece spawned to its
    mass-center.
12. Option `Snap to trace surface` if checked, will snap the chosen track directly to the
    trace surface.
![SurfSnap][ref-surf-snap]

13. Option `Draw adviser` if checked, will draw a composition of lines and circles to assist you with the building.
![DrawAdvaiser][ref-adviser]

14. Option `Draw assistant` if checked, will draw circles to assist you where the active points are.
![PointAssist][ref-pnt-assist]

15. Option `Ghosts count` if greater than zero, will create a ghosts stack client-side to assist you with the track
    building process. If you set this option to zero, ghosting will be disabled.
16. When building a track using a different than the default way is needed you may use:
  * `Origin <ang_comp>`, where `<ang_comp>` can be either `pitch`, `yaw` or `roll` are the angle
    offsets used for orientating the base coordinate system in order to snap the piece as the user desires.
  * `Offset <vec_comp>`, where `<vec_comp>` can be either `X`, `Y` or `Z` are linear offsets used for
    additional user offset regarding the next track piece to be spawned.
17. The button `V Reset variables V` as the name suggests clears the offsets mentioned in (16).

#### What will happen if something gets updated?
First of all this FAQ will be UPDATED AS THE TOOL GOES. So everything that
the tool supports will be represented here as a manual or something.
More information I publish you can also find in [the wiki page here](https://github.com/dvdvideo1234/TrackAssemblyTool/wiki).
That's what is this FAQ for anyway ( Though most people don't bother to read it before asking )...

#### Which addons did you work on?
Here they are, with available status, why I did not do some of them ( at the time of developing ).
The ones that are **included** in Garry's mod do not have links and are marked below:
  * PHX Monorails **(INCLUDED)**
  * PHX Regular Tracks ( For `switcher_2` `[X]` in the name as it misses collision meshes ) **(INCLUDED)**
  * [SligWolf's Rerailers](https://steamcommunity.com/sharedfiles/filedetails/?id=132843280) old and new(1,2,3)
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
  * Ron's 56 gauge rails ( Removed by the addon owner and [discontinued][ref-discontinued] )
  * [Ron's 2ft track pack](https://steamcommunity.com/sharedfiles/filedetails/?id=634000136) ( [Maintained by the owner]() )
  * PHX Tubes **(INCLUDED)**
  * [Magnum's second track pack](https://steamcommunity.com/sharedfiles/filedetails/?id=391016040) ( Ignore, not designed as prop )
  * [qwertyaaa's G Scale Track Pack](https://steamcommunity.com/sharedfiles/filedetails/?id=718239260)
  * [SligWolf's ModelPack](https://steamcommunity.com/sharedfiles/filedetails/?id=147812851) ( Mini hover tracks ) ( White rails )
  * [Ron's Minitrain Props](https://steamcommunity.com/sharedfiles/filedetails/?id=728833183)
  * [Battleship's abandoned rails](https://steamcommunity.com/sharedfiles/filedetails/?id=807162936)
  * [Ron's G-Scale track pack](https://steamcommunity.com/sharedfiles/filedetails/?id=865735701) ( [Maintained by the owner][ref-maintained] )
  * [AlexCookie's 2ft track pack](https://steamcommunity.com/sharedfiles/filedetails/?id=740453553)
  * [SligWolf's Tiny hover racer](https://steamcommunity.com/sharedfiles/filedetails/?id=1375275167)
  * [Joe's track pack](https://steamcommunity.com/sharedfiles/filedetails/?id=1658816805)
  * [StevenTechno's Buildings pack 2.0](https://steamcommunity.com/sharedfiles/filedetails/?id=1888013789)
  * [Modular canal props](https://steamcommunity.com/sharedfiles/filedetails/?id=1336622735) ( Interior only )

#### Where are the trains/vehicles[,](ref-easter) are there any of these?
Dude seriously, make them yourself, what's the point of playing Gmod then ... xD

#### Dude the rails are not showing in the menu, what should I do ?
[SUBSCRIBE TO THE OWNER OF THE ADDON !!!!](https://github.com/dvdvideo1234/TrackAssemblyTool#which-addons-did-you-work-on)

#### Are there going to be more of these?
Yes, I developed my dynamic database, so I can insert any model I want.
When I have free time I will make more, because it's a lot of data I insert in the DB

#### Will you create more [models][ref-model] in the future?
Well, It depends on what you mean by `create`.
If it is for the making of the 3D models, then ***NO*** ( big one ) I've got no experience in
that stuff neither am I a 3D artist. Other than that if the models are created by the 3D artists,
I will be more then happy to add them into the Track assembly tool if their collision model meets
the minimum requirements.
( Made a model once, but it turned out quite nasty xD, so better leave the job to the right people.)

#### Hey, do you remember that roller coaster assistant addon ?
Yes, it was snapping pieces when you got them too close to each other and they magically connect.
When looking at the panel in the right, there is a check-box labeled
`Enable physgun snap` that you must check. This makes the server to perform some
traces relative to the active points of the piece and search for other pieces to snap to.
If the snapping conditions are present, it will snap the trace piece on physgun release at
that end, which the server trace hits. Check the [wiki page][ref-phys-snap] for more information.

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

#### Does the script have manipulation panels of some sort like in [precision alignment][ref-PA]?
Yes, it does. You can find the manipulation panels description in the
[additional features][ref-add-ftr] list in the [wiki page][ref-wiki-ta].

#### May I put this thing in another third party website ?
***No I will not give you my permission to do that... Why ...***
That way you will upload some half-baked malicious tool, waste your time with stupid
things and confuse everybody with this so-called `unofficial` version of the Track assembly tool.
Not to mention that the stunned people ***will NOT GET ANY updates*** !
The best you can do is just point to the [original GIT repository](https://github.com/dvdvideo1234/TrackAssemblyTool)
avoiding any version mismatches and confusions. So please don't upload the script to any other sites. ***[I mean it!](https://www.youtube.com/watch?v=b1Om3vX1GlA)***

[ref-entity]: http://wiki.garrysmod.com/page/Category:Entity
[ref-dbext]: https://github.com/dvdvideo1234/TrackAssemblyTool/wiki/Database-extension
[ref-text-file]: https://www.youtube.com/watch?v=Pz0_RGwgfaY
[ref-value-exp]: https://www.youtube.com/watch?v=mEEpO3w8BLs
[ref-lua-script]: https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/autosave/z_autorun_%5Btrackassembly%5D.txt
[ref-load-list]: https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/trackasmlib_dsv.txt
[ref-list-pref]: https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/Test_s_track_packTRACKASSEMBLY_PIECES.txt
[ref-categ]: https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/Test_s_track_packTRACKASSEMBLY_CATEGORY.txt
[ref-vid-inters]: https://www.youtube.com/watch?v=1rsDHU79J50
[ref-vid-physnap]: https://www.youtube.com/watch?v=BxMlZMMGHrs
[ref-usr-offs]: https://www.youtube.com/watch?v=e1IK2zJ_Djk
[ref-trans]: https://github.com/dvdvideo1234/TrackAssemblyTool/wiki/Translations
[ref-resz-api]: https://wiki.garrysmod.com/page/Entity/PhysicsInitConvex
[ref-fade-door]: https://steamcommunity.com/sharedfiles/filedetails/?id=115753588
[ref-search]: https://github.com/dvdvideo1234/TrackAssemblyTool#hey-there-is-a-text-box-and-a-drop-down-menu-next-to-the-exportdb-button-what-are-these-for-
[ref-rag-constr]: https://developer.valvesoftware.com/wiki/Phys_ragdollconstraint
[ref-dsv-dir]: https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master/data/trackassembly/dsv
[ref-sv-db]: https://github.com/dvdvideo1234/TrackAssemblyTool/blob/master/data/trackassembly/dsv/sv_TRACKASSEMBLY_PIECES.txt
[ref-phys-snap]: https://github.com/dvdvideo1234/TrackAssemblyTool/wiki/Additional-features#physgun-snapping-feature
[ref-discontinued]: https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master/data/discontinued/owner-discontinued
[ref-maintained]: https://github.com/dvdvideo1234/TrackAssemblyTool/tree/master/data/discontinued/owner-maintained
[ref-easter]: https://tfwiki.net/wiki/Team_Bullet_Train
[ref-surf-snap]: https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/surfsnap.jpg
[ref-adviser]:https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/snapadvaiser.jpg
[ref-screenshot]: https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/screenshot.jpg
[ref-pnt-assist]: https://raw.githubusercontent.com/dvdvideo1234/TrackAssemblyTool/master/data/pictures/pointassist.jpg
[ref-ctx-menu]: https://wiki.garrysmod.com/page/The_Context_Menu
[ref-model]: https://developer.valvesoftware.com/wiki/Model
[ref-glua]: https://nodecraft.com/support/games/gmod/glua-101-an-introduction-to-garrys-mod-coding
[ref-exp2]: https://github.com/wiremod/wire/wiki/Expression-2
[ref-expadv]: https://github.com/Rusketh/ExpAdv2
[ref-starfall]: https://github.com/thegrb93/StarfallEx
[ref-ltab]: http://www.lua.org/pil/2.5.html
[ref-tsql]: https://www.sqlite.org/index.html
[ref-PA]: https://steamcommunity.com/sharedfiles/filedetails/?id=457478322
[ref-add-ftr]: https://github.com/dvdvideo1234/TrackAssemblyTool/wiki/Additional-features
[ref-wiki-ta]: https://github.com/dvdvideo1234/TrackAssemblyTool/wiki
