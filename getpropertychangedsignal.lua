-- very usefulnt
--[[
local a = t:New({b = 5})
local connection = a:GetPropertyChangedSignal("b", function()
    warn(a.b)
end)
a.b = 536344
connection:Disconnect()
a.b = 4822
]]

local t = {
    Objects = {}
}
t.__index = t

local objs = t.Objects
function t:New(props)
    local properties = setmetatable(props, t)
    
    local obj = setmetatable({connections = {}}, {
        __newindex = function(self2, prop, v)
            properties[prop] = v
            
            local connections = self2.connections
            if not connections[prop] then return end
            
            for _, v2 in ipairs(connections[prop]) do
                v2()
            end
        end,
        
        __index = properties
    })
    
    objs[obj] = obj
    
    return obj
end

function t:GetPropertyChangedSignal(prop, func)
    local connections = self.connections
    connections[prop] = connections[prop] or {}
    
    local o = connections[prop]
    o[#o + 1] = func
    
    return setmetatable(connections, t)
end

function t:Disconnect()
    table.clear(self)
end
