local t = {
    Objects = {}
}
t.__index = t

local objs = t.Objects
function t:New(props)
    local properties = setmetatable(props, t)
    
    local obj = setmetatable({props_connected = {}, connections = {}}, {
        __newindex = function(self2, i, v)
            properties[i] = v
            
            local props_connected = self2.props_connected
            if not table.find(props_connected, i) then
                return
            end
            
            local connections = self2.connections
            for _, v2 in ipairs(connections[i]) do
                v2()
            end
        end,
        
        __index = properties
    })
    
    objs[obj] = obj
    
    return obj
end

function t:GetPropertyChangedSignal(obj, prop, func)
    local props_connected = objs[obj].props_connected
    table.insert(props_connected, prop)
    
    local connections = objs[obj].connections
    connections[prop] = connections[prop] or {}
    
    local o = connections[prop]
    table.insert(o, func)
end

return t