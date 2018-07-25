require "fun"()

local ship_factory = require "./ship_factory"

function love.load()
  ships = {}
end

function love.update(dt)
  each(function (ship)
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
    ship = ship_factory:produce_ship()
    ship.update = update_ship
    table.insert(ships, ship)
  elseif key == "-" or key == "kp-" then
    table.remove(ships, 1)
  end
end

function draw_ship(ship)
  love.graphics.circle("line", ship.x, ship.y, 10)
end

function update_ship(ship, t)
  ship.x = ship.x + t * 50 * math.cos(ship.angle)
  ship.y = ship.y + t * 50 * math.sin(ship.angle)
end
