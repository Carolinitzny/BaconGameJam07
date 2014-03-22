local class = require 'middleclass'
require "entity"

Plane = class ("Plane", Entity)
function Plane:initialize(x, y)
    self.position = Vector:new(x,y)
    self.speed = 140
    self.direction = 0
    self.rotationspeed = 0.9
    self.fuel = 1
    self.fuelconsumption = 0.025
    self.quantity = 12
    self.altitude = 1
    self.landing = false
    self.isChrashing = false
    self.size = 1

    -- Trudel-Winkel, wird nicht in Richtung eingerechnet aber zum Drehen der Grafik verwendet
    self.spinAngle = 0
    self.spinAngleSpeed = 0

    -- particles
    self.smokeTrailLeft = SmokeTrail:new(self.position, self)
    self.smokeTrailRight = SmokeTrail:new(self.position, self)
end 

function Plane:update(dt)
    if not self.isChrashing then
        if love.keyboard.isDown("left") then
            self.direction = self.direction - self.rotationspeed*dt
            self.spinAngleSpeed = -self.rotationspeed
        end
        if love.keyboard.isDown("right") then
            self.direction = self.direction + self.rotationspeed*dt
            self.spinAngleSpeed = self.rotationspeed
        end  
    else
        self.spinAngle = self.spinAngle + self.spinAngleSpeed * dt
    end

    local dir = Vector:new(0, -1)
    dir:rotate(self.direction)
    dir = dir * dt * self.speed
    self.position = self.position + dir
    self.fuel = math.max(0, self.fuel - self.fuelconsumption*dt)
    if self.fuel <= 0 then
        self:crash()
    end

    self.size = 0.2 + 0.8 * self.altitude

    self.smokeTrailLeft.position = self.position + Vector:new(-40*self.size, 0):rotated(self.direction + self.spinAngle)
    self.smokeTrailRight.position = self.position + Vector:new( 40*self.size, 0):rotated(self.direction + self.spinAngle)
    self.smokeTrailLeft:update(dt)
    self.smokeTrailRight:update(dt)
end

function Plane:draw()
    love.graphics.draw(images.plane, self.position.x, self.position.y, self.direction + self.spinAngle, 
        self.size, self.size, images.plane:getWidth()/2, images.plane:getHeight()/2)

    self.smokeTrailLeft:draw()
    self.smokeTrailRight:draw()
end

function Plane:dropPackage()
    if self.quantity > 0 then
        self.state:add(Package:new(self))
        self.quantity = self.quantity - 1
    end
end

function Plane:crash()
    if self.isChrashing then return end
    self.isChrashing = true

    tween(3, self, {altitude = 0}, "inQuad")
    tween(3, self, {rotationspeed = 10}, "inCirc")
    tween(3, self, {speed = 0}, "inCirc", function() 
        self.state:add(Explosion:new(self.position:clone()))
    end)
    highscore.add("Hans-Peter", self.state.score)
end

function Plane:land()
    self.landing = true
    self.rotationspeed = 0
    self.fuelconsumption = 0
    tween(1, self, {altitude = 0}, "inOutQuad")
    tween(1.5, self, {speed = 0}, "inQuad", function()
        self:refuel()
    end)
end

function Plane:refuel()
    tween(1.5, self, {direction = self.direction + math.pi})
    tween(2, self, {fuel = 1}, "inOutQuad", function()
        self:liftoff()
    end)
end

function Plane:liftoff()
    self.rotationspeed = 0.9
    self.fuelconsumption = 0.05
    tween(1, self, {speed = 140}, "outQuad")
    tween(2, self, {altitude = 1}, "inQuad")
    self.landing = false
end

