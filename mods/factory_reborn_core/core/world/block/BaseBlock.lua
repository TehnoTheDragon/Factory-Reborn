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
end

---Should use every time when you want override new options
function BaseBlock:apply()
    
end

---Register this block in minetest, it's can be used only once!
function BaseBlock:registry()
    minetest.register_node(self.registry_name, {
        description = self.registry_name
    })
end