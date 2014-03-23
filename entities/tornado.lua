local class = require 'middleclass'
require "entity"

Tornado = class ("Tornado", Entity)
Tornado.z = 2
function Tornado:initialize(x,y)
    self.position = Vector:new(x,y)
    self.speed = 1
    self.direction = 1
end

function Tornado:draw()
    love.graphics.setColor(255, 255, 255)

    for k, v in pairs(self.tornado) do
        love.graphics.circle("fill", self.position.x, self.position.y, 50)        
    end
end