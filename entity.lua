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
    self.speed = 140
    self.direction = 0
    self.rotationspeed = 0.9
    self.fuel = 1
    self.fuelconsumption = 0.05
    self.quantity = 20
end 

function Plane:update(dt)
    if love.keyboard.isDown("left") then
        self.direction = self.direction - self.rotationspeed*dt
    end
    if love.keyboard.isDown("right") then
        self.direction = self.direction + self.rotationspeed*dt
    end    
    local dir = Vector:new(0, -1)
    dir:rotate(self.direction)
    dir = dir*dt*self.speed
    self.position = self.position + dir
    self.fuel = self.fuel - self.fuelconsumption*dt

end

function Plane:draw()
    love.graphics.draw(image.plane, self.position.x , self.position.y , self.direction, 1 ,1, (image.plane:getWidth())/2, image.plane:getHeight()/2)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", love.graphics.getWidth()-100-20-5, 15, 110, 25) 
    love.graphics.setColor(255 - 255*self.fuel, 255*self.fuel, 0)
    love.graphics.rectangle("fill", love.graphics.getWidth()-100-20, 20, self.fuel*100, 15)
    love.graphics.setColor(255, 255, 255)
    --[[for i = 1, plane.quantity do
        love.graphics.draw(image.package, love.graphics.getWidth()-200 + ((i%5)*20), 50*(i), 0.15, 0.15)
    end]]--
end

function Plane:dropPackage()
    local package = Package:new(self)
    table.insert(welt, package)
end

Package = class ("Package", Entity)
function Package:initialize(plane)
    self.position = plane.position:clone()
    self.direction = plane.direction
    self.speed = plane.speed
    --Flughoehe
    self.altitude = 1
    tween(2, self, {altitude = 0}, "inQuad")
    tween(1.5, self, {speed = 0}, "inQuad")
end

function Package:draw()
    local s = 0.2 + 0.2*self.altitude
    love.graphics.setColor(255,255,255)
    love.graphics.draw(image.package, self.position.x , self.position.y , 0, s ,s, (image.package:getWidth())/2, image.package:getHeight()/2)
    
end

function Package:update(dt)
    local dir = Vector:new(0, -1)
    dir:rotate(self.direction)
    dir = dir*dt*self.speed
    self.position = self.position + dir
 
end

