local class = require 'middleclass'
require "entity"

Airport = class ("Airport", Entity)
Airport.z = 1
function Airport:initialize(x,y,rotation)
    self.position = Vector:new(x,y)
    self.orientation = rotation
    self.image = images.airport
    self.lockedTime = 0
end

function Airport:draw()
    love.graphics.draw(self.image, self.position.x, self.position.y, self.orientation, 0.28, 0.28, self.image:getWidth() / 2 + 24, self.image:getHeight())
end

function Airport:update(dt)
    if self.lockedTime > 0 then
        self.lockedTime = self.lockedTime - dt
    else
        local plane = self.state.plane
        local distance = (plane.position - self.position):len()
        local angleDifference = math.abs(((plane.direction - self.orientation) + math.pi) % (2 * math.pi) - math.pi)
        if distance < 20 and angleDifference < 0.2 and not plane.landing and not plane.isChrashing then
            if plane.speed <= 1.2 then
                plane:land(self)
            else
                self.lockedTime = 1

                self.state:add(Text(self.position, "Too fast!", {255, 0, 0}, love.graphics.newFont(30)))
            end
        end
    end
end