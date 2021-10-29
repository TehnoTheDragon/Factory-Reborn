local BlocksStorage = {}
local Storage = {}
_G.FactoryRebornCore.Core.World.Block.BlocksStorage = BlocksStorage

---Saveing it in global blocks storage
---@param registry_name string
---@param block any
function BlocksStorage.SaveIt(registry_name, block)
    local mod_tab = BlocksStorage.GetIt()
    if (not mod_tab) then
        mod_tab = {}
        Storage[FactoryRebornCore.CurrentModname()] = mod_tab
    end
    mod_tab[registry_name] = block
end

---Return blocks storage
---@param modname string optional
---@return table
function BlocksStorage.GetIt(modname)
    return Storage[(modname or FactoryRebornCore.CurrentModname())]
end