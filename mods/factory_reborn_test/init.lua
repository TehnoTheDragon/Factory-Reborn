FactoryRebornCore.Debug("Test Environment!")

-- Removing Default HUDs
minetest.register_on_joinplayer(function(player, last_login)
	local flags = player:hud_get_flags()
	flags.healthbar = false
	flags.breathbar = false
	player:hud_set_flags(flags)
end)

-- Mask Textures
local white_blank_texture = "factory_reborn_test_white_blank.png" 
local mask_ore_light = "factory_reborn_test_mask_ore_light.png"
local mask_ore_light_second = "factory_reborn_test_mask_ore_light_second.png"
local mask_ore_dark = "factory_reborn_test_mask_ore_dark.png"

-- Formatted Textures
local grass_texture = ("(%s^[multiply:#AEC862)"):format(white_blank_texture)
local stone_texture = ("(%s^[multiply:#808080)"):format(white_blank_texture)
local sand_texture = ("(%s^[multiply:#F2E68F)"):format(white_blank_texture)
local dirt_texture = ("(%s^[multiply:#C28F43)"):format(white_blank_texture)
local water_texture = ("(%s^[multiply:#87DFF2)"):format(white_blank_texture)

-- Blocks
local Block = FactoryRebornCore.Core.World.Block

local GrassBlock = Block.BaseBlock("grass")
GrassBlock:SetTextures(grass_texture)
GrassBlock:Registry()

local StoneBlock = Block.BaseBlock("stone")
StoneBlock:SetTextures(stone_texture)
StoneBlock:Registry()

local SandBlock = Block.BaseBlock("sand")
SandBlock:SetTextures(sand_texture)
SandBlock:Registry()

local DirtBlock = Block.BaseBlock("dirt")
DirtBlock:SetTextures(dirt_texture)
DirtBlock:Registry()

minetest.register_node("factory_reborn_test:water", {
	description = "water",
	tiles = {("%s^[opacity:125"):format(water_texture)},
	use_texture_alpha = "blend",
	paramtype = "light",
	drawtype = "liquid",
	liquidtype = "source",
	liquid_alternative_flowing = "factory_reborn_test:water_flow",
	liquid_alternative_source = "factory_reborn_test:water",
	liquid_viscosity = 0.01,
	alpha = 125,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drowing = 1,
	post_effect_color = {a=125, r=135, g=223, b=242},
})

minetest.register_node("factory_reborn_test:water_flow", {
	description = "water",
	tiles = {("%s^[opacity:125"):format(water_texture)},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	drawtype = "liquid",
	liquidtype = "flowing",
	liquid_alternative_flowing = "factory_reborn_test:water_flow",
	liquid_alternative_source = "factory_reborn_test:water",
	liquid_viscosity = 0.01,
	alpha = 125,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drowing = 1,
	post_effect_color = {a=125, r=135, g=223, b=242},
})

---automatic register node & generate texture for itself
---@param ore_name string
---@param color string (light color if second_color isn't nil)
---@param second_color string (dark color)
---@param main_texture string optional, if not use, then it's will set to default stone texture
local function auto_createOre(ore_name, color, second_color, main_texture)
    -- safe asserting
    color = color or "#ffffff"
	main_texture = main_texture or stone_texture

    -- create local dark & light textures
    local dark, light

    -- multiply each textures to selected color
    if second_color == nil then
        dark = ("(%s^[multiply:%s)"):format(mask_ore_dark, color)
        light = ("(%s^[multiply:%s)"):format(mask_ore_light, color)
    else
        dark = ("%s^[multiply:%s"):format(mask_ore_light_second, second_color)
        light = ("%s^[multiply:%s"):format(mask_ore_light, color)
    end

    -- combine texture in one
    local ore_texture = ("(%s)^(%s)"):format(dark, light)

    -- register node
	local NewOreBlock = Block.BaseBlock(ore_name)
	NewOreBlock:SetTextures(("%s^%s"):format(main_texture, ore_texture))
	NewOreBlock:Registry()
	return NewOreBlock
end

local CoalOreBlock = auto_createOre("Coal", "#2f2f2f")
local IronOreBlock = auto_createOre("Iron", "#FAD09F")
local LeadOreBlock = auto_createOre("Lead", "#A98EC5", "#A086BB")
local SaltOreBlock = auto_createOre("Salt", "#fafaf0", nil, sand_texture)

minetest.clear_registered_biomes()
minetest.clear_registered_decorations()
minetest.clear_registered_ores()

minetest.register_alias("mapgen_stone", tostring(StoneBlock))
minetest.register_alias("mapgen_water_source", "factory_reborn_test:water")

-- Generation
local OreGenerator = FactoryRebornCore.Core.World.OreGenerator

minetest.register_ore(OreGenerator.Builder()
-- Parameters
.OreType("scatter")
.Ore("coal")
.Target("stone")
.Chance(16 ^ 3)
.MaxOreSize(5 * 4 * 3)
.ClusterSize(5)
.Height(-5000, 5000)
.NoiseThreshold(0.0)
-- Noise
.Noise(OreGenerator.NoiseParameterBuilder()
	.Seed(194)
	.Offset(0)
	.Scale(0.2)
	.Spread(64, 64, 64)
	.Octaves(1.0)
	.Persistence(0.0)
	.Lacunarity(4.0)
.build())
-- Finish
.build()
)

minetest.register_ore(OreGenerator.Builder()
-- Parameters
.OreType("scatter")
.Ore("iron")
.Target("stone")
.Chance(8 ^ 3)
.MaxOreSize(9)
.ClusterSize(3)
.Height(-5000, 5000)
.NoiseThreshold(0.0)
-- Noise
.Noise(OreGenerator.NoiseParameterBuilder()
	.Seed(193)
	.Offset(0)
	.Scale(0.4)
	.Spread(32, 32, 32)
	.Octaves(1.0)
	.Persistence(0.0)
	.Lacunarity(4.0)
.build())
-- Finish
.build()
)

minetest.register_ore(OreGenerator.Builder()
-- Parameters
.OreType("scatter")
.Ore("lead")
.Target("stone")
.Chance(8 ^ 3)
.MaxOreSize(9)
.ClusterSize(3)
.Height(-5000, 5000)
.NoiseThreshold(0.0)
-- Noise
.Noise(OreGenerator.NoiseParameterBuilder()
	.Seed(192)
	.Offset(0)
	.Scale(0.4)
	.Spread(32, 32, 32)
	.Octaves(1.0)
	.Persistence(0.0)
	.Lacunarity(4.0)
.build())
-- Finish
.build()
)

minetest.register_ore(OreGenerator.Builder()
-- Parameters
.OreType("sheet")
.Ore("salt")
.Target("sand")
.Chance(16 ^ 3)
.MaxOreSize(12)
.ClusterSize(5)
.Height(0, 30)
.NoiseThreshold(0.0)
-- Noise
.Noise(OreGenerator.NoiseParameterBuilder()
	.Seed(190)
	.Offset(0)
	.Scale(0.6)
	.Spread(32, 32, 32)
	.Octaves(2.0)
	.Persistence(0.1)
	.Lacunarity(4.0)
.build())
-- Finish
.build()
)

minetest.register_biome({
	name = "factory_reborn_test:default",
	node_top = GrassBlock:Name(),
	depth_top = 1,
	node_filler = DirtBlock:Name(),
	depth_filler = 3,

	y_max = 50,
	y_min = 0,

	heat_point = 20,
	humidity_point = 40,

	vertical_blend = 32,
})

minetest.register_biome({
	name = "factory_reborn_test:desert",
	node_top = SandBlock:Name(),
	depth_top = 30,
	node_filler = DirtBlock:Name(),
	depth_filler = 8,

	y_max = 50,
	y_min = 1,

	heat_point = 80,
	humidity_point = 0,

	vertical_blend = 32,
})

minetest.register_biome({
	name = "factory_reborn_test:mountain",
	node_top = StoneBlock:Name(),
	depth_top = 50,

	y_max = 2048,
	y_min = 50,

	heat_point = 5,
	humidity_point = 50,

	vertical_blend = 32,
})