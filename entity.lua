local class = require 'middleclass'
require "vector"

Entity = class ("Entity")
Entity.state = nil
function Entity:update(dt) end 
function Entity:draw() end
function Entity:onAdd(state) end
