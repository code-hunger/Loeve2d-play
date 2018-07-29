local fun = require "fun"

local ship_factory = require "./ship_factory"
local pilots = require "./pilots"
local speed = 100

ship_factory.x = 300
ship_factory.y = 400

local ships

function love.load()
  ships = {}
end

local next_ship = 0.5

local set_idle_ship, add_idle_ship, update_idle_ship, draw_ship

function love.update(dt)
  if next_ship <= 0 then
    next_ship = 1
    add_idle_ship(ships)
  else
    next_ship = next_ship - dt
  end

  fun.each(function(ship)
    ship.x, ship.y = update_ship(ship, dt)
  end, ships)
end

function love.draw()
  love.graphics.rectangle("line", ship_factory.x, ship_factory.y, ship_factory.width, ship_factory.height)
  love.graphics.print("Ship count: " .. #ships)

  fun.each(draw_ship, ships)
end

function love.keypressed(key)
  if key == "+" or key == "kp+" then
    add_idle_ship(ships)
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
    local t = ship.idle_state.target
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", c.x, c.y, ship.idle_state.radius)
    love.graphics.circle("fill", t.x, t.y, 5)
    love.graphics.line(ship.x, ship.y, t.x, t.y)
  end
end

function update_ship(ship, t)
  local angle = ship:pilot(t)
  return ship.x - t * speed * math.cos(angle),
         ship.y - t * speed * math.sin(angle)
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
  ship.update = update_idle_ship
end

function add_idle_ship()
  if #ships >= 50 then table.remove(ships, 1) end
  local ship = ship_factory:produce_ship()
  set_idle_ship(ship)
  table.insert(ships, ship)
end
