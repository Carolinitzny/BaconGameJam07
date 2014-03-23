local class = require 'middleclass'

require "entity"
Target = class ("Village", Entity)
Target.z = 4

function Target:initialize(x,y,village)
    self.position = Vector:new(x,y) 
    self.size = 15
    self.village = village
    self.color = {hsl2rgb(math.random(), 1, 0.5)}
    self.signal = TargetSignal(self.position, self)
end

function Target:update(dt)
    self.signal:update(dt)
end

function Target:draw()
    -- love.graphics.setColor(0, 255, 0, 20)
    -- love.graphics.circle("fill", self.position.x, self.position.y, self.size*5) 
    -- love.graphics.setColor(0, 255, 0)
    -- love.graphics.circle("fill", self.position.x, self.position.y, self.size)
    -- love.graphics.setColor(255, 255, 255)    
    self.signal:draw()
end