FactoryRebornCore.Debug("Test Environment!")

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

---automatic register node & generate texture for itself
---@param ore_name string
---@param color string (light color if second_color isn't nil)
---@param second_color string (dark color)
local function auto_createOre(ore_name, color, second_color)
    -- safe asserting
    color = color or "#ffffff"

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
	NewOreBlock:SetTextures(("%s^%s"):format(stone_texture, ore_texture))
	NewOreBlock:Registry()
	return NewOreBlock
end

auto_createOre("Coal", "#2f2f2f")
auto_createOre("Iron", "#FAD09F")
auto_createOre("Lead", "#A98EC5", "#A086BB")

-- Map-Gens]]

minetest.register_alias("mapgen_grass", "factory_reborn_test:grass")
minetest.register_alias("mapgen_stone", "factory_reborn_test:stone")
minetest.register_alias("mapgen_ore_coal", "factory_reborn_test:coal")
minetest.register_alias("mapgen_ore_iron", "factory_reborn_test:iron")
minetest.register_alias("mapgen_ore_lead", "factory_reborn_test:lead")

function mapgenOverride()
    minetest.register_ore({
		ore_type       = "blob",
		ore            = "factory_reborn_test:coal",
		wherein        = {"factory_reborn_test:stone"},
		clust_scarcity = 12 * 12 * 12,
		clust_size     = 5,
		y_max          = 31000,
		y_min          = -1000,
        noise_threshold = 0.2,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 8, y = 5, z = 3},
			seed = 766,
			octaves = 1,
			persist = 0.6,
			lacunarity = 2,
		},
	})

    minetest.register_ore({
		ore_type       = "scatter",
		ore            = "factory_reborn_test:iron",
		wherein        = "factory_reborn_test:stone",
		clust_scarcity = 9 * 9 * 9,
        clust_num_ores = 12,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = -1000,
	})

    minetest.register_ore({
		ore_type       = "scatter",
		ore            = "factory_reborn_test:lead",
		wherein        = "factory_reborn_test:stone",
		clust_scarcity = 6 * 9 * 6,
        clust_num_ores = 12,
		clust_size     = 5,
		y_max          = 31000,
		y_min          = -1000,
	})

    minetest.register_biome({
		name = "grassland",
		node_top = "factory_reborn_test:grass",
		depth_top = 1,
		node_filler = "factory_reborn_test:dirt",
		depth_filler = 3,
		node_riverbed = "factory_reborn_test:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 4,
	})

	--[[minetest.register_decoration({
		deco_type = "simple",
		place_on = {"factory_reborn_test:stone", "factory_reborn_test:grass"},
		sidelen = 1,
		noise_params = {
			offset = 0,
			scale = 1,
			spread = {x = 5, y = 5, z = 5},
			seed = 51,
			octaves = 1,
			persist = 0.2,
		},
		y_min = -50,
		y_max = 100,
		decoration = "factory_reborn_test:none"
	})]]
end

minetest.clear_registered_biomes()
minetest.clear_registered_ores()
minetest.clear_registered_decorations()

mapgenOverride()