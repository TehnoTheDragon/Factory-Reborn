--#region Global Methods

_G.FactoryRebornCore = {}

FactoryRebornCore.Enum = {}
FactoryRebornCore.Enum.LogType = {
    None = "none",
    Warning = "warning",
    Error = "error",
    Action = "action",
    Info = "info",
    Verbose = "verbose"
}

---Just interface of ```minetest.get_current_modname()```
---@return string
function FactoryRebornCore.CurrentModname()
    return minetest.get_current_modname()
end

---Return path to current mod
---@return string
function FactoryRebornCore.GetCurrentModpath()
    return minetest.get_modpath(FactoryRebornCore.CurrentModname())
end

---dofile relative current mod
---@param filepath string file
---@return any
function FactoryRebornCore.RelativeModLoad(filepath)
    filepath = filepath:gsub("/", "\\")
    return dofile(FactoryRebornCore.GetCurrentModpath() .. "\\" .. filepath)
end

---Like minetest but a little bit improvment
function FactoryRebornCore.Debug(...)
    FactoryRebornCore.Log(FactoryRebornCore.Enum.LogType.Info, ...)
end

function FactoryRebornCore.Log(logtype, ...)
    minetest.log(table.concat({...}, "\t"))
end

FactoryRebornCore.Debug("Loading")

--#endregion

--#region Vendors

FactoryRebornCore.Debug("Vendors Loader Begin...")

FactoryRebornCore.RelativeModLoad("vendors/yaci/yaci.lua")

FactoryRebornCore.Debug("Vendors Loader Done!")

--#endregion

--#region Pre Init

FactoryRebornCore.RelativeModLoad("core/Core.lua")

FactoryRebornCore.Debug("Pre Inited")

--#endregion

--#region Post Init

FactoryRebornCore.Debug("Post Inited")

--#endregion