local fun = require "fun"

local ship_factory = require "./ship_factory"
local Ship = require "./ship"
local speed = 100

local ship_leader

local squadron = require "./squadron"
local formations = require "./formations"

function love.load()
  squadron:set_formation(formations.row)
end

local next_ship = 0.5

function love.update(dt)
  if next_ship <= 0 then
    next_ship = 1
    add_squadron_ship()
  else
    next_ship = next_ship - dt
  end

  squadron:update()

  if ship_leader then
    ship_leader.angle = ship_leader:pilot(dt)
    ship_leader.x, ship_leader.y = Ship.update(ship_leader, dt, speed)
  end

  fun.each(function(ship)
    ship.x, ship.y = Ship.update(ship, dt, speed)
  end, squadron.ships)
end

function love.draw()
  ship_factory:draw()

  if ship_leader then
    Ship.draw(ship_leader)
  end
  fun.each(Ship.draw, squadron.ships)
end

function love.keypressed(key)
  if key == "+" or key == "kp+" then
    add_squadron_ship()
  elseif key == "-" or key == "kp-" then
    squadron.remove_ship()
  elseif key == "escape" then
    love.event.quit()
  end
end

function add_squadron_ship()
  local ship = ship_factory:produce_ship()
  if squadron.leader then
    squadron:add_ship(ship)
  else
    ship_leader = ship
    squadron.leader = ship
    Ship.set_idle(ship, 130)
  end
end
