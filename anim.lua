anim = {}

function anim:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function anim:update()
  self.t += 1
  if self.t > self.frame_length then
    self.t = 0
    self.frame += 1
    if self.frame > #self.frames then
      self.frame = 1
    end
  end
end

function anim:draw(x, y, flip_x, flip_y)
  spr(self.frames[self.frame], x, y, self.w, self.h, flip_x, flip_y)
end
