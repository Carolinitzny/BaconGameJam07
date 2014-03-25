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
    self.musicVolume = 1

    if MOBILE then
        self.playButton = Button("Play", Vector:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2), Vector:new(306, 80))
        self.playButton.font = fonts.writing30
        self.playButton.onTouchReleased = function() self:finish() end
        self:add(self.playButton, true)

        self.muteButton = Button("Toggle sound", self.playButton.position + Vector:new(0, 100), Vector:new(306, 80))
        self.muteButton.font = fonts.writing30
        self.muteButton.onTouchReleased = toggleMute
        self:add(self.muteButton, true)
    end
end

function TitleState:update(dt)
    self.musicCountdown = self.musicCountdown - dt
    if self.musicCountdown < 0 then
        self.music = love.audio.newSource("sound/theme.ogg", "stream")
        self.music:play()
        self.musicCountdown = 30
    end
    self.music:setVolume(self.musicVolume)
    self.plane.sound:setVolume(self.musicVolume)

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

    local text = "The Hunger Planes"
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fonts.title)
    love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, 100)

    if not MOBILE then
        love.graphics.setColor(0, 0, 0, 100 + 50 * math.abs(math.sin(time * 5)))
        text = "Press space to start (M for mute)"
        love.graphics.setFont(fonts.writing30)
        love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, 200)
    end

    love.graphics.setColor(0, 0, 0, 50)
    text = "Created by Carolinitzny, julia.hertel, opatut and trojan4"
    love.graphics.setFont(fonts.writing30)
    love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, love.graphics.getHeight() - 100)

    text = "for BaconGameJam 07 -- Theme: hungry"
    love.graphics.print(text, love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth(text) / 2, love.graphics.getHeight() - 60)

    love.graphics.setColor(255, 255, 255, 255 * self.fade)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function TitleState:onEvent(type, data)
    if (type == "keypressed" and data.key == " ") then
        self:finish()
        return true
    elseif (type == "keypressed" and data.key == "escape") then
        tween(1, self, {fade=1}, "inOutQuad", function()
            highscore.save()
            love.event.push("quit")
        end)
        return true
    end
end

function TitleState:finish()
    tween(FADE_TIME, self, {fade=1, musicVolume=0}, "inOutQuad", function()
        self.music:stop()
        self.plane.sound:stop()
        states.game:reset()
        setState(states.game)
    end)
end

function TitleState:onEnter()
    tween(FADE_TIME, self, {fade=0, musicVolume=1}, "inOutQuad")
end
