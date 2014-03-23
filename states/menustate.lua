local class = require "middleclass"
require "state"

MenuState = class("MenuState", State)
function MenuState:initialize()
    State.initialize(self)
    self.fade = 0
end

function MenuState:update(dt)
    self:updateEntities(dt)
end

function MenuState:draw()
    love.graphics.setBackgroundColor(255, 255, 255)

    self:drawWorld()
    self:drawUI()

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fonts.writing50)
    local text = "Kids will starve!"
    love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, 100)

    local text = "Press Enter to try it again!"
    love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, 180)
    
    love.graphics.setFont(fonts.writing30)
    local text = "Highscores"
    love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, love.graphics.getHeight() - 200)

    local count = 3
    for i, score, name in highscore() do
        love.graphics.setColor(0, 0, 0, 200)
        love.graphics.setFont(fonts.writing30)
        local text = i .. ". " .. name
        love.graphics.print(text, love.graphics.getWidth() / 2 + (i - 0.5 - count / 2)*200 - love.graphics.getFont():getWidth(text) / 2, love.graphics.getHeight() - 120)

        love.graphics.setColor(0, 0, 0, 100)
        love.graphics.setFont(fonts.writing50)
        love.graphics.print(score, love.graphics.getWidth() / 2 + (i - 0.5 - count / 2)*200 - love.graphics.getFont():getWidth(score) / 2, love.graphics.getHeight() - 80)
    end

    love.graphics.setColor(255, 255, 255, self.fade * 255)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function MenuState:keypressed(key)
    if key == "return" then 
        tween(1, self, {fade=1}, "inOutQuad", function()
            states.game:reset()
            setState(states.game)
        end)
    end
end

function MenuState:onEnter()
    self.fade = 1
    tween(1, self, {fade=0}, "inOutQuad")
end
