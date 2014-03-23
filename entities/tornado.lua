local class = require 'middleclass'
require "entity"

Tornado = class ("Tornado", Entity)
Tornado.z = 2
function Tornado:initialize(x,y)
    self.position = Vector:new(x,y)
    self.tornado = {}
    self.speed = 1
    self.direction = 1
    local tornado = {}
    tornado.pos = Vector:new(0,0)
    table.insert(self.tornado, tornado)

end

function Tornado:draw()
    love.graphics.setColor(255, 255, 255)

    for k, v in pairs(self.tornado) do
        love.graphics.circle("fill", v.pos.x + self.position.x, v.pos.y + self.position.y, 50)        
    end
end