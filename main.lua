local fun = require "fun"

local ship_factory = require "./ship_factory"
local Ship = require "./ship"
local speed = 100

ship_factory.x = 300
ship_factory.y = 400

local ships

local squadron = require "./squadron"
local formations = require "./formations"

function love.load()
  ships = {}
  squadron:set_formation(formations.row)
end

local next_ship = 0.5

function love.update(dt)
  if next_ship <= 0 then
    next_ship = 1
    add_squadron_ship(ships)
  else
    next_ship = next_ship - dt
  end

  squadron:update()

  fun.each(function(ship)
    ship.angle = ship:pilot(dt)
    ship.x, ship.y = Ship.update(ship, dt, speed)
  end, ships)

  fun.each(function(ship)
    ship.x, ship.y = Ship.update(ship, dt, speed)
  end, squadron.ships)
end

function love.draw()
  love.graphics.rectangle("line", ship_factory.x, ship_factory.y, ship_factory.width, ship_factory.height)
  love.graphics.print("Ship count: " .. #ships)

  fun.each(Ship.draw, ships)
  fun.each(Ship.draw, squadron.ships)
end

function love.keypressed(key)
  if key == "+" or key == "kp+" then
    add_squadron_ship()
  elseif key == "-" or key == "kp-" then
    table.remove(ships, 1)
  elseif key == "escape" then
    love.event.quit()
  end
end

function add_idle_ship()
  while #ships >= 50 do table.remove(ships, 1) end

  local ship = ship_factory:produce_ship()
  Ship.set_idle(ship)
  table.insert(ships, ship)
end

function add_squadron_ship()
  local ship = ship_factory:produce_ship()
  if squadron.leader then
    squadron:add_ship(ship)
  else
    Ship.set_idle(ship)
    ship.idle_state.radius = 130
    squadron.leader = ship
    table.insert(ships, ship)
  end
end
