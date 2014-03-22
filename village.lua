local class = require 'middleclass'

require "entity"
Village = class ("Village", Entity)
function Village:initialize(x,y)
    self.position = Vector:new(x,y) 
    self.count = math.random(7)
    self.houses = {}
    for k = 1, self.count do
        local house = {}
        house.imagenumber = math.random(#images.houses)
        house.x = math.random(-50, 50)
        house.y = math.random(-50, 50)
        table.insert(self.houses,house)
        
            

    end    


end

function Village:draw()
    for k, v in pairs(self.houses) do
        local s = 0.3
        local image =images.houses[v.imagenumber]
        love.graphics.draw(image,v.x + self.position.x, v.y + self.position.y,0,s,s,
            image:getWidth()/2, image:getHeight()/2)
    end 
end