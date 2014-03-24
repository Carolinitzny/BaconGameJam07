local class = require "middleclass"
require "state"

GameState = class("GameState", State)
function GameState:initialize()
    State.initialize(self)
    -- self:reset()
    self.fade = 0
end

function GameState:reset()
    self.ui = {}
    self.world = {}
    self.offset = Vector:new()
    self.generated = {left = 0, right = 0, top = 0, bottom = 0}

    self.score = 0
    self.positiveScore = 0
    self.negativeScore = 0

    time = 0

    self.windDirection = 0
    self.windSwing = 0
    GameOverState.highscore = false
    
    self:add(Ground:new())
    self:add(Clouds:new())

    self.plane = Plane:new(0, 0)
    self:add(self.plane)
    self:add(Airport:new(0, 60, 0))

    self:add(Indicators:new(), true)
    self:add(Minimap:new(), true)
end

function GameState:getWindVector(dt)
    return Vector:new(self.windFactor * dt, 0):rotated(self.windDirection)
end

function GameState:update(dt)
    self:updateEntities(dt)

    self.windDirection = love.math.noise(10000+time*0.1) * math.pi
    local f = love.math.noise(time*0.4)
    self.windFactor = f * (math.log(time * 0.05 + 1))
    self.windSwing = self.windSwing + f * dt

    self.offset = self.plane.position - Vector:new(love.graphics.getWidth(), love.graphics.getHeight())*0.5    

    -- Generating villages
    local distance = 2000
    local size = 2000
    local g = self.generated

    -- left
    if self.plane.position.x < g.left + distance then
        self:generateWorld(g.left - size, g.left, g.top, g.bottom)
        g.left = g.left - size
    end    
    --right 
    if self.plane.position.x > g.right - distance then
        self:generateWorld(g.right, g.right + size, g.top, g.bottom)
        g.right = g.right + size
    end    
    --top
    if self.plane.position.y < g.top + distance then
        self:generateWorld(g.left , g.right, g.top - size, g.top)
        g.top = g.top - size
    end
    --bottom    
    if self.plane.position.y > g.bottom - distance then
        self:generateWorld(g.left, g.right, g.bottom, g.bottom + size)
        g.bottom = g.bottom + size
    end    
end

function GameState:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.push()
    love.graphics.translate(-self.offset.x, -self.offset.y)
    self:drawWorld()
    love.graphics.pop()
    self:drawUI()

    love.graphics.setColor(255, 255, 255, self.fade * 255)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function GameState:isVillageNearby(pos, threshold)
    for k, v in pairs(self.world) do
        if v:isInstanceOf(Village) or v:isInstanceOf(Airport)then
            local diff = v.position - pos
            if diff:len() < threshold then
                return true
            end
        end    
    end    
    return false
end

function GameState:generateWorld(left, right, top, bottom)
    local area = math.abs((right - left)* (bottom - top))
    
    --villages
    local density = 1.2/(800*600)
    local count = area * density
    
    for k = 1, count do
        for l = 1, 50 do
            local pos = Vector:new(math.random(left,right), math.random(top, bottom))
            if not self:isVillageNearby(pos, 200) or l == 50 then
                if l == 50 then print("Meh village") end
                local village = Village:new(pos.x, pos.y)
                local target = Target:new(pos.x, pos.y, village)
                self:add(village)
                self:add(target)
                break    
            end 
        end    
    end

    --airports
    local density = 0.1/(800*600)
    local count = math.ceil(area * density)
    for k = 1, count do
        for l = 1, 50 do
            local pos = Vector:new(math.random(left,right), math.random(top, bottom))
            if not self:isVillageNearby(pos, 200) or l == 50 then
                local airport = Airport:new(pos.x, pos.y, math.random()*2*math.pi)
                self:add(airport)
                break    
            end 
        end    
    end

    --vegetation
    local density = 3/(800*600)
    local count = area*density
    for k = 1, count do
        local pos = Vector:new(math.random(left,right), math.random(top, bottom))
        local vegetation = Vegetation:new(pos.x, pos.y, vegetation)
        self:add(vegetation)
    end
    
    --tornado
    local density = 0.2/(800*600)
    local count = area*density
    for k = 1, count do
        local pos = Vector:new(math.random(left,right), math.random(top, bottom))
        local tornado = Tornado:new(pos.x, pos.y, tornado)
        self:add(tornado)
    end
end

function GameState:keypressed(key)
    if key == " " then
        self.plane:dropPackage()
    elseif key == "tab" then
        self:fadeOver(states.title)
    end
end

function GameState:addScore(s)
    self.score = self.score + s
    if s > 0 then
        self.positiveScore = self.positiveScore + s
    else
        self.negativeScore = self.negativeScore - s
    end
end

function GameState:mousepressed(x, y, b) 
    local p = Vector:new(x / love.graphics.getWidth(), y / love.graphics.getHeight())
    if (p - Vector:new(0.5, 0.5)):len() < 0.1 then
        self.plane:dropPackage()
    end
end

function GameState:fadeOver(state)
    tween(1, self, {fade=1}, "inOutQuad", function()
        setState(state)
    end)
end

function GameState:onEnter()
    self.fade = 1
    tween(1, self, {fade=0}, "inOutQuad")
end

function GameState:onScreen(pos, size)
    local screenSize = math.max(love.graphics.getWidth(), love.graphics.getHeight()) + size
    return (self.plane.position - pos):len() < screenSize
end
