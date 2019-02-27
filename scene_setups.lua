local ship_types = require "./ship_types"
local utils = require "./utils"

local setup = {}

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

function setup:random(count)
  for i=1,count do
    local conf
    if math.random(4) == 1 then
      conf = get_some_func_conf()
      conf.radius = math.random(20, 50)
    else
      conf = ship_types.N
    end

    self:add_ship(
      i,
      { x=math.random() * self.bounds.x, y=self.bounds.y * math.random() },
      120,
      math.random(0, 2*math.pi),
      conf)
  end
end

function setup:circle(count)
  for i=1,count do
    local angle = math.pi * 2 * i / count
    self:add_ship(
      i,
      { x = -math.cos(angle) * 150 + 340, y = -math.sin(angle) * 150 + 340 },
      200,
      angle,
      ship_types.N)
  end
end

function setup:mixed(count)
  self:add_ship(
    1,
    { x = 450, y = 300 },
    300,
    math.pi,
    get_some_func_conf())

  self:add_ship(
    2,
    { x = 150, y = 300 },
    300,
    0,
    get_some_func_conf())

  for i=3,count do
    local angle = math.pi * (i - 2) / (count - 2) - math.pi / 2
    self:add_ship(
      i,
      { x = math.cos(angle) * 250 + 340, y = math.sin(angle) * 250 + 300 },
      50,
      math.pi+angle,
      ship_types.N)
  end
end

return setup
