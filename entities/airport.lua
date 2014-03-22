local class = require 'middleclass'
require "entity"

Airport = class ("Airport", Entity)
function Airport:initialize(x,y,rotation)
    self.position = Vector:new(x,y)
    self.orientation = rotation
    self.image = images.airport
end

function Airport:draw()
    love.graphics.draw(self.image, self.position.x, self.position.y, self.orientation, 1, 1, self.image:getWidth() / 2, self.image:getHeight())
    love.graphics.circle("fill", self.position.x, self.position.y, 5)
end

function Airport:update(dt)
    local plane = self.state.plane
    local distance = (plane.position - self.position):len()
    local angleDifference = math.abs(((plane.direction - self.orientation) + math.pi) % (2 * math.pi) - math.pi)
    if distance < 20 and angleDifference < 0.2 and not plane.landing then
        plane:land()
    end
end