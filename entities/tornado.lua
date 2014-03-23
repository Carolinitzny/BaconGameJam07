local class = require 'middleclass'
require "entity"

Tornado = class ("Tornado", Entity)
Tornado.z = 6
function Tornado:initialize(x,y)
    self.position = Vector:new(x,y)
    self.tornado = {}
    self.speed = 0.03
    self.direction = Vector:new(x,y)
    local tornado = {}
    tornado.pos = Vector:new(0,0)
    table.insert(self.tornado, tornado)
end

function Tornado:update(dt)
   
   for k, v in pairs(self.state.world) do
        if v:isInstanceOf(Tornado) then
            if time == 0 then
                v.direction.x = mathe.random(-10, 10)
                v.direction.y = mathe.random(-10, 10)
                v.speed = 1/((math.abs(v.direction.x))*(math.abs(v.direction.y)))
            elseif time%(math.random(1,5)*60) < 1 then
                v.direction.x = math.random(-10, 10)
                v.direction.y = math.random(-10, 10)
            end
            self.position = self.position + self.direction*dt*self.speed
        end
   end
   
end

function Tornado:draw()
    love.graphics.setColor(255, 255, 255)

    for k, v in pairs(self.tornado) do
        love.graphics.circle("fill", v.pos.x + self.position.x, v.pos.y + self.position.y, 50)        
    end
end