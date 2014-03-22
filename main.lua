tween = require 'tween'
local class = require 'middleclass'
require "entity"
require "village"
welt = {}
images = {}

function love.load()
    math.randomseed(os.time())

    images.plane = love.graphics.newImage("graphics/Plane.png")
    images.package = love.graphics.newImage("graphics/Package.png")
    images.houses = {}
    images.houses[1] = love.graphics.newImage("graphics/House1.png")
    images.houses[2] = love.graphics.newImage("graphics/House3.png")
    images.church = love.graphics.newImage("graphics/House2.png")
    village = Village:new(500, 500)
    table.insert(welt,village)
    plane = Plane:new(400, 300)
    table.insert(welt, plane)
end

function love.update(dt)
    tween.update(dt)
    for k,v in pairs(welt) do
        v:update(dt)
    end    
end

function love.draw()
    for k,v in pairs(welt) do
        v:draw()
    end    
end
function love.keypressed(key)
    if key == " " then
        plane:dropPackage()
    end
end