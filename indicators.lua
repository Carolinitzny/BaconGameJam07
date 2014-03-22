local class = require 'middleclass'
require "entity"

Indicators = class("Indicators", Entity)

function Indicators:draw()    
    local angle = plane.fuel*((3/2)*math.pi)
    love.graphics.draw(images.gauge, love.graphics.getWidth()-75, 10, 0, 0.05, 0.05, images.gauge:getWidth()/2, images.gauge:getHeight()/2)
    love.graphics.draw(images.needle, love.graphics.getWidth()-75, 10, angle, 0.05, 0.05, images.needle:       getWidth()/2, images.needle:getHeight()/2)
    love.graphics.setColor(255, 255, 255)
    for i = 0, plane.quantity-1 do
        local r = math.sin(time*2*math.pi)*0.2
        love.graphics.draw(images.package, love.graphics.getWidth()-115 + ((i%5)*20), 50 + math.floor(i/5)*20, r, 0.15, 0.15,
            (images.package:getWidth())/2, images.package:getHeight()/2)
    end
end    