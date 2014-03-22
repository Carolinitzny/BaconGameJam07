local class = require "middleclass"
require "entity"

ParticleEntity = class("ParticleEntity", Entity)
function ParticleEntity:initialize(position, image, count)
    self.position = position
    self.particles = love.graphics.newParticleSystem(images.smoke, count or 100)
end

function ParticleEntity:update(dt)
    self.particles:setPosition(self.position.x, self.position.y)
    self.particles:update(dt)
end

function ParticleEntity:draw()
    love.graphics.draw(self.particles)
end

Explosion = class("Explosion", ParticleEntity)
function Explosion:initialize(position)
    ParticleEntity.initialize(self, position, images.smoke, 100)
    self.particles:setEmissionRate(1000)
    self.particles:setEmitterLifetime(0.1)
    self.particles:setParticleLifetime(1.5, 2.0)
    self.particles:setRadialAcceleration(-50)
    self.particles:setSpeed(100, 150)
    self.particles:setColors(
        255, 255, 200, 255,
        50, 50, 50, 20,
        0, 0, 0, 20,
        0, 0, 0, 10,
        0, 0, 0, 0)
    self.particles:setSizes(0.1, 0.8)
    self.particles:setSpread(math.pi * 2)
end

SmokeTrail = class("SmokeTrail", ParticleEntity)
function SmokeTrail:initialize(position)
    ParticleEntity.initialize(self, position, images.smoke, 200)
    self.particles:setEmissionRate(100)
    self.particles:setParticleLifetime(2.0)
    self.particles:setColors(
        255, 255, 255, 255,
        255, 255, 255, 0)
    self.particles:setSizes(0.05, 0.0)
end

