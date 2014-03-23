local class = require 'middleclass'
require "entity"

Vegetation = class ("Vegetation", Entity)

function Vegetation:initialize(x, y)
    self.position = Vector:new(x, y)
    self.vegetation = {}
    local type = math.random()
    
    if type > 0.2 then
        local count = math.random(1, 5)
        for k= 1, count do

            local direc = Vector:new(math.random(0,60), 0)
            direc:rotate(k*(math.pi*2)/count)
            
            local bush = {}
            bush.pos = direc
            table.insert(self.vegetation, bush)
            bush.image = images.bush 
        end
    else
            
        local oasis = {}
        oasis.pos = Vector:new(0, 0)
        table.insert(self.vegetation, oasis) 
        oasis.image = images.oasis
    end
end        
function Vegetation:draw()
    for k, v in pairs(self.vegetation) do
        love.graphics.draw(v.image,v.pos.x + self.position.x, v.pos.y + self.position.y,0, 0.2, 0.2, v.image:getWidth() / 2, v.image:getHeight() / 2)
        
    end
end
