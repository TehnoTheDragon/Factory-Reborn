-- Mask Textures
local grass_texture = "factory_reborn_test_grass.png" 
local stone_texture = "factory_reborn_test_stone.png"
local mask_ore_light = "factory_reborn_test_mask_ore_light.png"
local mask_ore_dark = "factory_reborn_test_mask_ore_dark.png"

-- Blocks
minetest.register_node("factory_reborn_test:grass", {
    description = "Grass",
    tiles = {grass_texture}
})

minetest.register_node("factory_reborn_test:stone", {
    description = "Stone",
    tiles = {stone_texture}
})

---automatic register node & generate texture for itself
---@param ore_name string
---@param pre_invert boolean
---@param color string
local function auto_createOre(ore_name, pre_invert, color)
    -- safe asserting
    pre_invert = pre_invert == nil and true or pre_invert
    color = color or "#ffffff"

    -- create local dark & light textures
    local dark = mask_ore_dark
    local light = mask_ore_light

    -- invert them colors if pre_invert is true
    if pre_invert then
        dark = dark .. "^[invert:rgb"
        light = light .. "^[invert:rgb"
    end

    -- multiply each textures to selected color
    dark = dark .. ("^[multiply:%s"):format(color)
    light = light .. ("^[multiply:%s"):format(color)

    -- combine texture in one
    local ore_texture = ("(%s^%s)"):format(dark, light)

    -- register node
    minetest.register_node(("factory_reborn_test:%s"):format(ore_name:lower():gsub(" ", "_")), {
        description = ore_name,
        tiles = {("%s^%s"):format(stone_texture, ore_texture)}
    })
end

auto_createOre("Coal", false, "#202020")
auto_createOre("Iron", false, "#ffffff")

-- Map-Gens

minetest.register_alias("mapgen_grass", "factory_reborn_test:grass")
minetest.register_alias("mapgen_stone", "factory_reborn_test:stone")
minetest.register_alias("mapgen_ore_coal", "factory_reborn_test:coal")
minetest.register_alias("mapgen_ore_iron", "factory_reborn_test:iron")

function mapgenOverride()
    minetest.register_ore({
		ore_type       = "blob",
		ore            = "factory_reborn_test:coal",
		wherein        = "factory_reborn_test:stone",
		clust_scarcity = 12 * 12 * 12,
		clust_size     = 4,
		y_max          = 31000,
		y_min          = -1000,
        noise_threshold = 0.1,
		noise_params    = {
			offset = 0.5,
			scale = 0.3,
			spread = {x = 8, y = 3, z = 8},
			seed = 766,
			octaves = 1.3,
			persist = 0.1
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

    minetest.register_biome({
		name = "grassland",
		node_top = "factory_reborn_test:grass",
		depth_top = 1,
		y_max = 31000,
		y_min = 4,
	})
end

minetest.clear_registered_biomes()
minetest.clear_registered_ores()
minetest.clear_registered_decorations()

mapgenOverride()