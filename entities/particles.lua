local class = require "middleclass"
require "entity"

ParticleEntity = class("ParticleEntity", Entity)
ParticleEntity.z = 4
function ParticleEntity:initialize(position, image, count)
    self.position = position
    self.particles = love.graphics.newParticleSystem(image, count or 100)
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
function SmokeTrail:initialize(position, plane, r, g, b)
    self.r = r
    self.g = g
    self.b = b
    ParticleEntity.initialize(self, position, images.smoke, 200)
    self.plane = plane
    self.particles:setEmissionRate(100)
    self.particles:setParticleLifetime(2.0)
    self.particles:setSizes(0.05, 0.0)
end

function SmokeTrail:update(dt)
    ParticleEntity.update(self, dt)
    self.particles:setColors(
        self.r, self.g, self.b, self.plane.altitude * 255,
        self.r, self.g, self.b, 0)
end

SmokeRing = class("SmokeRing", ParticleEntity)
function SmokeRing:initialize(position)
    ParticleEntity.initialize(self, position, images.smokeRing, 1)
    self.particles:setEmissionRate(100)
    self.particles:setEmitterLifetime(1)
    self.particles:setParticleLifetime(1)
    self.particles:setColors(
        100, 100, 0, 100,
        255, 200, 0, 0)
    self.particles:setSizes(0.1, 1.0)
end

TargetSignal = class("TargetSignal", ParticleEntity)
function TargetSignal:initialize(position, target)
    ParticleEntity.initialize(self, position, images.smoke, 100)
    self.target = target
    self.particles:setEmissionRate(50)
    self.particles:setParticleLifetime(1)
    self.particles:setSpeed(50)
    self.particles:setSpread(0.5)
    self.particles:setDirection(- math.pi /2)
    local c = self.target.color
    self.particles:setColors(
        255, 255, 255, 255,
        c[1], c[2], c[3], 128,
        c[1], c[2], c[3], 0)
    self.particles:setSizes(0.1, 0.5)
end

-- function TargetSignal:draw()
--     love.graphics.setBlendMode("additive")
--     love.graphics.draw(self.particles)
--     love.graphics.setBlendMode("alpha")
-- end
