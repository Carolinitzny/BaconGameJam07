local class = require 'middleclass'

require "entity"
Village = class ("Village", Entity)
function Village:initialize(x,y)
    self.position = Vector:new(x,y) 
    self.count = math.random(5)
    self.houses = {}
    for k = 1, self.count do
        local house = {}
        house.imagenumber = math.random(#images.houses)
        house.x = math.random(-100, 100)
        house.y = math.random(-100, 100)
        table.insert(self.houses,house)
        
            

    end    


end

function Village:draw()
    for k, v in pairs(self.houses) do
        love.graphics.draw(images.houses[v.imagenumber],v.x + self.position.x, v.y + self.position.y)
    end 
end