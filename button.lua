local class = require("middleclass")

Button = class("Button", Entity)
function Button:initialize(text, pos, size)
    Entity.initialize(self)
    self.text = text
    self.font = fonts.normal
    self.textColor = {0, 0, 0}
    self.backgroundColor = {1, 1, 1, 0.8}
    self.position = pos
    self.size = size or Vector(100, 30)
    self.z = 1000
    self.active = true
    self.tolerance = 1

    self.onTouchPressed = nil
    self.onTouchReleased = nil
    self.touchedDownId = -1
    self.touchedDown = false
end

function Button:isInside(p)
    return p.x >= self.position.x - self.size.x / 2 * self.tolerance and
        p.x <= self.position.x + self.size.x / 2 * self.tolerance and
        p.y >= self.position.y - self.size.y / 2 * self.tolerance and
        p.y <= self.position.y + self.size.y / 2 * self.tolerance
end

function Button:draw()
    local c = self.touchedDown and {1, 1, 1, 1} or
        self.active and self.backgroundColor or
        {0.5, 0.5, 0.5}
    love.graphics.setColor(unpack(c))
    -- love.graphics.rectangle("fill", self.position.x - self.size.x / 2, self.position.y - self.size.y / 2, self.size.x, self.size.y)
    local img = images.button
    local w, h = img:getWidth(), img:getHeight()
    love.graphics.draw(images.button, self.position.x, self.position.y, 0, self.size.x / w, self.size.y / h, w / 2, h / 2)

    love.graphics.setFont(self.font)
    love.graphics.setColor(unpack(self.textColor))
    love.graphics.print(self.text, self.position.x - self.font:getWidth(self.text) / 2, self.position.y - self.font:getHeight() / 2)
end

function Button:onEvent(type, data)
    if type == "touchpressed" or type == "mousepressed" then
        if(self:isInside(Vector:new(data.x, data.y))) then
            self:handleTouchPressed(data)
            self.touchedDownId = data.id
            self.touchedDown = true
            return true
        end
    elseif type == "touchreleased" or type == "mousereleased" then
        if data.id == self.touchedDownId then
            if self:isInside(Vector:new(data.x, data.y)) then
                self:handleTouchReleased(data)
            end
            self.touchedDownId = -1
            self.touchedDown = false
            return true
        end
    elseif type == "touchmoved" then
        if data.id == self.touchedDownId then
            self.touchedDown = self:isInside(Vector:new(data.x, data.y))
            return true
        end
    end
end

function Button:handleTouchPressed(data)
    if self.active and self.onTouchPressed then self:onTouchPressed(data) end
end

function Button:handleTouchReleased(data)
    if self.active and self.onTouchReleased then self:onTouchReleased(data) end
end
