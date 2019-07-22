local ship_types = {}
local utils = require "./utils"

ship_types.N = {
  text = function (id)
    return id .. " ∈ N"
  end,
  minimum_energy = 1,
  mass = 10,
  radius = 0,
  typename = 'N'
}

ship_types.Q = {
  init = function()
    return { denominator = math.random() }
  end,

  typename = 'Q',

  text = function (id)
    return id .. " ∈ N"
  end,

  minimum_energy = 1,
  mass = 10,
  radius = 0
}

ship_types.Func = {
  init = function(parameters, operator)
    return { operator = operator, parameters = parameters, cargo = {} }
  end,

  typename = 'Func',

  on_collide = function(ship, with)
    assert(#ship.conf.cargo < #ship.conf.parameters)

    local acquired = {}
    local params = {}
    for i = 1,#ship.conf.parameters do
      if ship.conf.cargo[i] == nil then
        table.insert(params, i)
      end
    end

    local flag = false

    for id,other_ship in ipairs(with) do
      assert(other_ship ~= ship, "Collides with itself")
      for i,j in ipairs(params) do
        if (not other_ship.used) and (other_ship.conf.typename == ship.conf.parameters[j]) then
          if not flag then print("NEW") end
          flag = true
          print("Acquires " .. id)
          table.insert(acquired, id)
          ship.conf.cargo[j] = other_ship
          other_ship.used = true
          table.remove(params, i)
        end
      end
    end

    assert(#ship.conf.cargo <= #ship.conf.parameters)

    local instr = { acquire = acquired }

    if #ship.conf.cargo == #ship.conf.parameters then
      assert(#acquired > 0)
      utils.merge(instr, ship.conf.operator(unpack(ship.conf.cargo)))
      ship.conf.cargo = {}
    end

    return instr
  end,
}

return ship_types
