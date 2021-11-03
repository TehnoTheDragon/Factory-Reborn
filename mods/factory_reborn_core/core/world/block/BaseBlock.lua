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
    self.identifier = nil
end

---return content_id of block, ```minetest.get_content_id(self.registry_name)```
---@return any
function BaseBlock:ID()
    if (self.identifier == nil) then
        self.identifier = minetest.get_content_id(self.registry_name)
    end
    return self.identifier
end

---Return a registry name of block
---@return string
function BaseBlock:Name()
    return self.registry_name
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

function BaseBlock:__tostring()
    return self:Name()
end

---Register this block in minetest, it's can be used only once!
function BaseBlock:Registry()
    self.node = minetest.register_node(self.registry_name, {
        description = self.registry_name,
        tiles = self.textures,

        
        on_construct = function(pos)
            local meta = minetest.get_meta(pos)
            meta:set_string("hp", minetest.serialize({value = 3}))
        end,
        on_punch = function (pos, node, player, pointed_thing)
            local meta = minetest.get_meta(pos)

            local hp = minetest.deserialize(meta:get_string("hp"))
            if not hp then
                meta:set_string("hp", minetest.serialize({value = 2}))
            else
                hp.value = hp.value - 1
                if hp.value <= 0 then
                    player:get_inventory():add_item("main", self.registry_name)
                    minetest.remove_node(pos)
                else
                    meta:set_string("hp", minetest.serialize({value = hp.value}))
                end
            end
        end,
    })
    self.identifier = minetest.get_content_id(self.registry_name)
    FactoryRebornCore.Core.World.Block.BlocksStorage.SaveIt(self.registry_name, self)
end