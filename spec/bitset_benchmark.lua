package.path  = './spec/?.lua;./lib/?.lua;;' .. package.path
require 'spec_helper'

local M = require 'bitset'
local a = M:new()
local b = M:new()

benchmark('set', 1e6, function(i)
  a:set(i)
end)

benchmark('get', 1e6, function(i)
  a:get(i)
end)

benchmark('clear', 1e6, function(i)
  a:clear(i)
end)

for i=1,70000 do a:set(i) end
for i=30000,100000 do b:set(i) end

benchmark('offsets', 50, function(i)
  a:offsets()
end)

benchmark('union', 300, function(i)
  a:union(b)
end)

benchmark('inter', 2000, function(i)
  a:inter(b)
end)

benchmark('diff', 200, function(i)
  a:diff(b)
end)
