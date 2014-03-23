local class = require "middleclass"
require "state"

GameOverState = class("GameOverState", State)
function GameOverState:initialize()
    State.initialize(self)
    self.fade = 0
    self.name = ""
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
    love.graphics.print("Enter your name!", love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Enter your name!") / 2, 200)


    love.graphics.print(self.name, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(self.name) / 2, 300)
    love.graphics.setColor(255, 255, 255, self.fade * 255)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
end

function GameOverState:keypressed(key)
    if key == "return" and self.name then
        highscore.add(self.name, states.game.score)
        tween(1, self, {fade=1}, "inOutQuad", function()
            plane.speed = 1
            plane.direction = 0
            plane.directionChange = 0
            plane.rotationspeed = 0.9
            plane.fuel = 1
            plane.fuelconsumption = 1
            plane.quantity = 9
            plane.altitude = 1
            plane.landing = false
            plane.isChrashing = false
            plane.crashed = false
            plane.size = 1
            setState(states.menu)
        end)
    end
    if key == "backspace" then
        self.name = string.sub(self.name, 1, string.len(self.name)-1)
    end
end

function GameOverState:textinput(char)
    self.name = self.name .. char
end

function GameOverState:onEnter()
    self.fade = 1
    tween(1, self, {fade=0}, "inOutQuad")
end
