local class = require 'middleclass'
require "entity"

SPEED_FACTOR = 240
MAX_SPEED = 2
FUEL_CONSUMPTION = 0.025

Plane = class ("Plane", Entity)
Plane.z = 6
function Plane:initialize(x, y)
    self.z = 6
    self.normalFlight = true
    self.position = Vector:new(x,y)
    self.speed = 1
    self.direction = 0
    self.directionChange = 0
    self.rotationspeed = 2
    self.fuel = 1
    self.fuelconsumption = 1
    self.quantity = 9
    self.altitude = 1
    self.landing = false
    self.isCrashing = false
    self.crashed = false
    self.size = 1
    self.stutter = false
    self.motorProblem = false

    self.landing = true
    self.altitude = 0
    self.fuelconsumption = 0
    self.speed = 0
    self:liftoff()

    self.sound = love.audio.newSource(sounds.flight)
    self.sound:setLooping(true)
    -- self.sound:play()

    -- Trudel-Winkel, wird nicht in Richtung eingerechnet, aber zum Drehen der Grafik verwendet
    self.spinAngle = 0
    self.spinAngleSpeed = 0

    -- particles
    self.smokeTrailLeft = SmokeTrail:new(self.position, self, 255, 255, 255)
    self.smokeTrailRight = SmokeTrail:new(self.position, self, 255, 255, 255)
    self.smokeTrailLeft2 = SmokeTrail:new(self.position, self, 200, 200, 200)
    self.smokeTrailRight2 = SmokeTrail:new(self.position, self, 200, 200, 200)

end 

function Plane:update(dt)
    if math.random() < 1/30*dt and not self.motorProblem then 
        self.motorProblem = true
        tween(math.random()*2 + 1,{},{},nil,function()
            self.motorProblem = false
        end)
    end
    self.stutter = (time%0.15)< 0.1 and self.motorProblem
    if self.stutter then
        self.sound:pause()
        
    else
        if not self.landing and not self.isCrashing and not self.crashed then
            self.sound:play()
        end
          
    end    
    if not self.isCrashing then
        local dir = 0
        local dirChangeSpeed = 5

        local mx, my = love.mouse.getPosition()
        local mp = Vector:new(mx / love.graphics.getWidth(), my / love.graphics.getHeight())
        local md = love.mouse.isDown("l")

        if love.keyboard.isDown("left") or love.keyboard.isDown("a") or (md and mp.x < 0.3) then dir = -1 end
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") or (md and mp.x > 0.7) then dir = 1 end  
        if not dir then dirChangeSpeed = 20 end
        self.directionChange = self.directionChange * (1 - dt*dirChangeSpeed) + dir * dt * dirChangeSpeed

        self.direction = self.direction + self.rotationspeed*dt*self.directionChange
        self.spinAngleSpeed = self.directionChange

        if not self.landing then
            local ds = 0
            local mc = md and mp.x > 0.3 and mp.x < 0.7
            if love.keyboard.isDown("w") or love.keyboard.isDown("up") or (mc and mp.y < 0.3) then ds = 1 end
            if love.keyboard.isDown("s") or love.keyboard.isDown("down") or (mc and mp.y > 0.7) then ds = -1 end
            self.speed = math.max(1, math.min(MAX_SPEED, self.speed + ds * dt))
        end
    else
        self.spinAngle = self.spinAngle + self.spinAngleSpeed * dt
    end

    local dir = Vector:new(0, -1)
    dir:rotate(self.direction)
    dir = dir * dt * self.speed * SPEED_FACTOR 

    -- wind
    if not (self.isCrashing or self.landing or self.crashed) then
        dir = dir + self.state:getWindVector(dt) * 0.2
    end

    self.position = self.position + dir
    self.fuel = math.max(0, self.fuel - self.fuelconsumption * dt * FUEL_CONSUMPTION * math.pow(self.speed, 1.3))
    if self.fuel <= 0 then
        self:crash()
    end

    self.size = 0.2 + 0.8 * self.altitude

    self.smokeTrailLeft.position = self.position + Vector:new(-40*self.size, 0):rotated(self.direction + self.spinAngle)
    self.smokeTrailRight.position = self.position + Vector:new( 40*self.size, 0):rotated(self.direction + self.spinAngle)
    self.smokeTrailLeft2.position = self.position + Vector:new(-40*self.size, 0):rotated(self.direction + self.spinAngle)
    self.smokeTrailRight2.position = self.position + Vector:new( 40*self.size, 0):rotated(self.direction + self.spinAngle)
    
    self.smokeTrailLeft:update(dt)
    self.smokeTrailRight:update(dt)
    self.smokeTrailLeft2:update(dt)
    self.smokeTrailRight2:update(dt)
end

function Plane:draw()
    self.smokeTrailLeft:draw()
    self.smokeTrailRight:draw()
    self.smokeTrailLeft2:draw()
    self.smokeTrailRight2:draw()
    if self.crashed == false then
        love.graphics.draw(images.plane, self.position.x, self.position.y, self.direction + self.spinAngle, 
        self.size, self.size, images.plane:getWidth()/2, images.plane:getHeight()/2)
    else
        love.graphics.draw(images.crater, self.position.x, self.position.y, 0, 0.1, 0.1, images.crater:getWidth()/2, images.crater:getHeight()/2)        
    end
end

function Plane:dropPackage()
    if self.quantity > 0 and self.isCrashing == false then
        source = love.audio.newSource(sounds.drop)
    source:play()
        self.state:add(Package:new(self))
        self.quantity = self.quantity - 1
    end
end

function Plane:crash()
    if self.isCrashing then return end
    self.isCrashing = true
    self.sound:pause()
    source = love.audio.newSource(sounds.crashing)
    source:play()
    tween(2.6, self, {altitude = 0}, "inQuad")
    tween(2.6, self, {speed = 0}, "inCirc", function() 
        self.state:add(Explosion:new(self.position:clone()))
        self.crashed = true
        Plane.z = 3
        tween(2, {}, {}, nil, function()
            self.state:fadeOver(states.gameover)
        end)
    end)
    
end

function Plane:land(airport)
    self.landing = true
    self.sound:pause()
    self.rotationspeed = 0
    self.fuelconsumption = 0
    source = love.audio.newSource(sounds.landing)
    source:play()

    local pi2 = math.pi * 2
    local dir = (airport.orientation + math.pi) % pi2 - math.pi
    self.direction = (self.direction + math.pi) % pi2 - math.pi
    if dir < 0 and self.direction > 0 then
        dir = dir + pi2
    end

    tween(1, self, {direction = dir}, "inOutQuad")
    tween(1.2, self, {altitude = 0}, "inOutQuad")
    self.speed = 0.6
    tween(1.5, self, {speed = 0}, "inExpo", function()
        self:refuel()
    end)
    
end

function Plane:refuel()
    source = love.audio.newSource(sounds.refuel)
    source:play()
    tween (2, self, {quantity = 9})
    tween(1.5, self, {direction = self.direction + math.pi})
    tween(2, self, {fuel = 1}, "inOutQuad", function()
        self:liftoff()
    end)
end

function Plane:liftoff()
    source = love.audio.newSource(sounds.liftoff)
    source:play()
    self.rotationspeed = 2
    self.fuelconsumption = 1
    tween(1, self, {speed = 1}, "inQuad")
    tween(1, {}, {}, nil, function() 
        tween(3, self, {altitude = 1}, "inOutQuad", function() 
            self.landing = false
            self.sound:play()
        end)
    end)
end

