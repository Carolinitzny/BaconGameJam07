local class = require "middleclass"
require "state"

GameState = class("GameState", State)
function GameState:initialize()
    State.initialize(self)
    self.offset = Vector:new()
    self.generated = {left = 0, right = 0, top = 0, bottom = 0}
    self:reset()
end

function GameState:reset()
    self.score = 0
    
    self:add(Ground:new())

    self.plane = Plane:new(0, 0)
    self:add(self.plane)

    self:add(Indicators:new(), true)
    self:add(Minimap:new(), true)
end

function GameState:update(dt)
    self:updateEntities(dt)

    self.offset = self.plane.position - Vector:new(love.graphics.getWidth(), love.graphics.getHeight())*0.5    

    -- Generating villages
    local distance = 2000
    local g = self.generated

    -- left
    if self.plane.position.x < g.left + distance then
        self:generateVillages(g.left - distance, g.left, g.top, g.bottom)
        g.left = g.left - distance
    end    
    --right 
    if self.plane.position.x > g.right - distance then
        self:generateVillages(g.right, g.right + distance, g.top, g.bottom)
        g.right = g.right + distance
    end    
    --top
    if self.plane.position.y < g.top + distance then
        self:generateVillages(g.left , g.right, g.top - distance, g.top)
        g.top = g.top - distance
    end
    --bottom    
    if self.plane.position.y > g.bottom - distance then
        self:generateVillages(g.left, g.right, g.bottom, g.bottom + distance)
        g.bottom = g.bottom + distance
    end    
end

function GameState:draw()
    love.graphics.push()
    love.graphics.translate(-self.offset.x, -self.offset.y)
    self:drawWorld()
    love.graphics.pop()
    self:drawUI()
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

function GameState:generateVillages(left, right, top, bottom)
    --villages
    local density = 1.5/(800*600)
    local area = math.abs((right - left)* (bottom - top))
    local count = area * density
    
    for k = 1, count do
        for l = 1, 50 do
            local pos = Vector:new(math.random(left,right), math.random(top, bottom))
            if not self:isVillageNearby(pos, 500) or l == 50 then
                local village = Village:new(pos.x, pos.y)
                local target = Target:new(pos.x, pos.y, village)
                self:add(village)
                self:add(target)
                break    
            end 
        end    
    end
    --airports

   local density = 0.15/(800*600)
    local area = math.abs((right - left)* (bottom - top))
    local count = area * density
    
    for k = 1, count do
        for l = 1, 50 do
            local pos = Vector:new(math.random(left,right), math.random(top, bottom))
            if not self:isVillageNearby(pos, 500) or l == 50 then
                local airport = Airport:new(pos.x, pos.y, math.random()*2*math.pi)
                self:add(airport)
                break    
            end 
        end    
    end
     
end

function GameState:keypressed(key)
    if key == " " then
        self.plane:dropPackage()
    elseif key == "tab" then
        currentState = states.menu
    end
end

function GameState:addScore(s)
    self.score = self.score + s
end
