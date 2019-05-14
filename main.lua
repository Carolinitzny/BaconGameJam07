DEBUG = false
FADE_TIME = 0.5

tween = require 'tween'
highscore = require 'sick'
local class = require 'middleclass'

require "helper"
require "entity"
require "entities/plane"
require "entities/package"
require "entities/village"
require "entities/vegetation"
require "entities/ground"
require "entities/airport"
require "entities/particles"
require "entities/target"
require "entities/text"
require "entities/clouds"
require "entities/tornado"
require "indicators"
require "minimap"
require "button"

require "state"
require "states/gamestate"
require "states/menustate"
require "states/gameoverstate"
require "states/titlestate"

function setState(state)
    currentState = state
    state:onEnter()
end

function love.load()
    time = 0
    math.randomseed(os.time())
    if love.window.getPixelScale then
        PIXELSCALE = love.window.getPixelScale()
    else
        PIXELSCALE = 1
    end

    MOBILE = love.system.getOS() == "Android"

    if DEBUG then
        love.audio.setVolume(0)
    end

    images = {}
    images.plane = love.graphics.newImage("graphics/Plane.png")
    images.package = love.graphics.newImage("graphics/Package.png")
    images.houses = {}
    images.houses[1] = love.graphics.newImage("graphics/House1.png")
    images.houses[2] = love.graphics.newImage("graphics/House3.png")
    images.church = love.graphics.newImage("graphics/House2.png")
    images.ground = love.graphics.newImage("graphics/background.png")
    images.airport = love.graphics.newImage("graphics/Airport.png")
    images.gauge = love.graphics.newImage("graphics/Gauge.png")
    images.needle = love.graphics.newImage("graphics/Needle.png")
    images.smoke = love.graphics.newImage("graphics/smoke.png")
    images.smoke2 = love.graphics.newImage("graphics/smoke2.png")
    images.smokeRing = love.graphics.newImage("graphics/smokeRing.png")
    images.circle = love.graphics.newImage("graphics/circle.png")
    images.crater = love.graphics.newImage("graphics/Crater.png")
    images.oasis = love.graphics.newImage("graphics/Oasis.png")
    images.bush = love.graphics.newImage("graphics/Bush.png")
    images.bush2 = love.graphics.newImage("graphics/bush2.png")
    images.cactus = love.graphics.newImage("graphics/cactus.png")
    images.clouds = love.graphics.newImage("graphics/clouds.png")
    images.windsock = love.graphics.newImage("graphics/windsock.png")
    images.minimapFrame = love.graphics.newImage("graphics/minimap-frame.png")
    images.arrow = love.graphics.newImage("graphics/arrow.png")
    images.button = love.graphics.newImage("graphics/button.png")
    images.tornado = love.graphics.newImage("graphics/tornado.png")
    images.target = love.graphics.newImage("graphics/target.png")


    sounds = {}
    sounds.landing = love.sound.newSoundData("sound/landing.ogg")
    sounds.liftoff = love.sound.newSoundData("sound/liftoff.ogg")
    sounds.kill = love.sound.newSoundData("sound/death.ogg")
    sounds.crashing = love.sound.newSoundData("sound/crash.ogg")
    sounds.hit = love.sound.newSoundData("sound/hit.ogg")
    sounds.flight = love.sound.newSoundData("sound/normal_flight.ogg")
    sounds.stutter_flight = love.sound.newSoundData("sound/stutter_flight.ogg")
    sounds.drop = love.sound.newSoundData("sound/drop.ogg")
    sounds.refuel = love.sound.newSoundData("sound/refuel.ogg")
    sounds.plop = love.sound.newSoundData("sound/plop.ogg")
    sounds.theme = love.sound.newSoundData("sound/theme.ogg")
    sounds.tornado = love.sound.newSoundData("sound/tornado.ogg")


    fonts = {}
    fonts.normal = love.graphics.newFont("Thin Skinned.ttf", 30+15*(PIXELSCALE - 1))
    fonts.writing30 = love.graphics.newFont("TMJ.ttf", 30+15*(PIXELSCALE - 1))
    fonts.writing50 = love.graphics.newFont("TMJ.ttf", 50+25*(PIXELSCALE - 1))
    fonts.title = love.graphics.newFont("TMJ.ttf", 80+40*(PIXELSCALE - 1))

    states = {}
    states.game = GameState:new()
    states.menu = MenuState:new()
    states.gameover = GameOverState:new()
    states.title = TitleState:new()

    currentState = states.title

    highscore.set("highscore", 3, "nobody", 0)
end

function love.update(dt)
    time = time + dt
    tween.update(dt)

    currentState:update(dt)
end

function love.draw()
    currentState:draw()
end

function love.keypressed(key)
    if currentState:sendEvent("keypressed", {key=key}) then return end

    if key == "escape" then
        highscore.save()
        love.event.push("quit")
    elseif key == "m" then
        toggleMute()
    end
end

function love.keyreleased(key)
    currentState:sendEvent("keyreleased", {key=key})
end

function love.textinput(char)
    currentState:sendEvent("textinput", {char=char})
end

function love.mousereleased(x, y, b)
    currentState:sendEvent("mousereleased", {x=x, y=y, b=b})
end

function love.mousepressed(x, y, b)
    currentState:sendEvent("mousepressed", {x=x, y=y, b=b})
end

function love.touchpressed(id, x, y, p)
    currentState:sendEvent("touchpressed", {id=id, x=x*love.graphics.getWidth(), y=y*love.graphics.getHeight(), p=p})
end

function love.touchreleased(id, x, y, p)
    currentState:sendEvent("touchreleased", {id=id, x=x*love.graphics.getWidth(), y=y*love.graphics.getHeight(), p=p})
end

function love.touchmoved(id, x, y, p)
    currentState:sendEvent("touchmoved", {id=id, x=x*love.graphics.getWidth(), y=y*love.graphics.getHeight(), p=p})
end
