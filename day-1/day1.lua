-- You need luarocks for that -> luarocks install set
require("luarocks.loader")
local Set = require("Set")

local toFind = 2020

function part1(numbers)
  local cache = Set:new()

  for i,n in ipairs(numbers) do
    local diff = toFind - n
    if cache[diff] then
      return n * diff
    end

    cache:add(n)
  end

  return 0
end

function part2(numbers)
  if #numbers < 3 then return 0 end

  -- I assume this is a hashmap?
  local cache = {}
  cache[numbers[1] + numbers[2]] = {numbers[1], numbers[2]}

  for i=3,#numbers do
    local diff = toFind - numbers[i]
    local hit = cache[diff]
    if hit then
      return numbers[i] * hit[1] * hit[2]
    end

    -- Not optimal but eh... not too much time either for Advent of code...
    for j=1,i do
      cache[numbers[i] + numbers[j]] = {numbers[i], numbers[j]}
    end
  end 

  return 0
end


local numbers = {}
for line in io.lines() do
  numbers[#numbers + 1] = tonumber(line)
end

print(string.format("Part 1: %d", part1(numbers)))
print(string.format("Part 2: %d", part2(numbers)))