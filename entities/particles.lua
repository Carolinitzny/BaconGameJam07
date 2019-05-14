local class = require "middleclass"
require "entity"

ParticleEntity = class("ParticleEntity", Entity)
ParticleEntity.z = 4
function ParticleEntity:initialize(position, image, count, blendMode)
    self.position = position
    self.blendMode = blendMode
    self.particles = love.graphics.newParticleSystem(image, count or 100)
end

function ParticleEntity:update(dt)
    self.particles:setPosition(self.position.x, self.position.y)
    self.particles:update(dt)
end

function ParticleEntity:draw()
    if self.blendMode then
        love.graphics.setBlendMode(self.blendMode)
    end
    love.graphics.draw(self.particles)
    love.graphics.setBlendMode("alpha")
end

Explosion = class("Explosion", ParticleEntity)
Explosion.z = 100
function Explosion:initialize(position)
    ParticleEntity.initialize(self, position, images.smoke, 100, "add")
    self.particles:setSpread(math.pi * 2)
    self.particles:setBufferSize( 1000 )
    self.particles:setEmissionRate( 4000 )
    self.particles:setEmitterLifetime( 0.05 )
    self.particles:setParticleLifetime( 0.5, 1.0 )
    self.particles:setColors( 0.8, 0.2, 0.1, 1, 1, 0.45, 0.12, 0 )
    self.particles:setSizes( 1, 2 , 0)
    self.particles:setSpeed( 120, 140  )
    self.particles:setRadialAcceleration( -150 )
end

SmokeTrail = class("SmokeTrail", ParticleEntity)
function SmokeTrail:initialize(position, plane, r, g, b)
    ParticleEntity.initialize(self, position, images.smoke, 500)
    self.r = r
    self.g = g
    self.b = b
    self.plane = plane
    self.particles:setParticleLifetime(1.0)
    self.particles:setSizes(0.1, 0.2)
    self.particles:setSpeed(0, 10)
    self.particles:setSpread(math.pi*2)
end

function SmokeTrail:update(dt)
    ParticleEntity.update(self, dt)
    self.particles:setEmissionRate(100*self.plane.speed)
    self.particles:setColors(
        self.r, self.g, self.b, self.plane.altitude,
        self.r, self.g, self.b, 0)
end

SmokeRing = class("SmokeRing", ParticleEntity)
function SmokeRing:initialize(position)
    ParticleEntity.initialize(self, position, images.smokeRing, 1)
    self.particles:setEmissionRate(100)
    self.particles:setEmitterLifetime(1)
    self.particles:setParticleLifetime(1)
    self.particles:setColors(
        0.4, 0.4, 0, 0.4,
        1, 0.8, 0, 0)
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
        1, 1, 1, 1,
        c[1], c[2], c[3], 0.5,
        c[1], c[2], c[3], 0)
    self.particles:setSizes(0.1, 0.5)
end

TornadoSwirl = class("TornadoSwirl", ParticleEntity)
function TornadoSwirl:initialize(position)
    ParticleEntity.initialize(self, position, images.smoke2, 100)
    self.particles:setEmissionRate(10)
    self.particles:setParticleLifetime(2)
    -- self.particles:setSpeed(-100)
    self.particles:setRadialAcceleration(-100)
    self.particles:setTangentialAcceleration(100)
    self.particles:setSpread(math.pi * 2)
    self.particles:setColors(
        0.4, 0.4, 0.4, 1,
        1, 1, 1, 0
        )
    self.particles:setSizes(0.1, 2)
    -- self.particles:setAreaSpread("normal", 100, 100)

    self.particles:setBufferSize( 2000 )
    self.particles:setEmissionRate( 400 )
    self.particles:setParticleLifetime( 2 )
    local a = 250
    local b = a * 0.6
    local c = a * 0.3
    self.particles:setColors(
        c, 0.9*c, 0.8*c, 0,
        b, 0.9*b, 0.8*b, 0.07,
        a, 0.9*a, 0.8*a, 0.2,
        a, 0.9*a, 0.8*a, 0)
    self.particles:setSizes( 0.1, 0.7)
    self.particles:setSpeed( 50, 70 )
    self.particles:setSpin(10)
    self.particles:setTangentialAcceleration( 160 )
    self.particles:setInsertMode("bottom")
    -- self.particles:setRadialAcceleration(-100)
end
