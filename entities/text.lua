local class = require 'middleclass'
require "entity"

Text = class("Text", Entity)
Text.z = 1000
function Text:initialize(pos, text, color, font)
    self.position = pos:clone()
    self.text = text
    self.color = color or {255, 255, 255}
    self.color[4] = 255
    self.font = font or fonts.writing30

    tween(2, self.color, {[4]=0})
    tween(2, self.position, {y=self.position.y - 100}, "outQuad", function()
        self.state:delete(self)
    end)
end

function Text:draw()
    love.graphics.setFont(self.font)
    love.graphics.setColor(unpack(self.color))
    love.graphics.print(self.text, self.position.x - self.font:getWidth(self.text) / 2, self.position.y - self.font:getHeight() / 2)
    love.graphics.setColor(255, 255, 255)
end

