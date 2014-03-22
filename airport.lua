local class = require 'middleclass'

require "entity"
Airport = class ("Airport", Entity)

function Airport:initialize(x,y,rotation)
    self.position = Vector:new(x,y)
    self.orientation = rotation
    self.image = images.airport
end

function Airport:draw()
    love.graphics.draw(self.image, self.x, self.y, self.orientation, 0.3, 0.3, 280, 425)
end

function Airport:update(dt)
    if (plane.position - self.position):len() < 20 and plane.landing == false then
        plane:land()
    end
end