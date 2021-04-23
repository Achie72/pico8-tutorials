Movement

Grid Based Movement

So let's start with the most basic one in my opinion, which will be Grid based movement.
The pico-8 screen is a 128*128 pixel space, in which you can sqeeze a 16*16 map area. Let's now create a very rudementary map, which consists a geen plains and some dirt roads, and let's move along on a grid, like in any turn based games.

This is very easy to do. First let's create a player variable, and assign it an `x` and a `y` coordinates like so:

```lua
player = {
	x = 0,
	y = 0,
}
```

Now we can store where the player is, and always ask for it with `player.x` or `player.y`