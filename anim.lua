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
    if self.frame < #self.frames then
      self.t = 0
      self.frame += 1
    elseif self.loop then
      self.t = 0
      self.frame = 1
    end
  end
end

function anim:done()
  return not self.loop and self.frame >= #self.frames and self.t > self.frame_length
end

function anim:draw(x, y, flip_x, flip_y)
  palt()
  palt(0, false)
  palt(self.trans_color, true)
  spr(self.frames[self.frame], x, y, self.w, self.h, flip_x, flip_y)
end
