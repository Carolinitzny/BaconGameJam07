local class = require 'middleclass'

require "entity"
Target = class ("Village", Entity)

function Target:initialize(x,y)
    self.position = Vector:new(x,y) 
    self.size = 10
end

function Target:draw()
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("fill", self.position.x, self.position.y, self.size) 
    love.graphics.setColor(255, 255, 255)    
end