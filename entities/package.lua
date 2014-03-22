local class = require 'middleclass'
require "entity"

Package = class("Package", Entity)
function Package:initialize(plane)
    self.position = plane.position:clone()
    self.direction = plane.direction
    self.speed = plane.speed
    self.altitude = 1 -- height above ground
    tween(1.0, self, {speed = 0}, "inQuad")
    tween(1, self, {altitude = 0}, "inQuad", function() 
        self.state:add(SmokeRing:new(self.position:clone()))
        self:landed()
    end)
end

function Package:draw()
    local s = 0.2 + 0.2*self.altitude
    love.graphics.setColor(255,255,255)
    love.graphics.draw(images.package, self.position.x , self.position.y , 0, s ,s, (images.package:getWidth())/2, images.package:getHeight()/2)
    
end

function Package:update(dt)
    local dir = Vector:new(0, -1)
    dir:rotate(self.direction)
    dir = dir*dt*self.speed
    self.position = self.position + dir
end

function Package:landed()
    for k, v in pairs(self.state.world) do
        if v:isInstanceOf(Target) then
            if math.abs(self.position.x - v.position.x) <= 50 and math.abs(self.position.y - v.position.y) <= 50 then
                self.state:addScore(1)
            end
        end  
    end        
end

