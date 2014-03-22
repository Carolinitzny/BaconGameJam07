local class = require 'middleclass'
require "entity"
welt = {}
image = {}
function love.load()
    plane = Plane:new(400, 300)
    table.insert(welt, plane)
    image.plane = love.graphics.newImage("graphics/Plane.png")
end

function love.update(dt)
    for k,v in pairs(welt) do
        v:update(dt)
    end    
end

function love.draw()
    for k,v in pairs(welt) do
        v:draw()
    end    
end
