tween = require 'tween'
local class = require 'middleclass'
require "entity"
require "village"
require "ground"

welt = {}
generated = {left = 0, right = 0, top = 0, bottom = 0}
images = {}
time = 0
alive = true
function isVillageNearby(pos, threshold)
    for k, v in pairs(welt) do
        if v:isInstanceOf(Village) then
            local diff = v.position - pos
            if diff:len() < threshold then
                return true
            end
        end    
    end    
    return false
end

function generateVillages(left, right, top, bottom)
    local density = 2/(800*600)
    local area = math.abs((right - left)* (bottom - top))
    local count = area * density
    
    for k = 1, count do
        for l = 1, 100 do
            local pos = Vector:new(math.random(left,right), math.random(top, bottom))
            if not isVillageNearby(pos, 500) or l == 100 then
                village = Village:new(pos.x, pos.y)
                table.insert(welt,village)
                break    
            end 
        end    
    end
end

function love.load()
    math.randomseed(os.time())

    images.plane = love.graphics.newImage("graphics/Plane.png")
    images.package = love.graphics.newImage("graphics/Package.png")
    images.houses = {}
    images.houses[1] = love.graphics.newImage("graphics/House1.png")
    images.houses[2] = love.graphics.newImage("graphics/House3.png")
    images.church = love.graphics.newImage("graphics/House2.png")
    images.ground = love.graphics.newImage("graphics/background.png")
    images.gauge = love.graphics.newImage("graphics/Gauge.png")
    images.needle = love.graphics.newImage("graphics/Needle.png")

    ground = Ground:new()
    table.insert(welt, ground)
    village = Village:new(500, 500)
    table.insert(welt,village)
    plane = Plane:new(400, 300)
    table.insert(welt, plane)
end

function love.update(dt)
    time = time + dt
    tween.update(dt)
    for k,v in pairs(welt) do
        v:update(dt)
    end
    offset = plane.position - Vector:new(love.graphics.getWidth(), love.graphics.getHeight())*0.5    
    
    --Generating villages
    local distance = 2000
    local g = generated

    -- left
    if plane.position.x < g.left + distance then
        generateVillages(g.left - distance, g.left, g.top, g.bottom)
        g.left = g.left - distance
    end    
    --right 
    if plane.position.x > g.right - distance then
        generateVillages(g.right, g.right + distance, g.top, g.bottom)
        g.right = g.right + distance
    end    
    --top
    if plane.position.y < g.top + distance then
        generateVillages(g.left , g.right, g.top - distance, g.top)
        g.top = g.top - distance
    end
    --bottom    
    if plane.position.y > g.bottom - distance then
        generateVillages(g.left, g.right, g.bottom, g.bottom + distance)
        g.bottom = g.bottom + distance
    end    
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-offset.x, -offset.y)
    for k,v in pairs(welt) do
        v:draw()
    end 
    love.graphics.pop()   
end

function love.keypressed(key)
    if key == " " then
        plane:dropPackage()
    end
end