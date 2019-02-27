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

    for id,other_ship in ipairs(with) do
      for _,j in ipairs(params) do
        if (not other_ship.used) and (other_ship.conf.typename == ship.conf.parameters[j]) then
          table.insert(acquired, id)
          ship.conf.cargo[j] = other_ship
          other_ship.used = true
        end
      end
    end

    assert(#ship.conf.cargo <= #ship.conf.parameters)

    local instr = {  acquire = acquired }

    if #ship.conf.cargo == #ship.conf.parameters then
      assert(#acquired > 0)
      print("COLLECTED!! OPERATOR" .. #ship.conf.cargo)
      utils.merge(instr, ship.conf.operator(unpack(ship.conf.cargo)))
      ship.conf.cargo = {}
    end

    return instr
  end,
}

return ship_types
