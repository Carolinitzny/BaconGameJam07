local class = require 'middleclass'
require "entity"

Airport = class ("Airport", Entity)
Airport.z = 1
function Airport:initialize(x,y,rotation)
    self.position = Vector:new(x,y)
    self.orientation = rotation
    self.image = images.airport
    self.lockedTime = 0
    self.arrowMove = 3
end

function Airport:draw()
        local plane = self.state.plane
        local distance = (plane.position - self.position):len()
        love.graphics.draw(self.image, self.position.x, self.position.y, self.orientation, 0.28, 0.28, self.image:getWidth() / 2 + 24, self.image:getHeight())
        if distance < 500 and plane.firstLanding then
            self.z = 10
            love.graphics.draw(images.arrow, self.position.x, self.position.y, self.orientation-math.pi/2, 1, 1, images.arrow:getWidth()*self.arrowMove, images.arrow:getHeight()/2)
            self.z = 1
        end
end

function Airport:update(dt)
    if self.lockedTime > 0 then
        self.lockedTime = self.lockedTime - dt
    else
        local plane = self.state.plane
        local distance = (plane.position - self.position):len()
        local angleDifference = math.abs(((plane.direction - self.orientation) + math.pi) % (2 * math.pi) - math.pi)
        if distance < 25 and angleDifference < 0.7 and not plane.landing and not plane.isChrashing then
            if plane.speed <= 1.2 then
                plane:land(self)
            else
                self.lockedTime = 1

                self.state:add(Text(self.position, "Too fast!", {1, 0, 0}, love.graphics.newFont(30)))
            end
        end
    end
    self.arrowMove = (self.arrowMove - 2*dt)%3
end
