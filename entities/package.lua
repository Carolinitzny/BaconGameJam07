local class = require 'middleclass'
require "entity"

Package = class("Package", Entity)
Package.z = 5
function Package:initialize(plane)
    self.position = plane.position:clone()
    self.direction = Vector:new(0, - plane.speed * 0.7 * SPEED_FACTOR):rotated(plane.direction)
    self.altitude = 1 -- height above ground
    tween(1, self, {altitude = 0}, "inQuad", function()
        self.state:add(SmokeRing:new(self.position:clone()))
        self:landed()
    end)
end

function Package:draw()
    local s = 0.2 + 0.2*self.altitude
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.package, self.position.x , self.position.y , 0, s ,s, (images.package:getWidth())/2, images.package:getHeight()/2)
end

function Package:update(dt)
    self.direction = self.direction + self.state:getWindVector(dt)
    self.position = self.position + self.direction * dt * self.altitude
end

function Package:landed()
    local hit = false
    for k, v in pairs(self.state.world) do
        if v:isInstanceOf(Target) then
            if (self.position - v.position):len() < 60 then
                if math.random(1,20) == 1 then
                    source = love.audio.newSource(sounds.kill)
                    source:play()
                    self.state:addScore(-1)
                    self.state:add(Text(v.position - Vector:new(0, 50), "1 casualty", {1, 0, 0}, fonts.writing30))
                end
                self.state:addScore(v.village.people)
                self.state:add(Text(v.position, v.village.people .. " fed", {0, 0.8, 0}, fonts.writing50))
                self.state:delete(v)
                hit = true
            end
        end
    end
    if not hit then
        source = love.audio.newSource(sounds.hit)
        source:play()
        local c = math.random(5, 20)
        self.state:add(Text(self.position, c .. " starved", {1, 0, 0}, fonts.writing30))
        self.state:addScore(-c)
    else
        source = love.audio.newSource(sounds.plop)
    source:play()
    end
end

