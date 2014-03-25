local class = require "middleclass"
require "state"

GameOverState = class("GameOverState", State)
function GameOverState:initialize()
    State.initialize(self)
    self.fade = 0
    self.name = ""
    self.highscore = false
end

function GameOverState:update(dt)
    self:updateEntities(dt)
end

function GameOverState:draw()
    love.graphics.setBackgroundColor(255, 255, 255)

    self:drawWorld()
    self:drawUI()

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fonts.writing50)
    local text = "GAME OVER"
    love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, 100)
    love.graphics.print("Enter your name to save your score!", love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Enter your name to save your score!") / 2, 200)


    love.graphics.print(self.name, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(self.name) / 2, 300)
    love.graphics.setColor(255, 255, 255, self.fade * 255)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function GameOverState:onEvent(type, data)
    if type == "keypressed" then
        if (data.key == "return" or data.key == "escape") and self.name then
            self:finish()
            return true
        elseif data.key == "backspace" then
            self.name = string.sub(self.name, 1, string.len(self.name)-1)
            return true
        end
    elseif type == "textinput" then
        self.name = string.upper(self.name .. data.char)
        return true
    end
end

function GameOverState:finish()
    love.keyboard.setTextInput(false)
    if not self.highscore then
        highscore.add(self.name, states.game.score)
        self.highscore = true
        tween(FADE_TIME, self, {fade=1}, "inOutQuad", function()
            setState(states.menu)
        end)
    end
end

function GameOverState:onEnter()
    self.highscore = false
    self.fade = 1
    tween(FADE_TIME, self, {fade=0}, "inOutQuad")
    self.music = love.audio.newSource("sound/theme.ogg", "stream")
    self.music:play()
    love.keyboard.setTextInput(true)
end
