local class = require 'middleclass'
require "entity"

Minimap = class("Minimap", Entity)

function Minimap:update(dt)
    local s = love.graphics.getHeight() / 3.5
    self.size = Vector:new(s, s)
    self.position = Vector:new(s * 0.6, s * 0.6)
    self.zoom = self.size.x/love.graphics.getWidth() * 0.33
end

function Minimap:draw()
    love.graphics.setScissor(self.position.x - self.size.x / 2, self.position.y - self.size.y / 2, self.size.x, self.size.y)

    local plane = self.state.plane

    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", self.position.x - self.size.x / 2, self.position.y - self.size.y / 2, self.size.x, self.size.y)

    love.graphics.setLineStyle("smooth")

    for k,v in pairs(self.state.world) do
        if v:isInstanceOf(Target) or v:isInstanceOf(Airport) then
            local diff = v.position - plane.position
            local pos = self.position + diff * self.zoom

            love.graphics.push()
            love.graphics.translate(pos.x, pos.y)
            love.graphics.rotate(v.orientation or 0)
            if v:isInstanceOf(Target) then
                love.graphics.setColor(1, 1, 1)
                local r = 0.03
                if v.village.count > 5 then
                    love.graphics.draw(images.circle,  0, -2, 0, r, r)
                    love.graphics.draw(images.circle,  2,  1, 0, r, r)
                    love.graphics.draw(images.circle, -2,  1, 0, r, r)
                else
                    love.graphics.draw(images.circle,  0,  0, 0, r, r)
                end
            elseif v:isInstanceOf(Airport) then
                love.graphics.setColor(1, 1, 1, 0.4)
                love.graphics.rectangle("fill", -2, -12, 4, 12)
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("fill", -2, 0, 4, 2)
            end
            love.graphics.pop()
        end
    end

    love.graphics.setColor(1, 1, 0)
    local p1 = self.position + Vector:new( 0, -7):rotated(plane.direction)
    local p2 = self.position + Vector:new( 5,  5):rotated(plane.direction)
    local p3 = self.position + Vector:new( 0,  2):rotated(plane.direction)
    local p4 = self.position + Vector:new(-5,  5):rotated(plane.direction)
    love.graphics.polygon("fill", p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y)

    love.graphics.setColor(1, 1, 1)
    local img = images.minimapFrame
    local w, h = img:getWidth(), img:getHeight()
    love.graphics.draw(images.minimapFrame, self.position.x, self.position.y, 0, self.size.x / w, self.size.y / h, w / 2, h / 2)

    love.graphics.setScissor()

    love.graphics.setColor(1, 1, 1)
    local img = images.windsock
    local angle = self.state:getWindVector(1):angleTo(Vector:new(-1, 0)) + math.sin(self.state.windSwing*5) * 0.1
    local s = self.size.x / 160
    love.graphics.draw(img, self.position.x, self.position.y + self.size.y, angle, s, s * (0.5 + 0.5 * self.state.windFactor), img:getWidth()/2, img:getHeight())
end
