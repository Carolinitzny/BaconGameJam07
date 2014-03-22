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
    for i, score, name in highscore() do
        love.graphics.print(name, 400, i * 40)
        love.graphics.print(score, 500, i * 40)
    end
end

function MenuState:keypressed(key)
    currentState = states.game
end