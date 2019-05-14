local class = require 'middleclass'

require "entity"
Clouds = class ("Clouds", Entity)
Clouds.z = 1000000

function Clouds:draw()
    local offset = self.state.offset or Vector:new(0, 0)
    local s = 2
    local w, h = images.clouds:getWidth()*s, images.clouds:getHeight()*s
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()

    local pos = -offset * 0.5
    offset = offset - pos

    love.graphics.setColor(1, 1, 1, 0.8)
    for x = math.floor(offset.x/w), math.ceil((offset.x + W)/w) do
        for y = math.floor(offset.y/h), math.ceil((offset.y + H)/h) do
            love.graphics.draw(images.clouds, pos.x + x * w, pos.y + y * h, 0, s, s)
        end
    end
end

