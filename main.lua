local space = require "./vspace"
local ship_types = require "./ship_types"
local utils = require "./utils"

local function get_some_func_conf()
  local conf = ship_types.Func.init({'N', 'N'},
    function(a,b)
      return {
        deploy = {
          { typename = 'N', id = a.id + b.id }
        },
        acquire = { 1, 2 }
      }
    end)

  conf.radius = 80
  conf.speed = 50
  utils.merge(conf, ship_types.Func)
  return conf
end

local function load_random(count)
  for i=1,count do
    local conf
    if math.random(4) == 1 then
      conf = get_some_func_conf()
      conf.radius = math.random(20, 50)
    else
      conf = ship_types.N
    end

    space:add_ship(
      i,
      { x=math.random() * space.bounds.x, y=space.bounds.y * math.random() },
      120,
      math.random(0, 2*math.pi),
      conf)
  end
end

local function load_in_circle(count)
  for i=1,count do
    local angle = math.pi * 2 * i / count
    space:add_ship(
      i,
      { x = -math.cos(angle) * 150 + 340, y = -math.sin(angle) * 150 + 340 },
      200,
      angle,
      ship_types.N)
  end
end

function love.load(arg)
  local count = (arg[1] or 7)
  if arg[2] then load_in_circle(count) else load_random(count) end
end

local next_ship = 0.5
function love.update(dt)
  if next_ship <= 0 then
    next_ship = 0.2
  else
    next_ship = next_ship - dt
  end

  space:update(dt)
end

function love.draw()
  space:draw()
end

function love.keypressed(key)
  if key == "-" or key == "kp-" then
    space:remove_ship()
  elseif key == "escape" then
    love.event.quit()
  end
end

