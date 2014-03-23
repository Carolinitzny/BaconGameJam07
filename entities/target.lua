local class = require 'middleclass'

require "entity"
Target = class ("Village", Entity)
Target.z = 1

function Target:initialize(x,y,village)
    self.position = Vector:new(x,y) 
    self.size = 15
    self.village = village
end

function Target:draw()
    love.graphics.setColor(0, 255, 0, 20)
    love.graphics.circle("fill", self.position.x, self.position.y, self.size*5) 
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("fill", self.position.x, self.position.y+10, self.size)
    love.graphics.setColor(255, 255, 255)    
end