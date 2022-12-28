---
layout: post
title:  "Menu System Demo"
date:   2022-12-28 18:51:25 +0100
categories: ui menu
---


## Basic idea behind

Most menu systems are achived with state machines. They might sound intimidating, but they are fairly easy. What they mean is the game has different state, which do different things and you can jump between those states.  
Let's say those states are: Logo, Main Menu, Game and Game Over and now you may get why they are useful! We will use them to indicate our different "scenes" in our game and use separate functions handle these states! Let's get into it!

## Basic Setup

What we will do here is fairly simple. we introduce a new variable that will hold which scene we are on at a certain point. With this, we can have different update and draw functions that will handle each scene.

In this demo, we will have a:
-- logo scene
-- menu scene
-- game scene
-- game_over scene


We will introduce a new variable inside our code (above `_init()`) for storing the current scene. We will modifiy this during the program to switch between them.

```lua
scene="logo"
```

We start are game being egoistic and showing our logo! Now let's take our default `_update()` and spice it up to be able to handle our scenes.

```lua
function _update()
		-- in the update we will check
		-- what our scene is and call
		-- a new function based on it
		
		if scene=="logo" then
			-- call the respective update
			update_logo()
		elseif scene=="menu" then
			update_menu()
		elseif scene=="game" then
			update_game()
		elseif scene=="game_over" then
			update_game_over()
		end
end
```

You can add as many scenes as you want into this system, just don't forget to add them to the update! But wait? How will we draw them? Same way as we spiced up our `_update()` let's take a look at our new `_draw()`

```lua
-- this is the original pico-8
-- draw call, where we seperate
-- our menu's respective calls
-- into new functions
function _draw()	
    -- the same way we have new
    -- updates for each scene
    -- we can easily seperate
    -- scene drawing
    
    if scene=="logo" then
        -- call the respective update
        draw_logo()
    elseif scene=="menu" then
        draw_menu()
    elseif scene=="game" then
        draw_game()
    elseif scene=="game_over" then
        draw_game_over()
    end
    
    -- this you can delete
    -- only shows which scene are
    -- we on at the bottom of the
    -- screen
    print_outline(scene,64-#scene*2,118,1,7)
end
```

This a basic skeleton for a menu system, so let's make a really simple game with them, just for showcase purposes!

## Setting up update functions

For our logo, we don't want anything special. Just showcase what we have drawn for ourself and let the players skip to the menu by pressing the ❎.
```lua
-- create a new update for the
-- logo scene. in this we handle
-- only the logo scene
function update_logo()

	-- press x to go to menu
	if btnp(5) then
		-- by simply giving the state
		-- the menu value our update
		-- will choose the menu updt
		-- for future works from now
		-- on
		scene = "menu"
	end
	
end
```

For the menu, we want a Title to be showcased, maybe some instruction or sub-title and the way to start the game.

```lua
-- this will be for the menu
-- if you want the menu to do
-- something handle code here
function update_menu()
	-- press x to start the game
	if btnp(5) then
		scene = "game"
		_init()
	end
end
```

We want a really simple game. We can move around, and die in the spikes, that is all as it is only to showcase the `update_game()` and `draw_game()`, and to step to the game over scene.

```lua
-- this is where your actual
-- game will be called. put
-- everything that is for the
-- gameplay over here
-- if you already had gameplay
-- code put it into here!
function update_game()
	-- we will do a simple tile
	-- based movement
	if btnp(0) then
		player.x -= 1
	elseif btnp(1) then
		player.x += 1
	elseif btnp(2) then
		player.y -= 1
	elseif btnp(3) then
		player.y += 1
	end
	
	-- if we are on the spikes 
	-- (sprite id 49) then we are
	-- dead! so switch to game over
	-- scene
	
	if mget(player.x,player.y) == 49 then
		scene = "game_over"
	end
	
end
```

Our game over will only show a "Game over" text and the skip instrctions.

```lua
-- this will handle the game
-- over menu. for the sake of
-- presentation we will do it
-- as a "floating window" on top
-- of the game (see draw_game_over)
-- we want to go to the menu
-- when we press ❎
function update_game_over()
	-- press x to start the menu
	if btnp(5) then
		scene = "menu"
		_init()
	end
end
```

## Setting up draw functions

So we have our draw skeleton:
```lua
function _draw()	
		if scene=="logo" then
			draw_logo()
		elseif scene=="menu" then
			draw_menu()
		elseif scene=="game" then
			draw_game()
		elseif scene=="game_over" then
			draw_game_over()
		end
		
		-- this you can delete
		-- only shows which scene are
		-- we on at the bottom of the
		-- screen
		print_outline(scene,64-#scene*2,118,1,7)
end
```

Let's do the other draw calls as well. But before that, let me show you what I've drawn in the cart!

<img src="{{site.baseurl | prepend: site.url}}/assets/images/menu_system_demo/sprites.png" alt="Sprites" align="center"/>


```lua
-- the drawing code for the logo
-- we only want to show the logo
-- of ours, nothing else
function draw_logo()
	cls() -- clear last frame
	spr(45,52,56,2,2) -- draw head
	spr(63,64,64) -- draw mug
	
	-- trick for middle aligment
	local text="achie"	
	print(text,64-#text*2,72,7)
	
	-- skip print
	print("❎:skip",100,118,1)
end


-- this will handle the menu
-- show our title, start game
-- and maybe a little sprite
-- from the game
function draw_menu()
	cls() -- clear last frame
	-- print our title to the middle
	local title ="menu system demo cart"
	print_outline(title,64-#title*2,20,7,1)

	-- some generic text
	printc("this is my awesome menu",40,7)

	-- start game text
	local start ="press ❎ to start" 
	-- +1 is for the ascii ❎ character
	print(start, 64-#start*2+1, 60, 7)
	
	-- our little yelpi doing a
	-- cameo
	spr(1,58,70)
end


-- this is where everything
-- gameplay related is drawn
-- if you already had a game
-- before put drawing code into
-- here
function draw_game()
	cls() -- clear last frame
	map() -- draw the map
	-- draw out player into the
	-- the given tile he is on
	spr(1,player.x*8,player.y*8)
end


-- this is our game_over "floating"
-- window
function draw_game_over()
	-- we won't do a cls so the
	-- text can stay over the game
	-- map. you could obv. do a
	-- cls() call and create your
	-- own screen, for demonstration
	-- i want to keep the last game
	-- frame on
	
	-- let's draw a box
	-- one rectfill for border
	rectfill(20,20,108,108,7)
	-- one with 1 pixel smaller
	-- for the body
	
	-- palt(0,false) so the black is
	-- not transparent.
	-- palt(colorindex,true/false)
	-- causes color with index to
	-- be transparent
	palt(0,false)
	rectfill(21,21,107,107,0)
	-- reset the transparency to
	-- the default true on black
	palt(0,true) 
	
	-- print game over text
	printc("game over",40,8)
	-- print the button prompt
	printc("❎: return to menu", 98, 1)
	
end
```

## Helper Functions

The below functions are for our "fancy" printing we do here and there. instead of these you can use for ex:
Printo from marina makes: [Printo](https://www.lexaloffle.com/bbs/?pid=120655)

```lua
-- center printing function
-- will print approximatle to the
-- center
function printc(text,y,clr)
	print(text,64-#text*2,y,clr)
end


-- ranodom outline print code
function print_outline(_txt,_x,_y,_clr,_bclr)
    -- if we don't pass a background color set it to white
    if _bclr == nil then _bclr = 7 end

    -- draw the text with the outline color offsetted in each direction
    -- based from the original text position we want to draw.
    -- this will create a big blob of singular colors, which's outliens
    -- will perfectly match the printed text outline
    for x=-1,1 do
        for y=-1,1 do
            print(_txt, _x-x, _y-y, _bclr)
        end
    end

    -- draw the original text with the intended color in the middle
    -- of the blob, creating the outline effect
    print(_txt, _x, _y, _clr)
end
```

# The Result:

<img src="{{site.baseurl | prepend: site.url}}/assets/images/menu_system_demo/results.gif" alt="Results gif" align="center"/>


{% include /menu_system_demo/index.html %}