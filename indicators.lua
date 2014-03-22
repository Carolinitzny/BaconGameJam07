local class = require 'middleclass'
require "entity"

Indicators = class("Indicators", Entity)

function Indicators:draw()    
    local plane = self.state.plane
    local angle = plane.fuel*((3/2)*math.pi)
    if plane.fuel < 0.15 then
       if (time*3)%1 < 0.5 then
           love.graphics.setColor(255, 200, 200)
       else
           love.graphics.setColor(255, 255, 255)
       end
    end
    love.graphics.draw(images.gauge, love.graphics.getWidth()-75, 80, 0, 0.15, 0.15, images.gauge:getWidth()/2, images.gauge:getHeight()/2)
    love.graphics.draw(images.needle, love.graphics.getWidth()-75, 80, angle, 0.15, 0.15, images.needle:       getWidth()/2, images.needle:getHeight()/2)
    love.graphics.setColor(255, 255, 255)
    for i = 0, plane.quantity-1 do
        local r = math.sin(time*2*math.pi)*0.2
        love.graphics.draw(images.package, love.graphics.getWidth()-120 + ((i%4)*30), 160 + math.floor(i/4)*20, r, 0.25, 0.25,
            (images.package:getWidth())/2, images.package:getHeight()/2)
    end
end    