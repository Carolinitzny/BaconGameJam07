local class = require 'middleclass'
require "vector"
Entity = class ("Entity")

function Entity:update(dt)

end 
function Entity:draw()

end


Plane = class ("Plane", Entity)
function Plane:initialize(x, y)
    self.position = Vector:new(x,y)
    self.speed = 100
    self.direction = 0
end 

function Plane:update(dt)
    local dir = Vector:new(0, -1)
    dir:rotate(self.direction)
    dir = dir*dt*self.speed
    self.position = self.position + dir

end

function Plane:draw()
    love.graphics.draw(image.plane, self.position.x , self.position.y , self.direction, 1 ,1, (image.plane:getWidth())/2, image.plane:getHeight()/2)
end