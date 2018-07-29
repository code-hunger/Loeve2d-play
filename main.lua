local fun = require "fun"

local ship_factory = require "./ship_factory"
local pilots = require "./pilots"
local speed = 100

ship_factory.x = 300
ship_factory.y = 400

local ships

local squadron = require "./squadron"

function sine_formation(ships, i, leader)
  return leader.x + 30 * i , leader.y+ 30 * math.sin(i * math . pi / 5)
end

function row_formation(ships, i, leader)
  return leader.x + i * 30, leader.y
end

function circle_formation(radius, arc, ships, i, leader)
  local angle = i / #ships * arc + (math.pi * 2 - arc) /2
  return leader.x + math.sin(angle) * radius, leader.y + math.cos(angle) * radius
end

function love.load()
  ships = {}
  squadron:set_formation(function (ships, i, leader)
    return circle_formation(150, 1 * math.pi, ships, i, leader)
  end)
end

local next_ship = 0.5

local set_idle_ship, add_idle_ship, update_idle_ship, draw_ship

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
    ship.x, ship.y = update_ship(ship, dt)
  end, ships)

  fun.each(function(ship)
    ship.x, ship.y = update_ship(ship, dt)
  end, squadron.ships)
end

function love.draw()
  love.graphics.rectangle("line", ship_factory.x, ship_factory.y, ship_factory.width, ship_factory.height)
  love.graphics.print("Ship count: " .. #ships)

  fun.each(draw_ship, ships)
  fun.each(draw_ship, squadron.ships)
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

function draw_ship(ship)
  love.graphics.setColor(0.9, 0.2, 0.2)
  love.graphics.setLineWidth(4)
  love.graphics.circle("line", ship.x, ship.y, 10)
  if ship.idle_state then
    local c = ship.idle_state.center
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", c.x, c.y, ship.idle_state.radius)
  end

  if ship.target then
    local t = ship.target
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", t.x, t.y, 5)
    love.graphics.line(ship.x, ship.y, t.x, t.y)
  end
end

function update_ship(ship, t)
  assert(ship.angle, "Angle is nil")
  return ship.x - t * speed * math.cos(ship.angle),
    ship.y - t * speed * math.sin(ship.angle)
end

function set_idle_ship(ship)
  local radius = math.floor(math.random() * 15) * 20 + 30
  ship.idle_state = {
    radius = radius;
    center = {
      x = 300;
      y = 300;
    }
  }
  ship.pilot = pilots.idle
end

function add_idle_ship()
  while #ships >= 50 do table.remove(ships, 1) end

  local ship = ship_factory:produce_ship()
  set_idle_ship(ship)
  table.insert(ships, ship)
end

function add_squadron_ship()
  local ship = ship_factory:produce_ship()
  if squadron.leader then
    squadron:add_ship(ship)
  else
    set_idle_ship(ship)
    ship.idle_state.radius = 30
    squadron.leader = ship
    table.insert(ships, ship)
  end
end
