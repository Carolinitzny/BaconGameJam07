local class = require 'middleclass'
require "entity"

Package = class("Package", Entity)
Package.z = 2
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
            if (self.position - v.position):len() < 30 then
                self.state:addScore(v.village.count)
                self.state:delete(v)
                    if math.random(1,20) == 1 then
                        self.state:addScore(-1)
                    end
            end
            
        end  
    end 
end

