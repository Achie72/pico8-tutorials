pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- state machines for menu/scene
-- management

--[[
what we will do here is fairly
simple. we introduce a new variable
that will hold which scene we are
on at a certain point.

with this, we can have different
update and draw functions that
will handle each scene

in this demo, we will have a:
-- logo scene
-- menu scene
-- game scene
-- game_over scene
]]--

-- the variable for storing
-- the current scene
-- we will modifiy this during
-- the program to switch between
-- scenes
scene="logo"
	

function _init()
	
	-- the player object
	player = {
	 x = 1,
	 y = 1
	}	
	
end


-- this is the original pico-8
-- update
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


-- the below functions are for
-- our "fancy" printing we
-- do here and there. instead of
-- these you can use for ex:
-- printo from marina makes:
-- https://www.lexaloffle.com/bbs/?pid=120655


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
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000f000f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000ffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000f1fff100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000effffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700002220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000f0f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000777770000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000007000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000000700000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000ffff0070000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000ffffff070000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070f0f11f11700000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070fff70f70700000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700fffffff700000000000
000003000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000f000f700000000000
0000000000070600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000fff0700000777770
03000000007000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700700007000007666667
00000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000777770000076768287
00000000000706000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000700000000007668887
00000030007000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777000000000000766867
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077770
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000011111111111111111000011111111111111111111111100011111111111111111000011111111111111110000000000000000000000
00000000000000000000017771777177117171000117717171177177717771777100017711777177711771000117717771777177710000000000000000000000
00000000000000000000017771711171717171000171117171711117117111777100017171711177717171000171117171717117110000000000000000000000
00000000000000000000017171771171717171000177717771777117117711717100017171771171717171000171017771771117100000000000000000000000
00000000000000000000017171711171717171000111711171117117117111717100017171711171717171000171117171717117100000000000000000000000
00000000000000000000017171777171711771000177117771771117117771717100017771777171717711000117717171717117100000000000000000000000
00000000000000000000011111111111111111000111111111111011111111111100011111111111111110000011111111111111100000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000077707070777007700000777007700000777070700000777070707770077007707770777000007770777077007070000000000000000000
00000000000000000007007070070070000000070070000000777070700000707070707000700070707770700000007770700070707070000000000000000000
00000000000000000007007770070077700000070077700000707077700000777070707700777070707070770000007070770070707070000000000000000000
00000000000000000007007070070000700000070000700000707000700000707077707000007070707070700000007070700070707070000000000000000000
00000000000000000007007070777077000000777077000000707077700000707077707770770077007070777000007070777070700770000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000077707770777007700770000007777700000077700770000007707770777077707770000000000000000000000000000
00000000000000000000000000000000070707070700070007000000077070770000007007070000070000700707070700700000000000000000000000000000
00000000000000000000000000000000077707700770077707770000077707770000007007070000077700700777077000700000000000000000000000000000
00000000000000000000000000000000070007070700000700070000077070770000007007070000000700700707070700700000000000000000000000000000
00000000000000000000000000000000070007070777077007700000007777700000007007700000077000700707070700700000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000f000f0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000ffffff000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000f1fff1000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000effffe000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000022200000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000088800000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000f0f00000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007777777777777777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007111711171177171700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007111717771717171700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007171711771717171700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007171717771717171700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007171711171717711700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000007777777777777777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303031303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303031303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030313000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303130303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
