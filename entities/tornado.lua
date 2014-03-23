local class = require 'middleclass'
require "entity"

Tornado = class ("Tornado", Entity)
Tornado.z = 7
function Tornado:initialize(x,y)
    self.position = Vector:new(x,y)
    self.tornado = {}
    self.direction = Vector:new(0, 0)
    self.particles = TornadoSwirl:new(self.position)
    self.seed = math.random() * 1000
end

function Tornado:update(dt)
    self.direction.x = love.math.noise(        time/10 + self.seed) * 2 - 1
    self.direction.y = love.math.noise(10000 + time/10 + self.seed) * 2 - 1
    self.position = self.position + self.direction * dt * 100

    self.particles.position = self.position
    self.particles:update(dt)
end

function Tornado:draw()
    love.graphics.setColor(255, 255, 255)

    self.particles:draw()
end