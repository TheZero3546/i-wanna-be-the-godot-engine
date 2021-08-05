# i-wanna-be-the-godot-engine #
open source godot project made as a framework for [I Wanna Be The Guy fangames](https://cwpat.me/fangames-intro/).

- - - -

## What's been done so far ##
- Blocks and spikes
- Guy physics
- Guy shot
- Guy animations
- Saves (Only 1 save file)
- Teleports (game saves on teleport)
- Music and sounds
- Main screen
- Death screen with blood splash
- Platforms (they don't work exactly as in other engines as the player doesn't snap to them yet)

- - - -
## Method of use ##
### How to create Scenes ###
The easy way of creating new screen is to copy __Test_01.tscn__. Here you can see:
1. __Blocks__: This is the blocks tileset. Collision layer for any block tileset __MUST__ be set to 1 for the player to collide with it.
2. __Spikes__: This is the spikes tileset. Collision layer for any spike tileset __MUST__ be set to 2 for the player to die on collision
3. __Warp__: This is the teleport object. It has 2 parameters:
    - __Teleport Id__: This refers to the ID of the screen it warps to. This ID is set by the _Global.gd_ script array: _screens_
    - __Spawn Point__: This refers to the global position this it teleports on the next screen.
4. __PlayerSpawn__: Every screen __MUST HAVE__ this node. It's the node used by the engine to know at what point of the screen the player is spawned. There's no need to set the position of this node, as this is managed by the restart and warp methods, but it can help as a visual guidance as to where to set _Spawn Point_ in warps.

### How to add Scenes to the game ###
As stated above, warps need screen id's for them to work. The way to add them is to edit the array variable _screens_ in _Global.gd_, as this is the variable used for warps and saves.


### How to edit music ###
You can add music by editing the _music_ variable inside _Global.gd_. There are 2 things you need: the music and the volume. Godot 3.x doesn't support __.mp3__ files, as they are licensed by _Microsoft_, so the engine uses __.ogg__ files.

the _music\_volume_ variable is used by the audio engine to know how it should manage the volume of the song. Volumes are in the same order as the music, as the same id is used for music and volume. The way for volume to work is by editing the decibels of the song, so if it is ok as it is, the variable should be 0, with negative values lowering the music and positive values amplifying it.

### How to change the death screen ###
Just change the image at _DeathScreen.tscn_. leave it not visible.

### How to set a background image ###
Add a Sprite node to the scene and set the background image there. Easy way to make it true background is to set Z index to some crazy value like -100