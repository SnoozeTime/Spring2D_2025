grid = {}

-- require {bounds, divisions}
function grid:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.resolution = {x = o.bounds.w / o.divisions, y = o.bounds.h / o.divisions}
  o.grid = {}
  return o
end

function grid:key(vec)
  local x = flr(vec.x / self.resolution.x)
  if x >= self.divisions or x < 0 then
    return nil
  end
  local y = flr(vec.y / self.resolution.y)
  if y >= self.divisions or y < 0 then
    return nil
  end
  return x + y * self.divisions
end

function grid:empty(vec)
  local key = self:key(vec)
  return key != nil and self.grid[key] == nil
end

-- Get the entity occupying the grid space that contains |vec| (if it exists)
function grid:get(vec)
  -- find grid index
  local key = self:key(vec)
  return self.grid[key]
end

function grid:insert(vec, o)
  local key = self:key(vec)
  assert(key)
  assert(self.grid[key] == nil)
  self.grid[key] = o
end
