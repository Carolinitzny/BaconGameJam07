local class = require 'middleclass'
require "entity"

Airport = class ("Airport", Entity)
Airport.z = 1
function Airport:initialize(x,y,rotation)
    self.position = Vector:new(x,y)
    self.orientation = rotation
    self.image = images.airport
end

function Airport:draw()
    love.graphics.draw(self.image, self.position.x, self.position.y, self.orientation, 0.28, 0.28, self.image:getWidth() / 2, self.image:getHeight())
end

function Airport:update(dt)
    local plane = self.state.plane
    local distance = (plane.position - self.position):len()
    local angleDifference = math.abs(((plane.direction - self.orientation) + math.pi) % (2 * math.pi) - math.pi)
    if distance < 20 and angleDifference < 0.2 and not plane.landing then
        plane:land()
    end
end