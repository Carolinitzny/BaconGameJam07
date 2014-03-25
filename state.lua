local class = require "middleclass"

State = class("State")
function State:initialize()
    self.world = {}
    self.ui = {}
end

function State:add(entity, ui)
    if ui then
        table.insert(self.ui, entity)
    else
        table.insert(self.world, entity)
    end
    entity.state = self
    entity:onAdd(self)
end

function State:delete(entity)
    table.removeValue(self.world, entity)
    table.removeValue(self.ui, entity)
    entity.state = nil
end 

function State:update(dt)
    self:updateEntities(dt)
end

function State:draw()
    self:drawWorld()
    self:drawUI()
end

function State:updateEntities(dt)
    for k,v in pairs(self.world) do
        v:update(dt)
    end
    for k,v in pairs(self.ui) do
        v:update(dt)
    end
end

function State:onScreen(pos, size)
    return true
end

function State:drawWorld()
    table.sort(self.world, function(a, b)
        if a.z == b.z and a.position and b.position then
            return a.position.y < b.position.y
        else
            return a.z < b.z
        end
    end)
    for k,v in pairs(self.world) do
        if v and (not v.position or self:onScreen(v.position, v.size or 200, 200)) then
            v:draw()
        end
    end
end

function State:drawUI()
    for k,v in pairs(self.ui) do
        v:draw()
    end
end

function State:onEvent(type, data) return false end
function State:onEnter() end

function State:sendEvent(type, data)
    if self:onEvent(type, data) then return true end
    for k,v in pairs(self.ui) do
        if v:onEvent(type, data) then return true end
    end
    for k,v in pairs(self.world) do
        if v:onEvent(type, data) then return true end
    end
    return false
end
