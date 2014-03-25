local class = require 'middleclass'

require "entity"
Target = class ("Village", Entity)
Target.z = 4

function Target:initialize(x,y,village)
    self.position = Vector:new(x,y) 
    self.size = 50
    self.village = village
    self.color = {hsl2rgb(math.random(), 1, 0.5)}
    if not MOBILE then
        self.signal = TargetSignal(self.position, self)
    end
end

function Target:update(dt)
    if self.signal then
        self.signal:update(dt)
    end
end

function Target:draw()
    -- love.graphics.setColor(0, 255, 0, 20)
    -- love.graphics.circle("fill", self.position.x, self.position.y, self.size*5) 
    -- love.graphics.setColor(0, 255, 0)
    -- love.graphics.circle("fill", self.position.x, self.position.y, self.size)
    -- love.graphics.setColor(255, 255, 255)    
    if self.signal then
        self.signal:draw()
    else
        love.graphics.setColor(unpack(self.color))
        -- love.graphics.circle("fill", self.position.x, self.position.y, self.size)
        local img = images.target
        local w, h = img:getWidth(), img:getHeight()
        love.graphics.draw(img, self.position.x, self.position.y, 0, self.size / w, self.size / h, w / 2, h / 2)
    end
end