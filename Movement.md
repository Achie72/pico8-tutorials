# Movement

## Basic draw setup for the player


This is very easy to do. First let's create a player variable, and assign it an `x` and a `y` coordinates like so:

```lua
player = {
	x = 0,
	y = 0,
}
```

Now we can store where the player is globally, and always ask for it with `player.x` or `player.y`. 

Let's try to show where we are on the screen! We need to create the `_update()` function which is the main loop for the pico-8 programs:

```lua
function _update()

end
```

Everything we type in this will be processed several dozen times a second, so let's show our dino on the screen! `spr(id, xPos, yPos)` draws the sprite with `id` to the coords (with the sprite's upper left corner aligned) defined by `xPos` and `yPos`. Our little dino is sprite id 0, so let's make a sprite for him, and draw him!

![alt text](https://github.com/Achie72/pico8-tutorials/blob/main/src_images/movement/player_sprite.png "Player Sprite")


```lua
function _update()
	cls()
	spr(1, player.x, player.y)
end
```

*(I'm gonna explain `cls()` later, for now let's just type it in)*

Now if you press Ctrl+R to reload the cart, we can see the dino on the upper left corner. 

![alt text](https://github.com/Achie72/pico8-tutorials/blob/main/src_images/movement/player_drawn.png "Player Drawn")

**Why?** Pico-8 screen is indexed from 0-128, and `x` and `y` are increasing from left to right, from top to bottom, so:

- upper left corner:  `(x=0, y=0)`
- upper right corner: `(x=128, y=0)`
- bottom left corner: `(x=0, y=128)`
- bottom right corner: `(x=128, y=128)`

Now we have our dino on screen let's move him!

# Movement

## Grid based movement:

So let's start with the most basic one in my opinion, which will be Grid based movement, where we move along tiles on the map, like in Heroes of Might and Magic series.
The pico-8 screen is a 128x128 pixel space, in which you can sqeeze a 16x16 tiled area, because tiles are sprites drawn next to each other, and as we now sprite size is 8x8 in pico-8. Let's draw some really basic tiles for a grassy ground and some dirt road.

![alt text](https://github.com/Achie72/pico8-tutorials/blob/main/src_images/movement/grass_tile.png "Grass tile")
![alt text](https://github.com/Achie72/pico8-tutorials/blob/main/src_images/movement/dirt_tile.png "Dirt tile")

Let's also draw our map! Just a few simple strokes of road, as road and grass doesn't really differ as of now. For ex:
![alt text](https://github.com/Achie72/pico8-tutorials/blob/main/src_images/movement/draw_map.png "Drawing a map")

We have our map, so let's draw it into the screen! You can do this by calling the `map()` function!
```lua
function _update()
	cls()
	map()
	spr(1, player.x, player.y)
end
```

Reload the cart with Ctrl+R and now we have our dino on the fields!

![alt text](https://github.com/Achie72/pico8-tutorials/blob/main/src_images/movement/map_drawn.png "Drawn map with player")

The only thing is left is to move! Let'S create another function, called `move_player()` in which we can do this!

For this we will need to capture which button is pressed, for this we can use the `btnp(id)` function, where:

- 0 is `Left Arrow`
- 1 is `Right Arrow`
- 2 is `Up Arrow`
- 3 is `Down Arrow`
(for now these will do, for further list click **here**)
`btnp(0)` will return **true** if the `Left Arrow Button` is pressed (hence btnp, as button pressed), so we can chek very easily how to move:

```lua
function move_player()
	if btnp(0) then
    	-- left is pressed, move left
  	elseif btnp(1) then
  		-- right is pressed move right
 	elseif btnp(2) then
   		-- up is pressed move up
 	elseif btnp(3) then
   		-- down is pressed move down
  	end
end
```

PICO-8 has it buttons like so:
- 0 is Left Arrow
- 1 is Right Arrow
- 2 is Up Arrow
- 3 is Down Arrow

We want to move according to this, so increase our position by 1 for each button press.

```lua
function move_player()
	if btnp(0) then
		player.x -= 1
    	-- we are moving to the left tile, so substract
  	elseif btnp(1) then
  		player.x += 1
  		-- we are moving right, so we add to our x value
 	elseif btnp(2) then
 		player.y -= 1
   		-- we are moving up
 	elseif btnp(3) then
 		player.y += 1
   		-- we are moving down
  	end
end
```

The only thing left, is to call this movement check in our `_update()` function!
Remember when i said that tiles are 8x8 sprites as well? For this reason, when we want to draw our character, we need to multiply the corresponding `x` and `y` values by 8! Why? Because that will show are player on the correct map tile (remember there are 16-of them in each row/column and are 8*8 pixels.)

```lua
function _update()
	cls()
	map()
	move_player()
	spr(1, player.x*8, player.y*8)
end
```

One could ask, why aren't we adding 8 to the player position, and just draw with `player.x, player.y`. My answer is that in these kind of games in the future you will want to check what tiles the player is on, for which it is much easier to do an `mget(player.x, player.y)` rather than `mget(player.x/8, player.y/8)`. (`mget(x,y)` will return the id of the tile on coordinates (x,y))


Reload (ctr+R) and now we can move around with our arrow keys!

![alt text](https://github.com/Achie72/pico8-tutorials/blob/main/src_images/movement/player_moving.gif "Moving Player")

Only slight problem we have is the fact, that we can move out from screen. We can handle this 3 ways:

- Make the player loop around the screen (exiting left coming in right)
- Force the player into the screen (we can't leave)
- Make the camera follow us!

