tween = require 'tween'
local class = require 'middleclass'
require "entity"
require "village"
require "ground"
welt = {}
images = {}
time = 0
alive = true

function love.load()
    math.randomseed(os.time())

    images.plane = love.graphics.newImage("graphics/Plane.png")
    images.package = love.graphics.newImage("graphics/Package.png")
    images.houses = {}
    images.houses[1] = love.graphics.newImage("graphics/House1.png")
    images.houses[2] = love.graphics.newImage("graphics/House3.png")
    images.church = love.graphics.newImage("graphics/House2.png")
    images.ground = love.graphics.newImage("graphics/background.png")

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