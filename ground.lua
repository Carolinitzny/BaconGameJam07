local class = require 'middleclass'

require "entity"
Ground = class ("Ground", Entity)


function Ground:draw()
    love.graphics.draw(images.ground)
end
    