tween = require 'tween'
local class = require 'middleclass'
require "entity"
require "entities/plane"
require "entities/package"
require "entities/village"
require "entities/ground"
require "entities/airport"
require "entities/particles"
require "entities/target"
require "indicators"

require "state"
require "states/gamestate"
require "states/menustate"

function love.load()
    time = 0
    math.randomseed(os.time())

    images = {}
    images.plane = love.graphics.newImage("graphics/Plane.png")
    images.package = love.graphics.newImage("graphics/Package.png")
    images.houses = {}
    images.houses[1] = love.graphics.newImage("graphics/House1.png")
    images.houses[2] = love.graphics.newImage("graphics/House3.png")
    images.church = love.graphics.newImage("graphics/House2.png")
    images.ground = love.graphics.newImage("graphics/background.png")
    images.airport = love.graphics.newImage("graphics/runway.png")
    images.gauge = love.graphics.newImage("graphics/Gauge.png")
    images.needle = love.graphics.newImage("graphics/Needle.png")
    images.smoke = love.graphics.newImage("graphics/smoke.png")
    images.smokeRing = love.graphics.newImage("graphics/smokeRing.png")

    states = {}
    states.game = GameState:new()
    states.menu = MenuState:new()

    currentState = states.game
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
        love.event.push("quit")
    else
        currentState:keypressed(key)
    end
end