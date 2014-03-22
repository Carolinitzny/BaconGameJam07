local class = require 'middleclass'
require "entity"

Plane = class ("Plane", Entity)
function Plane:initialize(x, y)
    self.position = Vector:new(x,y)
    self.speed = 140
    self.direction = 0
    self.rotationspeed = 0.9
    self.fuel = 1
    self.fuelconsumption = 0.05
    self.quantity = 20
    self.altitude = 1
    self.size = 1
    self.landing = false
    self.isChrashing = false

    -- particles
    self.smokeTrailLeft = SmokeTrail:new()
    self.smokeTrailRight = SmokeTrail:new()
end 

function Plane:update(dt)
    if self.isChrashing == false then
        if love.keyboard.isDown("left") then
            self.direction = self.direction - self.rotationspeed*dt
        end
        if love.keyboard.isDown("right") then
            self.direction = self.direction + self.rotationspeed*dt
        end  
    else
        self.direction = self.direction - self.rotationspeed*dt
    end
    local dir = Vector:new(0, -1)
    dir:rotate(self.direction)
    dir = dir*dt*self.speed
    self.position = self.position + dir
    self.fuel = self.fuel - self.fuelconsumption*dt  
    if self.fuel <= 0 then
        alive = false
        if self.isChrashing == false then
            self:crash()
            self.isChrashing = true
        end
    end

    self.smokeTrailLeft.position = self.position + Vector:new(-40*self.size, 0):rotated(self.direction)
    self.smokeTrailRight.position = self.position + Vector:new( 40*self.size, 0):rotated(self.direction)
    self.smokeTrailLeft:update(dt)
    self.smokeTrailRight:update(dt)
end

function Plane:draw()
    love.graphics.draw(images.plane, self.position.x, self.position.y, self.direction, 
        self.size, self.size, images.plane:getWidth()/2, images.plane:getHeight()/2)

    self.smokeTrailLeft:draw()
    self.smokeTrailRight:draw()
end

function Plane:dropPackage()
    if self.quantity > 0 then
        local package = Package:new(self)
        table.insert(welt, package)
        self.quantity = self.quantity - 1
    end
end

function Plane:crash()
    tween(5, self, {size = 0.2}, "inQuad")
    tween(5, self, {rotationspeed = 10}, "inCirc")
    tween(5, self, {speed = 400}, "inCirc")
end

function Plane:land()
    self.landing = true
    self.rotationspeed = 0
    self.fuelconsumption = 0
    tween(3, self, {size = 0.3}, "inQuad")
    tween(3, self, {altitude = 0}, "inQuad")
    tween(5, self, {speed = 0}, "inQuad", function()
        plane:refule()
    end)
end

function Plane:refule()
    tween(5, self, {fuel = 1}, "inQuad", function()
        plane:liftoff()
        end)
end

function Plane:liftoff()
    self.rotationspeed = 0.9
    self.fuelconsumption = 0.05
    tween(5, self, {speed = 140}, "inQuad")
    tween(3, self, {size = 1}, "inQuad")
    tween(3, self, {altitude = 1}, "inQuad")
    self.landing = false
    
end

