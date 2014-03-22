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
    self.altitude = 1
    self.size = 1
    self.isChrashing = false
    self.fuelrot = 0
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
    if self.fuel <= 0 then
        alive = false
        if self.isChrashing == false then
            self:crash()
            self.isChrashing = true
        end
    end
    self.fuelrot = self.fuel*((3/2)*math.pi)
end

function Plane:draw()
    love.graphics.draw(images.plane, self.position.x , self.position.y , self.direction, self.size, self.size, (images.plane:getWidth())/2,
        images.plane:getHeight()/2)
    love.graphics.print(tostring(self.size))
    love.graphics.draw(images.gauge, love.graphics.getWidth()-75, 10, 0, 0.05, 0.05, images.gauge:getWidth()/2, images.gauge:getHeight()/2)
    love.graphics.draw(images.needle, love.graphics.getWidth()-75, 10, self.fuelrot, 0.05, 0.05, images.needle:       getWidth()/2, images.needle:getHeight()/2)
    love.graphics.setColor(255, 255, 255)
    for i = 0, self.quantity-1 do
        local r = math.sin(time*2*math.pi)*0.2
        love.graphics.draw(images.package, love.graphics.getWidth()-115 + ((i%5)*20), 50 + math.floor(i/5)*20, r, 0.15, 0.15,
            (images.package:getWidth())/2, images.package:getHeight()/2)
    end
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
end

Package = class ("Package", Entity)
function Package:initialize(plane)
    self.position = plane.position:clone()
    self.direction = plane.direction
    self.speed = plane.speed
    --Flughoehe
    self.altitude = 1
    tween(1.5, self, {speed = 0}, "inQuad")
    tween(2, self, {altitude = 0}, "inQuad")
end

function Package:draw()
    local s = 0.2 + 0.2*self.altitude
    love.graphics.setColor(255,255,255)
    love.graphics.draw(images.package, self.position.x , self.position.y , 0, s ,s, (images.package:getWidth())/2, images.package:getHeight()/2)
    
end

function Package:update(dt)
    local dir = Vector:new(0, -1)
    dir:rotate(self.direction)
    dir = dir*dt*self.speed
    self.position = self.position + dir
 
end

