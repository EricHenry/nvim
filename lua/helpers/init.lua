local M = {}

M.map = function (tbl, f)
  local initial = {}
  local transform = function (current, accumilator)
    local new = f(current)
    table.insert(accumilator, new)
    return accumilator
  end

  return M.reduce(tbl, initial, transform)
end

M.filter = function(tbl, f)
  local initial = {}
  local predicate = function (current, accumilator)
    if f(current) then
      table.insert(accumilator, current)
    end
    return accumilator
  end

  return M.reduce(tbl, initial, predicate)
end

M.reduce = function(tbl, initial, f)
  local accumilator = initial
  for _,v in pairs(tbl) do
    accumilator = f(v, accumilator)
  end
  return accumilator
end

return M
