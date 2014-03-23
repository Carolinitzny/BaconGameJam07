tween = require 'tween'
highscore = require 'sick'
local class = require 'middleclass'

require "helper"
require "entity"
require "entities/plane"
require "entities/package"
require "entities/village"
require "entities/ground"
require "entities/airport"
require "entities/particles"
require "entities/target"
require "entities/text"
require "indicators"
require "minimap"

require "state"
require "states/gamestate"
require "states/menustate"
require "states/gameoverstate"

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
    images.smokeRing = love.graphics.newImage("graphics/smokeRing.png")
    images.circle = love.graphics.newImage("graphics/circle.png")
    images.crater = love.graphics.newImage("graphics/Crater.png")

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


    fonts = {}
    fonts.normal = love.graphics.newFont("Thin Skinned.ttf", 30)
    fonts.writing30 = love.graphics.newFont("TMJ.ttf", 30)
    fonts.writing50 = love.graphics.newFont("TMJ.ttf", 50)
    
    states = {}
    states.game = GameState:new()
    states.menu = MenuState:new()
    states.gameover = GameOverState:new()
    
    currentState = states.game
    
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
    if key == "escape" then
        highscore.save()
        love.event.push("quit")
    else
        currentState:keypressed(key)
    end
end

function love.textinput(char)
    currentState:textinput(char)
end

function love.mousepressed(x, y, b)
    currentState:mousepressed(x, y, b)
end

function love.touchpressed(id, x, y, p)
    x = x * love.graphics.getWidth()
    y = y * love.graphics.getHeight()
    if id ~= 0 then
        currentState:mousepressed(x, y, "l")
    end
end