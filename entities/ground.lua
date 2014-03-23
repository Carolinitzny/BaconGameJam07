local class = require 'middleclass'

require "entity"
Ground = class ("Ground", Entity)
Ground.z = 0

function Ground:draw()
    local offset = self.state.offset or Vector:new(0, 0)
    local w, h = images.ground:getWidth(), images.ground:getHeight()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()

    for x = math.floor(offset.x/w), math.ceil((offset.x + W)/w) do
        for y = math.floor(offset.y/h), math.ceil((offset.y + H)/h) do
            love.graphics.draw(images.ground, x * w, y * h)
        end
    end
end
    