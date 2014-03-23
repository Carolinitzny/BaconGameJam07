local class = require 'middleclass'
require "entity"

Indicators = class("Indicators", Entity)

function Indicators:initialize()
    self.size = love.graphics.getHeight() / 5
    self.position = Vector:new(love.graphics.getWidth() - self.size, self.size)
end

function Indicators:draw()    
    local score = self.state.score
    local plane = self.state.plane
    local angle = plane.fuel*((3/2)*math.pi)

    -- fuel gauge
    if plane.fuel < 0.15 then
        if (time*3)%1 < 0.5 then
            love.graphics.setColor(255, 200, 200)
        else
           love.graphics.setColor(255, 255, 255)
        end
    end
    local s = self.size/images.gauge:getWidth()
    love.graphics.draw(images.gauge,  self.position.x, self.position.y, 0,     s, s, images.gauge:getWidth()/2,  images.gauge:getHeight()/2)
    love.graphics.draw(images.needle, self.position.x, self.position.y, angle, s, s, images.needle:getWidth()/2, images.needle:getHeight()/2)
    love.graphics.setColor(255, 255, 255)

    -- packages left 
    for i = 0, plane.quantity-1 do
        local r = math.sin(time*2*math.pi+2*i) * 0.1
        love.graphics.draw(images.package, self.position.x - 29 + (i%3) * 30, self.position.y + self.size * 0.8 + math.floor(i/3) * 20, 
            r, 0.25, 0.25, images.package:getWidth()/2, images.package:getHeight()/2)
    end

    -- score
    local text = "People fed"
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fonts.writing30)
    love.graphics.print(text, self.position.x - love.graphics.getFont():getWidth(text) / 2, self.position.y + self.size * 1.5)
    love.graphics.setFont(fonts.writing50)
    love.graphics.print(score, self.position.x - love.graphics.getFont():getWidth(score) / 2, self.position.y + self.size * 1.5 + 30)
    love.graphics.setColor(255, 255, 255)
end    