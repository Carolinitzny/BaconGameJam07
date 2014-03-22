local class = require "middleclass"
require "state"

MenuState = class("MenuState", State)
function MenuState:initialize()
    State.initialize(self)
end

function MenuState:update(dt)
    self:updateEntities(dt)
end

function MenuState:draw()
    self:drawWorld()
    self:drawUI()

    love.graphics.print("This is the menu. Press any key to start", 100, 100)
end

function MenuState:keypressed(key)
    currentState = states.game
end