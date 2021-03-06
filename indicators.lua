local class = require 'middleclass'
require "entity"

Indicators = class("Indicators", Entity)

function Indicators:update(dt)
    self.size = love.graphics.getHeight() / 5
    self.position = Vector:new(love.graphics.getWidth() - self.size, self.size)
end

function Indicators:draw()
    local plane = self.state.plane
    local angle = plane.fuel*((3/2)*math.pi)

    -- fuel gauge
    if plane.fuel < 0.15 then
        if (time*3)%1 < 0.5 then
            love.graphics.setColor(1, 0.8, 0.8)
        else
            love.graphics.setColor(1, 1, 1)
        end
    end
    local s = self.size/images.gauge:getWidth()
    love.graphics.draw(images.gauge,  self.position.x, self.position.y, 0,     s, s, images.gauge:getWidth()/2,  images.gauge:getHeight()/2)
    love.graphics.draw(images.needle, self.position.x, self.position.y, angle, s, s, images.needle:getWidth()/2, images.needle:getHeight()/2)
    love.graphics.setColor(1, 1, 1)

    -- packages left
    local dx, dy = 0.3 * self.size, self.size * 0.2
    -- love.graphics.setColor(0, 0, 0, 0.8)
    -- love.graphics.rectangle("fill", self.position.x - dx * 1.72, self.position.y + self.size * 0.8 - dy * 0.75, dx * 3.5, dy * 3.5)
    -- love.graphics.setColor(1, 1, 1)
    for i = 0, plane.quantity-1 do
        local r = math.sin(time*2*math.pi+2*i) * 0.1
        love.graphics.draw(images.package, self.position.x - dx + (i%3) * dx, self.position.y + self.size * 0.8 + math.floor(i/3) * dy,
            r, self.size/300, self.size/300, images.package:getWidth()/2, images.package:getHeight()/2)
    end

    -- score
    local offset = 40
    local text = "People fed:"
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fonts.writing30)
    love.graphics.print(text, self.position.x - love.graphics.getFont():getWidth(text) + offset, self.position.y + self.size * 1.5)
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.setFont(fonts.writing50)
    local score = self.state.positiveScore
    love.graphics.print(score, self.position.x + offset + 10, self.position.y + self.size * 1.5 - 10)

    local text = "People killed:"
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fonts.writing30)
    love.graphics.print(text, self.position.x - love.graphics.getFont():getWidth(text) + offset, self.position.y + self.size * 2.0)
    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(fonts.writing50)
    local score = self.state.negativeScore
    love.graphics.print(score, self.position.x + offset + 10, self.position.y + self.size * 2.0 - 10)

    love.graphics.setColor(1, 1, 1)
end
