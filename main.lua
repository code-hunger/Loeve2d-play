require "fun"()

local ship_factory = require "./ship_factory"
local pilots = require "./pilots"
local speed = 100

ship_factory.x = 300
ship_factory.y = 400

function love.load()
  ships = {}
end

local next_ship = 0.5

function love.update(dt)
  if next_ship <= 0 then
    next_ship = 1
    add_idle_ship(ships)
  else
    next_ship = next_ship - dt
  end

  each(function(ship)
    ship:update(dt)
  end, ships)
end

function love.draw()
  love.graphics.rectangle("line", ship_factory.x, ship_factory.y, ship_factory.width, ship_factory.height)
  love.graphics.print("Ship count: " .. #ships)

  each(draw_ship, ships)
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
  love.graphics.circle("line", ship.x, ship.y, 10)
  if ship.idle_state then
    c = ship.idle_state.center
    t = ship.idle_state.target
    love.graphics.circle("line", c.x, c.y, ship.idle_state.radius)
    love.graphics.circle("fill", t.x, t.y, 5)
  end
end

function update_idle_ship(ship, t)
  local angle = pilots.idle(ship.x, ship.y, ship.idle_state, t)

  ship.x = ship.x - t * speed * math.cos(angle)
  ship.y = ship.y - t * speed * math.sin(angle)
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

function add_idle_ship(ships)
  if #ships >= 50 then table.remove(ships, 1) end
  ship = ship_factory:produce_ship()
  set_idle_ship(ship)
  table.insert(ships, ship)
end
