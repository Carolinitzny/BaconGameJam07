local class = require 'middleclass'

require "entity"
Ground = class ("Ground", Entity)


function Ground:draw()
    local offset = self.state.offset or Vector:new(0, 0)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    local x1 = math.floor(offset.x/w) *w
    local x2 = math.ceil(offset.x/w) *w
    local y1 = math.floor(offset.y/h) *h
    local y2 = math.ceil(offset.y/h) *h
    love.graphics.draw(images.ground,x1,y1)
    love.graphics.draw(images.ground,x1,y2)
    love.graphics.draw(images.ground,x2,y1)
    love.graphics.draw(images.ground,x2,y2)
end
    