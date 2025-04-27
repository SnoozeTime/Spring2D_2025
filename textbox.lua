textbox = {}

-- text
function textbox:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function textbox:update()
end

function textbox:draw(source_pos)
  local len = #self.text
  local x = source_pos.x - 4
  local y = source_pos.y - 15
  palt()
  palt(0,false)
  palt(11,true)
  spr(76, x, y, 1, 2)
  for i=4,4*len - 8,8 do
    x += 8
    spr(77, x, y, 1, 2)
  end
  x += 8
  spr(97, x, y, 1, 2)
  print(self.text, source_pos.x, source_pos.y - 11, 0)
end
