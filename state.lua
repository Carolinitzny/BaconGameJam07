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
    table.remove(self.world, entity)
    table.remove(self.ui, entity)
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


function State:drawWorld()
    for k,v in pairs(self.world) do
        v:draw()
    end
end

function State:drawUI()
    for k,v in pairs(self.ui) do
        v:draw()
    end
end

function State:keypressed(key) end
