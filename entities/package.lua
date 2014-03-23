local class = require 'middleclass'
require "entity"

Package = class("Package", Entity)
Package.z = 3
function Package:initialize(plane)
    self.position = plane.position:clone()
    self.direction = plane.direction
    self.speed = plane.speed * 0.7
    self.altitude = 1 -- height above ground
    tween(1, self, {speed = 0}, "inQuad")
    tween(1, self, {altitude = 0}, "inQuad", function() 
        self.state:add(SmokeRing:new(self.position:clone()))
        self:landed()
    end)
end

function Package:draw()
    local s = 0.2 + 0.2*self.altitude
    love.graphics.setColor(255,255,255)
    love.graphics.draw(images.package, self.position.x , self.position.y , 0, s ,s, (images.package:getWidth())/2, images.package:getHeight()/2)
end

function Package:update(dt)
    local dir = Vector:new(0, -1)
    dir:rotate(self.direction)
    dir = dir*dt*self.speed*SPEED_FACTOR
    self.position = self.position + dir
end

function Package:landed()
    local hit = false
    for k, v in pairs(self.state.world) do
        if v:isInstanceOf(Target) then
            if (self.position - v.position):len() < 30 then
                if math.random(1,20) == 1 then
                    source = love.audio.newSource(sounds.kill)
                    source:play()
                    self.state:addScore(-1)
                    self.state:add(Text(v.position - Vector:new(0, 50), "1 casualty", {255, 0, 0}, fonts.writing30))
                end
                self.state:addScore(v.village.people)
                self.state:add(Text(v.position, v.village.people .. " fed", {0, 255, 0}, fonts.writing50))
                self.state:delete(v)
                hit = true
            end
        end  
    end 
    if not hit then
        source = love.audio.newSource(sounds.hit)
        source:play()
        local c = math.random(5, 20)
        self.state:add(Text(self.position, c .. " starved", {255, 0, 0}, fonts.writing30))
        self.state:addScore(-c)
    else 
        source = love.audio.newSource(sounds.plop)
    source:play()
    end
end

