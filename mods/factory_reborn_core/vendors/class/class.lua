local function _generateGuid(length)
    length = length or 32
    local guid_keys = "0123456789eabcdef"
    local guid_keys_size = guid_keys:len()

    local t = {}
    for i = 1,length do
        local k = math.random(1, guid_keys_size)
        table.insert(t, guid_keys:sub(k, k))
    end
    return table.concat(t, "")
end

local ClassMetatable = {}
local Class = {}

function Class.allocate(extendClass)
	return setmetatable({}, { __index = Class, __newindex = extendClass })
end

ClassMetatable.__class = "Class"
ClassMetatable.__index = Class
ClassMetatable.__tostring = function()
	return ClassMetatable.__class
end
ClassMetatable.__call = Class.allocate

--- ## Create new class
--- ### Example: 
--- ```lua
--- local newClass = Class.extend("NewClass")
---
--- function newClass:init()
---
--- end
---
--- local newObject = newClass()
--- ```
---@param className string Class name
---@param extendClass table optional, create new class based off extend class
---@return table
function Class.extend(className, extendClass)
	extendClass = extendClass or Class
	
	local newClassMetatable = {}
	local newClass = {}
	
	function newClass.allocate(class)
		local newObject = { super = extendClass.allocate(class) }
		setmetatable(newObject, { __index = newClass, __newindex = class })
		return newObject
	end

	function newClass.new(...)
		local newObjectMetatable = {}
		local newObject = {}
		newObject.super = extendClass.allocate(newObject)
		
		newObjectMetatable.__guid = _generateGuid()
		newObjectMetatable.__object = className
		newObjectMetatable.__index = newClass
		newObjectMetatable.__tostring = newClass.__tostring or function()
			return ("(Object: %s) %s"):format(newObjectMetatable.__object, newObjectMetatable.__guid)
		end
		
		setmetatable(newObject, newObjectMetatable)
		
		newObject:init(...)
		return newObject
	end
	
	function newClass.extend(className)
		return Class.extend(className, newClass)
	end
	
	newClassMetatable.__guid = _generateGuid()
	newClassMetatable.__object = className
	newClassMetatable.__index = function(_, name)
		return rawget(extendClass, name)
	end
	newClassMetatable.__tostring = function()
		return ("(Class) %s"):format(newClassMetatable.__object)
	end
	newClassMetatable.__call = function(_,...)
		return newClass.new(...)
	end
	newClassMetatable.__eq = function(L, R)
		return rawequal(getmetatable(L).__guid, getmetatable(R).__guid)
	end
	
	setmetatable(newClass, newClassMetatable)
	
	return newClass
end

-- Implemented to Global
_G.Class = Class

setmetatable(Class, ClassMetatable)
return Class
