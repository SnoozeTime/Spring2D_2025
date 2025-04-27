flower_score = {}

function flower_score:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.flowers = {}
  local flowers_width = 24 * o.total - 8
  local flowers_x = 128/2 - flowers_width/2
  for i=1,o.total do
    local r = rose:new{
      pos = {x = flowers_x, y = o.y_pos},
    }
    if o.total - o.alive >= i then
      r:wither()
    end
    add(o.flowers, r)
    flowers_x += 24
  end

  return o
end

function flower_score:update()
  for flower in all(self.flowers) do
    flower:update()
  end
end

function flower_score:draw()
  for flower in all(self.flowers) do
    flower:draw()
  end
end
