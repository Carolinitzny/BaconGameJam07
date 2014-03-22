local class = require 'middleclass'
require "entity"

Village = class ("Village", Entity)
function Village:initialize(x,y)
    self.position = Vector:new(x,y) 
    self.count = math.random(3,10)
    self.houses = {}
    for k = 1, self.count do
        local house = {}
        house.image = images.houses[math.random(#images.houses)]
        house.x = math.random(-50, 50)
        house.y = math.random(-50, 50)
        table.insert(self.houses,house)
    end 
    if math.random()< 0.33 then
        local church = {}   
        church.image = images.church
        church.x = 0
        church.y = 0 
        table.insert(self.houses, church)    
    end
end

function Village:draw()
    for k, v in pairs(self.houses) do
        local s = 0.3
        local image =v.image
        love.graphics.draw(image,v.x + self.position.x, v.y + self.position.y,0,s,s,
            image:getWidth()/2, image:getHeight()/2)
    end 
end