# ClassModule
Lua Module, I created this for roblox games, but I guess it's should work anywhere else.
I'm not sure if everything is working correctly, because I have been doing this for a long time. I left it on the github only because I needed it so that I would not go to Roblox every time and copy this script from there.
I hope this still works as well as it did then :3

# How to use
```lua
local class = ... -- require or dofile to get access to class module

-- create new class
local Entity = class.extend("Entity")

function Entity:init(name)
  self.name = name
end

function Entity:printName()
  print(self.name)
end

-- create player class
local Player = Entity:extend("Player") -- or class.extend("Player", Entity)

function Player:init(username)
  self.super:init(username)
  self.hp = 10
end

function Player:printHp()
  print(self.hp)
end

-- create object based off player class
local player0 = Player("Player0")
player0:printName()
player0:printHp()
```
