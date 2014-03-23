local class = require 'middleclass'
require "entity"

Vegetation = class ("Vegetation", Entity)

function Vegetation:initialize(x, y)
    self.size = 1
    self.position = Vector:new(x, y)
    self.vegetation = {}
    local type = math.random()

    local veggies = {images.bush, images.cactus, images.bush2}
    local veggie = veggies[math.random(#veggies)]
    
    if type > 0.01 then
        self.size = 0.6
        local count = math.random(1, 5)
        for k= 1, count do

            local direc = Vector:new(math.random(0,60), 0)
            direc:rotate(k*(math.pi*2)/count)
            
            local bush = {}
            bush.pos = direc
            bush.image = veggie 
            table.insert(self.vegetation, bush)
        end
    else
        self.size = 0.6   
        local oasis = {}
        oasis.pos = Vector:new(0, 0)
        oasis.image = images.oasis
        table.insert(self.vegetation, oasis) 
    end
end        
function Vegetation:draw()
    for k, v in pairs(self.vegetation) do
        love.graphics.draw(v.image,v.pos.x + self.position.x, v.pos.y + self.position.y,0, self.size, self.size, v.image:getWidth() / 2, v.image:getHeight() / 2)
    end
end
