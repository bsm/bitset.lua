local BMSPF = "[B] %-12s%-15s%dms"

function inspect(t)
  if type(t) == 'string' then return '"' .. tostring(t) .. '"' end
  if type(t) ~= 'table' then return tostring(t) end

  local s = {}
  for k,v in pairs(t) do
    if k ~= #s+1 then
      s[#s+1] = "[" .. inspect(k) .. "] = " .. inspect(v)
    else
      s[#s+1] = inspect(v)
    end
  end
  return "{ " .. table.concat(s, ", ") .. " }"
end

function benchmark(context, cycles, fun)
  local start = os.clock()
  local cycles = cycles or 1e6
  for c=1,cycles do fun(c) end
  print(BMSPF:format(context, " (" .. cycles .. "x)", (os.clock()-start) * 1000))
end

local function compare_tables(t1, t2)
  local ty1 = type(t1)
  local ty2 = type(t2)
  if ty1 ~= ty2 then return false end
  -- non-table types can be directly compared
  if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
  -- as well as tables which have the metamethod __eq
  local mt = getmetatable(t1)
  for k1,v1 in pairs(t1) do
  local v2 = t2[k1]
  if v2 == nil or not compare_tables(v1,v2) then return false end
  end
  for k2,v2 in pairs(t2) do
  local v1 = t1[k2]
  if v1 == nil or not compare_tables(v1,v2) then return false end
  end
  return true
end

-- Custom assertions.
local telescope = require 'telescope'
telescope.make_assertion("tables", function(_, a, b)
  return "Expected table to be " .. inspect(b) .. ", but was " .. inspect(a)
end, function(a, b)
  return compare_tables(a, b)
end)
