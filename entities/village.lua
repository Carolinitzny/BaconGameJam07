local class = require 'middleclass'
require "entity"

Village = class ("Village", Entity)
Village.z = 2
function Village:initialize(x,y)
    self.position = Vector:new(x,y)
    self.count = math.random(3, 10)
    self.people = 0
    self.houses = {}
    for k = 1, self.count do
        local house = {}
        local direc = Vector:new(math.random(45, 70), 0)
        direc:rotate(k*(math.pi*2)/self.count)
        house.image = images.houses[math.random(#images.houses)]
        house.x = direc.x
        house.y = direc.y
        house.people = math.random(4, 8)
        table.insert(self.houses, house)
        self.people = self.people + house.people
    end
    if math.random()< 0.33 then
        local church = {}
        church.image = images.church
        church.x = 0
        church.y = 10
        table.insert(self.houses, church)
    end

    table.sort(self.houses, function(a, b) return a.y < b.y end)
end

function Village:draw()
    local image = images.smoke
    love.graphics.setColor(0.8, 0.3, 0, 0.5)
    love.graphics.draw(image, self.position.x, self.position.y, 0, 2, 2, image:getWidth() / 2, image:getHeight() / 2)
    love.graphics.setColor(1, 1, 1)

    for k, v in pairs(self.houses) do
        local s = 0.6
        local image =v.image
        love.graphics.draw(image,v.x + self.position.x, v.y + self.position.y,0,s,s,
            image:getWidth()/2, image:getHeight()/2)
    end
end
