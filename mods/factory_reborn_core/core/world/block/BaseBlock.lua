local function getRegisteredNode(registry_name)
    return minetest.registered_nodes[registry_name]
end

local BaseBlock = createClass("BaseBlock")
FactoryRebornCore.Core.World.Block.BaseBlock = BaseBlock

---Create a new block class
---@param registry_name string (modname as prefix will generated automaticaly! That's safe <.< I guess...)
function BaseBlock:init(registry_name)
    local modname = FactoryRebornCore.CurrentModname()
    self.registry_name = ("%s:%s"):format(modname, registry_name:lower():gsub(" ", "_"))
    self.textures = {"NaN.png"}
    self.node = nil
end

---Setting textures
---@param tiles table | string
function BaseBlock:SetTextures(tiles)
    local tile = {"NaN.png"}
    if (type(tiles) == "table") then
        tile = tiles
    elseif (type(tiles) == "string") then
        tile[1] = tiles
    else
        FactoryRebornCore.Log(FactoryRebornCore.Enum.LogType.Error, "BaseBlock:SetTexture(), got unsupported type of tiles!")
    end
    self.textures = tile
end

---Register this block in minetest, it's can be used only once!
function BaseBlock:Registry()
    self.node = minetest.register_node(self.registry_name, {
        description = self.registry_name,
        tiles = self.textures
    })
    FactoryRebornCore.Core.World.Block.BlocksStorage.SaveIt(self.registry_name, self)
end