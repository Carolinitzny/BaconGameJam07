local class = require "middleclass"
require "state"

TitleState = class("TitleState", State)
function TitleState:initialize()
    State.initialize(self)
    self.fade = 0

    self.plane = Plane:new(love.graphics.getWidth() / 2, love.graphics.getHeight(), true)
    self.ground = Ground:new()

    self:add(self.plane)
    self:add(self.ground)

    self.musicCountdown = 0
end

function TitleState:update(dt)
    self.musicCountdown = self.musicCountdown - dt
    if self.musicCountdown < 0 then
        self.music = love.audio.newSource("sound/theme.ogg", "stream")
        self.music:play()
        self.musicCountdown = 30
    end

    self:updateEntities(dt)
    if time > 1 then
        -- self.plane.direction = love.math.noise(time * 0.2) * math.min(1, time-1) * math.pi * 2
        self.plane.directionChange = (love.math.noise(time) - 0.5) * 10 -- * math.min(1, time-1) * math.pi * 2 - math.pi

        local b, w, h = 50, love.graphics.getWidth(), love.graphics.getHeight()
        if self.plane.position.x < - b then self.plane.position.x = w + b end
        if self.plane.position.x > w + b then self.plane.position.x = - b end
        if self.plane.position.y < - b then self.plane.position.y = h + b end
        if self.plane.position.y > h + b then self.plane.position.y = - b end
    end
end

function TitleState:draw()
    love.graphics.setColor(255, 255, 255)
    self:drawWorld()
    self:drawUI()

    local text = "Game Title Here"
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fonts.title)
    love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, 100)

    text = "Press any key to start"
    love.graphics.setFont(fonts.writing30)
    love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, 200)

    love.graphics.setColor(255, 255, 255, 255 * self.fade)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function TitleState:keypressed(key)
    tween(0.2, self, {fade=1}, "inOutQuad", function()
        self.plane.sound:stop()
        states.game:reset()
        setState(states.game)
    end)
end
