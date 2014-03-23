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
    self.sound = love.audio.newSource(sounds.tornado)
end

function Tornado:update(dt)
    self.direction.x = love.math.noise(        time/10 + self.seed) * 2 - 1
    self.direction.y = love.math.noise(10000 + time/10 + self.seed) * 2 - 1
    self.position = self.position + self.direction * dt * 100

    self.particles.position = self.position
    self.particles:update(dt)

    local plane = self.state.plane
    local diff = plane.position - self.position
    local len = diff:len()
    if len < 120 and not (plane.landing or plane.crashed) then
        if not plane.isCrashing then
            plane:crash()
        end
        plane.spinAngleSpeed = plane.spinAngleSpeed + (1 - len/120) * 50 * dt
    end

    if len < 500 then
        self.sound:setVolume(1 - len / 500)
        self.sound:play()
    else
        self.sound:pause()
    end
end

function Tornado:draw()
    love.graphics.setColor(255, 255, 255)

    self.particles:draw()
end