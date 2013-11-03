local setmetatable = setmetatable
local bit  = require 'bit'
local band = bit.band
local bnot = bit.bnot
local bor  = bit.bor
local lshift = bit.lshift
local concat = table.concat
local floor  = math.floor

local _M  = {
  _VERSION = "0.3.0"
}
local mt = { __index = _M }
local BITCARDS = {0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,4,5,5,6,5,6,6,7,5,6,6,7,6,7,7,8}

-- Creates a new bitset
function _M.new(_)
  return setmetatable({ nums = {}, str = "" }, mt)
end

-- Apply binary OR, return a new set (union)
function _M.union(...)
  local args = {...}
  local res  = _M.new()
  local rnms = res.nums

  for i=1,#args do
    local nums = args[i].nums
    for idx=1,#nums do
      local num = nums[idx]
      rnms[idx] = bor(rnms[idx] or 0, num)
    end
  end
  return res
end

-- Apply binary AND, return a new set (intersect)
function _M.inter(...)
  local args = {...}
  local res  = _M.new()
  local rnms = res.nums
  local mini = 0

  for i=1,#args do
    local len = #args[i].nums
    if mini == 0 or mini > len then
      mini = len
    end
  end

  for i=1,#args do
    local nums = args[i].nums
    for idx=1,mini do
      local num = nums[idx] or 0
      local cur = rnms[idx] or 0xffffffff
      if cur > 0 then
        rnms[idx] = band(cur, num)
      end
    end
  end
  return res
end

-- Apply binary AND NOT, return a new set (diff)
function _M.diff(self, ...)
  local other = {...}
  local nums  = self.nums
  local res   = _M.new()
  local rnms  = res.nums

  for i=1,#other do
    local onms = other[i].nums
    for idx=1,#nums do
      rnms[idx] = band(rnms[idx] or nums[idx] or 0, bnot(onms[idx] or 0))
    end
  end
  return res
end

-- Sets bit(s) at offset(s)
function _M.set(self, ...)
  local offsets = {...}

  for i=1,#offsets do
    local offset = offsets[i]
    local idx  = floor(offset / 32) + 1
    local pos  = offset % 32
    local nums = self.nums
    local byte = lshift(1, pos)

    while #nums < idx do
      nums[#nums+1] = 0
    end
    nums[idx] = bor(nums[idx] or 0, byte)
  end

  return self
end

-- Get bit(s) at offset(s)
function _M.get(self, ...)
  local offsets = {...}
  local res = {}

  for i=1,#offsets do
    local offset = offsets[i]
    local idx  = floor(offset / 32) + 1
    local pos  = offset % 32
    local nums = self.nums
    local byte = lshift(1, pos)
    res[#res+1] = band(nums[idx] or 0, byte) ~= 0
  end

  if #offsets == 1 then return res[1] end
  return res
end

-- Clear bit(s) at offset(s)
function _M.clear(self, ...)
  local offsets = {...}

  for i=1,#offsets do
    local offset = offsets[i]
    local idx  = floor(offset / 32) + 1
    local nums = self.nums

    if #nums >= idx then
      local pos  = offset % 32
      local byte = bnot(lshift(1, pos))
      nums[idx] = band(nums[idx] or 0, byte)
    end
  end

  return self
end

-- Get all offsets
function _M.offsets(self)
  local res  = {}
  local nums = self.nums

  for idx=0,#nums-1 do
    local num = nums[idx+1]
    if num and num ~= 0 then
      for pos=0,31 do
        if band(num, lshift(1, pos)) ~= 0 then
          res[#res+1] = 32*idx + pos
        end
      end
    end
  end
  return res
end

-- Count set bits
function _M.count(self)
  local res  = 0
  local nums = self.nums

  for idx=0,#nums-1 do
    local num = nums[idx+1]
    if num < 0 then
      num = 2^32 + num
    end
    while num > 0 do
      res = res + BITCARDS[num%256+1]
      num = floor(num/256)
    end
  end
  return res
end

return _M
